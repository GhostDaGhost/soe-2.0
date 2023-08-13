local seenStatusMessages = {}

-- HANDLES STATUS MESSAGES
local function HandleStatusMessages()
    for statusID, statusData in ipairs(statusMessages) do
        if seenStatusMessages[statusID] then return end
        if (GetPlayerServerId(PlayerId()) == statusData.src) then return end

        -- PROXIMITY CHECK
        local pos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(statusData.src)))
        if #(GetEntityCoords(PlayerPedId()) - pos) <= 5.0 then
            --print("I see that.")
            seenStatusMessages[statusID] = true
            TriggerEvent("Chat:Client:SendMessage", "me", ("You notice that %s %s"):format(statusData.name, statusData.message))

            -- SET A COOLDOWN FOR THIS SPECIFIC STATUS TO 5 MINUTES
            SetTimeout(600000, function()
                --print("Expired.")
                seenStatusMessages[statusID] = false
            end)
        end
    end
end

CreateThread(function()
    SetTextChatEnabled(false)
    SetNuiFocus(false)

    local loopIndex = 0
    local lastChatHideState, origChatHideState = -1, -1
    TriggerServerEvent("Chat:Server:GetStatusMessages", {status = true})
    while true do
        Wait(1)

        loopIndex = loopIndex + 1
        if (loopIndex % 850 == 0) then
            loopIndex = 0
            HandleStatusMessages()
        end

        if not chatInputActive then
            if IsControlPressed(0, isRDR and "INPUT_MP_TEXT_CHAT_ALL" or 245) then
                chatInputActive = true
                chatInputActivating = true
                SendNUIMessage({type = "ON_OPEN"})
            end
        end

        if chatInputActivating then
            if not IsControlPressed(0, isRDR and "INPUT_MP_TEXT_CHAT_ALL" or 245) then
                SetNuiFocus(true)
                chatInputActivating = false
            end
        end

        if chatLoaded then
            local forceHide = IsScreenFadedOut() or IsPauseMenuActive()
            local wasForceHide = false

            if (chatHideState ~= CHAT_HIDE_STATES.ALWAYS_HIDE) then
                if forceHide then
                    origChatHideState = chatHideState
                    chatHideState = CHAT_HIDE_STATES.ALWAYS_HIDE
                end
            elseif not forceHide and origChatHideState ~= -1 then
                chatHideState = origChatHideState
                origChatHideState = -1
                wasForceHide = true
            end

            if (chatHideState ~= lastChatHideState) then
                lastChatHideState = chatHideState

                SendNUIMessage({
                    type = "ON_SCREEN_STATE_CHANGE",
                    hideState = chatHideState,
                    fromUserInteraction = not forceHide and not isFirstHide and not wasForceHide
                })
                isFirstHide = false
            end
        end
    end
end)
