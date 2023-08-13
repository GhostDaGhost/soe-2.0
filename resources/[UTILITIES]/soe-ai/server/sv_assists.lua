RegisterCommand("coroner", function(source)
    local src = source
    local civType = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CivType
    if (civType == "POLICE" or civType == "EMS") then
        TriggerClientEvent("AI:Client:BodyRecoveryTeam", src, true)
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for Emergency Services.")
    end
end)

RegisterCommand("ambulance", function(source)
    local src = source
    local civType = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CivType
    if (civType == "POLICE" or civType == "EMS") then
        TriggerClientEvent("AI:Client:BodyRecoveryTeam", src, false)
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for Emergency Services.")
    end
end)

RegisterCommand("localtow", function(source)
    local src = source
    local civType = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CivType
    if (civType == "POLICE" or civType == "EMS") then
        TriggerClientEvent("AI:Client:SendLocalTow", src)
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for Emergency Services.")
    end
end)
