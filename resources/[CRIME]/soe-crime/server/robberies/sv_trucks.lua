-- SYNCING EVENT FOR TRUCK ALARMS
RegisterNetEvent("Crime:Server:SendTruckRobberyAlert")
AddEventHandler(
    "Crime:Server:SendTruckRobberyAlert",
    function(location, pos, details)
        TriggerClientEvent("Crime:Client:SendTruckRobberyAlert", -1, location, pos, details)
    end
)
