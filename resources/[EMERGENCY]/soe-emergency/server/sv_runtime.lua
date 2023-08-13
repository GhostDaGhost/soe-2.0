CreateThread(function()
    Wait(3500)

    local loopIndex = 0
    while true do
        Wait(1500)
        -- REFRESH ES BLIPS
        RefreshEmergencyBlips()

        -- REMINDER FOR ON DUTY CHARS WITHOUT CALLSIGNS
        loopIndex = loopIndex + 1
        if (loopIndex % 10 == 0) then
            RemindIfNoCallsign()
        -- CHECK FOR FIRE ENGINES FOR FIRE CALLS
        elseif (loopIndex % 50 == 0) then
            if (activeFire == nil) then
                CheckForFireEngines()
            end
        -- START A RANDOM FIRE
        elseif (loopIndex % 370 == 0) then
            loopIndex = 0
            if (activeFireEngines > 0 and activeFire == nil) then
                math.randomseed(os.time())
                if (math.random(1, 100) <= 55) then
                    StartFire()
                end
            end
        end
    end
end)
