local inVeh, isFueling, fuelSynced = false, false, false

-- DECORATORS
DecorRegister("fuelLevel", 1)

-- **********************
--    Local Functions
-- **********************
-- MATH ROUNDING FUNCTION
local function Round(num, numDecimalPlaces)
    local mult = (10 ^ (numDecimalPlaces or 0))
    return (math.floor(num * mult + 0.5) / mult)
end

-- MANAGES FUEL USAGE WHILE DRIVING AND SYNCS FUEL
local function ManageFuelUsage(veh)
    -- SYNC FUEL LEVELS AND RANDOMIZE LOCAL CAR FUEL
    if not DecorExistOn(veh, "fuelLevel") then
        SetFuel(veh, (math.random(200, 800) / 10))
    elseif not fuelSynced then
        SetFuel(veh, GetFuel(veh))
        fuelSynced = true
    end

    -- IF THE ENGINE IS ON, SLOWLY DECREASE FUEL
    if IsVehicleEngineOn(veh) then
        if not GetVehicleClass(veh) or not GetVehicleCurrentRpm(veh) then
            return
        end

        if (fuelUsage[Round(GetVehicleCurrentRpm(veh), 1)] == nil or classes[GetVehicleClass(veh)] == nil or GetVehicleFuelLevel(veh) == nil) then
            return
        end
        SetFuel(veh, GetVehicleFuelLevel(veh) - fuelUsage[Round(GetVehicleCurrentRpm(veh), 1)] * (classes[GetVehicleClass(veh)] or 1.0) / 10)
    end
end

-- BEGIN REFUEL FROM THE PUMP
local function RefuelFromPump(pump, ped, veh)
    if isFueling then return end
    isFueling = true

    -- GET VEHICLE CONTROL
    exports["soe-utils"]:GetEntityControl(veh)

    local loopIndex = 0
    local veryOldFuel = DecorGetFloat(veh, "fuelLevel")
    local currentFuel, currentCost = GetVehicleFuelLevel(veh), 0.0

    -- HAVE PED FACE THE VEHICLE
    TaskTurnPedToFaceEntity(ped, veh, -1)
    Wait(450)

    -- ANIMATION CONTROL
    exports["soe-utils"]:LoadAnimDict("weapon@w_sp_jerrycan", 15)
    TaskPlayAnim(ped, "weapon@w_sp_jerrycan", "fire", 1.0, 1.0, -1, 1, 0, 0, 0, 0)

    -- START FILLING TANK
    FreezeEntityPosition(ped, true)
    SetPedCanSwitchWeapon(ped, false)
    SendNUIMessage({type = "toggleFuelUI", show = true})
    exports["soe-ui"]:PersistentAlert("start", "fuelCancel", "debug", "[E] Cancel", 5)

    while isFueling do
        Wait(5)
        loopIndex = loopIndex + 1
        if (loopIndex % 40 == 0) then
            loopIndex = 0
            -- RECORD OLD FUEL LEVEL AND CALCULATE HOW MUCH FUEL TO ADD
            local oldFuel = DecorGetFloat(veh, "fuelLevel")
            local fuelToAdd = (math.random(10, 20) / 10.0)
            local extraCost = (fuelToAdd / 1.5)

            -- START FILLING TANK UP
            currentFuel = (oldFuel + fuelToAdd)
            if (currentFuel > 100.0) then
                currentFuel = 100.0
                isFueling = false
            end

            -- START CALCULATING COST
            currentCost = (currentCost + extraCost)
            SetFuel(veh, currentFuel)

            -- MAKE SURE WE ARE PLAYING THE FUELING ANIMATION
            if not IsEntityPlayingAnim(ped, "weapon@w_sp_jerrycan", "fire", 3) then
                TaskPlayAnim(ped, "weapon@w_sp_jerrycan", "fire", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
            end

            -- IF THERE'S SUDDENLY A DRIVER OR THE PUMP EXPLODED THEN CANCEL
            if DoesEntityExist(GetPedInVehicleSeat(veh, -1)) or (GetEntityHealth(pump) <= 0) then
                isFueling = false
            end
        end

        SendNUIMessage({type = "updateFuelUI", price = Round(currentCost, 1), progress = Round(currentFuel, 1)})
    end

    ClearPedTasks(ped)
    FreezeEntityPosition(ped, false)
    SetPedCanSwitchWeapon(ped, true)
    SendNUIMessage({type = "toggleFuelUI", show = false})
    exports["soe-ui"]:PersistentAlert("end", "fuelCancel")

    local payment = exports["soe-shops"]:NewTransaction(math.ceil(currentCost), "Vehicle Fuel")
    if payment then
        exports["soe-ui"]:SendAlert("warning", ("You filled your vehicle's fuel tank for $%s"):format(math.ceil(currentCost)), 8500)
    else
        SetFuel(veh, veryOldFuel)
        exports["soe-ui"]:SendAlert("error", "You cancelled the refuel payment process so the workers siphoned the fuel you just got", 5000)
        return
    end
end

-- MAIN FUELING FUNCTION
local function FuelMe()
    local ped = PlayerPedId()
    local obj, dist = FindNearestFuelPump()
    if not isFueling and (GetEntityHealth(obj) > 0) then
        local veh = GetVehiclePedIsIn(ped, true)
        if DoesEntityExist(veh) and #(GetEntityCoords(ped) - GetEntityCoords(veh)) < 2.5 and not DoesEntityExist(GetPedInVehicleSeat(veh, -1)) then
            if (GetVehicleFuelLevel(veh) < 99) then
                RefuelFromPump(obj, ped, veh)
            else
                exports["soe-ui"]:SendAlert("error", "Your fuel tank is already full", 5000)
            end
        end
    end
end

-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, RETURN IF PLAYER IS REFUELING
function IsFueling()
    return isFueling
end

-- RETURNS HOW MUCH FUEL IS IN THE VEHICLE
function GetFuel(veh)
    return DecorGetFloat(veh, "fuelLevel")
end

-- SETS HOW MUCH FUEL GOES INTO THE VEHICLE BY PARAMETER
function SetFuel(veh, fuel)
    if (type(fuel) == "number") and (fuel >= 0 and fuel <= 100) then
        SetVehicleFuelLevel(veh, (fuel + 0.0))
        DecorSetFloat(veh, "fuelLevel", GetVehicleFuelLevel(veh))
    end
end

-- SEARCH AND RETURN THE NEAREST FUEL PUMP
function FindNearestFuelPump()
    -- SEARCH FOR NEAREST FUEL PUMP
    local success
    local fuelPumps = {}
    local handle, object = FindFirstObject()
    repeat
        if pumpModels[GetEntityModel(object)] then
            fuelPumps[#fuelPumps + 1] = object
        end
        success, object = FindNextObject(handle, object)
    until not success
    EndFindObject(handle)

    -- CALCULATE NEAREST FUEL PUMP
    local pumpObj, pumpDist = 0, 850
    local pos = GetEntityCoords(PlayerPedId())
    for _, v in pairs(fuelPumps) do
        local dist = #(pos - GetEntityCoords(v))
        if (dist < pumpDist) then
            pumpObj, pumpDist = v, dist
        end
    end

    -- RETURN THE PUMP MODEL AND DISTANCE
    return pumpObj, pumpDist
end

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, FUEL UP VEHICLE WHEN NEAR A PUMP
AddEventHandler("Fuel:Client:FuelVehicle", FuelMe)

-- WHEN TRIGGERED, RESET ALL NUI INSTANCES
AddEventHandler("UI:Client:ResetNUI", function()
    print("[Fuel] UI resetted.")
    SendNUIMessage({type = "toggleFuelUI", show = false})
end)

-- WHEN TRIGGERED, CANCEL CURRENT FUELING
AddEventHandler("Utils:Client:InteractionKey", function()
    if isFueling then
        isFueling = false
    end
end)

-- WHEN TRIGGERED, STOP FUEL BURNING WHEN LEAVING VEHICLE
AddEventHandler("BaseEvents:Client:LeftVehicle", function()
    inVeh = false
    if fuelSynced then
        fuelSynced = false
    end
end)

-- WHEN TRIGGERED, START FUEL BURNING WHEN ENTERED VEHICLE
AddEventHandler("BaseEvents:Client:EnteredVehicle", function(veh, seat)
    if (seat ~= -1) then return end

    inVeh = true
    while inVeh do
        Wait(3500)
        if inVeh then
            ManageFuelUsage(veh)
        end
    end
end)
