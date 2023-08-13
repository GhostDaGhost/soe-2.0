-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, REPAIR VEHICLE FROM REPAIR KIT
local function DoRepairVehicle(veh, isAdvanced)
    math.randomseed(GetGameTimer())
    if (math.random(1, 100) <= 82) then
        exports["soe-utils"]:GetEntityControl(veh)
        exports["soe-ui"]:SendAlert("success", "You successfully repaired your vehicle", 5000)

        -- FIX TIRES OF VEHICLE
        for i = 0, GetVehicleNumberOfWheels(veh) do
            SetVehicleTyreFixed(veh, i)
        end

        -- FIX ENGINE UP
        if isAdvanced then
            if (GetVehicleEngineHealth(veh) < 550.0) then
                SetVehicleEngineHealth(veh, 550.0)
            end
        else
            if (GetVehicleEngineHealth(veh) < 420.0) then
                SetVehicleEngineHealth(veh, 420.0)
            end
        end
    else
        exports["soe-ui"]:SendAlert("error", "You failed to repair your vehicle", 5000)
    end

    -- RE-CLOSE HOOD AND STOP ANIMATION
    StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_ped", -2.0)
    if (GetVehicleDoorAngleRatio(veh, 4) > 0.0) then
        ExecuteCommand("hood")
    end
end

-- **********************
--    Global Functions
-- **********************
-- SCRATCH OFFS
function UseScratchOff()
    -- FIRST CHECK IF NEAR A CONVENIENCE STORE
    if exports["soe-shops"]:IsNearStore(PlayerPedId()) then
        -- GIVE A HEADSTART WARNING
        exports["soe-ui"]:SendAlert("warning", "Get ready to test your luck", 3000)
        Wait(3500)

        math.randomseed(GetGameTimer())
        if Skillbar(math.random(1000, 2200), math.random(3, 6)) then
            TriggerServerEvent("Challenge:Server:UseScratchOff", true)
        else
            TriggerServerEvent("Challenge:Server:UseScratchOff", false)
        end
    else
        exports["soe-ui"]:SendAlert("error", "You need to be near a 24/7 or LTD", 5000)
    end
end

-- PLASMA CUTTER
function UsePlasmaCutter()
    local veh = exports["soe-utils"]:GetVehInFrontOfPlayer(5.0)
    if (veh ~= nil) then
        -- GAIN ENTITY CONTROL
        exports["soe-utils"]:GetEntityControl(veh)

        -- GRAB OUR CLOSEST DOOR
        local ped = PlayerPedId()
        local pos, closestDoor = GetEntityCoords(ped), exports["soe-utils"]:GetClosestVehicleDoor(veh)
        if (closestDoor.pos ~= nil) then
            if #(pos - closestDoor.pos) <= 3.0 then
                if not IsPedSittingInAnyVehicle(ped) then
                    ClearPedTasks(ped)
                    TaskTurnPedToFaceEntity(ped, veh, -1)
                    Wait(100)
                    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_WELDING", 1, 1)

                    math.randomseed(GetGameTimer())
                    Wait(math.random(8000, 11000))
                    ClearPedTasks(ped)
                    SetVehicleDoorBroken(veh, closestDoor.id, false)
                end
            end
        end
    else
        exports["soe-ui"]:SendAlert("error", "No vehicle found", 5000)
    end
end

-- SLIMJIM
function UseSlimjim()
    local success = false
    local veh = exports["soe-utils"]:GetVehInFrontOfPlayer(5.0)
    if DoesEntityExist(veh) then
        -- ANIMATION CONTROL
        local ped = PlayerPedId()
        exports["soe-utils"]:LoadAnimDict("veh@break_in@0h@p_m_one@", 15)
        TaskPlayAnim(ped, "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0, 1.0, -1, 49, 0, 0, 0, 0)

        -- START MINIGAME
        math.randomseed(GetGameTimer())
        if Skillbar(math.random(5500, 7500), math.random(5, 10)) then
            Wait(200)
            if Skillbar(math.random(5500, 7500), math.random(5, 10)) then
                Wait(200)
                if Skillbar(math.random(5500, 7500), math.random(5, 10)) then
                    Wait(200)
                    if Skillbar(math.random(2500, 3500), math.random(5, 10)) then
                        Wait(200)
                        if Skillbar(math.random(2500, 3500), math.random(5, 10)) then
                            success = true
                        end
                    end
                end
            end
        end

        if success then
            -- GAIN ENTITY CONTROL
            DecorSetBool(veh, "unlocked", true)
            exports["soe-utils"]:GetEntityControl(veh)

            -- UNLOCK VEHICLE
            SetVehicleDoorsLocked(veh, 1)
            SetVehicleDoorsLockedForAllPlayers(veh, false)
            exports["soe-ui"]:SendAlert("inform", "Vehicle Unlocked", 3000)
        else
            exports["soe-ui"]:SendAlert("inform", "You failed to slimjim this vehicle", 5000)
        end

        StopAnimTask(ped, "veh@break_in@0h@p_m_one@", "low_force_entry_ds", -2.0)
    else
        exports["soe-ui"]:SendAlert("error", "No vehicle found", 5000)
    end
end

-- WHEN TRIGGERED, DO REPAIR KIT TASKS BEFORE REPAIRING
function UseRepairKit(isAdvanced)
    Wait(130)
    local veh = exports["soe-utils"]:GetVehInFrontOfPlayer(5.0)

    if (veh ~= 0) then
        -- CHECK IF HOOD IS OPEN
        if DoesVehicleHaveDoor(veh, 4) and (GetVehicleDoorAngleRatio(veh, 4) <= 0.0) then
            ExecuteCommand("hood")
        end

        -- ANIMATION CONTROL
        local ped = PlayerPedId()
        exports["soe-utils"]:LoadAnimDict("mini@repair", 15)
        TaskPlayAnim(ped, "mini@repair", "fixing_a_ped", 1.0, 1.0, -1, 1, 0, 0, 0, 0)

        -- START MINIGAME
        if exports["soe-factions"]:CheckPermission("CANREPAIR") then
            local duration = 15000
            if isAdvanced then
                duration = 18000
            end

            exports["soe-utils"]:Progress(
                {
                    name = "usingRepairKit",
                    duration = duration,
                    label = "Repairing",
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = false
                    }
                },
                function(cancelled)
                    if not cancelled then
                        DoRepairVehicle(veh, isAdvanced)
                    end
                end
            )
        else
            math.randomseed(GetGameTimer())
            if Skillbar(math.random(8500, 11500), math.random(5, 10)) then
                Wait(200)
                if Skillbar(math.random(8500, 11500), math.random(5, 10)) then
                    Wait(200)
                    if Skillbar(math.random(4500, 6500), math.random(3, 7)) then
                        Wait(200)
                        if Skillbar(math.random(2500, 3500), math.random(3, 7)) then
                            Wait(200)
                            if Skillbar(math.random(2500, 3500), math.random(3, 7)) then
                                DoRepairVehicle(veh, isAdvanced)
                            end
                        end
                    end
                end
            end

            -- RE-CLOSE HOOD AND STOP ANIMATION
            StopAnimTask(ped, "mini@repair", "fixing_a_ped", -2.0)
            if (GetVehicleDoorAngleRatio(veh, 4) > 0.0) then
                ExecuteCommand("hood")
            end
        end
    else
        exports["soe-ui"]:SendAlert("error", "No vehicle found", 5000)
    end
end
