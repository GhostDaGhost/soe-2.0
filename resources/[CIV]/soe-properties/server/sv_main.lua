local currentPropertyIDs = {}

-- **********************
--    Global Functions
-- **********************
function GetPropertySourceIsIn(src)
    if currentPropertyIDs[src] then
        return currentPropertyIDs[src]
    end
    return nil
end

function UpdatePropertyData(sendToClients)
    local properties = exports["soe-nexus"]:PerformAPIRequest("/api/properties/getproperties", "filler=1", true)
    if properties and properties.status then
        propertyList = {}
        for _, property in pairs(properties.data) do
            propertyEntry = OrganizePropertyData(property)
            table.insert(propertyList, propertyEntry)
        end

        if sendToClients then
            TriggerClientEvent("Properties:Client:ReceivePropertyData", -1, propertyList)
        end
    end
end

-- **********************
--       Commands
-- **********************
-- WHEN TRIGGERED, ALLOW PLAYER TO CHANGE CLOTHES INSIDE A PROPERTY (TEMPORARY UNTIL ATTACHED TO A FURNITURE ITEM)
RegisterCommand("closet", function(source)
    local src = source
    TriggerClientEvent("Properties:Client:UseCloset", src, {status = true})
end)

-- SHOW/HIDE HOUSING BLIPS
RegisterCommand("properties", function(src)
    local unownedProperties = {}
    for _, property in pairs(propertyList) do
        if not IsPropertyOwned(property.id) then
            table.insert(unownedProperties, property)
        end
    end
    TriggerClientEvent("Housing:Client:ToggleHousingBlips", src, unownedProperties)
end)

-- **********************
--        Events
-- **********************
-- GET PROPERTY LIST FROM SERVER
RegisterNetEvent("Properties:Server:RequestPropertyData")
AddEventHandler("Properties:Server:RequestPropertyData", function()
    local src = source
    TriggerClientEvent("Properties:Client:ReceivePropertyData", src, propertyList)
end)

RegisterNetEvent("Properties:Server:SetPropertyID")
AddEventHandler("Properties:Server:SetPropertyID", function(propertyID)
    local src = source
    currentPropertyIDs[src] = propertyID
end)

RegisterNetEvent("Housing:Server:InsertNewLoan")
AddEventHandler("Housing:Server:InsertNewLoan", function(charID, totalAmt, perWeek, apr, propertyID)
    local src = source
    local dataString = string.format("charid=%s&total=%s&perinterval=%s&apr=%s&propertyid=%s", charID, totalAmt, perWeek, apr, propertyID)
    local newLoan = exports["soe-nexus"]:PerformAPIRequest("/api/loans/create", dataString, true)
end)

-- REQUEST ALL ACCESS INFO FOR PROPERTY
AddEventHandler("Housing:Server:RequestPropertyAccessInfo", function(cb, src, propertyID)
    local dataString = ("propertyid=%s"):format(propertyID)
    local propertyAccess = exports["soe-nexus"]:PerformAPIRequest("/api/properties/getaccessdata", dataString, true)

    if propertyAccess.status then
        cb(propertyAccess.data)
    end
end)

AddEventHandler("Housing:Server:GetFinanceTerms", function(cb, src, charID, totalAmt, term)
    local dataString = ("charid=%s&amount=%s&length=%s"):format(charID, totalAmt, term)
    local loanTerms = exports["soe-nexus"]:PerformAPIRequest("/api/loans/getterms", dataString, true)

    if loanTerms and loanTerms.status then
        cb(loanTerms.data)
    else
        cb({})
    end
end)

-- INTERACT WITH PROPERTY AND GET ACCESS TYPE
RegisterNetEvent("Housing:Server:InteractWithProperty")
AddEventHandler("Housing:Server:InteractWithProperty", function(propertyId)
    local src = source
    local playerData = exports['soe-uchuu']:GetOnlinePlayerList()[src]
    if not playerData.LoggedIn then
        return
    end

    local property = GetPropertyByID(propertyId)
    local accessType = GetPlayerPropertyAccess(playerData.CharID, propertyId)
    TriggerClientEvent("Housing:Client:OpenHousingMenu", src, propertyId, accessType)
end)

-- PURCHASE PROPERTY
RegisterNetEvent("Housing:Server:PurchaseProperty")
AddEventHandler("Housing:Server:PurchaseProperty", function(propertyId)
    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    local property = GetPropertyByID(propertyId)

    if not IsPropertyOwned(propertyId) then
        if SetPlayerPropertyAccess(charID, propertyId, "OWNER") then
            TriggerClientEvent("Housing:Client:ShowHousePurchaseNotification", src, propertyId, property.price)
        end
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "properties", ("%s is already owned"):format(property.address))
    end
end)

-- SELL PROPERTY
RegisterNetEvent("Housing:Server:SellProperty")
AddEventHandler("Housing:Server:SellProperty", function(propertyId)
    local src = source
    local playerData = exports['soe-uchuu']:GetOnlinePlayerList()[src]

    local property = GetPropertyByID(propertyId)
    local price = GetPropertyByID(propertyId).price

    -- ADD PRIMARY ACCOUNT DEPOSIT
    SetPlayerPropertyAccess(playerData.CharID, propertyId, "NONE")
    exports["soe-inventory"]:AddItem(src, "char", playerData.CharID, "cash", math.ceil(price * 0.2), "")
    TriggerClientEvent("Housing:Client:ShowHouseSellNotification", src, propertyId, math.ceil(price * 0.2), true)
end)

-- UPDATE ACCESS FOR PROPERTY
RegisterNetEvent("Housing:Server:UpdatePropertyAccess")
AddEventHandler("Housing:Server:UpdatePropertyAccess", function(charID, propertyID, accessType)
    local src = source
    accessType = accessTypes[accessType]

    -- QUICK AND DIRTY SECURITY - WE WILL NEED TO IMPROVE THIS - ALLOW PLAYER TO CHANGE THEIR OWN ACCESS IF THEY ARE REMOVING THEMSELVES
    if exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID == charID and accessType ~= "NONE" then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 500 | Lua-Injecting Detected.", 0)
    end

    if SetPlayerPropertyAccess(charID, propertyID, accessType) then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "Access permissions updated!", length = 5000})
    else
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Unable to update access permissions!", length = 5000})
    end
end)

-- THIS IS IN PLACE OF A RUNTIME FILE - MOVE TO RUNTIME EVENTUALLY WHEN THERE'S MORE TO PUT THERE. GET PROPERTIES ON BOOT.
CreateThread(function()
    Wait(1000)
    local properties = exports["soe-nexus"]:PerformAPIRequest("/api/properties/getproperties", "filler=1", true)
    if properties and properties.status then
        for _, property in pairs(properties.data) do
            propertyEntry = OrganizePropertyData(property)
            table.insert(propertyList, propertyEntry)
        end
    end
end)
