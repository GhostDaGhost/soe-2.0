-- ***********************
--        Commands
-- ***********************
-- WHEN TRIGGERED, MUTE BOOMBOXES OR UNMUTE THEM
RegisterCommand("muteboombox", function(source)
    local src = source
    local userSettings = json.decode(exports["soe-uchuu"]:GetOnlinePlayerList()[src].UserSettings)
    if not userSettings["mutedBoomboxes"] then
        exports["soe-uchuu"]:UpdateUserSettings(src, "mutedBoomboxes", false, true)
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Boomboxes: Muted", length = 5000})
    else
        exports["soe-uchuu"]:UpdateUserSettings(src, "mutedBoomboxes", true)
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Boomboxes: Unmuted", length = 5000})
    end
end)

-- ***********************
--         Events
-- ***********************
-- WHEN TRIGGERED, PAUSE A BOOMBOX BY ITS ID
RegisterNetEvent("UX:Server:PauseBoombox")
AddEventHandler("UX:Server:PauseBoombox", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 5545-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 5545-2 | Lua-Injecting Detected.", 0)
        return
    end
    TriggerClientEvent("UX:Client:PauseBoombox", -1, data)

    -- LOG AND NOTIFY THE STATUS OF THE BOOMBOX
    if not data.paused then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "You pause the boombox", length = 5000})
    else
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "You unpaused the boombox", length = 5000})
    end

    local msg = ("HAS PAUSED A BOOMBOX | UID: %s | STATUS: %s"):format(data.uid, data.paused)
    exports["soe-logging"]:ServerLog("Boombox Paused", msg, src)
end)

-- WHEN TRIGGERED, START A BOOMBOX'S MUSIC BY ITS ID
RegisterNetEvent("UX:Server:SyncBoombox")
AddEventHandler("UX:Server:SyncBoombox", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 5546-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 5546-2 | Lua-Injecting Detected.", 0)
        return
    end

    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "You put some music on the boombox", length = 5000})
    TriggerClientEvent("UX:Client:SyncBoombox", -1, data)

    local msg = ("HAS STARTED USING A BOOMBOX | UID: %s | URL: %s | NET ID: %s"):format(data.uid, data.musicURL, data.netID)
    exports["soe-logging"]:ServerLog("Boombox Usage", msg, src)
end)
