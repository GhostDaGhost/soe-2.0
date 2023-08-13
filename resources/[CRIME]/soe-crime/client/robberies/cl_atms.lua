local hittingAmount, totalLoot = 13, 0
local robbingATM, smashingATM, cancelledRobbing = false, false, false

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, CHECK IF ATM CAN BE ROBBED
local function CanATMBeRobbed(atmCoords)
    local checkATMStatus = exports["soe-nexus"]:TriggerServerCallback("Crime:Server:CheckATMStatus", atmCoords)
    if checkATMStatus["robbable"] then
        return true
    end
    return false, checkATMStatus["msg"]
end

-- WHEN TRIGGERED, ENSURE PLAYER IS USING A WAY TO BREAK INTO THE ATM
local function UsingRobbingMethod()
    local ped = PlayerPedId()

    -- CHECK IF PLAYER HAS THE CORRECT WEAPON (CROWBAR) EQUIPPED | IMPLEMENT MORE WAYS LATER
    if (GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_CROWBAR")) then
        return true
    end
    return false
end

-- WHEN TRIGGERED, CHECK IF PLAYER CANCELS ATM ROBBERY OR GETS TOO FAR SOMEHOW
local function StartSanityCheckThread(atmCoords)
    CreateThread(function()
        local loopIndex = 0
        local config = exports["soe-config"]:GetConfigValue("economy", "atm_robbery") or {min = 8, max = 50}

        while smashingATM or robbingATM do
            Wait(5)
            local ped = PlayerPedId()

            -- BLOCK SOME KEYS
            DisableControlAction(0, 37, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 257, true)

            -- GIVE MONEY EVERY TIME THIS TRIGGERS
            loopIndex = loopIndex + 1
            if (loopIndex % 155 == 0) and robbingATM then
                loopIndex = 0

                math.randomseed(GetGameTimer())
                local loot = math.random(config["min"], config["max"])
                totalLoot = totalLoot + loot

                exports["soe-ui"]:SendAlert("warning", "You stole $" .. loot .. " dollars from the ATM", 50)
            end

            -- CHECK DISTANCE OF PLAYER FROM ATM
            if #(GetEntityCoords(ped) - atmCoords) > 2.5 then
                cancelledRobbing = true
                smashingATM, robbingATM = false, false
                exports["soe-ui"]:SendAlert("error", "You have left the ATM you were robbing", 5000)
                break
            end

            -- PRESS 'X' TO CANCEL ATM ROBBERY
            if IsControlJustPressed(0, 73) then
                cancelledRobbing = true
                smashingATM, robbingATM = false, false
                exports["soe-ui"]:SendAlert("error", "You have decided to stop robbing this ATM", 5000)
                break
            end

            -- PERSIST ANIMATION WHEN SMASHING ATMs
            if smashingATM and not IsEntityPlayingAnim(ped, "melee@small_wpn@streamed_core", "car_down_attack", 3) then
                TaskPlayAnim(ped, "melee@small_wpn@streamed_core", "car_down_attack", 2.5, 2.5, -1, 1, 0, 0, 0, 0)
            end

            -- PERSIST ANIMATION WHEN ROBBING ATMs
            if robbingATM and not IsEntityPlayingAnim(ped, "oddjobs@shop_robbery@rob_till", "loop", 3) then
                TaskPlayAnim(ped, "oddjobs@shop_robbery@rob_till", "loop", 2.5, 2.5, 50000, 1, 0, 0, 0, 0)
            end
        end

        if cancelledRobbing then
            exports["soe-ui"]:PersistentAlert("end", "smashingATM")
            exports["soe-ui"]:PersistentAlert("end", "robbingATM")
            smashingATM, robbingATM = false, false

            Wait(1000)
            ClearPedTasks(PlayerPedId())
        end

        exports["soe-ui"]:SendAlert("success", "You got $" .. totalLoot .. " from that ATM!", 7500)
        TriggerServerEvent("Crime:Server:HandleRewards", {status = true, name = "dirtycash", amt = totalLoot})

        exports["soe-logging"]:ServerLog("ATM Robbery - Reward", ("GOT $%s FROM AN ATM | COORDS: %s"):format(totalLoot, GetEntityCoords(PlayerPedId())))
        totalLoot = 0
    end)
end

-- WHEN TRIGGERED, ROB ATM BUT FIRST CHECK VALIDALITY
local function DoATMRobbery()
    -- PERFORM A SAFE GUARD OF DISTANCE
    local nearATM, atm = exports["soe-bank"]:NearATM()
    if not nearATM then
        exports["soe-ui"]:SendAlert("error", "You are not near an ATM!", 5000)
        return
    end

    -- CHECK IF ATM CAN BE ROBBED
    local atmCoords = GetEntityCoords(atm)
    local canRob, errorMsg = CanATMBeRobbed(atmCoords)
    if not canRob then
        exports["soe-ui"]:SendAlert("error", errorMsg or "This ATM cannot be robbed right now.", 5000)
        return
    end

    local usingRobbingMethod = UsingRobbingMethod()
    if not usingRobbingMethod then
        exports["soe-ui"]:SendAlert("error", "You need a crowbar in your hand!", 5000)
        return
    end

    -- EXPLOIT CHECK
    if smashingATM or robbingATM then
        exports["soe-ui"]:SendAlert("error", "You are already doing this!", 5000)
        return
    end

    -- CHECK IF THERE'S A NEARBY PLAYER TO STOP DOUBLE-OPENING
    if exports["soe-utils"]:GetClosestPlayer(2) then
        exports["soe-ui"]:SendAlert("error", "Someone is too close to you!", 5000)
        return
    end

    -- START A SANITY CHECK THREAD TO ENSURE NO EXPLOITING OR GLITCHES
    smashingATM, cancelledRobbing, totalLoot = true, false, 0
    exports["soe-nexus"]:TriggerServerCallback("Crime:Server:SetATMStatus", atmCoords)

    local loc = exports["soe-utils"]:GetLocation(atmCoords)
    local desc = ("A caller is reporting a subject breaking into an ATM in the area of %s."):format(loc)
    TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = true, code = "10-31", desc = desc, type = "ATM Tampering", loc = loc, coords = atmCoords})
    StartSanityCheckThread(atmCoords)

    -- PRE-LOAD ANIMATION DICTIONARIES
    exports["soe-utils"]:LoadAnimDict("melee@small_wpn@streamed_core", 15)
    exports["soe-utils"]:LoadAnimDict("oddjobs@shop_robbery@rob_till", 15)

    -- HIT THE ATM WITH THE CROWBAR A CERTAIN AMOUNT OF TIMES
    exports["soe-ui"]:PersistentAlert("start", "smashingATM", "debug", "You are smashing the ATM! | Press 'X' to cancel at any time", 5)
    TaskPlayAnim(ped, "melee@small_wpn@streamed_core", "car_down_attack", 2.5, 2.5, -1, 1, 0, 0, 0, 0)
    Wait(500)

    for times = 1, hittingAmount do
        if cancelledRobbing then
            break
        else
            PlaySoundFrontend(-1, "Drill_Pin_Break", "DLC_HEIST_FLEECA_SOUNDSET", 1)
            Wait(1200)
        end
    end

    if not cancelledRobbing then
        ped = PlayerPedId()
        StopAnimTask(ped, "melee@small_wpn@streamed_core", "car_down_attack", -1.5)
        exports["soe-ui"]:PersistentAlert("end", "smashingATM")
    
        smashingATM, robbingATM = false, true
        exports["soe-ui"]:PersistentAlert("start", "robbingATM", "debug", "You are robbing the ATM! | Press 'X' to cancel at any time", 5)
        TaskPlayAnim(ped, "oddjobs@shop_robbery@rob_till", "loop", 2.5, 2.5, 50000, 1, 0, 0, 0, 0)
        Wait(50000)
    end

    if not cancelledRobbing then
        exports["soe-ui"]:PersistentAlert("end", "robbingATM")
        smashingATM, robbingATM = false, false

        exports["soe-ui"]:SendAlert("success", "You successfully robbed the ATM!", 7500)
        Wait(1500)
        StopAnimTask(ped, "oddjobs@shop_robbery@rob_till", "loop", -1.5)
    end
    cancelledRobbing = false
end

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, ROB ATM BUT FIRST CHECK VALIDALITY
AddEventHandler("Crime:Client:DoATMRobbery", DoATMRobbery)

-- WHEN TRIGGERED, HALT ANY CURRENT ATM ROBBING TASKS WHEN RESOURCE STOPS
AddEventHandler("onResourceStop", function(resource)
    if (GetCurrentResourceName() ~= resource) then return end

    exports["soe-ui"]:PersistentAlert("end", "robbingATM")
    exports["soe-ui"]:PersistentAlert("end", "smashingATM")

    if robbingATM and IsEntityPlayingAnim(PlayerPedId(), "oddjobs@shop_robbery@rob_till", "loop", 3) then
        ClearPedTasksImmediately(PlayerPedId())
    end

    if smashingATM and IsEntityPlayingAnim(PlayerPedId(), "melee@small_wpn@streamed_core", "car_down_attack", 3) then
        ClearPedTasksImmediately(PlayerPedId())
    end
end)
