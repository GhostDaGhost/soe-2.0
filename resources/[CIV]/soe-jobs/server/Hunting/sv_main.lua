-- CALLED FROM CLIENT TO GIVE SOURCE THE ANIMAL MEAT
RegisterNetEvent("Jobs:Server:HarvestAnimal", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 94932-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 94932-2 | Lua-Injecting Detected.", 0)
        return
    end

    if (data.item == "cash") then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 94932-3 | Lua-Injecting Detected.", 0)
        return
    end

    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    if exports["soe-inventory"]:AddItem(src, "char", charID, data.item, data.amt, "{}") then
        TriggerClientEvent("Chat:Client:Message", src, "[Hunting]", ("You harvest %sx %s from the %s."):format(data.amt, data.item, data.animalName), "standard")
        exports["soe-logging"]:ServerLog(("HARVESTED AN ANIMAL | ANIMAL: %s | REWARD: %sx %s"):format(data.animalName, data.amt, data.item), src)
    end
end)
