-- **********************
--       Commands
-- **********************
-- WHEN TRIGGERED, OPEN NOTIFICATION LOG
RegisterCommand("notifylog", function(source)
    local src = source
    TriggerClientEvent("Notify:Client:OpenLog", src)
end)
