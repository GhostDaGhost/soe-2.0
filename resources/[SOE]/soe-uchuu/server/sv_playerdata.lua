onlinePlayers = {}

-- **********************
--    Local Functions
-- **********************
-- RECORDS BOTH CHARACTER AND USER PLAYTIME ON DISCONNECTION
local function RecordPlaytimes(src, playtime)
    -- RECORD CHARACTER PLAYTIME
    local charID = onlinePlayers[src].CharID
    if (charID ~= nil) then
        local myCharPlaytime = exports["soe-nexus"]:PerformAPIRequest("/api/character/playtime", ("charid=%s"):format(charID), true)
        myCharPlaytime = tonumber(myCharPlaytime.data) + playtime
        exports["soe-nexus"]:PerformAPIRequest("/api/character/playtime", ("charid=%s&playtime=%s"):format(charID, myCharPlaytime), true)
    end

    -- RECORD USER PLAYTIME
    local userID = onlinePlayers[src].UserID
    if (userID ~= nil) then
        local myUserPlaytime = exports["soe-nexus"]:PerformAPIRequest("/api/user/playtime", ("userid=%s"):format(userID), true)
        myUserPlaytime = tonumber(myUserPlaytime.data) + playtime
        exports["soe-nexus"]:PerformAPIRequest("/api/user/playtime", ("userid=%s&playtime=%s"):format(userID, myUserPlaytime), true)
    end
end

-- **********************
--    Global Functions
-- **********************
-- RETURNS USER/CHARACTER DATA FOR A SOURCE
function GetOnlinePlayerList()
    return onlinePlayers
end

-- RETURNS SOURCE IF ONLINE FROM CHARACTER ID
function GetSourceByCharacterID(charID)
    for src, playerData in pairs(onlinePlayers) do
        if (tonumber(playerData.CharID) == charID) then
            return src
        end
    end
    return nil
end

-- WHEN TRIGGERED, UPDATE PLAYER DATA
function UpdatePlayerData(src, parameter, value, setSource)
    if setSource then
        onlinePlayers[setSource][parameter] = value
    else
        onlinePlayers[src][parameter] = value
    end
end

-- WHEN TRIGGERED, UPDATE USER SETTINGS
function UpdateUserSettings(src, setting, remove, data)
    local userID = onlinePlayers[src].UserID
    if not userID then return end

    local dataString
    if remove then
        dataString = ("userid=%s&setting=%s&delete=%s"):format(userID, setting, remove)
    else
        dataString = ("userid=%s&setting=%s&data=%s"):format(userID, setting, data)
    end

    -- UPDATE OUR CURRENT SERVER DATA
    local modifySettings = exports["soe-nexus"]:PerformAPIRequest("/api/user/settings", dataString, true)
    if modifySettings.status then
        onlinePlayers[src]["UserSettings"] = modifySettings.data
        TriggerClientEvent("Uchuu:Client:UpdatePlayerData", src, {status = true, parameter = "UserSettings", paramData = modifySettings.data})
    end
end

-- WHEN TRIGGERED, UPDATE CHARACTER GAMESTATE
function UpdateGamestate(src, gamestate, remove, data)
    local charID = onlinePlayers[src].CharID
    if not charID then return end

    local dataString
    if remove then
        dataString = ("charid=%s&gamestate=%s&delete=%s"):format(charID, gamestate, remove)
    else
        dataString = ("charid=%s&gamestate=%s&data=%s"):format(charID, gamestate, data)
    end

    -- UPDATE OUR CURRENT SERVER DATA
    --print(("[Gamestate Update] | [Character ID: %s] | [State: %s] | [Remove State: %s] | [Data: %s] | [Success: Pending]"):format(charID, gamestate, remove, data))
    local modifyGamestate = exports["soe-nexus"]:PerformAPIRequest("/api/character/gamestate", dataString, true)
    if modifyGamestate.status then
        --print(("[Gamestate Update] | [Character ID: %s] | [State: %s] | [Remove State: %s] | [Data: %s] | [Success: True]"):format(charID, gamestate, remove, data))
        onlinePlayers[src]["Gamestate"] = modifyGamestate.data
        TriggerClientEvent("Uchuu:Client:UpdatePlayerData", src, {status = true, parameter = "Gamestate", paramData = modifyGamestate.data})
    else
        --print(("[Gamestate Update] | [Character ID: %s] | [State: %s] | [Remove State: %s] | [Data: %s] | [Success: False]"):format(charID, gamestate, remove, data))
    end
end

-- WHEN TRIGGERED, UPDATE CHARACTER SETTINGS
function UpdateCharacterSettings(src, setting, remove, data)
    local charID = onlinePlayers[src].CharID
    if not charID then return end

    local dataString
    if remove then
        dataString = ("charid=%s&setting=%s&delete=%s"):format(charID, setting, remove)
    else
        dataString = ("charid=%s&setting=%s&data=%s"):format(charID, setting, data)
    end

    -- UPDATE OUR CURRENT SERVER DATA
    --print(("[Character Settings Update] | [Character ID: %s] | [State: %s] | [Remove State: %s] | [Data: %s] | [Success: Pending]"):format(charID, setting, remove, data))
    local modifyCharSettings = exports["soe-nexus"]:PerformAPIRequest("/api/character/settings", dataString, true)
    if modifyCharSettings.status then
        --print(("[Character Settings Update] | [Character ID: %s] | [State: %s] | [Remove State: %s] | [Data: %s] | [Success: True]"):format(charID, setting, remove, data))
        onlinePlayers[src]["Settings"] = modifyCharSettings.data
        TriggerClientEvent("Uchuu:Client:UpdatePlayerData", src, {status = true, parameter = "Settings", paramData = modifyCharSettings.data})
    else
        --print(("[Character Settings Update] | [Character ID: %s] | [State: %s] | [Remove State: %s] | [Data: %s] | [Success: False]"):format(charID, setting, remove, data))
    end
end

-- **********************
--        Events
-- **********************
-- UPDATES OR ADDS A PARAMETER FOR A PLAYER
RegisterNetEvent("Uchuu:Server:UpdatePlayerData")
AddEventHandler("Uchuu:Server:UpdatePlayerData", function(parameter, value, setSource)
    local src = source
    UpdatePlayerData(src, parameter, value, setSource)
end)

-- WHEN TRIGGERED, UPDATE PLAYER DATA IN "BULK"
RegisterNetEvent("Uchuu:Server:UpdatePlayerDataBulk")
AddEventHandler("Uchuu:Server:UpdatePlayerDataBulk", function(dataToUpdate, setSource)
    if setSource then
        for parameter, value in pairs(dataToUpdate) do
            onlinePlayers[setSource][parameter] = value
        end
    else
        for parameter, value in pairs(dataToUpdate) do
            onlinePlayers[source][parameter] = value
        end
    end
end)

-- INSERT NEW PLAYER INTO PLAYERDATA ONCE THEY LOAD
RegisterNetEvent("Uchuu:Server:InsertNewPlayer")
AddEventHandler("Uchuu:Server:InsertNewPlayer", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 4235-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 4235-2 | Lua-Injecting Detected.", 0)
        return
    end

    -- GET PLAYER IDENTIFIERS
    local identifiers = exports["soe-utils"]:GetIdentifiersFromSource(src)

    -- INITIALIZE ENTRY IN ONLINE PLAYERS TABLE - BASIC DATA ONLY
    onlinePlayers[src] = {}
    onlinePlayers[src]["identifiers"] = identifiers
    onlinePlayers[src]["timeJoined"] = os.time()
    onlinePlayers[src]["loggedIn"] = false
end)

-- WHEN TRIGGERED, RECORD PLAYTIMES AND LOG EXIT AND CLEAR PLAYER DATA
AddEventHandler("playerDropped", function(reason)
    local src = source
    if onlinePlayers[src] then
        local username
        local totalPlaytime = os.time() - onlinePlayers[src]["timeJoined"]
        if (onlinePlayers[src]["Username"] == nil) then
            username = GetPlayerName(src)
        else
            username = onlinePlayers[src]["Username"]
        end

        -- SEND EXIT MESSAGE TO STAFF AND LOG THE DISCONNECTION
        exports["soe-crime"]:RestoreDrugRunReputation(src)
        exports["soe-logging"]:ServerLog("Player Disconnected", ("HAS LEFT THE SERVER | PLAYTIME: %s | REASON: %s"):format(totalPlaytime, reason), src)
        for playerID, playerData in pairs(onlinePlayers) do
            local userSettings = json.decode(playerData.UserSettings)
            if userSettings then
                if not userSettings["mutedExitMsgs"] then
                    if IsStaff(playerID) then
                        TriggerClientEvent("Chat:Client:SendMessage", playerID, "me", ("^2* %s left (%s)"):format(tostring(username), reason))
                    end
                end
            end
        end
        RecordPlaytimes(src, totalPlaytime)
        onlinePlayers[src] = nil
    end
end)

-- UPDATES PLAYER'S LAST KNOWN LOCATION
RegisterNetEvent("Uchuu:Server:UpdateLastPosition")
AddEventHandler("Uchuu:Server:UpdateLastPosition", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 867 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 866 | Lua-Injecting Detected.", 0)
        return
    end

    -- INSTANCE CHECK
    if (exports["soe-instance"]:GetPlayerInstance(src) ~= "global") then
        return
    end

    -- POSITION GRABBER
    local pos = GetEntityCoords(GetPlayerPed(src))
    local position = {x = pos.x, y = pos.y, z = pos.z}
    if data.pos then
        position = {x = data.pos.x, y = data.pos.y, z = data.pos.z}
    end
    UpdateGamestate(src, "position", false, json.encode(position))
end)

-- UPDATES OR ADDS A GAMEDATA PARAMETER FOR A PLAYER
RegisterNetEvent("Uchuu:Server:UpdateGamestate")
AddEventHandler("Uchuu:Server:UpdateGamestate", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 4444-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 4444-2 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.gamestate then return end
    UpdateGamestate(src, data.gamestate, data.remove, data.gamestateData)
end)

-- UPDATES OR ADDS A SETTING FOR A PLAYER
RegisterNetEvent("Uchuu:Server:UpdateCharacterSettings")
AddEventHandler("Uchuu:Server:UpdateCharacterSettings", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 4445-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 4445-2 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.setting then return end
    UpdateCharacterSettings(src, data.setting, data.remove, data.settingData)
end)

-- WHEN TRIGGERED, UPDATES OR ADDS A SETTING FOR A PLAYER
RegisterNetEvent("Uchuu:Server:UpdateUserSettings", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 44482-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 44482-2 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.setting then return end
    UpdateUserSettings(src, data.setting, data.remove, data.settingData)
end)
