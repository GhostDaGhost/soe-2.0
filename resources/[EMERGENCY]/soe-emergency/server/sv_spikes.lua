-- ***********************
--         Events
-- ***********************
-- WHEN TRIGGERED, SYNC TIRE POPPING FROM SPIKES WITH REST OF THE SERVER
AddEventHandler("Emergency:Server:SyncSpikesHit", function(cb, src, veh, tires, npcHit)
    cb(true)
    TriggerClientEvent("Emergency:Client:SyncSpikesHit", -1, veh, tires)

    if not npcHit then
        local pos = GetEntityCoords(GetPlayerPed(src))
        exports["soe-logging"]:ServerLog("Spike Strips - Hit", ("RAN OVER SOME SPIKE STRIPS AND WAS HIT | VEH NETID: %s | TIRES: %s | COORDS: %s"):format(veh, tires, pos), src)
    end
end)

-- WHEN TRIGGERED, SYNC PLACEMENT OF SPIKE STRIPS WITH REST OF THE SERVER
AddEventHandler("Emergency:Server:SyncSpikeStrips", function(cb, src, type, data)
    cb(true)
    TriggerClientEvent("Emergency:Client:SyncSpikeStrips", -1, type, data)

    local pos = GetEntityCoords(GetPlayerPed(src))
    if (type == "Place") then
        exports["soe-inventory"]:RemoveItem(src, 1, "spikestrips")
        exports["soe-logging"]:ServerLog("Spike Strips - Placed Down", "HAS PLACED DOWN A SPIKE STRIP AT COORDS: " .. pos, src)
    elseif (type == "Remove") then
        if not data.used then
            local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
            exports["soe-inventory"]:AddItem(src, "char", charID, "spikestrips", 1, "{}")
        else
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "debug", text = "These spikestrips have been used!", length = 5000})
        end
        exports["soe-logging"]:ServerLog("Spike Strips - Picked Up", ("HAS PICKED UP A SPIKE STRIP | COORDS: %s | USED: %s"):format(pos, data.used), src)
    end
end)
