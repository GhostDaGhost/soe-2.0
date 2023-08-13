-- MAIN RUNTIME
CreateThread(function()
    Wait(1000)

    local loopIndex = 0
    while true do
        -- CHECKS VOICE CHAT/MICROPHONE SETTINGS
        loopIndex = loopIndex + 1
        if (loopIndex % 8 == 0) then
            loopIndex = 0
            CheckVoiceSetting("profile_voiceEnable")
            CheckVoiceSetting("profile_voiceTalkEnabled")
            CheckVoiceSetting("profile_voiceChatMode")
        end

        -- WAIT FOR RECONNECTION TO MUMBLE IF LOST
        if not MumbleIsConnected() then
            while not MumbleIsConnected() do
                exports["soe-ui"]:PersistentAlert("start", "notConnectedToMumble", "error", "VOIP issues detected! Try relogging or check your voice settings.", 5)
                currentGrid = -1

                Wait(100)
            end
            exports["soe-ui"]:PersistentAlert("end", "notConnectedToMumble")
        end
	
        -- UPDATE GRID AS PLAYER MOVES
        UpdateMyZone()
        Wait(200)
    end
end)
