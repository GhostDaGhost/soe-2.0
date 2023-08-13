local atmsRobbed = 0 -- AMOUNT OF ATMs HIT
local robbedATMs = {} -- LIST OF ATMs THAT WERE HIT
local maxRobbedATMs = 10 -- MAX AMOUNT OF ATMs THAT CAN BE ROBBED BEFORE LOCKDOWN
local atmLockdown = false -- IF ATMs SHOULD BE IN A GLOBAL LOCKDOWN
local cooldownTime = 3600000 -- APPXOX 60 MINUTES
local secretPassword = "ghostDidntBreakIt" -- SECRET PASSWORD TO USE THE HTTP HANDLER

-- ***********************
--      HTTP Handlers
-- ***********************
-- WHEN TRIGGERED, DO THE FOLLOWING
SetHttpHandler(function(req, res)
    -- MANUALLY RESET LIST OF ROBBED ATMs
    if (req.path == "/resetatms/" .. secretPassword) then
        robbedATMs = {}
        atmsRobbed = 0

        res.send("ALL ATM COOLDOWNS AND LOCKDOWN LIFTED")
        exports["soe-logging"]:ServerLog("ATM Cooldowns", "ALL ATM COOLDOWNS AND LOCKDOWN LIFTED THROUGH HTTP HANDLER")
    end
end)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, SET AN ATM'S STATUS
AddEventHandler("Crime:Server:SetATMStatus", function(cb, src, atmCoords)
    cb(true)
    atmsRobbed = atmsRobbed + 1
    robbedATMs[#robbedATMs + 1] = {["coords"] = atmCoords, ["time"] = GetGameTimer(), ["robbed"] = true}

    local pos = GetEntityCoords(GetPlayerPed(src))
    exports["soe-logging"]:ServerLog("ATM Robbery", "IS ROBBING AN ATM | COORDS: " .. pos, src)
end)

-- WHEN TRIGGERED, CHECK IF ATM CAN BE ROBBED
AddEventHandler("Crime:Server:CheckATMStatus", function(cb, src, atmCoords)
    local msg = "This ATM cannot be robbed right now"
    local canRobATM = true

    for _, atm in pairs(robbedATMs) do
        if (atm["coords"] == atmCoords) then
            if atm.robbed then
                canRobATM = false
            end
            break
        end
    end

    if atmLockdown then
        canRobATM = false
        msg = "ATMs are on a island-wide lockdown!"
    end

    if not canRobATM then
        cb({robbable = false, msg = msg})
    else
        cb({robbable = true})
    end
end)

-- WHEN TRIGGERED, CHECK IF ATMs NEED TO BE LOCKED DOWN OR SHUT COOLDOWN OFF
AddEventHandler("Crime:Server:ATMStatusCooldownCheck", function()
    local copsOnline = exports["soe-jobs"]:GetDutyCount("POLICE")
    if (copsOnline > 0 and copsOnline <= 2) then
        maxRobbedATMs = 50
    elseif (copsOnline > 2 and copsOnline <= 4) then
        maxRobbedATMs = 100
    elseif (copsOnline > 4) then
        maxRobbedATMs = 155
    else
        maxRobbedATMs = 10
    end

    --print("atmsRobbed", atmsRobbed)
    for atmIdx, atm in pairs(robbedATMs) do
        local gameTimeNow = GetGameTimer()
        local gameTimeDifference = gameTimeNow - atm["time"]
        --print("gameTimeDifference", gameTimeDifference)

        -- REMOVE THE ATM ROBBED STATUS SO IT CAN BE ROBBED AGAIN
        if (gameTimeDifference >= cooldownTime) and atm["robbed"] then
            atm["robbed"] = false
            atmsRobbed = atmsRobbed - 1
            --print(atmIdx, "Robbable")
        --[[else
            print(atmIdx, "Not Robbable")]]
        end
    end
    --print("atmsRobbed", atmsRobbed)

    -- IF AMOUNT OF ATMS IN COOL DOWN IS EQUAL OR MORE THAN MAX, LOCKDOWN ALL ATMS FROM BEING ROBBED
    if (atmsRobbed >= maxRobbedATMs) then
        atmLockdown = true
        --print("Lockdown yes")
    else
        atmLockdown = false
        --print("lockdown no.")
    end
end)
