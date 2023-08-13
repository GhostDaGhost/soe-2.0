-- ***********************
--         Events
-- ***********************
-- WHEN TRIGGERED, TOGGLE HELICOPTER SEARCHLIGHT
RegisterNetEvent("Aviation:Server:SearchLight", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 73813-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 73813-2 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.veh then return end
    TriggerClientEvent("Aviation:Client:SearchLight", -1, data.veh, data.state)
end)
