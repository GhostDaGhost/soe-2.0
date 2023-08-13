-- **********************
--        Events
-- **********************
-- DELETES AN ENTITY SENT BY CLIENT GLOBALLY
RegisterNetEvent("Utils:Server:DeleteEntity")
AddEventHandler("Utils:Server:DeleteEntity", function(ent)
    TriggerClientEvent("Utils:Client:DeleteEntity", -1, ent)
end)

-- DELETES A PROP SENT BY CLIENT AT XYZ GLOBALLY
RegisterNetEvent("Utils:Server:DeletePropAtXYZ")
AddEventHandler("Utils:Server:DeletePropAtXYZ", function(propName, vector)
    TriggerClientEvent("Utils:Client:DeletePropAtXYZ", -1, propName, vector)
end)

-- CLEARS VEHICLES IN A RADIUS SPECIFIED
RegisterNetEvent("Utils:Server:ClearVehiclesInRadius")
AddEventHandler("Utils:Server:ClearVehiclesInRadius", function(x, y, z, radius)
    TriggerClientEvent("Utils:Client:ClearVehiclesInRadius", -1, x, y, z, radius)
end)

-- CALLED FROM CLIENT TO SYNC A MISSION ENTITY
RegisterNetEvent("Utils:Server:SyncMissionEntity")
AddEventHandler("Utils:Server:SyncMissionEntity", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 1050-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 1050-2 | Lua-Injecting Detected.", 0)
        return
    end
    TriggerClientEvent("Utils:Client:SyncMissionEntity", -1, {status = true, entity = data.entity})
end)

-- WHEN TRIGGERED, SYNC VEHICLE REPAIRING WITH EVERYONE
RegisterNetEvent("Utils:Server:SyncVehicleRepair")
AddEventHandler("Utils:Server:SyncVehicleRepair", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 1052-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 1052-2 | Lua-Injecting Detected.", 0)
        return
    end
    TriggerClientEvent("Utils:Client:SyncVehicleRepair", -1, {status = true, entity = data.entity})
end)

-- WHEN TRIGGERED, SYNC BOAT ANCHOR WITH EVERYONE
RegisterNetEvent("Utils:Server:SyncBoatAnchor")
AddEventHandler("Utils:Server:SyncBoatAnchor", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 1053-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 1053-2 | Lua-Injecting Detected.", 0)
        return
    end

    local name = exports["soe-chat"]:GetDisplayName(src)
    if data.anchor then
        exports["soe-chat"]:DoProximityMessage(src, 10.0, "me", "", name, "drops the anchor.")
    else
        exports["soe-chat"]:DoProximityMessage(src, 10.0, "me", "", name, "pulls up the anchor.")
    end
    TriggerClientEvent("Utils:Client:SyncBoatAnchor", -1, {status = true, entity = data.entity, anchor = data.anchor})
end)
