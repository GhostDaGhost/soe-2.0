-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, UPDATE THE USER'S IP LIST IN THE DB
local function UpdateIPList(userID, usedIPs)
    exports["soe-nexus"]:PerformAPIRequest("/api/user/updateiplist", ("userid=%s&usedips=%s"):format(userID, json.encode(usedIPs)), true)
end

-- FORMAT CHARACTERS ARRAY FROM DB TO FIT CLIENT/SERVER FORMAT
local function FormatCharacters(characters)
    local charList = {}
    for _, data in pairs(characters) do
        charList[tostring(data.CharID)] = {
            ["FirstGiven"] = data.FirstGiven,
            ["LastGiven"] = data.LastGiven,
            ["DOB"] = data.DOB,
            ["Gender"] = data.Gender,
            ["Appearance"] = json.decode(data.Appearance),
            ["Gamestate"] = json.decode(data.Gamestate),
            ["PrisonTime"] = data.PrisonTime,
            ["StateDebt"] = data.StateDebt,
            ["CivType"] = data.CivType,
            ["Employer"] = data.Employer or "Citizen",
            ["JobTitle"] = data.JobTitle or "State of San Andreas",
            ["Settings"] = json.decode(data.Settings),
            ["Playtime"] = data.Playtime,
            ["FirstSeen"] = data.FirstSeen,
            ["LastSeen"] = data.LastSeen
        }
    end
    return charList
end

-- **********************
--        Events
-- **********************
-- MARKS A CHARACTER THAT THEY HAVE SPAWNED
RegisterNetEvent("Uchuu:Server:PlayerSpawned")
AddEventHandler("Uchuu:Server:PlayerSpawned", function()
    local src = source
    onlinePlayers[src]["HasSpawned"] = true
end)

-- CREATE NEW CHARACTER
AddEventHandler("Uchuu:Server:CreateNewCharacter", function(cb, src, characterData)
    local dataString = ("userid=%s&firstgiven=%s&lastgiven=%s&dob=%s&gender=%s"):format(characterData.UserID, characterData.FirstGiven, characterData.LastGiven, characterData.DOB, characterData.Gender)
    local createCharacter = exports["soe-nexus"]:PerformAPIRequest("/api/character/create", dataString, true)

    if createCharacter and createCharacter.data then
        createCharacter.data.Characters = FormatCharacters(createCharacter.data)
        cb({["status"] = createCharacter.status, ["message"] = createCharacter.message, ["data"] = createCharacter.data})
    else
        print("A fatal error occurred when attempting to create your character. Please contact a member of the staff team.")
    end
end)

-- IF A STAFF MEMBER DISCONNECTS, WIPE THEM OFF THE TABLE
AddEventHandler("playerDropped", function()
    local index, found
    local src = source

    for k, v in pairs(onlineStaff) do
        for key, value in pairs(v) do
            if (value == src) then
                index = k
                found = key
            end
        end
    end

    if found then
        table.remove(onlineStaff[index], found)
    end
end)

-- REQUESTS A CHARACTER'S PROPERTIES TO SPAWN AT
AddEventHandler("Uchuu:Server:RequestResidentialSpawnsForCharID", function(cb, src, charID)
    local spawns = {}
    local properties = exports["soe-properties"]:GetProperties()
    local myProperties = exports["soe-nexus"]:PerformAPIRequest("/api/properties/getaccessdata", ("charid=%s"):format(charID), true)

    if not myProperties or not myProperties.status then
        cb({})
    end

    for _, property in pairs(properties) do
        local hasAccess, accessType = false, nil
        for _, access in pairs(myProperties.data) do
            if access.PropertyID == property.id and (access.Access == "OWNER" or access.Access == "TENANT") then
                hasAccess = true
                accessType = access.Access
            end
        end

        if hasAccess then
            spawns[#spawns + 1] = {
                ["Name"] = "Residence - " .. property.address,
                ["Cost"] = 0,
                ["Description"] = "You're a(n) " .. accessType:lower() .. " of this property!",
                ["Message"] = "You wake up after a great night of sleep!",
                ["Coords"] = vector4(property.entrance.x, property.entrance.y, property.entrance.z, property.entrance.h),
                ["PropertyID"] = property.id
            }
        end
    end
    cb(spawns)
end)

-- ATTEMPT TO REGISTER A NEW ACCOUNT IN THE DB
AddEventHandler("Uchuu:Server:RegisterNewAccount", function(cb, src, accountData)
    local identifiers = exports["soe-utils"]:GetIdentifiersFromSource(src)
    local usedIPs = {}
    usedIPs[#usedIPs + 1] = identifiers["ip"]

    local dataString = ("ForumLogin=%s&ForumPassword=%s&Identifiers=%s&UsedIPs=%s"):format(accountData.ForumLogin, accountData.ForumPassword, json.encode(identifiers), json.encode(usedIPs))
    dataString = dataString .. "&Username=" .. accountData.Username .. "&Password=" .. accountData.Password
    local createUser = exports["soe-nexus"]:PerformAPIRequest("/api/user/create", dataString, true)

    cb({["status"] = createUser.status, ["message"] = createUser.message, ["data"] = createUser.data})
    if createUser.status then
        onlinePlayers[src]["UserID"] = createUser.data.UserID
        onlinePlayers[src]["Username"] = accountData.Username
        onlinePlayers[src]["ForumAccount"] = createUser.data.ForumAccount
        onlinePlayers[src]["LoggedIn"] = true
        onlinePlayers[src]["UserSettings"] = createUser.data.UserSettings or {}
        TriggerClientEvent("Uchuu:Client:UpdatePlayerData", src, {status = true, parameter = "UserSettings", paramData = onlinePlayers[src]["UserSettings"]})

        local found
        local usedIPs = json.decode(createUser.data.UsedIPs)
        local currentIP = exports["soe-utils"]:GetIdentifiersFromSource(src)["ip"]
        for _, ip in pairs(usedIPs) do
            if (ip == currentIP) then
                found = true
            end
        end

        if not found then
            usedIPs[#usedIPs + 1] = currentIP
            UpdateIPList(createUser.data.UserID, usedIPs)
        end
    end
end)

-- ATTEMPT TO LOGIN TO ACCOUNT BY USERNAME AND PASSWORD
AddEventHandler("Uchuu:Server:LoginToAccount", function(cb, src, accountData)
    local identifiers = exports["soe-utils"]:GetIdentifiersFromSource(src)
    local dataString = ("Username=%s&Password=%s&Identifiers=%s"):format(accountData.Username, accountData.Password, json.encode(identifiers))
    local login = exports["soe-nexus"]:PerformAPIRequest("/api/user/login", dataString, true)
    if login and login.data then
        login.data.Characters = FormatCharacters(login.data.Characters)
    end

    cb({["status"] = login.status, ["message"] = login.message, ["data"] = login.data})
    if login.status then
        onlinePlayers[src]["UserID"] = login.data.UserID
        onlinePlayers[src]["Username"] = accountData.Username
        onlinePlayers[src]["ForumAccount"] = login.data.ForumAccount
        onlinePlayers[src]["LoggedIn"] = true
        onlinePlayers[src]["UserSettings"] = login.data.UserSettings or {}
        TriggerClientEvent("Uchuu:Client:UpdatePlayerData", src, {status = true, parameter = "UserSettings", paramData = login.data.UserSettings})

        local found
        local usedIPs = json.decode(login.data.UsedIPs)
        local currentIP = exports["soe-utils"]:GetIdentifiersFromSource(src)["ip"]
        for _, ip in pairs(usedIPs) do
            if (ip == currentIP) then
                found = true
            end
        end

        if not found then
            usedIPs[#usedIPs + 1] = currentIP
            UpdateIPList(login.data.UserID, usedIPs)
        end

        -- CHECK IF PLAYER IS PART OF THE SoE STAFF TEAM
        Wait(1000)
        local checkStaffRank = exports["soe-nexus"]:PerformAPIRequest("/api/staff/getrank", ("userid=%s"):format(login.data.UserID), true)
        if checkStaffRank.status then
            local found
            local rank = checkStaffRank.data
            for _, v in pairs(onlineStaff[rank]) do
                if (v == src) then
                    found = true
                end
            end

            if not found then
                onlineStaff[rank][#onlineStaff[rank] + 1] = src
            end
        end
    end
end)
