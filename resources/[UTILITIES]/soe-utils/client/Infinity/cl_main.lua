local playerCoords, entityCoords = {}, {}

-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, CHECK IF A PLAYER IS ACTIVE AND HAS VALID COORDS RUNNING
function IsPlayerActive(serverID)
    return (playerCoords[tonumber(serverID)] ~= nil)
end
exports("IsPlayerActive", IsPlayerActive)

-- WHEN TRIGGERED, GET TOTAL NUMBER OF ACTIVE PLAYERS
function GetPlayerCount()
    local count, max = exports["soe-nexus"]:TriggerServerCallback("Utils:Server:GetPlayerCount")
    return tonumber(count), tonumber(max)
end
exports("GetPlayerCount", GetPlayerCount)

-- WHEN TRIGGERED, CHECK IF A PLAYER EXISTS
function DoesPlayerExist(serverID)
    local player = GetPlayerFromServerId(tonumber(serverID))
    if (player ~= -1) then
        return true
    end
    return false
end
exports("DoesPlayerExist", DoesPlayerExist)

-- WHEN TRIGGERED, GRAB ENTITY COORDS FROM SERVER
function FetchEntityCoords(entity)
    local coords = exports["soe-nexus"]:TriggerServerCallback("Utils:Server:FetchEntityCoords", entity)
    entityCoords[entity] = coords

    return coords
end
exports("FetchEntityCoords", FetchEntityCoords)

-- WHEN TRIGGERED, GET LOCAL ENTITY ID
function GetLocalEntity(entityType, entityNetID)
    local entity
    if (entityType == "Player") then
        local playerIdx = GetPlayerFromServerId(entityNetID)
        entity = playerIdx ~= -1 and GetPlayerPed(playerIdx) or 0
    else
        entity = NetworkGetEntityFromNetworkId(entityNetID)
    end

    return entity
end
exports("GetLocalEntity", GetLocalEntity)

-- WHEN TRIGGERED, GET NETWORKED COORDINATES OF A ENTTIY OR PLAYER
function GetNetworkedCoords(entityType, entityNetID)
    local coords
    if (entityType == "Player") then
        local playerIdx = GetPlayerFromServerId(entityNetID)
        coords = playerIdx == -1 and playerCoords[entityNetID] or GetEntityCoords(GetPlayerPed(playerIdx))
    else
        local entity = NetworkGetEntityFromNetworkId(entityNetID)
        if DoesEntityExist(entity) then
            coords = GetEntityCoords(entity)
        else
            coords = entityCoords[entityNetID] or FetchEntityCoords(entityNetID)
        end
    end

    return coords
end
exports("GetNetworkedCoords", GetNetworkedCoords)
