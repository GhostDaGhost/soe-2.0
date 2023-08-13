-- ***********************
--        Events
-- ***********************
-- WHEN TRIGGERED, SYNC WINDOW ROLLING WITH THE REST OF THE SERVER
AddEventHandler("UX:Server:SyncRollWindows", function(cb, src, rollType, veh, window)
    cb(true)
    TriggerClientEvent("UX:Client:SyncRollWindows", -1, rollType, veh, window)
end)
