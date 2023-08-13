local isRDR = not TerraingridActivate and true or false
local kvpEntry = GetResourceKvpString("hideState")

CHAT_HIDE_STATES = {
    SHOW_WHEN_ACTIVE = 0,
    ALWAYS_SHOW = 1,
    ALWAYS_HIDE = 2
}

isFirstHide = true
chatLoaded = false
chatInputActive = false
chatInputActivating = false
chatHideState = kvpEntry and tonumber(kvpEntry) or CHAT_HIDE_STATES.SHOW_WHEN_ACTIVE

if not isRDR then
    if RegisterKeyMapping then
        RegisterKeyMapping("toggleChat", "[Chat] Cycle Show Stages", "keyboard", "F11")
    end

    RegisterCommand("toggleChat",function()
        if chatHideState == CHAT_HIDE_STATES.SHOW_WHEN_ACTIVE then
            chatHideState = CHAT_HIDE_STATES.ALWAYS_SHOW
        elseif chatHideState == CHAT_HIDE_STATES.ALWAYS_SHOW then
            chatHideState = CHAT_HIDE_STATES.ALWAYS_HIDE
        elseif chatHideState == CHAT_HIDE_STATES.ALWAYS_HIDE then
            chatHideState = CHAT_HIDE_STATES.SHOW_WHEN_ACTIVE
        end

        isFirstHide = false
        SetResourceKvp("hideState", tostring(chatHideState))
    end)
end

-- RemoveSuggestion
RemoveSuggestion = function(name)
    SendNUIMessage({type = "ON_SUGGESTION_REMOVE", name = name})
end
exports("RemoveSuggestion", RemoveSuggestion)

-- AddMessage
AddMessage = function(message)
    if (type(message) == "string") then
        message = {args = {message}}
    end

    SendNUIMessage({type = "ON_MESSAGE", message = message})
end
exports("AddMessage", AddMessage)

-- AddSuggestion
AddSuggestion = function(name, help, params)
    SendNUIMessage({
        type = "ON_SUGGESTION_ADD",
        suggestion = {
            name = name,
            help = help,
            params = params or nil
        }
    })
end
exports("AddSuggestion", AddSuggestion)

-- AddTemplate
AddTemplate = function(id, html)
    SendNUIMessage({
        type = "ON_TEMPLATE_ADD",
        template = {
            id = id,
            html = html
        }
    })
end
exports("AddTemplate", AddTemplate)

local function refreshCommands()
    if GetRegisteredCommands then
        local registeredCommands = GetRegisteredCommands()
        local suggestions = {}

        for _, command in ipairs(registeredCommands) do
            if IsAceAllowed(("command.%s"):format(command.name)) and command.name ~= "toggleChat" then
                table.insert(suggestions, {name = "/" .. command.name, help = ""})
            end
        end
        TriggerEvent("chat:addSuggestions", suggestions)
    end
end

local function refreshThemes()
    local themes = {}
    for resIdx = 0, GetNumResources() - 1 do
        local resource = GetResourceByFindIndex(resIdx)
        if GetResourceState(resource) == "started" then
            local numThemes = GetNumResourceMetadata(resource, "chat_theme")
            if numThemes > 0 then
                local themeName = GetResourceMetadata(resource, "chat_theme")
                local themeData = json.decode(GetResourceMetadata(resource, "chat_theme_extra") or "null")

                if themeName and themeData then
                    themeData.baseUrl = "nui://" .. resource .. "/"
                    themes[themeName] = themeData
                end
            end
        end
    end

    SendNUIMessage({type = "ON_UPDATE_THEMES", themes = themes})
end

RegisterNUICallback("loaded", function(data, cb)
    TriggerServerEvent("chat:init")
    LoadTemplates()

    refreshCommands()
    refreshThemes()
    chatLoaded = true
    cb("ok")
end)

RegisterNUICallback("chatResult", function(data, cb)
    chatInputActive = false
    SetNuiFocus(false)

    if not data.canceled then
        local success, triggerWord = exports["soe-fidelis"]:ValidateChatMessage(data.message)
        if not success then
            exports["soe-logging"]:ServerLog("Offensive Word In Chat (Fidelis)", "HAS USED AN OFFENSIVE WORD IN A CHAT MESSAGE | TRIGGERED WORD: || " .. triggerWord .. " || MESSAGE: || " .. data.message .. " ||")
        end

        if data.message:sub(1, 1) == "/" then
            ExecuteCommand(data.message:sub(2))
            exports["soe-logging"]:ServerLog("Command Executed", "HAS EXECUTED COMMAND: " .. data.message)
        else
            ExecuteCommand("l " .. data.message)
        end
        exports["soe-fidelis"]:ResetIdleTimer()
    end
    cb("ok")
end)

RegisterNetEvent("chatMessage")
RegisterNetEvent("chat:addSuggestions")
RegisterNetEvent("chat:addMode")
RegisterNetEvent("chat:removeMode")
RegisterNetEvent("__cfx_internal:serverPrint")
RegisterNetEvent("_chat:messageEntered")

RegisterNetEvent("chat:addMessage")
AddEventHandler("chat:addMessage", AddMessage)

RegisterNetEvent("chat:addTemplate")
AddEventHandler("chat:addTemplate", AddTemplate)

RegisterNetEvent("chat:addSuggestion")
AddEventHandler("chat:addSuggestion", AddSuggestion)

RegisterNetEvent("chat:removeSuggestion")
AddEventHandler("chat:removeSuggestion", RemoveSuggestion)

AddEventHandler("chat:addMode", function(mode)
    SendNUIMessage({type = "ON_MODE_ADD", mode = mode})
end)

AddEventHandler("chat:removeMode", function(name)
    SendNUIMessage({type = "ON_MODE_REMOVE", name = name})
end)

AddEventHandler("chat:addSuggestions", function(suggestions)
    for _, suggestion in ipairs(suggestions) do
        SendNUIMessage({type = "ON_SUGGESTION_ADD", suggestion = suggestion})
    end
end)

RegisterNetEvent("Chat:Client:ClearChat")
AddEventHandler("Chat:Client:ClearChat", function()
    SendNUIMessage({type = "ON_CLEAR"})
end)

AddEventHandler("onClientResourceStart", function()
    Wait(500)
    refreshCommands()
    refreshThemes()
end)

AddEventHandler("onClientResourceStop", function()
    Wait(500)
    refreshCommands()
    refreshThemes()
end)

--deprecated, use chat:addMessage
AddEventHandler("chatMessage", function(author, color, text)
    local args = {text}
    if (author ~= "") then
        table.insert(args, 1, author)
    end
    SendNUIMessage({
        type = "ON_MESSAGE",
        message = {
            color = color,
            multiline = true,
            args = args
        }
    })
end)
