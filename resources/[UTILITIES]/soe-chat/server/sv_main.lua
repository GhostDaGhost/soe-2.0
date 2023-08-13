-- RECORDS PLAYER PET NAMES
local petNames = {}

-- RECORDS STATUS MESSAGES
local statusMessages = {}

-- **********************
--    Local Functions
-- **********************
-- SETS/CLEARS STATUS MESSAGE
local function SetStatusMessage(src, msg)
    if statusMessages[src] then
        if (msg == "clear" or msg == nil or msg == "") then
            statusMessages[src] = nil
            TriggerClientEvent("Chat:Client:GetStatusMessages", -1, statusMessages)
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "You cleared your status message", length = 5000})
            return
        end
    end

    statusMessages[src] = {status = true, src = src, name = GetDisplayName(src), message = msg}
    TriggerClientEvent("Chat:Client:GetStatusMessages", -1, statusMessages)
    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "You set your status message to: " .. msg, length = 5000})
end

-- GETS USERNAME AND ADDS STAFF TAG IF POSSIBLE
local function GetUsername(src)
    local name
    local staffRank = exports["soe-uchuu"]:GetStaffRank(src)
    local username = exports["soe-uchuu"]:GetOnlinePlayerList()[src].Username
    local muteStaffTag = json.decode(exports["soe-uchuu"]:GetOnlinePlayerList()[src].UserSettings)["muteStaffTag"]

    -- ADD STAFF TAG IF PLAYER IS PART OF STAFF AND NOT MUTED STAFF TAG
    local username = tostring(username)
    if not muteStaffTag then
        if staffRank == "admin" then
            name = ("^1[Admin] ^7%s"):format(username)
        elseif staffRank == "moderator" then
            name = ("^1[Moderator] ^7%s"):format(username)
        elseif staffRank == "developer" then
            name = ("^1[Developer] ^7%s"):format(username)
        else
            name = username
        end
    else
        name = username
    end
    return name
end

-- **********************
--       Functions
-- **********************
-- RETURNS A DISPLAY NAME OF THEIR CHARACTER, (EXAMPLE: Deputy Rhodes)
function GetDisplayName(src)
    local myJob = exports["soe-jobs"]:GetJob(src)
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]

    if (petNames[char.CharID] == "" or petNames[char.CharID] == nil) then
        if (myJob == "POLICE" or myJob == "EMS" or myJob == "DISPATCH" or myJob == "DOJ" or myJob == "GOV") then
            return char.JobTitle .. " " .. char.LastGiven
        else
            return char.FirstGiven
        end
    else
        return petNames[char.CharID]
    end
end

-- WHEN TRIGGERED, DO A PROXIMITY MESSAGE
function DoProximityMessage(src, dist, type, prefix, charName, msg)
    local pos = GetEntityCoords(GetPlayerPed(src))
    for playerID in pairs(exports["soe-uchuu"]:GetOnlinePlayerList()) do
        if #(GetEntityCoords(GetPlayerPed(playerID)) - pos) <= dist then
            if (type == "me") then
                TriggerClientEvent("Chat:Client:Message", playerID, prefix, ("%s %s"):format(charName, msg), "me")
            elseif (type == "me-2") then
                TriggerClientEvent("Chat:Client:Message", playerID, prefix, ("%s %s"):format(charName, msg), "me-2")
            elseif (type == "do") then
                TriggerClientEvent("Chat:Client:Message", playerID, prefix, ("%s ((%s))"):format(msg, charName), "do")
            elseif (type ~= "" and charName == "") then
                TriggerClientEvent("Chat:Client:Message", playerID, prefix, msg, type)
            else
                TriggerClientEvent("Chat:Client:Message", playerID, ("%s %s"):format(prefix, charName), msg, "looc")
            end
        end
    end

    exports["soe-logging"]:ServerLog("Proximity Message", ("DID A PROXIMITY MESSAGE | TYPE: %s | PREFIX: %s | MSG: %s | DISTANCE: %s"):format(type, prefix, msg, dist), src)
end
exports("DoProximityMessage", DoProximityMessage)

-- **********************
--       Commands
-- **********************
RegisterCommand("status", function(source, args)
    local src = source
    SetStatusMessage(src, table.concat(args, " "))
end)

RegisterCommand("me", function(source, args)
    local src = source
    local msg = table.concat(args, " ")
    DoProximityMessage(src, 10.0, "me", "", GetDisplayName(src), msg)

    exports["soe-logging"]:ServerLog("'Me' Message", "DID A /me OF: " .. msg, src)
end)

RegisterCommand("do", function(source, args)
    local src = source
    local msg = table.concat(args, " ")
    DoProximityMessage(src, 10.0, "do", "", GetDisplayName(src), msg)

    exports["soe-logging"]:ServerLog("'Do' Message", "DID A /do OF: " .. msg, src)
end)

RegisterCommand("l", function(source, args)
    local src = source
    local msg = table.concat(args, " ")
    local name = ("[%s] %s"):format(src, GetUsername(src))
    DoProximityMessage(src, 10.0, "looc", "[Local OOC]", name, msg)

    exports["soe-logging"]:ServerLog("Local OOC Message", "DID A /l OF: " .. msg, src)
end)

RegisterCommand("ooc", function(source, args)
    local src = source
    local msg = table.concat(args, " ")
    local name = ("[%s] %s"):format(src, GetUsername(src))
    DoProximityMessage(src, 10.0, "looc", "[Local OOC]", name, msg)

    exports["soe-logging"]:ServerLog("Local OOC Message", "DID A /ooc OF: " .. msg, src)
end)

RegisterCommand("g", function(source, args)
    local src = source
    -- CHECK IF THE SOURCE HAS IT MUTED FIRST
    local userSettings = json.decode(exports["soe-uchuu"]:GetOnlinePlayerList()[src].UserSettings)
    if userSettings then
        if userSettings["mutedHelpChat"] then
            TriggerClientEvent("Chat:Client:Message", src, "[Help]", "You have help chat muted. Type /togglehelp to unmute it", "help")
            return
        end
    end

    -- ONLY SHOW THIS HELP CHAT TO THOSE WHO HAVE IT UNMUTED
    local name = GetUsername(src)
    local msg = table.concat(args, " ")
    for playerID, playerData in pairs(exports["soe-uchuu"]:GetOnlinePlayerList()) do
        local userSettings = json.decode(playerData.UserSettings)
        if userSettings then
            if not userSettings["mutedHelpChat"] then
                TriggerClientEvent("Chat:Client:Message", playerID, ("[Help] [%s] %s"):format(src, name), msg, "help")
            end
        end
    end
    exports["soe-logging"]:ServerLog("Global Help Message", "DID A HELP CHAT MSG OF: " .. msg, src)
end)

RegisterCommand("a", function(source, args)
    local src = source
    local name = GetUsername(src)
    local msg = table.concat(args, " ")
    if not exports["soe-uchuu"]:IsStaff(src) then
        TriggerClientEvent("Chat:Client:Message", src, ("[Message To Staff] [%s] %s"):format(src, name), msg, "system")
    else
        -- CHECK IF THE SOURCE HAS IT MUTED FIRST
        local userSettings = json.decode(exports["soe-uchuu"]:GetOnlinePlayerList()[src].UserSettings)
        if userSettings then
            if userSettings["mutedStaffChat"] then
                TriggerClientEvent("Chat:Client:Message", src, "[Staff Chat]", "You have staff chat muted. Type /togglestaffchat to unmute it", "system")
                return
            end
        end
    end

    for playerID, playerData in pairs(exports["soe-uchuu"]:GetOnlinePlayerList()) do
        local userSettings = json.decode(playerData.UserSettings)
        if userSettings then
            if not userSettings["mutedStaffChat"] then
                if exports["soe-uchuu"]:IsStaff(playerID) then
                    TriggerClientEvent("Chat:Client:Message", playerID, ("[Staff Chat] [%s] %s"):format(src, name), msg, "system")
                end
            end
        end
    end
    exports["soe-logging"]:ServerLog("Staff Chat Message", "DID A STAFF CHAT MSG OF: " .. msg, src)
end)

-- WHEN TRIGGERED, MUTE HELP CHAT OR UNMUTE IT
RegisterCommand("togglehelp", function(source)
    local src = source
    local userSettings = json.decode(exports["soe-uchuu"]:GetOnlinePlayerList()[src].UserSettings)
    if not userSettings["mutedHelpChat"] then
        exports["soe-uchuu"]:UpdateUserSettings(src, "mutedHelpChat", false, true)
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Help Chat: Muted", length = 5000})
    else
        exports["soe-uchuu"]:UpdateUserSettings(src, "mutedHelpChat", true)
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Help Chat: Unmuted", length = 5000})
    end
end)

-- WHEN TRIGGERED, MUTE STAFF CHAT OR UNMUTE IT
RegisterCommand("togglestaffchat", function(source)
    local src = source
    if not exports["soe-uchuu"]:IsStaff(src) then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You are not staff", length = 5000})
        return
    end

    local userSettings = json.decode(exports["soe-uchuu"]:GetOnlinePlayerList()[src].UserSettings)
    if not userSettings["mutedStaffChat"] then
        exports["soe-uchuu"]:UpdateUserSettings(src, "mutedStaffChat", false, true)
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Staff Chat: Muted", length = 5000})
    else
        exports["soe-uchuu"]:UpdateUserSettings(src, "mutedStaffChat", true)
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Staff Chat: Unmuted", length = 5000})
    end
end)

-- WHEN TRIGGERED, MUTE EXIT MESSAGES OR UNMUTE IT
RegisterCommand("toggleexitmsgs", function(source)
    local src = source
    if not exports["soe-uchuu"]:IsStaff(src) then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You are not staff", length = 5000})
        return
    end

    local userSettings = json.decode(exports["soe-uchuu"]:GetOnlinePlayerList()[src].UserSettings)
    if not userSettings["mutedExitMsgs"] then
        exports["soe-uchuu"]:UpdateUserSettings(src, "mutedExitMsgs", false, true)
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Exit Messages: Muted", length = 5000})
    else
        exports["soe-uchuu"]:UpdateUserSettings(src, "mutedExitMsgs", true)
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Exit Messages: Unmuted", length = 5000})
    end
end)

RegisterCommand("pet", function(source, args)
    local src = source
    local civType = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CivType
    if (civType == "EMS" or civType == "POLICE") or exports["soe-uchuu"]:IsStaff(src) then
        local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
        if (args[1] ~= nil) then
            petNames[charID] = args[1]
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "You set your pet name to: " .. tostring(args[1]), length = 5000})
        else
            petNames[charID] = nil
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "You reset your pet name", length = 5000})
        end
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available to Emergency Services.")
    end
end)

RegisterCommand("pm", function(source, args)
    local src = source
    local target = tonumber(args[1])
    if (target == nil) then return end

    -- CHECK IF PLAYER EVEN EXISTS TO PREVENT ERRORS
    if not DoesEntityExist(GetPlayerPed(target)) then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Player ID not active or invalid", length = 5000})
        return
    end

    table.remove(args, 1)
    local msg = table.concat(args, " ")

    -- WHAT WAS SENT
    local receiver = exports["soe-uchuu"]:GetOnlinePlayerList()[target].Username
    if not receiver then
        receiver = "(NOT LOGGED IN)"
    end
    TriggerClientEvent("Chat:Client:Message", src, ("[PM] To %s [%s]"):format(tostring(receiver), target), msg, "pm")

    -- WHAT WAS RECEIVED
    local sender = exports["soe-uchuu"]:GetOnlinePlayerList()[src].Username
    if not sender then
        sender = "(NOT LOGGED IN)"
    end
    TriggerClientEvent("Chat:Client:Message", target, ("[PM] From %s [%s]"):format(tostring(sender), src), msg, "pm")

    -- LOG PM
    exports["soe-logging"]:ServerLog("Private Message", ("SENT A PRIVATE MESSAGE TO %s WITH MESSAGE: %s"):format(receiver, msg), src)
end)

-- WHEN TRIGGERED, TOGGLE ON/OFF STAFF TAG INFRONT OF CHAT MESSAGE
RegisterCommand("togglestafftag", function(source)
    local src = source
    if not exports["soe-uchuu"]:IsStaff(src) then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You are not staff", length = 5000})
        return
    end

    local userSettings = json.decode(exports["soe-uchuu"]:GetOnlinePlayerList()[src].UserSettings)
    if not userSettings["muteStaffTag"] then
        exports["soe-uchuu"]:UpdateUserSettings(src, "muteStaffTag", false, true)
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Staff Tag In Messages: Muted", length = 5000})
    else
        exports["soe-uchuu"]:UpdateUserSettings(src, "muteStaffTag", true)
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Staff Tag In Messages: Unmuted", length = 5000})
    end
end)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, DO A PROXIMITY MESSAGE
RegisterNetEvent("Chat:Server:ProximityMsg")
AddEventHandler("Chat:Server:ProximityMsg", function(dist, type, prefix, charName, msg)
    local src = source
    DoProximityMessage(src, dist, type, prefix, charName, msg)
end)

RegisterNetEvent("Chat:Server:SendToLEOs")
AddEventHandler("Chat:Server:SendToLEOs", function(prefix, message, type)
    for src in pairs(exports["soe-uchuu"]:GetOnlinePlayerList()) do
        local myJob = exports["soe-jobs"]:GetJob(src)
        if (myJob == "POLICE" or myJob == "DISPATCH") then
            TriggerClientEvent("Chat:Client:Message", src, prefix, message, type)
        end
    end
end)

RegisterNetEvent("Chat:Server:SendToEMS")
AddEventHandler("Chat:Server:SendToEMS", function(prefix, message, type)
    for src in pairs(exports["soe-uchuu"]:GetOnlinePlayerList()) do
        local myJob = exports["soe-jobs"]:GetJob(src)
        if (myJob == "EMS" or myJob == "DISPATCH") then
            TriggerClientEvent("Chat:Client:Message", src, prefix, message, type)
        end
    end
end)

RegisterNetEvent("Chat:Server:SendToJointES")
AddEventHandler("Chat:Server:SendToJointES", function(prefix, message, type)
    for playerID in pairs(exports["soe-uchuu"]:GetOnlinePlayerList()) do
        local myJob = exports["soe-jobs"]:GetJob(playerID)
        if (myJob == "POLICE" or myJob == "EMS" or myJob == "DISPATCH") then
            TriggerClientEvent("Chat:Client:Message", playerID, prefix, message, type)
        end
    end
end)

RegisterNetEvent("Chat:Server:GetStatusMessages", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 640 | Lua-Injecting Detected.", 0)
        return
    end

    TriggerClientEvent("Chat:Client:GetStatusMessages", src, statusMessages)
end)
