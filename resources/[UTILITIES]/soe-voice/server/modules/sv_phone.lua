-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, REMOVE PLAYER FROM ANY CALL
function RemovePlayerFromCall(src, callChannel)
    --logger.info("[phone] Removed %s from call %s", src, callChannel)

    callData[callChannel] = callData[callChannel] or {}
    for player in pairs(callData[callChannel]) do
        TriggerClientEvent("Voice:Client:RemovePlayerFromCall", player, src)
    end

    callData[callChannel][src] = nil
    voiceData[src] = voiceData[src] or ResetDataTables(src)
    voiceData[src].call = 0
end

-- WHEN TRIGGERED, ADD PLAYER TO A CALL
function AddPlayerToCall(src, callChannel)
    --logger.info("[phone] Added %s to call %s", src, callChannel)

    callData[callChannel] = callData[callChannel] or {}
    for player in pairs(callData[callChannel]) do
        if (player ~= src) then
            TriggerClientEvent("Voice:Client:AddPlayerToCall", player, src)
        end
    end

    callData[callChannel][src] = false
    voiceData[src] = voiceData[src] or ResetDataTables(src)
    voiceData[src].call = callChannel
    TriggerClientEvent("Voice:Client:SyncCallData", src, callData[callChannel])
end

-- WHEN TRIGGERED, SET PLAYER TO A CALL
function SetPlayerCallChannel(src, callChannel)
    if GetInvokingResource() then
        TriggerClientEvent("Voice:Client:SetPlayerToCall", src, callChannel)
    end

    voiceData[src] = voiceData[src] or ResetDataTables(src)
    local plyVoice = voiceData[src]
    local callChannel = tonumber(callChannel)

    if (callChannel ~= 0 and plyVoice.call == 0) then
        AddPlayerToCall(src, callChannel)
    elseif (callChannel == 0) then
        RemovePlayerFromCall(src, plyVoice.call)
    elseif (plyVoice.call > 0) then
        RemovePlayerFromCall(src, plyVoice.call)
        AddPlayerToCall(src, callChannel)
    end
end

-- WHEN TRIGGERED, TOGGLE TALKING STATE FOR A PLAYER
function SetTalkingOnCall(talking)
    local src = source
    voiceData[src] = voiceData[src] or ResetDataTables(src)

    local plyVoice = voiceData[src]
    local callTbl = callData[plyVoice.call]
    if callTbl then
        --logger.info("[phone] %s %s talking in call %s", src, talking and "started" or "stopped", plyVoice.call)
        for player in pairs(callTbl) do
            if (player ~= src) then
                --logger.verbose("[call] Sending event to %s to tell them that %s is talking", player, src)
                TriggerClientEvent("Voice:Client:SetTalkingOnCall", player, src, talking)
            end
        end
    else
        --logger.info("[phone] %s tried to talk in call %s, but it doesnt exist.", src, plyVoice.call)
    end
end

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, TOGGLE TALKING STATE FOR A PLAYER
RegisterNetEvent("Voice:Server:SetTalkingOnCall", SetTalkingOnCall)

-- WHEN TRIGGERED, SET PLAYER TO A CALL
RegisterNetEvent("Voice:Server:SetPlayerCallChannel", function(callChannel)
    SetPlayerCallChannel(source, callChannel)
end)
