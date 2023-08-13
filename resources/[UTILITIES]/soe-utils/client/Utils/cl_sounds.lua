local soundLevel = 0.5

-- **********************
--    Global Functions
-- **********************
-- RETURN THE SET SOUND LEVEL
function GetSoundLevel()
    return soundLevel
end
exports("GetSoundLevel", GetSoundLevel)

-- KILLS ANY AUDIO PLAYING
function KillAudio()
    SendNUIMessage({action = "killSound"})
end
exports("KillAudio", KillAudio)

-- FIRES PROXIMITY SOUND WITHIN ANOTHER PLAYER TO SERVER
function PlayProximitySound(dist, file, volume)
    TriggerServerEvent("Utils:Server:PlayProximitySound", dist, file, volume)
end
exports("PlayProximitySound", PlayProximitySound)

-- FIRES PROXIMITY SOUND WITHIN COORDS TO SERVER
function PlayProximitySoundFromCoords(pos, dist, file, volume)
    TriggerServerEvent("Utils:Server:PlayProximitySoundFromCoords", pos, dist, file, volume)
end
exports("PlayProximitySoundFromCoords", PlayProximitySoundFromCoords)

-- STARTS PLAYING A SOUND
function PlaySound(file, volume, override)
    -- LOCAL SOUND LEVEL OVERRIDE
    if override then
        if (soundLevel ~= nil) then
            volume = soundLevel
        end
    end

    SendNUIMessage({action = "playSound", file = file, volume = volume})
end
exports("PlaySound", PlaySound)

-- **********************
--        Events
-- **********************
-- STARTS PLAYING A SOUND
RegisterNetEvent("Utils:Client:PlaySound", PlaySound)

-- KILLS ANY AUDIO PLAYING
RegisterNetEvent("Utils:Client:KillAudio", KillAudio)

-- CALLED FROM SERVER AFTER "/sound" IS EXECUTED
RegisterNetEvent("Utils:Client:UpdateVolume", function(_soundLevel)
    soundLevel = _soundLevel
end)
