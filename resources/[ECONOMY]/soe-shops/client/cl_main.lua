menuV = assert(MenuV)

--local cooldown = 0
local transactionReturn
local processing = false
local alreadyBuyingSeeds = false
--local previewingFurniture = false
local isPurchaseDialogOpen = false
local storeMenu = menuV:CreateMenu("Store", "No shoplifting", "topright", 4, 38, 191, "size-100", "default", "menuv", "storeMenu", "native")

isStoreMenuOpen = false

local currentStoreName = ""

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, PROMPT FOR AMOUNT OF A PRODUCT SOMEONE WANTS
local function PrepareShopTransaction(type, storeName, price, product, phoneStyle, factionName)
    if type == "buying" then
        exports["soe-input"]:OpenInputDialogue("number", "Enter Amount To Buy:", function(returnData)
            local amount = tonumber(returnData)
            if amount ~= nil then
                if amount <= 0 then
                    exports["soe-ui"]:SendAlert("error", "Nice try", 5000)
                    return
                end

                -- DO THIS IF THE ITEM PLAYER IS TRYING TO BUY IS A CRATE OF ITEMS OR A BOX OF SUPPLIES
                if string.match(product, "boxof") or string.match(product, "crateof") then
                    local returnData = exports["soe-nexus"]:TriggerServerCallback("Shops:Server:GetQuantityPurchased", factionName)

                    print("-----")
                    print("PRODUCT", product)
                    print("QUANTITY PURCHASED", returnData.quantityPurchased)
                    print("QUANTITY PURCHASED + REQUESTED AMOUNT", returnData.quantityPurchased + amount)

                    local buyLimit, type = 0, "boxes"
                    if string.match(product, "boxof") then
                        buyLimit = boxBuyLimit
                    elseif string.match(product, "crateof") then
                        buyLimit = crateBuyLimit
                        type = "crate"
                    end

                    print("BUYLIMIT", buyLimit)

                    -- EXIT TRANSACTION IF PLAYER IS TRYING TO BUY MORE THAN WHAT THEY ARE ALLOWED
                    if amount + returnData.quantityPurchased > buyLimit then
                        menuV:CloseAll()
                        isPurchaseDialogOpen = false
                        local canBuyAmt = buyLimit - returnData.quantityPurchased
                        if canBuyAmt ~= 0 then
                            exports["soe-ui"]:SendAlert("error", ("%s can only buy %s more %s"):format(factionName, canBuyAmt, type), 5000)
                        else
                            exports["soe-ui"]:SendAlert("error", ("%s cannot buy any more %s!"):format(factionName, type), 5000)
                        end
                        return
                    end
                end

                NewTransaction(price * amount, "Purchase - " .. (storeName or "Store"), {item = product, amt = amount, phoneStyle = phoneStyle}, factionName)
            end
        end)
    end
end

-- WHEN TRIGGERED, MAKE A PREVIEW FURNITURE FOR FURNITURE STORES
--[[local function PreviewFurniture(model)
    if previewingFurniture then
        previewingFurniture = false
        cooldown = GetGameTimer() + 3000
        return
    end

    -- COOLDOWN TO PREVENT DUPE PREVIEWS
    if (cooldown > GetGameTimer()) then
        exports["soe-ui"]:SendAlert("error", "Wait a while before doing that again", 5000)
        return
    end

    local hash = GetHashKey(model)
    exports["soe-utils"]:LoadModel(hash, 15)

    local offset = 0.0
    local obj = CreateObject(hash, GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 5.0, 0.0), 0, 0, 1)
    local hdg = GetEntityHeading(obj)
    SetEntityCollision(obj, false, false)

    previewingFurniture = true
    while previewingFurniture do
        Wait(5)
        local ray = exports["soe-utils"]:Raycast(100)
        DisableControlAction(0, 44, true)
        DisableControlAction(0, 51, true)

        SetEntityCoords(obj, ray.HitPosition.x, ray.HitPosition.y, ray.HitPosition.z + offset)
        SetEntityHeading(obj, hdg)

        -- FINE TUNING FOR HEADING/POSITION OF FURNITURE
        if IsControlPressed(0, 21) then
            if IsDisabledControlPressed(0, 44) then
                hdg = hdg - 0.1
            elseif IsDisabledControlPressed(0, 51) then
                hdg = hdg + 0.1
            end

            if IsControlJustReleased(0, 19) then
                offset = offset - 0.1
            elseif IsControlJustReleased(0, 73) then
                offset = offset + 0.1
            end
        else
            if IsDisabledControlPressed(0, 44) then
                hdg = hdg - 1.0
            elseif IsDisabledControlPressed(0, 51) then
                hdg = hdg + 1.0
            end

            if IsControlJustReleased(0, 19) then
                offset = offset - 1.0
            elseif IsControlJustReleased(0, 73) then
                offset = offset + 1.0
            end
        end
    end
    SetModelAsNoLongerNeeded(hash)
    DeleteEntity(obj)
    DeleteObject(obj)
end]]

-- WHEN TRIGGERED, DEBUG BUY LIMIT
local function ModifyBuyLimit(data)
    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 74677-1 | Lua-Injecting Detected.", 0)
    end
    local set = false
    if data.limitName == "box" then
        boxBuyLimit = data.amount
        set = true
    elseif data.limitName == "crate" then
        crateBuyLimit = data.amount
        set = true
    end
    if set then
        exports["soe-ui"]:SendAlert("success", ("Box Buy Limit: %s | Crate Buy Limit: %s"):format(boxBuyLimit, crateBuyLimit), 5000)
    end
end

-- **********************
--    Global Functions
-- **********************
-- RETURNS IF PLAYER IS NEAR A STORE
function IsNearStore(ped)
    local pos = GetEntityCoords(ped)
    for _, store in pairs(stores) do
        if #(pos - vector3(store.pos.x, store.pos.y, store.pos.z)) <= 3.5 then
            return true
        end
    end
    return false
end

function NewTransaction(totalPrice, statementText, item, factionName)
    if isPurchaseDialogOpen then
        print("PURCHASE DIALOG ALREADY OPEN - UNABLE TO PROCESS NEW TRANSACTION")
        return false
    end

    transactionReturn = nil
    isPurchaseDialogOpen = true

    if totalPrice ~= 0 then
        local myCash = exports["soe-inventory"]:GetItemAmt("cash", "left")
        SendNUIMessage({
            type = "ReceiveAccountData",
            accountsData = exports["soe-inventory"]:GetItemData("bankcard", "left"),
            cashData = myCash
        })

        SendNUIMessage({type = "OpenUI", price = totalPrice})
        SetNuiFocus(true, true)
    else
        transactionReturn = {type = "cash"}
        isPurchaseDialogOpen = false
    end
    processing = true

    -- REPEAT UNTIL PAYMENT IS MADE
    while processing do
        while transactionReturn == nil do
            Wait(50)
        end

        -- IF CANCELLED
        if transactionReturn.cancel == true then
            processing = false
            return false
        end

        local transactionStatus = exports["soe-nexus"]:TriggerServerCallback("Shops:Server:ProcessTransaction", transactionReturn, totalPrice, statementText, item, storeType)
        if totalPrice ~= 0 then
            Wait(1000)
            SendNUIMessage({type = "SendTransactionStatus", response = transactionStatus})
        end

        if transactionStatus.status == true then
            -- IF PLAYER SUCCESSFULLY PURCHASED A CRATE OF ITEMS OR A BOX OF SUPPLIES
            if item ~= nil then
                if string.match(item.item, "boxof") or string.match(item.item, "crateof") then
                    print(("PURCHASE %s %s"):format(item.amt, item.item))
                    local added = exports["soe-nexus"]:TriggerServerCallback("Shops:Server:SetQuantityPurchased", item.amt, factionName)
                    if added.status then
                        local returnData = exports["soe-nexus"]:TriggerServerCallback("Shops:Server:GetQuantityPurchased", factionName)

                        print(("ADDED %s TO SERVER LIST FOR ITEM %s"):format(item.amt, item.item))

                        local buyLimit = 0
                        if string.match(item.item, "boxof") then
                            buyLimit = boxBuyLimit
                        elseif string.match(item.item, "crateof") then
                            buyLimit = crateBuyLimit
                        end

                        exports["soe-ui"]:SendAlert("success", ("%s has purchased %s out of their limit of %s"):format(factionName, returnData.quantityPurchased, buyLimit), 5000)
                        menuV:CloseAll()
                        SetNuiFocus(false, false)
                        isPurchaseDialogOpen = false
                    end
                end
            end

            processing = false
            return true
        else
            transactionReturn = nil
        end
    end
end

-- BUILDS STORE MENU
function OpenMyStoreMenu()
    if isStoreMenuOpen then return end
    -- CLEAR MENU IF ALREADY EXISTS
    storeMenu:ClearItems()

    -- GET ALL THE PERMS
    local mrBlacksAmmuPerm = exports["soe-factions"]:CheckPermission("MADISCOUNT")
    local stewartsOutdoorAdventuresPerm = exports["soe-factions"]:CheckPermission("SODISCOUNT")

    -- FIND CLOSEST STORE
    local myStore, pos, multistoresList = false, GetEntityCoords(PlayerPedId()), {}
    local skipBreak = false
    for _, store in pairs(stores) do
        if #(pos - vector3(store.pos.x, store.pos.y, store.pos.z)) <= 3.5 then
            storeType = store.type

            -- IF NEAR A MULTISTORE ITERATE THROUGH ENTIRE STORE LIST
            if store.multistore then
                skipBreak = true
            end

            -- CHECK IF STORE REQUIRES SPECIAL PERMS TO USE
            local factionName = nil
            local authorized = true
            if store.perms then
                -- PLAYER MUST HAVE ALL PERMS IN LIST
                for _, perm in pairs(store.perms) do
                    if exports["soe-factions"]:CheckPermission(perm) then
                        authorized = true

                        -- SAVE THE FACTION NAME THAT HAS THE AUTHORIZING PERM
                        factionName = exports["soe-factions"]:GetFactionWithPerm(perm)
                    else
                        authorized = false
                    end
                end

                -- SHOW ERROR MESSAGE IF PLAYER IS NOT AUTHORIZED
                if not authorized and not skipBreak then
                    exports["soe-ui"]:SendAlert("error", "You do not have the right permissions to use this store!", 5000)
                    return
                end
            end

            if skipBreak and authorized then
                -- ADD MULTISTORE TO STORES TABLE
                multistoresList[#multistoresList + 1] = {store = store, factionName = factionName}
            elseif authorized then
                myStore = store
                break
            end
        end
    end

    -- SHOW ERROR MESSAGE IF PLAYER IS NOT AUTHORIZED
    if skipBreak and #multistoresList <= 0 then
        exports["soe-ui"]:SendAlert("error", "You do not have the right permissions to use this store!", 5000)
        return
    end

    -- SET UP MENU TO DISPLAY ALL THE STORE PLAYER IS NEAR TO
    if #multistoresList >= 2 then
        storeMenu:SetSubtitle("Select store")
        storeMenu:SetTitle("Stores")
        for _, storeData in pairs(multistoresList) do
            local buttonText = ("%s"):format(storeData.store.name)
            local button = storeMenu:AddButton({icon = "", label = buttonText, select = function()
                myStore = storeData.store
                myStore.factionName = storeData.factionName
                storeMenu:ClearItems()
            end})
        end
        storeMenu:Open()
        isStoreMenuOpen = true
    elseif #multistoresList == 1 then
        myStore = multistoresList[1].store
        myStore.factionName = multistoresList[1].factionName
        storeMenu:ClearItems()
        storeMenu:Open()
        isStoreMenuOpen = true
    else
        storeMenu:Open()
        isStoreMenuOpen = true
    end

    -- WAIT FOR PLAYER TO SELECT STORE
    while not myStore do
        Wait(0)
    end

    if myStore then
        storeMenu:SetTitle(myStore.name or "Store")
        if (myStore.type == "furniture") then
            storeMenu:SetSubtitle("Time to get decorative.")
            local chairFurniture, couchFurniture, bedFurniture = {}, {}, {}
            local bathroomFurniture, storageFurniture, tableFurniture = {}, {}, {}
            local plantsFurniture, electronicFurniture, miscFurniture, kitchenFurniture = {}, {}, {}, {}

            local furnitureProps = exports["soe-properties"]:GetFurniture()
            for furnitureHash, furnitureData in pairs(furnitureProps) do
                if (furnitureData.type == "bathroom") then
                    bathroomFurniture[#bathroomFurniture + 1] = {hash = furnitureHash, data = furnitureData}
                elseif (furnitureData.type == "storage") then
                    storageFurniture[#storageFurniture + 1] = {hash = furnitureHash, data = furnitureData}
                elseif (furnitureData.type == "table") then
                    tableFurniture[#tableFurniture + 1] = {hash = furnitureHash, data = furnitureData}
                elseif (furnitureData.type == "chair") then
                    chairFurniture[#chairFurniture + 1] = {hash = furnitureHash, data = furnitureData}
                elseif (furnitureData.type == "couch") then
                    couchFurniture[#couchFurniture + 1] = {hash = furnitureHash, data = furnitureData}
                elseif (furnitureData.type == "bed") then
                    bedFurniture[#bedFurniture + 1] = {hash = furnitureHash, data = furnitureData}
                elseif (furnitureData.type == "plants") then
                    plantsFurniture[#plantsFurniture + 1] = {hash = furnitureHash, data = furnitureData}
                elseif (furnitureData.type == "electronic") then
                    electronicFurniture[#electronicFurniture + 1] = {hash = furnitureHash, data = furnitureData}
                elseif (furnitureData.type == "misc") then
                    miscFurniture[#miscFurniture + 1] = {hash = furnitureHash, data = furnitureData}
                elseif (furnitureData.type == "kitchen") then
                    kitchenFurniture[#kitchenFurniture + 1] = {hash = furnitureHash, data = furnitureData}
                end
            end

            if #bathroomFurniture then
                local bathroomSubmenu = menuV:InheritMenu(storeMenu, {["title"] = false, ["subtitle"] = "Choose furniture for the bathroom"})
                storeMenu:AddButton({icon = "", label = "Bathroom", value = bathroomSubmenu})

                for _, furnitureData in pairs(bathroomFurniture) do
                    local price = 66666666
                    if exports["soe-config"]:GetConfigValue("economy", furnitureData.data.itemHash) then
                        price = exports["soe-config"]:GetConfigValue("economy", furnitureData.data.itemHash).buy
                    end

                    local label = ("%s <span style='float:right;color:lightgreen;'>$%s</span>"):format(furnitureData.data.name, price)
                    local button = bathroomSubmenu:AddButton({icon = "", label = label, select = function()
                        PrepareShopTransaction("buying", myStore.name, price, furnitureData.data.itemHash)
                    end})
                end
            end

            if #storageFurniture then
                local storageSubmenu = menuV:InheritMenu(storeMenu, {["title"] = false, ["subtitle"] = "Choose furniture for storage"})
                storeMenu:AddButton({icon = "", label = "Storage", value = storageSubmenu})

                for _, furnitureData in pairs(storageFurniture) do
                    local price = 66666666
                    if exports["soe-config"]:GetConfigValue("economy", furnitureData.data.itemHash) then
                        price = exports["soe-config"]:GetConfigValue("economy", furnitureData.data.itemHash).buy
                    end

                    local label = ("%s <span style='float:right;color:lightgreen;'>$%s</span>"):format(furnitureData.data.name, price)
                    local button = storageSubmenu:AddButton({icon = "", label = label, select = function()
                        PrepareShopTransaction("buying", myStore.name, price, furnitureData.data.itemHash)
                    end})
                end
            end

            if #tableFurniture then
                local tableSubmenu = menuV:InheritMenu(storeMenu, {["title"] = false, ["subtitle"] = "Choose a table"})
                storeMenu:AddButton({icon = "", label = "Tables", value = tableSubmenu})

                for _, furnitureData in pairs(tableFurniture) do
                    local price = 66666666
                    if exports["soe-config"]:GetConfigValue("economy", furnitureData.data.itemHash) then
                        price = exports["soe-config"]:GetConfigValue("economy", furnitureData.data.itemHash).buy
                    end

                    local label = ("%s <span style='float:right;color:lightgreen;'>$%s</span>"):format(furnitureData.data.name, price)
                    local button = tableSubmenu:AddButton({icon = "", label = label, select = function()
                        PrepareShopTransaction("buying", myStore.name, price, furnitureData.data.itemHash)
                    end})
                end
            end

            if #chairFurniture then
                local chairSubmenu = menuV:InheritMenu(storeMenu, {["title"] = false, ["subtitle"] = "Choose a chair"})
                storeMenu:AddButton({icon = "", label = "Chairs", value = chairSubmenu})

                for _, furnitureData in pairs(chairFurniture) do
                    local price = 66666666
                    if exports["soe-config"]:GetConfigValue("economy", furnitureData.data.itemHash) then
                        price = exports["soe-config"]:GetConfigValue("economy", furnitureData.data.itemHash).buy
                    end

                    local label = ("%s <span style='float:right;color:lightgreen;'>$%s</span>"):format(furnitureData.data.name, price)
                    local button = chairSubmenu:AddButton({icon = "", label = label, select = function()
                        PrepareShopTransaction("buying", myStore.name, price, furnitureData.data.itemHash)
                    end})
                end
            end

            if #couchFurniture then
                local couchSubmenu = menuV:InheritMenu(storeMenu, {["title"] = false, ["subtitle"] = "Choose a sofa"})
                storeMenu:AddButton({icon = "", label = "Sofas", value = couchSubmenu})

                for _, furnitureData in pairs(couchFurniture) do
                    local price = 66666666
                    if exports["soe-config"]:GetConfigValue("economy", furnitureData.data.itemHash) then
                        price = exports["soe-config"]:GetConfigValue("economy", furnitureData.data.itemHash).buy
                    end

                    local label = ("%s <span style='float:right;color:lightgreen;'>$%s</span>"):format(furnitureData.data.name, price)
                    local button = couchSubmenu:AddButton({icon = "", label = label, select = function()
                        PrepareShopTransaction("buying", myStore.name, price, furnitureData.data.itemHash)
                    end})
                end
            end

            if #bedFurniture then
                local bedSubmenu = menuV:InheritMenu(storeMenu, {["title"] = false, ["subtitle"] = "Choose a bed"})
                storeMenu:AddButton({icon = "", label = "Beds", value = bedSubmenu})

                for _, furnitureData in pairs(bedFurniture) do
                    local price = 66666666
                    if exports["soe-config"]:GetConfigValue("economy", furnitureData.data.itemHash) then
                        price = exports["soe-config"]:GetConfigValue("economy", furnitureData.data.itemHash).buy
                    end

                    local label = ("%s <span style='float:right;color:lightgreen;'>$%s</span>"):format(furnitureData.data.name, price)
                    local button = bedSubmenu:AddButton({icon = "", label = label, select = function()
                        PrepareShopTransaction("buying", myStore.name, price, furnitureData.data.itemHash)
                    end})
                end
            end

            if #plantsFurniture then
                local plantsSubmenu = menuV:InheritMenu(storeMenu, {["title"] = false, ["subtitle"] = "Choose a plant"})
                storeMenu:AddButton({icon = "", label = "Plants", value = plantsSubmenu})

                for _, furnitureData in pairs(plantsFurniture) do
                    local price = 66666666
                    if exports["soe-config"]:GetConfigValue("economy", furnitureData.data.itemHash) then
                        price = exports["soe-config"]:GetConfigValue("economy", furnitureData.data.itemHash).buy
                    end

                    local label = ("%s <span style='float:right;color:lightgreen;'>$%s</span>"):format(furnitureData.data.name, price)
                    local button = plantsSubmenu:AddButton({icon = "", label = label, select = function()
                        PrepareShopTransaction("buying", myStore.name, price, furnitureData.data.itemHash)
                    end})
                end
            end

            if #electronicFurniture then
                local electronicSubmenu = menuV:InheritMenu(storeMenu, {["title"] = false, ["subtitle"] = "Choose an electronic appliance"})
                storeMenu:AddButton({icon = "", label = "Electronic", value = electronicSubmenu})

                for _, furnitureData in pairs(electronicFurniture) do
                    local price = 66666666
                    if exports["soe-config"]:GetConfigValue("economy", furnitureData.data.itemHash) then
                        price = exports["soe-config"]:GetConfigValue("economy", furnitureData.data.itemHash).buy
                    end

                    local label = ("%s <span style='float:right;color:lightgreen;'>$%s</span>"):format(furnitureData.data.name, price)
                    local button = electronicSubmenu:AddButton({icon = "", label = label, select = function()
                        PrepareShopTransaction("buying", myStore.name, price, furnitureData.data.itemHash)
                    end})
                end
            end

            if #miscFurniture then
                local miscSubmenu = menuV:InheritMenu(storeMenu, {["title"] = false, ["subtitle"] = "Choose a miscelleanous furniture"})
                storeMenu:AddButton({icon = "", label = "Miscelleanous", value = miscSubmenu})

                for _, furnitureData in pairs(miscFurniture) do
                    local price = 66666666
                    if exports["soe-config"]:GetConfigValue("economy", furnitureData.data.itemHash) then
                        price = exports["soe-config"]:GetConfigValue("economy", furnitureData.data.itemHash).buy
                    end

                    local label = ("%s <span style='float:right;color:lightgreen;'>$%s</span>"):format(furnitureData.data.name, price)
                    local button = miscSubmenu:AddButton({icon = "", label = label, select = function()
                        PrepareShopTransaction("buying", myStore.name, price, furnitureData.data.itemHash)
                    end})
                end
            end

            if #kitchenFurniture then
                local miscSubmenu = menuV:InheritMenu(storeMenu, {["title"] = false, ["subtitle"] = "Choose furniture for the kitchen"})
                storeMenu:AddButton({icon = "", label = "Kitchen", value = miscSubmenu})

                for _, furnitureData in pairs(kitchenFurniture) do
                    local price = 66666666
                    if exports["soe-config"]:GetConfigValue("economy", furnitureData.data.itemHash) then
                        price = exports["soe-config"]:GetConfigValue("economy", furnitureData.data.itemHash).buy
                    end

                    local label = ("%s <span style='float:right;color:lightgreen;'>$%s</span>"):format(furnitureData.data.name, price)
                    local button = miscSubmenu:AddButton({icon = "", label = label, select = function()
                        PrepareShopTransaction("buying", myStore.name, price, furnitureData.data.itemHash)
                    end})
                end
            end

            return
        end

        -- NO MENU IF THE STORE IS AN ARMORY AND NOT LEO/EMS
        local civType = exports["soe-uchuu"]:GetPlayer().CivType
        if myStore.policeOnly and (civType ~= "POLICE") then
            exports["soe-ui"]:SendAlert("error", "Access Denied", 5000)
            return
        elseif myStore.emsOnly and (civType ~= "EMS") then
            exports["soe-ui"]:SendAlert("error", "Access Denied", 5000)
            return
        elseif myStore.crimelabOnly and (civType ~= "CRIMELAB") then
            exports["soe-ui"]:SendAlert("error", "Access Denied", 5000)
            return
        end

        if (myStore.method == "buyFrom") then
            storeMenu:SetSubtitle("No shoplifting. | Buying")
            for _, item in pairs(items) do
                -- DETERMINE WHETHER OR NOT ITEM CAN BE BOUGHT HERE
                local canBuyHere = false
                for _, v in pairs(item.buyFrom) do
                    if (v == myStore.type) then
                        canBuyHere = true
                        break
                    end
                end

                -- MAKE THE BUTTON IF IT CAN BE BOUGHT HERE
                if canBuyHere then
                    -- MAKE ARMORY ITEMS FREE
                    local price = 1000
                    if exports["soe-config"]:GetConfigValue("economy", item.hash) then
                        price = exports["soe-config"]:GetConfigValue("economy", item.hash).buy
                    end

                    -- CHECK IF THE STORE IS A GUN STORE
                    local discountedPrice = false
                    if myStore.type == "guns" then
                        -- CHECK IF PLAYER HAS DISCOUNT PERK
                        -- MR BLACKS AMMUNATION
                        if myStore.ownedBy == "mrblacksammunation" and mrBlacksAmmuPerm then
                            -- 40% DISCOUNT
                            local originalPrice = price
                            local newPrice = math.floor(exports["soe-config"]:GetConfigValue("economy", item.hash).buy * storesDiscountPerc)
                            local priceDifference = originalPrice - newPrice

                            price = priceDifference
                            discountedPrice = true
                        end
                    elseif myStore.type == "fishing_supplies" then
                        -- STEWARTS OUTDOOR ADVENTURES DISCOUNT PERM
                        if stewartsOutdoorAdventuresPerm then
                            -- 40% DISCOUNT
                            local originalPrice = price
                            local newPrice = math.floor(exports["soe-config"]:GetConfigValue("economy", item.hash).buy * storesDiscountPerc)

                            -- FOR VERY CHEAP ITEMS
                            if newPrice < 1 then
                                newPrice = 1
                            end

                            local priceDifference = originalPrice - newPrice

                            price = priceDifference
                            discountedPrice = true
                        end
                    end

                    if myStore.policeOnly or myStore.emsOnly or myStore.crimelabOnly or myStore.prison then
                        price = 0
                    end

                    -- IF THIS IS GRANDMA'S HOUSE
                    if (myStore.type ~= "grandma") then
                        local buttonText = ("%s <span style='float:right;color:lightgreen;'>$%s</span>"):format(item.name, price)

                        if discountedPrice then
                            buttonText = ("%s <span style='float:right;color:lightgreen;'>$%s (Discounted)</span>"):format(item.name, price)
                        elseif price == 0 then
                            buttonText = ("%s <span style='float:right;color:lightgreen;'>FREE</span>"):format(item.name)
                        end

                        local button = storeMenu:AddButton({icon = "", label = buttonText, select = function()
                            -- IF THIS IS THE PRISON CAFETERIA, CHECK IF THEY REALLY NEED IT
                            if myStore.prison then
                                if (item.type == "food") then
                                    if (exports["soe-nutrition"]:GetHunger() > 30) then
                                        menuV:CloseAll()
                                        exports["soe-ui"]:SendAlert("error", "You don't feel hungry right now", 5000)
                                        return
                                    end
                                elseif (item.type == "liquids") then
                                    if (exports["soe-nutrition"]:GetThirst() > 30) then
                                        menuV:CloseAll()
                                        exports["soe-ui"]:SendAlert("error", "You don't feel thirsty right now", 5000)
                                        return
                                    end
                                end
                            end

                            if (item.hash ~= "cellphone") then
                                PrepareShopTransaction("buying", myStore.name, price, item.hash, item.phoneStyle, myStore.factionName)
                            else
                                NewTransaction(price, "Purchase - " .. (myStore.name or "Store"), {item = item.hash, amt = 1, phoneStyle = item.phoneStyle})
                            end
                        end})
                    else
                        local buttonText = ("%s (x5) <span style='float:right;color:lightgreen;'>$%s</span>"):format(item.name, price)
                        local button = storeMenu:AddButton({icon = "", label = buttonText, select = function()
                            if (exports["soe-inventory"]:GetItemAmt("cash", "left") >= price) then
                                if alreadyBuyingSeeds then return end
                                alreadyBuyingSeeds = true

                                exports["soe-input"]:OpenConfirmDialogue("Buy 5 seeds of weed?", "Yes", "No", function(returnData)
                                    if returnData then
                                        menuV:CloseAll()
                                        TriggerServerEvent("Shops:Server:BuyWeedSeeds", {status = true, price = price, item = item.hash})
                                    end
                                    Wait(1000)
                                    alreadyBuyingSeeds = false
                                end)
                            else
                                menuV:CloseAll()
                                exports["soe-ui"]:SendAlert("error", "You don't have enough cash", 5000)
                            end
                        end})
                    end
                    Wait(1)
                end
            end
        elseif (myStore.method == "sellTo") then
            storeMenu:SetSubtitle("We don't scam. | Selling")
            for _, item in pairs(sellableItems) do
                -- DETERMINE WHETHER OR NOT ITEM CAN BE SOLD HERE
                local canSellHere = false
                for _, v in pairs(item.sellTo) do
                    if (v == myStore.type) then
                        canSellHere = true
                        break
                    end
                end

                -- MAKE THE BUTTON IF IT CAN BE SOLD HERE
                if canSellHere then
                    local price = 5
                    if exports["soe-config"]:GetConfigValue("economy", item.hash) then
                        price = exports["soe-config"]:GetConfigValue("economy", item.hash).sell
                        local hour = GetClockHours()
                        math.randomseed(hour)
                        price = math.random(price["min"], price["max"])
                    end

                    local buttonText = ("%s <span style='float:right;color:lightgreen;'>$%s</span>"):format(item.name, price)
                    local button = storeMenu:AddButton({icon = "", label = buttonText, select = function()
                        local amt = exports["soe-inventory"]:GetItemAmt(item.hash, "left")
                        if (item.quantity ~= nil) then
                            if (amt >= item.quantity) then
                                TriggerServerEvent("Shops:Server:SellItem", item, item.quantity, price)
                            else
                                exports["soe-ui"]:SendAlert("error", ("You need to have at least %s of this item"):format(item.quantity), 5000)
                            end

                            return
                        end

                        exports["soe-input"]:OpenInputDialogue("number", ("Enter Amount To Sell (You have: %s):"):format(amt), function(returnData)
                            local amount = tonumber(returnData)
                            if (amount ~= nil) then
                                if (amount <= 0) then
                                    exports["soe-ui"]:SendAlert("error", "Nice try", 5000)
                                    return
                                end

                                TriggerServerEvent("Shops:Server:SellItem", item, amount, (price * amount))
                            end
                        end)
                    end})
                    Wait(1)
                end
            end
        end
    end
end

-- ON MENU CLOSED
storeMenu:On("close", function(menu)
    isStoreMenuOpen = false
    --previewingFurniture = false
end)

-- **********************
--     NUI Callbacks
-- **********************
RegisterNUICallback("CancelTransaction", function()
    TriggerEvent("Shops:Client:GetTransactionStatus", {status = false, cancel = true})
end)

RegisterNUICallback("ProcessTransaction", function(data)
    if data then
        transactionReturn = data
        return
    end
end)

RegisterNUICallback("CloseUI", function()
    if processing then
        transactionReturn = {cancel = true}
    end

    if isPurchaseDialogOpen then
        SetNuiFocus(false, false)
        isPurchaseDialogOpen = false
    end
end)

-- **********************
--        Events
-- **********************
-- OPENS STORE MENU
AddEventHandler("Shops:Client:BrowseStore", OpenMyStoreMenu)

-- WHEN TRIGGERED, DEBUG BUY LIMIT
RegisterNetEvent("Jobs:Client:ModifyBuyLimit")
AddEventHandler("Jobs:Client:ModifyBuyLimit", ModifyBuyLimit)

-- WHEN TRIGGERED, RESET ALL NUI INSTANCES
AddEventHandler("UI:Client:ResetNUI", function()
    SendNUIMessage({type = "Shops.HideUI"})
end)