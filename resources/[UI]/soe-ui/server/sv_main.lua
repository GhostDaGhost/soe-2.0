-- **********************
--       Commands
-- **********************
-- WHEN TRIGGERED, TOGGLE LARGE GPS
RegisterCommand("gps", function(source)
    local src = source
    TriggerClientEvent("UI:Client:ToggleLargeGPS", src)
end)

-- WHEN TRIGGERED, RESET ALL UI IN CASE OF MALFUNCTION
RegisterCommand("resetui", function(source)
    local src = source
    TriggerClientEvent("UI:Client:ResetUI", src)
end)
