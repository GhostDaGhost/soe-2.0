-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, SPAWN A VEHICLE FROM THE SERVER-SIDE (HOPEFUL PERSISTENCE)
AddEventHandler("Utils:Server:CreateNewVehicle", function(cb, src, hash, pos, modelName)
    local veh = CreateVehicle(hash, pos["x"], pos["y"], pos["z"], pos["w"], true, true)
    local failsafe = 0

    while failsafe ~= 100 and not DoesEntityExist(veh) do
        Wait(150)
        failsafe = failsafe + 1
    end

    -- IF THE FAILSAFE WAS TRIGGERED, SKIP EVERYTHING BELOW THESE LINES
    if failsafe >= 100 then
        exports["soe-logging"]:ServerLog("Vehicle Created - Failed", ("HAS FAILED TO CREATE A VEHICLE | MODEL: %s | HASH: %s | COORDS: %s"):format(modelName, hash, pos), src)
        return cb({succeeded = false})
    end

    --[[SetEntityCoords(veh, pos)
    SetEntityHeading(veh, pos["w"] or 0.0)]]
    SetVehicleDirtLevel(veh, 0.0)

    local netID = NetworkGetNetworkIdFromEntity(veh)
    cb({succeeded = true, ent = veh, netID = netID})

    local plate = GetVehicleNumberPlateText(veh) or 0
    exports["soe-logging"]:ServerLog("Vehicle Created", ("HAS CREATED A VEHICLE | PLATE: %s | MODEL: %s | HASH: %s | NET ID: %s | COORDS: %s"):format(plate, modelName, hash, netID, GetEntityCoords(veh)), src)
end)
