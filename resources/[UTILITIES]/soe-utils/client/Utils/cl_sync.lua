-- **********************
--    Global Functions
-- **********************
-- GETS NETWORK ID OF THE ENTITY
function GetNetID(entity)
    local netID = NetworkGetNetworkIdFromEntity(entity)
    NetworkSetNetworkIdDynamic(netID, false)
    SetNetworkIdCanMigrate(netID, true)
    SetNetworkIdExistsOnAllMachines(netID, true)
    return netID
end
exports("GetNetID", GetNetID)

-- GETS ENTITY NETWORK CONTROL (ERRORS OUT WHEN UNSUCCESSFUL SO NO STUCK LOOPS)
function GetEntityControl(ent)
    local wait = 0
    NetworkRequestControlOfEntity(ent)
    while not NetworkHasControlOfEntity(ent) do
        Wait(1)
        wait = wait + 1
        if (wait > 15) then
            break
        end
    end
    return NetworkHasControlOfEntity(ent)
end
exports("GetEntityControl", GetEntityControl)

-- REGISTERS ENTITY AS NETWORKED (ERRORS OUT WHEN UNSUCCESSFUL SO NO STUCK LOOPS)
function RegisterEntityAsNetworked(ent)
    local wait = 0
    NetworkRegisterEntityAsNetworked(ent)
    while not NetworkGetEntityIsNetworked(ent) do
        Wait(50)
        wait = wait + 1
        if (wait > 10) then
            break
        end
    end
    return NetworkGetEntityIsNetworked(ent)
end
exports("RegisterEntityAsNetworked", RegisterEntityAsNetworked)

-- **********************
--        Events
-- **********************
-- SENT FROM SERVER TO SYNC A MISSION ENTITY
RegisterNetEvent("Utils:Client:SyncMissionEntity")
AddEventHandler("Utils:Client:SyncMissionEntity", function(data)
    if not data.status then return end
    local ent = NetworkGetEntityFromNetworkId(data.entity)
    SetEntityAsMissionEntity(ent, true, true)
end)

-- WHEN TRIGGERED, SYNC VEHICLE REPAIRING WITH EVERYONE
RegisterNetEvent("Utils:Client:SyncVehicleRepair")
AddEventHandler("Utils:Client:SyncVehicleRepair", function(data)
    if not data.status then return end
    local veh = NetToEnt(data.entity)

    RepairVehicle(veh)
end)

-- WHEN TRIGGERED, SYNC BOAT ANCHOR WITH EVERYONE
RegisterNetEvent("Utils:Client:SyncBoatAnchor")
AddEventHandler("Utils:Client:SyncBoatAnchor", function(data)
    if not data.status then return end
    local ent = NetToEnt(data.entity)

    SetBoatAnchor(ent, data.anchor)
    SetBoatFrozenWhenAnchored(ent, data.anchor)
    SetForcedBoatLocationWhenAnchored(ent, data.anchor)
end)

-- SENT FROM SERVER TO DELETE AN ENTITY SPECIFIED
RegisterNetEvent("Utils:Client:DeleteEntity")
AddEventHandler("Utils:Client:DeleteEntity", function(entity)
    if NetworkDoesNetworkIdExist(entity) then
        entity = NetToEnt(entity)
        if NetworkHasControlOfEntity(entity) then
            -- ALT
            --TriggerEvent('persistent-vehicles/forget-vehicle', entity)
            
            SetEntityAsMissionEntity(entity, true)
            DeleteEntity(entity)
        end
    end
end)

-- SENT FROM SERVER TO DELETE AN ENTITY SPECIFIED
RegisterNetEvent("Utils:Client:DeletePropAtXYZ")
AddEventHandler("Utils:Client:DeletePropAtXYZ", function(propName, vector)
    local objectAtCoords = GetClosestObjectOfType(vector, 1.0, GetHashKey(propName), 0, 0, 0)
    if DoesEntityExist(objectAtCoords) then
        if NetworkHasControlOfEntity(objectAtCoords) then
            SetEntityAsMissionEntity(objectAtCoords, true)
            DeleteEntity(objectAtCoords)
        end
    end
end)
