-- **********************
--         Events
-- **********************
-- WHEN TRIGGERED, GET TOTAL NUMBER OF ACTIVE PLAYERS
AddEventHandler("Utils:Server:GetPlayerCount", function(cb, src)
    local count = GetNumPlayerIndices()
    local max = GetConvarInt("sv_maxclients", 100)
    cb(count or 0, max or 100)
end)

-- WHEN TRIGGERED, GRAB ENTITY COORDS FROM SERVER
AddEventHandler("Utils:Server:FetchEntityCoords", function(cb, src, entity)
    if not DoesEntityExist(GetPlayerPed(entity)) then cb(nil) return end

    local coords = GetEntityCoords(GetPlayerPed(entity))
    cb(coords or vector3(0.0, 0.0, 0.0))
end)
