local binsFilled = {}
local vehiclesFilled = {}
local openInventories = {}

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, SYNC INVENTORY WITH SOURCE
local function SyncInventory(type, data)
    for src, inventory in pairs(openInventories) do
        if (inventory.type == type and inventory.data == data) then
            TriggerClientEvent("Inventory:Client:SyncInventory", src)
        end
    end
end

-- WHEN TRIGGERED, GENERATE BIN LOOT
local function GenerateBinLoot(src, binID)
    if binsFilled[binID] then return false end
    binsFilled[binID] = true
    local lootgen = {}

    -- GET RANDOM SEED AND GENERATE X RANDOM ITEMS TO PUT IN BIN
    local items = math.random(1, 4)
    for i = 1, items do
        -- DUPLICATE CHECK
        local item = binLoot[math.random(1, #binLoot)]
        for _, existingItem in pairs(lootgen) do
            if (existingItem.item == item.hash) then
                return
            end
        end

        -- ADD TO OUR LOOT GEN TABLE
        if (math.random(1, 100) <= item.chance) then
            lootgen[#lootgen + 1] = {item = item.hash, amt = math.random(1, item.max)}
        end
    end

    -- FINALIZE LOOT HERE
    for _, loot in pairs(lootgen) do
        AddItem(src, "dumpster", binID, loot.item, loot.amt, "{}")
    end
    return true
end

-- WHEN TRIGGERED, GENERATE VEHICLE LOOT
local function GenerateVehicleLoot(src, class, plate)
    -- DO NOT PUT ANYTHING INTO CERTAIN VEHICLES (POLICE/FIRE/EMS/MILITARY/BICYCLES/TRAINS)
    if (class == 13 or class == 17 or class == 18 or class == 19 or class == 21) then
        return false
    end

    -- IF THIS VEHICLE WAS ALREADY FILLED WITH LOOT ONCE
    if vehiclesFilled[plate] then
        return false
    end

    -- 30% CHANCE OF EMPTY VEHICLE
    if exports["soe-utils"]:GetRandomChance(30) then
        return false
    end

    local lootgen = {}
    -- GET RANDOM SEED AND GENERATE X RANDOM ITEMS TO PUT IN VEHICLE
    math.randomseed(os.time())
    local items = math.random(1, 4)
    for i = 1, items do
        local item = vehicleLoot[math.random(1, #vehicleLoot)]
        lootgen[#lootgen + 1] = {item = item.item, amt = math.random(1, item.max)}
    end

    -- FINALIZE LOOT HERE
    vehiclesFilled[plate] = true
    for _, loot in pairs(lootgen) do
        AddItem(src, "tempveh", plate, loot.item, loot.amt, "{}")
    end
    return true
end

-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, MODIFY ITEM METADATA
function ModifyItemMeta(itemid, itemmeta)
    local modifyItemMeta = exports["soe-nexus"]:PerformAPIRequest("/api/inventory/modifymeta", ("itemid=%s&meta=%s"):format(itemid, itemmeta), true)
    if modifyItemMeta.status then
        return true
    else
        --[[if modifyItemMeta.message then
            print("Metadata modification fatal error", modifyItemMeta.message)
        else
            print("Metadata modification fatal error", "No error message provided.")
        end]]
        return false
    end
end

-- WHEN TRIGGERED, GET ITEM AMOUNT OF A INVENTORY ITEM WITHIN A VEHICLE
function GetItemAmtInVehicle(src, itemType, data)
    local amt = 0
    local inv = RequestInventory(src, "veh", true, {vehicleNetworkId = data.netID, licPlate = data.plate})
    if (inv.rightInventory ~= nil) then
        for _, item in pairs(inv.rightInventory) do
            if (item.ItemType == itemType) then
                amt = amt + item.ItemAmt
            end
        end
    end
    return amt
end

-- WHEN TRIGGERED, MOVE INVENTORY ITEM
function MoveItem(src, type, data, id, server)
    local moveItem = exports["soe-nexus"]:PerformAPIRequest("/api/inventory/moveitem", ("itemid=%s&invtype=%s&invdata=%s"):format(id, type, data), true)
    if moveItem.status then
        SyncInventory(type, data)
        if not server then
            -- RequestInventory(src, 'all')
        else
            return moveItem
        end
    else
        print("A fatal error occurred while attempting to move an item.")
    end
end

-- WHEN TRIGGERED, SPLIT INVENTORY ITEM BASED OFF DATA
function SplitItem(src, id, amt, server)
    -- NIL CHECKS TO PREVENT API 500 ERROR
    if not id then return end
    if not amt then return end

    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[tonumber(src)].CharID
    local splitItem = exports["soe-nexus"]:PerformAPIRequest("/api/inventory/splititem", ("itemid=%s&amt=%s"):format(id, amt), true)
    TriggerClientEvent("Inventory:Client:HandleServerCallback", src, "SplitItem", splitItem)

    if splitItem.status then
        if not server then
            TriggerClientEvent("Inventory:Client:SyncInventory", src)
            SyncInventory("char", charID)
        else
            return splitItem
        end
    else
        print("A fatal error occurred while attempting to split an item.")
    end
end

-- WHEN TRIGGERED, MERGE INVENTORY ITEMS BASED OFF DATA
function MergeItem(src, itemID1, itemID2, server)
    local mergeItem = exports["soe-nexus"]:PerformAPIRequest("/api/inventory/mergeitems", ("itemid1=%s&itemid2=%s"):format(itemID1, itemID2), true)
    TriggerClientEvent("Inventory:Client:HandleServerCallback", src, "MergeItem", mergeItem)

    if mergeItem.status then
        if not server then
            TriggerClientEvent("Inventory:Client:SyncInventory", src)
        else
            return mergeItem
        end
    else
        print("A fatal error occurred while attempting to merge an item.")
    end
end

-- WHEN TRIGGERED, GET ITEM AMOUNT OF A INVENTORY ITEM
function GetItemAmt(src, itemtype, invSide)
    local invSide = invSide or "left"
    local inv = RequestInventory(src, "all", true)

    -- ITERATE THROUGH INVENTORY CONTENTS
    local totalAmt = 0
    if invSide == "left" or invSide == "both" then
        if inv.leftInventory ~= nil then
            for _, item in pairs(inv.leftInventory) do
                if item.ItemType == itemtype then
                    totalAmt = totalAmt + item.ItemAmt
                end
            end
        end
    end

    if invSide == "right" or invSide == "both" then
        if inv.rightInventory ~= nil then
            for _, item in pairs(inv.rightInventory) do
                if item.ItemType == itemtype then
                    totalAmt = totalAmt + item.ItemAmt
                end
            end
        end
    end
    return totalAmt
end

-- WHEN TRIGGERED, GET INVENTORY ITEM DATA
function GetItemData(src, itemtype, invSide)
    local inv = RequestInventory(src, "all", true)
    local returnTable = {}

    -- ITERATE THROUGH ITEMS
    if invSide == "left" or invSide == "both" then
        if inv.leftInventory ~= nil then
            for i, item in pairs(inv.leftInventory) do
                if item.ItemType == itemtype then
                    returnTable[i] = item
                end
            end
        end
    end

    if invSide == "right" or invSide == "both" then
        if inv.rightInventory ~= nil then
            for i, item in pairs(inv.rightInventory) do
                if item.ItemType == itemtype then
                    returnTable[i] = item
                end
            end
        end
    end
    return returnTable
end

-- WHEN TRIGGERED, REMOVE INVENTORY ITEM FROM VEHICLE BASED OFF DATA
function RemoveItemFromVehicle(src, amt, itemType, data)
    local remainingItems = amt
    local inv = RequestInventory(src, "veh", true, {vehicleNetworkId = data.netID, licPlate = data.plate})

    -- ITERATE THROUGH SOURCE'S INVENTORY FOR ITEM
    for _, item in pairs(inv.rightInventory) do
        if (item.ItemType == tostring(itemType)) then
            if (item.ItemAmt <= remainingItems) then
                -- ITEM HOLDS LESS OR EQUAL AMOUNT OF ITEM THAN REMAINING ITEMS
                if (data.vin ~= 0) then
                    ModifyItem(src, "veh", data.vin, 0 - item.ItemAmt, item.ItemType, item.ItemID, true)
                else
                    ModifyItem(src, "tempveh", data.plate, 0 - item.ItemAmt, item.ItemType, item.ItemID, true)
                end
            else
                -- ITEM HOLDS MORE ITEMS THAN REMAINING ITEMS
                if (data.vin ~= 0) then
                    ModifyItem(src, "veh", data.vin, 0 - remainingItems, item.ItemType, item.ItemID, true)
                else
                    ModifyItem(src, "tempveh", data.plate, 0 - remainingItems, item.ItemType, item.ItemID, true)
                end
            end
            remainingItems = remainingItems - item.ItemAmt
            if (remainingItems <= 0) then
                break
            end
        end
    end

    exports["soe-logging"]:ServerLog("Removed Inventory Item (Vehicle)", ("HAS REMOVED A VEHICLE INVENTORY ITEM | AMT: %s | NAME: %s"):format(amt, itemType), src)
    return true
end

-- WHEN TRIGGERED, REMOVE INVENTORY ITEM BASED OFF DATA
function RemoveItem(src, amt, itemType)
    local remainingItems = amt
    local myInventory = RequestInventory(src, "left", true)
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID

    -- ITERATE THROUGH SOURCE'S INVENTORY FOR ITEM
    for _, item in pairs(myInventory.leftInventory) do
        if (item.ItemType == tostring(itemType)) then
            if (item.ItemAmt <= remainingItems) then
                -- ITEM HOLDS LESS OR EQUAL AMOUNT OF ITEM THAN REMAINING ITEMS
                ModifyItem(src, "char", charID, 0 - item.ItemAmt, item.ItemType, item.ItemID, true)
            else
                -- ITEM HOLDS MORE ITEMS THAN REMAINING ITEMS
                ModifyItem(src, "char", charID, 0 - remainingItems, item.ItemType, item.ItemID, true)
            end
            remainingItems = remainingItems - item.ItemAmt
            if (remainingItems <= 0) then
                break
            end
        end
    end

    if (tonumber(amt) > 1) then
        TriggerClientEvent("Inventory:Client:ItemNotify", src, "remove", itemType, amt, itemdefs[itemType]["multiple"])
    else
        TriggerClientEvent("Inventory:Client:ItemNotify", src, "remove", itemType, amt, itemdefs[itemType]["singular"])
    end
    exports["soe-logging"]:ServerLog("Removed Inventory Item", ("HAS REMOVED INVENTORY ITEM | NAME: %s | AMOUNT: %s"):format(itemType, amt), src)
    return true
end

-- WHEN TRIGGERED, REMOVE INVENTORY ITEM BASED OFF ITEM ID
function RemoveItemByUID(src, itemUID, amt, silent)
    local amount = amt or 1
    local myInventory = RequestInventory(src, "left", true)
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    local itemName

    -- ITERATE THROUGH SOURCE'S INVENTORY FOR ITEM
    for uid, item in pairs(myInventory["leftInventory"]) do
        if (tonumber(uid) == tonumber(itemUID)) then
            itemName = item["ItemType"]
            ModifyItem(src, "char", charID, 0 - amount, item["ItemType"], item["ItemID"], true)
            break
        end
    end

    if (itemName ~= nil) then
        if not silent then
            if (tonumber(amount) > 1) then
                TriggerClientEvent("Inventory:Client:ItemNotify", src, "remove", itemName, amount, itemdefs[itemName]["multiple"])
            else
                TriggerClientEvent("Inventory:Client:ItemNotify", src, "remove", itemName, amount, itemdefs[itemName]["singular"])
            end
        end

        exports["soe-logging"]:ServerLog("Removed Inventory Item By UID", "HAS REMOVED AN INVENTORY ITEM BY UID | AMT: " .. amount .. " | NAME: " .. itemName, src)
        return true
    end
    return false
end

-- WHEN TRIGGERED, MODIFY AN INVENTORY ITEM
function ModifyItem(src, type, data, amt, name, id, server)
    local dataString
    local modifyItem
    if id then
        -- MODIFY EXISTING ITEM
        dataString = ("invtype=%s&invdata=%s&amt=%s&itemname=%s&itemid=%s&blockindex=%s"):format(type, data, amt, name, id, 0)
    else
        -- ADD NEW ITEM TO INVENTORY
        dataString = ("invtype=%s&invdata=%s&amt=%s&itemname=%s&blockindex=%s"):format(type, data, amt, name, 0)
    end

    modifyItem = exports["soe-nexus"]:PerformAPIRequest("/api/inventory/additem", dataString, true)
    if modifyItem.status then
        SyncInventory(type, data)
        if not server then
            TriggerEvent("Inventory:Client:SyncInventory", src)
        else
            return modifyItem
        end
    else
        print("A fatal error occurred while attempting to modify an item.")
    end
end

-- WHEN TRIGGERED, USE INVENTORY ITEM
function UseItem(src, itemid, amt, invtype, itemname, invdata)
    -- IF CAN'T USE, RETURN
    if not itemdefs[itemname].canUse then
        local errorMsg = json.encode({status = false, message = "Item cannot be used."})
        TriggerClientEvent("Inventory:Client:HandleServerCallback", src, 'UseItem', json.decode(errorMsg))
        return false
    end

    -- IF CAN'T REUSE, CONSUME
    if not itemdefs[itemname].reusable then
        if (tonumber(amt) > 1) then
            TriggerClientEvent("Inventory:Client:ItemNotify", src, "remove", itemname, amt, itemdefs[itemname]["multiple"])
        else
            TriggerClientEvent("Inventory:Client:ItemNotify", src, "remove", itemname, amt, itemdefs[itemname]["singular"])
        end
    end

    -- Force amount to -1 for now
    amt = -1
    local useItem = exports["soe-nexus"]:PerformAPIRequest("/api/inventory/additem", ("itemid=%s&amt=%s&invtype=%s&itemname=%s&invdata=%s&blockindex=%s"):format(itemid, amt, invtype, itemname, invdata, 0), true)
    if useItem.status then
        if (invtype == "char") then
            TriggerClientEvent("Inventory:Client:SyncInventory", src)
        end
        SyncInventory(invtype, invdata)
    else
        print("A fatal error occurred while attempting to use an item.")
    end
    TriggerClientEvent("Inventory:Client:HandleServerCallback", src, 'UseItem', useItem)
end

-- WHEN TRIGGERED, ADD INVENTORY ITEM
function AddItem(src, invtype, invdata, itemtype, itemamt, itemmeta)
    if (itemdefs[itemtype] == nil) then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = ('"%s" is an invalid inventory item!'):format(itemtype), length = 5000})
        return false
    end

    local function add(single)
        -- ADD ONE AT A TIME
        if single then
            itemamt = 1
        end

        local addItem = exports["soe-nexus"]:PerformAPIRequest("/api/inventory/additem", ("invtype=%s&invdata=%s&amt=%s&itemname=%s&meta=%s&blockindex=%s&new=%s"):format(invtype, invdata, itemamt, itemtype, itemmeta, 0, 1), true)
        if addItem.status then
            -- print("AddItem returned OK")
            SyncInventory(invtype, invdata)

            -- META-DATA CONTROL DEPENDING ON THE ITEM
            local itemMeta = json.decode(addItem.data.ItemMeta)

            -- ADD META FOR ITEMS THAT CAN'T STACK
            if not itemdefs[itemtype].canStack then
                itemMeta.canStack = false
            else
                itemMeta.canStack = true
            end

            if (itemdefs[itemtype].itemtype == "firearm") then
                math.randomseed(os.time())
                math.random() math.random()
                itemMeta.ammo = 0
                itemMeta.equipped = false
                itemMeta.flashlight = false
                itemMeta.suppressor = false
                itemMeta.scope = false
                itemMeta.grip = false
                itemMeta.serialNum = math.random(100000, 999999999)
            elseif (itemdefs[itemtype].itemtype == "weapon") then
                itemMeta.equipped = false
            elseif (itemdefs[itemtype].itemtype == "armor") then
                if (itemtype == "bodyarmor") then
                    itemMeta.remaining = 50
                elseif (itemtype == "platecarrier") then
                    itemMeta.remaining = 100
                elseif (itemtype == "lightarmor") then
                    itemMeta.remaining = 35
                end
            elseif (itemdefs[itemtype].itemtype == "scubagear") then
                if (itemtype == "scubagear") then
                    itemMeta.progress = 100
                    itemMeta.remaining = 300.0
                    itemMeta.loopTime = 3000
                    itemMeta.equipped = false
                elseif (itemtype == "scubagearmkii") then
                    itemMeta.progress = 100
                    itemMeta.remaining = 600.0
                    itemMeta.loopTime = 6000
                    itemMeta.equipped = false
                end
            elseif (itemdefs[itemtype].isChargeItem) then
                itemMeta.remaining = itemdefs[itemtype].maxCharge
            end
            ModifyItemMeta(addItem.data.ItemID, json.encode(itemMeta))

            if (invtype == "char") then
                -- Sync character inventory
                TriggerClientEvent("Inventory:Client:SyncInventory", src)
                if (itemamt > 1) then
                    TriggerClientEvent("Inventory:Client:ItemNotify", src, "add", itemtype, itemamt, itemdefs[itemtype]["multiple"])
                else
                    TriggerClientEvent("Inventory:Client:ItemNotify", src, "add", itemtype, itemamt, itemdefs[itemtype]["singular"])
                end

                local msg = ("HAS ADDED AN INVENTORY ITEM | AMOUNT: %s | NAME: %s | META: %s"):format(itemamt, itemtype, json.encode(itemMeta))
                exports["soe-logging"]:ServerLog("Added Inventory Item", msg, src)

                if (tonumber(itemamt) >= 20000) then
                    msg = ("HAS BEEN GIVEN A LARGE QUANTITY OF AN ITEM | AMOUNT: %s | NAME: %s"):format(itemamt, itemtype)
                    exports["soe-logging"]:ServerLog("Added Inventory Item - Potential Exploit", msg, src)
                    exports["soe-logging"]:ScreenshotScreen(src, "Added Inventory Item - Potential Exploit")
                end
                return true
            elseif (invtype == "tempveh") then
                return true
            elseif (invtype == "veh") then
                return true
            elseif (invtype == "dumpster") then
                return true
            else
                print("A fatal error occurred while attempting to add a new item. (1)", "Inventory Type Specified:", invtype)
                return false
            end
        else
            print("A fatal error occurred while attempting to add a new item. (2)", "API Return Error")
            return false
        end
    end

    -- IF ITEM IS STACKABLE, ADD THE WHOLE LOT OTHERWISE ADD ONE BY ONE
    if itemdefs[itemtype].canStack == nil or itemdefs[itemtype].canStack then
        return add()
    else
        local added = {}
        for amount = 1, itemamt do
            Wait(10)
            added[#added + 1] = add(true)
        end
        for _, bool in pairs(added) do
            if not bool then
                return false
            end
        end
        return true
    end
end

function RequestInventory(src, type, server, extraData)
    -- SET TYPE TO DEFAULT 'ALL'
    type = type or "all"

    -- REQUEST INVENTORY BY API REQUEST
    local data = exports["soe-uchuu"]:GetOnlinePlayerList()[tonumber(src)].CharID
    local returnTable = {}

    if type then
        -- GET CHARACTER INVENTORY
        local requestCharacterInventory = exports["soe-nexus"]:PerformAPIRequest("/api/inventory/get", ("invtype=%s&invdata=%s"):format("char", data), true)
        if requestCharacterInventory.status then
            returnTable["type"] = type
            returnTable["data"] = data
            returnTable["leftInventory"] = requestCharacterInventory.data
            returnTable["leftTitle"] = "MY POCKETS"
        else
            print("A fatal error occurred while attempting to request an inventory (1).")
        end
    end

    if (type == "veh") then
        -- CHECK IF PLAYER IS IN A VEHICLE
        local playerVehicle = GetVehiclePedIsIn(GetPlayerPed(src), false)
        if (playerVehicle ~= 0 and playerVehicle ~= nil) or extraData then
            local vehicleNetworkId = NetworkGetNetworkIdFromEntity(playerVehicle)
            local vin = exports["soe-valet"]:GetVehicleVIN(vehicleNetworkId)
            local licPlate = GetVehicleNumberPlateText(playerVehicle)

            -- ONLY IF PLAYER IS SEARCHING VEHICLE
            if extraData then
                class = extraData.class
                if not extraData.notFromOutside then
                    vehicleNetworkId = extraData.vehicleNetworkId
                end
            end
            vin = exports["soe-valet"]:GetVehicleVIN(vehicleNetworkId)

            -- ONLY IF PLAYER IS SEARCHING VEHICLE
            if extraData then
                class = extraData.class
                if not extraData.notFromOutside then
                    licPlate = extraData.licPlate
                end
            end

            local requestVehicleInventory
            if vin then
                requestVehicleInventory = exports["soe-nexus"]:PerformAPIRequest("/api/inventory/get", ("invtype=%s&invdata=%s"):format("veh", vin), true)
            else
                requestVehicleInventory = exports["soe-nexus"]:PerformAPIRequest("/api/inventory/get", ("invtype=%s&invdata=%s"):format("tempveh", licPlate), true)
            end

            if requestVehicleInventory and requestVehicleInventory.status then
                returnTable["rightInventory"] = requestVehicleInventory.data
                if vin then
                    returnTable["rightTitle"] = "VEHICLE STORAGE - VIN: " .. vin
                    TriggerEvent("Inventory:Server:ToggleOpenStatus", "veh", vin, true, src)
                else
                    if licPlate ~= nil then
                        returnTable["rightTitle"] = "VEHICLE STORAGE - PLATE: " .. licPlate
                        -- VEHICLE LOOT GENERATOR
                        if (extraData.canLoot == false) then
                            if GenerateVehicleLoot(src, class, licPlate) then
                                Wait(250)
                                -- REQUEST THE INVENTORY AGAIN FROM THE DATABASE
                                requestVehicleInventory = exports["soe-nexus"]:PerformAPIRequest("/api/inventory/get", ("invtype=%s&invdata=%s"):format("tempveh", licPlate), true)
                                if requestVehicleInventory and requestVehicleInventory.status then
                                    returnTable["rightInventory"] = requestVehicleInventory.data
                                end
                            end
                        end

                        -- OPEN INVENTORY AS USUAL
                        TriggerEvent("Inventory:Server:ToggleOpenStatus", "tempveh", licPlate, true, src)
                    end
                end
            else
                error("A fatal error occurred while attempting to request an inventory (2).")
            end
        end
    end

    if (type == "prop") then
        local requestPropertyInventory = exports["soe-nexus"]:PerformAPIRequest("/api/inventory/get", ("invtype=%s&invdata=%s"):format("prop", extraData.id), true)
        if requestPropertyInventory and requestPropertyInventory.status then
            returnTable["rightInventory"] = requestPropertyInventory.data
            returnTable["rightTitle"] = "PROPERTY STORAGE - " .. string.upper(extraData.address)
            TriggerEvent("Inventory:Server:ToggleOpenStatus", "prop", extraData.id, true, src)
        else
            error("A fatal error occurred while attempting to request an inventory (2).")
        end
    end

    if (type == "evidence") then
        local requestEvidenceInventory = exports["soe-nexus"]:PerformAPIRequest("/api/inventory/get", ("invtype=%s&invdata=%s"):format("evidence", extraData), true)
        if requestEvidenceInventory and requestEvidenceInventory.status then
            returnTable["rightInventory"] = requestEvidenceInventory.data
            returnTable["rightTitle"] = "EVIDENCE ROOM - EN " .. extraData
            TriggerEvent("Inventory:Server:ToggleOpenStatus", "evidence", extraData, true, src)
        else
            error("A fatal error occurred while attempting to request an inventory (2).")
        end
    end

    if (type == "casinganalysis") then
        returnTable["rightInventory"] = {}
        returnTable["rightTitle"] = "FORENSICS - CASING ANALYSIS"
        TriggerEvent("Inventory:Server:ToggleOpenStatus", "casinganalysis", extraData, true, src)
    end

    if (type == "bloodanalysis") then
        returnTable["rightInventory"] = {}
        returnTable["rightTitle"] = "FORENSICS - BLOOD ANALYSIS"
        TriggerEvent("Inventory:Server:ToggleOpenStatus", "bloodanalysis", extraData, true, src)
    end

    if (type == "printanalysis") then
        returnTable["rightInventory"] = {}
        returnTable["rightTitle"] = "FORENSICS - FINGERPRINT ANALYSIS"
        TriggerEvent("Inventory:Server:ToggleOpenStatus", "printanalysis", extraData, true, src)
    end

    if (type == "vehfragmentanalysis") then
        returnTable["rightInventory"] = {}
        returnTable["rightTitle"] = "FORENSICS - VEHICLE FRAGMENT ANALYSIS"
        TriggerEvent("Inventory:Server:ToggleOpenStatus", "vehfragmentanalysis", extraData, true, src)
    end

    if (type == "locker") then
        local requestLockerInv = exports["soe-nexus"]:PerformAPIRequest("/api/inventory/get", ("invtype=%s&invdata=%s"):format("locker", extraData), true)
        if requestLockerInv and requestLockerInv.status then
            returnTable["rightInventory"] = requestLockerInv.data
            returnTable["rightTitle"] = "LOCKER - SSN #" .. extraData
            TriggerEvent("Inventory:Server:ToggleOpenStatus", "locker", extraData, true, src)
        else
            error("A fatal error occurred while attempting to request a locker's inventory.")
        end
    end

    if (type == "trash") then
        local requestTrashInv = exports["soe-nexus"]:PerformAPIRequest("/api/inventory/get", ("invtype=%s&invdata=%s"):format("trash", 1), true)
        if requestTrashInv and requestTrashInv.status then
            returnTable["rightInventory"] = requestTrashInv.data
            returnTable["rightTitle"] = "TRASH"
            TriggerEvent("Inventory:Server:ToggleOpenStatus", "trash", extraData, true, src)
        else
            error("A fatal error occurred while attempting to request a trash's inventory.")
        end
    end

    if (type == "dumpster") then
        local requestDumpsterInv = exports["soe-nexus"]:PerformAPIRequest("/api/inventory/get", ("invtype=%s&invdata=%s"):format("dumpster", extraData.binID), true)
        if requestDumpsterInv and requestDumpsterInv.status then
            returnTable["rightInventory"] = requestDumpsterInv.data
            returnTable["rightTitle"] = "BIN-" .. extraData.binID
            -- DUMPSTER LOOT GENERATOR
            if GenerateBinLoot(src, extraData.binID) then
                Wait(250)
                -- REQUEST THE INVENTORY AGAIN FROM THE DATABASE
                requestDumpsterInv = exports["soe-nexus"]:PerformAPIRequest("/api/inventory/get", ("invtype=%s&invdata=%s"):format("dumpster", extraData.binID), true)
                if requestDumpsterInv and requestDumpsterInv.status then
                    returnTable["rightInventory"] = requestDumpsterInv.data
                end
            end

            -- OPEN INVENTORY AS USUAL
            TriggerEvent("Inventory:Server:ToggleOpenStatus", "dumpster", extraData.binID, true, src)
        else
            error("A fatal error occurred while attempting to request an dumpster's inventory.")
        end
    end

    if (type == "search") then
        local requestSearchInventory = exports["soe-nexus"]:PerformAPIRequest("/api/inventory/get", ("invtype=%s&invdata=%s"):format("char", extraData), true)
        if requestSearchInventory and requestSearchInventory.status then
            returnTable["rightInventory"] = requestSearchInventory.data
            returnTable["rightTitle"] = "SEARCH RESULTS"
            TriggerEvent("Inventory:Server:ToggleOpenStatus", "char", extraData, true, src)
        else
            error("A fatal error occurred while attempting to request an inventory (2).")
        end
    end

    if (type == "frisk") then
        local requestFriskInventory = exports["soe-nexus"]:PerformAPIRequest("/api/inventory/get", ("invtype=%s&invdata=%s"):format("char", extraData), true)
        if requestFriskInventory and requestFriskInventory.status then
            local sendInv = {}
            for itemID, eachItem in pairs(requestFriskInventory.data) do
                if itemdefs[eachItem.ItemType].itemtype == "weapon" or itemdefs[eachItem.ItemType].itemtype == "firearm" or itemdefs[eachItem.ItemType].itemtype == "armor" then
                    sendInv[itemID] = eachItem
                end
            end

            returnTable["rightInventory"] = sendInv
            returnTable["rightTitle"] = "FRISK RESULTS"
            TriggerEvent("Inventory:Server:ToggleOpenStatus", "char", extraData, true, src)
        else
            error("A fatal error occurred while attempting to request an inventory (2).")
        end
    end

    if (type == "storage") then
        local requestBusinessStorageInv = exports["soe-nexus"]:PerformAPIRequest("/api/inventory/get", ("invtype=%s&invdata=%s"):format("storage", extraData), true)
        if requestBusinessStorageInv and requestBusinessStorageInv.status then
            returnTable["rightInventory"] = requestBusinessStorageInv.data
            returnTable["rightTitle"] = "Storage - " .. extraData
            TriggerEvent("Inventory:Server:ToggleOpenStatus", "storage", extraData, true, src)
        else
            error("A fatal error occurred while attempting to request a business storage's inventory.")
        end
    end

    if (type == "counter") then
        local requestBusinessCounterInv = exports["soe-nexus"]:PerformAPIRequest("/api/inventory/get", ("invtype=%s&invdata=%s"):format("counter", extraData), true)
        if requestBusinessCounterInv and requestBusinessCounterInv.status then
            returnTable["rightInventory"] = requestBusinessCounterInv.data
            returnTable["rightTitle"] = extraData .. " - Counter"
            TriggerEvent("Inventory:Server:ToggleOpenStatus", "counter", extraData, true, src)
        else
            error("A fatal error occurred while attempting to request a business counter's inventory.")
        end
    end

    -- RETURN RESULTS
    if not server then
        TriggerClientEvent("Inventory:Client:HandleServerCallback", src, 'RequestInventory', returnTable)
    else
        return returnTable
    end
end

-- **********************
--       Commands
-- **********************
-- WHEN TRIGGERED, UNLOAD CURRENT WEAPON
RegisterCommand("unload", function(source)
    local src = source
    TriggerClientEvent("Inventory:Client:UnloadAmmo", src, {status = true})
end)

-- WHEN TRIGGERED, OPEN A EVIDENCE LOCKER
RegisterCommand("evidence", function(source, args)
    local src = source
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    if tonumber(args[1]) and (char.CivType == "POLICE" or char.CivType == "CRIMELAB") then
        local pos = GetEntityCoords(GetPlayerPed(src))
        for _, room in pairs(evidenceRooms) do
            if #(pos - room.pos) <= room.range then
                TriggerClientEvent("Inventory:Client:ShowInventory", src, "evidence", false, tonumber(args[1]))
                return
            end
        end
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "No evidence rooms located nearby", length = 5000})
        return
    end
    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Please enter a case number for this evidence", length = 5000})
end)

-- WHEN TRIGGERED, OPEN TRASH
RegisterCommand("trash", function(source)
    local src = source
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]

    if (char.CivType == "POLICE" or char.CivType == "EMS" or char.CivType == "CRIMELAB") then
        local isNearby = false
        local pos = GetEntityCoords(GetPlayerPed(src))
        for _, lockers in pairs(lockerRooms) do
            if #(pos - lockers.pos) <= lockers.range then
                isNearby = true
                break
            end
        end

        -- ARGUMENT CHECK
        if isNearby then
            TriggerClientEvent("Inventory:Client:ShowInventory", src, "trash", false, 1)
        else
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You are not near a locker room", length = 5000})
        end
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for Emergency Services.")
    end
end)

-- WHEN TRIGGERED, OPEN A LEO/EMS'S LOCKER
RegisterCommand("locker", function(source, args)
    local src = source
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]

    if (char.CivType == "POLICE" or char.CivType == "EMS") then
        local isNearby = false
        local pos = GetEntityCoords(GetPlayerPed(src))
        for _, lockers in pairs(lockerRooms) do
            if #(pos - lockers.pos) <= lockers.range then
                isNearby = true
                break
            end
        end

        -- ARGUMENT CHECK
        if isNearby then
            TriggerClientEvent("Inventory:Client:ShowInventory", src, "locker", false, tonumber(char.CharID))
        else
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You are not near a locker room", length = 5000})
        end
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for Emergency Services.")
    end
end)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, EDIT INVENTORY ITEM META
RegisterNetEvent("Inventory:Server:EditItemMeta")
AddEventHandler("Inventory:Server:EditItemMeta", function(itemID, itemMeta)
    local src = source
    ModifyItemMeta(itemID, json.encode(itemMeta))
end)

-- WHEN TRIGGERED, HANDLE INVENTORY CLOSE EVENT FROM CLIENT SECURELY
RegisterNetEvent("Inventory:Server:CloseInventory")
AddEventHandler("Inventory:Server:CloseInventory", function()
    local src = tonumber(source)

    -- RUN LAB TESTS IF NEEDED
    if openInventories[src] then
        if openInventories[src]["type"] == "casinganalysis" or openInventories[src]["type"] == "bloodanalysis" or openInventories[src]["type"] == "printanalysis" or openInventories[src]["type"] == "vehfragmentanalysis" then
            TriggerEvent("CSI:Server:AnalyzeCasings", src)
            TriggerEvent("CSI:Server:AnalyzeBloodDrops", src)
            TriggerEvent("CSI:Server:AnalyzePrints", src)
            TriggerEvent("CSI:Server:AnalyzeVehFragments", src)
        end
    end

    playersSearching[src] = false

    TriggerEvent("Inventory:Server:ToggleOpenStatus", "", "", false, src)
end)

-- WHEN TRIGGERED, REQUEST INVENTORY FROM API
RegisterNetEvent("Inventory:Server:RequestInventory")
AddEventHandler("Inventory:Server:RequestInventory", function(type, serverSauce, extraData)
    local src = source
    if tonumber(source) then
        RequestInventory(src, type, false, extraData)
    else
        RequestInventory(serverSauce, type, false, extraData)
    end
end)

-- WHEN TRIGGERED, MERGE INVENTORY ITEM BASED ON DATA
RegisterNetEvent("Inventory:Server:MergeItem")
AddEventHandler("Inventory:Server:MergeItem", function(itemid1, itemid2)
    local src = source
    if tonumber(source) then
        MergeItem(src, itemid1, itemid2)
    else
        MergeItem(serverSauce, itemid1, itemid2)
    end

    local msg = ("HAS MERGED INVENTORY ITEMS | ITEM 1: %s | ITEM 2: %s"):format(itemid1, itemid2)
    exports["soe-logging"]:ServerLog("Inventory Items Merged", msg, src)
end)

-- WHEN TRIGGERED, SPLIT INVENTORY ITEM
RegisterNetEvent("Inventory:Server:SplitItem")
AddEventHandler("Inventory:Server:SplitItem", function(itemId, itemAmt, serverSauce)
    local src = source
    if tonumber(source) then
        SplitItem(src, itemId, itemAmt)
    else
        SplitItem(serverSauce, itemId, itemAmt)
    end

    local msg = ("HAS SPLIT AN INVENTORY ITEM | AMOUNT: %s | ITEM ID: %s"):format(itemAmt, itemID)
    exports["soe-logging"]:ServerLog("Inventory Item Split", msg, src)
end)

-- WHEN TRIGGERED, MODIFY INVENTORY ITEM BASED ON DATA
RegisterNetEvent("Inventory:Server:ModifyItem")
AddEventHandler("Inventory:Server:ModifyItem", function(type, data, amt, name, id, serverSauce)
    local src = source
    if tonumber(source) then
        ModifyItem(src, type, data, amt, name, id)
    else
        ModifyItem(serverSauce, type, data, amt, name, id)
    end

    local msg = ("HAS MODIFIED AN INVENTORY ITEM | NEW AMOUNT: %s | ITEM ID: %s | NAME: %s"):format(itemAmt, itemID, name)
    exports["soe-logging"]:ServerLog("Inventory Item Modified", msg, src)
end)

-- WHEN TRIGGERED, TOGGLE OPEN STATUS OF INVENTORY
RegisterNetEvent("Inventory:Server:ToggleOpenStatus")
AddEventHandler("Inventory:Server:ToggleOpenStatus", function(type, data, bool, serverSauce)
    local src
    if tonumber(source) then
        src = source
    else
        src = serverSauce
    end

    if bool then
        openInventories[src] = {type = type, data = data}
        --print("Setting open - src:", src, json.encode(openInventories[src]))
    else
        openInventories[src] = nil
        --print("Setting closed")
    end
end)

-- CALLED FROM CLIENT TO FIND THE CORRECT BODY ARMOR BEING USED
RegisterNetEvent("Inventory:Server:UseBodyArmor", function(itemID, itemName, displayName)
    local src = source
    local getArmor = GetItemData(src, itemName, "left")
    local armorFound

    -- ITERATE THROUGH ARMOR PIECES FOUND
    for armorID, armorData in pairs(getArmor) do
        if (tonumber(armorID) == tonumber(itemID)) then
            armorFound = armorData
        end
    end

    -- IF WE FOUND OUR ARMOR PIECE, USE IT IN THE CLIENT
    if not armorFound then return end
    TriggerClientEvent("Inventory:Client:UseBodyArmor", src, itemID, itemName, displayName, json.decode(armorFound["ItemMeta"])["remaining"] or 0)
end)

-- SENT FROM CLIENT TO UPDATE BODY ARMOR STATUS LEVEL
RegisterNetEvent("Inventory:Server:UpdateArmorWelfare", function(itemID, itemName, remaining)
    local src = source
    local getArmor = GetItemData(src, itemName, "left")
    local armorFound

    -- ITERATE THROUGH ARMOR PIECES FOUND
    for armorID, armorData in pairs(getArmor) do
        if (tonumber(armorID) == tonumber(itemID)) then
            armorFound = armorData
        end
    end

    -- IF WE FOUND OUR ARMOR PIECE, UPDATE THE ARMOR'S WELFARE LEVEL
    if armorFound then
        local itemMeta = json.decode(armorFound["ItemMeta"]) or {}
        itemMeta["remaining"] = remaining
        ModifyItemMeta(itemID, json.encode(itemMeta))
    end
end)

-- WHEN TRIGGERED, USE INVENTORY ITEM
RegisterNetEvent("Inventory:Server:UseItem")
AddEventHandler("Inventory:Server:UseItem", function(itemId, itemAmt, itemName, parentContainer, serverSauce)
    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[tonumber(src)].CharID
    if tonumber(source) then
        src = source
    else
        src = serverSauce
    end

    if (parentContainer == "left") then
        -- Character Inventory
        UseItem(src, itemId, itemAmt, "char", itemName, charID)
    else
        -- Other Inventory
        UseItem(src, itemId, itemAmt, "char", itemName, openInventories[src].data)
    end

    -- MAKE A SERVER LOG
    local msg = ("HAS USED INVENTORY ITEM | NAME: %s | AMOUNT: %s | ITEM ID: %s"):format(itemName, itemAmt, itemId)
    exports["soe-logging"]:ServerLog("Inventory Item Used", msg, src)
end)

-- WHEN TRIGGERED, SHOW STATE LICENSE TO PLAYERS AROUND THE SOURCE
RegisterNetEvent("Inventory:Server:UseStateLicense", function(itemID)
    local src = source
    local getLicenses = GetItemData(src, "statelicense", "left")
    local thisLicense

    -- ITERATE THROUGH LICENSES FOUND
    for licenseID, licenseData in pairs(getLicenses) do
        if (tonumber(licenseID) == tonumber(itemID)) then
            thisLicense = licenseData
        end
    end

    -- IF WE FOUND OUR LICENSE, SHOW IT TO CLIENTS AROUND THE SOURCE
    if not thisLicense then
        return
    end

    local licenseData = json.decode(thisLicense["ItemMeta"]) or {}

    --[[local ssn, firstGiven, lastGiven = licenseData["SSN"] or 0, licenseData["FirstGiven"] or "Danny", licenseData["LastGiven"] or "Default"
    local DOB, issuedDate, expiryDate = licenseData["DOB"] or "2000-01-01", licenseData["IssuedDate"] or "2000-01-01", licenseData["ExpiryDate"] or "2099-01-01"
    local msg = ("ID #: ^2%s ^0| SSN #: ^2%s ^0| First: ^2%s ^0Last: ^2%s ^0| DOB: ^2%s ^0| Issued Date: ^2%s ^0| Expiry Date: ^2%s ^0"):format(itemID, ssn, firstGiven, lastGiven, DOB, issuedDate, expiryDate)

    exports["soe-chat"]:DoProximityMessage(src, 10.0, "id", "[ID]", "", msg)]]
    local myPos = GetEntityCoords(GetPlayerPed(src))
    for serverID in pairs(exports["soe-uchuu"]:GetOnlinePlayerList()) do
        local pos = GetEntityCoords(GetPlayerPed(serverID))
        if #(myPos - pos) <= 6.0 then
            TriggerClientEvent("UI:Client:ShowLicense", serverID, licenseData, itemID)
        end
    end

    if not exports["soe-utils"]:IsModelADog(GetPlayerPed(src)) and not exports["soe-emergency"]:IsRestrained(src) then
        exports["soe-emotes"]:PlayEmote(src, "give2")
    end
end)

-- WHEN TRIGGERED, MOVE INVENTORY ITEM
RegisterNetEvent("Inventory:Server:MoveItem", function(toContainer, fromContainer, id, amt)
    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[tonumber(src)].CharID

    if (toContainer == "hand") then
        return
    elseif (toContainer == "right") then
        if (openInventories[src].type == "trash") then
            RemoveItemByUID(src, id, amt, true)
            TriggerClientEvent("Inventory:Client:SyncInventory", src)

            -- MAKE A SERVER LOG
            local msg = ("HAS TRASHED AN INVENTORY ITEM | FROM CONTAINER: %s | ITEM ID: %s | AMOUNT: %s"):format(fromContainer, id, amt)
            exports["soe-logging"]:ServerLog("Inventory Item Trashed", msg, src)
            return
        end

        if (openInventories[src].type == "casinganalysis" or openInventories[src].type == "bloodanalysis" or openInventories[src].type == "printanalysis" or openInventories[src].type == "vehfragmentanalysis") then
            exports["soe-csi"]:AddToForensicsQueue(id, openInventories[src]["data"], src)
            return
        end

        if openInventories[src] then
            MoveItem(src, openInventories[src].type, openInventories[src].data, id)
        else
            print("MoveItem Validation Failed 1")
        end
    else
        MoveItem(src, "char", charID, id)
        if openInventories[src] then
            SyncInventory(openInventories[src].type, openInventories[src].data)
        else
            print("MoveItem Validation Failed 3")
        end
    end

    -- MAKE A SERVER LOG
    local msg = ("HAS MOVED AN INVENTORY ITEM | FROM CONTAINER: %s | TO CONTAINER: %s | ITEM ID: %s"):format(fromContainer, toContainer, id)
    exports["soe-logging"]:ServerLog("Inventory Item Moved", msg, src)
end)

-- WHEN TRIGGERED, CHECK IF PLAYER CAN RECEIVE STARTER ITEMS
RegisterNetEvent("Inventory:Server:StarterItemChecks", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 18278-1 | Lua-Injecting Detected.", 0)
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 18278-2 | Lua-Injecting Detected.", 0)
    end

    Wait(1500)
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    local getPlaytime = exports["soe-nexus"]:PerformAPIRequest("/api/character/playtime", "charid=" .. char.CharID, true)
    if not getPlaytime["status"] then
        exports["soe-logging"]:ServerLog("Starter Items Given (Failed)", "DID NOT GET STARTER ITEMS | PLAYTIME API DIDN'T WORK", src)
        return
    end

    if (tonumber(getPlaytime["data"]) <= 0) then
        local starterCash = exports["soe-config"]:GetConfigValue("economy", "startercash") or 1500
        AddItem(src, "char", char.CharID, "water", 10, "{}")
        AddItem(src, "char", char.CharID, "sandwich", 10, "{}")
        AddItem(src, "char", char.CharID, "cash", tonumber(starterCash), "{}")
        TriggerClientEvent("Gov:Client:IssueNewStateLicense", src)

        -- GIVE THE CHARACTER A PHONE AS WELL
        exports["soe-nexus"]:PerformAPIRequest("/api/phone/modify", ("func=%s&model=%s&style=%s&charid=%s"):format("create", "gPhone", "black", char.CharID), true)
        exports["soe-logging"]:ServerLog("Starter Items Given (Success)", "WAS SUCCESSFULLY GIVEN STARTER ITEMS", src)
    else
        exports["soe-logging"]:ServerLog("Starter Items Given (Failed)", "DID NOT GET STARTER ITEMS | PLAYTIME TOO HIGH", src)
    end
end)

-- WHEN TRIGGERED, ADD ITEM TO PLAYER
RegisterNetEvent("Inventory:Server:AddItem")
AddEventHandler("Inventory:Server:AddItem", function(data)
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 927 | Lua-Injecting Detected.", 0)
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 928 | Lua-Injecting Detected.", 0)
    end

    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID

    if data.itemsToGive ~= nil then
        for _, itemData in pairs (data.itemsToGive) do
            -- AMOUNT CHECK
            local amount = 0
            if itemData.amount ~= nil then
                amount = itemData.amount
            end

            -- ADD THE ITEM
            if itemData.itemName ~= nil then
                AddItem(src, "char", charID, itemData.itemName, amount, "{}")
            end
        end
    else
        -- AMOUNT CHECK
        local amount = 0
        if data.amount ~= nil then
            amount = data.amount
        end

        -- ADD THE ITEM
        if data.itemName ~= nil then
            AddItem(src, "char", charID, data.itemName, amount, "{}")
        end
    end

    -- REMOVES REQUIRED ITEMS
    if data.itemToRemove ~= nil then
        RemoveItem(src, data.removeAmt, data.itemToRemove)
    end

    -- UPDATE META OF ORIGINAL ITEM AND REMOVE IF NEW REMAINING IS 0
    if data.newItemMeta.remaining >= 1 then
        ModifyItemMeta(data.itemUID, json.encode(data.newItemMeta))
    else
        RemoveItemByUID(src, data.itemUID)
    end
end)

-- SENT FROM CLIENT TO EQUIP WEAPON ATTACHMENT
RegisterNetEvent("Inventory:Server:EquipAttachment")
AddEventHandler("Inventory:Server:EquipAttachment", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 8281-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 8281-2 | Lua-Injecting Detected.", 0)
        return
    end

    -- ITERATE THROUGH GUNS FOUND
    local found
    local getGuns = GetItemData(src, data.gun.hash, "left")
    for gunID, gunData in pairs(getGuns) do
        if (tonumber(gunID) == tonumber(data.gun.uid)) then
            found = gunData
            break
        end
    end

    if found then
        local itemMeta = json.decode(found.ItemMeta)
        if (data.attachment == "pistol_flashlight") then
            if not weaponAttachments["Pistol Flashlight"][data.gun.hash] then
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "This attachment is incompatible with this gun", length = 5000})
                return
            end
            itemMeta.flashlight = "pistol"
        elseif (data.attachment == "rifle_flashlight") then
            if not weaponAttachments["Rifle Flashlight"][data.gun.hash] then
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "This attachment is incompatible with this gun", length = 5000})
                return
            end
            itemMeta.flashlight = "rifle"
        elseif (data.attachment == "small_silencer") then
            if not weaponAttachments["Small Silencer"][data.gun.hash] then
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "This attachment is incompatible with this gun", length = 5000})
                return
            end
            itemMeta.suppressor = "pistol"
        elseif (data.attachment == "large_silencer") then
            if not weaponAttachments["Large Silencer"][data.gun.hash] then
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "This attachment is incompatible with this gun", length = 5000})
                return
            end
            itemMeta.suppressor = "rifle"
        elseif (data.attachment == "holographic_sight") then
            if not weaponAttachments["Holographic Sight"][data.gun.hash] then
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "This attachment is incompatible with this gun", length = 5000})
                return
            end
            itemMeta.scope = "holographic"
        elseif (data.attachment == "gun_scope") then
            if not weaponAttachments["Normal Scope"][data.gun.hash] then
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "This attachment is incompatible with this gun", length = 5000})
                return
            end
            itemMeta.scope = "normal"
        elseif (data.attachment == "rifle_grip") then
            if not weaponAttachments["Rifle Grip"][data.gun.hash] then
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "This attachment is incompatible with this gun", length = 5000})
                return
            end
            itemMeta.grip = true
        end
        RemoveItem(src, 1, data.attachment)
        ModifyItemMeta(data.gun.uid, json.encode(itemMeta))

        -- HAVE CLIENT HIDE WEAPON TO UPDATE IT
        TriggerClientEvent("Inventory:Client:UpdateWeaponAttachment", src, {status = true, hash = data.gun.hash, attachment = data.attachment})
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "You put an attachment on your gun", length = 5000})
    end
end)