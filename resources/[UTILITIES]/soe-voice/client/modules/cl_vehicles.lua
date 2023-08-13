-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, CHECK IF A PLAYER CAN CHANGE VOICE RANGE WHEN INSIDE A VEHICLE
function AllowRangeChange(veh)
    local hasWindowsDown = DecorGetBool(veh, "windowsDown")
    local vehicleIsGoingSlowly = ((GetEntitySpeed(veh) * 2.236936) < 25)

    local hasRoof = DoesVehicleHaveRoof(veh)
    local isMotorcycle = (GetVehicleClass(veh) == 8)
    local isBoat = IsThisModelABoat(GetEntityModel(veh))
    local isConvertible = IsVehicleAConvertible(veh, false)

    local hasRoofClosed = (GetConvertibleRoofState(veh) == 0 or GetConvertibleRoofState(veh) == 3)
    local hasIntactWindows = AreAllVehicleWindowsIntact(veh) and IsVehicleWindowIntact(veh, 0) and IsVehicleWindowIntact(veh, 1)

    local hasClosedDoors = (GetVehicleDoorAngleRatio(veh, 0) <= 0.0) and (GetVehicleDoorAngleRatio(veh, 1) <= 0.0)
    if (GetNumberOfVehicleDoors(veh) >= 6) then
        hasIntactWindows = hasIntactWindows and IsVehicleWindowIntact(veh, 2) and IsVehicleWindowIntact(veh, 3)
        hasClosedDoors = hasClosedDoors and (GetVehicleDoorAngleRatio(veh, 2) <= 0.0) and (GetVehicleDoorAngleRatio(veh, 3) <= 0.0) and (GetVehicleDoorAngleRatio(veh, 5) <= 0.0)
    end

    if (veh ~= 0) and IsThisModelABicycle(GetEntityModel(veh)) then
        return true
    end

    if (veh ~= 0) and (isConvertible and (not hasRoofClosed or not hasIntactWindows) and
       vehicleIsGoingSlowly) or (isMotorcycle and vehicleIsGoingSlowly) or (isBoat and vehicleIsGoingSlowly) or
       (not hasClosedDoors and vehicleIsGoingSlowly) or (not hasRoof and vehicleIsGoingSlowly) or (hasRoof and
       (hasWindowsDown or not hasIntactWindows) and vehicleIsGoingSlowly)
    then
        return true
    end
    return false
end
exports("AllowRangeChange", AllowRangeChange)
