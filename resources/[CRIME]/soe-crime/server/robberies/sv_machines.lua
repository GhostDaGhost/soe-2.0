local cooldownTime = 1800000 -- APPROX 30 MINUTES
local robbedVendingMachines = {} -- LIST OF VENDING MACHINES THAT WERE HIT
local secretPassword = "bluePigeonSmile" -- SECRET PASSWORD TO USE THE HTTP HANDLER

-- ***********************
--      HTTP Handlers
-- ***********************
-- WHEN TRIGGERED, DO THE FOLLOWING
SetHttpHandler(function(req, res)
    -- MANUALLY RESET LIST OF ROBBED VENDING MACHINES
    if (req.path == "/resetmachines/" .. secretPassword) then
        robbedVendingMachines = {}

        res.send("ALL VENDING MACHINE COOLDOWNS LIFTED")
        exports["soe-logging"]:ServerLog("Vending Machines - Cooldowns", "ALL VENDING MACHINE COOLDOWNS LIFTED THROUGH HTTP HANDLER")
    end
end)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, SET A VENDING MACHINE'S STATUS
AddEventHandler("Crime:Server:SetMachineStatus", function(cb, src, machineCoords)
    cb(true)
    robbedVendingMachines[#robbedVendingMachines + 1] = {["coords"] = machineCoords, ["time"] = GetGameTimer(), ["robbed"] = true}

    local pos = GetEntityCoords(GetPlayerPed(src))
    exports["soe-logging"]:ServerLog("Vending Machine - Robbery", "IS ROBBING A VENDING MACHINE | COORDS: " .. pos, src)
end)

-- WHEN TRIGGERED, CHECK IF VENDING MACHINES PASSED THEIR COOLDOWN
AddEventHandler("Crime:Server:MachineStatusCooldownCheck", function()
    for machineIdx, machine in pairs(robbedVendingMachines) do
        local gameTimeNow = GetGameTimer()
        local gameTimeDifference = gameTimeNow - machine["time"]

        -- REMOVE THE MACHINE ROBBED STATUS SO IT CAN BE ROBBED AGAIN
        if (gameTimeDifference >= cooldownTime) and machine["robbed"] then
            machine["robbed"] = false
        end
    end
end)

-- WHEN TRIGGERED, CHECK IF A VENDING MACHINE CAN BE ROBBED
AddEventHandler("Crime:Server:CheckMachineStatus", function(cb, src, machineCoords)
    local msg = "This machine cannot be robbed right now"
    local canRobMachine = true

    for _, machine in pairs(robbedVendingMachines) do
        if (machine["coords"] == machineCoords) then
            if machine["robbed"] then
                canRobMachine = false
            end
            break
        end
    end
    cb({robbable = canRobMachine or false, msg = msg})
end)

-- WHEN TRIGGERED, GET REWARDS FOR ROBBING A VENDING MACHINE
AddEventHandler("Crime:Server:MachineRobberyLoot", function(cb, src, machineModel)
    cb(true)

    local copsOnline = exports["soe-jobs"]:GetDutyCount("POLICE")
    local config = exports["soe-config"]:GetConfigValue("economy", "machine_robbery") or {min = 5, max = 24} -- VERY LOW REWARD
    if (copsOnline > 0 and copsOnline <= 2) then
        config = exports["soe-config"]:GetConfigValue("economy", "machine_robbery2") or {min = 24, max = 35} -- LOW REWARD
    elseif (copsOnline > 2 and copsOnline <= 4) then
        config = exports["soe-config"]:GetConfigValue("economy", "machine_robbery3") or {min = 35, max = 48} -- MEDIUM REWARD
    elseif (copsOnline > 4) then
        config = exports["soe-config"]:GetConfigValue("economy", "machine_robbery4") or {min = 48, max = 75} -- HIGH REWARD
    else
        config = exports["soe-config"]:GetConfigValue("economy", "machine_robbery") or {min = 5, max = 24} -- VERY LOW REWARD
    end

    math.randomseed(os.time())
    math.random() math.random()
    local amount = math.random(config["min"], config["max"])
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID

    local pos = GetEntityCoords(GetPlayerPed(src))
    if exports["soe-inventory"]:AddItem(src, "char", charID, "cash", amount, "{}") then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "You got $" .. amount .. " from that Vending Machine!", length = 1300})
        exports["soe-logging"]:ServerLog("Vending Machine - Robbed", ("HAS ROBBED A VENDING MACHINE | COORDS: %s | REWARD: $%s"):format(pos, amount), src)
    end

    local machineLoot = extraVendingMachineLoot[machineModel]
    if machineLoot then
        for times = 1, 3 do
            math.randomseed(os.time())
            math.random() math.random()
            local item = machineLoot[math.random(1, #machineLoot)]
            amount = math.random(2, 7)

            if exports["soe-inventory"]:AddItem(src, "char", charID, item, amount, "{}") then
                exports["soe-logging"]:ServerLog("Vending Machine - Robbery Reward", ("HAS ROBBED A VENDING MACHINE | COORDS: %s | REWARD: %sx %s"):format(pos, amount, item), src)
            end
            Wait(15)
        end
    end
end)
