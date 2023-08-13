RegisterNetEvent("Jobs:Server:CreateRecipe")
AddEventHandler("Jobs:Server:CreateRecipe", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 993-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 993-2 | Lua-Injecting Detected.", 0)
        return
    end

    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    if not data.craft then
        -- ENSURE PLAYER HAS SUPPLIES FIRST
        if (exports["soe-inventory"]:GetItemAmt(src, data.containerItem, "left") < 1) then
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You don't seem to have the supplies to make this item!", length = 5000})
            return
        end

        -- ADDS THE ITEMS FROM CONTAINER TO PLAYER INVENTORY
        if exports["soe-inventory"]:AddItem(src, "char", charID, data.item, data.amount, "{}") then
            exports["soe-logging"]:ServerLog("Create Recipe", ("HAS CREATED %s IN QUANTITIES OF %s"):format(data.item, data.amount), src)
        end

        -- REMOVE CONTAINER FROM PLAYER INVENTORY
        exports["soe-inventory"]:RemoveItem(src, 1, data.containerItem)
    else
        -- ENSURE PLAYER HAS ALL THE ITEMS FIRST
        local missingItems = {}
        for _, data in pairs(data.recipeIngredients) do
            local haveAmount = exports["soe-inventory"]:GetItemAmt(src, data.itemName, "left")
            if haveAmount < data.requiredAmount then
                missingItems[#missingItems + 1] = {name = data.itemDisplayName, amount = data.requiredAmount - haveAmount}
            end
        end

        -- CONTINUE TO CRAFT IF NO MISSING ITEMS ELSE DISPLAY WHAT ITEMS ARE MISSING AND AMOUNT
        if #missingItems == 0 then
            print("data.item, data.amount", data.item, data.amount)
            -- ADDS THE CRATED ITEM TO PLAYER INVENTORY
            if exports["soe-inventory"]:AddItem(src, "char", charID, data.item, data.amount, "{}") then
                exports["soe-logging"]:ServerLog("Create Recipe", ("HAS CREATED %s IN QUANTITIES OF %s"):format(data.item, data.amount), src)
            end

            -- REMOVE INGREDIENTS REQUIRED TO MAKE THE ITEM FROM PLAYER INVENTORY
            for _, data in pairs(data.recipeIngredients) do
                exports["soe-inventory"]:RemoveItem(src, data.requiredAmount, data.itemName)
            end

        elseif #missingItems > 1 then
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You are missing some items to make this ", length = 5000})
            local missingString = ("%s x%s"):format(missingItems[1].name, missingItems[1].amount)
            for index = 2, #missingItems do
                missingString = ("%s, %s x%s"):format(missingString, missingItems[index].name, missingItems[index].amount)
            end
            TriggerClientEvent("Chat:Client:SendMessage", src, ("[%s]"):format(currentBusiness.name), ("Missing: %s"):format(missingString))
        elseif #missingItems == 1 then
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You are missing an item to make this ", length = 5000})
            local missingString = ("%s x%s"):format(missingItems[1].name, missingItems[1].amount)
            TriggerClientEvent("Chat:Client:SendMessage", src, ("[%s]"):format(currentBusiness.name), ("Missing: %s"):format(missingString))
        end
    end
end)

RegisterNetEvent("Jobs:Server:CreateBadge")
AddEventHandler("Jobs:Server:CreateBadge", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 993-3 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 993-4 | Lua-Injecting Detected.", 0)
        return
    end

    -- ENSURE PLAYER HAS THE ITEM FIRST
    if (exports["soe-inventory"]:GetItemAmt(src, data.itemName, "left") < 1) then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You don't seem to have the item in your inventory!", length = 5000})
        return
    end

    -- CHARACTER DATA
    local charData = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    local charID = charData.CharID or 0

    if not data.emergencyServicesBadge then
        -- FOR BUSINESS
        local factions = exports["soe-nexus"]:PerformAPIRequest("/api/factions/get", ("charid=%s"):format(charID), true)

        if not factions or factions.status == false then
            factions = {}
        end

        -- TRY TO FIND MATCHING FATION
        for _, faction in pairs(factions.data) do
            if faction.FactionData.FactionType == "business" then
                local businessName = data.factionName
                if string.lower(businessName) == string.lower(faction.FactionData.FactionName) then
                    factionName = faction.FactionData.FactionName
                    title = faction.MyData.Title
                    found = true
                    break
                end
            end
        end

        -- NO MATCHING FACTION FOUND
        if not found then
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You are not part of this faction!", length = 5000})
        else
            -- DETERMINE WHAT ITEM TO CREATE
            local itemToCreate = nil
            local itemMeta = {}
            if data.itemName == "cs_badge_blank" then
                itemToCreate = "cs_badge"
                itemMeta.company = "Celtic Shield Security"
                itemMeta.firstName = charData.FirstGiven
                itemMeta.lastName = charData.LastGiven
                itemMeta.rank = title
                itemMeta.serialNum = ("CSS%s"):format(math.random(10000, 99999))
            end

            -- ADDS THE ITEMS FROM CONTAINER TO PLAYER INVENTORY
            if exports["soe-inventory"]:AddItem(src, "char", charID, itemToCreate, 1, json.encode(itemMeta)) then
                exports["soe-logging"]:ServerLog("Create Badge", ("HAS CREATED A %s WITH META DATA %s"):format(itemToCreate, json.encode(itemMeta)), src)
            end

            -- REMOVE BLANK BADGE ITEM FROM PLAYER INVENTORY
            exports["soe-inventory"]:RemoveItem(src, 1, data.itemName)
        end
    else
        -- FOR EMERGENCY SERVICES
        local civType, employer, jobtitle = charData.CivType, charData.Employer, charData.JobTitle

        if civType ~= "POLICE" and civType ~= "EMS" and civType ~= "CRIMELAB" then
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You are not authorized to use this item!", length = 5000})
            return
        end

        -- DETERMINE WHAT ITEM TO CREATE
        local itemToCreate = nil
        local itemMeta = {}
        if employer == "BCSO" then
            itemToCreate = "bcso_badge"
            itemMeta.agency = "Blaine County Sheriff's Office"
        elseif employer == "LSPD" then
            itemToCreate = "lspd_badge"
            itemMeta.agency = "Los Santos Police Department"
        elseif employer == "SASP" then
            itemToCreate = "sasp_badge"
            itemMeta.agency = "San Andreas State Police"
        elseif employer == "SAFR" then
            itemToCreate = "safr_badge"
            itemMeta.agency = "San Andreas Fire And Rescue"
        elseif employer == "SAES" then
            itemToCreate = "saes_badge"
            itemMeta.agency = "San Andreas Emergency Services"
        elseif employer == "SACL" then
            itemToCreate = "sacl_badge"
            itemMeta.agency = "San Andreas Crime Lab"
        end
        itemMeta.firstName = charData.FirstGiven
        itemMeta.lastName = charData.LastGiven
        itemMeta.callsign = exports["soe-emergency"]:GetCallsign(charID) or "N/A"
        itemMeta.rank = jobtitle

        -- ADDS THE ITEMS FROM CONTAINER TO PLAYER INVENTORY
        if exports["soe-inventory"]:AddItem(src, "char", charID, itemToCreate, 1, json.encode(itemMeta)) then
            exports["soe-logging"]:ServerLog("Create Badge", ("HAS CREATED A %s WITH META DATA %s"):format(itemToCreate, json.encode(itemMeta)), src)
        end

        -- REMOVE BLANK BADGE ITEM FROM PLAYER INVENTORY
        exports["soe-inventory"]:RemoveItem(src, 1, data.itemName)
    end
end)

RegisterNetEvent("Jobs:Server:UseBadge")
AddEventHandler("Jobs:Server:UseBadge", function(data)
    local src = data.source or source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 993-5 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 993-6 | Lua-Injecting Detected.", 0)
        return
    end

    local itemMeta, items = nil, exports["soe-inventory"]:GetItemData(src, data.itemName, "left")

    -- FIND THE ITEM
    for uid, itemData in pairs(items) do
        if (tonumber(uid) == tonumber(data.uid)) then
            itemMeta = json.decode(itemData.ItemMeta)
            break
        end
    end

    -- DO ITEM FUNCTION HERE
    if itemMeta ~= nil then
        if not data.emergencyServicesBadge then
            local company, firstName, lastName, rank, serialNum
            if itemMeta.company ~= nil then
                company = itemMeta.company
            end
            if itemMeta.firstName ~= nil then
                firstName = itemMeta.firstName
            end
            if itemMeta.lastName ~= nil then
                lastName = itemMeta.lastName
            end
            if itemMeta.rank ~= nil then
                rank = itemMeta.rank
            end
            if itemMeta.serialNum ~= nil then
                serialNum = itemMeta.serialNum
            end
            exports["soe-chat"]:DoProximityMessage(src, 10.0, "id", "[Badge]", "", ("%s | %s/%s - %s | %s"):format(company, firstName, lastName, rank, serialNum))
        else
            local agency, firstName, lastName, callsign, rank
            if itemMeta.agency ~= nil then
                agency = itemMeta.agency
            end
            if itemMeta.firstName ~= nil then
                firstName = string.sub(itemMeta.firstName, 1, 1)
            end
            if itemMeta.lastName ~= nil then
                lastName = itemMeta.lastName
            end
            if itemMeta.rank ~= nil then
                rank = itemMeta.rank
            end
            if itemMeta.callsign ~= nil then
                callsign = itemMeta.callsign
            end
            exports["soe-chat"]:DoProximityMessage(src, 10.0, "id", "[Badge]", "", ("%s | %s %s.%s - %s"):format(agency, rank, firstName, lastName, callsign))
        end
        exports["soe-emotes"]:PlayEmote(src, "badge")
    end
end)

-- WHEN TRIGGERED, OPEN STORAGE CONTAINER FOR BUSINESS
RegisterCommand("storage", function(source, args)
    local src = source

    local business = nil
    local isNearby = false
    local hasPerms = false
    local pos = GetEntityCoords(GetPlayerPed(src))

    -- CHECK FOR NEARBY BUSINESS STORAGES
    for _, businessData in pairs(storageSpot) do
        if #(pos - businessData.pos) <= businessData.range then
            business = businessData
            isNearby = true
            break
        end
    end

    if business == nil then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You are not near a business storage!", length = 2500})
        return
    end

    --[[print("-----")
    print("isNearby", isNearby)
    print("business.name", business.name)
    print("business.pos", business.pos)
    print("business.range", business.range)]]

    -- CHECK IF PLAYER HAS PERMS, PLAYER MUST HAVE ALL PERMS IN LIST
    for _, perm in pairs(business.perms) do
        if exports["soe-factions"]:CheckPermission(src, perm) then
            hasPerms = true
        else
            hasPerms = false
        end
    end
    --print("hasPerms", hasPerms)

    -- OPEN BUSINESS STORAGE IF NEARBY AND HAS PERMS
    if isNearby and hasPerms then
        TriggerClientEvent("Inventory:Client:ShowInventory", src, "storage", false, business.name)
    elseif not hasPerms then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You do not have the right permissions to use this storage!", length = 2500})
    elseif not isNearby then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You are not near a business storage!", length = 2500})
    end
end)