local soundID = 0
local soundsPlaying = {}

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, GET A SOUND INDEX
local function GetSoundIdx()
    soundID = soundID + 1
    return soundID
end

-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, END A SOUND
function EndSound(soundIdx)
    SendNUIMessage({type = "SFX.EndSound", soundIdx = soundIdx})
end
exports("EndSound", EndSound)

-- WHEN TRIGGERED, PLAY A 3D SOUND
function Play3DSound(soundFile, soundPos, soundRot, soundDist)
    local soundIdx = GetSoundIdx()
    TriggerServerEvent("UI:Server:Play3DSound", {status = true, soundIdx = soundIdx, soundFile = soundFile, soundPos = soundPos, soundRot = soundRot, soundDist = soundDist})
end
exports("Play3DSound", Play3DSound)

-- WHEN TRIGGERED, PLAY A SOUND
function PlaySound(soundIdx, soundFile, soundVolume, loop)
    SendNUIMessage({
        type = "SFX.Play",
        soundFile = soundFile,
        soundVolume = soundVolume,
        soundIdx = soundIdx,
        loop = loop
    })
end
exports("PlaySound", PlaySound)

-- **********************
--     NUI Callbacks
-- **********************
-- WHEN TRIGGERED, STOP VOLUME CONTROL LOOP OF A SOUND
RegisterNUICallback("SFX.StopSound", function(data)
    soundsPlaying[data.soundIdx] = false
end)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, PLAY A 3D SOUND
RegisterNetEvent("UI:Client:Play3DSound", function(soundIdx, soundFile, soundPos, soundRot, soundDist)
    soundsPlaying[soundIdx] = true
    SendNUIMessage({
        type = "SFX.Play3D",
        soundFile = soundFile,
        soundIdx = soundIdx,
        soundPos = soundPos,
        soundRot = soundRot
    })

    local sleep = 250
    while soundsPlaying[soundIdx] do
        Wait(sleep)
        if not soundsPlaying[soundIdx] then
            return
        end

        -- VOLUME CONTROL BASED OFF DISTANCE
        local pos, rot = GetEntityCoords(PlayerPedId()), GetGameplayCamRot(0)
        if #(soundPos - pos) < soundDist then
            sleep = 250
            SendNUIMessage({type = "SFX.ModifyVolume", soundIdx = soundIdx, soundPos = pos, soundRot = rot, mute = false})
        else
            sleep = 3500
            SendNUIMessage({type = "SFX.ModifyVolume", soundIdx = soundIdx, soundPos = pos, soundRot = rot, mute = true})
        end
    end
end)
