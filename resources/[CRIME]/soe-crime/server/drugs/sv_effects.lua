RegisterNetEvent("Crime:Server:InjectMorphine")
AddEventHandler("Crime:Server:InjectMorphine", function(target)
    TriggerClientEvent("Crime:Client:MorphineEffects", target)
end)
