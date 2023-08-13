local hasCollisionOccurred = false

-- DECORATORS
DecorRegister("windowsDown", 2)

-- ***********************
--    Local Functions
-- ***********************
-- WHEN TRIGGERED, SYNC WINDOW ROLLING WITH THE REST OF THE SERVER
local function SyncRollWindows(rollType, veh, window)
    veh = NetToVeh(veh)
    if (rollType == "Up") then
        RollUpWindow(veh, window)
        DecorSetBool(veh, "windowsDown", false)
    elseif (rollType == "Down") then
        RollDownWindow(veh, window)
        DecorSetBool(veh, "windowsDown", true)
    else
        print("SyncRollWindows: Unknown direction specified.")
    end
end

-- VEHICLE COLLISION SHAKE EFFECTS DEPENDING ON SPEED
local function CarCrashShake(speed)
    if (speed <= 50) then
        ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 0.4)
    elseif (speed > 50 and speed <= 60) then
        ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 0.7)
    elseif (speed > 60 and speed <= 70) then
        ShakeGameplayCam("MEDIUM_EXPLOSION_SHAKE", 1.2)
    elseif (speed > 70 and speed <= 80) then
        ShakeGameplayCam("MEDIUM_EXPLOSION_SHAKE", 1.5)
    else
        ShakeGameplayCam("LARGE_EXPLOSION_SHAKE", 1.5)
    end
end

-- VEHICLE ENGINE DAMAGE MODIFIER ON SPEED
local function CarDamageModifier(veh, speed)
    if (GetPedInVehicleSeat(veh, -1) == PlayerPedId()) then
        local engineHealth = GetVehicleEngineHealth(veh) 
        if (speed <= 40) then
            SetVehicleEngineHealth(veh, engineHealth - 75)
        elseif (speed > 40 and speed <= 45) then
            SetVehicleEngineHealth(veh, engineHealth - 150)
        elseif (speed > 45 and speed <= 50) then
            SetVehicleEngineHealth(veh, engineHealth - 175)
        elseif (speed > 50 and speed <= 55) then
            SetVehicleEngineHealth(veh, engineHealth - 200)
        elseif (speed > 55 and speed <= 60) then
            SetVehicleEngineHealth(veh, engineHealth - 225)
        elseif (speed > 60 and speed <= 65) then
            SetVehicleEngineHealth(veh, engineHealth - 250)
        elseif (speed > 65 and speed <= 70) then
            SetVehicleEngineHealth(veh, engineHealth - 275)
        elseif (speed > 70 and speed <= 75) then
            SetVehicleEngineHealth(veh, engineHealth - 300)
        elseif (speed > 75 and speed <= 80) then
            SetVehicleEngineHealth(veh, engineHealth - 325)
        elseif (speed > 80 and speed <= 85) then
            SetVehicleEngineHealth(veh, engineHealth - 350)
        elseif (speed > 85 and speed <= 90) then
            SetVehicleEngineHealth(veh, engineHealth - 375)
        elseif (speed > 90 and speed <= 95) then
            SetVehicleEngineHealth(veh, engineHealth - 400)
        elseif (speed > 95 and speed <= 100) then
            SetVehicleEngineHealth(veh, engineHealth - 500)
        else
            SetVehicleEngineHealth(veh, engineHealth - 1000)
        end
    end
end

-- VEHICLE EJECTION
local function VehicleEjection(veh, speed)
    local ped = PlayerPedId()
    if (GetPedInVehicleSeat(veh, -1) ~= ped or GetPedInVehicleSeat(veh, 0) ~= ped) then
        return
    end

    -- 55% CHANCE OF EJECTION
    math.randomseed(GetGameTimer() + 10)
    if (math.random(0, 100) <= 45) then
        local pos, primary, plate = GetEntityCoords(ped), GetVehicleColours(veh), GetVehicleNumberPlateText(veh)

        -- EJECTION MAGIC
        DetachVehicleWindscreen(veh)
        SetEntityCoords(ped, GetEntityCoords(ped))
        Wait(100)
        exports["soe-healthcare"]:StartBleeding(1)
        SetPedToRagdoll(ped, 5511, 5511, 0, 0, 0, 0)
        SetEntityHealth(ped, (GetEntityHealth(ped) - 10))
        ApplyForceToEntityCenterOfMass(ped, 1, 0.0, prevSpeed, 0.0, 1, 1, 1, 1)

        -- SEND CAD ALERT FOR CAR CRASHES
        Wait(2000)
        if exports["soe-emergency"]:ShouldReportInThisArea() then
            local loc = exports["soe-utils"]:GetLocation(pos)
            --TriggerServerEvent("Emergency:Server:CADAlerts", "Motor Vehicle Collision", location, {model = GetEntityModel(veh), color = primary, plate = plate}, pos)
            TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = true, type = "Motor Vehicle Collision",
                loc = loc, model = GetEntityModel(veh), color = primary, plate = plate, coords = pos
            })
        end
    end
end

-- WHEN TRIGGERED, ROLL WINDOWS UP/DOWN FOR VEHICLE
local function RollWindows(direction, multiplier)
    -- CHECK IF THE VEHICLE PLAYER IS IN EXISTS
    if not myVeh then
        exports["soe-ui"]:SendAlert("error", "Must be in a vehicle!", 5000)
        return
    end

    -- AMOUNT OF WINDOWS TO ROLL MANAGEMENT
    local start, finish = 0, 1
    local ped = PlayerPedId()
    if (GetPedInVehicleSeat(myVeh, 1) == ped or GetPedInVehicleSeat(myVeh, 2) == ped) then
        start, finish = 2, 4
    end

    if (multiplier == "all") then
        if (GetPedInVehicleSeat(myVeh, -1) == ped or GetPedInVehicleSeat(myVeh, 0) == ped) then
            start, finish = 0, 4
        else
            exports["soe-ui"]:SendAlert("error", "Must be the driver or front passenger to roll all windows!", 5000)
            return
        end
    end

    -- DO SOME SPECIFIC CHECKS FOR WINDOWS
    if (direction == "Up") then
        for window = start, finish do
            --RollUpWindow(myVeh, window)
            exports["soe-nexus"]:TriggerServerCallback("UX:Server:SyncRollWindows", "Up", VehToNet(myVeh), window)
        end
    elseif (direction == "Down") then
        for window = start, finish do
            --RollDownWindow(myVeh, window)
            exports["soe-nexus"]:TriggerServerCallback("UX:Server:SyncRollWindows", "Down", VehToNet(myVeh), window)
        end
    else
        print("RollWindows: Unknown direction specified.")
    end
end

-- WHEN TRIGGERED, DO CAR CRASH TASKS
local function DoCollisionTasks(veh, seat, curSpeed, prevSpeed, prevVelocity)
    -- CLASS BLACKLIST
    if (GetVehicleClass(veh) == 8 or GetVehicleClass(veh) == 13) then
        print("Vehicle Collision: This class is blacklisted. Natural ejection would happen normally. No shake needed.")
        return
    end

    -- COLLISION HANDLING COOLDOWN
    if hasCollisionOccurred then return end
    if (prevSpeed < 31) then return end
    hasCollisionOccurred = true

    -- CAR DAMAGE MODIFIER
    CarDamageModifier(myVeh, prevSpeed)
    print("New Health")
    print(GetVehicleEngineHealth(myVeh))

    CarCrashShake(prevSpeed)
    if not seatbelt then
        VehicleEjection(myVeh, prevSpeed)
    else
        Wait(100)
        if (prevSpeed <= 50) then
            AnimpostfxPlay("DrugsDrivingIn", 300, false)
            Wait(3000)
            AnimpostfxStop("DrugsDrivingIn")
        elseif (prevSpeed > 50 and prevSpeed <= 60) then
            AnimpostfxPlay("DrugsDrivingIn", 300, false)
            Wait(4200)
            AnimpostfxStop("DrugsDrivingIn")
        elseif (prevSpeed > 60 and prevSpeed <= 70) then
            AnimpostfxPlay("DrugsDrivingIn", 300, false)
            Wait(8200)
            AnimpostfxStop("DrugsDrivingIn")
        elseif (prevSpeed > 70 and prevSpeed <= 80) then
            AnimpostfxPlay("DrugsDrivingIn", 100, false)
            Wait(10200)
            AnimpostfxStop("DrugsDrivingIn")
        else
            AnimpostfxPlay("DrugsDrivingIn", 100, false)
            Wait(20200)
            AnimpostfxStop("DrugsDrivingIn")
        end
    end
    hasCollisionOccurred = false
end

-- ***********************
--        Commands
-- ***********************
RegisterCommand("rollup", function(source, args)
    RollWindows("Up", args[1])
end)

RegisterCommand("rolldown", function(source, args)
    RollWindows("Down", args[1])
end)

-- ***********************
--        Events
-- ***********************
-- WHEN TRIGGERED, SYNC WINDOW ROLLING WITH THE REST OF THE SERVER
RegisterNetEvent("UX:Client:SyncRollWindows", SyncRollWindows)

-- WHEN TRIGGERED, HANDLE CRASHED VEHICLE EVENTS SUCH AS EJECTION AND EFFECTS
AddEventHandler("BaseEvents:Client:VehicleCrashed", DoCollisionTasks)
