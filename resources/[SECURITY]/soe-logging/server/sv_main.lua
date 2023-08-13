local uploadWebhook = "https://discord.com/api/webhooks/808241455696445442/Am_gVjQBk2Rcu4qbyGN0UveUjBVNHW4xT4xeGvFgiz8fpwRQssBEZHggUhlYzldx87qQ"

-- **********************
--    Local Functions
-- **********************
-- UPLOADS SCREENSHOT TO THE SOE DISCORD STAFF CHANNELS
local function UploadScreenshot(url, reason)
    local src = source
    if exports["soe-uchuu"]:IsStaff(src) or exports["soe-uchuu"]:IsDevServer() then
        print("Not uploading anti-cheat logs to discord.")
        return
    end

    local charData
    local timestamp = os.date("%Y-%m-%d %H:%M:%S", os.time())
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    if (char.FirstGiven ~= nil) then
        local name = ("%s %s"):format(char.FirstGiven, char.LastGiven)
        charData = {{
            name = ("Character ID: %s"):format(char.CharID),
            value = ("SoE Username: %s\nSoE Forum Username: %s\n\nCharacter Name: %s\nTimestamp: %s"):format(char.Username, char.ForumAccount, name, timestamp)
        }}
    else
        charData = {{name = ("Timestamp: %s"):format(timestamp), value = "Character Not Selected Yet"}}
    end

    local data =
        json.encode({embeds = {{
            color = 9312783,
            url = url,
            title = string.format("Server ID: %s\nReason: %s", src, (reason or "No Reason Provided")),
            thumbnail = {url = "https://i.imgur.com/JceXJC5.png"},
            image = {url = url},
            fields = charData
        }}}
    )
    PerformHttpRequest(uploadWebhook, function() end, "POST", data, {["Content-Type"] = "application/json"})
end

-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, TAKE SCREENSHOT OF SOURCE'S WINDOW
function ScreenshotScreen(src, reason)
    if not src then return end
    if not reason then return end

    TriggerClientEvent("Logging:Client:TakeThisSucker", src, reason)
end

-- LOGS DATA IN THE FORM OF TEXT TO THE DATABASE
function ServerLog(type, data, src)
    if src then
        local playerInfo = "(ID: " .. src .. ")"
        local playerData = exports["soe-uchuu"]:GetOnlinePlayerList()[src]

        -- PLAYERDATA WILL ALWAYS BE NIL ON CONNECT
        if not playerData then return end

        if playerData.Username then
            playerInfo = ("%s (%s)"):format(playerInfo, playerData.Username or "Unknown Username")
        end

        if playerData.FirstGiven and playerData.LastGiven then
            playerInfo = ("%s (SSN: %s) (%s / %s)"):format(playerInfo, playerData.CharID or 0, playerData.FirstGiven or "Unknown", playerData.LastGiven or "Unknown")
        end
        data = playerInfo .. " " .. data
    end

    if type and data then
        -- IF THE LOG IS AN EXPLOIT OR ANTI-CHEAT ALERT... ALERT STAFF
        if type:match("Exploit") or type:match("Fidelis") then
            if not exports["soe-uchuu"]:IsDevServer() then
                local timestamp = os.date("%Y-%m-%d %H:%M:%S", os.time())

                local data = {{color = 9312783, title = "Fidelis Log", description = ("Type: %s \nTimestamp: %s \n\n%s"):format(type, timestamp, data)}}
                PerformHttpRequest(uploadWebhook, function() end, "POST", json.encode({username = "Fidelis", embeds = data}), {["Content-Type"] = "application/json"})
            end
        end

        local server = GetConvar("serverTag", "Undefined")
        local dataString = ("type=%s&data=%s&servertag=%s"):format(type, data, server)

        local inputLog = exports["soe-nexus"]:PerformAPIRequest("/api/log/inputlog", dataString, true)
        if exports["soe-uchuu"]:IsDevServer() then
            if inputLog and inputLog.status then
                print(("[Log - %s]"):format(type), data)
            end
        end

        -- OLD SQL QUERY ENTRY
        --exports["soe-nexus"]:execute("INSERT INTO soelog2.logs (`Type`, `Data`, `Server`) VALUES (@Type, @Data, @Server)", {Type = type, Data = logData, Server = server})
    else
        print("[Log] Invalid Entry.")
    end
end

-- **********************
--        Events
-- **********************
-- MADE TO BE ABLE TO BE CALLED FROM CLIENT
RegisterNetEvent("Logging:Server:UploadScreenshot")
AddEventHandler("Logging:Server:UploadScreenshot", UploadScreenshot)

-- MADE TO BE ABLE TO BE CALLED FROM CLIENT
RegisterNetEvent("Logging:Server:Log")
AddEventHandler("Logging:Server:Log", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 18381-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 18381-2 | Lua-Injecting Detected.", 0)
        return
    end
    ServerLog(data.type or "Unknown Type", data.logData or "Unknown Data", src)
end)
