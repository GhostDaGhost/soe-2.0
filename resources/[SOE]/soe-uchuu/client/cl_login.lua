local mySpawns = {}
local myCharacters = {}

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, INITIATE GAMESTATE/SETTINGS FOR CHARACTER
local function InitiateCharacterData()
    print("I like turtles.")
    local gamestate, setting = json.encode(myData["Gamestate"]), json.encode(myData["Settings"])
    gamestate, setting = json.decode(gamestate), json.decode(setting)

    -- CHARACTER GAMESTATE
    -- IF PLAYER WAS DEAD PRIOR TO DISCONNECTING, KILL THEM AGAIN
    if gamestate["dead"] then
        SetEntityHealth(PlayerPedId(), 0)
        TriggerEvent("Chat:Client:SendMessage", "system", "You were dead before disconnecting, so you will die now.")
    end

    -- IF PLAYER WAS RESTRAINED PRIOR TO DISCONNECTING, RESTRAIN THEM AGAIN
    if gamestate["cuffed"] then
        TriggerServerEvent("Emergency:Server:RestraintGamestate", {status = true, type = "Cuff"})
    end

    if gamestate["zip-tied"] then
        TriggerServerEvent("Emergency:Server:RestraintGamestate", {status = true, type = "Zip-Tie"})
    end

    -- IF THE PLAYER HAS SAVED HUNGER AND THIRST, RESTORE THOSE VALUES
    if (gamestate["hunger"] ~= nil and gamestate["thirst"] ~= nil) then
        exports["soe-nutrition"]:SetLevels(tonumber(gamestate["hunger"]), tonumber(gamestate["thirst"]))
    end

    -- CHARACTER SETTINGS
    -- IF LARGE GPS WAS SAVED, MAKE IT BIGGER
    if setting["largeGPS"] then
        exports["soe-ui"]:EnableBigGPS()
    end
end

-- GET A LIST OF AVAILABLE SPAWNS FOR CHARID
local function GetSpawnList(charID)
    local lastLocDesc, lastLocMsg = "The last location you were at.", "You're suddenly awake with a vague recollection of past events!"
    local gamestate = json.encode(myData["Gamestate"])
    gamestate = json.decode(gamestate)

    -- REQUEST LAST LOCATION BE ADDED TO THE SPAWN LIST
    local location = json.decode(gamestate["position"])
    if location then
        mySpawns["LASTLOC"] = {
            ["Name"] = "Last Position",
            ["Cost"] = 0,
            ["Description"] = lastLocDesc,
            ["Message"] = lastLocMsg,
            ["Coords"] = vector3(location.x, location.y, location.z)
        }
    end    
    
    -- IF THERE ARE ANY PROPERTY SPAWNS
    if not gamestate["dead"] then
        -- REQUEST PROPERTY SPAWNS
        local propertySpawns = exports["soe-nexus"]:TriggerServerCallback("Uchuu:Server:RequestResidentialSpawnsForCharID", charID)
        if exports["soe-utils"]:GetTableSize(propertySpawns) > 0 then
            for _, spawn in pairs(propertySpawns) do
                mySpawns["P" .. spawn.PropertyID] = spawn
            end
        else
            -- IF NOT, OFFER DEFAULT SPAWNS
            for spawnID, spawnData in pairs(defaultSpawns) do
                mySpawns[spawnID] = spawnData
            end
        end
    else
        lastLocDesc, lastLocMsg = "You died prior to disconnecting... thus you will only be able to spawn here.", "You're suddenly awake in pain!"
    end

    -- RETURN SPAWNS
    return mySpawns
end

-- SELECT CHARACTER BY CHARID AND SET DATA ACCORDINGLY
local function SelectCharacterByID(CharID)
    --[[if not myCharacters[CharID] then
        TriggerServerEvent("Fidelis:Server:HandleSelfBan", "Injecting/Exploiting (Fidelis)")
        return
    end]]

    -- SET CLIENT DATA
    myData["CharID"] = CharID
    myData["FirstGiven"] = myCharacters[CharID].FirstGiven
    myData["LastGiven"] = myCharacters[CharID].LastGiven
    myData["DOB"] = myCharacters[CharID].DOB
    myData["Gender"] = myCharacters[CharID].Gender
    myData["CivType"] = myCharacters[CharID].CivType
    myData["Employer"] = myCharacters[CharID].Employer
    myData["JobTitle"] = myCharacters[CharID].JobTitle
    myData["PrisonTime"] = myCharacters[CharID].PrisonTime
    myData["Appearance"] = myCharacters[CharID].Appearance
    myData["Settings"] = myCharacters[CharID].Settings
    myData["Gamestate"] = myCharacters[CharID].Gamestate

    -- SET SERVER DATA
    local dataToUpdate = {
        ["CharID"] = CharID,
        ["FirstGiven"] = myCharacters[CharID].FirstGiven,
        ["LastGiven"] = myCharacters[CharID].LastGiven,
        ["DOB"] = myCharacters[CharID].DOB,
        ["Gender"] = myCharacters[CharID].Gender,
        ["CivType"] = myCharacters[CharID].CivType,
        ["Employer"] = myCharacters[CharID].Employer,
        ["JobTitle"] = myCharacters[CharID].JobTitle,
        ["PrisonTime"] = myCharacters[CharID].PrisonTime,
        ["Appearance"] = myCharacters[CharID].Appearance,
        ["Settings"] = myCharacters[CharID].Settings,
        ["Gamestate"] = myCharacters[CharID].Gamestate
    }
    TriggerServerEvent("Uchuu:Server:UpdatePlayerDataBulk", dataToUpdate)

    --BROADCAST CHARACTER SELECTED EVENT
    TriggerEvent("Uchuu:Client:CharacterSelected", CharID)
end

-- SELECT SPAWN BY SPAWN ID
local function SelectSpawnLocation(SpawnID)
    if not mySpawns[SpawnID] then
        TriggerServerEvent("Fidelis:Server:HandleSelfBan", "[Autoban] Trigger ID: 8353 | Lua-Injecting Detected.", 0)
        return
    end
    local spawn = mySpawns[SpawnID]

    -- TELEPORT PLAYER TO SPAWN AND PRINT SPAWN MESSAGE
    exports["soe-fidelis"]:AuthorizeTeleport()
    SetEntityCoords(PlayerPedId(), spawn.Coords)
    exports["soe-ui"]:SendAlert("warning", spawn.Message, 9500)

    -- BROADCAST PLAYER SPAWNED EVENT
    TriggerServerEvent("Uchuu:Server:PlayerSpawned")
    TriggerEvent("Uchuu:Client:PlayerSpawned", spawn)
    TriggerEvent('cd_dispatch:GrabInfo')
end

-- **********************
--     NUI Callbacks
-- **********************
RegisterNUICallback("Uchuu.ButtonPush", function(data, cb)
    if (data.eventType == "login") then -- ACCOUNT LOGIN
        local accountLogin = exports["soe-nexus"]:TriggerServerCallback("Uchuu:Server:LoginToAccount", {["Username"] = data.username, ["Password"] = data.password})
        if accountLogin.status then
            myCharacters = accountLogin.data.Characters
            myData.UserID = accountLogin.data.UserID
            TriggerEvent("Uchuu:Client:UserLoggedIn", data.UserID)
        end
        cb(accountLogin)
    elseif (data.eventType == "register") then -- ACCOUNT REGISTRATION
        local accountRegister = exports["soe-nexus"]:TriggerServerCallback("Uchuu:Server:RegisterNewAccount", {
            ["Username"] = data.username,
            ["Password"] = data.password,
            ["ForumLogin"] = data.forumUsername,
            ["ForumPassword"] = data.forumPassword
        })

        if accountRegister.status then
            myData.UserID = accountRegister.data.UserID
            TriggerEvent("Uchuu:Client:UserLoggedIn", accountRegister.data.UserID)
        end
        cb(accountRegister)
    elseif (data.eventType == "charCreate") then -- CHARACTER CREATION
        local characterCreate = exports["soe-nexus"]:TriggerServerCallback("Uchuu:Server:CreateNewCharacter", {
            ["UserID"] = myData.UserID,
            ["FirstGiven"] = data.FirstGiven,
            ["LastGiven"] = data.LastGiven,
            ["DOB"] = data.DOB,
            ["Gender"] = data.Gender
        })

        myCharacters = characterCreate.data.Characters
        cb(json.encode(characterCreate))
    elseif (data.eventType == "charSelect") then -- CHARACTER SELECTION
        SelectCharacterByID(tostring(data.CharID))
        cb({["status"] = true, ["message"] = "Character selected!", ["data"] = GetSpawnList(data.CharID)})
    elseif (data.eventType == "spawnSelect") then -- SPAWN SELECTION
        SelectSpawnLocation(data.SpawnID)
        SetNuiFocus(false, false)

        -- INITIATE GAMESTATE/SETTINGS OF CHARACTER
        Wait(3500)
        InitiateCharacterData()
    end
end)

-- **********************
--        Events
-- **********************
-- DETECT WHEN MAP LOADS IN. DO SPAWNMANAGER CONFIGURATIONS
AddEventHandler("onClientMapStart", function()
    exports["spawnmanager"]:setAutoSpawn(false)
    exports["spawnmanager"]:spawnPlayer()
end)

-- DETECT WHEN RESOURCE STARTS IN ORDER TO SET NUI FOCUS FOR LOGIN UI AND INSTANCE CHECK
AddEventHandler("onClientResourceStart", function(resource)
    if (GetCurrentResourceName() ~= resource) then return end

    -- WAIT A MOMENT FOR STUFF TO LOAD THEN SET NUI FOCUS
    Wait(1500)
    SetNuiFocus(true, true)
    Wait(1500)
    SetNuiFocus(true, true)
    SetNuiFocus(true, true)
end)
