-- VARIABLES
currentHouse = nil
currentShell = nil
housingBlips = {}

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, ALLOW PLAYER TO CHANGE CLOTHES INSIDE A PROPERTY (TEMPORARY UNTIL ATTACHED TO A FURNITURE ITEM)
local function UseCloset(data)
    if not data.status then return end
    local myProperty = GetCurrentProperty()
    if not myProperty then
        exports["soe-ui"]:SendAlert("error", "You must be in a property", 5000)
        return
    end

    exports["soe-appearance"]:OpenAppearanceMenu("lowclothing", "Closet", myProperty.address, false, true)
end

-- EXIT PROPERTY
local function ExitShell()
    local exitPOS = {}
    if (currentHouse ~= nil) then
        exitPOS = GetPropertyByID(currentHouse).entrance
    else -- SPAWN AT BANNER HOTEL IF NO HOUSE ENTRANCE FOUND
        exitPOS = {x = -286.94, y = -1061.81, z = 27.21, h = 247.41}
    end

    local houseID = currentHouse
    TriggerServerEvent("Crime:Server:ExitShellDespawn", houseID)

    TriggerServerEvent("Instance:Server:SetPlayerInstance", -1)
    TriggerServerEvent("Properties:Server:SetPropertyID", nil)
    PropertyTeleport(exitPOS.x, exitPOS.y, exitPOS.z, exitPOS.h)
    exports["soe-climate"]:SetTimeWeatherOverride(false)
    if DoesEntityExist(currentShell) then
        SetEntityAsMissionEntity(currentShell, true, true)
        DeleteObject(currentShell)
    end

    currentShell = nil
    currentHouse = nil

    -- DELETE ALL FURNITURE
    furniture.removing = false
    furniture.placingObj = false
    if furniture.spawnedProps then
        for _, prop in pairs(furniture.spawnedProps) do
            if DoesEntityExist(prop) then
                SetEntityAsMissionEntity(prop, true, true)
                DeleteObject(prop)
                DeleteEntity(prop)
            end
        end
    end

    furniture.spawnedProps = {}
    exports["soe-utils"]:PlayProximitySoundFromCoords(vector3(exitPOS.x, exitPOS.y, exitPOS.z), 3.0, "house_closedoor.ogg", 0.10)
end

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, ALLOW PLAYER TO CHANGE CLOTHES INSIDE A PROPERTY
RegisterNetEvent("Properties:Client:UseCloset")
AddEventHandler("Properties:Client:UseCloset", UseCloset)

-- RECEIVE PROPERTY DATA
RegisterNetEvent("Properties:Client:ReceivePropertyData")
AddEventHandler("Properties:Client:ReceivePropertyData", function(data)
    print("PROPERTY DATA RECEIVED FROM SERVER")
    propertyList = data
end)

-- SHOW SELL NOTIFICATION
RegisterNetEvent("Housing:Client:ShowHouseSellNotification")
AddEventHandler("Housing:Client:ShowHouseSellNotification", function(propertyId, price)
    local address = GetPropertyByID(propertyId).address
    TriggerEvent("Chat:Client:SendMessage", "properties", ("You have successfully sold %s for $%s!"):format(address, price))
end)

-- SHOW PURCHASE NOTIFICATION
RegisterNetEvent("Housing:Client:ShowHousePurchaseNotification")
AddEventHandler("Housing:Client:ShowHousePurchaseNotification", function(propertyId, price, success)
    local address = GetPropertyByID(propertyId).address
    if (success == nil or success == true) then
        TriggerEvent("Chat:Client:SendMessage", "properties", ("You have successfully purchased %s for $%s. Congrats!"):format(address, price))
    else
        TriggerEvent("Chat:Client:SendMessage", "properties", "Unable to purchase this property!")
    end
end)

-- INTERACT KEY - CHANGE TO F2 MENU IN THE FUTURE
AddEventHandler("Utils:Client:InteractionKey", function()
    local closestProperty = GetClosestProperty()
    if closestProperty then
        TriggerServerEvent("Housing:Server:InteractWithProperty", closestProperty.id)
    end

    if currentHouse then
        local myPos = GetEntityCoords(PlayerPedId())
        local property = GetPropertyByID(currentHouse)
        local shell = shellData[property.shell]
        local doorCoords = GetCoordsFromPropertyOffset(property.id, shell.doorOffset.x, shell.doorOffset.y, shell.doorOffset.z)
        if #(myPos - vector3(doorCoords.x, doorCoords.y, doorCoords.z)) <= 1.55 then
            ExitShell()
        end
    end
end)

-- ENTER PROPERTY (SHELL)
AddEventHandler("Housing:Client:EnterShell", function(propertyId)
    local property = GetPropertyByID(propertyId)
    local shell = property.shell
    local spawnCoords = property.entrance
    local newZ = spawnCoords.z + shellVerticalOffset

    -- CREATE SHELL
    local hash = GetHashKey(shell)
    exports["soe-utils"]:LoadModel(hash, 15)
    local myBuilding = CreateObject(hash, spawnCoords.x, spawnCoords.y, newZ, false, false, false)

    SetEntityAsMissionEntity(myBuilding, true, true)
    FreezeEntityPosition(myBuilding, true)

    local safe = exports["soe-utils"]:FloatUntilSafe(myBuilding)
    if not safe then
        exports["soe-ui"]:SendAlert("error", "Your building is inaccessible right now.", 5000)
        return
    end

    -- SET AS CURRENT PROPERTY AND HANDLE TELEPORT
    currentShell = myBuilding
    currentHouse = propertyId
    exports["soe-utils"]:PlayProximitySoundFromCoords(GetEntityCoords(PlayerPedId()), 3.0, "house_opendoor.ogg", 0.25)

    -- CREATE FURNITURE
    TriggerServerEvent("Properties:Server:SetPropertyID", propertyId)
    local getFurniture = exports["soe-nexus"]:TriggerServerCallback("Properties:Server:GetFurniture", propertyId)
    if getFurniture.status then
        if not furniture.spawnedProps then
            furniture.spawnedProps = {}
        end

        for _, prop in pairs(getFurniture.data) do
            exports["soe-utils"]:LoadModel(GetHashKey(prop.ObjHash), 15)

            local pos = json.decode(prop.ObjPosition)
            local obj = CreateObject(GetHashKey(prop.ObjHash), pos.x, pos.y, pos.z, false, true, false)
            SetEntityAsMissionEntity(obj, true, true)
            SetEntityCoords(obj, pos.x, pos.y, pos.z)
            SetEntityHeading(obj, pos.h)
            NetworkSetEntityInvisibleToNetwork(obj, true)
            
            SetTimeout(3500, function()
                FreezeEntityPosition(obj, true)
            end)
            DecorSetInt(obj, "furnitureID", prop.FurnitureID)
            furniture.spawnedProps[#furniture.spawnedProps + 1] = obj
        end
    end

    -- OVERRIDE TIME/WEATHER
    exports["soe-climate"]:SetTimeWeatherOverride(true)
    SetWeatherTypeNowPersist("EXTRASUNNY")
    NetworkOverrideClockTime(6, 0, 0)

    local _shell = shellData[shell]
    if not _shell.debug then
        local doorCoords = GetCoordsFromPropertyOffset(property.id, _shell.doorOffset.x, _shell.doorOffset.y, _shell.doorOffset.z)
        PropertyTeleport(doorCoords.x, doorCoords.y, doorCoords.z, _shell.heading)
        TriggerServerEvent("Instance:Server:SetPlayerInstance", tostring(property.address))
    end
end)

-- TOGGLE HOUSING BLIPS
RegisterNetEvent("Housing:Client:ToggleHousingBlips")
AddEventHandler("Housing:Client:ToggleHousingBlips", function(properties, refresh)
    if exports["soe-utils"]:GetTableSize(housingBlips) >= 1 and refresh == true then
        for propertyID, blip in pairs(housingBlips) do
            RemoveBlip(blip.blip)
        end
        housingBlips = {}

        for _, property in pairs(properties) do
            housingBlips[property.id] = {
                ["blip"] = AddBlipForCoord(property.entrance.x, property.entrance.y, property.entrance.z)
            }
            SetBlipSprite(housingBlips[property.id]["blip"], 40)
            SetBlipColour(housingBlips[property.id]["blip"], 13)
            SetBlipScale(housingBlips[property.id]["blip"], 0.6)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Unowned Property")
            EndTextCommandSetBlipName(housingBlips[property.id]["blip"])
            SetBlipAsShortRange(housingBlips[property.id]["blip"], true)
        end
        exports["soe-ui"]:SendAlert("success", "Property blips updated!", 5000)
        return
    elseif refresh == true then
        return
    end

    if exports["soe-utils"]:GetTableSize(housingBlips) >= 1 then
        for propertyID, blip in pairs(housingBlips) do
            RemoveBlip(blip.blip)
        end
        housingBlips = {}
        exports["soe-ui"]:SendAlert("success", "Property blips removed from map!", 5000)
    else
        for _, property in pairs(properties) do
            housingBlips[property.id] = {
                ["blip"] = AddBlipForCoord(property.entrance.x, property.entrance.y, property.entrance.z)
            }
            SetBlipSprite(housingBlips[property.id]["blip"], 40)
            SetBlipColour(housingBlips[property.id]["blip"], 13)
            SetBlipScale(housingBlips[property.id]["blip"], 0.6)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Unowned Property")
            EndTextCommandSetBlipName(housingBlips[property.id]["blip"])
            SetBlipAsShortRange(housingBlips[property.id]["blip"], true)
        end
        exports["soe-ui"]:SendAlert("success", "Property blips added to map!", 5000)
    end
end)