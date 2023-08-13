RegisterCommand("guide", function(source)
    local src = source
    TriggerClientEvent("Guide:Client:ShowUI", src)
end)
