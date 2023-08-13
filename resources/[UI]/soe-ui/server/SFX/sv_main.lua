-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, GET A SOUND INDEX
local function GetSoundIdx()
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
    return string.gsub(template, "[xy]", function(c)
        local v = (c == "x") and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format("%x", v)
    end)
end

-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, PLAY A 3D SOUND
function Play3DSound(soundFile, soundPos, soundRot, soundDist, soundIdx)
    local soundUID = soundIdx or GetSoundIdx()
    TriggerClientEvent("UI:Client:Play3DSound", -1, soundUID, soundFile, soundPos, soundRot, soundDist)
end
exports("Play3DSound", Play3DSound)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, PLAY A 3D SOUND
RegisterNetEvent("UI:Server:Play3DSound", function(data)
    Play3DSound(data.soundFile, data.soundPos, data.soundRot, data.soundDist, data.soundIdx)
end)
