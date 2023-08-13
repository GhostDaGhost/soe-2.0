
-- Initialize current vars and handle instancing Thread
-- Updates player intances once every second and ensures corrent instancing is set
CreateThread(function()
    -- Wait until session start to call init event
    while not NetworkIsSessionActive() do
        Wait(10)
    end

    TriggerServerEvent("Instance:Server:InitializeClient")
    while true do
        -- 1 second delay
        Wait(1000)

        -- Local current instance and server id
        local currentInstance = GetPlayerInstance(-1)
        local localServerId = GetPlayerServerId(PlayerId())

        -- Iterates through player instace table from cl_main.lua
        for serverId, instance in pairs(instancedPlayers) do
            -- Ensures we only conceal check non local players
            if serverId ~= localServerId then
                local targetPlayer = GetPlayerFromServerId(serverId)
                if instance ~= currentInstance then -- Not in current instance
                    -- Only conceal if not already concealed
                    if not NetworkIsPlayerConcealed(targetPlayer) then
                        NetworkConcealPlayer(targetPlayer, true, true)
                    end
                else -- If player is in local player instance
                    -- Only unconceal if concealed
                    if NetworkIsPlayerConcealed(targetPlayer) then
                        NetworkConcealPlayer(targetPlayer, false, false)
                    end
                end
            end
        end

        -- Iterates through entity instace table from cl_main.lua
        for netID, instance in pairs(instancedEntites) do
            if NetworkDoesEntityExistWithNetworkId(netID) then -- Checks if Network ID is active. 
                local entity = NetworkGetEntityFromNetworkId(netID)
                if instance ~= currentInstance then -- Isn't in local player's instance
                    -- Only run conceal if not already concealed
                    if not NetworkIsEntityConcealed(entity) then
                        NetworkConcealEntity(entity, true)
                    end
                else -- Is in local player's instance

                    -- Only run unconceal if not already unconcealed
                    if NetworkIsEntityConcealed(entity) then
                        NetworkConcealEntity(entity, false)
                    end
                end
            end
        end
    end
end)
