local myCurrentWeapon
local isInvOpen, currentParachute = false, false
local lastWeightWarning = GetGameTimer() - 60000

myInventory = nil
myTotalWeight = 0.0
wearingArmor = false
myArmorData, myEquippedWeapons = {}, {}

-- DECORATORS
DecorRegister("noInventoryLoot", 2)

-- KEY MAPPINGS
RegisterKeyMapping("inv", "[Inventory] Open Inventory", "KEYBOARD", "F7")

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, LOOK FOR THE NEAREST BIN
local function FindBin(ped)
    local startPos = GetOffsetFromEntityInWorldCoords(ped, 0, 0.1, 0)
    local endPos = GetOffsetFromEntityInWorldCoords(ped, 0, 1.8, -0.4)
    local shapeTestHandle = StartShapeTestRay(startPos.x, startPos.y, startPos.z, endPos.x, endPos.y, endPos.z, 16, ped, 0)

    local netID
    local _, _, _, _, ent = GetShapeTestResult(shapeTestHandle)

    if bins[tonumber(GetEntityModel(ent))] then
        exports["soe-utils"]:RegisterEntityAsNetworked(ent)
        netID = NetworkGetNetworkIdFromEntity(ent)
        SetNetworkIdExistsOnAllMachines(netID, true)
        return netID
    end
    return netID
end

-- WHEN TRIGGERED, OPENING AN INVENTORY CHECKS CERTAIN THINGS FIRST
local function HandleInventoryTasks()
    local ped = PlayerPedId()
    local myBin = FindBin(ped)
    local myProperty = exports["soe-properties"]:GetCurrentProperty()

    if IsPedInAnyVehicle(ped, false) then
        local veh = GetVehiclePedIsIn(ped, false)
        local canLoot = DecorGetBool(veh, "noInventoryLoot")
        TriggerEvent("Inventory:Client:ShowInventory", "veh", false, {class = GetVehicleClass(veh), canLoot = canLoot, notFromOutside = true})
    elseif (myProperty ~= nil) then
        TriggerEvent("Inventory:Client:ShowInventory", "prop", false, myProperty)
    elseif (myBin ~= nil) then
        TriggerEvent("Inventory:Client:ShowInventory", "dumpster", false, {binID = myBin, dumpster = true})
    else
        TriggerEvent("Inventory:Client:ShowInventory", "all", false)
    end
end

-- WHEN TRIGGERED, DO SOME CALCULATIONS FOR WEIGHT VIA CASH
local function GetCashWeight(amount, item)
    local singleWeight = itemdefs[item].weight
    if amount <= 50 then
        -- $1 BILLS
        return amount * singleWeight
    elseif amount > 50 and amount <= 200 then
        -- $5 BILLS
        return (amount * singleWeight) / 5
    elseif amount > 200 and amount <= 500 then
        -- $10 BILLS
        return (amount * singleWeight) / 10
    elseif amount > 500 and amount <= 2000 then
        -- $20 BILLS
        return (amount * singleWeight) / 20
    elseif amount > 2000 and amount <= 10000 then
        -- $50 BILLS
        return (amount * singleWeight) / 50
    elseif amount > 10000 then
        -- $100 BILLS
        return (amount * singleWeight) / 100
    end
end

-- UPDATES TOTAL WEIGHT FOR ENFORCEMENT DURING SYNCING/OPENING
local function UpdateMyTotalWeight(myInventory)
    myTotalWeight = 0.0
    for _, itemData in pairs(myInventory) do
        if itemdefs[itemData.ItemType] then
            if (itemData.ItemAmt >= 1) then
                if itemData.ItemType == "cash" or itemData.ItemType == "dirtycash" then
                    local weight = GetCashWeight(itemData.ItemAmt, itemData.ItemType)
                    myTotalWeight = myTotalWeight + weight
                else
                    myTotalWeight = myTotalWeight + (itemdefs[itemData.ItemType].weight * itemData.ItemAmt)
                end
            end
        end
    end
end

-- SORTS THE INVENTORY ALPHABETICALLY
local function SortInventoryByName(inventoryToSort)
    -- SAVE REQUIRED DATA TO TEMP TABLE FOR LATER USE
    local tempTable = {}
    for index = 1, #inventoryToSort.items do
        local itemName = string.lower(inventoryToSort.items[index].displayname.single)
        tempTable[#tempTable + 1] = {itemName = itemName, originalIndex = index, data = inventoryToSort.items[index]}
    end

    -- SORT THE DATA ALPHABETICALLY
    local function NameSort(a, b)
        if string.lower(a.itemName) < string.lower(b.itemName) then
            return true
        else
            return false
        end
    end
    table.sort(tempTable, NameSort)

    -- UPDATE ORIGINAL TABLE WITH SORTED DATA
    for i = 1, #tempTable do
        inventoryToSort.items[i] = tempTable[i].data
    end
end

-- BUILD ITEM DESCRIPTION
local function BuildItemDescription(itemData, itemID)
    local description = itemdefs[itemData.ItemType].description
    local meta = json.decode(itemData.ItemMeta)

    if meta.canStack == nil then
        meta.canStack = itemdefs[itemData.ItemType].canStack
        TriggerServerEvent("Inventory:Server:EditItemMeta", itemID, meta)
    end

    -- SET META DATA DISPLAY
    if (itemData.ItemType == "rifle_casing" or itemData.ItemType == "shotgun_shell" or itemData.ItemType == "pistol_casing") then
        description = ("%s<br><br>Casing ID: <span style='color:gold'>%s</span>"):format(description, meta.casingID)
    elseif (itemData["ItemType"] == "vehiclefragment") then
        if meta["genericColor"] then
            description = ("%s<br><br>Fragment Color: <span style='color:gold'>%s</span>"):format(description, meta["genericColor"])
        end

        if meta["fragmentID"] then
            description = ("%s<br><br>Fragment ID: <span style='color:gold'>%s</span>"):format(description, meta["fragmentID"])
        end
    elseif (itemData.ItemType == "plate") then
        description = ("%s<br><br>Plate: <span style='color:gold'>%s</span>"):format(description, meta.plate)
    elseif (itemData.ItemType == "bloodsample") then
        description = ("%s<br><br>Sample ID: <span style='color:gold'>%s</span>"):format(description, meta.bloodID)
    elseif (itemData.ItemType == "liftedprint") then
        description = ("%s<br><br>Print ID: <span style='color:gold'>%s</span>"):format(description, meta.printID)
    elseif (itemData.ItemType == "gsrresult") then
        description = ("%s<br><br>Test Result: <span style='color:gold'>%s</span><br>Label: <span style='color:gold'>%s</span>"):format(description, meta.result, meta.label)
    elseif (itemdefs[itemData.ItemType].itemtype == "firearm") then
        description = ("%s<br><br>Ammo: <span style='color:CornflowerBlue'>%s</span>"):format(description, meta.ammo)
        -- SHOW SERIAL NUMBER
        if (meta.serialNum ~= nil) then
            description = ("%s<br>Serial Number: <span style='color:gold'>%s</span>"):format(description, meta.serialNum)
        end

        -- SHOW IF THE WEAPON HAS AN ATTACHMENT
        if not itemdefs[itemData.ItemType].noAttachments then
            if meta.flashlight then
                description = description .. "<br><br>Flashlight: <span style='color:green'>Yes</span>"
            else
                description = description .. "<br><br>Flashlight: <span style='color:red'>No</span>"
            end

            if meta.suppressor then
                description = description .. "<br>Suppressor: <span style='color:green'>Yes</span>"
            else
                description = description .. "<br>Suppressor: <span style='color:red'>No</span>"
            end

            --[[if meta.scope then
                description = description .. "<br>Scope: <span style='color:green'>Yes</span>"
            else
                description = description .. "<br>Scope: <span style='color:red'>No</span>"
            end]]
        end
    elseif itemdefs[itemData.ItemType].itemtype == "armor" then
        if meta.remaining ~= nil then
            description = ("%s<br><br>Armor Welfare: <span style='color:gold'>%s</span>"):format(description, meta.remaining)
        end
    elseif itemData.ItemType == "citation" then
        if meta.charges ~= nil then
            description = ("%s<br><br>Charges: %s<br>Amount: $%s<br>Issued By: %s<br>Issued To: %s"):format(description, meta.charges, meta.amount, meta.issuedBy, meta.issuedTo)
        end
    elseif itemdefs[itemData.ItemType].isChargeItem ~= nil then
        if meta.remaining ~= nil then
            description = ("%s<br><br>Remaining: <span style='color:gold'>%s</span>"):format(description, meta.remaining)
        end
    elseif itemdefs[itemData.ItemType].itemtype == "scubagear" then
        if meta.progress ~= nil then
            description = ("%s<br><br>Remaining: <span style='color:gold'>%s%s</span>"):format(description, meta.progress, "%")
        end
        if meta.remaining ~= nil then
            description = ("%s<br><br>Time: <span style='color:gold'>%s seconds</span>"):format(description, meta.remaining)
        end
        if meta.equipped ~= nil then
            local color = "green"
            if not meta.equipped then
                color = "red"
            end
            description = description .. ("<br><br>Equipped: <span style='color:%s'>%s</span>"):format(color, meta.equipped)
        end
    elseif (itemdefs[itemData.ItemType].itemtype == "badge") then
        -- SHOW BADGE INFO
        if (meta.company ~= nil) then
            description = ("%s<br><br>- Company -<br> <span style='color:CornflowerBlue'>%s</span>"):format(description, meta.company)
            description = ("%s<br>"):format(description)
        end
        if (meta.agency ~= nil) then
            description = ("%s<br><br>- Agency -<br> <span style='color:CornflowerBlue'>%s</span>"):format(description, meta.agency)
            description = ("%s<br>"):format(description)
        end
        if (meta.firstName ~= nil) then
            description = ("%s<br>First Name: <span style='color:gold'>%s</span>"):format(description, meta.firstName)
        end
        if (meta.lastName ~= nil) then
            description = ("%s<br>Last Name: <span style='color:gold'>%s</span>"):format(description, meta.lastName)
        end
        if (meta.rank ~= nil) then
            description = ("%s<br>Rank: <span style='color:gold'>%s</span>"):format(description, meta.rank)
        end
        if (meta.callsign ~= nil) then
            description = ("%s<br>Callsign: <span style='color:gold'>%s</span>"):format(description, meta.callsign)
        end
        if (meta.serialNum ~= nil) then
            description = ("%s<br>Serial Number: <span style='color:gold'>%s</span>"):format(description, meta.serialNum)
        end
    elseif (itemData["ItemType"] == "statelicense") then -- SHOW LICENSE INFO
        if (meta["SSN"] ~= nil) then
            description = ("%s<br><br>SSN: <span style='color:gold'>%s</span>"):format(description, meta["SSN"])
        end

        if (itemID ~= nil) then
            description = ("%s<br>ID #: <span style='color:gold'>%s</span>"):format(description, itemID)
        end

        if (meta["FirstGiven"] ~= nil) then
            description = ("%s<br>First Name: <span style='color:gold'>%s</span>"):format(description, meta["FirstGiven"])
        end

        if (meta["LastGiven"] ~= nil) then
            description = ("%s<br>Last Name: <span style='color:gold'>%s</span>"):format(description, meta["LastGiven"])
        end

        if (meta["DOB"] ~= nil) then
            description = ("%s<br>Date of Birth: <span style='color:gold'>%s</span>"):format(description, meta["DOB"])
        end

        --[[if (meta["IssuedDate"] ~= nil) then
            description = ("%s<br>Issued Date: <span style='color:gold'>%s</span>"):format(description, meta["IssuedDate"])
        end

        if (meta["ExpiryDate"] ~= nil) then
            description = ("%s<br>Expiry Date: <span style='color:gold'>%s</span>"):format(description, meta["ExpiryDate"])
        end]]
    end
    return description
end

-- **********************
--    Global Functions
-- **********************
-- GETS CURRENT WEAPON
function GetMyCurrentWeapon()
    return myCurrentWeapon
end

-- SETS CURRENT WEAPON
function SetMyCurrentWeapon(data)
    myCurrentWeapon = data
end

-- WHEN TRIGGERED, SET PARACHUTE STATE
function SetParachuteState(toggle)
    currentParachute = toggle
end

-- WHEN TRIGGERED, REQUEST INVENTORY FROM SERVER
function RequestInventory()
    myInventory = RequestInventoryFromServer('all')
    return myInventory
end

-- WHEN TRIGGERED, CLEAR BODY ARMOR
function ClearBodyArmor()
    myArmorData = {}
    wearingArmor = false
    SetPedArmour(PlayerPedId(), 0)
end
exports("ClearBodyArmor", ClearBodyArmor)

-- ENFORCES INVENTORY WEIGHT AND CAUSES CONSEQUENCES WHEN TOO FULL
function EnforceInventoryWeight()
    -- IF IT EXCEEDS 85.5 POUNDS? THEN DON'T ALLOW SPRINT/JUMPING
    if (myTotalWeight >= 85.5) then
        DisableControlAction(0, 21, true)
        DisableControlAction(0, 22, true)

        if (GetGameTimer() - lastWeightWarning > 60000) then
            exports["soe-ui"]:SendAlert("warning", "You feel weighed down by items in your pockets!", 3500)
            lastWeightWarning = GetGameTimer()
        end
    else
        lastWeightWarning = GetGameTimer() - 60000
    end
end

-- WHEN TRIGGERED, RETURN IF PERSONAL INVENTORY HAS AN ITEM
function HasInventoryItem(itemName)
    if (myInventory == nil or myInventory["leftInventory"] == nil) then
        return false
    end

    for _, item in pairs(myInventory["leftInventory"]) do
        if (item["ItemType"] == itemName) then
            return true
        end
    end
    return false
end
exports("HasInventoryItem", HasInventoryItem)

-- WHEN TRIGGERED, RETURN HOW MANY OF AN ITEM A PLAYER HAS IN THEIR PERSONAL INVENTORY
function HasInventoryItemByAmt(itemName)
    if (myInventory == nil or myInventory["leftInventory"] == nil) then
        return 0
    end

    local amount = 0
    for _, item in pairs(myInventory["leftInventory"]) do
        if (item["ItemType"] == itemName) then
            amount = amount + item["ItemAmt"]
        end
    end
    return amount
end
exports("HasInventoryItemByAmt", HasInventoryItemByAmt)

function GetItemData(itemtype, invSide)
    RequestInventory()
    -- Get player inventory
    local inv = myInventory
    local returnTable = {}

    -- Iterate through items
    if invSide == "left" or invSide == "both" then
        if inv.leftInventory ~= nil then
            for i, item in pairs (inv.leftInventory) do
                if item.ItemType == itemtype then
                    returnTable[i] = item
                end
            end
        end
    end

    if invSide == "right" or invSide == "both" then
        if inv.rightInventory ~= nil then
            for i, item in pairs (inv.rightInventory) do
                if item.ItemType == itemtype then
                    returnTable[i] = item
                end
            end
        end
    end
    return returnTable
end

function GetItemAmt(itemtype, invSide)
    RequestInventory()
    local invSide = invSide or "left"
    -- Get player inventory
    local inv = myInventory

    -- Iterate through inventory contents
    local totalAmt = 0
    if invSide == "left" or invSide == "both" then
        if inv.leftInventory ~= nil then
            for _, item in pairs (inv.leftInventory) do
                if item.ItemType == itemtype then
                    totalAmt = totalAmt + item.ItemAmt
                end
            end
        end
    end

    if invSide == "right" or invSide == "both" then
        if inv.rightInventory ~= nil then
            for _, item in pairs (inv.rightInventory) do
                if item.ItemType == itemtype then
                    totalAmt = totalAmt + item.ItemAmt
                end
            end
        end
    end
    return totalAmt
end

-- WHEN TRIGGERED, DO SOME TASKS IF ITEMS WERE TRANSFERRED AWAY
function HandleItemTransfer(to, from, itemName, itemID, amt)
    if (myInventory == nil or myInventory["leftInventory"] == nil) then
        return
    end

    if not itemName then
        print("HandleItemTransfer: No itemName defined.")
        return
    end

    --print(json.encode(myInventory["leftInventory"][tostring(itemID)], {indent = true}))
    if (to == "right" or to == "drop") then
        if (tonumber(amt) > 1) then
            TriggerEvent("Inventory:Client:ItemNotify", "remove", itemName, amt, itemdefs[itemName]["multiple"])
        else
            TriggerEvent("Inventory:Client:ItemNotify", "remove", itemName, amt, itemdefs[itemName]["singular"])
        end

        local ped = PlayerPedId()
        local itemData = myInventory["leftInventory"][tostring(itemID)]
        if not itemData then
            return
        end

        SetTimeout(1500, function()
            if HasInventoryItem(itemName) then -- DO NOT CONTINUE IF WE STILL HAVE THIS ITEM
                return
            end

            local itemMeta = json.decode(itemData["ItemMeta"]) or {}
            if itemMeta["equipped"] and HasPedGotWeapon(ped, GetHashKey(itemName), false) then -- UNEQUIP WEAPON IF NO LONGER HAS THE ITEM
                -- SET META DATA
                itemMeta["equipped"] = false
                myEquippedWeapons[itemName] = nil
                if (model ~= "WEAPON_SNSPISTOL_MK2") then
                    itemMeta["ammo"] = GetAmmoInPedWeapon(ped, GetHashKey(itemName))
                end

                -- REMOVE WEAPON
                RemoveWeaponFromPed(ped, GetHashKey(itemName))
                TriggerServerEvent("Inventory:Server:EditItemMeta", itemID, itemMeta)
            end

            -- DISCONNECT FROM RADIO CHANNELS IF NO LONGER HAS RADIO ITEM
            if (itemName == "radio") then
                exports["soe-voice"]:SetRadioChannel(0, "Primary")
                exports["soe-voice"]:SetRadioChannel(0, "Secondary")
            end

            -- REMOVE BODY ARMOR IF NO BODY ARMOR IS FOUND
            if myArmorData["type"] and (itemName == myArmorData["type"]) and not HasInventoryItem(itemName) then
                ClearBodyArmor()
            end
        end)
    elseif (to == "left" and from ~= "hand") then
        if (tonumber(amt) > 1) then
            TriggerEvent("Inventory:Client:ItemNotify", "add", itemName, amt, itemdefs[itemName]["multiple"])
        else
            TriggerEvent("Inventory:Client:ItemNotify", "add", itemName, amt, itemdefs[itemName]["singular"])
        end
    end
end

-- WHEN EQUIPPING A WEAPON, A CHECK IS DONE IF YOU HAVE IT
function ValidateMyWeapon(hash)
    local valid, ped = false, PlayerPedId()
    local myInventory = RequestInventory()
    if (myInventory.leftInventory ~= nil) then
        for id, item in pairs(myInventory.leftInventory) do
            if (GetHashKey(item.ItemType) == hash) then
                valid = true
                --print("I HAVE THIS WEAPON IN MY INVENTORY")

                -- SET CURRENT WEAPON TO RECORD SERIAL NUMBER ETC
                local meta = json.decode(item.ItemMeta)
                if (meta.serialNum == nil) then
                    meta.serialNum = "UNKNOWN"
                end

                -- ATTACH ANY FLASHLIGHTS
                if (meta.flashlight ~= nil) then
                    if (meta.flashlight == "pistol") then
                        local attachment = weaponAttachments["Pistol Flashlight"][item.ItemType]
                        GiveWeaponComponentToPed(ped, hash, GetHashKey(attachment))
                    elseif (meta.flashlight == "rifle") then
                        local attachment = weaponAttachments["Rifle Flashlight"][item.ItemType]
                        GiveWeaponComponentToPed(ped, hash, GetHashKey(attachment))
                    end
                end

                -- ATTACH ANY SILENCERS
                if (meta.suppressor ~= nil) then
                    if (meta.suppressor == "pistol") then
                        local attachment = weaponAttachments["Small Silencer"][item.ItemType]
                        GiveWeaponComponentToPed(ped, hash, GetHashKey(attachment))
                    elseif (meta.suppressor == "rifle") then
                        local attachment = weaponAttachments["Large Silencer"][item.ItemType]
                        GiveWeaponComponentToPed(ped, hash, GetHashKey(attachment))
                    end
                end

                -- ATTACH ANY SCOPES
                if (meta.scope ~= nil) then
                    if (meta.scope == "holographic") then
                        local attachment = weaponAttachments["Holographic Sight"][item.ItemType]
                        GiveWeaponComponentToPed(ped, hash, GetHashKey(attachment))
                    elseif (meta.scope == "normal") then
                        local attachment = weaponAttachments["Normal Scope"][item.ItemType]
                        GiveWeaponComponentToPed(ped, hash, GetHashKey(attachment))
                    end
                end

                -- ATTACH ANY GRIPS
                if meta.grip then
                    local attachment = weaponAttachments["Rifle Grip"][item.ItemType]
                    GiveWeaponComponentToPed(ped, hash, GetHashKey(attachment))
                end

                SetMyCurrentWeapon({uid = id, equipped = meta.equipped, hash = item.ItemType, serial = meta.serialNum, name = itemdefs[item.ItemType].singular})
                break
            end
        end
    end

    if not valid then
        RemoveWeaponFromPed(ped, hash)
        --print("DEBUG: I DO NOT HAVE THIS WEAPON IN MY INVENTORY ANYMORE")
    end
end

-- **********************
--       Commands
-- **********************
-- WHEN TRIGGERED, OPENS INVENTORY
RegisterCommand("inv", HandleInventoryTasks)

-- **********************
--     NUI Callbacks
-- **********************
-- CLOSE UI
RegisterNUICallback("CloseUI", function(data, cb)
    SetNuiFocus(false, false)
    isInvOpen = false
    if IsEntityPlayingAnim(PlayerPedId(), "amb@prop_human_bum_bin@base", "base", 3) then
        StopAnimTask(PlayerPedId(), "amb@prop_human_bum_bin@base", "base", -2.5)
    end

    -- REOPEN INVENTORY IF BOOLEAN IS TRUE
    TriggerServerEvent("Inventory:Server:CloseInventory")
    if data.reopen then
        TriggerEvent("Inventory:Client:ShowInventory", "all", false)
    end
    cb("good")
end)

-- USE AN ITEM
RegisterNUICallback("UseItem", function(data, cb)
    -- ERROR PREVENTION
    if not data.item then
        print("data.item came back nil! Try again maybe?")
        return
    end

    if itemdefs[data.item] and itemdefs[data.item].closeInventoryOnUsage then
        SendNUIMessage({type = "CloseInventory", reopen = false})
    end

    if not itemdefs[data.item].reusable then
        -- Item is not reusable, consume with server event

        -- Fix for callback hanging to due invalid parent type
        if data.parent == "hand" then
            data.parent = "left"
        end

        TriggerServerEvent("Inventory:Server:UseItem", data.uid, data.amt, data.item, data.parent)
        -- print(json.encode(data))

        -- Clear to prevent old data populating script
        callback['UseItem'] = nil

        -- Wait for server callback
        while callback['UseItem'] == nil do
            Wait(100)
        end

        -- print("UseItem Callback: ", callback['UseItem'])

        -- Return server response
        cb(callback['UseItem'])

        if callback['UseItem'].status == true then
            itemdefs[data.item].onUse(data.uid)
        end
    else
        -- Item is reusable
        itemdefs[data.item].onUse(data.uid)

        cb({status = true, message = "Item was used but not consumed due to reusable flag."})
    end

    if not itemdefs[data.item].closeInventoryOnUsage then
        -- print("Refresh inv")
        Wait(1)
        TriggerEvent("Inventory:Client:ShowInventory", "all", true)
    end
end)

-- MOVE AN ITEM
RegisterNUICallback("MoveItem", function(data, cb)
    TriggerServerEvent("Inventory:Server:MoveItem", data.toContainer, data.fromContainer, data.uid, data.amount)
    HandleItemTransfer(data.toContainer, data.fromContainer, data.item, data.uid, data.amount)

    cb("good")
end)

-- MERGE AN ITEM
RegisterNUICallback("MergeItem", function(data, cb)
    -- CAN STACK CHECK
    if (itemdefs[data.itemid1] and not itemdefs[data.itemid1].canStack) or (itemdefs[data.itemid2] and not itemdefs[data.itemid2].canStack) then
        return
    end

    -- print("MergeItem Triggered")
    TriggerServerEvent("Inventory:Server:MergeItem", data.itemid1, data.itemid2)

    -- Clear to prevent old data populating script
    callback['MergeItem'] = nil

    -- Wait for server callback
    while callback['MergeItem'] == nil do
        Wait(10)
        if callback['MergeItem'] ~= nil then break end
        -- print("Waiting for callback (MergeItem)")
    end

    -- Return server response
    cb(callback['MergeItem'])
end)

-- SPLIT AN ITEM
RegisterNUICallback("SplitItem", function(data, cb)
    -- print("SplitItem Triggered")
    TriggerServerEvent("Inventory:Server:SplitItem", data.itemId, data.itemAmt)

    -- Clear to prevent old data populating script
    callback['SplitItem'] = nil

    -- Wait for server callback
    while callback['SplitItem'] == nil do
        Wait(10)
        if callback['SplitItem'] ~= nil then break end
        -- print("Waiting for callback (SplitItem)")
    end

    -- Return server response
    cb(callback['SplitItem'])
end)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, VALIDATE IF SENT WEAPON IS OWNED BY PLAYER
AddEventHandler("Inventory:Client:ValidateWeapon", ValidateMyWeapon)

-- WHEN TRIGGERED, REMOVE ALL WEAPONS
AddEventHandler("onClientResourceStart", function(resource)
    if (GetCurrentResourceName() ~= resource) then return end
    RemoveAllPedWeapons(PlayerPedId())
    SetPedArmour(PlayerPedId(), 0)
end)

-- WHEN TRIGGERED, CLOSE INVENTORY UI
RegisterNetEvent("Inventory:Client:CloseInventory")
AddEventHandler("Inventory:Client:CloseInventory", function()
    SendNUIMessage({type = "CloseInventory", reopen = false})
end)

-- WHEN TRIGGERED, SEND A NOTIFICATION OF ITEM USAGE/ADDITION
RegisterNetEvent("Inventory:Client:ItemNotify")
AddEventHandler("Inventory:Client:ItemNotify", function(type, itemID, itemAmt, itemName)
    SendNUIMessage({type = "ShowNotif", notifType = type, itemID = itemID, itemAmt = itemAmt, itemName = itemName})
end)

-- WHEN TRIGGERED, UNLOAD CURRENT WEAPON
RegisterNetEvent("Inventory:Client:UnloadAmmo")
AddEventHandler("Inventory:Client:UnloadAmmo", function(data)
    if not data.status then return end
    if not myCurrentWeapon then return end
    if not ammoTypes[myCurrentWeapon.hash] then return end

    if (GetAmmoInPedWeapon(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId())) > 0) then
        TriggerServerEvent("UX:Server:ReloadMyGun", myCurrentWeapon, ammoTypes[myCurrentWeapon.hash], 0, true)
    end
end)

-- WHEN TRIGGERED, RESET ALL NUI INSTANCES
AddEventHandler("UI:Client:ResetNUI", function()
    if not isInvOpen then return end
    print("[Inventory] UI resetted.")

    SetNuiFocus(false, false)
    if IsEntityPlayingAnim(PlayerPedId(), "amb@prop_human_bum_bin@base", "base", 3) then
        StopAnimTask(PlayerPedId(), "amb@prop_human_bum_bin@base", "base", -2.5)
    end
    TriggerServerEvent("Inventory:Server:CloseInventory")
    SendNUIMessage({type = "CloseInventory", reopen = false})
end)

-- WHEN TRIGGERED, UPDATE LIVE GUN ATTACHMENT
RegisterNetEvent("Inventory:Client:UpdateWeaponAttachment", function(data)
    if not data.status then return end
    if not data.hash then return end

    if (data.attachment == "pistol_flashlight") then
        local attachment = weaponAttachments["Pistol Flashlight"][data.hash]
        GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(data.hash), GetHashKey(attachment))
    elseif (data.attachment == "rifle_flashlight") then
        local attachment = weaponAttachments["Rifle Flashlight"][data.hash]
        GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(data.hash), GetHashKey(attachment))
    elseif (data.attachment == "small_silencer") then
        local attachment = weaponAttachments["Small Silencer"][data.hash]
        GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(data.hash), GetHashKey(attachment))
    elseif (data.attachment == "large_silencer") then
        local attachment = weaponAttachments["Large Silencer"][data.hash]
        GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(data.hash), GetHashKey(attachment))
    elseif (data.attachment == "holographic_sight") then
        local attachment = weaponAttachments["Holographic Sight"][data.hash]
        GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(data.hash), GetHashKey(attachment))
    elseif (data.attachment == "gun_scope") then
        local attachment = weaponAttachments["Normal Scope"][data.hash]
        GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(data.hash), GetHashKey(attachment))
    elseif (data.attachment == "rifle_grip") then
        local attachment = weaponAttachments["Rifle Grip"][data.hash]
        GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(data.hash), GetHashKey(attachment))
    end
end)

RegisterNetEvent("Inventory:Client:UseBodyArmor", function(itemID, itemName, displayName, remaining)
    local ped, name = PlayerPedId(), exports["soe-chat"]:GetDisplayName()

    if (GetPedArmour(ped) > 0) then
        exports["soe-utils"]:Progress({
            name = "removingArmor",
            duration = 6000,
            label = "Removing " .. displayName,
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = false,
            },
            animation = {
                animDict = "clothingshirt",
                anim = "try_shirt_positive_d",
                flags = 49
            },
        }, function(cancelled)
            if not cancelled then
                ClearBodyArmor()
                TriggerServerEvent("Chat:Server:ProximityMsg", 10.0, "me", "", name, ("removes their %s."):format(displayName))
            end
        end)
    else
        exports["soe-utils"]:Progress({
            name = "equippingArmor",
            duration = 6500,
            label = "Equipping " .. displayName,
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = false,
            },
            animation = {
                animDict = "clothingshirt",
                anim = "try_shirt_positive_d",
                flags = 49
            },
        }, function(cancelled)
            if not cancelled then
                wearingArmor = true
                SetPedArmour(ped, remaining)

                myArmorData = {["percent"] = remaining, ["itemID"] = itemID, ["type"] = itemName}
                TriggerServerEvent("Chat:Server:ProximityMsg", 10.0, "me", "", name, ("slides on a %s."):format(displayName))
            end
        end)
    end
end)

-- WHEN TRIGGERED, TOGGLE PARACHUTE
AddEventHandler("Inventory:Client:UseParachute", function()
    if currentParachute then
        currentParachute = false
        exports["soe-ui"]:SendAlert("inform", "Unequipped: Parachute", 1500)
        exports["soe-appearance"]:ToggleParachute(false)
    else
        if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
            exports["soe-ui"]:SendAlert("error", "You cannot do this!")
            return
        end

        currentParachute = true
        exports["soe-ui"]:SendAlert("inform", "Equipped: Parachute", 1500)

        GiveWeaponToPed(PlayerPedId(), GetHashKey("GADGET_PARACHUTE"), 150, true, true)
        SetPlayerHasReserveParachute(false)
        exports["soe-appearance"]:ToggleParachute(true)

        local notif = false
        while currentParachute do
            Wait(150)
            if IsPedInParachuteFreeFall(PlayerPedId()) then
                if not notif then
                    exports["soe-ui"]:SendAlert("inform", "Press F or Left Click to open!", 10000)
                    notif = true
                end
            else
                notif = false
            end

            if exports["soe-emergency"]:IsDead() then
                currentParachute = false
                break
            end

            if not HasPedGotWeapon(PlayerPedId(), GetHashKey("GADGET_PARACHUTE"), false) then
                GiveWeaponToPed(PlayerPedId(), GetHashKey("GADGET_PARACHUTE"), 150, true, true)
            end
        end
        exports["soe-appearance"]:ToggleParachute(false)
        RemoveWeaponFromPed(PlayerPedId(), GetHashKey("GADGET_PARACHUTE"))
    end
end)

-- SHOW THE INVENTORY UI
RegisterNetEvent("Inventory:Client:ShowInventory")
AddEventHandler("Inventory:Client:ShowInventory", function(whichInv, refreshInventory, extraData)
    if exports["soe-emergency"]:IsRestrained() then return end

    refreshInventory = refreshInventory or false
    -- Check whichInv is valid and that myInventory is set

    -- Request inventory from server
    myInventory = RequestInventoryFromServer(whichInv, extraData)

    -- Prepare table for dispatch to UI
    local sendInventory = {
        ["itemsLeft"] = {
            ["items"] = {}
        },
        ["itemsRight"] = {
            ["items"] = {}
        }
    }

    local invType
    local ped = PlayerPedId()
    if refreshInventory then
        invType = "UpdateInventory"
    else
        invType = "ShowInventory"

        -- NUI focus & keyboard focus
        SetNuiFocusKeepInput(false)
        SetNuiFocus(true, true)
        isInvOpen = true

        -- ANIMATION WHEN ACCESSING INVENTORY
        if not exports["soe-utils"]:IsModelADog(ped) then
            if (whichInv == "dumpster") then
                exports["soe-utils"]:LoadAnimDict("amb@prop_human_bum_bin@base", 15)
                TaskPlayAnim(ped, "amb@prop_human_bum_bin@base", "base", 3.0, 3.0, -1, 1, 0, 0, 0, 0)
            else
                exports["soe-utils"]:LoadAnimDict("pickup_object", 15)
                TaskPlayAnim(ped, "pickup_object", "putdown_low", 5.0, 1.5, 1300, 49, 0, 0, 0, 0)
            end
        end
    end

    -- Left inventory panel (Character Inventory)
    if myInventory.leftInventory then
        for itemID, itemData in pairs(myInventory.leftInventory) do
            if itemdefs[itemData.ItemType] then
                local description = BuildItemDescription(itemData, itemID)
                local weight = itemdefs[itemData.ItemType].weight * itemData.ItemAmt
                if itemData.ItemType == "cash" or itemData.ItemType == "dirtycash" then
                    weight = GetCashWeight(itemData.ItemAmt, itemData.ItemType)
                end

                sendInventory.itemsLeft.items[#sendInventory.itemsLeft.items + 1] = {
                    ["uid"] = itemID,
                    ["item"] = itemData.ItemType,
                    ["displayname"] = {
                        ["single"] = itemdefs[itemData.ItemType].singular,
                        ["plural"] = itemdefs[itemData.ItemType].multiple
                    },
                    ["weight"] = weight,
                    ["amt"] = itemData.ItemAmt,
                    ["description"] = description,
                    ["metadata"] = itemData.ItemMeta,
                    ["canUse"] = itemdefs[itemData.ItemType].canUse or false
                }
            else
                print("[Opening Inventory Bug] (PLEASE REPORT) '".. itemData.ItemType .."' (Item ID: '".. itemID .."') does not exist in the item definitions table. This just saved this player's inventory from breaking.")
            end
        end

        UpdateMyTotalWeight(myInventory.leftInventory)
        SortInventoryByName(sendInventory.itemsLeft)
        SendNUIMessage({type = invType, inventory = sendInventory.itemsLeft, container = "left", title = myInventory.leftTitle})
    end

    -- Right inventory panel (Other inventory)
    if myInventory.rightInventory then
        for itemID, itemData in pairs(myInventory.rightInventory) do
            if itemdefs[itemData.ItemType] then
                local description = BuildItemDescription(itemData, itemID)
                local weight = itemdefs[itemData.ItemType].weight * itemData.ItemAmt
                if itemData.ItemType == "cash" or itemData.ItemType == "dirtycash" then
                    weight = GetCashWeight(itemData.ItemAmt, itemData.ItemType)
                end

                sendInventory.itemsRight.items[#sendInventory.itemsRight.items + 1] = {
                    ["uid"] = itemID,
                    ["item"] = itemData.ItemType,
                    ["displayname"] = {
                        ["single"] = itemdefs[itemData.ItemType].singular,
                        ["plural"] = itemdefs[itemData.ItemType].multiple
                    },
                    ["weight"] = weight,
                    ["amt"] = itemData.ItemAmt,
                    ["description"] = description,
                    ["metadata"] = itemData.ItemMeta,
                    ["canUse"] = itemdefs[itemData.ItemType].canUse or false
                }
            else
                print("[Opening Inventory Bug] (PLEASE REPORT) '".. itemData.ItemType .."' (Item ID: '".. itemID .."') does not exist in the item definitions table. This just saved this right-sided inventory from breaking.")
            end
        end

        SortInventoryByName(sendInventory.itemsRight)
        SendNUIMessage({type = invType, inventory = sendInventory.itemsRight, container = "right", title = myInventory.rightTitle})
    end
end)

RegisterNetEvent("Inventory:Client:SyncInventory")
AddEventHandler("Inventory:Client:SyncInventory", function()
    print("Inventory sync event received from server")
    TriggerEvent("Inventory:Client:ShowInventory", "all", true)

    -- UPDATE WEIGHT
    local myInv = RequestInventory()
    UpdateMyTotalWeight(myInv.leftInventory)
end)
