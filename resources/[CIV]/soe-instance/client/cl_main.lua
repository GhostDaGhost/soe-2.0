----------------------
-- Script Variables --
----------------------
instancedPlayers = {}
instancedEntites = {}

----------------------
-- Gloabl functions --
----------------------

-- Gets the selected player's instance
function GetPlayerInstance(player)
    -- Check if should be local player
    if player == -1 then
        player = GetPlayerServerId(PlayerId())
    end

    -- Return the item in the local table
    return instancedPlayers[player]
end

-- Gets the selected non player entity's instance
function GetEntityInstance(entity)
    return instancedEntites[entity]
end

---------------------
-- Local functions --
---------------------

-- Used by server called events to update the player's Instance
local function UpdatePlayerLine(player, instance)
    instancedPlayers[player] = instance
end

-- Used by server called events to update a entity's Instance
local function UpdateEntityLine(entity, instance)
    instancedEntites[entity] = instance
end

-- Only called when player first connects to set current Instance values
local function InitializeInstanceValues(_instancedPlayers, _instancedEntites)
    instancedPlayers = _instancedPlayers
    instancedEntites = _instancedEntites
end

--------------------
-- Syncing Events --
--------------------

RegisterNetEvent("Instance:Client:UpdatePlayerLine")
AddEventHandler("Instance:Client:UpdatePlayerLine", UpdatePlayerLine)

RegisterNetEvent("Instance:Client:UpdateEntityLine")
AddEventHandler("Instance:Client:UpdateEntityLine", UpdateEntityLine)

RegisterNetEvent("Instance:Client:InitializeInstanceValues")
AddEventHandler("Instance:Client:InitializeInstanceValues", InitializeInstanceValues)
