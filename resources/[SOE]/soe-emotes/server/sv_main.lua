local emoteRequests = {}

-- ***********************
--    Local Functions
-- ***********************
-- WHEN TRIGGERED, PERFORM CONFIRMATION OF EMOTE REQUEST
local function PerformEmoteRequestConfirmation(src, data)
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 28555-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 28555-2 | Lua-Injecting Detected.", 0)
        return
    end

    if emoteRequests[src] then
        emoteRequests[src].accepted = data.response
    end
end

-- ITERATES REQUESTED WALKSTYLE THROUGH WALKSTYLES TABLE
local function DoWalkstyle(src, style)
    -- MAKE SURE COMMAND INPUT SPECIFIES A WALKSTYLE
    if (style == nil) then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Please specify a walkstyle", length = 5000})
        return
    end

    -- IF "/walk reset" IS ENTERED, RESET WALKSTYLE
    if (style == "reset") then
        TriggerClientEvent("Emotes:Client:ChangeWalkstyle", src, "reset")
        return
    end

    if walkstyles[style] then
        TriggerClientEvent("Emotes:Client:ChangeWalkstyle", src, walkstyles[style])
    else
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = ('"%s" is not a valid walkstyle'):format(style), length = 5000})
    end
end

-- ITERATES REQUESTED FACIAL EXPRESSION THROUGH EXPRESSIONS TABLE
local function DoFacialExpression(src, expression)
    -- MAKE SURE COMMAND INPUT SPECIFIES A MOOD
    if (expression == nil) then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Please specify a mood", length = 5000})
        return
    end

    -- IF "/mood reset" IS ENTERED, CLEAR EXPRESSIONS
    if (expression == "reset") then
        TriggerClientEvent("Emotes:Client:PlayExpression", src, "reset")
        return
    end

    if faceExpressions[expression] then
        TriggerClientEvent("Emotes:Client:PlayExpression", src, faceExpressions[expression])
    else
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = ('"%s" is not a valid mood'):format(expression), length = 5000})
    end
end

-- ITERATES REQUESTED FACIAL EXPRESSION THROUGH EXPRESSIONS TABLE
local function DoAimingStyle(src, style)
    -- MAKE SURE COMMAND INPUT SPECIFIES A STYLE
    if (style == nil) then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Please specify a style", length = 5000})
        return
    end

    -- IF "/aim reset" IS ENTERED, CLEAR AIMING STYLE
    if (style == "reset") then
        TriggerClientEvent("Emotes:Client:PlayAimingStyle", src, "reset")
        return
    end

    if aimingStyles[style] then
        TriggerClientEvent("Emotes:Client:PlayAimingStyle", src, aimingStyles[style])
    else
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = ('"%s" is not a valid aiming style'):format(style), length = 5000})
    end
end

-- WHEN TRIGGERED, SAVE OR REMOVE A EMOTE BIND
local function UpdateSavedBinds(src, bind, emote)
    if not bind then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You must include a bind number from a range of 1-".. amountOfBinds, length = 5000})
        return
    end

    if (bind > 0 and bind <= amountOfBinds) then
        emote = emote:lower()
        -- DELETE EMOTE FROM SAVED BIND
        if (emote == "delete" or emote == "nil") then
            exports["soe-uchuu"]:UpdateCharacterSettings(src, "emote_bind" .. bind, true)
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "Cleared emote from Emote Bind #".. bind, length = 7500})
            return
        end

        -- SAVE EMOTE TO SPECIFIC BIND NUMBER
        if animations[emote] then
            exports["soe-uchuu"]:UpdateCharacterSettings(src, "emote_bind" .. bind, false, emote)
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "Binded ".. emote .." to Emote Bind #".. bind, length = 7500})
        else
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = ('"%s" is not a valid animation'):format(emote), length = 5000})
        end
    else
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Bind number must be from a range of 1-" .. amountOfBinds, length = 5000})
    end
end

-- ***********************
--    Global Functions
-- ***********************
-- WHEN TRIGGERED, PLAYS EMOTE FOR A SOURCE
function PlayEmote(src, emote)
    -- MAKE SURE COMMAND INPUT SPECIFIES AN EMOTE
    if (emote == nil) then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Please specify an emote", length = 5000})
        return
    end

    -- IF "/e c" IS ENTERED, CANCEL EMOTE
    if (emote == "c") then
        TriggerClientEvent("Emotes:Client:PlayAnimation", src, "reset")
        return
    end

    if not exports["soe-utils"]:IsModelADog(GetPlayerPed(src)) then
        if animations[emote] then
            local hasItem = true
            if emote == "camera" then
                if exports["soe-inventory"]:GetItemAmt(src, "camera", "left") < 1 and exports["soe-inventory"]:GetItemAmt(src, "weazelcamera", "left") < 1 then
                    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You need a camera to use this emote", length = 5000})
                    hasItem = false
                end
            end

            if hasItem then
                TriggerClientEvent("Emotes:Client:PlayAnimation", src, animations[emote])
            end
        else
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = ('"%s" is not a valid animation'):format(emote), length = 5000})
        end
    else
        if dogAnimations[emote] then
            TriggerClientEvent("Emotes:Client:PlayAnimation", src, dogAnimations[emote])
        else
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = ('"%s" is not a valid dog animation'):format(emote), length = 5000})
        end
    end
end

-- ***********************
--        Commands
-- ***********************
RegisterCommand("walk", function(source, args)
    local src = source
    DoWalkstyle(src, args[1])
end)

RegisterCommand("mood", function(source, args)
    local src = source
    DoFacialExpression(src, args[1])
end)

RegisterCommand("aim", function(source, args)
    local src = source
    DoAimingStyle(src, args[1])
end)

RegisterCommand("emotemenu", function(source)
    local src = source
    TriggerClientEvent("Emotes:Client:OpenEmoteMenu", src)
end)

RegisterCommand("bindemote", function(source, args)
    local src = source
    UpdateSavedBinds(src, tonumber(args[1]), tostring(args[2]))
end)

RegisterCommand("dance", function(source, args)
    local src = source
    TriggerClientEvent("Emotes:Client:DoDanceAnim", src, args[1] == nil and -1 or tonumber(args[1]))
end)

RegisterCommand("dances", function(source)
    local src = source
    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = ("There are %s dances"):format(#danceAnimations), length = 5000})
end)

RegisterCommand("e", function(source, args)
    local src = source
    if (args[1] ~= nil) then
        PlayEmote(src, args[1]:lower())
    end
end)

RegisterCommand("emote", function(source, args)
    local src = source
    if (args[1] ~= nil) then
        PlayEmote(src, args[1]:lower())
    end
end)

-- WHEN TRIGGERED, PRINT A LIST OF USABLE MOODS IN THE CHAT
RegisterCommand("moods", function(source)
    local src = source
    local msg = ""
    for mood in pairs(faceExpressions) do
        msg = msg .. "" .. mood .. ", "
    end
    TriggerClientEvent("Chat:Client:Message", src, "[Moods]", msg, "emotes")
end)

-- WHEN TRIGGERED, PRINT A LIST OF USABLE WALKSTYLES IN THE CHAT
RegisterCommand("walks", function(source)
    local src = source
    local msg = ""
    for walkstyle in pairs(walkstyles) do
        msg = msg .. "" .. walkstyle .. ", "
    end
    TriggerClientEvent("Chat:Client:Message", src, "[Walkstyles]", msg, "emotes")
end)

-- WHEN TRIGGERED, PRINT A LIST OF USABLE NORMAL ANIMATIONS IN THE CHAT
RegisterCommand("emotes", function(source)
    local src = source
    local msg = ""
    for emoteID in pairs(animations) do
        msg = msg .. "" .. emoteID .. ", "
    end
    TriggerClientEvent("Chat:Client:Message", src, "[Emotes]", msg, "emotes")
end)

-- WHEN TRIGGERED, PRINT A LIST OF USABLE SHARED ANIMATIONS IN THE CHAT
RegisterCommand("sharedemotes", function(source)
    local src = source
    local msg = ""
    for emoteID, emoteData in pairs(animations) do
        if emoteData.shared then
            msg = msg .. "" .. emoteID .. ", "
        end
    end
    TriggerClientEvent("Chat:Client:Message", src, "[Shared Emotes]", msg, "emotes")
end)

-- WHEN TRIGGERED, LOOK FOR THE CLOSEST PLAYER AND REQUEST A SYNCED EMOTE
RegisterCommand("nearby", function(source, args)
    local src = source
    if exports["soe-utils"]:IsModelADog(GetPlayerPed(src)) then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Cannot do this whilst you are an animal!", length = 5000})
        return
    end

    if (args[1] ~= nil) then
        local emote = args[1]:lower()
        if animations[emote] then
            if animations[emote].shared then
                TriggerClientEvent("Emotes:Client:GetClosestForSync", src, {status = true, emote = emote})
            else
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "This emote cannot be shared with others", length = 5000})
            end
        else
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = ('"%s" is not a valid animation'):format(emote), length = 5000})
        end
    else
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Please specify an emote", length = 5000})
    end
end)

-- ***********************
--         Events
-- ***********************
-- WHEN TRIGGERED, PERFORM CONFIRMATION OF EMOTE REQUEST
RegisterNetEvent("Emotes:Server:RespondEmoteRequest")
AddEventHandler("Emotes:Server:RespondEmoteRequest", function(data)
    local src = source
    PerformEmoteRequestConfirmation(src, data)
end)

-- WHEN TRIGGERED, REMOVE ACTIVE EMOTE REQUEST IF THERE IS ONE
AddEventHandler("playerDropped", function()
    local src = source
    if emoteRequests[src] then
        emoteRequests[src].active = false
    end
end)

-- WHEN TRIGGERED, GET CHARACTER'S DEFAULT WALKSTYLE
RegisterNetEvent("Emotes:Server:GetMyWalkstyle")
AddEventHandler("Emotes:Server:GetMyWalkstyle", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 2844-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 2844-2 | Lua-Injecting Detected.", 0)
        return
    end

    -- GET CHARACTER'S DEFAULT WALKSTYLE FROM THE DB
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    local requestWalkstyle = exports["soe-nexus"]:PerformAPIRequest("/api/character/settings", ("charid=%s"):format(charID), true)
    if requestWalkstyle.status then
        local charSettings = json.decode(requestWalkstyle.data)
        TriggerClientEvent("Emotes:Client:GetMyWalkstyle", src, charSettings["walkstyle"])
    else
        TriggerClientEvent("Emotes:Client:GetMyWalkstyle", src, nil)
    end
end)

-- WHEN TRIGGERED, INITIATE THIS RESOURCE AND SEND SOURCE SOME DATA
RegisterNetEvent("Emotes:Server:InitResource")
AddEventHandler("Emotes:Server:InitResource", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 2842-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 2842-2 | Lua-Injecting Detected.", 0)
        return
    end

    -- GET CHARACTER'S DEFAULT WALKSTYLE FROM THE DB
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    local requestWalkstyle = exports["soe-nexus"]:PerformAPIRequest("/api/character/settings", ("charid=%s"):format(charID), true)
    if requestWalkstyle.status then
        local charSettings = json.decode(requestWalkstyle.data)
        TriggerClientEvent("Emotes:Client:GetMyWalkstyle", src, charSettings["walkstyle"])
    else
        TriggerClientEvent("Emotes:Client:GetMyWalkstyle", src, nil)
    end

    Wait(2500)
    -- POINTING NATIVE SENDING TO SOURCE (YES THIS IS JANKY AF BUT THE MOST RELIABLE POINTING SCRIPT OUT THERE) - Ghost 5/24/21
    TriggerClientEvent("Emotes:Client:ReceivePointingNatives", src, {
        {"15400973881305242190", "__GetPlayerPed", "Pitch", "__Pitch"},
        {"15400973881305242190", "__GetPlayerPed", "Heading", "__Heading"},
        {"15400973881305242190", "__GetPlayerPed", "Speed", 0},
        {"12729089900991484040", "__GetPlayerPed", "isBlocked", 0},
        {"12729089900991484040", "__GetPlayerPed", "isFirstPerson", 0},
        {"1807067481085428835", "__GetPlayerPed", 36, 1},
        {"3266090088685725238", "__GetPlayerPed", "task_mp_pointing", 0.5, 0, "anim@mp_point", 24},
        {"0xD3BD40951412FEF6", "anim@mp_point"},
        {"0xD031A9162D01088C", "anim@mp_point"}
    })
end)

-- WHEN TRIGGERED, BEGIN EMOTE REQUEST FOR SOURCE AND TARGET
AddEventHandler("Emotes:Server:SendEmoteRequest", function(cb, src, target, emote)
    if not target then cb({accepted = false}) return end
    if not emote then cb({accepted = false}) return end

    -- CHECK IF THE TARGET ALREADY HAS AN ACTIVE REQUEST GOING
    if emoteRequests[target] and emoteRequests[target].active then
        cb({accepted = false})
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Target already has a request active", length = 5000})
        return
    end

    -- BEGIN CONFIRMATION LOOP
    local loopIndex = 0
    emoteRequests[target] = {active = true, accepted = nil, emote = emote}
    TriggerClientEvent("Emotes:Client:EmoteRequestNotify", target, {status = true, emote = emote})
    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = 'Emote request of "' .. emote .. '" has been sent!', length = 5000})

    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[target]
    local msg = ("HAS REQUESTED %s (%s / %s) TO DO SHARED EMOTE %s"):format(char.Username, char.FirstGiven, char.LastGiven, emote)
    exports["soe-logging"]:ServerLog("Shared Emote Request", msg, src)

    while emoteRequests[target].active do
        Wait(250)
        -- TIMER ON HOW LONG A REQUEST CAN BE ACTIVE
        loopIndex = loopIndex + 1
        if (loopIndex >= 95) then
            emoteRequests[target].active = false
            break
        end

        -- SECURITY DISTANCE CHECK
        if #(GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(target))) > 3.5 then
            emoteRequests[target].active = false
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Target moved too far away!", length = 5000})
            TriggerClientEvent("Emotes:Client:PerformEmoteRequest", target, {status = true, emote = emote, response = false})

            msg = ("WAS TOO FAR FROM %s (%s / %s) TO DO SHARED EMOTE %s"):format(char.Username, char.FirstGiven, char.LastGiven, emote)
            exports["soe-logging"]:ServerLog("Shared Emote Request - Too Far From Target", msg, src)
            break
        end

        -- CHECK IF ACCEPTED OR DENIED
        if emoteRequests[target].accepted then
            emoteRequests[target].active = false
            TriggerClientEvent("Emotes:Client:PerformEmoteRequest", target, {status = true, src = src, emote = emote, response = true})

            msg = ("DID SHARED EMOTE %s WITH %s (%s / %s)"):format(emote, char.Username, char.FirstGiven, char.LastGiven)
            exports["soe-logging"]:ServerLog("Shared Emote Request - Accepted By Target", msg, src)
            break
        elseif (emoteRequests[target].accepted == false) then
            emoteRequests[target].active = false
            TriggerClientEvent("Emotes:Client:PerformEmoteRequest", target, {status = true, emote = emote, response = false})

            msg = ("WAS REJECTED FROM DOING SHARED EMOTE %s WITH %s (%s / %s)"):format(emote, char.Username, char.FirstGiven, char.LastGiven)
            exports["soe-logging"]:ServerLog("Shared Emote Request - Denied By Target", msg, src)
            break
        end
    end

    cb({accepted = emoteRequests[target].accepted})
    emoteRequests[target] = nil
end)
