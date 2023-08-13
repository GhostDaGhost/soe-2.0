callback = {}

function RequestInventoryFromServer(type, extraData)
    -- Trigger API call on server
    TriggerServerEvent("Inventory:Server:RequestInventory", type, '', extraData)

    -- Clear to prevent old data populating script
    callback['RequestInventory'] = nil

    -- Wait for server callback
    while callback['RequestInventory'] == nil do
        Wait(100)
        if callback['RequestInventory'] ~= nil then break end
        -- print("Waiting for callback (RequestInventory)")
    end

    -- Return server response
    return callback['RequestInventory']
end

-- CALLED FROM ITEM USAGE TO EQUIP/UNEQUIP WEAPON // WIP
function ToggleWeapon(model, itemID)
    local ped = PlayerPedId()
    -- ITERATE THROUGH THIS SPECIFIC WEAPON FOUND
    local myGun, getWeapons = nil, exports["soe-inventory"]:GetItemData(model, "left")
    for weaponID, weaponData in pairs(getWeapons) do
        if (tonumber(weaponID) == tonumber(itemID)) then
            myGun = weaponData
        end
    end

    if not myGun then
        return
    end

    local hash = GetHashKey(model)
    local itemMeta = json.decode(myGun.ItemMeta)
    if type(itemMeta) == "string" then
        itemMeta = {}
    end

    if HasPedGotWeapon(ped, hash, false) then
        if itemMeta.equipped then
            -- UNEQUIP WEAPON AND UPDATE AMMO
            itemMeta.equipped = false
            myEquippedWeapons[model] = nil
            if (model ~= "WEAPON_SNSPISTOL_MK2") then
                itemMeta.ammo = GetAmmoInPedWeapon(ped, hash)
            end

            -- REMOVE WEAPON
            RemoveWeaponFromPed(ped, hash)
            exports["soe-ui"]:SendAlert("warning", "Weapon: Unequipped", 1000)
            TriggerServerEvent("Inventory:Server:EditItemMeta", itemID, itemMeta)
        end
    else
        if myGun then
            itemMeta.equipped = true
            myEquippedWeapons[model] = true
            GiveWeaponToPed(ped, hash, 0, false, true)

            if model:match("MK2") then
                SetPedWeaponTintIndex(ped, hash, 1)
            end
            exports["soe-ui"]:SendAlert("warning", "Weapon: Equipped", 1000)

            -- SET AMMO
            if (model == "WEAPON_FIREEXTINGUISHER" or model == "WEAPON_PETROLCAN") then
                SetPedAmmo(ped, hash, 2000)
            else
                if (model ~= "WEAPON_SNSPISTOL_MK2") then
                    SetPedAmmo(ped, hash, tonumber(itemMeta.ammo) or 0)
                end

                if (model == "WEAPON_SMOKEGRENADE") then
                    SetPedAmmo(ped, hash, 3)
                end
            end
            TriggerServerEvent("Inventory:Server:EditItemMeta", itemID, itemMeta)
        else
            print("Fatal error when equipping the weapon: ", model)
        end
    end
end

function ReloadFirearm(ammoType, ammoCount)
    local currentWeapon = GetMyCurrentWeapon()
    if currentWeapon then
        local ped = PlayerPedId()
        -- IF THIS IS A TASER, LIMIT THE AMOUNT OF PRONGS
        if (currentWeapon.hash == "WEAPON_STUNGUN") then
            if (GetAmmoInPedWeapon(ped, GetSelectedPedWeapon(ped)) == 2) then
                exports["soe-ui"]:SendAlert("error", "You can only hold two prongs in this taser!", 5000)
                return
            end
        end

        -- IF THIS IS A FLARE GUN, LIMIT THE AMOUNT OF FLARES
        if (currentWeapon.hash == "WEAPON_FLAREGUN") then
            if (GetAmmoInPedWeapon(ped, GetSelectedPedWeapon(ped)) == 1) then
                exports["soe-ui"]:SendAlert("error", "You can only hold one flare in this flare gun!", 5000)
                return
            end
        end

        if (ammoTypes[currentWeapon.hash] == ammoType) then
            TriggerServerEvent("UX:Server:ReloadMyGun", currentWeapon, ammoType, GetAmmoInPedWeapon(ped, GetSelectedPedWeapon(ped)) + ammoCount)
            return
        end
        exports["soe-ui"]:SendAlert("error", "Not the correct ammo type!", 5000)
    else
        exports["soe-ui"]:SendAlert("error", "You must have a gun on hand", 5000)
    end
end

function UseChargeItem(itemName, itemUID)
    local itemMeta, items, multiItems = nil, exports["soe-inventory"]:GetItemData(itemName, "left"), false

    -- FIND THE ITEM
    for uid, itemData in pairs(items) do
        if (tonumber(uid) == tonumber(itemUID)) then
            itemMeta = json.decode(itemData.ItemMeta)
            break
        end
    end

    -- DO ITEM FUNCTIONS HERE
    if itemMeta ~= nil then
        -- RESULT ITEM
        local itemToGive, itemsToGive, itemToRemove, removeAmt = nil, {}, nil, 0
        if itemName == "lollipopbag" then
            local lollipopColors = {"blue", "green", "orange", "purple", "red", "yellow", "purple"}
            local randomNum = math.random(1, #lollipopColors)
            itemToGive = string.format("lollipop%s", lollipopColors[randomNum])
        elseif itemName == "bm_applepie" then
            itemToGive = "bm_sliceofapplepie"
        elseif itemName == "bm_carrotcake" then
            itemToGive = "bm_sliceofcarrotcake"
        elseif itemName == "bm_redvelvetcake" then
            itemToGive = "bm_sliceofredvelvetcake"
        elseif itemName == "bm_strawberrycake" then
            itemToGive = "bm_sliceofstrawberrycake"
        elseif itemName == "cigarettepack" then
            itemToGive = "cigarette"
        elseif itemName == "advancedrepairkit" then
            local veh = exports["soe-utils"]:GetVehInFrontOfPlayer(5.0)
            if veh ~= nil then
                exports["soe-challenge"]:UseRepairKit(true)
            else
                exports["soe-ui"]:SendAlert("error", "No vehicle found", 5000)
            end
        elseif itemName == "gn_tasteofdiamonds" then
            if HasInventoryItem("champagneglass") then
                itemToGive = "gn_tasteofdiamondsflute"
                itemToRemove = "champagneglass"
                removeAmt = 1
            else
                exports["soe-nutrition"]:Drink("Beer", 0, 40)
                exports["soe-civ"]:SetAlcoholLevel(8)
            end
        elseif itemName == "gin" then
            if HasInventoryItem("shotglass") then
                itemToGive = "shot_gin"
                itemToRemove = "shotglass"
                removeAmt = 1
            else
                exports["soe-nutrition"]:Drink("Beer", 0, 40)
                exports["soe-civ"]:SetAlcoholLevel(10)
            end
        elseif itemName == "rum" then
            if HasInventoryItem("shotglass") then
                itemToGive = "shot_rum"
                itemToRemove = "shotglass"
                removeAmt = 1
            else
                exports["soe-nutrition"]:Drink("Beer", 0, 40)
                exports["soe-civ"]:SetAlcoholLevel(10)
            end
        elseif itemName == "vermouth" then
            if HasInventoryItem("shotglass") then
                itemToGive = "shot_vermouth"
                itemToRemove = "shotglass"
                removeAmt = 1
            else
                exports["soe-nutrition"]:Drink("Beer", 0, 40)
                exports["soe-civ"]:SetAlcoholLevel(10)
            end
        elseif itemName == "vodka" then
            if HasInventoryItem("shotglass") then
                itemToGive = "shot_vodka"
                itemToRemove = "shotglass"
                removeAmt = 1
            else
                exports["soe-nutrition"]:Drink("Beer", 0, 40)
                exports["soe-civ"]:SetAlcoholLevel(10)
            end
        elseif itemName == "redwine" then
            if HasInventoryItem("champagneglass") then
                itemToGive = "glass_redwine"
                itemToRemove = "champagneglass"
                removeAmt = 1
            else
                exports["soe-nutrition"]:Drink("Beer", 0, 40)
                exports["soe-civ"]:SetAlcoholLevel(10)
            end
        elseif itemName == "whitewine" then
            if HasInventoryItem("champagneglass") then
                itemToGive = "glass_whitewine"
                itemToRemove = "champagneglass"
                removeAmt = 1
            else
                exports["soe-nutrition"]:Drink("Beer", 0, 40)
                exports["soe-civ"]:SetAlcoholLevel(10)
            end
        elseif itemName == "bs_moneyshotmeal" or itemName == "bs_bleedermeal" or itemName == "bs_meatlessmeal" or itemName == "bs_torpedomeal" or itemName == "bs_6lbburger" then
            local chance = math.random(100)

            -- INCREASE THE CHANCE OF ULTIMATE TOY IF ITEM IS 6LB BURGER
            local max = 1000
            if itemName == "bs_6lbburger" then
                max = 333
            end

            if chance <= 40 then
                itemToGive = "bs_toy_sasquatch"
            elseif chance <= 60 then
                itemToGive = "bs_toy_alien"
            elseif chance <= 72 then
                itemToGive = "bs_toy_wolf"
            elseif chance <= 82 then
                itemToGive = "bs_toy_superhero"
            elseif chance <= 92 then
                itemToGive = "bs_toy_spaceman"
            elseif chance <= 97 then
                itemToGive = "bs_toy_monkey"
            elseif chance <= 99 then
                itemToGive = "bs_toy_spaceman2"
            elseif chance <= 100 then
                Wait(5)
                chance = math.random(max)
                if chance <= 1 then
                    itemToGive = "bs_toy_bubblegum"
                else
                    itemToGive = "bs_toy_sasquatch"
                end
            end
        elseif itemName == "sd_vuvodka" then
            if HasInventoryItem("shotglass") then
                itemToGive = "sd_shot_vuvodka"
                itemToRemove = "shotglass"
                removeAmt = 1
            else
                exports["soe-nutrition"]:Drink("Beer", 0, 40)
                exports["soe-civ"]:SetAlcoholLevel(10)
            end
        elseif itemName == "sd_petrovka" then
            if HasInventoryItem("shotglass") then
                itemToGive = "sd_shot_petrovka"
                itemToRemove = "shotglass"
                removeAmt = 1
            else
                exports["soe-nutrition"]:Drink("Beer", 0, 40)
                exports["soe-civ"]:SetAlcoholLevel(10)
            end
        elseif itemName == "ao_rocketfuel" then
            if HasInventoryItem("shotglass") then
                itemToGive = "ao_shot_rocketfuel"
                itemToRemove = "shotglass"
                removeAmt = 1
            else
                exports["soe-nutrition"]:Drink("Beer", 0, 40)
                exports["soe-civ"]:SetAlcoholLevel(12)
            end
        elseif itemName == "yj_tequila" then
            if exports["soe-inventory"]:GetItemAmt("shotglass", "left") >= 1 then
                itemToGive = "yj_shot_tequila"
                itemToRemove = "shotglass"
                removeAmt = 1
            else
                exports["soe-nutrition"]:Drink("Beer", 0, 40)
                exports["soe-civ"]:SetAlcoholLevel(10)
            end

        elseif itemName == "yj_whiskey" then
            if exports["soe-inventory"]:GetItemAmt("shotglass", "left") >= 1 then
                itemToGive = "yj_shot_whiskey"
                itemToRemove = "shotglass"
                removeAmt = 1
            else
                exports["soe-nutrition"]:Drink("Beer", 0, 40)
                exports["soe-civ"]:SetAlcoholLevel(10)
            end
        elseif itemName == "sd_msclovers" then
            if HasInventoryItem("shotglass") then
                itemToGive = "sd_shot_msclovers"
                itemToRemove = "shotglass"
                removeAmt = 1
            else
                exports["soe-nutrition"]:Drink("Beer", 0, 40)
                exports["soe-civ"]:SetAlcoholLevel(10)
            end
        elseif itemName == "fl_winewoodblanc" then
            if HasInventoryItem("champagneglass") then
                itemToGive = "fl_glass_winewoodblanc"
                itemToRemove = "champagneglass"
                removeAmt = 1
            else
                exports["soe-nutrition"]:Drink("Beer", 0, 40)
                exports["soe-civ"]:SetAlcoholLevel(8)
            end
        elseif itemName == "fl_blaueballe" then
            if HasInventoryItem("champagneglass") then
                itemToGive = "fl_glass_blaueballe"
                itemToRemove = "champagneglass"
                removeAmt = 1
            else
                exports["soe-nutrition"]:Drink("Beer", 0, 40)
                exports["soe-civ"]:SetAlcoholLevel(8)
            end
        elseif itemName == "fl_portzancudo" then
            if HasInventoryItem("champagneglass") then
                itemToGive = "fl_glass_portzancudo"
                itemToRemove = "champagneglass"
                removeAmt = 1
            else
                exports["soe-nutrition"]:Drink("Beer", 0, 40)
                exports["soe-civ"]:SetAlcoholLevel(8)
            end
        elseif itemName == "fl_lessantosspecial" then
            if HasInventoryItem("champagneglass") then
                itemToGive = "fl_glass_lessantosspecial"
                itemToRemove = "champagneglass"
                removeAmt = 1
            else
                exports["soe-nutrition"]:Drink("Beer", 0, 40)
                exports["soe-civ"]:SetAlcoholLevel(8)
            end
        elseif itemName == "fl_chardonjay" then
            if HasInventoryItem("champagneglass") then
                itemToGive = "fl_glass_chardonjay"
                itemToRemove = "champagneglass"
                removeAmt = 1
            else
                exports["soe-nutrition"]:Drink("Beer", 0, 40)
                exports["soe-civ"]:SetAlcoholLevel(8)
            end
        elseif itemName == "lh_jameson" then
            if HasInventoryItem("shotglass") then
                itemToGive = "lh_shot_jameson"
                itemToRemove = "shotglass"
                removeAmt = 1
            else
                exports["soe-nutrition"]:Drink("Beer", 0, 40)
                exports["soe-civ"]:SetAlcoholLevel(10)
            end
        elseif itemName == "lu_devinedeli" then
            exports["soe-nutrition"]:Eat("", 70, -5)
        elseif itemName == "hs_meatboard" then
            exports["soe-nutrition"]:Eat("", 70, -5)
        elseif itemName == "sotw_partypack" then
            itemToGive = "sotw_handypack"
        elseif itemName == "sotw_handypack" then
            itemToGive = "sotw_joint"
        elseif itemName == "sotw_partypack_goldensunrise" then
            itemToGive = "sotw_handypack_goldensunrise"
        elseif itemName == "sotw_handypack_goldensunrise" then
            itemToGive = "sotw_joint_goldensunrise"
        elseif itemName == "sotw_partypack_purplenurple" then
            itemToGive = "sotw_handypack_purplenurple"
        elseif itemName == "sotw_handypack_purplenurple" then
            itemToGive = "sotw_joint_purplenurple"
        elseif itemName == "sotw_partypack_tealappeal" then
            itemToGive = "sotw_handypack_tealappeal"
        elseif itemName == "sotw_handypack_tealappeal" then
            itemToGive = "sotw_joint_tealappeal"
        elseif itemName == "bb_starburstthcgummies" or itemName == "bb_cookiesandcreambar" then
            exports["soe-nutrition"]:Eat("Brownie", 2, 0)
            TriggerEvent("Crime:Client:DoDrugEffects", "Weed", "Best Buds Edibles", false)
        elseif itemName == "lb_milkchoc" or itemName == "lb_whitechoc" or itemName == "lb_peanutchoc" then
            exports["soe-nutrition"]:Eat("Brownie", 5, 0)
        elseif itemName == "bb_seedpacket" then
            itemToGive = "weed_seed"
        elseif itemName == "bagofleogear" then
            multiItems = true
            itemsToGive[#itemsToGive+1] = {itemName = "WEAPON_PISTOL_MK2", amount = 1}
            itemsToGive[#itemsToGive+1] = {itemName = "pistol_magazine", amount = 10}
            itemsToGive[#itemsToGive+1] = {itemName = "pistol_flashlight", amount = 1}
            itemsToGive[#itemsToGive+1] = {itemName = "WEAPON_STUNGUN", amount = 1}
            itemsToGive[#itemsToGive+1] = {itemName = "ammo_taser", amount = 8}
            itemsToGive[#itemsToGive+1] = {itemName = "WEAPON_NIGHTSTICK", amount = 1}
            itemsToGive[#itemsToGive+1] = {itemName = "handcuffs", amount = 3}
            itemsToGive[#itemsToGive+1] = {itemName = "cuffkey", amount = 1}
            itemsToGive[#itemsToGive+1] = {itemName = "radio", amount = 1}
            itemsToGive[#itemsToGive+1] = {itemName = "tablet", amount = 1}
            itemsToGive[#itemsToGive+1] = {itemName = "platecarrier", amount = 1}
            itemsToGive[#itemsToGive+1] = {itemName = "firstaidkit", amount = 5}
            itemsToGive[#itemsToGive+1] = {itemName = "repairkit", amount = 5}
            itemsToGive[#itemsToGive+1] = {itemName = "multitool", amount = 1}
            itemsToGive[#itemsToGive+1] = {itemName = "slimjim", amount = 1}
            itemsToGive[#itemsToGive+1] = {itemName = "gsrkit", amount = 1}
            itemsToGive[#itemsToGive+1] = {itemName = "tintmeter", amount = 1}
            itemsToGive[#itemsToGive+1] = {itemName = "breathalyzer", amount = 1}
            itemsToGive[#itemsToGive+1] = {itemName = "printkit", amount = 1}
            itemsToGive[#itemsToGive+1] = {itemName = "spikestrips", amount = 1}
            itemsToGive[#itemsToGive+1] = {itemName = "binos", amount = 1}
        end

        -- MINUS 1 FROM CHARGE ON CHARGE ITEM
        if not itemMeta["remaining"] then
            print("Remaining was nil!")
            return
        end
        itemMeta["remaining"] = itemMeta["remaining"] - 1

        -- SEND DATA TO SERVER
        if not multiItems then
            local data = {status = true, itemUID = itemUID, itemName = itemToGive, amount = 1, newItemMeta = itemMeta, itemToRemove = itemToRemove, removeAmt = removeAmt}
            TriggerServerEvent("Inventory:Server:AddItem", data)
        else
            local data = {status = true, itemUID = itemUID, itemsToGive = itemsToGive, newItemMeta = itemMeta, itemToRemove = itemToRemove, removeAmt = removeAmt}
            TriggerServerEvent("Inventory:Server:AddItem", data)
            
        end
    end
end

RegisterNetEvent("Inventory:Client:HandleServerCallback")
AddEventHandler("Inventory:Client:HandleServerCallback", function(callbackName, payload)
    -- print("Callback received from server [", callbackName, ']')
    callback[callbackName] = payload
end)
