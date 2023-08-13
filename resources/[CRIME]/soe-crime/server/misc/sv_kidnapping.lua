-- **********************
--       Commands
-- **********************
-- WHEN TRIGGERED, HEADBAG THE NEAREST PLAYER
RegisterCommand("headbag", function(source)
    local src = source
    TriggerClientEvent("Crime:Client:DoHeadbagging", src, {status = true})
end)

-- WHEN TRIGGERED, GET INSIDE TRUNK OF NEAREST VEHICLE
RegisterCommand("getintrunk", function(source)
    local src = source
    TriggerClientEvent("Crime:Client:GetInsideTrunk", src, {status = true})
end)

-- WHEN TRIGGERED, PUTS RESTRAINED PLAYER INSIDE TRUNK OF NEAREST VEHICLE
RegisterCommand("putintrunk", function(source)
    local src = source
    TriggerClientEvent("Crime:Client:PutInsideTrunk", src, {status = true})
end)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, SYNC HEADBAGGING WITH THE SENT SERVER ID
RegisterNetEvent("Crime:Server:Headbag")
AddEventHandler("Crime:Server:Headbag", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 5994-1 | Lua-Injecting Detected.", 0)
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 5994-2 | Lua-Injecting Detected.", 0)
    end

    if not data.serverID then return end
    TriggerClientEvent("Crime:Client:Headbag", data.serverID, {status = true})
end)

-- WHEN TRIGGERED, SYNC TARGETED PLAYER TO GET INSIDE THE TRUNK
RegisterNetEvent("Crime:Server:PutInsideTrunk")
AddEventHandler("Crime:Server:PutInsideTrunk", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 5993-1 | Lua-Injecting Detected.", 0)
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 5993-2 | Lua-Injecting Detected.", 0)
    end

    if not data.serverID then return end
    TriggerClientEvent("Crime:Client:GetInsideTrunk", data.serverID, {status = true, veh = data.veh})
end)
