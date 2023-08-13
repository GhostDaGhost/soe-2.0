-- ***********************
--         Events
-- ***********************
-- WHEN TRIGGERED, SYNC TURN SIGNALS WITH THE REST OF THE SERVER
AddEventHandler("UX:Server:SyncTurnSignals", function(cb, src, veh, status)
    cb(true)
    TriggerClientEvent("UX:Client:SyncTurnSignals", -1, veh, status)
end)
