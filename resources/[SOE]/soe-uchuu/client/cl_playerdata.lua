myData = {}

-- **********************
--    Global Functions
-- **********************
-- EXPORTED TO PROVIDE CHARACTER DATA
function GetPlayer()
    return myData
end

-- EXPORTED TO ALLOW CLIENT TO SET CHARACTER GAMESTATES
function UpdateGamestate(gamestate, remove, data)
    TriggerServerEvent("Uchuu:Server:UpdateGamestate", {status = true, gamestate = gamestate, remove = remove, gamestateData = data})
end

-- EXPORTED TO ALLOW CLIENT TO SET CHARACTER SETTINGS
function UpdateSettings(setting, remove, data)
    TriggerServerEvent("Uchuu:Server:UpdateCharacterSettings", {status = true, setting = setting, remove = remove, settingData = data})
end

-- SAVES LAST CHARACTER POSITION
function SaveLastPosition()
    -- DO NOT ALLOW LAST LOCATION SAVING IF INSIDE A HOUSE ROBBERY
    if exports["soe-crime"]:IsRobbingAHouse() then return end

    -- IF INSIDE A PROPERTY, OVERRIDE LOCATION WITH THE PROPERTY ENTRANCE
    local currentProperty = exports["soe-properties"]:GetCurrentProperty()
    if currentProperty then
        TriggerServerEvent("Uchuu:Server:UpdateLastPosition", {status = true, pos = currentProperty.entrance})
        return
    end

    TriggerServerEvent("Uchuu:Server:UpdateLastPosition", {status = true, pos = nil})
end

-- **********************
--        Events
-- **********************
-- DETECT WHEN RESOURCE STARTS IN ORDER TO START THE LOGIN STUFF
AddEventHandler("onClientResourceStart", function(resource)
    if (GetCurrentResourceName() ~= resource) then return end
    TriggerServerEvent("Uchuu:Server:InsertNewPlayer", {status = true})
end)

-- WHEN TRIGGERED, UPDATE PLAYER DATA FROM SERVER
RegisterNetEvent("Uchuu:Client:UpdatePlayerData")
AddEventHandler("Uchuu:Client:UpdatePlayerData", function(data)
    if not data.status then return end
    myData[tostring(data.parameter)] = data.paramData
end)
