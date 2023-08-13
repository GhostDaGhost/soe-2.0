Citizen.CreateThread(
    function()
        while true do
            -- TICK TIME TO NETX MINUTE, CHECK IF WEATHER NEEDS TO CHANGE, SEND TO CLIENT
            TickTime()
            CheckWeather()
            TriggerClientEvent("Climate:Client:SendTWState", -1, twState)
            Wait(7500)
        end
    end
)
