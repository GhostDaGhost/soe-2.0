-- CHECK EVERY PLAYER EVERY MINUTE IN CASE THEY BAN EVADED
--[[CreateThread(function()
    Wait(3500)
    while true do
        Wait(60000)
        -- ITERATE THROUGH ACTIVE PLAYERS
        for _, v in pairs(GetPlayers()) do
            local identifiers = exports["soe-utils"]:GetIdentifiersFromSource(tonumber(v))
            local myIdentifiers = json.encode(identifiers)

            -- IF A BAN IS FOUND, KICK THIS SUCKER AND SHOW BAN MESSAGE
            local checkBan = exports["soe-nexus"]:PerformAPIRequest("/api/ban/get", ("identifiers=%s"):format(myIdentifiers), true)
            if checkBan.status then
                if checkBan.data then
                    local msg = string.format(
                        "\nYou have been banned from the SoE servers!\nBan ID: %s\nBanned By: %s (Evasion Detected)\nBan Expires: %s UTC\nBan Reason: %s\n\nYou can appeal this ban at soe.gg/banappeal",
                        checkBan.data.BanID,
                        checkBan.data.BannedBy,
                        checkBan.data.BanExpiry,
                        checkBan.data.BanReason
                    )
                    DropPlayer(tonumber(v), msg)
                end
            end
        end
    end
end)]]
