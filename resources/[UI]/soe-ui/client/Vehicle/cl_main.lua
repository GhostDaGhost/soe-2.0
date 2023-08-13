inVeh, myVeh = false, nil
isAircraft, isBoat, isBMX = false, false, false

-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, TOGGLE SEATBELT UI
function UpdateSeatbeltIcon(show)
    SendNUIMessage({type = "Vehicle.PopulateUI.Belt", seatbelt = show})
end
exports("UpdateSeatbeltIcon", UpdateSeatbeltIcon)

-- WHEN TRIGGERED, RETURN CURRENT GAME TIME IN 24-HOUR FORMAT
function GetCurrentGameTime()
    local hour, minute = GetClockHours(), GetClockMinutes()
    if (minute < 10) then
        minute = "0" .. minute
    end
    return hour .. ":" .. minute
end

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, HIDE VEHICLE UI
AddEventHandler("BaseEvents:Client:LeftVehicle", function()
    inVeh = false
    SendNUIMessage({type = "Vehicle.DisplayUI", show = false})
end)

-- WHEN TRIGGERED, SHOW VEHICLE UI
AddEventHandler("BaseEvents:Client:EnteredVehicle", function(veh)
    inVeh, myVeh = true, veh
    isAircraft, isBoat, isBMX = false, false, false, false

    local ped = PlayerPedId()
    if IsPedInAnyHeli(ped) or IsPedInAnyPlane(ped) then
        isAircraft = true
    end

    if IsThisModelABicycle(GetEntityModel(veh)) then
        isBMX = true
    end

    if IsPedInAnyBoat(ped) then
        isBoat = true
    end

    -- SET INITIAL VALUES WHEN ENTERING A VEHICLE
    SendNUIMessage({type = "Vehicle.PopulateUI.Time", time = GetCurrentGameTime()})
    SendNUIMessage({type = "Vehicle.PopulateUI.Fuel", fuel = exports["soe-fuel"]:GetFuel(veh)})

    if (GetVehicleEngineHealth(veh) < 400.0) then
        SendNUIMessage({type = "Vehicle.PopulateUI.Engine", show = true})
    else
        SendNUIMessage({type = "Vehicle.PopulateUI.Engine", show = false})
    end
    SendNUIMessage({type = "Vehicle.SetType", isBMX = isBMX, isBoat = isBoat, isAircraft = isAircraft})
    SendNUIMessage({type = "Vehicle.DisplayUI", show = true})
end)
