Citizen.CreateThread(
    function()
        while true do
            -- ENSURE TIME IS SET PROPERLY EACH SECOND
            Wait(1000)
            if not overrideTimeWeather then
                NetworkOverrideClockTime(twState.time.hour, twState.time.minute, 0)
            else
                while overrideTimeWeather do
                    Wait(5)
                    NetworkOverrideClockTime(06, 0, 0)
                end
            end
        end
    end
)