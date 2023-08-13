local currentSafe = 0
local myTotalLoot = 0
local currentRegister = 0
local robbingSafe = false
local tooFarFromSafe = false
local robbingRegister = false
local cancelKeyPressed = false
local tooFarFromRegister = false

-- FUNCTION TO GENERATE MONEY FOR REGISTER
local function GenerateRegisterLoot()
    local maxCash = 15
    local registerLoot = {}
    local config = exports["soe-config"]:GetConfigValue("economy", "stores_register")

    math.randomseed(GetGameTimer())
    local cash = math.random(10, maxCash)
    for i = 1, cash do
        math.randomseed(GetGameTimer())
        Wait(3)
        local amount = math.random(config["min"], config["max"])
        table.insert(registerLoot, amount)
    end

    return registerLoot
end

-- FUNCTION TO GENERATE MONEY FOR SAFE
local function GenerateSafeLoot()
    local maxCash = 25
    local safeLoot = {}
    local config = exports["soe-config"]:GetConfigValue("economy", "stores_safe")

    math.randomseed(GetGameTimer())
    local cash = math.random(10, maxCash)
    for i = 1, cash do
        math.randomseed(GetGameTimer())
        Wait(3)
        local amount = math.random(config["min"], config["max"])
        table.insert(safeLoot, amount)
    end

    return safeLoot
end

-- LOOP TO WORK DURING REGISTER ROBBERY
local function RobbingRegisterRuntime(ped, pos)
    CreateThread(function()
        while robbingRegister do
            Wait(5)
            DisableControlAction(0, 37, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 257, true)

            -- PRESS 'X' TO CANCEL AND BAIL
            if IsControlJustPressed(0, 73) then
                exports["soe-ui"]:PersistentAlert("end", "robbingRegister")
                StopAnimTask(ped, "oddjobs@shop_robbery@rob_till", "loop", 2.0)
                exports["soe-ui"]:SendAlert("inform", "You have left the register you were robbing", 5000)
                TriggerServerEvent("Crime:Server:HandleRewards", {status = true, name = "cash", amt = myTotalLoot})
                myTotalLoot = 0
                cancelKeyPressed = true
                robbingRegister = false
                return
            end
        
            -- TOO FAR FROM THE REGISTER
            local posNow = GetEntityCoords(PlayerPedId())
            if #(pos - posNow) > 0.63 then
                exports["soe-ui"]:PersistentAlert("end", "robbingRegister")
                StopAnimTask(ped, "oddjobs@shop_robbery@rob_till", "loop", 2.0)
                exports["soe-ui"]:SendAlert("inform", "You have left the register you were robbing", 5000)
                TriggerServerEvent("Crime:Server:HandleRewards", {status = true, name = "cash", amt = myTotalLoot})
                myTotalLoot = 0
                tooFarFromRegister = true
                robbingRegister = false
                return
            end
        
            -- ANIMATION CONTROLLER
            if not IsEntityPlayingAnim(ped, "oddjobs@shop_robbery@rob_till", "loop", 3) then
                ClearPedTasks(ped)
                TaskPlayAnim(ped, "oddjobs@shop_robbery@rob_till", "loop", 8.0, 5.0, 30000, 49, 0, 0, 0, 0)
            end
        end
    end)
end

-- LOOP TO WORK DURING SAFE ROBBERY
local function RobbingSafeRuntime(ped, pos)
    CreateThread(function()
        while robbingSafe do
            Wait(5)
            DisableControlAction(0, 37, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 257, true)

            -- PRESS 'X' TO CANCEL AND BAIL
            if IsControlJustPressed(0, 73) then
                exports["soe-ui"]:PersistentAlert("end", "robbingSafe")
                StopAnimTask(ped, "anim@heists@ornate_bank@grab_cash", "grab", 2.0)
                exports["soe-ui"]:SendAlert("inform", "You have left the safe you were robbing", 5000)
                TriggerServerEvent("Crime:Server:HandleRewards", {status = true, name = "cash", amt = myTotalLoot})
                myTotalLoot = 0
                cancelKeyPressed = true
                robbingSafe = false
                return
            end
        
            -- TOO FAR FROM THE REGISTER
            local posNow = GetEntityCoords(PlayerPedId())
            if #(pos - posNow) > 0.63 then
                exports["soe-ui"]:PersistentAlert("end", "robbingSafe")
                StopAnimTask(ped, "anim@heists@ornate_bank@grab_cash", "grab", 2.0)
                exports["soe-ui"]:SendAlert("inform", "You have left the safe you were robbing", 5000)
                TriggerServerEvent("Crime:Server:HandleRewards", {status = true, name = "cash", amt = myTotalLoot})
                myTotalLoot = 0
                tooFarFromSafe = true
                robbingSafe = false
                return
            end
        
            -- ANIMATION CONTROLLER
            if not IsEntityPlayingAnim(ped, "anim@heists@ornate_bank@grab_cash", "grab", 3) then
                ClearPedTasks(ped)
                TaskPlayAnim(ped, "anim@heists@ornate_bank@grab_cash", "grab", 1.0, -1.0, 40000, 2, 0, 0, 0, 0)
            end
        end
    end)
end

-- LOOT THE NEAREST CASH REGISTER
local function LootRegister(ped, pos)
    local bundlesTaken = 0
    local registerLoot = GenerateRegisterLoot()

    cancelKeyPressed = false
    tooFarFromRegister = false

    if robbingRegister then
        -- NO MATTER WHAT, MARK THE REGISTER AS BROKEN INTO
        TriggerServerEvent("Crime:Server:SetRegisterStatus", currentRegister)

        -- START RUNTIME LOOP
        RobbingRegisterRuntime(ped, pos)

        -- REGISTER LOOT
        for i = 1, #registerLoot do
            if not tooFarFromRegister and robbingRegister then
                myTotalLoot = myTotalLoot + registerLoot[i]
                exports["soe-ui"]:SendAlert("warning", ("You stole $%s dollars from the register"):format(registerLoot[i]), 500)
                bundlesTaken = bundlesTaken + 1
                Wait(2500)
            end
        end

        -- FINISH UP THE ROBBERY
        if (bundlesTaken >= #registerLoot) then
            robbingRegister = false
            exports["soe-ui"]:PersistentAlert("end", "robbingRegister")
            exports["soe-ui"]:SendAlert("success", "The register is empty", 2500)
            TriggerServerEvent("Crime:Server:HandleRewards", {status = true, name = "cash", amt = myTotalLoot})
            myTotalLoot = 0

            Wait(2000)
            StopAnimTask(ped, "oddjobs@shop_robbery@rob_till", "loop", 2.0)
        end
    end
end

-- LOOT THE NEAREST SAFE
local function LootSafe(ped, pos)
    local bundlesTaken = 0
    local safeLoot = GenerateSafeLoot()

    cancelKeyPressed = false
    tooFarFromSafe = false

    if robbingSafe then
        -- NO MATTER WHAT, MARK THE REGISTER AS BROKEN INTO
        TriggerServerEvent("Crime:Server:SetSafeStatus", currentSafe)

        -- START RUNTIME LOOP
        RobbingSafeRuntime(ped, pos)

        -- REGISTER LOOT
        for i = 1, #safeLoot do
            if not tooFarFromSafe and robbingSafe then
                myTotalLoot = myTotalLoot + safeLoot[i]
                exports["soe-ui"]:SendAlert("warning", ("You stole $%s dollars from the safe"):format(safeLoot[i]), 500)
                bundlesTaken = bundlesTaken + 1
                Wait(2500)
            end
        end

        -- FINISH UP THE ROBBERY
        if (bundlesTaken >= #safeLoot) then
            robbingSafe = false
            exports["soe-ui"]:PersistentAlert("end", "robbingSafe")
            exports["soe-ui"]:SendAlert("success", "The safe is empty", 2500)
            TriggerServerEvent("Crime:Server:HandleRewards", {status = true, name = "cash", amt = myTotalLoot})
            myTotalLoot = 0

            Wait(2000)
            StopAnimTask(ped, "anim@heists@ornate_bank@grab_cash", "grab", 2.0)
        end
    end
end

-- PREPARE TO ROB THE NEAREST CASH REGISTER
local function RobRegister()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    for k in pairs(storeRegisters) do
        -- IF THE PLAYER IS NEAR A CASH REGISTER
        local dist = Vdist2(pos, storeRegisters[k].x, storeRegisters[k].y, storeRegisters[k].z)
        if (dist <= 1) then
            -- IF ALREADY ROBBED, LET PLAYER KNOW AND RETURN
            if storeRegisters[k].robbed then
                exports["soe-ui"]:SendAlert("error", "This cash register is already open and empty", 3500)
                return
            end

            if not exports["soe-inventory"]:HasInventoryItem("lockpick") then
                exports["soe-ui"]:SendAlert("error", "You do not have a lockpick", 5000)
                return
            end

            local copsOnline = exports["soe-emergency"]:GetCurrentCops()
            if (copsOnline < exports["soe-config"]:GetConfigValue("duty", "stores")) then
                TriggerEvent("Chat:Client:SendMessage", "bank", "The register appears to be secured tightly.")
                return
            end

            if robbingRegister then
                return
            end

            currentRegister = k
            -- DON'T ALLOW TO DO THIS IF SOMEONE IS TOO CLOSE
            if (exports["soe-utils"]:GetClosestPlayer(2) ~= nil) then return end
            -- IF PLAYER LOCKPICKED SUCCESSFULLY
            local location = exports["soe-utils"]:GetLocation(pos)
            TriggerServerEvent("Crime:Server:SendStoreRobberyAlert", location, pos, "cash register", storeRegisters[currentRegister].name)
            if exports["soe-challenge"]:StartLockpicking(true) then
                if (currentRegister == 0) then
                    return
                end
                robbingRegister = true

                -- OPEN THE REGISTER PROP
                local obj = GetClosestObjectOfType(pos, 5.0, GetHashKey("prop_till_01"))
                if DoesEntityExist(obj) then
                    CreateModelSwap(GetEntityCoords(obj), 0.5, GetHashKey("prop_till_01"), GetHashKey("prop_till_01_dam"), false)
                end

                -- LOAD ANIMATION AND SEND CAD ALERT
                exports["soe-utils"]:LoadAnimDict("oddjobs@shop_robbery@rob_till")
                TriggerServerEvent("Crime:Server:SendStoreRobberyAlert", location, pos, "cash register", storeRegisters[currentRegister].name)
                exports["soe-ui"]:PersistentAlert("start", "robbingRegister", "inform", "You are robbing the cash register | Press 'X' to cancel at any time", 2500)

                -- BEGIN LOOTING REGISTER
                LootRegister(ped, pos)

                -- CLOSE THE REGISTER PROP
                local brokenObj = GetClosestObjectOfType(pos, 5.0, GetHashKey("prop_till_01_dam"))
                if DoesEntityExist(brokenObj) then
                    CreateModelSwap(GetEntityCoords(brokenObj), 0.5, GetHashKey("prop_till_01_dam"), GetHashKey("prop_till_01"), false)
                end
            end
        end
    end
end

-- PREPARE TO ROB THE NEAREST SAFE
local function RobSafe()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    for safe in pairs(storeSafes) do
        if #(pos - storeSafes[safe].pos) <= 1.0 then
            if not storeSafes[safe].robbed then
                currentSafe = safe
                if robbingSafe then return end

                local copsOnline = exports["soe-emergency"]:GetCurrentCops()
                if (copsOnline < exports["soe-config"]:GetConfigValue("duty", "stores")) then
                   TriggerEvent("Chat:Client:SendMessage", "bank", "The safe appears to be secured tightly.")
                   return
                end

                -- DON'T ALLOW TO DO THIS IF SOMEONE IS TOO CLOSE
                if (exports["soe-utils"]:GetClosestPlayer(2) ~= nil) then return end
                local location = exports["soe-utils"]:GetLocation(pos)
                if (storeSafes[currentSafe].type == "padlock") then
                    TriggerServerEvent("Crime:Server:SendStoreRobberyAlert", location, pos, "safe", storeSafes[currentSafe].name)
                    local safeCracked = exports["soe-challenge"]:StartSafeCracking({math.random(0, 99), math.random(0, 99), math.random(0, 99)})
                    if (currentSafe ~= 0) and safeCracked then
                        robbingSafe = true
                        local location = exports["soe-utils"]:GetLocation(pos)
                        exports["soe-utils"]:LoadAnimDict("anim@heists@ornate_bank@grab_cash")

                        exports["soe-ui"]:SendAlert("success", "You successfully cracked this safe", 5000)
                        TriggerServerEvent("Crime:Server:SendStoreRobberyAlert", location, pos, "safe", storeSafes[currentSafe].name)
                        exports["soe-ui"]:PersistentAlert("start", "robbingSafe", "inform", "You are robbing the safe | Press 'X' to cancel at any time", 2500)

                        -- START LOOTING
                        LootSafe(ped, pos)
                    else
                        exports["soe-ui"]:SendAlert("error", "You failed to crack this safe", 5000)
                    end
                elseif (storeSafes[currentSafe]["type"] == "keypad") then
                    if not exports["soe-inventory"]:HasInventoryItem("drill") then
                        exports["soe-ui"]:SendAlert("error", "You do not have a drill", 5000)
                        return
                    end

                    if not exports["soe-inventory"]:HasInventoryItem("drillbit") then
                        exports["soe-ui"]:SendAlert("error", "You do not have drill bits", 5000)
                        return
                    end

                    exports["soe-ui"]:SendAlert("inform", "You start drilling the safe", 5000)
                    TriggerServerEvent("Crime:Server:SendStoreRobberyAlert", location, pos, "safe", storeSafes[currentSafe]["name"])
                    if (currentSafe ~= 0) and exports["soe-challenge"]:StartDrilling() then
                        robbingSafe = true
                        exports["soe-utils"]:LoadAnimDict("anim@heists@ornate_bank@grab_cash")
                        exports["soe-ui"]:SendAlert("success", "You successfully drilled this safe", 5000)

                        math.randomseed(GetGameTimer())
                        math.random() math.random() math.random()
                        if (math.random(1, 100) <= 35) then
                            exports["soe-ui"]:SendAlert("error", "You broke the drill bit while pulling out!", 5000)
                            TriggerServerEvent("Challenge:Server:BreakDrillBit")
                        end
                        TriggerServerEvent("Crime:Server:SendStoreRobberyAlert", location, pos, "safe", storeSafes[currentSafe]["name"])
                        exports["soe-ui"]:PersistentAlert("start", "robbingSafe", "inform", "You are robbing the safe | Press 'X' to cancel at any time", 2500)
                        LootSafe(ped, pos)
                    end

                    Wait(600)
                    StopAnimTask(ped, "mp_weapons_deal_sting", "crackhead_bag_loop", 2.0)
                end
            else
                exports["soe-ui"]:SendAlert("error", "This safe is already open and empty", 3500)
            end
        end
    end
end

-- RETURNS CASH REGISTERS
function GetCashRegisters()
    return storeRegisters
end

-- RETURNS STORE SAFES
function GetStoreSafes()
    return storeSafes
end

-- EVENTS FOR RADIAL MENU TRIGGER
AddEventHandler("Crime:Client:RobSafe", RobSafe)
AddEventHandler("Crime:Client:RobRegister", RobRegister)

-- UPON RESOURCE START, SYNC ROBBABLE ITEMS' COOLDOWN
AddEventHandler("onClientResourceStart", function(resource)
    Wait(5000)
    if (GetCurrentResourceName() == resource) then
        TriggerServerEvent("Crime:Server:SyncStoreRobbables")
    end
end)

-- CALLED FROM SERVER TO SYNC REGISTER STATUS
RegisterNetEvent("Crime:Client:SetRegisterStatus")
AddEventHandler("Crime:Client:SetRegisterStatus", function(register, status)
    storeRegisters[register].robbed = status
end)

-- CALLED FROM SERVER TO SYNC SAFE STATUS
RegisterNetEvent("Crime:Client:SetSafeStatus")
AddEventHandler("Crime:Client:SetSafeStatus", function(safe, status)
    storeSafes[safe].robbed = status
end)

-- SENT FROM SERVER TO SYNC REGISTER/SAFE STATUS ON STARTUP
RegisterNetEvent("Crime:Client:SyncStoreRobbables")
AddEventHandler("Crime:Client:SyncStoreRobbables", function(registers, safes)
    -- SYNC CASH REGISTERS
    for register in pairs(registers) do
        storeRegisters[register].robbed = registers[register].robbed
    end

    -- SYNC SAFES
    for safe in pairs(safes) do
        storeSafes[safe].robbed = safes[safe].robbed
    end
end)

-- CAD ALERT FOR STORE ROBBERY, CHANGE HOW IT IS FROM A 10-90
RegisterNetEvent("Crime:Client:SendStoreRobberyAlert")
AddEventHandler("Crime:Client:SendStoreRobberyAlert", function(location, pos, type, storeName)
    local char = exports["soe-uchuu"]:GetPlayer()
    local isOnDuty = exports["soe-jobs"]:IsOnDuty()
    if isOnDuty and (char.CivType == "POLICE") then
        -- STORE ROBBERY CAD ALERT
        local desc = ("A security company is reporting a %s alarm has been triggered at the %s on %s"):format(type, storeName, location)
        TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = false, type = "Commercial Alarm (Store)", desc = desc, code = "10-35", coords = pos})
        --[[TriggerServerEvent("CADAlerts:Server:SendCAD", false, {
            ["cadType"] = "POLICE",
            ["coords"] = pos,
            ["title"] = "<b>10-35 - Commercial Alarm</b><hr>",
            ["description"] = desc,
            ["blip"] = {
                ["sprite"] = 900,
                ["color"] = 38,
                ["scale"] = 0.0
            }
        })]]
    end
end)
