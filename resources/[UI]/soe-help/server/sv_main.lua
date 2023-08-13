RegisterCommand("help", function(source)
    local src = source
    TriggerClientEvent("Help:Client:OpenGuide", src)
end)
