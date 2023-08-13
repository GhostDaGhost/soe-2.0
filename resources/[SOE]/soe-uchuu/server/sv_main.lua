onlineStaff = {admin = {}, moderator = {}, developer = {}}

-- SETS MAP NAME UPON SERVER START-UP
SetMapName("SoE")

-- ***********************
--      HTTP Handler
-- ***********************
-- SERVER JSON FILE WITH ONLINE STAFF ROSTER WHEN REQUESTED
SetHttpHandler(function(req, res)
    if (req.path == "/onlinestaff.json") then
        res.send(json.encode(onlineStaff))
    end
end)

-- **********************
--    Local Functions
-- **********************
-- CHECKS OS TIME FOR RESTART WARNINGS
local function CheckRestartTime()
    local currentTime = os.date("%H:%M:%S", os.time())
    if (currentTime == "00:50:00") then
        print("10 minute restart warning given.")
        TriggerClientEvent("Chat:Client:Message", -1, "[National Weather Service]", "The National Weather Service has issued a tsunami warning. Estimated arrival is in 10 minutes. (Server Restart)", "dev")
    elseif (currentTime == "00:55:00") then
        print("5 minute restart warning given.")
        TriggerClientEvent("Chat:Client:Message", -1, "[National Weather Service]", "The National Weather Service has issued a tsunami warning. Estimated arrival is in 5 minutes. (Server Restart)", "dev")
    elseif (currentTime == "00:59:00") then
        print("1 minute restart warning given.")
        TriggerClientEvent("Chat:Client:Message", -1, "[National Weather Service]", "The National Weather Service has issued a tsunami warning. Estimated arrival is in 1 minute. Please evacuate. (Server Restart)", "dev")
    end
end

-- CHECK EVERY MINUTE FOR RESTART WARNING
local function RestartWarning()
    SetTimeout(1000, function()
        CheckRestartTime()
        RestartWarning()
    end)
end
RestartWarning()

-- WHEN TRIGGERED, SHOW LIST OF STAFF ONLINE TO SOURCE
local function ShowOnlineStaff(src)
    local str = ""
    for _, serverID in pairs(onlineStaff["admin"]) do
        local userSettings = onlinePlayers[serverID].UserSettings
        if (type(userSettings) == "string") then
            userSettings = json.decode(onlinePlayers[serverID].UserSettings)
        end

        local username = onlinePlayers[serverID].Username
        if username and not userSettings["muteStaffTag"] then
            str = str .. "[" .. serverID .. "] " .. username .. " ^*|^r "
        end
    end
    TriggerClientEvent("Chat:Client:Message", src, "[Online Admins]", str, "standard")

    local str = ""
    for _, serverID in pairs(onlineStaff["moderator"]) do
        local userSettings = onlinePlayers[serverID].UserSettings
        if (type(userSettings) == "string") then
            userSettings = json.decode(onlinePlayers[serverID].UserSettings)
        end

        local username = onlinePlayers[serverID].Username
        if username and not userSettings["muteStaffTag"] then
            str = str .. "[" .. serverID .. "] " .. username .. " ^*|^r "
        end
    end
    TriggerClientEvent("Chat:Client:Message", src, "[Online Mods]", str, "standard")

    local str = ""
    for _, serverID in pairs(onlineStaff["developer"]) do
        local userSettings = onlinePlayers[serverID].UserSettings
        if (type(userSettings) == "string") then
            userSettings = json.decode(onlinePlayers[serverID].UserSettings)
        end

        local username = onlinePlayers[serverID].Username
        if username and not userSettings["muteStaffTag"] then
            str = str .. "[" .. serverID .. "] " .. username .. " ^*|^r "
        end
    end
    TriggerClientEvent("Chat:Client:Message", src, "[Online Devs]", str, "standard")
end

-- **********************
--    Global Functions
-- **********************
-- CHECKS IF PLAYER IS PART OF A STAFF GROUP
function GetStaffRank(src)
    local group, found
    for k, v in pairs(onlineStaff) do
        for key, value in pairs(v) do
            if (value == src) then
                group = k
                found = key
            end
        end
    end

    if found then
        return group
    end
end

-- CHECKS IF PLAYER IS STAFF
function IsStaff(src)
    local authorized = false
    local group = GetStaffRank(src)
    if (group == "admin") then
        authorized = true
    elseif (group == "moderator") then
        authorized = true
    elseif (group == "developer") then
        authorized = true
    end
    return authorized
end

-- **********************
--       Commands
-- **********************
-- WHEN TRIGGERED, GIVE A LIST OF STAFF ONLINE
RegisterCommand("staff", function(source)
    local src = source
    ShowOnlineStaff(src)
end)
