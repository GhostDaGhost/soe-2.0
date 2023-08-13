----------------------
-- Script Variables --
----------------------

local instancedPlayers = {}
local instancedEntities = {}

----------------------
-- Global Functions --
----------------------

-- Updates player instance in server table and sends update to all clients
function SetPlayerInstance(instance, _src)
    -- locally define source variable
    local src = source

    -- Check if instance is nil
    if instance == -1 then
        instance = "global"
    end

    -- Check if setting other player instance
    if _src ~= nil then
        src = _src
    end

    -- Update player's instance
    instancedPlayers[src] = instance
    TriggerClientEvent("Instance:Client:UpdatePlayerLine", -1, src, instance)
    print(string.format("INSTANCE >> [%s] has been set to: %s", src, instance))
    exports["soe-logging"]:ServerLog("Instance", "HAS BEEN SET TO INSTANCE: " .. instance, src)
end

-- Updates enitty instance in server table and sends update to all clients
function SetEntityInstance(netID, instance)
    if instance == -1 then
        instance = "global"
    end
    -- Update entity instance and broadcast change
    instancedEntities[netID] = instance
    TriggerClientEvent("Instance:Client:UpdateEntityLine", -1, netID, instance)
end

-- Get the instance name of player with specifed server ID
function GetPlayerInstance(player)
    return instancedPlayers[player]
end

-- Get the instance name of entity with specifed network ID
function GetEntityInstance(entity)
    return instancedEntities[entity]
end

---------------------
-- Local Functions --
---------------------

local function InitializeClient()
    local src = source

    -- Set default to global instance
    instancedPlayers[src] = "global"

    -- Init player with current instance data
    TriggerClientEvent("Instance:Client:InitializeInstanceValues", src, instancedPlayers, instancedEntities)

    -- Init player data for all players. Set to call from table to easily change default
    TriggerClientEvent("Instance:Client:UpdatePlayerLine", -1, src, instancedPlayers[src])
end

-- When player drops, remove them from the intance table
local function PlayerDisconnect()
    local src = source

    -- Update data and braodcast change
    instancedPlayers[src] = nil
    TriggerClientEvent("Instance:Client:UpdatePlayerLine", -1, src, nil)
end

-------------------
-- Server Events --
-------------------

RegisterNetEvent("Instance:Server:InitializeClient")
AddEventHandler("Instance:Server:InitializeClient", InitializeClient)

RegisterNetEvent("Instance:Server:SetPlayerInstance")
AddEventHandler("Instance:Server:SetPlayerInstance", SetPlayerInstance)

RegisterNetEvent("Instance:Server:SetEntityInstance")
AddEventHandler("Instance:Server:SetEntityInstance", SetEntityInstance)

AddEventHandler("playerDropped", PlayerDisconnect)
