-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, FIRES PROXIMITY SOUND TO ANY PLAYER WITHIN THE TARGET
function PlayProximitySound(src, dist, file, volume)
    local pos = GetEntityCoords(GetPlayerPed(src))
    for serverID in pairs(exports["soe-uchuu"]:GetOnlinePlayerList()) do
        if #(GetEntityCoords(GetPlayerPed(serverID)) - pos) <= dist then
            TriggerClientEvent("Utils:Client:PlaySound", serverID, file, volume)
        end
    end
end
exports("PlayProximitySound", PlayProximitySound)

-- WHEN TRIGGERED, FIRES PROXIMITY SOUND TO ANY PLAYER WITHIN COORDS
function PlayProximitySoundFromCoords(_pos, dist, file, volume)
    for src in pairs(exports["soe-uchuu"]:GetOnlinePlayerList()) do
        local pos = GetEntityCoords(GetPlayerPed(src))
        if #(pos - _pos) <= dist then
            TriggerClientEvent("Utils:Client:PlaySound", src, file, volume)
        end
    end
end
exports("PlayProximitySoundFromCoords", PlayProximitySoundFromCoords)

-- **********************
--       Commands
-- **********************
RegisterCommand("sound", function(source, args)
    local src = source
    local volume = tonumber(args[1])
    if (volume ~= nil) then
        if (volume > 1) then
            TriggerClientEvent("Utils:Client:UpdateVolume", src, 1)
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Sound Volume: 1 | Don't try to deafen yourself!", length = 5000})
        else
            TriggerClientEvent("Utils:Client:UpdateVolume", src, volume)
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = string.format("Sound Volume: %s", volume), length = 5000})
        end
    end
end)

-- **********************
--        Events
-- **********************
-- PLAYS A SOUND TO ALL PLAYERS ON THE SERVER
RegisterNetEvent("Utils:Server:PlayOnAll", function(file, volume)
    TriggerClientEvent("Utils:Client:PlaySound", -1, file, volume)
end)

-- PROXIMITY SOUND FOR ANYONE NEAR THE SOURCE POS
RegisterNetEvent("Utils:Server:PlayProximitySoundFromCoords", function(pos, dist, file, volume)
    PlayProximitySoundFromCoords(pos, dist, file, volume)
end)

-- WHEN TRIGGERED, FIRES PROXIMITY SOUND TO ANY PLAYER WITHIN THE TARGET
RegisterNetEvent("Utils:Server:PlayProximitySound", function(dist, file, volume)
    local src = source
    PlayProximitySound(src, dist, file, volume)
end)

-- KILLS ANY SOUND PLAYING ON THE SOURCE
RegisterNetEvent("Utils:Server:KillOnSource", function()
    local src = source
    TriggerClientEvent("Utils:Client:KillAudio", src)
end)

-- PLAYS A SOUND LOCALLY ON THE SOURCE
RegisterNetEvent("Utils:Server:PlaySound", function(file, volume)
    local src = source
    TriggerClientEvent("Utils:Client:PlaySound", src, file, volume)
end)
