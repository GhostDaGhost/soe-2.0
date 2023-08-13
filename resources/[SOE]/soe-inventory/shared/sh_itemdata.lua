local doorMappings = {
    [0] = -1,
    [1] = 0,
    [2] = 1,
    [3] = 2
}

itemdefs = {}

-- GARBAGE ITEMS
itemdefs["ash"] = {
    itemtype = "garbage",
    singular = "Pile of Ash",
    multiple = "Piles of Ash",
    weight = 0.01,
    description = "Ashes. They don't look like remains.",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["plate"] = {
    itemtype = "licenseplate",
    singular = "License Plate",
    multiple = "License Plates",
    weight = 0.02,
    description = "Yoink and replace.",
    canUse = true,
    canStack = false,
    reusable = false,
    onUse = function()
    end
}

itemdefs["citation"] = {
    itemtype = "tool",
    singular = "Citation",
    multiple = "Citations",
    weight = 0.01,
    description = "Issued by police.",
    canUse = false,
    canStack = false,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["kittylitter"] = {
    itemtype = "tool",
    singular = "Kitty Litter",
    multiple = "Kitty Litter",
    weight = 0.03,
    description = "Cleans spilled fluids on the ground!",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-civ"]:UseKittyLitter()
    end
}

itemdefs["makeupkit"] = {
    itemtype = "tool",
    singular = "Makeup Kit",
    multiple = "Makeup Kit",
    weight = 0.10,
    description = "Gotta look pretty with this anywhere.",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        exports["soe-appearance"]:OpenAppearanceMenu("stylist", "Makeup", "You're beautiful just the way you are!", false, true)
    end
}

-- EVIDENCE ITEMS
itemdefs["bloodsample"] = {
    singular = "Blood Sample",
    multiple = "Blood Samples",
    weight = 0.01,
    description = "Thought this was ketchup inside... I was wrong.",
    canUse = false,
    canStack = false,
    reusable = false,
    onUse = function()
    end
}

itemdefs["vehiclefragment"] = {
    singular = "Vehicle Fragment",
    multiple = "Vehicle Fragments",
    weight = 0.01,
    description = "Piece of a vehicle... they must've hit something.",
    canUse = false,
    canStack = false,
    reusable = false,
    onUse = function()
    end
}

itemdefs["pistol_casing"] = {
    singular = "Pistol Casing",
    multiple = "Pistol Casings",
    weight = 0.01,
    description = "Someone's been out here shooting... could hide it or use it as evidence.",
    canUse = false,
    canStack = false,
    reusable = false,
    onUse = function()
    end
}

itemdefs["shotgun_shell"] = {
    singular = "Shotgun Shell",
    multiple = "Shotgun Shells",
    weight = 0.01,
    description = "Someone or something just got blown away...",
    canUse = false,
    canStack = false,
    reusable = false,
    onUse = function()
    end
}

itemdefs["rifle_casing"] = {
    singular = "Rifle Casing",
    multiple = "Rifle Casings",
    weight = 0.01,
    description = "Not a common casing to find... what the hell happened?",
    canUse = false,
    canStack = false,
    reusable = false,
    onUse = function()
    end
}

itemdefs["collectionvial"] = {
    singular = "Collection Vial",
    multiple = "Collection Vials",
    weight = 0.01,
    description = "Used to collect blood or any other substance.",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["printkit"] = {
    singular = "Fingerprint Kit",
    multiple = "Fingerprint Kits",
    weight = 0.01,
    description = "A small kit used to dust for and lift a fingerprint from a surface.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        -- IF A VEHICLE
        local veh = exports["soe-utils"]:GetVehInFrontOfPlayer(1.0)
        if veh then
            local doorID = exports["soe-utils"]:GetClosestVehicleDoor(veh).id
            exports["soe-utils"]:Progress(
                {
                    name = "dustingVeh",
                    duration = 10000,
                    label = "Dusting vehicle door for prints",
                    useWhileDead = false,
                    canCancel = false,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true
                    },
                    animation = {
                        animDict = "mp_arresting",
                        anim = "a_uncuff",
                        flags = 49
                    }
                },
                function(cancelled)
                    if not cancelled then
                        TriggerServerEvent("CSI:Server:DustForVehPrints", GetVehicleNumberPlateText(veh), doorMappings[doorID])
                    end
                end
            )
        end
    end
}

itemdefs["liftedprint"] = {
    singular = "Lifted Fingerprint",
    multiple = "Lifted Fingerprint",
    weight = 0.01,
    description = "A fingerprint lifted from a scene.",
    canUse = false,
    canStack = false,
    reusable = false,
    onUse = function()
    end
}

-- BODY ARMOR
itemdefs["lightarmor"] = {
    itemtype = "armor",
    singular = "Light Body Armor",
    multiple = "Light Body Armor",
    weight = 0.850,
    description = "Knight in shining armor!",
    canUse = true,
    canStack = false,
    reusable = true,
    onUse = function(uid)
        TriggerServerEvent("Inventory:Server:UseBodyArmor", uid, "lightarmor", "light body armor")
    end
}

itemdefs["bodyarmor"] = {
    itemtype = "armor",
    singular = "Body Armor",
    multiple = "Body Armor",
    weight = 0.900,
    description = "Pretty armor doesn't make a warrior.",
    canUse = true,
    canStack = false,
    reusable = true,
    onUse = function(uid)
        TriggerServerEvent("Inventory:Server:UseBodyArmor", uid, "bodyarmor", "body armor")
    end
}

itemdefs["platecarrier"] = {
    itemtype = "armor",
    singular = "Plate Carrier",
    multiple = "Plate Carrier",
    weight = 0.960,
    description = "A plate carrier.",
    canUse = true,
    canStack = false,
    reusable = true,
    onUse = function(uid)
        TriggerServerEvent("Inventory:Server:UseBodyArmor", uid, "platecarrier", "plate carrier")
    end
}

-- GUN RELATED
itemdefs["ammo_flaregun"] = {
    itemtype = "weapon_ammo",
    singular = "Flaregun Ammo",
    multiple = "Flaregun Ammo",
    weight = 0.01,
    description = "Ammo to fill up a Flare Gun.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        ReloadFirearm("ammo_flaregun", 1)
    end
}

itemdefs["ammo_firework"] = {
    itemtype = "weapon_ammo",
    singular = "Firework Rocket",
    multiple = "Firework Rockets",
    weight = 1.00,
    description = "Ammo to fill up a Firework Launcher.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        ReloadFirearm("ammo_firework", 1)
    end
}

itemdefs["ammo_smg"] = {
    itemtype = "weapon_ammo",
    singular = "SMG Ammo",
    multiple = "SMG Ammo",
    weight = 0.03,
    description = "Ammo to fill up a SMG.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        ReloadFirearm("ammo_smg", 25)
    end
}

itemdefs["ammo_sniper"] = {
    itemtype = "weapon_ammo",
    singular = "Sniper Ammo",
    multiple = "Sniper Ammo",
    weight = 0.03,
    description = "Ammo to fill up a rifle.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        ReloadFirearm("ammo_sniper", 10)
    end
}

itemdefs["ammo_rifle"] = {
    itemtype = "weapon_ammo",
    singular = "Rifle Ammo",
    multiple = "Rifle Ammo",
    weight = 0.03,
    description = "Ammo to fill up a rifle.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        ReloadFirearm("ammo_rifle", 35)
    end
}

itemdefs["ammo_taser"] = {
    itemtype = "weapon_ammo",
    singular = "Taser Cartridge",
    multiple = "Taser Cartridges",
    weight = 0.05,
    description = "Cartridges to fill up the taser.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        ReloadFirearm("ammo_taser", 1)
    end
}

itemdefs["ammo_revolver"] = {
    itemtype = "weapon_ammo",
    singular = "Revolver Ammo",
    multiple = "Revolver Ammo",
    weight = 0.05,
    description = "Ammo and speed loader to fill up the revolver.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        ReloadFirearm("ammo_revolver", 10)
    end
}

itemdefs["ammo_mp5"] = {
    itemtype = "weapon_ammo",
    singular = "MP5 Ammo",
    multiple = "MP5 Ammo",
    weight = 0.05,
    description = "Ammo to fill up the MP5.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        ReloadFirearm("ammo_mp5", 50)
    end
}

itemdefs["ammo_musket"] = {
    itemtype = "weapon_ammo",
    singular = "Musket Powder",
    multiple = "Musket Powder",
    weight = 0.02,
    description = "Ammo to fill up a musket.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        ReloadFirearm("ammo_musket", 10)
    end
}

itemdefs["ammo_shotgun"] = {
    itemtype = "weapon_ammo",
    singular = "Shotgun Ammo",
    multiple = "Shotgun Ammo",
    weight = 0.03,
    description = "Ammo to fill up a shotgun.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        ReloadFirearm("ammo_shotgun", 30)
    end
}

itemdefs["ammo_beanbag"] = {
    itemtype = "weapon_ammo",
    singular = "Beanbag Ammo",
    multiple = "Beanbag Ammo",
    weight = 0.05,
    description = "Ammo to fill up a beanbag weapon.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        ReloadFirearm("ammo_beanbag", 30)
    end
}

itemdefs["ammo_firework"] = {
    itemtype = "weapon_ammo",
    singular = "Firework Ammo",
    multiple = "Firework Ammo",
    weight = 0.05,
    description = "Ammo to fill up a firework launcher.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        ReloadFirearm("ammo_firework", 1)
    end
}

itemdefs["pistol_magazine"] = {
    itemtype = "weapon_ammo",
    singular = "Pistol Magazine",
    multiple = "Pistol Magazine",
    weight = 0.05,
    description = "Ammo to fill up a handgun.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        ReloadFirearm("pistol_magazine", 25)
    end
}

itemdefs["pistol_flashlight"] = {
    itemtype = "weapon_attachment",
    singular = "Pistol Flashlight",
    multiple = "Pistol Flashlights",
    weight = 0.02,
    description = "A flashlight that attaches to a handgun.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        if GetMyCurrentWeapon() then
            TriggerServerEvent("Inventory:Server:EquipAttachment", {status = true, gun = GetMyCurrentWeapon(), attachment = "pistol_flashlight"})
        else
            exports["soe-ui"]:SendAlert("error", "You must have a gun on hand", 5000)
        end
    end
}

itemdefs["rifle_flashlight"] = {
    itemtype = "weapon_attachment",
    singular = "Rifle Flashlight",
    multiple = "Rifle Flashlights",
    weight = 0.02,
    description = "A flashlight that attaches to a rifle or shotgun.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        if GetMyCurrentWeapon() then
            TriggerServerEvent("Inventory:Server:EquipAttachment", {status = true, gun = GetMyCurrentWeapon(), attachment = "rifle_flashlight"})
        else
            exports["soe-ui"]:SendAlert("error", "You must have a gun on hand", 5000)
        end
    end
}

itemdefs["small_silencer"] = {
    itemtype = "weapon_attachment",
    singular = "Small Silencer",
    multiple = "Small Silencers",
    weight = 0.02,
    description = "A small silencer that attaches to a handgun or small SMG.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        if GetMyCurrentWeapon() then
            TriggerServerEvent("Inventory:Server:EquipAttachment", {status = true, gun = GetMyCurrentWeapon(), attachment = "small_silencer"})
        else
            exports["soe-ui"]:SendAlert("error", "You must have a gun on hand", 5000)
        end
    end
}

itemdefs["large_silencer"] = {
    itemtype = "weapon_attachment",
    singular = "Large Silencer",
    multiple = "Large Silencers",
    weight = 0.02,
    description = "A silencer that attaches to a rifle or shotgun.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        if GetMyCurrentWeapon() then
            TriggerServerEvent("Inventory:Server:EquipAttachment", {status = true, gun = GetMyCurrentWeapon(), attachment = "large_silencer"})
        else
            exports["soe-ui"]:SendAlert("error", "You must have a gun on hand", 5000)
        end
    end
}

itemdefs["holographic_sight"] = {
    itemtype = "weapon_attachment",
    singular = "Holographic Sight",
    multiple = "Holographic Sights",
    weight = 0.02,
    description = "A holographic sight that attaches to a rifle.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        if GetMyCurrentWeapon() then
            TriggerServerEvent("Inventory:Server:EquipAttachment", {status = true, gun = GetMyCurrentWeapon(), attachment = "holographic_sight"})
        else
            exports["soe-ui"]:SendAlert("error", "You must have a gun on hand", 5000)
        end
    end
}

itemdefs["gun_scope"] = {
    itemtype = "weapon_attachment",
    singular = "Gun Scope",
    multiple = "Gun Scopes",
    weight = 0.02,
    description = "A gun scope that attaches to a rifle or SMG.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        if GetMyCurrentWeapon() then
            TriggerServerEvent("Inventory:Server:EquipAttachment", {status = true, gun = GetMyCurrentWeapon(), attachment = "gun_scope"})
        else
            exports["soe-ui"]:SendAlert("error", "You must have a gun on hand", 5000)
        end
    end
}

itemdefs["rifle_grip"] = {
    itemtype = "weapon_attachment",
    singular = "Rifle Grip",
    multiple = "Rifle Grips",
    weight = 0.02,
    description = "A gun grip that attaches to a rifle.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        if GetMyCurrentWeapon() then
            TriggerServerEvent("Inventory:Server:EquipAttachment", {status = true, gun = GetMyCurrentWeapon(), attachment = "rifle_grip"})
        else
            exports["soe-ui"]:SendAlert("error", "You must have a gun on hand", 5000)
        end
    end
}

-- TOOLS
itemdefs["drill"] = {
    itemtype = "tool",
    singular = "Drill",
    multiple = "Drills",
    weight = 10.5,
    description = "Don't go pointing that at people.",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["drillbit"] = {
    itemtype = "tool",
    singular = "Drill Bit",
    multiple = "Drill Bits",
    weight = 0.1,
    description = "You'll need this to drill!",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["jackstand"] = {
    itemtype = "object",
    singular = "Jack Stand",
    multiple = "Jack Stands",
    weight = 7.50,
    description = "A jack stand.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Inventory:Client:UseJackstand")
    end
}

itemdefs["enginekiller"] = {
    itemtype = "tool",
    singular = "Engine Killer",
    multiple = "Engine Killers",
    weight = 0.07,
    description = "Can kill a vehicle's engine so fast...",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Inventory:Client:UseEngineKiller")
    end
}

-- FOOD ITEMS
itemdefs["bread"] = {
    singular = "Slice of Bread",
    multiple = "Slices of Bread",
    weight = 0.08,
    description = "Just a simple bit of bread. It won't satisfy much, but it's food.",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        TriggerEvent("client.eat", 30, -5)
    end
}

itemdefs["sandwich"] = {
    singular = "Sandwich",
    multiple = "Sandwiches",
    weight = 0.2,
    description = "Just a plain healthy sandwich.",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Eat("Sandwich", 75, -5)
    end
}

itemdefs["beefjerky"] = {
    itemtype = "food",
    singular = "Beef Jerky",
    multiple = "Beef Jerky",
    weight = 0.3,
    description = "Kellys best jerky around",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Eat("Beef Jerky", 30, -5)
    end
}

itemdefs["burrito"] = {
    itemtype = "food",
    singular = "Burrito",
    multiple = "Burrito",
    weight = 0.75,
    description = "Specially made for you to spend an evening at home",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Eat("Hamburger", 75, -5)
    end
}

-- DRINKING ITEMS
itemdefs["water"] = {
    singular = "Bottle of Water",
    multiple = "Bottles of Water",
    weight = 0.8,
    description = "A bottle of water. Drink it to quench your thirst.",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Drink("Water Bottle", 0, 75)
    end
}

itemdefs["waterlarge"] = {
    itemtype = "drink",
    singular = "1.5L Bottle of Water",
    multiple = "1.5L Bottles of Water",
    weight = 1.5,
    description = "A bottle of water. Drink it to quench your thirst.",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Drink("Water Bottle", 0, 125)
    end
}

itemdefs["coffee"] = {
    itemtype = "drink",
    singular = "Cup of Coffee",
    multiple = "Cups of Coffee",
    weight = 0.8,
    description = "A cup of coffee. Nice to drink in the mornings.",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Drink("Coffee", 0, 30)
    end
}

itemdefs["grape"] = {
    itemtype = "drink",
    singular = "Box of Juice",
    multiple = "Boxes of Juice",
    weight = 0.6,
    description = "A box of juice. Drink it to quench your thirst.",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Drink("Juice", 0, 30)
    end
}

itemdefs["beer"] = {
    itemtype = "drink",
    singular = "Bottle of Beer",
    multiple = "Bottles of Beer",
    weight = 0.8,
    description = "A bottle of beer. Don't drink and drive!",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Drink("Beer", 0, 35)
        exports["soe-civ"]:SetAlcoholLevel(5)
    end
}

itemdefs["vodka"] = {
    itemtype = "drink",
    singular = "Bottle of Vodka",
    multiple = "Bottles of Vodka",
    weight = 0.8,
    description = "A bottle of vodka. Don't drink and drive!",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 12,
    onUse = function(uid)
        UseChargeItem("vodka", uid)
    end
}

itemdefs["donut"] = {
    itemtype = "food",
    singular = "Donut",
    multiple = "Donuts ",
    weight = 0.75,
    description = "Mmmm donuts",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Eat("Donut", 30, -5)
    end
}

itemdefs["taco"] = {
    itemtype = "food",
    singular = "Store Bought Taco",
    multiple = "Store Bought Tacos",
    weight = 0.75,
    description = "Time to get your Taco on!",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Eat("Taco", 75, -5)
    end
}

itemdefs["ecola"] = {
    itemtype = "food",
    singular = "Can of E-Cola",
    multiple = "Cans of E-Cola",
    weight = 0.06,
    description = "Refreshing to drink at any time of day.",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Drink("E-Cola", 0, 30)
    end
}

itemdefs["sprunk"] = {
    itemtype = "food",
    singular = "Can of Sprunk",
    multiple = "Cans of Sprunk",
    weight = 0.06,
    description = "Refreshing to drink at any time of day.",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Drink("Sprunk", 0, 30)
    end
}

itemdefs["ps&qs"] = {
    itemtype = "food",
    singular = "Bar of Ps & Qs",
    multiple = "Bars of Ps & Qs",
    weight = 0.06,
    description = "Ooo piece of candy!",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Eat("ps&qs", 30, -5)
    end
}

itemdefs["phatchips"] = {
    itemtype = "food",
    singular = "Bag of Phat Chips",
    multiple = "Bags of Phat Chips",
    weight = 0.06,
    description = "Nice and crisp",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Eat("Chips", 30, -5)
    end
}

itemdefs["joint"] = {
    itemtype = "food",
    singular = "Joint",
    multiple = "Joints",
    weight = 0.01,
    description = "Smoke weed everyday brah..",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        TriggerEvent("Crime:Client:DoDrugEffects", "Weed", "Marijuana")
    end
}

itemdefs["cigarette"] = {
    itemtype = "food",
    singular = "Cigarette",
    multiple = "Cigarettes",
    weight = 0.01,
    description = "Don't smoke, kids.",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-emotes"]:StartEmote("smoke")
    end
}

itemdefs["cigarettepack"] = {
    itemtype = "misc",
    singular = "Pack of Cigarettes",
    multiple = "Packs of Cigarettes",
    weight = 0.01,
    description = "Don't smoke, kids.",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 20,
    onUse = function(uid)
        UseChargeItem("cigarettepack", uid)
    end
}

itemdefs["gummies"] = {
    itemtype = "food",
    singular = "Gummie",
    multiple = "Gummies",
    weight = 0.075,
    description = "Can never go wrong with a gummie bear",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Eat("ps&qs", 25, -5)
    end
}

itemdefs["candybar"] = {
    itemtype = "food",
    singular = "Candy Bar",
    multiple = "Candy Bars",
    weight = 0.075,
    description = "When you're hungry, you're not you.",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Eat("ps&qs", 30, -5)
    end
}

itemdefs["bagofcandy"] = {
    itemtype = "food",
    singular = "Bag of Candy",
    multiple = "Bags of Candy",
    weight = 0.075,
    description = "Rainbow tasting",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Eat("ps&qs", 30, -5)
    end
}

itemdefs["shoe"] = {
    itemtype = "container",
    singular = "Shoe",
    multiple = "Shoes",
    weight = 0.005,
    description = "What are those!",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        --TriggerEvent("client:openContainer:shoe")
    end
}

itemdefs["panties1"] = {
    itemtype = "junk",
    singular = "Panties",
    multiple = "Panties",
    weight = 0.001,
    description = "Oh?",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["panties2"] = {
    itemtype = "junk",
    singular = "Panties",
    multiple = "Panties",
    weight = 0.001,
    description = "Oh?",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["panties3"] = {
    itemtype = "junk",
    singular = "Panties",
    multiple = "Panties",
    weight = 0.001,
    description = "Oh?",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["secretletter"] = {
    itemtype = "junk",
    singular = "Mysterious Invitation",
    multiple = "Mysterious Invitations",
    weight = 0.005,
    description = "You and a trusted colleague are invited to meet Arnefe. 5 pm, Shank St Heliport. No weapons and invitation must be presented.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        local name = exports["soe-chat"]:GetDisplayName()
        TriggerServerEvent("Chat:Server:ProximityMsg", 10.0, "me-2", "", name, "shows an invitation from someone named Arnefe...")
    end
}

itemdefs["awkwardpics"] = {
    itemtype = "junk",
    singular = "Picture",
    multiple = "Pictures",
    weight = 0.001,
    description = "Shame if these fell on the wrong hands.",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["empty_pot"] = {
    itemtype = "supplies",
    singular = "Empty Pot",
    multiple = "Empty Pot",
    weight = 0.50,
    description = "An empty pot.",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["soil_bag"] = {
    itemtype = "supplies",
    singular = "Soil Bag",
    multiple = "Soil Bag",
    weight = 0.15,
    description = "A bag of soil.",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["weed_seed"] = {
    itemtype = "supplies",
    singular = "Weed Seed",
    multiple = "Weed Seed",
    weight = 0.01,
    description = "A weed seed.",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["emptybottle"] = {
    itemtype = "junk",
    singular = "Empty Bottle",
    multiple = "Empty Bottles",
    weight = 0.5,
    description = "An empty bottle.",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["nintendoswitch"] = {
    itemtype = "tool",
    singular = "Nintendo Switch",
    multiple = "Nintendo Switches",
    weight = 0.80,
    description = "Why is Animal Crossing so popular?",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["headphones"] = {
    itemtype = "tool",
    singular = "Beats Headphones",
    multiple = "Beats Headphones",
    weight = 0.40,
    description = "What? I can't hear you!",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["brokenheadphones"] = {
    itemtype = "tool",
    singular = "Broken Beats Headphones",
    multiple = "Broken Beats Headphones",
    weight = 0.40,
    description = "What? I can't hear you!",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["earbuds"] = {
    itemtype = "tool",
    singular = "Earbuds",
    multiple = "Earbuds",
    weight = 0.01,
    description = "What? I can't hear you!",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["rag"] = {
    itemtype = "tool",
    singular = "Rag",
    multiple = "Rags",
    weight = 0.01,
    description = "A rag.",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        exports["soe-jobs"]:UseRag()
    end
}

itemdefs["usb"] = {
    itemtype = "tool",
    singular = "USB Stick",
    multiple = "USB Sticks",
    weight = 0.01,
    description = "What could be in here...",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["usb2"] = {
    itemtype = "tool",
    singular = "Red USB Stick",
    multiple = "Red USB Sticks",
    weight = 0.01,
    description = "What could be in here...",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["laptop"] = {
    itemtype = "tool",
    singular = "Laptop",
    multiple = "Laptops",
    weight = 0.95,
    description = "Slower than Windows XP.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "p_amb_lap_top_02", 0.0)
    end
}

itemdefs["brokenlaptop"] = {
    itemtype = "junk",
    singular = "Broken Laptop",
    multiple = "Broken Laptops",
    weight = 0.95,
    description = "Still better than Vista.",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["violin"] = {
    itemtype = "tool",
    singular = "Violin",
    multiple = "Violins",
    weight = 3.95,
    description = "A violin.",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["camera"] = {
    itemtype = "tool",
    singular = "Camera",
    multiple = "Cameras",
    weight = 0.95,
    description = "No flash photography.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_pap_camera_01", 0.06)
    end
}

itemdefs["weazelcamera"] = {
    itemtype = "tool",
    singular = "Weazel News Camera",
    multiple = "Weazel News Cameras",
    weight = 0.95,
    description = "Property of Weazel News.",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        exports["soe-jobs"]:UseCamera()
    end
}

itemdefs["designersunglasses"] = {
    itemtype = "junk",
    singular = "Designer Glasses",
    multiple = "Designer Glasses",
    weight = 0.01,
    description = "Trying to look cool?",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["cash"] = {
    itemtype = "money",
    singular = "Dollar Cash",
    multiple = "Dollars Cash",
    weight = 0.002,
    description = "Cold hard cash.",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["bankvaultkey"] = {
    itemtype = "bankkey",
    singular = "Bank Key",
    multiple = "Bank Keys",
    weight = 0.01,
    description = "Random key? Not sure exactly what this can be used for.",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["vaultcard_black"] = {
    itemtype = "bankcard",
    singular = "Black Bank Card",
    multiple = "Black Bank Cards",
    weight = 0.03,
    description = "Black!",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["vaultcard_red"] = {
    itemtype = "bankcard",
    singular = "Red Bank Card",
    multiple = "Red Bank Cards",
    weight = 0.03,
    description = "Red!",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["vaultcard_blue"] = {
    itemtype = "bankcard",
    singular = "Blue Bank Card",
    multiple = "Blue Bank Cards",
    weight = 0.03,
    description = "Blue!",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["vaultcard_green"] = {
    itemtype = "bankcard",
    singular = "Green Bank Card",
    multiple = "Green Bank Cards",
    weight = 0.03,
    description = "Green!",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["bankcard"] = {
    itemtype = "bankcard",
    singular = "Bank Card",
    multiple = "Bank Cards",
    weight = 0.06,
    description = "Don't spend it all at once.",
    canUse = false,
    canStack = false,
    reusable = false,
    onUse = function()
    end
}

itemdefs["dirtycash"] = {
    itemtype = "money",
    singular = "Marked Bill",
    multiple = "Marked Bills",
    weight = 0.0001,
    description = "What's with the markings..?",
    canUse = false,
    canStack = true,
    isIllegal = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["tintmeter"] = {
    itemtype = "tool",
    singular = "Tint Meter",
    multiple = "Tint Meter",
    weight = 0.125,
    description = "A tint meter.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        exports["soe-emergency"]:UseTintMeter()
    end
}

itemdefs["breathalyzer"] = {
    itemtype = "tool",
    singular = "Breathalyzer",
    multiple = "Breathalyzer",
    weight = 0.010,
    description = "A breathalyzer.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        exports["soe-civ"]:UseBreathalyzer()
    end
}

itemdefs["cocainevial"] = {
    itemtype = "drugs",
    singular = "Vial of Cocaine",
    multiple = "Vials of Cocaine",
    weight = 0.1,
    description = "Not to be confused with salt.",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = true,
    onUse = function()
        exports["soe-crime"]:SmokeCocaine()
    end
}

itemdefs["weed_smallbag"] = {
    itemtype = "drugs",
    singular = "Gram of Weed",
    multiple = "Grams of Weed",
    weight = 0.1,
    description = "Green!",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = true,
    onUse = function()
    end
}

itemdefs["crack_smallbag"] = {
    itemtype = "drugs",
    singular = "Gram of Crack",
    multiple = "Grams of Crack",
    weight = 0.1,
    description = "Oh boy...",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = true,
    onUse = function()
    end
}

itemdefs["morphine"] = {
    itemtype = "drugs",
    singular = "Morphine",
    multiple = "Morphine",
    weight = 0.1,
    description = "Why is the sky so rainbow?",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        --UseMorphine()
    end
}

itemdefs["painkillers"] = {
    itemtype = "drugs",
    singular = "Painkiller",
    multiple = "Painkillers",
    weight = 0.1,
    description = "Make the pain go away!",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-healthcare"]:UsePainKillers(3)
    end
}

itemdefs["WEAPON_KNIFE"] = {
    itemtype = "weapon",
    singular = "Knife",
    multiple = "Knives",
    weight = 0.345,
    description = "Shank, shank!",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_KNIFE", uid)
    end
}

itemdefs["WEAPON_DAGGER"] = {
    itemtype = "weapon",
    singular = "Dagger",
    multiple = "Daggers",
    weight = 0.33,
    description = "Shank, shank!",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_DAGGER", uid)
    end
}

itemdefs["WEAPON_MACHETE"] = {
    itemtype = "weapon",
    singular = "Machete",
    multiple = "Machetes",
    weight = 1.460,
    description = "Chop chop!",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_MACHETE", uid)
    end
}

itemdefs["WEAPON_PETROLCAN"] = {
    itemtype = "weapon",
    singular = "Petrol Can",
    multiple = "Petrol Cans",
    weight = 1.50,
    description = "Mobile fuel.",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_PETROLCAN", uid)
    end
}

itemdefs["WEAPON_GOLFCLUB"] = {
    itemtype = "weapon",
    singular = "Golf Club",
    multiple = "Golf Clubs",
    weight = 0.75,
    description = "Swing... And a miss!",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_GOLFCLUB", uid)
    end
}

itemdefs["GADGET_PARACHUTE"] = {
    itemtype = "weapon",
    singular = "Parachute",
    multiple = "Parachutes",
    weight = 1.215,
    description = "A parachute.",
    canUse = true,
    reusable = true,
    canStack = true,
    onUse = function()
        TriggerEvent("Inventory:Client:UseParachute")
    end
}

itemdefs["WEAPON_FIREEXTINGUISHER"] = {
    itemtype = "weapon",
    singular = "Fire Extinguisher",
    multiple = "Fire Extinguisher",
    weight = 1.415,
    description = "A fire extinguisher.",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_FIREEXTINGUISHER", uid)
    end
}

itemdefs["WEAPON_STUNGUN"] = {
    itemtype = "firearm",
    singular = "Taser",
    multiple = "Taser",
    weight = 1.095,
    description = "A taser. Zap! Zap!",
    canUse = true,
    reusable = true,
    canStack = false,
    noAttachments = true,
    onUse = function(uid)
        ToggleWeapon("WEAPON_STUNGUN", uid)
    end
}

itemdefs["WEAPON_CARBINERIFLE"] = {
    itemtype = "firearm",
    singular = "Carbine Rifle",
    multiple = "Carbine Rifle",
    weight = 1.950,
    description = "A carbine rifle.",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_CARBINERIFLE", uid)
    end
}

itemdefs["WEAPON_CARBINERIFLE_MK2"] = {
    itemtype = "firearm",
    singular = "Carbine Rifle MKII",
    multiple = "Carbine Rifle MKII",
    weight = 1.950,
    description = "A MKII carbine rifle.",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_CARBINERIFLE_MK2", uid)
    end
}

itemdefs["WEAPON_PUMPSHOTGUN"] = {
    itemtype = "firearm",
    singular = "Pump Shotgun",
    multiple = "Pump Shotguns",
    weight = 1.990,
    description = "Must be Redwood-Certified to use this.",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_PUMPSHOTGUN", uid)
    end
}

itemdefs["WEAPON_COMBATSHOTGUN"] = {
    itemtype = "firearm",
    singular = "Combat Shotgun",
    multiple = "Combat Shotguns",
    weight = 1.990,
    description = "A combat shotgun.",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_COMBATSHOTGUN", uid)
    end
}

itemdefs["WEAPON_MILITARYRIFLE"] = {
    itemtype = "firearm",
    singular = "Military Rifle",
    multiple = "Military Rifles",
    weight = 1.990,
    description = "A military rifle.",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_MILITARYRIFLE", uid)
    end
}

itemdefs["WEAPON_PUMPSHOTGUN_MK2"] = {
    itemtype = "firearm",
    singular = "Beanbag Shotgun",
    multiple = "Beanbag Shotguns",
    weight = 1.690,
    description = "Ouch!",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_PUMPSHOTGUN_MK2", uid)
    end
}

itemdefs["WEAPON_HEAVYSNIPER"] = {
    itemtype = "firearm",
    singular = "Heavy Sniper",
    multiple = "Heavy Sniper",
    weight = 2.293,
    description = "Do a 360 no-scope.",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_HEAVYSNIPER", uid)
    end
}

itemdefs["WEAPON_PISTOL"] = {
    itemtype = "firearm",
    singular = "Pistol",
    multiple = "Pistols",
    weight = 1.395,
    description = "A standard 9MM handgun.",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_PISTOL", uid)
    end
}

itemdefs["WEAPON_PISTOL_MK2"] = {
    itemtype = "firearm",
    singular = "Pistol Mk II",
    multiple = "Pistol Mk IIs",
    weight = 1.410,
    description = "A modified 9MM handgun.",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_PISTOL_MK2", uid)
    end
}

itemdefs["WEAPON_CERAMICPISTOL"] = {
    itemtype = "firearm",
    singular = "Ceramic Pistol",
    multiple = "Ceramic Pistols",
    weight = 1.395,
    description = "A ceramic pistol.",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_CERAMICPISTOL", uid)
    end
}

itemdefs["WEAPON_NAVYREVOLVER"] = {
    itemtype = "firearm",
    singular = "Navy Revolver",
    multiple = "Navy Revolver",
    weight = 1.405,
    description = "A navy revolver.",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_NAVYREVOLVER", uid)
    end
}

itemdefs["WEAPON_GADGETPISTOL"] = {
    itemtype = "firearm",
    singular = "Perico Pistol",
    multiple = "Perico Pistols",
    weight = 1.300,
    description = "A perico pistol.",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_GADGETPISTOL", uid)
    end
}

itemdefs["WEAPON_SMG"] = {
    itemtype = "firearm",
    singular = "SMG",
    multiple = "SMG",
    weight = 1.495,
    description = "An SMG.",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_SMG", uid)
    end
}

itemdefs["WEAPON_GLOCK"] = {
    itemtype = "firearm",
    singular = "Glock 17",
    multiple = "Glock 17",
    weight = 1.4,
    description = "A Glock 17 handgun.",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_GLOCK", uid)
    end
}

itemdefs["WEAPON_SIGP226"] = {
    itemtype = "firearm",
    singular = "Sig Sauer P226",
    multiple = "Sig Sauer P226",
    weight = 1.25,
    description = "A Sig Sauer P226 handgun.",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_SIGP226", uid)
    end
}

itemdefs["WEAPON_PSPRAY"] = {
    itemtype = "firearm",
    singular = "Pepper Spray",
    multiple = "Pepper Spray",
    weight = 1.0,
    description = "A Pepper Spray.",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_PSPRAY", uid)
    end
}

itemdefs["WEAPON_COMBATPISTOL"] = {
    itemtype = "firearm",
    singular = "Combat Pistol",
    multiple = "Combat Pistols",
    weight = 1.375,
    description = "A Combat Pistol handgun.",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_COMBATPISTOL", uid)
    end
}

itemdefs["WEAPON_PISTOL50"] = {
    itemtype = "firearm",
    singular = "Pistol .50",
    multiple = "Pistol .50",
    weight = 1.675,
    description = "A 50 cal handgun.",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_PISTOL50", uid)
    end
}

itemdefs["WEAPON_HEAVYPISTOL"] = {
    itemtype = "firearm",
    singular = "Heavy Pistol",
    multiple = "Heavy Pistols",
    weight = 1.535,
    description = "A .45 Handgun.",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_HEAVYPISTOL", uid)
    end
}

itemdefs["WEAPON_VINTAGEPISTOL"] = {
    itemtype = "firearm",
    singular = "Vintage Pistol",
    multiple = "Vintage Pistols",
    weight = 1.475,
    description = "An ancient handgun.",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_VINTAGEPISTOL", uid)
    end
}

itemdefs["WEAPON_SNOWBALL"] = {
    itemtype = "weapon",
    singular = "Snowball",
    multiple = "Snowballs",
    weight = 0.1,
    description = "Brrrrr.",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_SNOWBALL", uid)
    end
}

itemdefs["WEAPON_SNSPISTOL"] = {
    itemtype = "firearm",
    singular = "SNS Pistol",
    multiple = "SNS Pistol",
    weight = 0.650,
    description = "A small purse handgun.",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_SNSPISTOL", uid)
    end
}

itemdefs["WEAPON_SNSPISTOL_MK2"] = {
    itemtype = "firearm",
    singular = "Lidar Gun",
    multiple = "Lidar Guns",
    weight = 0.650,
    description = "Lidar gun used by law enforcement for determining vehicle speeds.",
    canUse = true,
    reusable = true,
    canStack = false,
    noAttachments = true,
    onUse = function(uid)
        ToggleWeapon("WEAPON_SNSPISTOL_MK2", uid)
        GiveWeaponComponentToPed(PlayerPedId(), GetHashKey("WEAPON_SNSPISTOL_MK2"), GetHashKey("COMPONENT_AT_PI_RAIL_02"))
    end
}

itemdefs["WEAPON_REVOLVER"] = {
    itemtype = "firearm",
    singular = "Heavy Revolver",
    multiple = "Heavy Revolvers",
    weight = 1.535,
    description = "Dirty harry style...",
    canUse = true,
    reusable = true,
    canStack = false,
    noAttachments = true,
    onUse = function(uid)
        ToggleWeapon("WEAPON_REVOLVER", uid)
    end
}

itemdefs["WEAPON_DOUBLEACTION"] = {
    itemtype = "firearm",
    singular = "Doubleaction",
    multiple = "Doubleaction",
    weight = 1.235,
    description = "A double action revolver.",
    canUse = true,
    reusable = true,
    canStack = false,
    noAttachments = true,
    onUse = function(uid)
        ToggleWeapon("WEAPON_DOUBLEACTION", uid)
    end
}

itemdefs["WEAPON_FLAREGUN"] = {
    itemtype = "firearm",
    singular = "Flare Gun",
    multiple = "Flare Guns",
    weight = 1.125,
    description = "A tool used to signal or cook somebody...",
    canUse = true,
    reusable = true,
    canStack = false,
    noAttachments = true,
    onUse = function(uid)
        ToggleWeapon("WEAPON_FLAREGUN", uid)
    end
}

itemdefs["WEAPON_FLARE"] = {
    itemtype = "weapon",
    singular = "Flare",
    multiple = "Flares",
    weight = 0.312,
    description = "A tool used to signal or cook somebody...",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_FLARE", uid)
    end
}

itemdefs["WEAPON_SMOKEGRENADE"] = {
    itemtype = "weapon",
    singular = "Tear Gas",
    multiple = "Tear Gas",
    weight = 0.200,
    description = "A tool used to gas somebody...",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_SMOKEGRENADE", uid)
    end
}

itemdefs["WEAPON_HAMMER"] = {
    itemtype = "weapon",
    singular = "Hammer",
    multiple = "Hammers",
    weight = 1.460,
    description = "A hammer.",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_HAMMER", uid)
    end
}

itemdefs["WEAPON_CROWBAR"] = {
    itemtype = "weapon",
    singular = "Crowbar",
    multiple = "Crowbars",
    weight = 1.420,
    description = "A crowbar.",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_CROWBAR", uid)
    end
}

itemdefs["WEAPON_WRENCH"] = {
    itemtype = "weapon",
    singular = "Pipe Wrench",
    multiple = "Pipe Wrench",
    weight = 1.460,
    description = "A pipe wrench.",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_WRENCH", uid)
    end
}

itemdefs["WEAPON_NIGHTSTICK"] = {
    itemtype = "weapon",
    singular = "Baton",
    multiple = "Batons",
    weight = 1.220,
    description = "A Baton.",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_NIGHTSTICK", uid)
    end
}

itemdefs["WEAPON_HATCHET"] = {
    itemtype = "weapon",
    singular = "Hatchet",
    multiple = "Hatchets",
    weight = 1.220,
    description = "A Hatchet.",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_HATCHET", uid)
    end
}

itemdefs["WEAPON_BATTLEAXE"] = {
    itemtype = "weapon",
    singular = "Battle Axe",
    multiple = "Battle Axes",
    weight = 1.220,
    description = "A Battle Axe.",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_BATTLEAXE", uid)
    end
}

itemdefs["WEAPON_BAT"] = {
    itemtype = "weapon",
    singular = "Baseball Bat",
    multiple = "Baseball Bats",
    weight = 1.720,
    description = "Batter, batter swing!",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_BAT", uid)
    end
}

itemdefs["WEAPON_UNICORN"] = {
    itemtype = "weapon",
    singular = "Unicorn",
    multiple = "Unicorn",
    weight = 1.45,
    description = "Concussion time?",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_UNICORN", uid)
    end
}

itemdefs["WEAPON_SLEDGEHAMMER"] = {
    itemtype = "weapon",
    singular = "Sledgehammer",
    multiple = "Sledgehammer",
    weight = 1.85,
    description = "Concussion time?",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_SLEDGEHAMMER", uid)
    end
}

itemdefs["WEAPON_KATANA"] = {
    itemtype = "weapon",
    singular = "Katana",
    multiple = "Katana",
    weight = 1.0,
    description = "You can cut so many things with this...",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_KATANA", uid)
    end
}

itemdefs["WEAPON_FLASHLIGHT"] = {
    itemtype = "weapon",
    singular = "Flashlight",
    multiple = "Flashlights",
    weight = 1.000,
    description = "Pretty bright.",
    canUse = true,
    reusable = true,
    canStack = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_FLASHLIGHT", uid)
    end
}

itemdefs["radio"] = {
    itemtype = "tool",
    singular = "Radio",
    multiple = "Radio",
    weight = 0.8,
    description = "A tool used to communicate with others.",
    canUse = true,
    reusable = true,
    canStack = true,
    onUse = function()
        Wait(1000)
        ExecuteCommand("radio")
    end
}

itemdefs["firstaidkit"] = {
    itemtype = "tool",
    singular = "First Aid Kit",
    multiple = "First Aid Kits",
    weight = 2.0,
    description = "A tool used to heal bleeding and other small injuries.",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-healthcare"]:UseFirstAidKit()
    end
}

itemdefs["repairkit"] = {
    itemtype = "tool",
    singular = "Repair Kit",
    multiple = "Repair Kits",
    weight = 4.5,
    description = "A tool used to repair vehicles.",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
        exports["soe-challenge"]:UseRepairKit(false)
    end
}

itemdefs["advancedrepairkit"] = {
    itemtype = "tool",
    singular = "Advanced Repair Kit",
    multiple = "Advanced Repair Kits",
    weight = 5.5,
    description = "An advanced tool used to repair vehicles.",
    canUse = true,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    isChargeItem = true,
    maxCharge = 5,
    onUse = function(uid)
        UseChargeItem("advancedrepairkit", uid)
    end
}

itemdefs["gps"] = {
    itemtype = "tool",
    singular = "GPS",
    multiple = "GPS",
    weight = 0.6,
    description = "A tool used to find places and streets.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        local name = exports["soe-chat"]:GetDisplayName()
        --TriggerServerEvent("Chat:Server:ProximityMsg", 10.0, "me", "", name, "toggles their GPS.")
        exports["soe-ui"]:ToggleMinimap(not exports["soe-ui"]:GetMinimap())

        CreateThread(function()
            local minimap = exports["soe-ui"]:GetMinimap()
            while minimap do
                Wait(8500)
                local hasGPS = HasInventoryItem("gps")
                -- DISABLE MINIMAP IF PLAYER DOESNT HAVE GPS
                if not hasGPS and minimap then
                    minimap = false
                    exports["soe-ui"]:ToggleMinimap(minimap)
                end
            end
        end)
    end
}

itemdefs["spikestrips"] = {
    itemtype = "tool",
    singular = "Spike Strip",
    multiple = "Spike Strips",
    weight = 5.5,
    description = "A tool used to neutralize tires of a vehicle.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Inventory:Client:UseSpikeStrips")
    end
}

itemdefs["gsrkit"] = {
    itemtype = "tool",
    singular = "GSR Kit",
    multiple = "GSR Kits",
    weight = 3.5,
    description = "A tool used to find gunshot residue on a person or object.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        exports["soe-csi"]:UseGSRKit()
    end
}

itemdefs["gsrresult"] = {
    itemtype = "tool",
    singular = "GSR Test Kit Result",
    multiple = "GSR Test Kit Results",
    weight = 0.08,
    description = "A GSR test kit result.",
    canUse = false,
    canStack = false,
    reusable = false
}

itemdefs["slimjim"] = {
    itemtype = "tool",
    singular = "Slim Jim Tool",
    multiple = "Slim Jim Tools",
    weight = 1.0,
    description = "A tool used to enter locked vehicles.",
    canUse = true,
    canStack = true,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
        exports["soe-challenge"]:UseSlimjim()
    end
}

itemdefs["pliers"] = {
    itemtype = "tool",
    singular = "Pliers",
    multiple = "Pliers",
    weight = 0.05,
    description = "A tool used to squeeze stuff.",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["multitool"] = {
    itemtype = "tool",
    singular = "Multitool",
    multiple = "Multitool",
    weight = 0.05,
    description = "A tool that uses multiple things.",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["wirestripper"] = {
    itemtype = "tool",
    singular = "Wire Stripper",
    multiple = "Wire Strippers",
    weight = 0.04,
    description = "A tool used to strip wires.",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["electricaltape"] = {
    itemtype = "tool",
    singular = "Electrical Tape",
    multiple = "Electrical Tape",
    weight = 0.03,
    description = "A tool used to tape stuff together.",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["screwdriver"] = {
    itemtype = "tool",
    singular = "Screwdriver",
    multiple = "Screwdrivers",
    weight = 0.03,
    description = "A tool used to screw things",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["thermite"] = {
    itemtype = "tool",
    singular = "Thermite",
    multiple = "Thermite",
    weight = 0.03,
    description = "Heard that these were explosive.",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-crime"]:UseThermite()
    end
}

itemdefs["thermalcharge"] = {
    itemtype = "tool",
    singular = "Thermal Charge",
    multiple = "Thermal Charges",
    weight = 0.065,
    description = "Heard that these were explosive.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Inventory:Client:UseThermalCharge")
    end
}

itemdefs["binos"] = {
    itemtype = "tool",
    singular = "Binoculars",
    multiple = "Binoculars",
    weight = 3.5,
    description = "A tool used to see far away.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        exports["soe-civ"]:UseBinoculars()
    end
}

itemdefs["measuringtape"] = {
    itemtype = "tool",
    singular = "Measuring Tape",
    multiple = "Measuring Tapes",
    weight = 0.06,
    description = "A tool used to measure from Point A to Point B.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        exports["soe-civ"]:UseMeasuringTape()
    end
}

itemdefs["lockpick"] = {
    itemtype = "tool",
    singular = "Lockpick",
    multiple = "Lockpicks",
    weight = 0.291,
    description = "A tool used to enter locked objects and vehicles.",
    canUse = true,
    canStack = true,
    reusable = true,
    isIllegal = true,
    onUse = function()
        TriggerEvent("Inventory:Client:UseLockpick", false)
    end
}

itemdefs["advancedlockpick"] = {
    itemtype = "tool",
    singular = "Advanced Lockpick",
    multiple = "Advanced Lockpicks",
    weight = 0.296,
    description = "A tool used to enter locked objects.",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = true,
    onUse = function()
        TriggerEvent("Inventory:Client:UseLockpick", true)
    end
}

itemdefs["bag"] = {
    itemtype = "tool",
    singular = "Bag",
    multiple = "Bags",
    weight = 0.01,
    description = "Use it to cover someone's head!",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["handcuffs"] = {
    itemtype = "tool",
    singular = "Handcuffs",
    multiple = "Handcuffs",
    weight = 0.625,
    description = "A tool cops use to detain a person or something else... ;)",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["zipties"] = {
    itemtype = "tool",
    singular = "Zip Ties",
    multiple = "Zip Ties",
    weight = 0.008,
    description = "A tool used to tie something up well.",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["scissors"] = {
    itemtype = "tool",
    singular = "Scissors",
    multiple = "Scissors",
    weight = 0.001,
    description = "A tool used to cut things.",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["cuffkey"] = {
    itemtype = "tool",
    singular = "Cuff Key",
    multiple = "Cuff Keys",
    weight = 0.10,
    description = "A tool to unlock handcuffs.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["tablet"] = {
    itemtype = "tool",
    singular = "Core Tablet",
    multiple = "Core Tablets",
    weight = 1.0,
    description = "A gadget that goes beep boop.",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        Wait(1500)
        ExecuteCommand("tablet")
    end
}

itemdefs["brokentablet"] = {
    itemtype = "tool",
    singular = "Broken Core Tablet",
    multiple = "Broken Core Tablets",
    weight = 1.0,
    description = "A gadget that went beep boop.",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["weedbrick"] = {
    itemtype = "drug",
    singular = "Brick of Marijuana",
    multiple = "Bricks of Marijuana",
    weight = 1.0,
    description = "A tightly packed brick of quality marijuana.",
    canUse = false,
    reusable = true,
    canStack = true,
    isIllegal = true,
    onUse = function()
    end
}

itemdefs["cocainebrick"] = {
    itemtype = "drug",
    singular = "Brick of Cocaine",
    multiple = "Bricks of Cocaine",
    weight = 1.0,
    description = "A tightly packed brick of quality cocaine.",
    canUse = false,
    reusable = true,
    canStack = true,
    isIllegal = true,
    onUse = function()
    end
}

itemdefs["cracktray"] = {
    itemtype = "drug",
    singular = "Tray of Crack",
    multiple = "Trays of Crack",
    weight = 1.0,
    description = "Secured pack trays of quality crack.",
    canUse = false,
    reusable = true,
    canStack = true,
    isIllegal = true,
    onUse = function()
    end
}

-- FISH ITEMS START
itemdefs["fish"] = {
    itemtype = "fish",
    singular = "Fish",
    multiple = "Fish",
    weight = 1.0,
    description = "A fish.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["sunfish"] = {
    itemtype = "fish",
    singular = "Sunfish",
    multiple = "Sunfish",
    weight = 1.0,
    description = "A fish.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["bass"] = {
    itemtype = "fish",
    singular = "Smallmouth Bass",
    multiple = "Smallmouth Bass",
    weight = 1.0,
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["rainbowtrout"] = {
    itemtype = "fish",
    singular = "Rainbow Trout",
    multiple = "Rainbow Trout",
    weight = 1.0,
    description = "A fish.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["freshwatersalmon"] = {
    itemtype = "fish",
    singular = "Freshwater Salmon",
    multiple = "Freshwater Salmon",
    weight = 1.0,
    description = "A fish.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["channelcatfish"] = {
    itemtype = "fish",
    singular = "Channel Catfish",
    multiple = "Channel Catfish",
    weight = 1.0,
    description = "A fish.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["reddrum"] = {
    itemtype = "fish",
    singular = "Red Drum",
    multiple = "Red Drums",
    weight = 1.0,
    description = "A fish.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["tilapia"] = {
    itemtype = "fish",
    singular = "Tilapia",
    multiple = "Tilapia",
    weight = 1.0,
    description = "A fish.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["corvina"] = {
    itemtype = "fish",
    singular = "Corvina",
    multiple = "Corvina",
    weight = 1.0,
    description = "A fish.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["largemouthbass"] = {
    itemtype = "fish",
    singular = "Large Mouth Bass",
    multiple = "Large Mouth Bass",
    weight = 1.0,
    description = "A fish.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["carp"] = {
    itemtype = "fish",
    singular = "Carp",
    multiple = "Carp",
    weight = 1.0,
    description = "A fish.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["whitecatfish"] = {
    itemtype = "fish",
    singular = "White Catfish",
    multiple = "White Catfish",
    weight = 1.0,
    description = "A fish.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["razorbacksucker"] = {
    itemtype = "fish",
    singular = "Razorback Sucker",
    multiple = "Razorback Sucker",
    weight = 1.0,
    description = "A fish.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = true,
    onUse = function()
    end
}

itemdefs["freshwatereel"] = {
    itemtype = "fish",
    singular = "Freshwater Eels",
    multiple = "Freshwater Eels",
    weight = 1.0,
    description = "A fish.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = true,
    onUse = function()
    end
}

itemdefs["turtle"] = {
    itemtype = "fish",
    singular = "Turtle",
    multiple = "Turtles",
    weight = 1.0,
    description = "A shelly boi.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = true,
    onUse = function()
    end
}

itemdefs["riversturgeon"] = {
    itemtype = "fish",
    singular = "River Sturgeon",
    multiple = "River Sturgeon",
    weight = 1.0,
    description = "A fish.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = true,
    onUse = function()
    end
}

itemdefs["rockfish"] = {
    itemtype = "fish",
    singular = "Rockfish",
    multiple = "Rockfish",
    weight = 1.0,
    description = "A fish.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["cod"] = {
    itemtype = "fish",
    singular = "Cod",
    multiple = "Cod",
    weight = 1.0,
    description = "A fish.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["mackerel"] = {
    itemtype = "fish",
    singular = "Mackerel",
    multiple = "Mackerel",
    weight = 1.0,
    description = "A fish.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["perch"] = {
    itemtype = "fish",
    singular = "Perch",
    multiple = "Perch",
    weight = 1.0,
    description = "A fish.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["seabass"] = {
    itemtype = "fish",
    singular = "Sea Bass",
    multiple = "Sea Bass",
    weight = 1.0,
    description = "A fish.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["flounder"] = {
    itemtype = "fish",
    singular = "Flounder",
    multiple = "Flounder",
    weight = 1.0,
    description = "A fish.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["halibut"] = {
    itemtype = "fish",
    singular = "Halibut",
    multiple = "Halibut",
    weight = 1.0,
    description = "A fish.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["swordfish"] = {
    itemtype = "fish",
    singular = "Swordfish",
    multiple = "Swordfish",
    weight = 1.0,
    description = "A fish.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["yellowfintuna"] = {
    itemtype = "fish",
    singular = "Yellow Fin Tuna",
    multiple = "Yellow Fin Tuna",
    weight = 1.0,
    description = "A fish.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["ghostfish"] = {
    itemtype = "fish",
    singular = "Ghost Fish",
    multiple = "Ghost Fish",
    weight = 1.0,
    description = "A fish.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["witchflounder"] = {
    itemtype = "fish",
    singular = "Witch Flounder",
    multiple = "Witch Flounder",
    weight = 1.0,
    description = "A fish.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["bonefish"] = {
    itemtype = "fish",
    singular = "Bone Fish",
    multiple = "Bone Fish",
    weight = 1.0,
    description = "A fish.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["vampirefish"] = {
    itemtype = "fish",
    singular = "Vampire Fish",
    multiple = "Vampire Fish",
    weight = 1.0,
    description = "A fish.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["moonfish"] = {
    itemtype = "fish",
    singular = "Moon Fish",
    multiple = "Moon Fish",
    weight = 1.0,
    description = "A fish.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["fishingrod"] = {
    itemtype = "tool",
    singular = "Fishing Rod",
    multiple = "Fishing Rods",
    weight = 1.0,
    description = "A rod for fishing.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        ExecuteCommand("fish")
    end
}

itemdefs["lobworm"] = {
    itemtype = "tool",
    singular = "Lobworm",
    multiple = "Lobworms",
    weight = 0.001,
    description = "A worm or something.",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["fishingmap"] = {
    itemtype = "tool",
    singular = "Fishing Map",
    multiple = "Fishing Maps",
    weight = 0.003,
    description = "Shows places where you can grab a boat and fish!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        exports["soe-jobs"]:UseFishingMap()
    end
}

-- FISH ITEMS END

itemdefs["1LHydrochloricAcidBottle"] = {
    itemtype = "tool",
    singular = "Bottle of 1L Hydrochloric Acid",
    multiple = "Bottles of 1L Hydrochloric Acid",
    weight = 1.0,
    description = "A bottle of 1L Hydrochloric Acid, wonder what can be made with this.",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["AAEnergizerLithiumBatteries"] = {
    itemtype = "tool",
    singular = "AA Energizer Lithium Battery",
    multiple = "AA Energizer Lithium Batteries",
    weight = 1.0,
    description = "Charging up.",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["60mgPseudophedrinePills"] = {
    itemtype = "drugs",
    singular = "Pack of 60mg Pseudophedrine Pills",
    multiple = "Packs of 60mg Pseudophedrine Pills",
    weight = 0.25,
    description = "Stay awake with these",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["shrooms"] = {
    itemtype = "drugs",
    singular = "Magic Mushroom",
    multiple = "Magic Mushrooms",
    weight = 0.05,
    description = "I wonder why they are magic...",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = true,
    onUse = function()
        TriggerEvent("Crime:Client:DoDrugEffects", "Shrooms")
    end
}

itemdefs["gramofmeth"] = {
    itemtype = "drugs",
    singular = "Gram of Meth",
    multiple = "Grams of Meth",
    weight = 0.0022,
    description = "Woooo weeeee.",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = true,
    onUse = function()
        TriggerEvent("Crime:Client:DoDrugEffects", "Meth")
    end
}

itemdefs["WEAPON_FIREWORK"] = {
    itemtype = "weapon",
    singular = "Firework Launcher",
    multiple = "Firework Launcher",
    weight = 2.0,
    description = "A firework launcher for celebrations.",
    canUse = true,
    reusable = true,
    canStack = false,
    isIllegal = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_FIREWORK", uid)
    end
}

itemdefs["digiScanner"] = {
    itemtype = "tool",
    singular = "Digital Scanner",
    multiple = "Digital Scanner",
    weight = 1.0,
    description = "A digital scanner.",
    reusable = true,
    onUse = function()
        GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_DIGISCANNER"), 1, false, true)
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_DIGISCANNER"), true)
    end
}

itemdefs["WEAPON_SPECIALCARBINE"] = {
    itemtype = "firearm",
    singular = "Special Carbine",
    multiple = "Special Carbine",
    weight = 1.0,
    description = "A Special Carbine.",
    canUse = true,
    reusable = true,
    canStack = false,
    isIllegal = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_SPECIALCARBINE", uid)
    end
}

itemdefs["WEAPON_SPECIALCARBINE_MK2"] = {
    itemtype = "firearm",
    singular = "Special Carbine Mk2",
    multiple = "Special Carbine Mk2",
    weight = 1.0,
    description = "A Special Carbine Mk2.",
    canUse = true,
    reusable = true,
    canStack = false,
    isIllegal = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_SPECIALCARBINE_MK2", uid)
    end
}

-- ILLEGAL WEAPONS
itemdefs["WEAPON_ASSAULTRIFLE"] = {
    itemtype = "firearm",
    singular = "Assault Rifle",
    multiple = "Assault Rifles",
    weight = 1.950,
    description = "An assault rifle.",
    canUse = true,
    reusable = true,
    canStack = false,
    isIllegal = true,
    onUse = function(uid)
        ToggleWeapon("WEAPON_ASSAULTRIFLE", uid)
    end
}

itemdefs["WEAPON_MACHINEPISTOL"] = {
    itemtype = "firearm",
    singular = "Machine Pistol",
    multiple = "Machine Pistols",
    weight = 1.950,
    description = "A machine pistol.",
    canUse = true,
    reusable = true,
    canStack = false,
    isIllegal = true,
    noAttachments = true,
    onUse = function(uid)
        ToggleWeapon("WEAPON_MACHINEPISTOL", uid)
    end
}

itemdefs["WEAPON_APPISTOL"] = {
    itemtype = "firearm",
    singular = "AP Pistol",
    multiple = "AP Pistol",
    weight = 1.600,
    description = "An AP Pistol.",
    canUse = true,
    reusable = true,
    canStack = false,
    isIllegal = true,
    onUse = function(uid)
        ToggleWeapon("WEAPON_APPISTOL", uid)
    end
}

itemdefs["WEAPON_MINISMG"] = {
    itemtype = "firearm",
    singular = "Mini SMG",
    multiple = "Mini SMG",
    weight = 1.810,
    description = "A mini SMG.",
    canUse = true,
    reusable = true,
    canStack = false,
    isIllegal = true,
    onUse = function(uid)
        ToggleWeapon("WEAPON_MINISMG", uid)
    end
}

itemdefs["WEAPON_MICROSMG"] = {
    itemtype = "firearm",
    singular = "Micro SMG",
    multiple = "Micro SMG",
    weight = 1.950,
    description = "A micro SMG.",
    canUse = true,
    reusable = true,
    canStack = false,
    isIllegal = true,
    onUse = function(uid)
        ToggleWeapon("WEAPON_MICROSMG", uid)
    end
}

itemdefs["WEAPON_COMPACTRIFLE"] = {
    itemtype = "firearm",
    singular = "Compact Rifle",
    multiple = "Compact Rifles",
    weight = 1.950,
    description = "A compact rifle.",
    canUse = true,
    reusable = true,
    canStack = false,
    isIllegal = true,
    onUse = function(uid)
        ToggleWeapon("WEAPON_COMPACTRIFLE", uid)
    end
}

itemdefs["WEAPON_MARKSMANRIFLE"] = {
    itemtype = "firearm",
    singular = "Marksman Rifle",
    multiple = "Marksman Rifles",
    weight = 1.950,
    description = "A marksman rifle.",
    canUse = true,
    reusable = true,
    canStack = false,
    isIllegal = true,
    onUse = function(uid)
        ToggleWeapon("WEAPON_MARKSMANRIFLE", uid)
    end
}

itemdefs["WEAPON_SWITCHBLADE"] = {
    itemtype = "weapon",
    singular = "Switchblade",
    multiple = "Switchblades",
    weight = 0.345,
    description = "A switchblade.",
    canUse = true,
    reusable = true,
    canStack = false,
    isIllegal = true,
    onUse = function(uid)
        ToggleWeapon("WEAPON_SWITCHBLADE", uid)
    end
}

itemdefs["WEAPON_BOTTLE"] = {
    itemtype = "weapon",
    singular = "Broken Bottle",
    multiple = "Broken Bottles",
    weight = 0.345,
    description = "A broken bottle.",
    canUse = true,
    reusable = true,
    canStack = false,
    isIllegal = true,
    onUse = function(uid)
        ToggleWeapon("WEAPON_BOTTLE", uid)
    end
}

itemdefs["WEAPON_SAWNOFFSHOTGUN"] = {
    itemtype = "firearm",
    singular = "Sawn off Shotgun",
    multiple = "Sawn off Shotgun",
    weight = 0.345,
    description = "A Sawn off Shotgun.",
    canUse = true,
    reusable = true,
    canStack = false,
    isIllegal = true,
    noAttachments = true,
    onUse = function(uid)
        ToggleWeapon("WEAPON_SAWNOFFSHOTGUN", uid)
    end
}

itemdefs["WEAPON_DBSHOTGUN"] = {
    itemtype = "firearm",
    singular = "Double Barrel Shotgun",
    multiple = "Double Barrel Shotgun",
    weight = 0.345,
    description = "A Double Barrel Shotgun.",
    canUse = true,
    reusable = true,
    canStack = false,
    isIllegal = true,
    onUse = function(uid)
        ToggleWeapon("WEAPON_DBSHOTGUN", uid)
    end
}

itemdefs["WEAPON_MOLOTOV"] = {
    itemtype = "weapon",
    singular = "Molotov Cocktail",
    multiple = "Molotov Cocktail",
    weight = 0.345,
    description = "A Molotov Cocktail.",
    canUse = true,
    reusable = true,
    canStack = false,
    isIllegal = true,
    onUse = function(uid)
        ToggleWeapon("WEAPON_MOLOTOV", uid)
    end
}

-- PROSPECTING ITEMS
itemdefs["metaldetector"] = {
    itemtype = "tool",
    singular = "Metal Detector",
    multiple = "Metal Detectors",
    weight = 1.05,
    description = "A detector for metallic objects.",
    canUse = true,
    reusable = true,
    canStack = true,
    onUse = function()
        TriggerEvent("Jobs:Client:BeginProspect")
    end
}

itemdefs["dogcollar"] = {
    itemtype = "junk",
    singular = "Dog Collar",
    multiple = "Dog Collars",
    weight = 0.25,
    description = "A dog collar, wonder if it's a dogs or a persons?",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["brokenbeltbuckle"] = {
    itemtype = "junk",
    singular = "Broken Belt Buckle",
    multiple = "Broken Belt Buckles",
    weight = 0.25,
    description = "Used to help keep pants on",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["earrings"] = {
    itemtype = "jewllery",
    singular = "Pair of earrings",
    multiple = "Pairs of Earrings",
    weight = 0.25,
    description = "A beautiful set of earrings.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["necklace"] = {
    itemtype = "jewllery",
    singular = "Necklace",
    multiple = "Necklaces",
    weight = 0.25,
    description = "A necklace with white beads.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["bracelet"] = {
    itemtype = "jewllery",
    singular = "Bracelet",
    multiple = "Bracelets",
    weight = 0.25,
    description = "A wonderful bracelet for your wrists.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["goldwatch"] = {
    itemtype = "jewllery",
    singular = "Gold Watch",
    multiple = "Gold Watches",
    weight = 0.25,
    description = "An expensive gold watch.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["goldring"] = {
    itemtype = "jewllery",
    singular = "Gold Ring",
    multiple = "Gold Rings",
    weight = 0.25,
    description = "An expensive gold ring.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["goldtooth"] = {
    itemtype = "jewllery",
    singular = "Gold Tooth",
    multiple = "Gold Teeth",
    weight = 0.25,
    description = "A gold tooth, wonder where that's been?",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["luckycoin"] = {
    itemtype = "valuable",
    singular = "Lucky Coin",
    multiple = "Lucky Coins",
    weight = 0.25,
    description = "Must not be that lucky if it's in the ground.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["emptysodacan"] = {
    itemtype = "junk",
    singular = "Empty Soda Can",
    multiple = "Empty Tin Cans",
    weight = 0.25,
    description = "A worthless tin can.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["scrapmetal"] = {
    itemtype = "junk",
    singular = "Scrap Metal",
    multiple = "Scrap Metal",
    weight = 0.25,
    description = "Piece of scrap metal",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["musketball"] = {
    itemtype = "junk",
    singular = "Musket ball",
    multiple = "Musket balls",
    weight = 0.05,
    description = "Ammunition for a musket",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["cannonball"] = {
    itemtype = "junk",
    singular = "Cannon ball",
    multiple = "Cannon balls",
    weight = 0.50,
    description = "Ready the cannons!",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["oldcoatbutton"] = {
    itemtype = "junk",
    singular = "Old Coat Button",
    multiple = "Old Coat Buttons",
    weight = 0.02,
    description = "Button from the 1800s!",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["oldfork"] = {
    itemtype = "junk",
    singular = "Old Fork",
    multiple = "Old Forks",
    weight = 0.50,
    description = "An old fork, not for eating.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["oldspoon"] = {
    itemtype = "junk",
    singular = "Old Spoon",
    multiple = "Old Spoon",
    weight = 0.50,
    description = "An old spoon, not for eating.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["oldknife"] = {
    itemtype = "junk",
    singular = "Old Knife",
    multiple = "Old Knives",
    weight = 0.50,
    description = "An old knife, not for eating.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["rustyslimjim"] = {
    itemtype = "junt",
    singular = "Rusty Slim Jim",
    multiple = "Rusty Slim Jims",
    weight = 1.0,
    description = "A tool once used to enter locked vehicles.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["rustymultitool"] = {
    itemtype = "junk",
    singular = "Rusty Multitool",
    multiple = "Rusty Multitools",
    weight = 1.0,
    description = "A once powerful too but now rusted.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["foreigncoins"] = {
    itemtype = "junk",
    singular = "Foreign Coins",
    multiple = "Foreign Coins",
    weight = 0.02,
    description = "Coins from another country!",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["emptycan"] = {
    itemtype = "junk",
    singular = "Empty Can",
    multiple = "Empty Cans",
    weight = 0.03,
    description = "Already been emptied!",
    canUse = false,
    reusable = true,
    canStack = true,
    onUse = function()
    end
}

itemdefs["floppydisk"] = {
    itemtype = "junk",
    singular = "Floppy Disk",
    multiple = "Floppy Disks",
    weight = 0.05,
    description = "Once used for computers... back in the day.",
    canUse = false,
    reusable = true,
    canStack = true,
    onUse = function()
    end
}

itemdefs["badsparkplug"] = {
    itemtype = "junk",
    singular = "Bad Sparkplug",
    multiple = "Bad Sparkplugs",
    weight = 0.02,
    description = "Once used to start a car, now junk!",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["brokencellphone"] = {
    itemtype = "junk",
    singular = "Broken Cellphone",
    multiple = "Broken Cellphones",
    weight = 0.02,
    description = "Poor thing. Looks like it didn't survive.",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["rustynail"] = {
    itemtype = "junk",
    singular = "Rusty Nail",
    multiple = "Rusty Nails",
    weight = 0.02,
    description = "A rusty nail.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["bottlecap"] = {
    itemtype = "junk",
    singular = "Bottle Cap",
    multiple = "Bottle Caps",
    weight = 0.02,
    description = "Currency of the future.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["dogtag"] = {
    itemtype = "junk",
    singular = "Dog Tag",
    multiple = "Dog Tags",
    weight = 0.02,
    description = "Tags for dogs or humans?",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["rustyAxeHead"] = {
    itemtype = "junk",
    singular = "Rusty Axe Head",
    multiple = "Rusty Axe Heads",
    weight = 0.02,
    description = "Where's the handle?",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["corrodedbulletcasing"] = {
    itemtype = "junk",
    singular = "Corroded Bullet Casing",
    multiple = "Corroded Bullet Casings",
    weight = 0.02,
    description = "A corroded bulled casing.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["rustyfliplighter"] = {
    itemtype = "junk",
    singular = "Rusty Flip Lighter",
    multiple = "Rusty Flip Lighters",
    weight = 0.02,
    description = "An old and rusted flip lighter.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["rustypocketwatch"] = {
    itemtype = "junk",
    singular = "Rusty Pocket Watch",
    multiple = "Rusty Pocket Watch",
    weight = 0.02,
    description = "An old and rusted pocket watch.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["cellphone"] = {
    itemtype = "tool",
    singular = "Cell Phone",
    multiple = "Cell Phones",
    weight = 0.2,
    description = "A cellular device",
    canUse = true,
    canStack = false,
    reusable = true,
    onUse = function(uid)
        -- exports["soe-phone-new"]:setPrimaryPhoneData(uid, myInventory[uid].metadata)
        -- print("Remind boba to make this a thing when you use a phone")
        print(uid)
        exports["soe-gphone"]:InventoryUse(uid)
    end
}

-- PROSPECTING ITEMS END

-- MINING ITEMS

itemdefs["pickaxe"] = {
    itemtype = "tool",
    singular = "Pickaxe",
    multiple = "Pickaxes",
    weight = 2.5,
    description = "A pickaxe used for mining.",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["copperore"] = {
    itemtype = "rock",
    singular = "Copper Ore",
    multiple = "Copper Ores",
    weight = 1.5,
    description = "Copper Ore",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["silverore"] = {
    itemtype = "rock",
    singular = "Silver Ore",
    multiple = "Silver Ores",
    weight = 2.1,
    description = "Silver ore",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["goldore"] = {
    itemtype = "rock",
    singular = "Gold Ore",
    multiple = "Gold Ores",
    weight = 2.5,
    description = "Gold ore",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["coal"] = {
    itemtype = "rock",
    singular = "Coal",
    multiple = "Coal",
    weight = 1.0,
    description = "Coal",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["ironore"] = {
    itemtype = "rock",
    singular = "Iron Ore",
    multiple = "Iron Ores",
    weight = 1.0,
    description = "Iron Ore",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["rocks"] = {
    itemtype = "rock",
    singular = "Rocks",
    multiple = "Rocks",
    weight = 2.0,
    description = "Rocks",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["diamond"] = {
    itemtype = "rock",
    singular = "Diamond",
    multiple = "Diamonds",
    weight = 0.025,
    description = "A very hard rock.",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["emerald"] = {
    itemtype = "rock",
    singular = "Emerald",
    multiple = "Emeralds",
    weight = 0.027,
    description = "A very hard rock.",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["goldnugget"] = {
    itemtype = "rock",
    singular = "Gold Nugget",
    multiple = "Gold Nuggets",
    weight = 0.015,
    description = "A very hard rock.",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["ruby"] = {
    itemtype = "rock",
    singular = "Ruby",
    multiple = "Ruby",
    weight = 0.018,
    description = "A very hard rock.",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["sapphire"] = {
    itemtype = "rock",
    singular = "Sapphire",
    multiple = "Sapphire",
    weight = 0.018,
    description = "A very hard rock.",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

-- MINING ITEMS END

-- HUNTING ITEMS

itemdefs["WEAPON_MUSKET"] = {
    itemtype = "firearm",
    singular = "Musket",
    multiple = "Musket",
    weight = 2.293,
    description = "A rifle used for hunting.",
    canUse = true,
    reusable = true,
    canStack = false,
    isIllegal = false,
    onUse = function(uid)
        ToggleWeapon("WEAPON_MUSKET", uid)
    end
}

itemdefs["boarmeat"] = {
    itemtype = "hunting",
    singular = "Boar Meat",
    multiple = "Boar Meats",
    weight = 1.0,
    description = "Meat from a Boar",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["boarpelt"] = {
    itemtype = "hunting",
    singular = "Boar Pelt",
    multiple = "Boar Pelts",
    weight = 1.0,
    description = "Boar Pelt",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["boarpeltpoor"] = {
    itemtype = "hunting",
    singular = "Poor Boar Pelt",
    multiple = "Poor Boar Pelts",
    weight = 1.0,
    description = "Poor Boar Pelt",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["boarpeltperfect"] = {
    itemtype = "hunting",
    singular = "Perfect Boar Pelt",
    multiple = "Perfect Boar Pelts",
    weight = 1.0,
    description = "Perfect Boar Pelt",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["deermeat"] = {
    itemtype = "hunting",
    singular = "Deer Meat",
    multiple = "Deer Meats",
    weight = 1.0,
    description = "Meat from a Deer",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["deerpelt"] = {
    itemtype = "hunting",
    singular = "Deer Pelt",
    multiple = "Deer Pelts",
    weight = 1.0,
    description = "Deer Pelt",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["deerpeltpoor"] = {
    itemtype = "hunting",
    singular = "Poor Deer Pelt",
    multiple = "Poor Deer Pelts",
    weight = 1.0,
    description = "Poor Deer Pelt",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["deerpeltperfect"] = {
    itemtype = "hunting",
    singular = "Perfect Deer Pelt",
    multiple = "Perfect Deer Pelts",
    weight = 1.0,
    description = "Perfect Deer Pelt",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["chickenmeat"] = {
    itemtype = "hunting",
    singular = "Chicken Meat",
    multiple = "Chicken Meats",
    weight = 1.0,
    description = "Meat from a Chicken",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["birdmeat"] = {
    itemtype = "hunting",
    singular = "Bird Meat",
    multiple = "Bird Meats",
    weight = 1.0,
    description = "Meat from a Bird",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["smallgamemeat"] = {
    itemtype = "hunting",
    singular = "Small Game Meat",
    multiple = "Small Game Meats",
    weight = 1.0,
    description = "Meat from Small Game",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["smallgamepelt"] = {
    itemtype = "hunting",
    singular = "Small Game Pelt",
    multiple = "Small Game Pelts",
    weight = 1.0,
    description = "Small Game Pelt",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["smallgamepeltpoor"] = {
    itemtype = "hunting",
    singular = "Poor Small Game Pelt",
    multiple = "Poor Small Game Pelts",
    weight = 1.0,
    description = "Poor Small Game Pelt",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["smallgamepeltperfect"] = {
    itemtype = "hunting",
    singular = "Perfect Small Game Pelt",
    multiple = "Perfect Small Game Pelts",
    weight = 1.0,
    description = "Perfect Small Game Pelt",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["mountainlionmeat"] = {
    itemtype = "hunting",
    singular = "Mountain Lion Meat",
    multiple = "Mountain Lion Meats",
    weight = 1.0,
    description = "Meat from a Mountain Lion",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["mountainlionpelt"] = {
    itemtype = "hunting",
    singular = "Mountain Lion Pelt",
    multiple = "Mountain Lion Pelts",
    weight = 1.0,
    description = "Mountain Lion Pelt",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["mountainlionpeltpoor"] = {
    itemtype = "hunting",
    singular = "Poor Mountain Lion Pelt",
    multiple = "Poor Mountain Lion Pelts",
    weight = 1.0,
    description = "Poor Mountain Lion Pelt",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["mountainlionpeltperfect"] = {
    itemtype = "hunting",
    singular = "Perfect Mountain Lion Pelt",
    multiple = "Perfect Mountain Lion Pelts",
    weight = 1.0,
    description = "Perfect Mountain Lion Pelt",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["sharkmeat"] = {
    itemtype = "hunting",
    singular = "Shark Meat",
    multiple = "Shark Meats",
    weight = 1.0,
    description = "Meat from a Shark",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["sharkpelt"] = {
    itemtype = "hunting",
    singular = "Shark Pelt",
    multiple = "Shark Pelts",
    weight = 1.0,
    description = "Shark Pelt",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["sharkpeltpoor"] = {
    itemtype = "hunting",
    singular = "Poor Shark Pelt",
    multiple = "Poor Shark Pelts",
    weight = 1.0,
    description = "Poor Shark Pelt",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["sharkpeltperfect"] = {
    itemtype = "hunting",
    singular = "Perfect Shark Pelt",
    multiple = "Perfect Shark Pelts",
    weight = 1.0,
    description = "Perfect Shark Pelt",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["feather"] = {
    itemtype = "junk",
    singular = "Feather",
    multiple = "Feathers",
    weight = 0.01,
    description = "A feather from an animal with wings.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["featherraggedy"] = {
    itemtype = "junk",
    singular = "Raggedy Feather",
    multiple = "Raggedy Feathers",
    weight = 0.01,
    description = "A raggedy feather from an animal with wings.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["featherperfect"] = {
    itemtype = "junk",
    singular = "Fine Feather",
    multiple = "Fine Feathers",
    weight = 0.01,
    description = "A fine feather from an animal with wings.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

-- HUNTING ITEMS END

-- CRAFT ITEMS START

itemdefs["ice"] = {
    itemtype = "food",
    singular = "Ice",
    multiple = "Ice",
    weight = 0.25,
    description = "Ice cold baby",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["icebeer"] = {
    itemtype = "drink",
    singular = "Bottle of ice cold Beer",
    multiple = "Bottles of ice cold Beer",
    weight = 0.8,
    description = "A bottle of ice cold beer. Don't drink and drive!",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-civ"]:SetAlcoholLevel(5)
    end
}

itemdefs["whiskey"] = {
    itemtype = "drink",
    singular = "Bottle of whiskey",
    multiple = "Bottles of whiskey",
    weight = 0.8,
    description = "A bottle of whiskey. Don't drink and drive!",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-civ"]:SetAlcoholLevel(5)
    end
}

itemdefs["whiskeyrocks"] = {
    itemtype = "drink",
    singular = "Whiskey on the rocks",
    multiple = "Whiskey on the rocks",
    weight = 0.8,
    description = "Classic. Don't drink and drive!",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-nutrition"]:Drink("whiskyGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(5)
    end
}

itemdefs["gin"] = {
    itemtype = "drink",
    singular = "Bottle of gin",
    multiple = "Bottles of gin",
    weight = 0.8,
    description = "A bottle of gin. Don't drink and drive!",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 12,
    onUse = function(uid)
        UseChargeItem("gin", uid)
    end
}

itemdefs["ginandjuice"] = {
    itemtype = "drink",
    singular = "Gin & Juice",
    multiple = "Gin & Juice",
    weight = 0.8,
    description = "A cup of gin mixed with juice.",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-civ"]:SetAlcoholLevel(8)
    end
}

itemdefs["tequila"] = {
    itemtype = "drink",
    singular = "Bottle of Tequila",
    multiple = "Bottles of Tequila",
    weight = 0.8,
    description = "A bottle of tequila. Don't drink and drive!",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-civ"]:SetAlcoholLevel(10)
    end
}

itemdefs["margarita"] = {
    itemtype = "drink",
    singular = "Margarita",
    multiple = "Margaritas",
    weight = 0.8,
    description = "A glass of margarita.",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-civ"]:SetAlcoholLevel(8)
    end
}

itemdefs["vermouth"] = {
    itemtype = "drink",
    singular = "Bottle of Vermouth",
    multiple = "Bottles of Vermouth",
    weight = 0.8,
    description = "A bottle of vermouth. Don't drink and drive!",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 12,
    onUse = function(uid)
        UseChargeItem("vermouth", uid)
    end
}

itemdefs["martini"] = {
    itemtype = "drink",
    singular = "Martini",
    multiple = "Martinis",
    weight = 0.8,
    description = "A glass of martini.",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-civ"]:SetAlcoholLevel(8)
    end
}

itemdefs["bloodymary"] = {
    itemtype = "drink",
    singular = "Bloody Mary",
    multiple = "Bloody Mary",
    weight = 0.8,
    description = "A glass bloody mary.",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-civ"]:SetAlcoholLevel(8)
    end
}

itemdefs["redwine"] = {
    itemtype = "drink",
    singular = "Bottle of Red Wine",
    multiple = "Bottles of Red Wine",
    weight = 0.8,
    description = "A bottle of red wine. Don't drink and drive!",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 12,
    onUse = function(uid)
        UseChargeItem("redwine", uid)
    end
}

itemdefs["whitewine"] = {
    itemtype = "drink",
    singular = "Bottle of White Wine",
    multiple = "Bottles of White Wine",
    weight = 0.8,
    description = "A bottle of white wine. Don't drink and drive!",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 12,
    onUse = function(uid)
        UseChargeItem("whitewine", uid)
    end
}

itemdefs["rum"] = {
    itemtype = "drink",
    singular = "Bottle of Rum",
    multiple = "Bottles of Rum",
    weight = 0.8,
    description = "A bottle of rum. Don't drink and drive!",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 12,
    onUse = function(uid)
        UseChargeItem("rum", uid)
    end
}

itemdefs["rumandcoke"] = {
    itemtype = "drink",
    singular = "Rum & Coke",
    multiple = "Rum & Coke",
    weight = 0.8,
    description = "A glass of rum mixed with cola.",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-nutrition"]:Drink("whiskyGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(8)
    end
}

itemdefs["appletini"] = {
    itemtype = "drink",
    singular = "Appletini",
    multiple = "Appletini",
    weight = 0.8,
    description = "A glass appletini.",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-nutrition"]:Drink("Appletini", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(8)
    end
}

itemdefs["longisland"] = {
    itemtype = "drink",
    singular = "Long Island",
    multiple = "Long Island",
    weight = 0.8,
    description = "A glass long island.",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-civ"]:SetAlcoholLevel(8)
    end
}

itemdefs["bun"] = {
    itemtype = "food",
    singular = "Plain old bun",
    multiple = "Plain old buns",
    weight = 0.02,
    description = "A Plain old bun, not tastey on its own!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Bread", 2, 0)
    end
}

itemdefs["beefpatty"] = {
    itemtype = "food",
    singular = "Beef patty",
    multiple = "Beef patties",
    weight = 0.02,
    description = "A Juicy beef patty, find some buns to go with it!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Hamburger", 15, 0)
    end
}

itemdefs["lettuce"] = {
    itemtype = "food",
    singular = "Lettuce",
    multiple = "Lettuces",
    weight = 0.02,
    description = "Eat your veges!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Bread", 5, 0)
    end
}

itemdefs["americancheeseslice"] = {
    itemtype = "food",
    singular = "American Cheese Slice",
    multiple = "American Cheese Slices",
    weight = 0.02,
    description = "Say cheese.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Bread", 5, 0)
    end
}

itemdefs["cheddarcheeseslice"] = {
    itemtype = "food",
    singular = "Cheddar Cheese Slice",
    multiple = "Cheddar Cheese Slices",
    weight = 0.02,
    description = "Say cheese.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Bread", 5, 0)
    end
}

itemdefs["swisscheeseslice"] = {
    itemtype = "food",
    singular = "Swiss Cheese Slice",
    multiple = "Swiss Cheese Slices",
    weight = 0.02,
    description = "Say cheese.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Bread", 5, 0)
    end
}

itemdefs["vegancheeseslice"] = {
    itemtype = "food",
    singular = "Vegan Cheese Slice",
    multiple = "Vegan Cheese Slices",
    weight = 0.02,
    description = "Say cheese.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Bread", 5, 0)
    end
}

itemdefs["onion"] = {
    itemtype = "food",
    singular = "Onion",
    multiple = "Onions",
    weight = 0.02,
    description = "I'm not crying!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Bread", 5, 0)
    end
}

itemdefs["avocado"] = {
    itemtype = "food",
    singular = "Avocado",
    multiple = "Avocados",
    weight = 0.02,
    description = "Mush!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Bread", 5, 0)
    end
}

itemdefs["garlic"] = {
    itemtype = "food",
    singular = "Garlic",
    multiple = "Garlics",
    weight = 0.02,
    description = "Vampire repelant!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Bread", 2, 0)
    end
}

itemdefs["hotdogbun"] = {
    itemtype = "food",
    singular = "Hot dog bun",
    multiple = "Hot dog buns",
    weight = 0.02,
    description = "A long bun used for hotdogs.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Bread", 2, 0)
    end
}

itemdefs["hotdogweiner"] = {
    itemtype = "food",
    singular = "Hot dog weiner",
    multiple = "Hot dog weiners",
    weight = 0.02,
    description = "A weiner used for hotdogs.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Bread", 25, -5)
    end
}

itemdefs["hotdog"] = {
    itemtype = "food",
    singular = "Hot Dog",
    multiple = "Hot Dogs",
    weight = 0.02,
    description = "A hot dog bun with a weiner in the middle.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Hotdog", 50, -10)
    end
}

itemdefs["sashimi"] = {
    itemtype = "food",
    singular = "Sashimi",
    multiple = "Sashimi",
    weight = 0.02,
    description = "Raw fish sliced into pieces.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Bread", 40, -8)
    end
}

itemdefs["rice"] = {
    itemtype = "food",
    singular = "Rice",
    multiple = "Rice",
    weight = 1.0,
    description = "Rice, needs to be cooked first.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["nigiri"] = {
    itemtype = "food",
    singular = "Nigiri",
    multiple = "Nigiri",
    weight = 1.0,
    description = "Rawfish on top of rice.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Bread", 80, -10)
    end
}

itemdefs["mayonnaise"] = {
    itemtype = "food",
    singular = "Mayonnaise",
    multiple = "Mayonnaise",
    weight = 0.02,
    description = "Thick white mayo.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["ketchup"] = {
    itemtype = "food",
    singular = "Ketchup",
    multiple = "Ketchup",
    weight = 0.02,
    description = "Red sauce, looks like blood.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["mustard"] = {
    itemtype = "food",
    singular = "Mustard",
    multiple = "Mustard",
    weight = 0.02,
    description = "Yellow sauce, for hotdog?",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["sugar"] = {
    itemtype = "food",
    singular = "Sugar",
    multiple = "Sugar",
    weight = 0.05,
    description = "Makes things sweet?",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["celery"] = {
    itemtype = "food",
    singular = "Celery",
    multiple = "Celery",
    weight = 0.02,
    description = "Healthy crunch.",
    canUse = false,
    canStack = true,
    onUse = function()
        TriggerEvent("client.eat", 6, 0)
    end
}

itemdefs["olives"] = {
    itemtype = "food",
    singular = "Olives",
    multiple = "Olives",
    weight = 0.02,
    description = "Ollie Olives.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Bread", 5, 0)
    end
}

itemdefs["pickle"] = {
    itemtype = "food",
    singular = "Pickle",
    multiple = "Pickles",
    weight = 0.02,
    description = "Eww pickle.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Bread", 5, 0)
    end
}

itemdefs["potato"] = {
    itemtype = "food",
    singular = "Potato",
    multiple = "Potatos",
    weight = 0.02,
    description = "Potato Potatoe.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Bread", 5, 0)
    end
}

itemdefs["fries"] = {
    itemtype = "food",
    singular = "Fries",
    multiple = "Fries",
    weight = 0.02,
    description = "Homemade Fries.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Chips", 25, -10)
    end
}

itemdefs["tomato"] = {
    itemtype = "food",
    singular = "Tomato",
    multiple = "Tomatoes",
    weight = 0.02,
    canUse = true,
    canStack = true,
    reusable = false,
    closeInventoryOnUsage = true,
    description = "Fruit or vege?.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Apple", 4, 4)
    end
}

itemdefs["tomatoslices"] = {
    itemtype = "food",
    singular = "Tomato Slices",
    multiple = "Tomato Slices",
    weight = 0.02,
    description = "Fruit or vege?.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Bread", 5, 0)
    end
}

itemdefs["rawtofu"] = {
    itemtype = "food",
    singular = "Raw Tofu",
    multiple = "Raw Tofu",
    weight = 0.02,
    description = "Made from beans.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Bread", 5, 0)
    end
}

itemdefs["friedtofu"] = {
    itemtype = "food",
    singular = "Fried Tofu",
    multiple = "Fried Tofu",
    weight = 0.02,
    description = "Made from beans.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Bread", 8, 0)
    end
}

itemdefs["cheeseburger"] = {
    itemtype = "food",
    singular = "Cheeseburger",
    multiple = "Cheeseburgers",
    weight = 0.02,
    description = "Yummy cheeseburger!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Hamburger", 200, -10)
    end
}

itemdefs["fishandchips"] = {
    itemtype = "food",
    singular = "Fish and Chips",
    multiple = "Fish and Chips",
    weight = 0.25,
    description = "Fish and Chips!",
    canUse = true,
    canStack = true,
    onUse = function()
        TriggerEvent("client.eat", 200, -15)
    end
}

itemdefs["goldbar"] = {
    itemtype = "industry",
    singular = "Gold Bar",
    multiple = "Gold Bars",
    weight = 1.0,
    description = "A bar of gold!",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["silverbar"] = {
    itemtype = "industry",
    singular = "Silver Bar",
    multiple = "Silver Bars",
    weight = 1.0,
    description = "A bar of silver!",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["steelbar"] = {
    itemtype = "industry",
    singular = "Steel Bar",
    multiple = "Steel Bars",
    weight = 1.0,
    description = "A bar of steel!",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["copper"] = {
    itemtype = "industry",
    singular = "Copper Bar",
    multiple = "Copper Bars",
    weight = 1.0,
    description = "A bar of copper!",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["gravel"] = {
    itemtype = "rock",
    singular = "Gravel",
    multiple = "Gravel",
    weight = 5.0,
    description = "Many uses in construction.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["bandage"] = {
    itemtype = "tool",
    singular = "Bandage",
    multiple = "Bandages",
    weight = 0.02,
    description = "I'm a mummy!",
    canUse = true,
    canStack = true,
    onUse = function()
        TriggerEvent("usebandage")
    end
}

itemdefs["tortillashell"] = {
    itemtype = "food",
    singular = "Tortilla Shell",
    multiple = "Tortilla Shells",
    weight = 0.02,
    description = "Tortilla shell for tacos.",
    canUse = false,
    canStack = true,
    onUse = function()
        TriggerEvent("client.eat", 5, 0)
    end
}

itemdefs["softtortilla"] = {
    itemtype = "food",
    singular = "Soft Tortilla",
    multiple = "Soft Tortillas",
    weight = 0.02,
    description = "Soft tortilla for burritos.",
    canUse = false,
    canStack = true,
    onUse = function()
        TriggerEvent("client.eat", 5, 0)
    end
}

itemdefs["tortillachips"] = {
    itemtype = "food",
    singular = "Tortilla Chips",
    multiple = "Tortilla Chips",
    weight = 0.02,
    description = "Would go great with some guacamole.",
    canUse = false,
    canStack = true,
    onUse = function()
        TriggerEvent("client.eat", 5, 0)
    end
}

itemdefs["chipsandguacamole"] = {
    itemtype = "food",
    singular = "Chips and Guacamole",
    multiple = "Chips and Guacamoles",
    weight = 0.02,
    description = "Tortilla Chips with a Guacamole side.",
    canUse = false,
    canStack = true,
    onUse = function()
        TriggerEvent("client.eat", 15, -5)
    end
}

itemdefs["rawchicken"] = {
    itemtype = "food",
    singular = "Raw Chicken",
    multiple = "Raw Chickens",
    weight = 0.02,
    description = "Cook before eating!",
    canUse = false,
    canStack = true,
    onUse = function()
        TriggerEvent("client.eat", -50, 0)
    end
}

itemdefs["cookedchicken"] = {
    itemtype = "food",
    singular = "Cooked Chicken",
    multiple = "Cooked Chickens",
    weight = 0.02,
    description = "Juicy cooked chicken",
    canUse = true,
    canStack = true,
    onUse = function()
        TriggerEvent("client.eat", 100, -50)
    end
}

itemdefs["chickenstrips"] = {
    itemtype = "food",
    singular = "Chicken strips",
    multiple = "Chicken strips",
    weight = 0.02,
    description = "Chicken strips",
    canUse = true,
    canStack = true,
    onUse = function()
        TriggerEvent("client.eat", 75, -20)
    end
}

itemdefs["rawbeef"] = {
    itemtype = "food",
    singular = "Raw Beef",
    multiple = "Raw Beef",
    weight = 0.02,
    description = "Cook before eating!",
    canUse = true,
    canStack = true,
    onUse = function()
        TriggerEvent("client.eat", -50, 0)
    end
}

itemdefs["cookedbeef"] = {
    itemtype = "food",
    singular = "Cooked Beef",
    multiple = "Cooked Beef",
    weight = 0.02,
    description = "Juicy cooked beef",
    canUse = true,
    canStack = true,
    onUse = function()
        TriggerEvent("client.eat", 100, -50)
    end
}

itemdefs["beefstrips"] = {
    itemtype = "food",
    singular = "Beef strips",
    multiple = "Beef strips",
    weight = 0.02,
    description = "Beef strips",
    canUse = true,
    canStack = true,
    onUse = function()
        TriggerEvent("client.eat", 75, -20)
    end
}

itemdefs["rawbaconstrips"] = {
    itemtype = "food",
    singular = "Raw Bacon Strips",
    multiple = "Raw Bacon Strips",
    weight = 0.02,
    description = "Cook before eating!",
    canUse = true,
    canStack = true,
    onUse = function()
        TriggerEvent("client.eat", -50, 0)
    end
}

itemdefs["cookedbaconstrips"] = {
    itemtype = "food",
    singular = "Cooked Bacon Strips",
    multiple = "Cooked Bacon Strips",
    weight = 0.02,
    description = "Juicy cooked bacon",
    canUse = true,
    canStack = true,
    onUse = function()
        TriggerEvent("client.eat", 100, -50)
    end
}

itemdefs["rawfishfillets"] = {
    itemtype = "food",
    singular = "Raw Fish Fillets",
    multiple = "Raw Fish Fillets",
    weight = 0.10,
    description = "Cook before eating!",
    canUse = true,
    canStack = true,
    onUse = function()
        TriggerEvent("client.eat", 70, -20)
    end
}

itemdefs["friedfishfillets"] = {
    itemtype = "food",
    singular = "Fried Fish Fillets",
    multiple = "Fried Fish Fillets",
    weight = 0.18,
    description = "Fried fish! Goes nice with chips",
    canUse = true,
    canStack = true,
    onUse = function()
        TriggerEvent("client.eat", 100, -50)
    end
}

itemdefs["sourcream"] = {
    itemtype = "food",
    singular = "Sour Cream",
    multiple = "Sour Cream",
    weight = 0.02,
    description = "Cream that's sour!",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["shreddedcheese"] = {
    itemtype = "food",
    singular = "Shredded Cheese",
    multiple = "Shredded Cheese",
    weight = 0.02,
    description = "Cheese in shreads",
    canUse = true,
    canStack = true,
    onUse = function()
        TriggerEvent("client.eat", 5, 0)
    end
}

itemdefs["chickentaco"] = {
    itemtype = "food",
    singular = "Chicken Taco",
    multiple = "Chicken Tacos",
    weight = 0.75,
    description = "Time to get your Taco on!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Taco", 85, -5)
    end
}

itemdefs["beeftaco"] = {
    itemtype = "food",
    singular = "Beef Taco",
    multiple = "Beef Tacos",
    weight = 0.75,
    description = "Time to get your Taco on!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Taco", 85, -5)
    end
}

itemdefs["fishtaco"] = {
    itemtype = "food",
    singular = "Fish Taco",
    multiple = "Fish Tacos",
    weight = 0.75,
    description = "Time to get your Taco on!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Taco", 85, -5)
    end
}

itemdefs["vegantaco"] = {
    itemtype = "food",
    singular = "Vegan Taco",
    multiple = "Vegan Tacos",
    weight = 0.75,
    description = "Time to get your Taco on!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Taco", 85, -5)
    end
}

itemdefs["beefburrito"] = {
    itemtype = "food",
    singular = "Beef Burrito",
    multiple = "Beef Burritos",
    weight = 0.75,
    description = "'Soft' Taco!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Burrito", 85, -5)
    end
}

itemdefs["chickenburrito"] = {
    itemtype = "food",
    singular = "Chicken Burrito",
    multiple = "Chicken Burritos",
    weight = 0.75,
    description = "'Soft' Taco!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Burrito", 85, -5)
    end
}

itemdefs["fishburrito"] = {
    itemtype = "food",
    singular = "Fish Burrito",
    multiple = "Fish Burritos",
    weight = 0.75,
    description = "'Soft' Taco!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Burrito", 85, -5)
    end
}

itemdefs["veganburrito"] = {
    itemtype = "food",
    singular = "Vegan Burrito",
    multiple = "Vegan Burritos",
    weight = 0.75,
    description = "'Soft' Taco!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Burrito", 85, -5)
    end
}

itemdefs["apple"] = {
    itemtype = "food",
    singular = "Apple",
    multiple = "Apples",
    weight = 0.1,
    description = "An apple a day keeps the dctor away.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Apple", 4, 4)
    end
}

itemdefs["orange"] = {
    itemtype = "food",
    singular = "Orange",
    multiple = "Oranges",
    weight = 0.1,
    description = "Full of vitamin C!",
    canUse = true,
    canStack = true,
    reusable = false,
    closeInventoryOnUsage = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Orange", 4, 4)
    end
}

itemdefs["lemon"] = {
    itemtype = "food",
    singular = "Lemon",
    multiple = "Lemons",
    weight = 0.1,
    description = "If life gives you lemons.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Lemon", 4, 4)
    end
}

itemdefs["lime"] = {
    itemtype = "food",
    singular = "Lime",
    multiple = "Limes",
    weight = 0.1,
    description = "Fresh and sour.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Lime", 4, 4)
    end
}

itemdefs["banana"] = {
    itemtype = "food",
    singular = "Banana",
    multiple = "Bananas",
    weight = 0.1,
    description = "Na na na na.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Banana", 4, 4)
    end
}

itemdefs["carrot"] = {
    itemtype = "food",
    singular = "Carrot",
    multiple = "Carrots",
    weight = 0.1,
    description = "Eat more for better eyesight.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Carrot", 4, 4)
    end
}

itemdefs["grapes"] = {
    itemtype = "food",
    singular = "Bunch of Grapes",
    multiple = "Bunch of Grapes",
    weight = 0.1,
    description = "Juicey grapes.",
    canUse = true,
    canStack = true,
    onUse = function()
        TriggerEvent("client.eat", 8, 8)
    end
}

itemdefs["applejuice"] = {
    itemtype = "drink",
    singular = "Apple Juice",
    multiple = "Apple Juice",
    weight = 0.1,
    description = "Fresh apple juice.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("Juice", 0, 85)
    end
}

itemdefs["carrotjuice"] = {
    itemtype = "drink",
    singular = "Carrot Juice",
    multiple = "Carrot Juice",
    weight = 0.1,
    description = "Healthy alternative.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("Juice", 0, 85)
    end
}

itemdefs["grapejuice"] = {
    itemtype = "drink",
    singular = "Grape Juice",
    multiple = "Grape Juice",
    weight = 0.1,
    description = "Sweet Grape Juice.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("Juice", 0, 85)
    end
}

itemdefs["orangejuice"] = {
    itemtype = "drink",
    singular = "Orange Juice",
    multiple = "Orange Juice",
    weight = 0.1,
    description = "Fresh OJ.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("Juice", 0, 85)
    end
}

itemdefs["tomatojuice"] = {
    itemtype = "drink",
    singular = "Tomato Juice",
    multiple = "Tomato Juice",
    weight = 0.1,
    description = "Fresh Tomato Juice.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("Juice", 0, 85)
    end
}

itemdefs["lemonade"] = {
    itemtype = "drink",
    singular = "Lemonade",
    multiple = "Lemonade",
    weight = 0.1,
    description = "Sweet and refreshing.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("Juice", 0, 150)
    end
}

itemdefs["rollingpapers"] = {
    itemtype = "tool",
    singular = "Rolling Papers",
    multiple = "Rolling Papers",
    weight = 0.0005,
    description = "Rolling Papers.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["filter"] = {
    itemtype = "tool",
    singular = "Filter",
    multiple = "Filters",
    weight = 0.0002,
    description = "A filter.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["loosemarijuana"] = {
    itemtype = "drug",
    singular = "Loose Marijuana",
    multiple = "Loose Marijuana",
    weight = 0.00044,
    description = "Loose Marijuana.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["sotwrollingpapers"] = {
    itemtype = "SOTW",
    singular = "SOTW Rolling Papers",
    multiple = "SOTW Rolling Papers",
    weight = 0.0005,
    description = "SOTW Rolling Papers.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["bm_chailatte"] = {
    itemtype = "Bean Machine",
    singular = "Chai Latte - Bean Machine",
    multiple = "Chai Lattes - Bean Machine",
    weight = 0.8,
    description = "A cup of Chai Latte.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("Coffee", 0, 70)
    end
}

itemdefs["chaiteabag"] = {
    itemtype = "Bean Machine",
    singular = "Chai Tea Bag",
    multiple = "Chai Tea Bags",
    weight = 0.025,
    description = "Chai Tea Bag.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["cartonofmilk"] = {
    itemtype = "drink",
    singular = "Carton of Milk",
    multiple = "Cartons of Milk",
    weight = 0.4,
    description = "At least it's not in a bag.",
    canUse = false,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("Milk", 10, 45)
    end
}

itemdefs["bm_applepie"] = {
    itemtype = "Bean Machine",
    singular = "Apple Pie - Bean Machine",
    multiple = "Apple Pie - Bean Machine",
    weight = 0.75,
    description = "Tasty apple pie",
    remainingDesc = "Remaining Slices",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 6,
    onUse = function(uid)
        UseChargeItem("bm_applepie", uid)
    end
}

itemdefs["bm_sliceofapplepie"] = {
    itemtype = "Bean Machine",
    singular = "Slice of Apple Pie - Bean Machine",
    multiple = "Slices of Apple Pie - Bean Machine",
    weight = 0.188,
    description = "Slice of apple pie.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Slice of velvet cake", 80, -5)
    end
}

itemdefs["piecrust"] = {
    itemtype = "misc",
    singular = "Pie Crust",
    multiple = "Pie Crust",
    weight = 0.05,
    description = "Used for making pies.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["bm_carrotcake"] = {
    itemtype = "Bean Machine",
    singular = "Carrot Cake - Bean Machine",
    multiple = "Carrot Cake - Bean Machine",
    weight = 0.75,
    description = "Tasty carrot cake.",
    remainingDesc = "Remaining Slices",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 6,
    onUse = function(uid)
        UseChargeItem("bm_carrotcake", uid)
    end
}

itemdefs["bm_sliceofcarrotcake"] = {
    itemtype = "Bean Machine",
    singular = "Slice of Carrot Cake - Bean Machine",
    multiple = "Slices of Carrot Cake - Bean Machine",
    weight = 0.188,
    description = "Slice of carrot cake.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Slice of carrot cake", 80, -5)
    end
}

itemdefs["bm_redvelvetcake"] = {
    itemtype = "Bean Machine",
    singular = "Red Velvet Cake - Bean Machine",
    multiple = "Red Velvet Cake - Bean Machine",
    weight = 0.75,
    description = "Tasty red velvet cake",
    remainingDesc = "Remaining Slices",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 6,
    onUse = function(uid)
        UseChargeItem("bm_redvelvetcake", uid)
    end
}

itemdefs["bm_sliceofredvelvetcake"] = {
    itemtype = "Bean Machine",
    singular = "Slice of Red Velvet Cake - Bean Machine",
    multiple = "Slices of Red Velvet Cake - Bean Machine",
    weight = 0.188,
    description = "Slice of red velvet cake.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Slice of velvet cake", 80, -5)
    end
}

itemdefs["bm_strawberrycake"] = {
    itemtype = "Bean Machine",
    singular = "Strawberry Cake - Bean Machine",
    multiple = "Strawberry Cakes - Bean Machine",
    weight = 0.75,
    description = "Tasty strawberry cake",
    remainingDesc = "Remaining Slices",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 6,
    onUse = function(uid)
        UseChargeItem("bm_strawberrycake", uid)
    end
}

itemdefs["bm_sliceofstrawberrycake"] = {
    itemtype = "Bean Machine",
    singular = "Slice of Strawberry Cake - Bean Machine",
    multiple = "Slices of Strawberry Cake - Bean Machine",
    weight = 0.188,
    description = "Slice of strawberry cake.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Slice of strawberry cake", 80, -5)
    end
}

itemdefs["brownie"] = {
    itemtype = "Last Train",
    singular = "Chocolate Brownie",
    multiple = "Chocolate Brownies",
    weight = 0.75,
    description = "Mmmm brownie",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Eat("Brownie", 35, -5)
    end
}

itemdefs["cakemix"] = {
    itemtype = "misc",
    singular = "Cake Mix",
    multiple = "Cake Mix",
    weight = 0.075,
    description = "Mixture used for baking cake.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["icing"] = {
    itemtype = "misc",
    singular = "Icing",
    multiple = "Icing",
    weight = 0.05,
    description = "Icing to make the cake pretty.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["cartonofeggs"] = {
    itemtype = "misc",
    singular = "Carton of Eggs",
    multiple = "Carton of Eggs",
    weight = 0.05,
    description = "Half of a dozen eggs",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 6,
    onUse = function(uid)
        --UseChargeItem("cartonofeggs", uid)
    end
}

itemdefs["egg"] = {
    itemtype = "drink",
    singular = "Egg",
    multiple = "Eggs",
    weight = 0.008,
    description = "What came first, Chicken or Egg?",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["cookedboarmeat"] = {
    itemtype = "food",
    singular = "Cooked Boar Meat",
    multiple = "Cooked Boar Meats",
    weight = 1.0,
    description = "Cooked Meat from a Boar",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Cooked Boar Meat", 85, -5)
    end
}

itemdefs["cookedgame"] = {
    itemtype = "food",
    singular = "Cooked Game Meat",
    multiple = "Cooked Game Meats",
    weight = 1.0,
    description = "Cooked Small Game Meat",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Cooked Game Meat", 85, -5)
    end
}

itemdefs["cookedvenison"] = {
    itemtype = "food",
    singular = "Cooked Venison",
    multiple = "Cooked Venison",
    weight = 1.0,
    description = "Cooked Venison",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Cooked Venison", 85, -5)
    end
}

itemdefs["hunterschicken"] = {
    itemtype = "food",
    singular = "Hunter's Chicken",
    multiple = "Hunter's Chicken",
    weight = 0.02,
    description = "Delicious food from Hunter's Lodge",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Hunter's Chicken", 80, -5)
    end
}

itemdefs["bbqsauce"] = {
    itemtype = "misc",
    singular = "BBQ Sauce",
    multiple = "BBQ Sauce",
    weight = 0.02,
    description = "BBQ Sauce",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["rangerjerky"] = {
    itemtype = "food",
    singular = "Ranger Jerky",
    multiple = "Ranger Jerky",
    weight = 0.3,
    description = "Ranger jerky, not jerking around!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Ranger Jerky", 45, -2)
    end
}

itemdefs["rangerfuelcoffee"] = {
    itemtype = "drink",
    singular = "Ranger Fuel Coffee",
    multiple = "Ranger Fuel Coffees",
    weight = 0.8,
    description = "Ranger coffee, for rangers.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("Coffee", -2, 45)
    end
}

itemdefs["coffeebeans"] = {
    itemtype = "misc",
    singular = "Coffee Beans",
    multiple = "Coffee Beans",
    weight = 0.002,
    description = "Beans for coffee.",
    canuse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["bs_moneyshotmeal"] = {
    itemtype = "Burger Shot",
    singular = "Burger Shot Money Shot Meal",
    multiple = "Burger Shot Money Shot Meals",
    weight = 0.02,
    description = "Show me the money!",
    canUse = true,
    canStack = true,
    reusable = true,
    isChargeItem = true,
    maxCharge = 1,
    onUse = function(uid)
        exports["soe-nutrition"]:Eat("Hamburger", 100, 50)
        UseChargeItem("bs_moneyshotmeal", uid)
    end
}

itemdefs["bs_bleedermeal"] = {
    itemtype = "Burger Shot",
    singular = "Burger Shot Bleeder Meal",
    multiple = "Burger Shot Bleeder Meals",
    weight = 0.02,
    description = "It's just ketchup!",
    canUse = true,
    canStack = true,
    reusable = true,
    isChargeItem = true,
    maxCharge = 1,
    onUse = function(uid)
        exports["soe-nutrition"]:Eat("Hamburger", 100, 50)
        UseChargeItem("bs_bleedermeal", uid)
    end
}

itemdefs["bs_meatlessmeal"] = {
    itemtype = "Burger Shot",
    singular = "Burger Shot Meatless Meal",
    multiple = "Burger Shot Meatless Meals",
    weight = 0.02,
    description = "Don't worry, it just tastes like meat!",
    canUse = true,
    canStack = true,
    reusable = true,
    isChargeItem = true,
    maxCharge = 1,
    onUse = function(uid)
        exports["soe-nutrition"]:Eat("Hamburger", 100, 50)
        UseChargeItem("bs_meatlessmeal", uid)
    end
}

itemdefs["bs_torpedomeal"] = {
    itemtype = "Burger Shot",
    singular = "Burger Shot Torpedo Meal",
    multiple = "Burger Shot Torpedo Meals",
    weight = 0.02,
    description = "Torpedo away!",
    canUse = true,
    canStack = true,
    reusable = true,
    isChargeItem = true,
    maxCharge = 1,
    onUse = function(uid)
        exports["soe-nutrition"]:Eat("Hamburger", 100, 50)
        UseChargeItem("bs_torpedomeal", uid)
    end
}

itemdefs["bs_6lbburger"] = {
    itemtype = "Burger Shot",
    singular = "Burger Shot 6 Lb Burger",
    multiple = "Burger Shot 6 Lb Burgers",
    weight = 0.02,
    description = "Heart stopper!!",
    canUse = true,
    canStack = true,
    reusable = true,
    isChargeItem = true,
    maxCharge = 1,
    onUse = function(uid)
        exports["soe-nutrition"]:Eat("Hamburger", 200, -50)
        UseChargeItem("bs_6lbburger", uid)
    end
}

itemdefs["bs_fries"] = {
    itemtype = "Burger Shot",
    singular = "Burger Shot Fries",
    multiple = "Burger Shot Fries",
    weight = 0.02,
    description = "Yummy fries!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Hamburger", 30, -5)
    end
}

itemdefs["bs_toy_alien"] = {
    itemtype = "bs_toy_object",
    singular = "Alien Toy - Burgershot",
    multiple = "Alien Toys - Burgershot",
    weight = 0.002,
    description = "Alieeeeens!",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        if not exports["soe-properties"]:GetCurrentProperty() then
            PlaceObject("vw_prop_vw_colle_alien", 0.0)
        else
            TriggerEvent("Properties:Client:PrepFurniturePlacement", "vw_prop_vw_colle_alien", 0.0)
        end
    end
}

itemdefs["bs_toy_bubblegum"] = {
    itemtype = "bs_toy_object",
    singular = "Princess Robot Bubblegum Toy - Burgershot",
    multiple = "Princess Robot Bubblegum Toys - Burgershot",
    weight = 0.002,
    description = "Hello princess!",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        if not exports["soe-properties"]:GetCurrentProperty() then
            PlaceObject("vw_prop_vw_colle_prbubble", 0.0)
        else
            TriggerEvent("Properties:Client:PrepFurniturePlacement", "vw_prop_vw_colle_prbubble", 0.0)
        end
    end
}

itemdefs["bs_toy_monkey"] = {
    itemtype = "bs_toy_object",
    singular = "Space Monkey Toy - Burgershot",
    multiple = "Space Monkey Toys - Burgershot",
    weight = 0.002,
    description = "One day, they will rule the world!",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        if not exports["soe-properties"]:GetCurrentProperty() then
            PlaceObject("vw_prop_vw_colle_pogo", 0.0)
        else
            TriggerEvent("Properties:Client:PrepFurniturePlacement", "vw_prop_vw_colle_pogo", 0.0)
        end
    end
}

itemdefs["bs_toy_sasquatch"] = {
    itemtype = "bs_toy_object",
    singular = "Bigfoot Toy - Burgershot",
    multiple = "Bigfoot Toys - Burgershot",
    weight = 0.002,
    description = "They do exist!",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        if not exports["soe-properties"]:GetCurrentProperty() then
            PlaceObject("vw_prop_vw_colle_sasquatch", 0.0)
        else
            TriggerEvent("Properties:Client:PrepFurniturePlacement", "vw_prop_vw_colle_sasquatch", 0.0)
        end
    end
}

itemdefs["bs_toy_spaceman"] = {
    itemtype = "bs_toy_object",
    singular = "Space Ranger Toy - Burgershot",
    multiple = "Space Ranger Toys - Burgershot",
    weight = 0.002,
    description = "To infinity!",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        if not exports["soe-properties"]:GetCurrentProperty() then
            PlaceObject("vw_prop_vw_colle_rsrcomm", 0.0)
        else
            TriggerEvent("Properties:Client:PrepFurniturePlacement", "vw_prop_vw_colle_rsrcomm", 0.0)
        end
    end
}

itemdefs["bs_toy_spaceman2"] = {
    itemtype = "bs_toy_object",
    singular = "Space Ranger 2 Toy - Burgershot",
    multiple = "Space Ranger 2 Toys - Burgershot",
    weight = 0.002,
    description = "And beyond!",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        if not exports["soe-properties"]:GetCurrentProperty() then
            PlaceObject("vw_prop_vw_colle_rsrgeneric", 0.0)
        else
            TriggerEvent("Properties:Client:PrepFurniturePlacement", "vw_prop_vw_colle_rsrgeneric", 0.0)
        end
    end
}

itemdefs["bs_toy_superhero"] = {
    itemtype = "bs_toy_object",
    singular = "Impotent Rage Toy - Burgershot",
    multiple = "Impotent Rage Toys - Burgershot",
    weight = 0.002,
    description = "Rageeeee!",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        if not exports["soe-properties"]:GetCurrentProperty() then
            PlaceObject("vw_prop_vw_colle_imporage", 0.0)
        else
            TriggerEvent("Properties:Client:PrepFurniturePlacement", "vw_prop_vw_colle_imporage", 0.0)
        end
    end
}

itemdefs["bs_toy_wolf"] = {
    itemtype = "bs_toy_object",
    singular = "The Beast Toy - Burgershot",
    multiple = "The Beast Toys - Burgershot",
    weight = 0.002,
    description = "Werewolf or man!",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        if not exports["soe-properties"]:GetCurrentProperty() then
            PlaceObject("vw_prop_vw_colle_beast", 0.0)
        else
            TriggerEvent("Properties:Client:PrepFurniturePlacement", "vw_prop_vw_colle_beast", 0.0)
        end
    end
}

itemdefs["ll_chickenfriedstreak"] = {
    itemtype = "Lawson Lunchbox",
    singular = "Chicken Fried Steak - Lawson Lunchbox",
    multiple = "Chicken Fried Steaks - Lawson Lunchbox",
    weight = 0.02,
    description = "Chicken steak!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 100, -15)
    end
}

itemdefs["ll_hotwings"] = {
    itemtype = "Lawson Lunchbox",
    singular = "Hot Wings - Lawson Lunchbox",
    multiple = "Hot Wings - Lawson Lunchbox",
    weight = 0.02,
    description = "Chicken wing chicken wing!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 75, -10)
    end
}

itemdefs["ll_biscuitsandgravy"] = {
    itemtype = "Lawson Lunchbox",
    singular = "Biscuits & Gravy - Lawson Lunchbox",
    multiple = "Biscuits & Gravy - Lawson Lunchbox",
    weight = 0.02,
    description = "Gravy and biscuits",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 30, -5)
    end
}

itemdefs["ll_baconeggrollup"] = {
    itemtype = "Lawson Lunchbox",
    singular = "Bacon & Egg Rollup - Lawson Lunchbox",
    multiple = "Bacon & Egg Rollups - Lawson Lunchbox",
    weight = 0.02,
    description = "Mmm, Bacon and egg",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 100, -15)
    end
}

itemdefs["ll_grits"] = {
    itemtype = "Lawson Lunchbox",
    singular = "Grits - Lawson Lunchbox",
    multiple = "Grits - Lawson Lunchbox",
    weight = 0.02,
    description = "Fancy name for poridge!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 30, 5)
    end
}

itemdefs["ll_sweettea"] = {
    itemtype = "Lawson Lunchbox",
    singular = "Sweet Tea - Lawson Lunchbox",
    multiple = "Sweet Teas - Lawson Lunchbox",
    weight = 0.8,
    description = "Sweet sweet tea.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("Juice", 0, 150)
    end
}

itemdefs["ll_chilicheesefries"] = {
    itemtype = "Lawson Lunchbox",
    singular = "Chili Cheese Fries - Lawson Lunchbox",
    multiple = "Chili Cheese Fries - Lawson Lunchbox",
    weight = 0.02,
    description = "Yummy fries!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 30, -5)
    end
}

itemdefs["ll_smokedbrisket"] = {
    itemtype = "Lawson Lunchbox",
    singular = "Smoked Brisket - Lawson Lunchbox",
    multiple = "Smoked Brisket - Lawson Lunchbox",
    weight = 0.02,
    description = "Smoked brisket!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 100, -15)
    end
}

itemdefs["ll_pulledporkplatter"] = {
    itemtype = "Lawson Lunchbox",
    singular = "Pulled Pork Platter - Lawson Lunchbox",
    multiple = "Pulled Pork Platters - Lawson Lunchbox",
    weight = 0.02,
    description = "Pork platter!!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 200, -50)
    end
}

itemdefs["bm_icedcoffee"] = {
    itemtype = "Bean Machine",
    singular = "Iced Coffee - Bean Machine",
    multiple = "Iced Coffees - Bean Machine",
    weight = 0.8,
    description = "Ice cold coffee.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("Juice", 0, 150)
    end
}

itemdefs["bm_cappuccino"] = {
    itemtype = "drink",
    singular = "Cup of Cappuccino",
    multiple = "Cups of Cappuccino",
    weight = 0.8,
    description = "A cup of cappuccino.",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Drink("Coffee", 0, 45)
    end
}

itemdefs["lt_blueraspberryslushie"] = {
    itemtype = "Last Train",
    singular = "Blue Raspberry Slushie - Last Train",
    multiple = "Blue Raspberry Slushies - Last Train",
    weight = 0.8,
    description = "Ice cold slushie.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("Juice", 0, 150)
    end
}

itemdefs["lt_currywurst"] = {
    itemtype = "Last Train",
    singular = "Curry Wurst - Last Train",
    multiple = "Curry Wurst - Last Train",
    weight = 0.80,
    description = "Mmm, Bacon and egg",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 80, -15)
    end
}

itemdefs["lt_onionrings"] = {
    itemtype = "Last Train",
    singular = "Beer Battered Onion Rings - Last Train",
    multiple = "Beer Battered Onion Rings - Last Train",
    weight = 0.02,
    description = "Onion Rings",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Eat("Donut", 35, -5)
        exports["soe-civ"]:SetAlcoholLevel(0.5)
    end
}

itemdefs["lt_beefrumpsteak"] = {
    itemtype = "Lawson Lunchbox",
    singular = "Beef Rump Steak - Last Train",
    multiple = "Beef Rump Steaks - Last Train",
    weight = 0.80,
    description = "Beef steak!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 100, -15)
    end
}

itemdefs["lt_fries"] = {
    itemtype = "food",
    singular = "Fries - Last Train",
    multiple = "Fries - Last Train",
    weight = 0.02,
    description = "Delicious Fries.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 15, -10)
    end
}

itemdefs["vu_jalapenocheesepops"] = {
    itemtype = "Vanilla Unicorn",
    singular = "Jalapeno Cheese Pops - Vanilla Unicorn",
    multiple = "Jalapeno Cheese Pops - Vanilla Unicorn",
    weight = 0.02,
    description = "Cheese Pops",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 35, -5)
    end
}

itemdefs["vu_bbqwings"] = {
    itemtype = "Vanilla Unicorn",
    singular = "Barbeque Wings - Vanilla Unicorn",
    multiple = "Barbeque Wings - Vanilla Unicorn",
    weight = 0.02,
    description = "Chicken wing chicken wing!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 75, -10)
    end
}

itemdefs["vu_buffalocauliflowerwings"] = {
    itemtype = "Vanilla Unicorn",
    singular = "Buffalo Cauliflower Wings - Vanilla Unicorn",
    multiple = "Buffalo Cauliflower Wings - Vanilla Unicorn",
    weight = 0.02,
    description = "Chicken wing chicken wing!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 75, -10)
    end
}

itemdefs["vu_appletini"] = {
    itemtype = "Vanilla Unicorn",
    singular = "Appletini - Vanilla Unicorn",
    multiple = "Appletini - Vanilla Unicorn",
    weight = 0.8,
    description = "A glass appletini.",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-nutrition"]:Drink("champagneGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(8)
    end
}

itemdefs["vu_sexonthebeach"] = {
    itemtype = "Vanilla Unicorn",
    singular = "Sex On The Beach - Vanilla Unicorn",
    multiple = "Sex On The Beach's - Vanilla Unicorn",
    weight = 0.8,
    description = "A glass of sex on the beach.",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-nutrition"]:Drink("champagneGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(8)
    end
}

itemdefs["vu_strawberrydaiquiri"] = {
    itemtype = "Vanilla Unicorn",
    singular = "Strawberry Daiquiri - Vanilla Unicorn",
    multiple = "Strawberry Daiquiri's - Vanilla Unicorn",
    weight = 0.8,
    description = "A glass of strawberry daiquiri.",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-nutrition"]:Drink("champagneGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(8)
    end
}

itemdefs["hs_babybear"] = {
    itemtype = "Haven Resort And Spa",
    singular = "Baby Bear - Haven Resort And Spa",
    multiple = "Baby Bears - Haven Resort And Spa",
    weight = 0.8,
    description = "Refreshing, innocent & delightful.",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-nutrition"]:Drink("whiskyGlass", 0, 40)
    end
}

itemdefs["hs_lemonandcucumberwater"] = {
    itemtype = "Haven Resort And Spa",
    singular = "Lemon & Cucumber Water - Haven Resort And Spa",
    multiple = "Lemon & Cucumber Waters - Haven Resort And Spa",
    weight = 0.8,
    description = "Refreshing, light and energising",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-nutrition"]:Drink("whiskyGlass", 0, 150)
    end
}

itemdefs["hs_meatboard"] = {
    itemtype = "Haven Resort And Spa",
    singular = "Meat Board - Haven Resort And Spa",
    multiple = "Meat Boards - Haven Resort And Spa",
    weight = 0.8,
    description = "A range of cut meats, cheese, crackers and dip.",
    canUse = true,
    canStack = false,
    reusable = true,
    isIllegal = false,
    isChargeItem = true,
    maxCharge = 6,
    onUse = function(uid)
        UseChargeItem("hs_meatboard", uid)
    end
}

itemdefs["hs_float"] = {
    itemtype = "Haven Resort And Spa",
    singular = "Float - Haven Resort And Spa",
    multiple = "Floats - Haven Resort And Spa",
    weight = 0.8,
    description = "Place and ride me!",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        if not exports["soe-properties"]:GetCurrentProperty() then
            PlaceObject("prop_beach_lilo_01", 0.0)
        else
            TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_beach_lilo_01", 0.0)
        end
    end
}

itemdefs["hs_kentuckysunrise"] = {
    itemtype = "Haven Resort And Spa",
    singular = "Smokey Sunrise - Haven Resort And Spa",
    multiple = "Smokey Sunrise - Haven Resort And Spa",
    weight = 0.8,
    description = "Kentucky Sunrise but it's gonna be Smokey.",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-nutrition"]:Drink("whiskyGlass", 0, 40)
    end
}

itemdefs["ao_nachos"] = {
    itemtype = "Arcade-O'Rama",
    singular = "Nachos - Arcade-O'Rama",
    multiple = "Nachos - Arcade-O'Rama",
    weight = 0.8,
    description = "Nachos 4head",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 70, -10)
    end
}

itemdefs["ao_chickennuggets"] = {
    itemtype = "Arcade-O'Rama",
    singular = "Chicken Nuggets - Arcade-O'Rama",
    multiple = "Chicken Nuggets - Arcade-O'Rama",
    weight = 0.8,
    description = "Chicken Nuggets 4head",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 70, -10)
    end
}

itemdefs["ao_chillicheese"] = {
    itemtype = "Arcade-O'Rama",
    singular = "Chilli Cheese Tops - Arcade-O'Rama",
    multiple = "Chilli Cheese Tops - Arcade-O'Rama",
    weight = 0.8,
    description = "Chilli Cheese Tops 4head",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 70, -10)
    end
}

itemdefs["ao_pizza"] = {
    itemtype = "Arcade-O'Rama",
    singular = "Pizza - Arcade-O'Rama",
    multiple = "Pizza - Arcade-O'Rama",
    weight = 0.8,
    description = "Pizza 4head",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 70, -10)
    end
}

itemdefs["ao_rocketfuel"] = {
    itemtype = "Arcade-O'Rama",
    singular = "Rocket Fuel - Arcade-O'Rama",
    multiple = "Rocket Fuel - Arcade-O'Rama",
    weight = 0.8,
    description = "Rocket Fuel 4head",
    canUse = true,
    canStack = false,
    reusable = true,
    isIllegal = false,
    isChargeItem = true,
    maxCharge = 12,
    onUse = function(uid)
        UseChargeItem("ao_rocketfuel", uid)
    end
}

itemdefs["ao_shot_rocketfuel"] = {
    itemtype = "shot",
    singular = "Shot of Rocket Fuel - Arcade-O'Rama",
    multiple = "Shot of Rocket Fuel - Arcade-O'Rama",
    weight = 0.002,
    description = "Shot of Rocket Fuel.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("shotGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(10)
    end
}

itemdefs["ao_milkshake"] = {
    itemtype = "Arcade-O'Rama",
    singular = "Milkshake - Arcade-O'Rama",
    multiple = "Milkshake - Arcade-O'Rama",
    weight = 0.8,
    description = "Milkshake 4head",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-nutrition"]:Drink("", 0, 50)
    end
}

itemdefs["lb_kittencandy"] = {
    itemtype = "L and B Candies",
    singular = "Kitten Candy - L and B Candies",
    multiple = "Kitten Candy's - L and B Candies",
    weight = 0.8,
    description = "Bag of gummies in the shape of cats.",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-nutrition"]:Eat("ps&qs", 40, -10)
    end
}

itemdefs["lb_puppycandy"] = {
    itemtype = "L and B Candies",
    singular = "Puppy Candy - L and B Candies",
    multiple = "Puppy Candy's - L and B Candies",
    weight = 0.8,
    description = "Bag of gummies in the shape of dogs.",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-nutrition"]:Eat("ps&qs", 40, -10)
    end
}

itemdefs["lb_peanutchoc"] = {
    itemtype = "L and B Candies",
    singular = "Peanut Butter Chocolate Bar - L and B Candies",
    multiple = "Peanut Butter Chocolate Bars - L and B Candies",
    weight = 0.8,
    description = "A Peanut Butter Chocolate Bar.",
    canUse = true,
    canStack = false,
    reusable = true,
    isIllegal = false,
    isChargeItem = true,
    maxCharge = 6,
    onUse = function(uid)
        UseChargeItem("lb_peanutchoc", uid)
    end
}

itemdefs["lb_milkchoc"] = {
    itemtype = "L and B Candies",
    singular = "Milk Chocolate Bar - L and B Candies",
    multiple = "Milk Chocolate Bars - L and B Candies",
    weight = 0.8,
    description = "A Milk Chocolate Bar.",
    canUse = true,
    canStack = false,
    reusable = true,
    isIllegal = false,
    isChargeItem = true,
    maxCharge = 6,
    onUse = function(uid)
        UseChargeItem("lb_milkchoc", uid)
    end
}

itemdefs["lb_whitechoc"] = {
    itemtype = "L and B Candies",
    singular = "White Chocolate Bar - L and B Candies",
    multiple = "White Chocolate Bars - L and B Candies",
    weight = 0.8,
    description = "A White Chocolate Bar.",
    canUse = true,
    canStack = false,
    reusable = true,
    isIllegal = false,
    isChargeItem = true,
    maxCharge = 6,
    onUse = function(uid)
        UseChargeItem("lb_whitechoc", uid)
    end
}

itemdefs["lb_dogtreats"] = {
    itemtype = "L and B Candies",
    singular = "Dog Treat - L and B Candies",
    multiple = "Dog Treats - L and B Candies",
    weight = 0.8,
    description = "A Dog Treat.",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-nutrition"]:Eat("Brownie", 40, -10)
    end
}

itemdefs["dc_margarita"] = {
    itemtype = "Diamond Casino",
    singular = "Margarita - Diamond Casino",
    multiple = "Margaritas - Diamond Casino",
    weight = 0.8,
    description = "A glass of margarita.",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-nutrition"]:Drink("champagneGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(8)
    end
}

itemdefs["dc_longisland"] = {
    itemtype = "Diamond Casino",
    singular = "Long Island - Diamond Casino",
    multiple = "Long Island - Diamond Casino",
    weight = 0.8,
    description = "A glass long island.",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-nutrition"]:Drink("whiskyGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(8)
    end
}

itemdefs["dc_martini"] = {
    itemtype = "Diamond Casino",
    singular = "Martini - Diamond Casino",
    multiple = "Martinis - Diamond Casino",
    weight = 0.8,
    description = "A glass of martini.",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-nutrition"]:Drink("champagneGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(8)
    end
}

itemdefs["dc_mimosa"] = {
    itemtype = "Diamond Casino",
    singular = "Mimosa - Diamond Casino",
    multiple = "Mimosa - Diamond Casino",
    weight = 0.8,
    description = "A glass of mimosa.",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-nutrition"]:Drink("champagneGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(8)
    end
}

itemdefs["dc_pretzels"] = {
    itemtype = "Diamond Casino",
    singular = "Pretzels - Diamond Casino",
    multiple = "Pretzels - Diamond Casino",
    weight = 0.02,
    description = "Pretzels",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 35, -5)
    end
}

itemdefs["dc_primerib"] = {
    itemtype = "Diamond Casino",
    singular = "Prime rib - Diamond Casino",
    multiple = "Primes rib - Diamond Casino",
    weight = 0.80,
    description = "Tasty Prime Rib!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 100, -15)
    end
}

itemdefs["gn_galaxy"] = {
    itemtype = "Galaxy Nightclub",
    singular = "Galaxy - Galaxy Nightclub",
    multiple = "Galaxy's - Galaxy Nightclub",
    weight = 0.02,
    description = "Everclear & Grape Kool-aid",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("champagneGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(16)
    end
}

itemdefs["gn_tasteofdiamonds"] = {
    itemtype = "Galaxy Nightclub",
    singular = "Bottle Of Taste Of Diamonds - Galaxy Nightclub",
    multiple = "Bottle Of Taste Of Diamonds's - Galaxy Nightclub",
    weight = 0.12,
    description = "Bottle of diamonds",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 12,
    onUse = function(uid)
        UseChargeItem("gn_tasteofdiamonds", uid)
    end
}

itemdefs["gn_tasteofdiamondsflute"] = {
    itemtype = "Galaxy Nightclub",
    singular = "Taste Of Diamonds - Galaxy Nightclub",
    multiple = "Taste Of Diamonds's - Galaxy Nightclub",
    weight = 0.02,
    description = "Taste like diamonds",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("champagneGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(8)
    end
}

itemdefs["gn_lemondrop"] = {
    itemtype = "Galaxy Nightclub",
    singular = "Lemon Drop - Galaxy Nightclub",
    multiple = "Lemon Drop's - Galaxy Nightclub",
    weight = 0.02,
    description = "Drop of lemon",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("champagneGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(16)
    end
}

itemdefs["gn_pornstarmartini"] = {
    itemtype = "Galaxy Nightclub",
    singular = "Pornstar Martini - Galaxy Nightclub",
    multiple = "Pornstar Martini's - Galaxy Nightclub",
    weight = 0.02,
    description = "Like a pornstar",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("champagneGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(8)
    end
}

itemdefs["gn_whiskeysour"] = {
    itemtype = "Galaxy Nightclub",
    singular = "Whiskey Sour - Galaxy Nightclub",
    multiple = "Whiskey Sour's - Galaxy Nightclub",
    weight = 0.02,
    description = "Sour whiskey",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("whiskyglass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(8)
    end
}

itemdefs["gn_cosmopolitain"] = {
    itemtype = "Galaxy Nightclub",
    singular = "Cosmopolitain - Galaxy Nightclub",
    multiple = "Cosmopolitain's - Galaxy Nightclub",
    weight = 0.02,
    description = "Like a cosmonaut",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("champagneGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(8)
    end
}

itemdefs["sd_lostlager"] = {
    itemtype = "Solomons Distilleries",
    singular = "Lost Lager - Solomon Distilleries",
    multiple = "Lost Lagers - Solomon Distilleries",
    weight = 0.02,
    description = "Forever lost",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("Beer", 0, 35)
        exports["soe-civ"]:SetAlcoholLevel(8)
    end
}

itemdefs["sd_vuvodka"] = {
    itemtype = "Solomons Distilleries",
    singular = "Vanilla Unicorn Vodka - Solomon Distilleries",
    multiple = "Vanilla Unicorn Vodka - Solomon Distilleries",
    weight = 0.024,
    description = "Vanilla",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 12,
    onUse = function(uid)
        UseChargeItem("sd_vuvodka", uid)
    end
}

itemdefs["sd_petrovka"] = {
    itemtype = "Solomons Distilleries",
    singular = "Petrovka - Solomon Distilleries",
    multiple = "Petrovka - Solomon Distilleries",
    weight = 0.024,
    description = "Privyet!",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 12,
    onUse = function(uid)
        UseChargeItem("sd_petrovka", uid)
    end
}

itemdefs["sd_msclovers"] = {
    itemtype = "Solomons Distilleries",
    singular = "Ms. Clover's - Solomon Distilleries",
    multiple = "Ms. Clover's - Solomon Distilleries",
    weight = 0.012,
    description = "Irish Cream",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 6,
    onUse = function(uid)
        UseChargeItem("sd_msclovers", uid)
    end
}

itemdefs["sd_shot_vuvodka"] = {
    itemtype = "shot",
    singular = "Shot of Vanilla Unicorn Vodka",
    multiple = "Shots of Vanilla Unicorn Vodka",
    weight = 0.002,
    description = "Vanilla Unicorn Vodka shot.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("shotGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(10)
    end
}

itemdefs["sd_shot_petrovka"] = {
    itemtype = "shot",
    singular = "Shot of Petrovka",
    multiple = "Shots of Petrovka",
    weight = 0.002,
    description = "Petrovka shot.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("shotGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(10)
    end
}

itemdefs["sd_shot_msclovers"] = {
    itemtype = "glass",
    singular = "Shot of Ms Clover's",
    multiple = "Shots of Ms Clover's",
    weight = 0.002,
    description = "Irish milk.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("shotGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(10)
    end
}

itemdefs["cs_badge_blank"] = {
    itemtype = "badge",
    singular = "Blank Celtic Shield Badge",
    multiple = "Blank Celtic Shield Badges",
    weight = 0.002,
    description = "Blank Celtic Security Badge.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerServerEvent("Jobs:Server:CreateBadge", {status = true, itemName = "cs_badge_blank", factionName = "Celtic Shield Security Solutions Ltd"})
    end
}

itemdefs["cs_badge"] = {
    itemtype = "badge",
    singular = "Celtic Shield Badge",
    multiple = "Celtic Shield Badges",
    weight = 0.002,
    description = "Celtic Security Badge.",
    canUse = true,
    canStack = false,
    reusable = true,
    onUse = function(uid)
        TriggerServerEvent("Jobs:Server:UseBadge", {status = true, itemName = "cs_badge", uid = uid})
    end
}

itemdefs["luchettismenu"] = {
    itemtype = "menu",
    singular = "Luchettis' Menu",
    multiple = "Luchettis' Menus",
    weight = 0.01,
    description = "List of foods and drinks!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        Wait(250)
        exports["soe-ui"]:ShowFoodMenu("luchettis_menu.png")
    end
}

itemdefs["galaxyclubmenu"] = {
    itemtype = "menu",
    singular = "Galaxy Nightclub Menu",
    multiple = "Galaxy Nightclub Menus",
    weight = 0.01,
    description = "List of foods and drinks!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        Wait(250)
        exports["soe-ui"]:ShowFoodMenu("galaxyclub_menu.png")
    end
}

itemdefs["fl_winewoodblanc"] = {
    itemtype = "Four Leaf Vineyard",
    singular = "Bottle Of WineWood Blanc - Four Leaf Vineyard",
    multiple = "Bottle Of WineWood Blancs - Four Leaf Vineyard",
    weight = 0.12,
    description = "Bottle of WineWood Blanc",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 12,
    onUse = function(uid)
        UseChargeItem("fl_winewoodblanc", uid)
    end
}

itemdefs["fl_glass_winewoodblanc"] = {
    itemtype = "Four Leaf Vineyard",
    singular = "WineWood Blanc - Four Leaf Vineyard",
    multiple = "WineWood Blancs - Four Leaf Vineyard",
    weight = 0.02,
    description = "Glass of WineWood Blanc",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("champagneGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(8)
    end
}

itemdefs["fl_blaueballe"] = {
    itemtype = "Four Leaf Vineyard",
    singular = "Bottle Of Blaue Balle - Four Leaf Vineyard",
    multiple = "Bottle Of Blaue Balles - Four Leaf Vineyard",
    weight = 0.12,
    description = "Bottle of Blaue Balle",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 12,
    onUse = function(uid)
        UseChargeItem("fl_blaueballe", uid)
    end
}

itemdefs["fl_glass_blaueballe"] = {
    itemtype = "Four Leaf Vineyard",
    singular = "Blaue Balle - Four Leaf Vineyard",
    multiple = "Blaue Balles - Four Leaf Vineyard",
    weight = 0.02,
    description = "Glass of Blaue Balle",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("champagneGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(8)
    end
}

itemdefs["fl_portzancudo"] = {
    itemtype = "Four Leaf Vineyard",
    singular = "Bottle Of Port Zancudo - Four Leaf Vineyard",
    multiple = "Bottle Of Port Zancudos - Four Leaf Vineyard",
    weight = 0.12,
    description = "Bottle of Port Zancudo",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 12,
    onUse = function(uid)
        UseChargeItem("fl_portzancudo", uid)
    end
}

itemdefs["fl_glass_portzancudo"] = {
    itemtype = "Four Leaf Vineyard",
    singular = "Port Zancudo - Four Leaf Vineyard",
    multiple = "Port Zancudos - Four Leaf Vineyard",
    weight = 0.02,
    description = "Glass of Port Zancudo",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("champagneGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(8)
    end
}

itemdefs["fl_lessantosspecial"] = {
    itemtype = "Four Leaf Vineyard",
    singular = "Bottle Of Les Santos Special - Four Leaf Vineyard",
    multiple = "Bottle Of Les Santos Specials - Four Leaf Vineyard",
    weight = 0.12,
    description = "No spike strips",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 12,
    onUse = function(uid)
        UseChargeItem("fl_lessantosspecial", uid)
    end
}

itemdefs["fl_glass_lessantosspecial"] = {
    itemtype = "Four Leaf Vineyard",
    singular = "Les Santos Special - Four Leaf Vineyard",
    multiple = "Les Santos Specials - Four Leaf Vineyard",
    weight = 0.02,
    description = "Glass of Les Santos Special",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("champagneGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(8)
    end
}

itemdefs["fl_chardonjay"] = {
    itemtype = "Four Leaf Vineyard",
    singular = "Bottle Of Chardonjay - Four Leaf Vineyard",
    multiple = "Bottle Of Chardonjays - Four Leaf Vineyard",
    weight = 0.12,
    description = "Bottle of Chardonjay",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 12,
    onUse = function(uid)
        UseChargeItem("fl_chardonjay", uid)
    end
}

itemdefs["fl_glass_chardonjay"] = {
    itemtype = "Four Leaf Vineyard",
    singular = "Chardonjay - Four Leaf Vineyard",
    multiple = "Chardonjays - Four Leaf Vineyard",
    weight = 0.02,
    description = "Glass of Chardonjay",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("champagneGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(8)
    end
}

itemdefs["lu_bakedziti"] = {
    itemtype = "Luchetti's",
    singular = "Baked Ziti - Luchetti's",
    multiple = "Baked Zitis - Luchetti's",
    weight = 0.02,
    description = "Baked Ziti",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 75, -10)
    end
}

itemdefs["lu_cannoli"] = {
    itemtype = "Luchetti's",
    singular = "Cannoli - Luchetti's",
    multiple = "Cannolis - Luchetti's",
    weight = 0.02,
    description = "Cannoli",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 30, -5)
    end
}

itemdefs["lu_devinedeli"] = {
    itemtype = "Luchetti's",
    singular = "Devine Deli - Luchetti's",
    multiple = "Devine Deli - Luchetti's",
    weight = 0.02,
    description = "Devine Deli",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 6,
    onUse = function(uid)
        UseChargeItem("lu_devinedeli", uid)
    end
}

itemdefs["lu_fettucinealfredo"] = {
    itemtype = "Luchetti's",
    singular = "Fettucineal Fredo - Luchetti's",
    multiple = "Fettucineal Fredo - Luchetti's",
    weight = 0.02,
    description = "Fettucineal Fredo",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 75, -10)
    end
}

itemdefs["lu_manicotti"] = {
    itemtype = "Luchetti's",
    singular = "Manicotti - Luchetti's",
    multiple = "Manicotti - Luchetti's",
    weight = 0.02,
    description = "Manicotti",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 75, -10)
    end
}

itemdefs["lu_spaghetti"] = {
    itemtype = "Luchetti's",
    singular = "Spaghetti - Luchetti's",
    multiple = "Spaghetti - Luchetti's",
    weight = 0.02,
    description = "Spaghetti",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 75, -10)
    end
}

itemdefs["lu_tiramisu"] = {
    itemtype = "Luchetti's",
    singular = "Tiramisu - Luchetti's",
    multiple = "Tiramisu - Luchetti's",
    weight = 0.02,
    description = "Tiramisu",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 35, -5)
    end
}

itemdefs["lh_coddle"] = {
    itemtype = "Lucky Leprechaun",
    singular = "Coddle - Lucky Leprechaun",
    multiple = "Coddles - Lucky Leprechaun",
    weight = 0.02,
    description = "Irish leftovers!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 35, 10)
    end
}

itemdefs["lh_fishandchips"] = {
    itemtype = "Lucky Leprechaun",
    singular = "Fish & Chips - Lucky Leprechaun",
    multiple = "Fish & Chips - Lucky Leprechaun",
    weight = 0.25,
    description = "Fish and Chips!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 100, -15)
    end
}

itemdefs["lh_guinnesspint"] = {
    itemtype = "Lucky Leprechaun",
    singular = "Guinness Pint - Lucky Leprechaun",
    multiple = "Guinness Pints - Lucky Leprechaun",
    weight = 0.02,
    description = "A pint of guinness.",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-nutrition"]:Drink("whiskyGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(8)
    end
}

itemdefs["lh_shamrockshake"] = {
    itemtype = "Lucky Leprechaun",
    singular = "Boozy Shamrock Shake - Lucky Leprechaun",
    multiple = "Boozy Shamrock Shakes - Lucky Leprechaun",
    weight = 0.02,
    description = "A frosty glass of ice cream, and drunkeness.",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-nutrition"]:Drink("whiskyGlass", 10, 40)
        exports["soe-civ"]:SetAlcoholLevel(3)
    end
}

itemdefs["lh_jameson"] = {
    itemtype = "Lucky Leprechaun",
    singular = "Jameson - Lucky Leprechaun",
    multiple = "Jamesons - Lucky Leprechaun",
    weight = 0.02,
    description = "Irish Whiskey",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 12,
    onUse = function(uid)
        UseChargeItem("lh_jameson", uid)
    end
}

itemdefs["lh_shot_jameson"] = {
    itemtype = "Lucky Leprechaun",
    singular = "Shot of Jameson - Lucky Leprechaun",
    multiple = "Shots of Jameson - Lucky Leprechaun",
    weight = 0.02,
    description = "Shot of Irish Whiskey",
    canUse = true,
    canStack = true,
    onUse = function(uid)
        exports["soe-nutrition"]:Drink("shotGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(10)
    end
}

itemdefs["lh_smithwicks"] = {
    itemtype = "Lucky Leprechaun",
    singular = "Smithwicks - Lucky Leprechaun",
    multiple = "Smithwicks - Lucky Leprechaun",
    weight = 0.02,
    description = "Irish Beer.",
    canUse = true,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
        exports["soe-nutrition"]:Drink("whiskyGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(8)
    end
}

itemdefs["lh_sodabread"] = {
    itemtype = "Lucky Leprechaun",
    singular = "Soda Bread - Lucky Leprechaun",
    multiple = "Soda Breads - Lucky Leprechaun",
    weight = 0.02,
    description = "Irish Bread.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Hamburger", 30, -5)
    end
}

itemdefs["rh_betweenhops"] = {
    itemtype = "Rabbit Hole",
    singular = "Between The Hops IPA - Rabbit Hole",
    multiple = "Between The Hops IPAs - Rabbit Hole",
    weight = 0.02,
    description = "Between The Hops IPA",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("Beer", 0, 35)
        exports["soe-civ"]:SetAlcoholLevel(8)
    end
}

itemdefs["rh_nachosandcheese"] = {
    itemtype = "Rabbit Hole",
    singular = "Nachos & Cheese - Rabbit Hole",
    multiple = "Nachos & Cheese - Rabbit Hole",
    weight = 0.02,
    description = "Cheesy Nachos.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 30, -5)
    end
}

itemdefs["rh_outsidersale"] = {
    itemtype = "Rabbit Hole",
    singular = "Outsiders Ale - Rabbit Hole",
    multiple = "Outsiders Ales - Rabbit Hole",
    weight = 0.02,
    description = "Outsider Ale",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("Beer", 0, 35)
        exports["soe-civ"]:SetAlcoholLevel(8)
    end
}

itemdefs["rh_paletoporter"] = {
    itemtype = "Rabbit Hole",
    singular = "Paleto Porter - Rabbit Hole",
    multiple = "Paleto Porters - Rabbit Hole",
    weight = 0.02,
    description = "Paleto Porter",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("Beer", 0, 35)
        exports["soe-civ"]:SetAlcoholLevel(8)
    end
}

itemdefs["rh_peanuts"] = {
    itemtype = "Rabbit Hole",
    singular = "Peanuts - Rabbit Hole",
    multiple = "Peanuts - Rabbit Hole",
    weight = 0.02,
    description = "Peanuts",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 10, -5)
    end
}

itemdefs["rh_pricstout"] = {
    itemtype = "Rabbit Hole",
    singular = "PRIC Stout - Rabbit Hole",
    multiple = "PRICE Stouts - Rabbit Hole",
    weight = 0.02,
    description = "PRICE Stout",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("Beer", 0, 35)
        exports["soe-civ"]:SetAlcoholLevel(8)
    end
}

itemdefs["yj_breakfastburrito"] = {
    itemtype = "Yellow Jack",
    singular = "Breakfast Burrito - Yellow Jack",
    multiple = "Breakfast Burritos - Yellow Jack",
    weight = 0.05,
    description = "Breakfast Burrito",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Eat("Hamburger", 75, -5)
    end
}

itemdefs["yj_grilledcheeseandsoup"] = {
    itemtype = "Yellow Jack",
    singular = "Grilled Cheese & Soup - Yellow Jack",
    multiple = "Grilled Cheese & Soups - Yellow Jack",
    weight = 0.05,
    description = "Grilled Cheese & Soup",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 75, 25)
    end
}

itemdefs["yj_chickenandrice"] = {
    itemtype = "Yellow Jack",
    singular = "Chicken & Rice - Yellow Jack",
    multiple = "Chicken & Rices - Yellow Jack",
    weight = 0.05,
    description = "Chicken & Rice",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 100, -15)
    end
}

itemdefs["yj_boilermaker"] = {
    itemtype = "drink",
    singular = "Yellow Jack - Boiler Maker",
    multiple = "Yellow Jack - Boiler Maker",
    weight = 0.08,
    description = "Beer with a shot of Whiskey inside",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Drink("shotGlass", 0, 35)
        exports["soe-civ"]:SetAlcoholLevel(12)
    end
}

itemdefs["yj_tequila"] = {
    itemtype = "drink",
    singular = "Yellow Jack - Tequila",
    multiple = "Yellow Jack - Tequila",
    weight = 0.08,
    description = "Yellow Jack Tequila",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 12,
    onUse = function(uid)
        UseChargeItem("yj_tequila", uid)
    end
}

itemdefs["yj_whiskey"] = {
    itemtype = "drink",
    singular = "Yellow Jack - Whiskey",
    multiple = "Yellow Jack - Whiskey",
    weight = 0.08,
    description = "Yellow Jack Whiskey",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 12,
    onUse = function(uid)
        UseChargeItem("yj_whiskey", uid)
    end
}

itemdefs["yj_shot_tequila"] = {
    itemtype = "shot",
    singular = "Shot of Yellow Jack Tequila",
    multiple = "Shots of Yellow Jack Tequila",
    weight = 0.002,
    description = "Yellow Jack Tequila Shot.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("shotGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(10)
    end
}

itemdefs["yj_shot_whiskey"] = {
    itemtype = "shot",
    singular = "Shot of Yellow Jack Whiskey",
    multiple = "Shots of Yellow Jack Whiskey",
    weight = 0.002,
    description = "Yellow Jack Whiskey Shot.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("shotGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(10)
    end
}

itemdefs["sb_stepfred"] = {
    itemtype = "tool",
    singular = "Sex on The Beach - The Step Fred",
    multiple = "Sex on The Beach - The Step Fred",
    weight = 0.10,
    description = "Use your imagination",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        if not exports["soe-properties"]:GetCurrentProperty() then
            PlaceObject("prop_cs_dildo_01", 0.0)
        else
            TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_cs_dildo_01", 0.0)
        end
    end
}

itemdefs["sb_frostdickle"] = {
    itemtype = "tool",
    singular = "Sex on The Beach - The Frostdickle",
    multiple = "Sex on The Beach - The Frostdickle",
    weight = 0.10,
    description = "Use your imagination",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        if not exports["soe-properties"]:GetCurrentProperty() then
            PlaceObject("v_res_d_dildo_c", 0.0)
        else
            TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_d_dildo_c", 0.0)
        end
    end
}

itemdefs["sb_goose"] = {
    itemtype = "tool",
    singular = "Sex on The Beach - The Goose",
    multiple = "Sex on The Beach - The Goose",
    weight = 0.10,
    description = "Use your imagination",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        if not exports["soe-properties"]:GetCurrentProperty() then
            PlaceObject("v_res_d_dildo_b", 0.0)
        else
            TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_d_dildo_b", 0.0)
        end
    end
}

itemdefs["sb_lube"] = {
    itemtype = "tool",
    singular = "Sex On The Beach - Lube",
    multiple = "Sex On The Beach - Lube",
    weight = 0.30,
    description = "Sex On The Beach Lube!",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        if not exports["soe-properties"]:GetCurrentProperty() then
            PlaceObject("v_res_d_lube", 0.0)
        else
            TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_d_lube", 0.0)
        end
    end
}

itemdefs["sb_heidi"] = {
    itemtype = "tool",
    singular = "Sex On The Beach - Heidi",
    multiple = "Sex On The Beach - Heidi",
    weight = 0.30,
    description = "Sex On The Beach Heidi Sex Doll!",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        if not exports["soe-properties"]:GetCurrentProperty() then
            PlaceObject("prop_dummy_01", 0.0)
        else
            TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_dummy_01", 0.0)
        end
    end
}

itemdefs["sn_braisedbeeframen"] = {
    itemtype = "Sato's Noodle Exchange and Sushi",
    singular = "Braised Beef Ramen - Sato's Noodle Exchange",
    multiple = "Braised Beef Ramens - Sato's Noodle Exchange",
    weight = 0.05,
    description = "Braised Beef Ramen!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 100, 25)
    end
}

itemdefs["sn_gyoza"] = {
    itemtype = "Sato's Noodle Exchange and Sushi",
    singular = "Gyoza - Sato's Noodle Exchange",
    multiple = "Gyozas - Sato's Noodle Exchange",
    weight = 0.02,
    description = "Fancy word for dumpling",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 75, -10)
    end
}

itemdefs["sn_japanesepannoodles"] = {
    itemtype = "Sato's Noodle Exchange and Sushi",
    singular = "Japanese Pan Noodles - Sato's Noodle Exchange",
    multiple = "Japanese Pan Noodles - Sato's Noodle Exchange",
    weight = 0.05,
    description = "Japanese Pan Noodles!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 100, -15)
    end
}

itemdefs["sn_lemonicetea"] = {
    itemtype = "Sato's Noodle Exchange and Sushi",
    singular = "Lemon Ice Tea - Sato's Noodle Exchange",
    multiple = "Lemon Ice Tea - Sato's Noodle Exchange",
    weight = 0.02,
    description = "Refreshing lemon ice tea.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("Juice", 0, 150)
    end
}

itemdefs["sn_padthai"] = {
    itemtype = "Sato's Noodle Exchange and Sushi",
    singular = "Pad Thai - Sato's Noodle Exchange",
    multiple = "Pad Thais - Sato's Noodle Exchange",
    weight = 0.05,
    description = "Pad Thai!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 100, -15)
    end
}

itemdefs["sn_stirfrychickennoodles"] = {
    itemtype = "Sato's Noodle Exchange and Sushi",
    singular = "Stir Fry Chicken Noodles - Sato's Noodle Exchange",
    multiple = "Stir Fry Chicken Noodles - Sato's Noodle Exchange",
    weight = 0.05,
    description = "Stir Fry Chicken Noodles!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 200, -50)
    end
}

itemdefs["cb_littleballs"] = {
    itemtype = "food",
    singular = "Little Balls - Cool Beans",
    multiple = "Little Balls - Cool Beans ",
    weight = 0.75,
    description = "Little Balls",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 35, -5)
    end
}

itemdefs["cb_creampie"] = {
    itemtype = "food",
    singular = "Cream Pie - Cool Beans",
    multiple = "Cream Pie - Cool Beans ",
    weight = 0.75,
    description = "Cream Pie",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 35, -5)
    end
}

itemdefs["cb_cakepops"] = {
    itemtype = "food",
    singular = "Cakepops - Cool Beans",
    multiple = "Cakepops - Cool Beans ",
    weight = 0.75,
    description = "Cakepops",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Eat("Lollipop", 10, 0)
    end
}

itemdefs["cb_dirtychai"] = {
    itemtype = "food",
    singular = "Dirt Chai - Cool Beans",
    multiple = "Dirt Chai - Cool Beans ",
    weight = 0.75,
    description = "Dirt Chai",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Drink("Coffee", 0, 70)
    end
}

itemdefs["cb_peachtea"] = {
    itemtype = "food",
    singular = "Peach Tea - Cool Beans",
    multiple = "Peach Tea - Cool Beans ",
    weight = 0.75,
    description = "Peach Tea",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Drink("Coffee", 0, 70)
    end
}

itemdefs["cb_icedcoffeewithdonut"] = {
    itemtype = "food",
    singular = "Ice Coffee With Donut - Cool Beans",
    multiple = "Ice Coffee With Donut - Cool Beans ",
    weight = 0.75,
    description = "Ice Coffee With Donut",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Drink("Coffee", 35, 70)
    end
}

itemdefs["sotw_partypack"] = {
    itemtype = "SOTW",
    singular = "Original Party Pack - SOTW",
    multiple = "Original Party Packs - SOTW",
    weight = 0.25,
    description = "A box containing 20 Smoke On The Water handy packs.",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 20,
    onUse = function(uid)
        UseChargeItem("sotw_partypack", uid)
    end
}

itemdefs["sotw_handypack"] = {
    itemtype = "SOTW",
    singular = "Original Handy Pack - SOTW",
    multiple = "Original Handy Packs - SOTW",
    weight = 0.05,
    description = "A pack containing 5 fine Smoke On The Water joints.",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 5,
    onUse = function(uid)
        UseChargeItem("sotw_handypack", uid)
    end
}

itemdefs["sotw_joint"] = {
    itemtype = "SOTW",
    singular = "Original Joint - SOTW",
    multiple = "Original Joints - SOTW",
    weight = 0.01,
    description = "Smoke weed everyday brah..",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        TriggerEvent("Crime:Client:DoDrugEffects", "Weed", "SOTW")
    end
}

itemdefs["sotw_partypack_goldensunrise"] = {
    itemtype = "SOTW",
    singular = "Golden Sunrise Party Pack - SOTW",
    multiple = "Golden Sunrise Party Packs - SOTW",
    weight = 0.25,
    description = "A box containing 20 Smoke On The Water handy packs.",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 20,
    onUse = function(uid)
        UseChargeItem("sotw_partypack_goldensunrise", uid)
    end
}

itemdefs["sotw_handypack_goldensunrise"] = {
    itemtype = "SOTW",
    singular = "Golden Sunrise Handy Pack - SOTW",
    multiple = "Golden Sunrise Handy Packs - SOTW",
    weight = 0.05,
    description = "A pack containing 5 fine Smoke On The Water joints.",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 5,
    onUse = function(uid)
        UseChargeItem("sotw_handypack_goldensunrise", uid)
    end
}

itemdefs["sotw_joint_goldensunrise"] = {
    itemtype = "SOTW",
    singular = "Golden Sunrise Joint - SOTW",
    multiple = "Golden Sunrise Joints - SOTW",
    weight = 0.01,
    description = "Smoke weed everyday brah..",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        TriggerEvent("Crime:Client:DoDrugEffects", "Weed", "SOTW")
    end
}

itemdefs["sotw_partypack_purplenurple"] = {
    itemtype = "SOTW",
    singular = "Purple Nurple Party Pack - SOTW",
    multiple = "Purple Nurple Party Packs - SOTW",
    weight = 0.25,
    description = "A box containing 20 Smoke On The Water handy packs.",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 20,
    onUse = function(uid)
        UseChargeItem("sotw_partypack_purplenurple", uid)
    end
}

itemdefs["sotw_handypack_purplenurple"] = {
    itemtype = "SOTW",
    singular = "Purple Nurple Handy Pack - SOTW",
    multiple = "Purple Nurple Handy Packs - SOTW",
    weight = 0.05,
    description = "A pack containing 5 fine Smoke On The Water joints.",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 5,
    onUse = function(uid)
        UseChargeItem("sotw_handypack_purplenurple", uid)
    end
}

itemdefs["sotw_joint_purplenurple"] = {
    itemtype = "SOTW",
    singular = "Purple Nurple Joint - SOTW",
    multiple = "Purple Nurple Joints - SOTW",
    weight = 0.01,
    description = "Smoke weed everyday brah..",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        TriggerEvent("Crime:Client:DoDrugEffects", "Weed", "SOTW")
    end
}

itemdefs["sotw_partypack_tealappeal"] = {
    itemtype = "SOTW",
    singular = "Teal Appeal Party Pack - SOTW",
    multiple = "Teal Appeal Party Packs - SOTW",
    weight = 0.25,
    description = "A box containing 20 Smoke On The Water handy packs.",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 20,
    onUse = function(uid)
        UseChargeItem("sotw_partypack_tealappeal", uid)
    end
}

itemdefs["sotw_handypack_tealappeal"] = {
    itemtype = "SOTW",
    singular = "Teal Appeal Handy Pack - SOTW",
    multiple = "Teal Appeal Handy Packs - SOTW",
    weight = 0.05,
    description = "A pack containing 5 fine Smoke On The Water joints.",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 5,
    onUse = function(uid)
        UseChargeItem("sotw_handypack_tealappeal", uid)
    end
}

itemdefs["sotw_joint_tealappeal"] = {
    itemtype = "SOTW",
    singular = "Teal Appeal Joint - SOTW",
    multiple = "Teal Appeal Joints - SOTW",
    weight = 0.01,
    description = "Smoke weed everyday brah..",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        TriggerEvent("Crime:Client:DoDrugEffects", "Weed", "SOTW")
    end
}

itemdefs["hh_meatloversomlette"] = {
    itemtype = "Hen House",
    singular = "Meat Lovers Omelette - Hen House",
    multiple = "Meat Lovers Omelettes - Hen House",
    weight = 0.05,
    description = "Meat Lovers Omelette",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Eat("Hamburger", 75, -5)
    end
}

itemdefs["hh_marinatedgrilledchicken"] = {
    itemtype = "Hen House",
    singular = "Marinated Grilled Chicken - Hen House",
    multiple = "Marinated Grilled Chickens - Hen House",
    weight = 0.02,
    description = "Marinated Grilled Chicken!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 75, -10)
    end
}

itemdefs["hh_friedchicken"] = {
    itemtype = "Hen House",
    singular = "Fried Chicken - Hen House",
    multiple = "Fried Chickens - Hen House",
    weight = 0.02,
    description = "Fried Chicken!",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 75, -10)
    end
}

itemdefs["hh_chickenmac"] = {
    itemtype = "Hen House",
    singular = "Chicken Mac - Hen House",
    multiple = "Chicken Mac - Hen House",
    weight = 0.05,
    description = "Chicken Mac",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 75, 25)
    end
}

itemdefs["hh_taternachos"] = {
    itemtype = "Hen House",
    singular = "Tater Nachos - Hen House",
    multiple = "Tater Nachos - Hen House",
    weight = 0.02,
    description = "Tater Nachos.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 30, -5)
    end
}

itemdefs["hh_jaegerbomb"] = {
    itemtype = "shot",
    singular = "Shot of Jager Bomb",
    multiple = "Shots of Jager Bomb",
    weight = 0.002,
    description = "Jager Bomb shot.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("shotGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(10)
    end
}

itemdefs["bt_chickenbento"] = {
    itemtype = "Bento",
    singular = "Chicken Bento - Bento",
    multiple = "Chicken Bentos - Bento",
    weight = 0.05,
    description = "Chicken Bento",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 75, -10)
    end
}

itemdefs["bt_nogogibento"] = {
    itemtype = "Bento",
    singular = "Nogogi Bento - Bento",
    multiple = "Nogogi Bentos - Bento",
    weight = 0.05,
    description = "Nogogi Bento",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 75, -10)
    end
}

itemdefs["bt_porkbento"] = {
    itemtype = "Bento",
    singular = "Pork Bento - Bento",
    multiple = "Pork Bentos - Bento",
    weight = 0.05,
    description = "Pork Bento",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 75, -10)
    end
}

itemdefs["bt_sushiplatter"] = {
    itemtype = "Bento",
    singular = "Sushi Platter - Bento",
    multiple = "Sushi Platters - Bento",
    weight = 0.02,
    description = "Sushi Platter",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 75, -10)
    end
}

itemdefs["bt_takoyaki"] = {
    itemtype = "Bento",
    singular = "Takoyaki - Bento",
    multiple = "Takoyaki - Bento",
    weight = 0.01,
    description = "Takoyaki",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("", 30, -5)
    end
}

itemdefs["bt_bubbletea"] = {
    itemtype = "Bento",
    singular = "Bubble Tea - Bento",
    multiple = "Bubble Teas - Bento",
    weight = 0.01,
    description = "Bubble Tea",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("Juice", 0, 125)
    end
}

itemdefs["bb_starburstthcgummies"] = {
    itemtype = "Best Buds",
    singular = "Bag of THC Gummies - Best Buds",
    multiple = "Bags of THC Gummies - Best Buds",
    weight = 0.01,
    description = "Warning: contains THC",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 20,
    onUse = function(uid)
        UseChargeItem("bb_starburstthcgummies", uid)
    end
}

itemdefs["bb_cookiesandcreambar"] = {
    itemtype = "Best Buds",
    singular = "Cookies And Cream Bar - Best Buds",
    multiple = "Cookies And Cream Bars - Best Buds",
    weight = 0.01,
    description = "Warning: contains THC",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 15,
    onUse = function(uid)
        UseChargeItem("bb_cookiesandcreambar", uid)
    end
}

itemdefs["bb_cannabisbrownie"] = {
    itemtype = "Best Buds",
    singular = "Cannabis Brownie - Best Buds",
    multiple = "Cannabis Brownies - Best Buds",
    weight = 0.01,
    description = "Warning: contains cannabis",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Eat("Brownie", 35, -5)
        TriggerEvent("Crime:Client:DoDrugEffects", "Weed", "Best Buds Edibles", false)
    end
}

itemdefs["bb_pumpkinspice"] = {
    itemtype = "Best Buds",
    singular = "Pumpkin Spice Cannabis Rolls - Best Buds",
    multiple = "Pumpkin Spice Cannabis Rolls - Best Buds",
    weight = 0.01,
    description = "Warning: contains cannabis",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        exports["soe-nutrition"]:Eat("Brownie", 45, -5)
        TriggerEvent("Crime:Client:DoDrugEffects", "Weed", "Best Buds Edibles", false)
    end
}

itemdefs["bb_joint_pineappleexpress"] = {
    itemtype = "Best Buds",
    singular = "Pineapple Express Joint - Best Buds",
    multiple = "Pineapple Express Joints - Best Buds",
    weight = 0.01,
    description = "Smoke weed everyday brah..",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        TriggerEvent("Crime:Client:DoDrugEffects", "Weed", "Best Buds")
    end
}

itemdefs["bb_joint_chernobyl"] = {
    itemtype = "Best Buds",
    singular = "Chernobyl Joint - Best Buds",
    multiple = "Chernobyl Joints - Best Buds",
    weight = 0.01,
    description = "Smoke weed everyday brah..",
    canUse = true,
    canStack = true,
    reusable = false,
    onUse = function()
        TriggerEvent("Crime:Client:DoDrugEffects", "Weed", "Best Buds")
    end
}

itemdefs["bb_seedpacket"] = {
    itemtype = "Best Buds",
    singular = "Seed Packet - Best Buds",
    multiple = "Seed Packets - Best Buds",
    weight = 0.01,
    description = "Seed Packet",
    canUse = true,
    canStack = true,
    reusable = true,
    isChargeItem = true,
    maxCharge = 1,
    onUse = function(uid)
        UseChargeItem("bb_seedpacket", uid)
    end
}

-- CRAFT ITEMS END

itemdefs["statelicense"] = {
    itemtype = "id",
    singular = "State License",
    multiple = "State License",
    weight = 0.001,
    description = "State License.",
    canUse = true,
    canStack = false,
    reusable = true,
    onUse = function(uid)
        TriggerServerEvent("Inventory:Server:UseStateLicense", uid)
    end
}

-- BADGES START --

itemdefs["emergencyservices_badge_blank"] = {
    itemtype = "badge",
    singular = "Blank Emergency Services Badge",
    multiple = "Blank Emergency Services Badges",
    weight = 0.002,
    description = "Blank Emergency Services Badge.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerServerEvent("Jobs:Server:CreateBadge", {status = true, emergencyServicesBadge = true, itemName = "emergencyservices_badge_blank"})
    end
}

itemdefs["bcso_badge"] = {
    itemtype = "badge",
    singular = "BCSO Badge",
    multiple = "BCSO Badges",
    weight = 0.002,
    description = "BCSO Badge.",
    canUse = true,
    canStack = false,
    reusable = true,
    onUse = function(uid)
        TriggerServerEvent("Jobs:Server:UseBadge", {status = true, emergencyServicesBadge = true, itemName = "bcso_badge", uid = uid})
    end
}

itemdefs["lspd_badge"] = {
    itemtype = "badge",
    singular = "LSPD Badge",
    multiple = "LSPD Badges",
    weight = 0.002,
    description = "LEO Badge.",
    canUse = true,
    canStack = false,
    reusable = true,
    onUse = function(uid)
        TriggerServerEvent("Jobs:Server:UseBadge", {status = true, emergencyServicesBadge = true, itemName = "lspd_badge", uid = uid})
    end
}

itemdefs["sasp_badge"] = {
    itemtype = "badge",
    singular = "SASP Badge",
    multiple = "SASP Badges",
    weight = 0.002,
    description = "SASP Badge.",
    canUse = true,
    canStack = false,
    reusable = true,
    onUse = function(uid)
        TriggerServerEvent("Jobs:Server:UseBadge", {status = true, emergencyServicesBadge = true, itemName = "leo_badge", uid = uid})
    end
}

itemdefs["safr_badge"] = {
    itemtype = "badge",
    singular = "SAFR Badge",
    multiple = "SAFR Badges",
    weight = 0.002,
    description = "SAFR Badge.",
    canUse = true,
    canStack = false,
    reusable = true,
    onUse = function(uid)
        TriggerServerEvent("Jobs:Server:UseBadge", {status = true, emergencyServicesBadge = true, itemName = "safr_badge", uid = uid})
    end
}

itemdefs["saes_badge"] = {
    itemtype = "badge",
    singular = "SAES Badge",
    multiple = "SAES Badges",
    weight = 0.002,
    description = "SAES Badge.",
    canUse = true,
    canStack = false,
    reusable = true,
    onUse = function(uid)
        TriggerServerEvent("Jobs:Server:UseBadge", {status = true, emergencyServicesBadge = true, itemName = "saes_badge", uid = uid})
    end
}

itemdefs["sacl_badge"] = {
    itemtype = "badge",
    singular = "SACL Badge",
    multiple = "SACL Badges",
    weight = 0.002,
    description = "SACL Badge.",
    canUse = true,
    canStack = false,
    reusable = true,
    onUse = function(uid)
        TriggerServerEvent("Jobs:Server:UseBadge", {status = true, emergencyServicesBadge = true, itemName = "sacl_badge", uid = uid})
    end
}

-- BADGES END --

itemdefs["bagofleogear"] = {
    itemtype = "tool",
    singular = "Box of LEO gear",
    multiple = "Boxes of LEO gear",
    weight = 50.0,
    description = "Loot box",
    canUse = true,
    canStack = true,
    reusable = true,
    isChargeItem = true,
    maxCharge = 1,
    onUse = function(uid)
        UseChargeItem("bagofleogear", uid)
    end
}

itemdefs["scubagear"] = {
    itemtype = "scubagear",
    singular = "Scuba Gear",
    multiple = "Scuba Gear",
    weight = 3.0,
    description = "Scuba Gear.",
    canUse = true,
    canStack = false,
    reusable = true,
    onUse = function(uid)
        exports["soe-civ"]:UseScuba("MkI", uid)
    end
}

itemdefs["scubagearmkii"] = {
    itemtype = "scubagear",
    singular = "Scuba Gear Mk II",
    multiple = "Scuba Gear Mk II",
    weight = 3.5,
    description = "Advanced Scuba Gear.",
    canUse = true,
    canStack = false,
    reusable = true,
    onUse = function(uid)
        exports["soe-civ"]:UseScuba("MkII", uid)
    end
}

-- CONTAINERS START
itemdefs["smallcrateofscubagearmkii"] = {
    itemtype = "container",
    singular = "Small Crate of Scuba Gear Mk II's",
    multiple = "Large Crates of Scuba Gear Mk II's",
    weight = 20.0,
    description = "Crate of Scuba Gear MkII.",
    canUse = true,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
        local containerData = {
            item = "scubagearmkii",
            maxQuantity = 5,
            containerItem = "smallcrateofscubagearmkii",
            containerName = "Small Crate of Scuba Gear Mk II's",
            canDamage = false,
            requiresSkill = true,
            requiresCrowbar = true,
            duration = nil
        }
        TriggerEvent("Civ:Client:OpenContainer", containerData)
    end
}

itemdefs["largecrateofscubagearmkii"] = {
    itemtype = "container",
    singular = "Large Crate of Scuba Gear Mk II's",
    multiple = "Large Crates of Scuba Gear Mk II's",
    weight = 55.0,
    description = "Crate of Scuba Gear.",
    canUse = true,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
        local containerData = {
            item = "scubagearmkii",
            maxQuantity = 10,
            containerItem = "largecrateofscubagearmkii",
            containerName = "Large Crate of Scuba Gear Mk II's",
            canDamage = false,
            requiresSkill = true,
            requiresCrowbar = true,
            duration = nil
        }
        TriggerEvent("Civ:Client:OpenContainer", containerData)
    end
}

itemdefs["crateofmachinepistols"] = {
    itemtype = "container",
    singular = "Crate of Machine Pistols",
    multiple = "Crates of Machine Pistols",
    weight = 5.5,
    description = "Crate of Machine Pistols.",
    canUse = true,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
        local containerData = {
            item = "WEAPON_MACHINEPISTOL",
            maxQuantity = 5,
            containerItem = "crateofmachinepistols",
            containerName = "Crate of Machine Pistols",
            canDamage = false,
            requiresSkill = true,
            requiresCrowbar = true,
            duration = nil
        }
        TriggerEvent("Civ:Client:OpenContainer", containerData)
    end
}

itemdefs["crateofappistols"] = {
    itemtype = "container",
    singular = "Crate of AP Pistols",
    multiple = "Crates of AP Pistols",
    weight = 5.5,
    description = "Crate of AP Pistols.",
    canUse = true,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
        local containerData = {
            item = "WEAPON_APPISTOL",
            maxQuantity = 5,
            containerItem = "crateofappistols",
            containerName = "Crate of AP Pistols",
            canDamage = false,
            requiresSkill = true,
            requiresCrowbar = true,
            duration = nil
        }
        TriggerEvent("Civ:Client:OpenContainer", containerData)
    end
}

itemdefs["crateofcocaine"] = {
    itemtype = "container",
    singular = "Crate of Cocaine",
    multiple = "Crates of Cocaine",
    weight = 5.5,
    description = "Crate of Cocaine.",
    canUse = true,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
        local containerData = {
            item = "cocainevial",
            maxQuantity = 150,
            containerItem = "crateofcocaine",
            containerName = "Crate of Cocaine",
            canDamage = false,
            requiresSkill = true,
            requiresCrowbar = true,
            duration = nil
        }
        TriggerEvent("Civ:Client:OpenContainer", containerData)
    end
}

itemdefs["crateofmeth"] = {
    itemtype = "container",
    singular = "Crate of Meth",
    multiple = "Crates of Meth",
    weight = 5.5,
    description = "Crate of Meth.",
    canUse = true,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
        local containerData = {
            item = "gramofmeth",
            maxQuantity = 150,
            containerItem = "crateofmeth",
            containerName = "Crate of Meth",
            canDamage = false,
            requiresSkill = true,
            requiresCrowbar = true,
            duration = nil
        }
        TriggerEvent("Civ:Client:OpenContainer", containerData)
    end
}

itemdefs["crateofshrooms"] = {
    itemtype = "container",
    singular = "Crate of Magic Mushrooms",
    multiple = "Crates of Magic Mushrooms",
    weight = 5.5,
    description = "Crate of Magic Mushrooms.",
    canUse = true,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
        local containerData = {
            item = "shrooms",
            maxQuantity = 150,
            containerItem = "crateofshrooms",
            containerName = "Crate of Magic Mushrooms",
            canDamage = false,
            requiresSkill = true,
            requiresCrowbar = true,
            duration = nil
        }
        TriggerEvent("Civ:Client:OpenContainer", containerData)
    end
}

itemdefs["crateofcrack"] = {
    itemtype = "container",
    singular = "Crate of Crack",
    multiple = "Crates of Crack",
    weight = 5.5,
    description = "Crate of Crack.",
    canUse = true,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
        local containerData = {
            item = "crack_smallbag",
            maxQuantity = 150,
            containerItem = "crateofcrack",
            containerName = "Crate of Crack",
            canDamage = false,
            requiresSkill = true,
            requiresCrowbar = true,
            duration = nil
        }
        TriggerEvent("Civ:Client:OpenContainer", containerData)
    end
}

itemdefs["crateofcompactrifles"] = {
    itemtype = "container",
    singular = "Crate of Compact Rifles",
    multiple = "Crates of Compact Rifles",
    weight = 5.5,
    description = "Crate of Compact Rifles.",
    canUse = true,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
        local containerData = {
            item = "WEAPON_COMPACTRIFLE",
            maxQuantity = 5,
            containerItem = "crateofcompactrifles",
            containerName = "Crate of Compact Rifles",
            canDamage = false,
            requiresSkill = true,
            requiresCrowbar = true,
            duration = nil
        }
        TriggerEvent("Civ:Client:OpenContainer", containerData)
    end
}

itemdefs["crateofassaultrifles"] = {
    itemtype = "container",
    singular = "Crate of Assault Rifles",
    multiple = "Crates of Assault Rifles",
    weight = 5.5,
    description = "Crate of Assault Rifles.",
    canUse = true,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
        local containerData = {
            item = "WEAPON_ASSAULTRIFLE",
            maxQuantity = 5,
            containerItem = "crateofassaultrifles",
            containerName = "Crate of Assault Rifles",
            canDamage = false,
            requiresSkill = true,
            requiresCrowbar = true,
            duration = nil
        }
        TriggerEvent("Civ:Client:OpenContainer", containerData)
    end
}

itemdefs["crateofdbshotguns"] = {
    itemtype = "container",
    singular = "Crate of Double Barrel Shotguns",
    multiple = "Crates of Double Barrel Shotguns",
    weight = 5.5,
    description = "Crate of Double Barrel Shotguns.",
    canUse = true,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
        local containerData = {
            item = "WEAPON_DBSHOTGUN",
            maxQuantity = 5,
            containerItem = "crateofdbshotguns",
            containerName = "Crate of Double Barrel Shotguns",
            canDamage = false,
            requiresSkill = true,
            requiresCrowbar = true,
            duration = nil
        }
        TriggerEvent("Civ:Client:OpenContainer", containerData)
    end
}

itemdefs["crateofsawedoffshotguns"] = {
    itemtype = "container",
    singular = "Crate of Sawed-Off Shotguns",
    multiple = "Crates of Sawed-Off Shotguns",
    weight = 5.5,
    description = "Crate of Sawed-Off Shotguns.",
    canUse = true,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
        local containerData = {
            item = "WEAPON_SAWNOFFSHOTGUN",
            maxQuantity = 5,
            containerItem = "crateofsawedoffshotguns",
            containerName = "Crate of Sawed-Off Shotguns",
            canDamage = false,
            requiresSkill = true,
            requiresCrowbar = true,
            duration = nil
        }
        TriggerEvent("Civ:Client:OpenContainer", containerData)
    end
}

itemdefs["crateofmicrosmgs"] = {
    itemtype = "container",
    singular = "Crate of Micro SMGs",
    multiple = "Crates of Micro SMGs",
    weight = 5.5,
    description = "Crate of Micro SMGs.",
    canUse = true,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
        local containerData = {
            item = "WEAPON_MICROSMG",
            maxQuantity = 5,
            containerItem = "crateofmicrosmgs",
            containerName = "Crate of Micro SMGs",
            canDamage = false,
            requiresSkill = true,
            requiresCrowbar = true,
            duration = nil
        }
        TriggerEvent("Civ:Client:OpenContainer", containerData)
    end
}

itemdefs["crateofsmallsilencers"] = {
    itemtype = "container",
    singular = "Crate of Small Silencers",
    multiple = "Crates of Small Silencers",
    weight = 5.5,
    description = "Crate of Small Silencers.",
    canUse = true,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
        local containerData = {
            item = "small_silencer",
            maxQuantity = 5,
            containerItem = "crateofsmallsilencers",
            containerName = "Crate of Small Silencers",
            canDamage = false,
            requiresSkill = true,
            requiresCrowbar = true,
            duration = nil
        }
        TriggerEvent("Civ:Client:OpenContainer", containerData)
    end
}

itemdefs["crateoflargesilencers"] = {
    itemtype = "container",
    singular = "Crate of Large Silencers",
    multiple = "Crates of Large Silencers",
    weight = 5.5,
    description = "Crate of Large Silencers.",
    canUse = true,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
        local containerData = {
            item = "large_silencer",
            maxQuantity = 5,
            containerItem = "crateoflargesilencers",
            containerName = "Crate of Large Silencers",
            canDamage = false,
            requiresSkill = true,
            requiresCrowbar = true,
            duration = nil
        }
        TriggerEvent("Civ:Client:OpenContainer", containerData)
    end
}

itemdefs["smallcrateoflaptops"] = {
    itemtype = "container",
    singular = "Small Crate of Laptops",
    multiple = "Small Crates of Laptops",
    weight = 5.0,
    description = "Crate of Laptops.",
    canUse = true,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
        local containerData = {
            item = "laptop",
            maxQuantity = 5,
            containerItem = "smallcrateoflaptops",
            containerName = "Small Crate of Laptops",
            canDamage = true,
            requiresSkill = true,
            requiresCrowbar = true,
            duration = nil
        }
        TriggerEvent("Civ:Client:OpenContainer", containerData)
    end
}

itemdefs["largecrateoflaptops"] = {
    itemtype = "container",
    singular = "Large Crate of Laptops",
    multiple = "Large Crates of Laptops",
    weight = 14.5,
    description = "Crate of Laptops.",
    canUse = true,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
        local containerData = {
            item = "laptop",
            maxQuantity = 15,
            containerItem = "largecrateoflaptops",
            containerName = "Large Crate of Laptops",
            canDamage = true,
            requiresSkill = true,
            requiresCrowbar = true,
            duration = nil
        }
        TriggerEvent("Civ:Client:OpenContainer", containerData)
    end
}

itemdefs["smallcrateofheadphones"] = {
    itemtype = "container",
    singular = "Small Crate of Headphones",
    multiple = "Small Crates of Headphones",
    weight = 2.5,
    description = "Crate of Headphones.",
    canUse = true,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
        local containerData = {
            item = "headphones",
            maxQuantity = 5,
            containerItem = "smallcrateofheadphones",
            containerName = "Small Crate of Headphones",
            canDamage = true,
            requiresSkill = true,
            requiresCrowbar = true,
            duration = nil
        }
        TriggerEvent("Civ:Client:OpenContainer", containerData)
    end
}

itemdefs["largecrateofheadphones"] = {
    itemtype = "container",
    singular = "Large Crate of Headphones",
    multiple = "Large Crates of Headphones",
    weight = 8.0,
    description = "Crate of Headphones.",
    canUse = true,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
        local containerData = {
            item = "headphones",
            maxQuantity = 15,
            containerItem = "largecrateofheadphones",
            containerName = "Large Crate of Headphones",
            canDamage = true,
            requiresSkill = true,
            requiresCrowbar = true,
            duration = nil
        }
        TriggerEvent("Civ:Client:OpenContainer", containerData)
    end
}

itemdefs["smallcrateoftablets"] = {
    itemtype = "container",
    singular = "Small Crate of Tablets",
    multiple = "Small Crates of Tablets",
    weight = 10.0,
    description = "Crate of Headphones.",
    canUse = true,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
        local containerData = {
            item = "tablet",
            maxQuantity = 8,
            containerItem = "smallcrateoftablets",
            containerName = "Small Crate of Tablets",
            canDamage = true,
            requiresSkill = true,
            requiresCrowbar = true,
            duration = nil
        }
        TriggerEvent("Civ:Client:OpenContainer", containerData)
    end
}

itemdefs["largecrateoftablets"] = {
    itemtype = "container",
    singular = "Large Crate of Tablets",
    multiple = "Large Crates of Tablets",
    weight = 22.0,
    description = "Crate of Headphones.",
    canUse = true,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
        local containerData = {
            item = "tablet",
            maxQuantity = 20,
            containerItem = "largecrateoftablets",
            containerName = "Large Crate of Tablets",
            canDamage = true,
            requiresSkill = true,
            requiresCrowbar = true,
            duration = nil
        }
        TriggerEvent("Civ:Client:OpenContainer", containerData)
    end
}

itemdefs["smallcrateofadvancedrepairkit"] = {
    itemtype = "container",
    singular = "Small Crate of Advanced Repair Kits",
    multiple = "Small Crates of Advanced Repair Kits",
    weight = 30.0,
    description = "Crate of Advanced Repair Kits.",
    canUse = true,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
        local containerData = {
            item = "advancedrepairkit",
            maxQuantity = 5,
            containerItem = "smallcrateofadvancedrepairkit",
            containerName = "Small Crate of Advanced Repair Kits",
            canDamage = false,
            requiresSkill = true,
            requiresCrowbar = true,
            duration = nil
        }
        TriggerEvent("Civ:Client:OpenContainer", containerData)
    end
}

itemdefs["largecrateofadvancedrepairkit"] = {
    itemtype = "container",
    singular = "Large Crate of Advanced Repair Kits",
    multiple = "Large Crates of Advanced Repair Kits",
    weight = 57.5,
    description = "Crate of Advanced Repair Kits.",
    canUse = true,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
        local containerData = {
            item = "advancedrepairkit",
            maxQuantity = 9,
            containerItem = "largecrateofadvancedrepairkit",
            containerName = "Large Crate of Advanced Repair Kits",
            canDamage = false,
            requiresSkill = true,
            requiresCrowbar = true,
            duration = nil
        }
        TriggerEvent("Civ:Client:OpenContainer", containerData)
    end
}

itemdefs["smallboxofsotwsupplies"] = {
    itemtype = "container",
    singular = "Small Box of SOTW Supplies",
    multiple = "Small Boxes of SOTW Supplies",
    weight = 1.0,
    description = "Box of Supplies for SOTW.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["largeboxofsotwsupplies"] = {
    itemtype = "container",
    singular = "Large Box of SOTW Supplies",
    multiple = "Large Boxes of SOTW Supplies",
    weight = 2.25,
    description = "Box of Supplies for SOTW.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["smallboxoflbsupplies"] = {
    itemtype = "container",
    singular = "Small Box of L and B Candies Supplies",
    multiple = "Small Boxes of L and B Candies Supplies",
    weight = 1.0,
    description = "Box of Supplies for L and B Candies.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["largeboxoflbsupplies"] = {
    itemtype = "container",
    singular = "Large Box of L and B Candies Supplies",
    multiple = "Large Boxes of L and B Candies Supplies",
    weight = 2.25,
    description = "Box of Supplies for L and B Candies.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["smallboxofaosupplies"] = {
    itemtype = "container",
    singular = "Small Box of Arcade-O'Rama Supplies",
    multiple = "Small Boxes of Arcade-O'Rama Supplies",
    weight = 1.0,
    description = "Box of Supplies for Arcade-O'Rama.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["largeboxofaosupplies"] = {
    itemtype = "container",
    singular = "Large Box of Arcade-O'Rama Supplies",
    multiple = "Large Boxes of Arcade-O'Rama Supplies",
    weight = 2.25,
    description = "Box of Supplies for Arcade-O'Rama.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["smallboxofhssupplies"] = {
    itemtype = "container",
    singular = "Small Box of Haven Spa Supplies",
    multiple = "Small Boxes of Haven Spa Supplies",
    weight = 1.0,
    description = "Box of Supplies for Haven Spa and Resort.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["largeboxofhssupplies"] = {
    itemtype = "container",
    singular = "Large Box of Haven Spa Supplies",
    multiple = "Large Boxes of Haven Spa Supplies",
    weight = 2.25,
    description = "Box of Supplies for Haven Spa and Resort.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["smallboxofbeanmachinesupplies"] = {
    itemtype = "container",
    singular = "Small Box of Bean Machine Supplies",
    multiple = "Small Boxes of Bean Machine Supplies",
    weight = 1.0,
    description = "Box of Supplies for Bean Machine.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["largeboxofbeanmachinesupplies"] = {
    itemtype = "container",
    singular = "Large Box of Bean Machine Supplies",
    multiple = "Large Boxes of Bean Machine Supplies",
    weight = 2.25,
    description = "Box of Supplies for Bean Machine.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["smallboxoflasttrainsupplies"] = {
    itemtype = "container",
    singular = "Small Box of Last Train Supplies",
    multiple = "Small Boxes of Last Train Supplies",
    weight = 1.0,
    description = "Box of Supplies for Last Train.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["largeboxoflasttrainsupplies"] = {
    itemtype = "container",
    singular = "Large Box of Last Train Supplies",
    multiple = "Large Boxes of Last Train Supplies",
    weight = 2.25,
    description = "Box of Supplies for Last Train.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["smallboxofbahamasupplies"] = {
    itemtype = "container",
    singular = "Small Box of Bahama Mamas Supplies",
    multiple = "Small Boxes of Bahama Mamas Supplies",
    weight = 1.0,
    description = "Box of Supplies for Bahama Mamas.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["largeboxofbahamasupplies"] = {
    itemtype = "container",
    singular = "Large Box of Bahama Mamas Supplies",
    multiple = "Large Boxes of Bahama Mamas Supplies",
    weight = 2.25,
    description = "Box of Supplies for Bahama Mamas.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["smallboxofvusupplies"] = {
    itemtype = "container",
    singular = "Small Box of Vanilla Unicorn Supplies",
    multiple = "Small Boxes of Vanilla Unicorn Supplies",
    weight = 1.0,
    description = "Box of Supplies for Vanilla Unicorn.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["largeboxofvusupplies"] = {
    itemtype = "container",
    singular = "Large Box of Vanilla Unicorn Supplies",
    multiple = "Large Boxes of Vanilla Unicorn Supplies",
    weight = 2.25,
    description = "Box of Supplies for Vanilla Unicorn.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["smallboxofbssupplies"] = {
    itemtype = "container",
    singular = "Small Box of Burger Shot Supplies",
    multiple = "Small Boxes of Burger Shot Supplies",
    weight = 1.0,
    description = "Box of Supplies for Burger Shot.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["largeboxofbssupplies"] = {
    itemtype = "container",
    singular = "Large Box of Burger Shot Supplies",
    multiple = "Large Boxes of Burger Shot Supplies",
    weight = 2.25,
    description = "Box of Supplies for Burger Shot.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["smallboxofllsupplies"] = {
    itemtype = "container",
    singular = "Small Box of Lawson Lunchbox Supplies",
    multiple = "Small Boxes of Lawson Lunchbox Supplies",
    weight = 1.0,
    description = "Box of Supplies for Lawson Lunchbox.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["largeboxofllsupplies"] = {
    itemtype = "container",
    singular = "Large Box of Lawson Lunchbox Supplies",
    multiple = "Large Boxes of Lawson Lunchbox Supplies",
    weight = 2.25,
    description = "Box of Supplies for Lawson Lunchbox.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["smallboxofdcsupplies"] = {
    itemtype = "container",
    singular = "Small Box of Diamond Casino Supplies",
    multiple = "Small Boxes of Diamond Casino Supplies",
    weight = 1.0,
    description = "Box of Supplies for Diamond Casino.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["largeboxofdcsupplies"] = {
    itemtype = "container",
    singular = "Large Box of Diamond Casino Supplies",
    multiple = "Large Boxes of Diamond Casino Supplies",
    weight = 2.25,
    description = "Box of Supplies for Diamond Casino.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["smallboxofbksupplies"] = {
    itemtype = "container",
    singular = "Small Box of Brat's Keys Supplies",
    multiple = "Small Boxes of Brat's Keys Supplies",
    weight = 1.0,
    description = "Box of Supplies for Brat's Keys.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["largeboxofbksupplies"] = {
    itemtype = "container",
    singular = "Large Box of Brat's Keys Supplies",
    multiple = "Large Boxes of Brat's Keys Supplies",
    weight = 2.25,
    description = "Box of Supplies for Brat's Keys.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["smallboxofgnsupplies"] = {
    itemtype = "container",
    singular = "Small Box of Galaxy Nightclub Supplies",
    multiple = "Small Boxes of Galaxy Nightclub Supplies",
    weight = 1.0,
    description = "Box of Supplies for Galaxy Nightclub.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["largeboxofgnsupplies"] = {
    itemtype = "container",
    singular = "Large Box of Galaxy Nightclub Supplies",
    multiple = "Large Boxes of Galaxy Nightclub Supplies",
    weight = 2.25,
    description = "Box of Supplies for Galaxy Nightclub.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["smallboxofsdsupplies"] = {
    itemtype = "container",
    singular = "Small Box of Solomon Distilleries Supplies",
    multiple = "Small Boxes of Solomon Distilleries Supplies",
    weight = 1.0,
    description = "Box of Supplies for Solomon Distilleries.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["largeboxofsdsupplies"] = {
    itemtype = "container",
    singular = "Large Box of Solomon Distilleries Supplies",
    multiple = "Large Boxes of Solomon Distilleries Supplies",
    weight = 2.25,
    description = "Box of Supplies for Solomon Distilleries.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["smallboxofcssupplies"] = {
    itemtype = "container",
    singular = "Small Box of Celtic Security Supplies",
    multiple = "Small Boxes of Celtic Security Supplies",
    weight = 1.0,
    description = "Box of Supplies for Celtic Security.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["largeboxofcssupplies"] = {
    itemtype = "container",
    singular = "Large Box of Celtic Security Supplies",
    multiple = "Large Boxes of Celtic Security Supplies",
    weight = 2.25,
    description = "Box of Supplies for Celtic Security.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["smallboxofflsupplies"] = {
    itemtype = "container",
    singular = "Small Box of Four Leaf Vineyard Supplies",
    multiple = "Small Boxes of Four Leaf Vineyard Supplies",
    weight = 1.0,
    description = "Box of Supplies for Four Leaf Vineyard.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["largeboxofflsupplies"] = {
    itemtype = "container",
    singular = "Large Box of Four Leaf Vineyard Supplies",
    multiple = "Large Boxes of Four Leaf Vineyard Supplies",
    weight = 2.25,
    description = "Box of Supplies for Four Leaf Vineyard.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["smallboxoflusupplies"] = {
    itemtype = "container",
    singular = "Small Box of Luchetti's Supplies",
    multiple = "Small Boxes of Luchetti's Supplies",
    weight = 1.0,
    description = "Box of Supplies for Luchetti's.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["largeboxoflusupplies"] = {
    itemtype = "container",
    singular = "Large Box of Luchetti's Supplies",
    multiple = "Large Boxes of Luchetti's Supplies",
    weight = 2.25,
    description = "Box of Supplies for Luchetti's.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["smallboxofsnsupplies"] = {
    itemtype = "container",
    singular = "Small Box of Sato's Noodle Exchange Supplies",
    multiple = "Small Boxes of Sato's Noodle Exchange Supplies",
    weight = 1.0,
    description = "Box of Supplies for Sato's Noodle Exchange.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["largeboxofsnsupplies"] = {
    itemtype = "container",
    singular = "Large Box of Sato's Noodle Exchange Supplies",
    multiple = "Large Boxes of Sato's Noodle Exchange Supplies",
    weight = 2.25,
    description = "Box of Supplies for Sato's Noodle Exchange.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["smallboxoflhsupplies"] = {
    itemtype = "container",
    singular = "Small Box of Lucky Leprechaun Supplies",
    multiple = "Small Boxes of Lucky Leprechaun Supplies",
    weight = 1.0,
    description = "Box of Supplies for Lucky Leprechaun.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["largeboxoflhsupplies"] = {
    itemtype = "container",
    singular = "Large Box of Lucky Leprechaun Supplies",
    multiple = "Large Boxes of Lucky Leprechaun Supplies",
    weight = 2.25,
    description = "Box of Supplies for Lucky Leprechaun.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["smallboxofsbsupplies"] = {
    itemtype = "container",
    singular = "Small Box of Sex On The Beach Supplies",
    multiple = "Small Boxes of Sex On The Beach",
    weight = 2.25,
    description = "Box of Supplies for Sex On The Beach.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["largeboxofsbsupplies"] = {
    itemtype = "container",
    singular = "Large Box of Sex On The Beach Supplies",
    multiple = "Large Boxes of Sex On The Beach",
    weight = 2.25,
    description = "Box of Supplies for Sex On The Beach.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["smallboxofrhsupplies"] = {
    itemtype = "container",
    singular = "Small Box of Rabbit Hole Supplies",
    multiple = "Small Boxes of Rabbit Hole Supplies",
    weight = 1.0,
    description = "Box of Supplies for Rabbit Hole.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["largeboxofrhsupplies"] = {
    itemtype = "container",
    singular = "Large Box of Rabbit Hole Supplies",
    multiple = "Large Boxes of Rabbit Hole Supplies",
    weight = 2.25,
    description = "Box of Supplies for Rabbit Hole.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["smallboxofyjsupplies"] = {
    itemtype = "container",
    singular = "Small Box of Yellow Jack Supplies",
    multiple = "Small Boxes of Yellow Jack Supplies",
    weight = 1.0,
    description = "Box of Supplies for Yellow Jack.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["largeboxofyjsupplies"] = {
    itemtype = "container",
    singular = "Large Box of Yellow Jack Supplies",
    multiple = "Large Boxes of Yellow Jack Supplies",
    weight = 2.25,
    description = "Box of Supplies for Yellow Jack.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["smallboxofcbsupplies"] = {
    itemtype = "container",
    singular = "Small Box of Cool Beans Supplies",
    multiple = "Small Boxes of Cool Beans Supplies",
    weight = 1.0,
    description = "Box of Supplies for Cool Beans.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["largeboxofcbsupplies"] = {
    itemtype = "container",
    singular = "Large Box of Cool Beans Supplies",
    multiple = "Large Boxes of Cool Beans Supplies",
    weight = 2.25,
    description = "Box of Supplies for Cool Beans.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["smallboxofhhsupplies"] = {
    itemtype = "container",
    singular = "Small Box of Hen House Supplies",
    multiple = "Small Boxes of Hen House Supplies",
    weight = 1.0,
    description = "Box of Supplies for Hen House.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["largeboxofhhsupplies"] = {
    itemtype = "container",
    singular = "Large Box of Hen House Supplies",
    multiple = "Large Boxes of Hen House Supplies",
    weight = 2.25,
    description = "Box of Supplies for Hen House.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["smallboxofbtsupplies"] = {
    itemtype = "container",
    singular = "Small Box of Bento Supplies",
    multiple = "Small Boxes of Bento Supplies",
    weight = 1.0,
    description = "Box of Supplies for Bento.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["largeboxofbtsupplies"] = {
    itemtype = "container",
    singular = "Large Box of Bento Supplies",
    multiple = "Large Boxes of Bento Supplies",
    weight = 2.25,
    description = "Box of Supplies for Bento.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["smallboxofbbsupplies"] = {
    itemtype = "container",
    singular = "Small Box of Best Buds Supplies",
    multiple = "Small Boxes of Best Buds Supplies",
    weight = 1.0,
    description = "Box of Supplies for Best Buds.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

itemdefs["largeboxofbbsupplies"] = {
    itemtype = "container",
    singular = "Large Box of Best Buds Supplies",
    multiple = "Large Boxes of Best Buds Supplies",
    weight = 2.25,
    description = "Box of Supplies for Best Buds.",
    canUse = false,
    canStack = false,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
    end
}

-- END CONTAINERS

itemdefs["lollipopbag"] = {
    itemtype = "food",
    singular = "Bag of Lollipops",
    multiple = "Bags of Lollipops",
    weight = 0.025,
    description = "Bag of Lollipops.",
    canUse = true,
    canStack = false,
    reusable = true,
    isChargeItem = true,
    maxCharge = 6,
    onUse = function(uid)
        UseChargeItem("lollipopbag", uid)
    end
}

itemdefs["lollipopblue"] = {
    itemtype = "food",
    singular = "Blueberry Flavoured Lollipop",
    multiple = "Blueberry Flavoured Lollipops",
    weight = 0.005,
    description = "Blueberry flavoured lollipop.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Lollipop", 10, 0)
    end
}

itemdefs["lollipopgreen"] = {
    itemtype = "food",
    singular = "Green Apple Flavoured Lollipop",
    multiple = "Green Apple Flavoured Lollipops",
    weight = 0.005,
    description = "Green Apple flavoured lollipop.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Lollipop", 10, 0)
    end
}

itemdefs["lollipoporange"] = {
    itemtype = "food",
    singular = "Orange Flavoured Lollipop",
    multiple = "Orange Flavoured Lollipops",
    weight = 0.005,
    description = "Orange flavoured lollipop.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Lollipop", 10, 0)
    end
}

itemdefs["lollipoppurple"] = {
    itemtype = "food",
    singular = "Grape Flavoured Lollipop",
    multiple = "Grape Flavoured Lollipops",
    weight = 0.005,
    description = "Grape flavoured lollipop.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Lollipop", 10, 0)
    end
}

itemdefs["lollipopred"] = {
    itemtype = "food",
    singular = "Cherry Flavoured Lollipop",
    multiple = "Cherry Flavoured Lollipops",
    weight = 0.005,
    description = "Cherry flavoured lollipop.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Lollipop", 10, 0)
    end
}

itemdefs["lollipopyellow"] = {
    itemtype = "food",
    singular = "Lemon Flavoured Lollipop",
    multiple = "Lemon Flavoured Lollipops",
    weight = 0.005,
    description = "Lemon flavoured lollipop.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Lollipop", 10, 0)
    end
}

itemdefs["gumball_blue"] = {
    itemtype = "food",
    singular = "Blue Gumball",
    multiple = "Blue Gumballs",
    weight = 0.005,
    description = "Blue Gumball.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Gumball", 10, 0)
    end
}

itemdefs["gumball_green"] = {
    itemtype = "food",
    singular = "Green Gumball",
    multiple = "Grnne Gumballs",
    weight = 0.005,
    description = "Green Gumball.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Gumball", 10, 0)
    end
}

itemdefs["gumball_orange"] = {
    itemtype = "food",
    singular = "Orange Gumball",
    multiple = "Orange Gumballs",
    weight = 0.005,
    description = "Orange Gumball.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Gumball", 10, 0)
    end
}

itemdefs["gumball_pink"] = {
    itemtype = "food",
    singular = "Pink Gumball",
    multiple = "Pink Gumballs",
    weight = 0.005,
    description = "Pink Gumball.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Gumball", 10, 0)
    end
}

itemdefs["gumball_purple"] = {
    itemtype = "food",
    singular = "Purple Gumball",
    multiple = "Purple Gumballs",
    weight = 0.005,
    description = "Purple Gumball.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Gumball", 10, 0)
    end
}

itemdefs["gumball_red"] = {
    itemtype = "food",
    singular = "Red Gumball",
    multiple = "Red Gumballs",
    weight = 0.005,
    description = "Red Gumball.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Gumball", 10, 0)
    end
}

itemdefs["gumball_yellow"] = {
    itemtype = "food",
    singular = "Yellow Gumball",
    multiple = "Yellow Gumballs",
    weight = 0.005,
    description = "Yellow Gumball.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Eat("Gumball", 10, 0)
    end
}

itemdefs["calculatorwatch"] = {
    itemtype = "jewllery",
    singular = "Calculator Watch",
    multiple = "Calculator Watch",
    weight = 0.25,
    description = "A watch with a calculator.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["digitalwatch"] = {
    itemtype = "jewllery",
    singular = "Digital Watch",
    multiple = "Digital Watch",
    weight = 0.25,
    description = "A digital watch.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["usedtissue"] = {
    itemtype = "junk",
    singular = "Used Tissue",
    multiple = "Used Tissues",
    weight = 0.001,
    description = "Ew!",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["usedpapercup"] = {
    itemtype = "junk",
    singular = "Used Paper Cup",
    multiple = "Used Paper Cups",
    weight = 0.001,
    description = "Reduce reuse recycle!",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["usedpregnancytest"] = {
    itemtype = "junk",
    singular = "Used Pregnancy Test",
    multiple = "Used Pregnancy Tests",
    weight = 0.001,
    description = "Is it 1 line or 2 lines?",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["oldnewspaper"] = {
    itemtype = "junk",
    singular = "Old Newpaper",
    multiple = "Old Newpapers",
    weight = 0.001,
    description = "Get with the times.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["fossilizedfrenchfry"] = {
    itemtype = "junk",
    singular = "Fossilized French Fry",
    multiple = "Fossilized French Fries",
    weight = 0.001,
    description = "Get with the times.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["emptycreamer"] = {
    itemtype = "junk",
    singular = "Empty Creamer",
    multiple = "Empty Creamers",
    weight = 0.001,
    description = "Creamy creamy.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["drypen"] = {
    itemtype = "junk",
    singular = "Dried Pen",
    multiple = "Dried Pens",
    weight = 0.001,
    description = "Use to useful.",
    canUse = false,
    canStack = true,
    onUse = function()
    end
}

itemdefs["scratchoff"] = {
    itemtype = "junk",
    singular = "Scratch-Off Ticket",
    multiple = "Scratch-Off Tickets",
    weight = 0.001,
    description = "This could be a winner... or a loser.",
    canUse = true,
    canStack = true,
    reusable = true,
    isIllegal = false,
    closeInventoryOnUsage = true,
    onUse = function()
        exports["soe-challenge"]:UseScratchOff()
    end
}

itemdefs["scratchoff-lost"] = {
    itemtype = "junk",
    singular = "Losing Scratch-Off",
    multiple = "Losing Scratch-Offs",
    weight = 0.001,
    description = "Its always rigged.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["dice"] = {
    itemtype = "junk",
    singular = "Dice",
    multiple = "Dice",
    weight = 0.001,
    description = "Luck is in small things.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["deckofcards"] = {
    itemtype = "junk",
    singular = "Deck of Cards",
    multiple = "Deck of Cards",
    weight = 0.005,
    description = "Luck is in small things.",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["plasmacutter"] = {
    itemtype = "tool",
    singular = "Plasma Cutter",
    multiple = "Plasma Cutters",
    weight = 0.25,
    description = "It is good at breaking car doors!",
    canUse = true,
    canStack = true,
    reusable = true,
    isIllegal = false,
    onUse = function()
        exports["soe-challenge"]:UsePlasmaCutter()
    end
}

itemdefs["logs"] = {
    itemtype = "tool",
    singular = "Wood Log",
    multiple = "Wood Logs",
    weight = 1.0,
    description = "Useful for making a campfire!",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["woodenplanks"] = {
    itemtype = "industry",
    singular = "Wooden Planks",
    multiple = "Wooden Planks",
    weight = 2.0,
    description = "Cut from logs",
    canUse = false,
    canStack = true,
    reusable = false,
    onUse = function()
    end
}

itemdefs["tunerlaptop"] = {
    itemtype = "tool",
    singular = "Tuner Laptop",
    multiple = "Tuner Laptop",
    weight = 0.15,
    description = "This makes cars go brr.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        exports["soe-ux"]:InstallTunerLaptop()
    end
}

itemdefs["champagneglass"] = {
    itemtype = "junk",
    singular = "Champagne Glass",
    multiple = "Champagne Glasses",
    weight = 0.001,
    description = "For alcohol only.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["shotglass"] = {
    itemtype = "junk",
    singular = "Shot Glass",
    multiple = "Shot Glasses",
    weight = 0.001,
    description = "For alcohol only.",
    canUse = false,
    canStack = true,
    reusable = false,
    isIllegal = false,
    onUse = function()
    end
}

itemdefs["shot_gin"] = {
    itemtype = "shot",
    singular = "Shot of Gin",
    multiple = "Shots of Gin",
    weight = 0.002,
    description = "Gin shot.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("shotGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(10)
    end
}

itemdefs["shot_rum"] = {
    itemtype = "shot",
    singular = "Shot of Rum",
    multiple = "Shots of Rum",
    weight = 0.002,
    description = "Rum shot.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("shotGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(10)
    end
}

itemdefs["shot_vermouth"] = {
    itemtype = "shot",
    singular = "Shot of Vermouth",
    multiple = "Shots of Vermouth",
    weight = 0.002,
    description = "Vermouth shot.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("shotGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(10)
    end
}

itemdefs["shot_vodka"] = {
    itemtype = "shot",
    singular = "Shot of Vodka",
    multiple = "Shots of Vodka",
    weight = 0.002,
    description = "Vodka shot.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("shotGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(10)
    end
}

itemdefs["glass_redwine"] = {
    itemtype = "wineglass",
    singular = "Glass of Red Wine",
    multiple = "Glass's of Red Wine",
    weight = 0.002,
    description = "Red wine in a glass.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("champagneGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(10)
    end
}

itemdefs["glass_whitewine"] = {
    itemtype = "wineglass",
    singular = "Glass of White Wine",
    multiple = "Glass's of White Wine",
    weight = 0.002,
    description = "White wine in a glass.",
    canUse = true,
    canStack = true,
    onUse = function()
        exports["soe-nutrition"]:Drink("champagneGlass", 0, 40)
        exports["soe-civ"]:SetAlcoholLevel(10)
    end
}

-- PLACEABLES
itemdefs["barrier"] = {
    itemtype = "object",
    singular = "Barrier",
    multiple = "Barriers",
    weight = 6.50,
    description = "Block the road!",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        PlaceObject("prop_mp_barrier_02b", 0.0)
    end
}

itemdefs["policebarrier"] = {
    itemtype = "object",
    singular = "Police Barrier",
    multiple = "Police Barriers",
    weight = 5.35,
    description = "Block the road!",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        PlaceObject("prop_barrier_work05", 0.0)
    end
}

itemdefs["arrowbarrier"] = {
    itemtype = "object",
    singular = "Arrow Barrier",
    multiple = "Arrow Barriers",
    weight = 4.55,
    description = "Direct where to go!",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        PlaceObject("prop_mp_arrow_barrier_01", 0.0)
    end
}

itemdefs["basketball"] = {
    itemtype = "object",
    singular = "Basketball",
    multiple = "Basketballs",
    weight = 0.80,
    description = "Step 1 of playing basketball... break them ankles.",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        PlaceObject("prop_bskball_01", 0.0)
    end
}

itemdefs["cone"] = {
    itemtype = "object",
    singular = "Cone",
    multiple = "Cone",
    weight = 1.20,
    description = "Don't knock these over, dammit!",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        PlaceObject("prop_mp_cone_01", 0.0)
    end
}

itemdefs["bodybag"] = {
    itemtype = "object",
    singular = "Bodybag",
    multiple = "Bodybags",
    weight = 0.30,
    description = "Kinda scary to see these around.",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        PlaceObject("xm_prop_body_bag", 0.0)
    end
}

itemdefs["medbag"] = {
    itemtype = "object",
    singular = "Medbag",
    multiple = "Medbags",
    weight = 0.25,
    description = "Useful to treat injuries!",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        PlaceObject("xm_prop_x17_bag_med_01a", 0.0)
    end
}

itemdefs["boombox"] = {
    itemtype = "object",
    singular = "Boombox",
    multiple = "Boomboxes",
    weight = 3.50,
    description = "Useful for parties!",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        PlaceObject("prop_boombox_01", 0.25)
    end
}

itemdefs["beachtowel"] = {
    itemtype = "object",
    singular = "Beach Towel",
    multiple = "Beach Towels",
    weight = 0.03,
    description = "I hate sand. Its coarse, rough and gets everywhere.",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        PlaceObject("p_cs_beachtowel_01_s", 0.0)
    end
}

itemdefs["coffin"] = {
    itemtype = "object",
    singular = "Coffin",
    multiple = "Coffins",
    weight = 5.85,
    description = "Fits bodies!",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        PlaceObject("prop_coffin_02b", 0.0)
    end
}

itemdefs["boxofeggs"] = {
    itemtype = "object",
    singular = "Box of Eggs",
    multiple = "Boxes of Eggs",
    weight = 0.20,
    description = "Carries eggs!",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        PlaceObject("v_ret_247_eggs", 0.0)
    end
}

itemdefs["alienegg"] = {
    itemtype = "object",
    singular = "Alien Egg",
    multiple = "Alien Eggs",
    weight = 1.00,
    description = "What the hell is this?!",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        PlaceObject("prop_alien_egg_01", 0.3)
    end
}

itemdefs["roadworkbarrier"] = {
    itemtype = "object",
    singular = "Roadwork Barrier",
    multiple = "Roadwork Barriers",
    weight = 7.10,
    description = "Road work ahead? Uh yeah, I sure hope it does.",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        PlaceObject("prop_barrier_work04a", 0.0)
    end
}

itemdefs["roadworkbarrier2"] = {
    itemtype = "object",
    singular = "Roadwork Barrier",
    multiple = "Roadwork Barriers",
    weight = 6.23,
    description = "Road work ahead? Uh yeah, I sure hope it does.",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        PlaceObject("prop_barrier_work06b", 0.0)
    end
}

itemdefs["box"] = {
    itemtype = "object",
    singular = "Box",
    multiple = "Boxes",
    weight = 0.90,
    description = "Whats inside?",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        PlaceObject("hei_prop_heist_box", 0.23)
    end
}

itemdefs["micstand"] = {
    itemtype = "object",
    singular = "Mic Stand",
    multiple = "Mic Stands",
    weight = 0.60,
    description = "Time to perform!",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        PlaceObject("v_club_roc_micstd", 0.41)
    end
}

itemdefs["bluetent"] = {
    itemtype = "object",
    singular = "Blue Tent",
    multiple = "Blue Tents",
    weight = 4.00,
    description = "Camping!",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        PlaceObject("prop_skid_tent_01b", 0.5)
    end
}

itemdefs["campfire"] = {
    itemtype = "object",
    singular = "Camp Fire",
    multiple = "Camp Fire",
    weight = 1.10,
    description = "Lets make this and start singing songs!",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        PlaceObject("prop_beach_fire", 0.05)
    end
}

itemdefs["cone2"] = {
    itemtype = "object",
    singular = "Traffic Cone",
    multiple = "Traffic Cones",
    weight = 1.55,
    description = "Traffic Cone. Nothing interesting to say.",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        PlaceObject("prop_air_conelight", 0.0)
    end
}

itemdefs["cone3"] = {
    itemtype = "object",
    singular = "Traffic Cone",
    multiple = "Traffic Cones",
    weight = 1.20,
    description = "Traffic Cone. Nothing interesting to say.",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        PlaceObject("prop_byard_net02", 0.0)
    end
}

itemdefs["garbagebag"] = {
    itemtype = "object",
    singular = "Garbage Bag",
    multiple = "Garbage Bags",
    weight = 0.40,
    description = "Garbage Bag. Nothing interesting to say.",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        PlaceObject("p_rub_binbag_test", 0.45)
    end
}

itemdefs["worklight"] = {
    itemtype = "object",
    singular = "Work Light",
    multiple = "Work Lights",
    weight = 3.50,
    description = "Too damn bright.",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        PlaceObject("prop_worklight_03b", 0.0)
    end
}

itemdefs["crate"] = {
    itemtype = "object",
    singular = "Green Crate",
    multiple = "Green Crates",
    weight = 5.50,
    description = "A green crate!",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        PlaceObject("prop_mb_crate_01a", 0.0)
    end
}

itemdefs["crate2"] = {
    itemtype = "object",
    singular = "Green Crates",
    multiple = "Green Crates",
    weight = 5.50,
    description = "Some green crates!",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        PlaceObject("prop_mb_crate_01a_set", 0.0)
    end
}

itemdefs["crate3"] = {
    itemtype = "object",
    singular = "Large Green Crates",
    multiple = "Large Green Crates",
    weight = 5.50,
    description = "Some large green crates!",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        PlaceObject("prop_mb_crate_01b", 0.0)
    end
}

itemdefs["crate4"] = {
    itemtype = "object",
    singular = "Large Gun Crate",
    multiple = "Large Gun Crates",
    weight = 10.50,
    description = "A large gun crate!",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        PlaceObject("ba_prop_battle_crates_rifles_03a", 0.0)
    end
}

itemdefs["crate5"] = {
    itemtype = "object",
    singular = "Medium Gun Crate",
    multiple = "Medium Gun Crates",
    weight = 8.50,
    description = "Some medium gun crates!",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        PlaceObject("ch_prop_ch_crate_full_01a", 0.0)
    end
}

itemdefs["crate6"] = {
    itemtype = "object",
    singular = "Drug Crate",
    multiple = "Drug Crates",
    weight = 8.50,
    description = "A drug crate!",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        PlaceObject("ex_prop_crate_narc_sc", 0.2)
    end
}

itemdefs["crate7"] = {
    itemtype = "object",
    singular = "Weapon Crate",
    multiple = "Weapon Crates",
    weight = 8.50,
    description = "A weapon crate!",
    canUse = true,
    canStack = true,
    reusable = true,
    closeInventoryOnUsage = true,
    onUse = function()
        PlaceObject("h4_prop_h4_crates_full_01a", 0.0)
    end
}

itemdefs["hs_softsparobe"] = {
    itemtype = "Haven Resort And Spa",
    singular = "Soft Spa Robe - Haven Resort And Spa",
    multiple = "Soft Spa Robe - Haven Resort And Spa",
    weight = 0.05,
    description = "Soft and fluffy.",
    canUse = true,
    reusable = true,
    canStack = true,
    onUse = function()
        TriggerEvent("Appearance:Client:PieceToggles", "Bathrobe")
    end
}

pickups = {
    ["prop_mp_barrier_02b"] = "barrier",
    ["prop_barrier_work05"] = "policebarrier",
    ["prop_mp_arrow_barrier_01"] = "arrowbarrier",
    ["prop_mp_cone_01"] = "cone",
    ["xm_prop_body_bag"] = "bodybag",
    ["xm_prop_x17_bag_med_01a"] = "medbag",
    ["p_cs_beachtowel_01_s"] = "beachtowel",
    ["prop_coffin_02b"] = "coffin",
    ["v_ret_247_eggs"] = "boxofeggs",
    ["prop_alien_egg_01"] = "alienegg",
    ["prop_barrier_work04a"] = "roadworkbarrier",
    ["prop_barrier_work06b"] = "roadworkbarrier2",
    ["hei_prop_heist_box"] = "box",
    ["v_club_roc_micstd"] = "micstand",
    ["prop_skid_tent_01b"] = "bluetent",
    ["prop_beach_fire"] = "campfire",
    ["prop_air_conelight"] = "cone2",
    ["prop_byard_net02"] = "cone3",
    ["p_rub_binbag_test"] = "garbagebag",
    ["prop_worklight_03b"] = "worklight",
    ["prop_bskball_01"] = "basketball",
    ["prop_boombox_01"] = "boombox",
    ["prop_mb_crate_01a"] = "crate",
    ["prop_mb_crate_01a_set"] = "crate2",
    ["prop_mb_crate_01b"] = "crate3",
    ["ba_prop_battle_crates_rifles_03a"] = "crate4",
    ["ch_prop_ch_crate_full_01a"] = "crate5",
    ["ex_prop_crate_narc_sc"] = "crate6",
    ["h4_prop_h4_crates_full_01a"] = "crate7",
    ["vw_prop_vw_colle_alien"] = "bs_toy_alien",
    ["vw_prop_vw_colle_prbubble"] = "bs_toy_bubblegum",
    ["vw_prop_vw_colle_pogo"] = "bs_toy_monkey",
    ["vw_prop_vw_colle_sasquatch"] = "bs_toy_sasquatch",
    ["vw_prop_vw_colle_rsrcomm"] = "bs_toy_spaceman",
    ["vw_prop_vw_colle_rsrgeneric"] = "bs_toy_spaceman2",
    ["vw_prop_vw_colle_imporage"] = "bs_toy_superhero",
    ["vw_prop_vw_colle_beast"] = "bs_toy_wolf",
    ["prop_cs_dildo_01"] = "sb_stepfred",
    ["v_res_d_dildo_c"] = "sb_frostdickle",
    ["v_res_d_dildo_b"] = "sb_goose",
    ["prop_dummy_01"] = "sb_heidi",
    ["v_res_d_lube"] = "sb_lube",
    ["prop_beach_lilo_01"] = "hs_float",
}

-- ********************
--      Furniture
-- ********************
itemdefs["dirtytoilet"] = {
    itemtype = "furniture",
    singular = "Dirty Toilet",
    multiple = "Dirty Toilets",
    weight = 35.00,
    description = "Nobody has cleaned it in a while.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_ld_toilet_01", 0.35)
    end
}

itemdefs["toilet"] = {
    itemtype = "furniture",
    singular = "Toilet",
    multiple = "Toilets",
    weight = 35.00,
    description = "Perfect for your business!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_toilet_01", 0.0)
    end
}

itemdefs["toilet2"] = {
    itemtype = "furniture",
    singular = "Small Toilet",
    multiple = "Small Toilets",
    weight = 31.00,
    description = "Perfect for your business!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_toilet_02", 0.0)
    end
}

itemdefs["toiletbrush"] = {
    itemtype = "furniture",
    singular = "Toilet Brush",
    multiple = "Toilet Brushes",
    weight = 0.80,
    description = "Clean your toilet!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_toilet_brush_01", -0.05)
    end
}

itemdefs["tvcabinet"] = {
    itemtype = "furniture",
    singular = "Wooden TV Cabinet",
    multiple = "Wooden TV Cabinets",
    weight = 55.00,
    description = "Gonna need something to put the TV on.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_tv_cabinet_03", 0.0)
    end
}

itemdefs["flattv"] = {
    itemtype = "furniture",
    singular = "Small Flatscreen TV",
    multiple = "Small Flatscreen TVs",
    weight = 40.00,
    description = "High definition!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_tv_flat_02", 0.24)
    end
}

itemdefs["sofa"] = {
    itemtype = "furniture",
    singular = "Padded Brown Leather Sofa",
    multiple = "Padded Brown Leather Sofas",
    weight = 65.00,
    description = "Super comfy.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "p_v_med_p_sofa_s", 0.0)
    end
}

--[[itemdefs["sofa2"] = {
    itemtype = "furniture",
    singular = "Blue Sofa",
    multiple = "Blue Sofas",
    weight = 61.00,
    description = "Super comfy.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_tre_sofa_s", 0.0)
    end
}]]

itemdefs["sofabed"] = {
    itemtype = "furniture",
    singular = "Sofa Bed",
    multiple = "Sofa Bed",
    weight = 76.00,
    description = "Perfect place to lie down and chill.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_t_sofa", 0.4)
    end
}

itemdefs["pottedplant"] = {
    itemtype = "furniture",
    singular = "Potted Plant",
    multiple = "Potted Plants",
    weight = 9.00,
    description = "A nice potted plant.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_pot_plant_04b", 0.0)
    end
}

itemdefs["tvstand"] = {
    itemtype = "furniture",
    singular = "Vintage TV Stand",
    multiple = "Vintage TV Stand",
    weight = 43.00,
    description = "A Vintage TV Stand.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_cs_tv_stand", 0.0)
    end
}

itemdefs["gnome1"] = {
    itemtype = "furniture",
    singular = "Gnome",
    multiple = "Gnomes",
    weight = 0.20,
    description = "Gnome!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_gnome1", 0.0)
    end
}

itemdefs["gnome2"] = {
    itemtype = "furniture",
    singular = "Gnome",
    multiple = "Gnomes",
    weight = 0.20,
    description = "Gnome!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_gnome2", 0.0)
    end
}

itemdefs["gnome3"] = {
    itemtype = "furniture",
    singular = "Gnome",
    multiple = "Gnomes",
    weight = 0.20,
    description = "Gnome!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_gnome3", 0.0)
    end
}

itemdefs["workbench"] = {
    itemtype = "furniture",
    singular = "Workbench",
    multiple = "Workbenches",
    weight = 30.50,
    description = "A place to craft things!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "gr_prop_gr_bench_04a", 0.0)
    end
}

itemdefs["locker"] = {
    itemtype = "furniture",
    singular = "Closed Locker",
    multiple = "Closed Lockers",
    weight = 13.73,
    description = "A place to put things!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "p_cs_locker_01_s", 0.0)
    end
}

itemdefs["locker2"] = {
    itemtype = "furniture",
    singular = "Open Locker",
    multiple = "Open Lockers",
    weight = 13.00,
    description = "A place to put things!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "p_cs_locker_02", 0.0)
    end
}

itemdefs["bed"] = {
    itemtype = "furniture",
    singular = "Black and Red Double Bed",
    multiple = "Black and Red Double Bed",
    weight = 90.00,
    description = "A place to sleep!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_msonbed", 0.0)
    end
}

itemdefs["bed2"] = {
    itemtype = "furniture",
    singular = "Brown Wooden Double Bed",
    multiple = "Brown Wooden Double Bed",
    weight = 80.00,
    description = "A place to sleep!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "p_lestersbed_s", 0.52)
    end
}

itemdefs["chair"] = {
    itemtype = "furniture",
    singular = "Orange Bucket Chair",
    multiple = "Orange Bucket Chairs",
    weight = 5.00,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "hei_heist_din_chair_02", 0.0)
    end
}

itemdefs["chair2"] = {
    itemtype = "furniture",
    singular = "Wood Finish Chair",
    multiple = "Wood Finish Chairs",
    weight = 3.50,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "hei_heist_din_chair_03", 0.0)
    end
}

itemdefs["chair3"] = {
    itemtype = "furniture",
    singular = "Grey Fabric Chair",
    multiple = "Grey Fabric Chairs",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "hei_heist_din_chair_05", 0.0)
    end
}

itemdefs["table"] = {
    itemtype = "furniture",
    singular = "Large Dark Wood Dining Table",
    multiple = "Large Dark Wood Dining Tables",
    weight = 13.73,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_din_table_05", 0.0)
    end
}

itemdefs["sofa3"] = {
    itemtype = "furniture",
    singular = "White Corner Sofa",
    multiple = "White Corner Sofas",
    weight = 105.55,
    description = "Super comfy.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_mp_sofa", 0.0)
    end
}

itemdefs["bed3"] = {
    itemtype = "furniture",
    singular = "Black Double Bed",
    multiple = "Black Double Bed",
    weight = 80.00,
    description = "A place to sleep!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_bed_double_08", 0.0)
    end
}

itemdefs["gunlocker"] = {
    itemtype = "furniture",
    singular = "Gun Locker",
    multiple = "Gun Lockers",
    weight = 13.00,
    description = "A place to put firearms!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "bkr_prop_gunlocker_01a", 0.0)
    end
}

itemdefs["shelveunit"] = {
    itemtype = "furniture",
    singular = "Wooden Shelving Unit",
    multiple = "Wooden Shelving Units",
    weight = 50.00,
    description = "A place to put stuff!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_str_shelffloorm_02", 0.0)
    end
}

itemdefs["chair4"] = {
    itemtype = "furniture",
    singular = "Grey Office Seat",
    multiple = "Grey Office Seats",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_off_chair_05", 0.0)
    end
}

itemdefs["chair5"] = {
    itemtype = "furniture",
    singular = "Green Skid Chair",
    multiple = "Green Skid Chairs",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_skid_chair_01", 0.4)
    end
}

itemdefs["chair6"] = {
    itemtype = "furniture",
    singular = "Worn Blue Skid Chair",
    multiple = "Worn Blue Skid Chairs",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_skid_chair_02", 0.4)
    end
}

itemdefs["chair7"] = {
    itemtype = "furniture",
    singular = "Patterned Skid Chair",
    multiple = "Patterned Skid Chairs",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_skid_chair_03", 0.4)
    end
}

itemdefs["chair8"] = {
    itemtype = "furniture",
    singular = "Metal Chair",
    multiple = "Metal Chairs",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_chair_01a", 0.0)
    end
}

itemdefs["table2"] = {
    itemtype = "furniture",
    singular = "Large White Dining Table",
    multiple = "Large White Dining Tables",
    weight = 11.20,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_din_table_06", 0.0)
    end
}

itemdefs["bed4"] = {
    itemtype = "furniture",
    singular = "Grey Double Bed",
    multiple = "Grey Double Bed",
    weight = 80.00,
    description = "A place to sleep!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_bed_double_09", 0.0)
    end
}

itemdefs["bed5"] = {
    itemtype = "furniture",
    singular = "Red Triple Bed",
    multiple = "Red Triple Bed",
    weight = 80.00,
    description = "A place to sleep!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_bed_wide_05", 0.0)
    end
}

itemdefs["table3"] = {
    itemtype = "furniture",
    singular = "Rounded Glass Dining Table",
    multiple = "Rounded Glass Dining Tables",
    weight = 11.20,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "hei_heist_din_table_07", 0.0)
    end
}

itemdefs["chair9"] = {
    itemtype = "furniture",
    singular = "Vintage Red Pattern Chair",
    multiple = "Vintage Red Pattern Chairs",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_ret_chair", 0.0)
    end
}

itemdefs["bed6"] = {
    itemtype = "furniture",
    singular = "Black Sideboard Double Bed",
    multiple = "Black Sideboard Double Bed",
    weight = 80.00,
    description = "A place to sleep!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_bed_with_table_02", 0.0)
    end
}

itemdefs["bed7"] = {
    itemtype = "furniture",
    singular = "Grey Triple Bed",
    multiple = "Grey Triple Bed",
    weight = 80.00,
    description = "A place to sleep!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_yacht_bed_01", 0.0)
    end
}

itemdefs["chair10"] = {
    itemtype = "furniture",
    singular = "Vintage Orange Striped Chair",
    multiple = "Vintage Orange Striped Chairs",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_m_l_chair1", 0.0)
    end
}

itemdefs["table4"] = {
    itemtype = "furniture",
    singular = "Large Glass Dining Table 1",
    multiple = "Large Glass Dining Tables 1",
    weight = 11.20,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "hei_heist_din_table_01", 0.0)
    end
}

itemdefs["chair11"] = {
    itemtype = "furniture",
    singular = "Vintage White Pattern Chair",
    multiple = "Vintage White Pattern Chairs",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_ret_chair_white", 0.0)
    end
}

itemdefs["chair12"] = {
    itemtype = "furniture",
    singular = "Wooden Cushioned Dining Chair",
    multiple = "Wooden Cushioned Dining Chairs",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "p_dinechair_01_s", 0.0)
    end
}

itemdefs["chair13"] = {
    itemtype = "furniture",
    singular = "White Wood Dining Chair",
    multiple = "White Wood Dining Chairs",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_tre_chair", 0.45)
    end
}

itemdefs["sofa4"] = {
    itemtype = "furniture",
    singular = "Grey Corner Sofa",
    multiple = "Grey Corner Sofas",
    weight = 105.55,
    description = "Super comfy.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_stn_sofacorn_01", 0.0)
    end
}

itemdefs["bed8"] = {
    itemtype = "furniture",
    singular = "Black Triple Bed",
    multiple = "Black Triple Bed",
    weight = 80.00,
    description = "A place to sleep!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_yacht_bed_02", 0.0)
    end
}

itemdefs["bed9"] = {
    itemtype = "furniture",
    singular = "Vintage Wooden Double Bed",
    multiple = "Vintage Wooden Double Bed",
    weight = 80.00,
    description = "A place to sleep!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "p_mbbed_s", 0.0)
    end
}

itemdefs["bed10"] = {
    itemtype = "furniture",
    singular = "Vintage White Double Bed",
    multiple = "Vintage White Double Bed",
    weight = 80.00,
    description = "A place to sleep!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_mdbed", 0.0)
    end
}

itemdefs["bed11"] = {
    itemtype = "furniture",
    singular = "White and Green Double Bed",
    multiple = "White and Green Double Bed",
    weight = 80.00,
    description = "A place to sleep!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_tre_bed1", 0.0)
    end
}

itemdefs["bed12"] = {
    itemtype = "furniture",
    singular = "Blue Wooden Double Bed",
    multiple = "Blue Wooden Double Bed",
    weight = 80.00,
    description = "A place to sleep!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_tre_bed2", 0.0)
    end
}

itemdefs["bed13"] = {
    itemtype = "furniture",
    singular = "Grey Metal Bed",
    multiple = "Grey Metal Bed",
    weight = 80.00,
    description = "A place to sleep!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "gr_prop_bunker_bed_01", 0.0)
    end
}

itemdefs["bed14"] = {
    itemtype = "furniture",
    singular = "Brown Leather Bed",
    multiple = "Brown Leather Beds",
    weight = 80.00,
    description = "A place to sleep!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "ex_prop_exec_bed_01", 0.0)
    end
}

itemdefs["bed15"] = {
    itemtype = "furniture",
    singular = "Green Military Bed",
    multiple = "Green Military Beds",
    weight = 80.00,
    description = "A place to sleep!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "bkr_prop_biker_campbed_01", 0.0)
    end
}

itemdefs["bed16"] = {
    itemtype = "furniture",
    singular = "Red Sleeping Bed",
    multiple = "Red Sleeping Beds",
    weight = 80.00,
    description = "A place to sleep!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_skid_sleepbag_1", 0.1)
    end
}

itemdefs["chair14"] = {
    itemtype = "furniture",
    singular = "Used Wooden Chair",
    multiple = "Used Wooden Chairs",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_chair_07", 0.0)
    end
}

itemdefs["chair15"] = {
    itemtype = "furniture",
    singular = "Wooden Dining Chair",
    multiple = "Wooden Dining Chairs",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_clown_chair", 0.0)
    end
}

itemdefs["chair16"] = {
    itemtype = "furniture",
    singular = "Outdoors Wooden Chair 1",
    multiple = "Outdoors Wooden Chairs 1",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_table_01_chr_b", 0.5)
    end
}

itemdefs["sofa5"] = {
    itemtype = "furniture",
    singular = "Dark Grey Corner Sofa",
    multiple = "Dark Grey Corner Sofas",
    weight = 105.55,
    description = "Super comfy.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_stn_sofacorn_09", 0.0)
    end
}

itemdefs["chair17"] = {
    itemtype = "furniture",
    singular = "Outdoors Wooden Chair 2",
    multiple = "Outdoors Wooden Chairs 2",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_table_02_chr", 0.0)
    end
}

itemdefs["sofa6"] = {
    itemtype = "furniture",
    singular = "Blue and Grey Corner Sofa",
    multiple = "Blue and Grey Corner Sofas",
    weight = 105.55,
    description = "Super comfy.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_stn_sofacorn_05", 0.0)
    end
}

itemdefs["sofa7"] = {
    itemtype = "furniture",
    singular = "Blue Grey Corner Sofa",
    multiple = "Blue Grey Corner Sofas",
    weight = 105.55,
    description = "Super comfy.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "hei_heist_stn_sofacorn_05", 0.0)
    end
}

itemdefs["sofa8"] = {
    itemtype = "furniture",
    singular = "Blue and Black Corner Sofa",
    multiple = "Blue and Black Corner Sofas",
    weight = 105.55,
    description = "Super comfy.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_stn_sofacorn_07", 0.0)
    end
}

itemdefs["sofa9"] = {
    itemtype = "furniture",
    singular = "Green Corner Sofa",
    multiple = "Green Corner Sofas",
    weight = 105.55,
    description = "Super comfy.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_stn_sofacorn_06", 0.0)
    end
}

itemdefs["sofa10"] = {
    itemtype = "furniture",
    singular = "White and Red Corner Sofa",
    multiple = "White and Red Corner Sofas",
    weight = 105.55,
    description = "Super comfy.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_stn_sofacorn_10", 0.0)
    end
}

itemdefs["sofa11"] = {
    itemtype = "furniture",
    singular = "Large Cream and Wood Sofa",
    multiple = "Large Cream and Wood Sofas",
    weight = 90.00,
    description = "Super comfy.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_yacht_sofa_01", 0.0)
    end
}

itemdefs["sofa12"] = {
    itemtype = "furniture",
    singular = "Brown Leather Sofa",
    multiple = "Brown Leather Sofas",
    weight = 70.00,
    description = "Super comfy.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_yacht_sofa_02", 0.0)
    end
}

itemdefs["sofa13"] = {
    itemtype = "furniture",
    singular = "Black Leather Sofa",
    multiple = "Black Leather Sofas",
    weight = 70.00,
    description = "Super comfy.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "bkr_prop_clubhouse_sofa_01a", 0.0)
    end
}

itemdefs["sofa14"] = {
    itemtype = "furniture",
    singular = "Black Modern Sofa",
    multiple = "Black Modern Sofas",
    weight = 60.00,
    description = "Super comfy.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "ex_mp_h_off_sofa_02", 0.0)
    end
}

itemdefs["sofa15"] = {
    itemtype = "furniture",
    singular = "Grey Modern Sofa",
    multiple = "Grey Modern Sofas",
    weight = 60.00,
    description = "Super comfy.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "ex_mp_h_off_sofa_003", 0.0)
    end
}

itemdefs["sofa16"] = {
    itemtype = "furniture",
    singular = "White Modern Sofa",
    multiple = "White Modern Sofas",
    weight = 60.00,
    description = "Super comfy.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "ex_mp_h_off_sofa_01", 0.0)
    end
}

itemdefs["sofa17"] = {
    itemtype = "furniture",
    singular = "White Love Seat Modern Sofa",
    multiple = "White Love Seat Modern Sofas",
    weight = 60.00,
    description = "Super comfy.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_stn_sofa2seat_02", 0.0)
    end
}

itemdefs["sofa18"] = {
    itemtype = "furniture",
    singular = "Vintage Cream Sofa",
    multiple = "Vintage Cream Sofas",
    weight = 60.00,
    description = "Super comfy.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_m_h_sofa", 0.0)
    end
}

itemdefs["sofa19"] = {
    itemtype = "furniture",
    singular = "Vintage Pattern Sofa",
    multiple = "Vintage Pattern Sofas",
    weight = 60.00,
    description = "Super comfy.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "p_res_sofa_l_s", 0.0)
    end
}

itemdefs["sofa20"] = {
    itemtype = "furniture",
    singular = "Grey Day Sofa",
    multiple = "Grey Day Sofas",
    weight = 60.00,
    description = "Super comfy.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "hei_heist_stn_sofa3seat_01", 0.0)
    end
}

itemdefs["sofa21"] = {
    itemtype = "furniture",
    singular = "3 Seat Brown Sofa",
    multiple = "3 Seat Brown Sofas",
    weight = 60.00,
    description = "Super comfy.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "hei_heist_stn_sofa3seat_02", 0.0)
    end
}

itemdefs["sofa22"] = {
    itemtype = "furniture",
    singular = "3 Seat Grey Sofa",
    multiple = "3 Seat Grey Sofas",
    weight = 60.00,
    description = "Super comfy.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "hei_heist_stn_sofa3seat_06", 0.0)
    end
}

itemdefs["sofa23"] = {
    itemtype = "furniture",
    singular = "Cream Brown Yellow Pattern Sofa",
    multiple = "Cream Brown Yellow Pattern Sofas",
    weight = 60.00,
    description = "Super comfy.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_couch_01", 0.0)
    end
}

itemdefs["sofa24"] = {
    itemtype = "furniture",
    singular = "Brown Yellow Pattern Sofa",
    multiple = "Brown Yellow Pattern Sofas",
    weight = 60.00,
    description = "Super comfy.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_couch_03", 0.0)
    end
}

itemdefs["sofa25"] = {
    itemtype = "furniture",
    singular = "Wide Modern White Sofa",
    multiple = "Wide Modern White Sofas",
    weight = 60.00,
    description = "Super comfy.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_couch_lg_07", 0.0)
    end
}

itemdefs["sofa26"] = {
    itemtype = "furniture",
    singular = "Grandma's Used Sofa",
    multiple = "Grandma's Used Sofas",
    weight = 60.00,
    description = "Super comfy.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "miss_rub_couch_01", 0.0)
    end
}

itemdefs["sofa27"] = {
    itemtype = "furniture",
    singular = "Used Striped Green Sofa",
    multiple = "Used Striped Green Sofas",
    weight = 60.00,
    description = "Super comfy.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_ld_farm_couch02", 0.5)
    end
}

itemdefs["sofa28"] = {
    itemtype = "furniture",
    singular = "Brown Leather Bench",
    multiple = "Brown Leather Benches",
    weight = 60.00,
    description = "Super comfy.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_fib_3b_bench", 0.0)
    end
}

itemdefs["sofa29"] = {
    itemtype = "furniture",
    singular = "Black Leather Bench",
    multiple = "Black Leather Benches",
    weight = 60.00,
    description = "Super comfy.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_wait_bench_01", 0.0)
    end
}

itemdefs["tvunit"] = {
    itemtype = "furniture",
    singular = "Large Wooden TV Unit",
    multiple = "Large Wooden TV Units",
    weight = 150.00,
    description = "Very high definition.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_str_avunitl_01_b", 0.0)
    end
}

itemdefs["tvunit2"] = {
    itemtype = "furniture",
    singular = "Large White TV Unit",
    multiple = "Large White TV Units",
    weight = 150.00,
    description = "Very high definition.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_str_avunitl_04", 0.0)
    end
}

itemdefs["tvunit3"] = {
    itemtype = "furniture",
    singular = "Metal TV Unit",
    multiple = "Metal TV Units",
    weight = 130.00,
    description = "Very high definition.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_str_avunits_04", 0.0)
    end
}

itemdefs["tvunit4"] = {
    itemtype = "furniture",
    singular = "White TV Unit",
    multiple = "White TV Units",
    weight = 130.00,
    description = "Very high definition.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "hei_heist_str_avunitl_03", 0.0)
    end
}

itemdefs["tvunit5"] = {
    itemtype = "furniture",
    singular = "Large TV",
    multiple = "Large TV",
    weight = 50.00,
    description = "Very high definition.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "des_tvsmash_start", 0.8)
    end
}

itemdefs["tvunit6"] = {
    itemtype = "furniture",
    singular = "CRT TV",
    multiple = "CRT TV",
    weight = 5.50,
    description = "For the good shows and movies.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_tv_03", 0.3)
    end
}

itemdefs["tvunit7"] = {
    itemtype = "furniture",
    singular = "Vintage TV",
    multiple = "Vintage TV",
    weight = 5.50,
    description = "For the good shows and movies.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_tv_05", 0.17)
    end
}

itemdefs["jukebox"] = {
    itemtype = "furniture",
    singular = "Large Jukebox",
    multiple = "Large Jukeboxes",
    weight = 25.00,
    description = "For the good music.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "bkr_prop_clubhouse_jukebox_01b", 0.0)
    end
}

itemdefs["jukebox2"] = {
    itemtype = "furniture",
    singular = "Medium Jukebox",
    multiple = "Medium Jukeboxes",
    weight = 21.00,
    description = "For the good music.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "bkr_prop_clubhouse_jukebox_01a", -0.1)
    end
}

itemdefs["jukebox3"] = {
    itemtype = "furniture",
    singular = "Vintage Jukebox",
    multiple = "Vintage Jukeboxes",
    weight = 21.00,
    description = "For the good music.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "bkr_prop_clubhouse_jukebox_02a", 0.0)
    end
}

itemdefs["tvunit8"] = {
    itemtype = "furniture",
    singular = "Large Wall TV",
    multiple = "Large Wall TV",
    weight = 21.00,
    description = "For the good shows and movies.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_tv_flat_01", -0.1)
    end
}

itemdefs["tvunit9"] = {
    itemtype = "furniture",
    singular = "Medium TV",
    multiple = "Medium TV",
    weight = 19.00,
    description = "For the good shows and movies.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_tv_flat_michael", 0.0)
    end
}

itemdefs["djdeck"] = {
    itemtype = "furniture",
    singular = "DJ Deck",
    multiple = "DJ Decks",
    weight = 5.00,
    description = "Play some good music.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_dj_deck_02", 0.07)
    end
}

itemdefs["ifruitcomputer"] = {
    itemtype = "furniture",
    singular = "iFruit Computer",
    multiple = "iFruit Computer",
    weight = 4.00,
    description = "Browse the web!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "ex_prop_monitor_01_ex", 0.08)
    end
}

itemdefs["pcmonitor"] = {
    itemtype = "furniture",
    singular = "PC Monitor",
    multiple = "PC Monitors",
    weight = 1.50,
    description = "144hz or nothing!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_monitor_w_large", 0.0)
    end
}

itemdefs["pctower"] = {
    itemtype = "furniture",
    singular = "PC Tower",
    multiple = "PC Towers",
    weight = 2.75,
    description = "This better be powered by AMD.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_dyn_pc_02", 0.28)
    end
}

itemdefs["keyboard"] = {
    itemtype = "furniture",
    singular = "Keyboard",
    multiple = "Keyboards",
    weight = 0.55,
    description = "RGB or no RGB?",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "hei_prop_hei_cs_keyboard", 0.01)
    end
}

itemdefs["moneycounter"] = {
    itemtype = "furniture",
    singular = "Money Counter",
    multiple = "Money Counters",
    weight = 1.95,
    description = "A money counter.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "bkr_prop_money_counter", 0.0)
    end
}

itemdefs["officephone"] = {
    itemtype = "furniture",
    singular = "Office Phone",
    multiple = "Office Phones",
    weight = 0.70,
    description = "An office phone.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_office_phone_tnt", 0.05)
    end
}

itemdefs["greenphone"] = {
    itemtype = "furniture",
    singular = "Green Phone",
    multiple = "Green Phones",
    weight = 0.75,
    description = "An green phone.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_acc_phone_01", 0.0)
    end
}

itemdefs["printer"] = {
    itemtype = "furniture",
    singular = "Printer",
    multiple = "Printers",
    weight = 2.55,
    description = "A printer.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_printer_02", 0.0)
    end
}

itemdefs["shreddermachine"] = {
    itemtype = "furniture",
    singular = "Paper Shredder Machine",
    multiple = "Paper Shredder Machine",
    weight = 3.20,
    description = "A Paper Shredder Machine.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_shredder_01", 0.0)
    end
}

itemdefs["copymachine"] = {
    itemtype = "furniture",
    singular = "Photocopier Machine",
    multiple = "Photocopier Machine",
    weight = 12.00,
    description = "A Photocopier Machine.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_copier_01", 0.0)
    end
}

itemdefs["securitycamera"] = {
    itemtype = "furniture",
    singular = "Security Camera",
    multiple = "Security Cameras",
    weight = 3.00,
    description = "A Security Camera.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "hei_prop_bank_cctv_01", 0.0)
    end
}

itemdefs["speakerdock"] = {
    itemtype = "furniture",
    singular = "Phone Speaker Dock",
    multiple = "Phone Speaker Docks",
    weight = 0.50,
    description = "A Phone Speaker Dock.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_mp3_dock", 0.07)
    end
}

itemdefs["smallspeaker"] = {
    itemtype = "furniture",
    singular = "Small Black Speaker",
    multiple = "Small Black Speaker",
    weight = 0.55,
    description = "A Small Black Speaker.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_speaker_06", 0.27)
    end
}

itemdefs["largespeaker"] = {
    itemtype = "furniture",
    singular = "Large Wooden Speaker",
    multiple = "Large Wooden Speaker",
    weight = 1.10,
    description = "A Large Wooden Speaker.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_speaker_03", 0.0)
    end
}

itemdefs["largespeaker2"] = {
    itemtype = "furniture",
    singular = "Large Black Speaker",
    multiple = "Large Black Speaker",
    weight = 1.10,
    description = "A Large Black Speaker.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_speaker_07", 0.46)
    end
}

itemdefs["arcademachine"] = {
    itemtype = "furniture",
    singular = "QUB3D Arcade Machine",
    multiple = "QUB3D Arcade Machines",
    weight = 14.00,
    description = "An Arcade Machine.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_arcade_01", 0.9)
    end
}

itemdefs["deskfan"] = {
    itemtype = "furniture",
    singular = "Desk Fan",
    multiple = "Desk Fans",
    weight = 0.50,
    description = "A Desk Fan.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "gr_prop_bunker_deskfan_01a", 0.0)
    end
}

itemdefs["floorfan"] = {
    itemtype = "furniture",
    singular = "Floor Fan",
    multiple = "Floor Fans",
    weight = 1.30,
    description = "A Floor Fan.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "bkr_prop_weed_fan_floor_01a", 0.0)
    end
}

itemdefs["whiteboxfan"] = {
    itemtype = "furniture",
    singular = "White Box Fan",
    multiple = "White Box Fans",
    weight = 1.45,
    description = "A White Box Fan.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_fa_fan", 0.4)
    end
}

itemdefs["chair18"] = {
    itemtype = "furniture",
    singular = "Simplistic Wooden Chair 1",
    multiple = "Simplistic Wooden Chairs 1",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_chair_04a", 0.0)
    end
}

itemdefs["chair19"] = {
    itemtype = "furniture",
    singular = "Simplistic Wooden Chair 2",
    multiple = "Simplistic Wooden Chairs 2",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "bkr_prop_weed_chair_01a", 0.0)
    end
}

itemdefs["chair20"] = {
    itemtype = "furniture",
    singular = "Simplistic White Chair",
    multiple = "Simplistic White Chairs",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_chair_04b", 0.0)
    end
}

itemdefs["chair21"] = {
    itemtype = "furniture",
    singular = "Black Executive Desk Chair",
    multiple = "Black Executive Desk Chairs",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "ex_prop_offchair_exec_04", 0.6)
    end
}

itemdefs["chair22"] = {
    itemtype = "furniture",
    singular = "Black Bucket Chair",
    multiple = "Black Bucket Chairs",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_stn_chairarm_12", 0.0)
    end
}

itemdefs["chair23"] = {
    itemtype = "furniture",
    singular = "Yellow Desk Chair",
    multiple = "Yellow Desk Chairs",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_stn_chairarm_13", 0.0)
    end
}

itemdefs["chair24"] = {
    itemtype = "furniture",
    singular = "Black Desk Chair 1",
    multiple = "Black Desk Chairs 1",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "ex_prop_offchair_exec_01", 0.6)
    end
}

itemdefs["chair25"] = {
    itemtype = "furniture",
    singular = "Black Desk Chair 2",
    multiple = "Black Desk Chairs 2",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_ret_gc_chair03", 0.7)
    end
}

itemdefs["chair26"] = {
    itemtype = "furniture",
    singular = "Black Desk Chair 3",
    multiple = "Black Desk Chairs 3",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "bkr_prop_biker_boardchair01", 0.6)
    end
}

itemdefs["chair27"] = {
    itemtype = "furniture",
    singular = "Brown Leather Desk Chair",
    multiple = "Brown Leather Desk Chairs",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_ilev_leath_chr", 0.0)
    end
}

itemdefs["chair28"] = {
    itemtype = "furniture",
    singular = "Used Desk Chair",
    multiple = "Used Desk Chairs",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_off_chair_03", 0.0)
    end
}

itemdefs["chair28"] = {
    itemtype = "furniture",
    singular = "Used Desk Chair",
    multiple = "Used Desk Chairs",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_off_chair_03", 0.0)
    end
}

itemdefs["chair29"] = {
    itemtype = "furniture",
    singular = "Rounded White Modern Stool",
    multiple = "Rounded White Modern Stools",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_din_stool_04", 0.0)
    end
}

itemdefs["chair30"] = {
    itemtype = "furniture",
    singular = "Padded White Modern Stool",
    multiple = "Padded White Modern Stools",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "bkr_prop_biker_barstool_02", 0.0)
    end
}

itemdefs["chair31"] = {
    itemtype = "furniture",
    singular = "Vintage Wooden Stool",
    multiple = "Vintage Wooden Stools",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_kitchnstool", 0.0)
    end
}

itemdefs["chair32"] = {
    itemtype = "furniture",
    singular = "Square Grey Stool",
    multiple = "Square Grey Stools",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_fh_kitnstool", 0.0)
    end
}

itemdefs["chair33"] = {
    itemtype = "furniture",
    singular = "Circular Grey Stool",
    multiple = "Circular Grey Stools",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_tre_stool", 0.7)
    end
}

itemdefs["chair34"] = {
    itemtype = "furniture",
    singular = "Circular Brown Leather Stool",
    multiple = "Circular Brown Leather Stools",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_tre_stool_leather", 0.7)
    end
}

--[[itemdefs["chair35"] = {
    itemtype = "furniture",
    singular = "Circular Wooden Stool",
    multiple = "Circular Wooden Stools",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "bkr_prop_biker_barstool_03", 0.0)
    end
}]]

itemdefs["chair36"] = {
    itemtype = "furniture",
    singular = "Wood and Black Stool",
    multiple = "Wood and Black Stools",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "ba_prop_int_edgy_stool", 0.0)
    end
}

itemdefs["chair37"] = {
    itemtype = "furniture",
    singular = "Black and Gold Stool",
    multiple = "Black and Gold Stools",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "ba_prop_int_glam_stool", 0.0)
    end
}

itemdefs["chair38"] = {
    itemtype = "furniture",
    singular = "Grey Cube Pouf",
    multiple = "Grey Cube Poufs",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_fh_pouf", 0.28)
    end
}

itemdefs["chair39"] = {
    itemtype = "furniture",
    singular = "Cream Round Pouf",
    multiple = "Cream Round Poufs",
    weight = 3.10,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_yacht_stool_01", 0.0)
    end
}

itemdefs["chair40"] = {
    itemtype = "furniture",
    singular = "Small Black Stool",
    multiple = "Small Black Stools",
    weight = 2.00,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_stn_chairstool_12", 0.0)
    end
}

itemdefs["chair41"] = {
    itemtype = "furniture",
    singular = "Grey Table Stool",
    multiple = "Grey Table Stools",
    weight = 5.00,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_stn_foot_stool_01", 0.0)
    end
}

itemdefs["chair42"] = {
    itemtype = "furniture",
    singular = "White Table Stool",
    multiple = "White Table Stools",
    weight = 5.00,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_stn_foot_stool_02", 0.0)
    end
}

itemdefs["chair43"] = {
    itemtype = "furniture",
    singular = "Black Day Chair",
    multiple = "Black Day Chairs",
    weight = 6.00,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_stn_sofa_daybed_02", 0.0)
    end
}

itemdefs["chair44"] = {
    itemtype = "furniture",
    singular = "Beige Day Chair",
    multiple = "Beige Day Chairs",
    weight = 7.50,
    description = "A thing to sit on!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_stn_sofa_daybed_01", 0.0)
    end
}

itemdefs["cleaningtrolly"] = {
    itemtype = "furniture",
    singular = "Cleaning Trolly",
    multiple = "Cleaning Trollies",
    weight = 5.50,
    description = "A Cleaning Trolly.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_cleaning_trolly", 0.0)
    end
}

itemdefs["bathtub"] = {
    itemtype = "furniture",
    singular = "Bathtub",
    multiple = "Bathtub",
    weight = 45.00,
    description = "A Bathtub.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_bathtub_01", 0.0)
    end
}

itemdefs["bathroomcounter"] = {
    itemtype = "furniture",
    singular = "Bathroom Counter",
    multiple = "Bathroom Counters",
    weight = 65.00,
    description = "A Bathroom Counter.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "p_new_j_counter_02", 0.6)
    end
}

itemdefs["bathroomsink"] = {
    itemtype = "furniture",
    singular = "Bathroom Bowl Sink",
    multiple = "Bathroom Bowl Sinks",
    weight = 5.00,
    description = "A Bathroom Bowl Sink.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_sink_05", 0.1)
    end
}

itemdefs["bathroomsink2"] = {
    itemtype = "furniture",
    singular = "Bathroom Sink",
    multiple = "Bathroom Sinks",
    weight = 9.00,
    description = "A Bathroom Sink.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_sink_06", 0.0)
    end
}

itemdefs["toiletrollholder"] = {
    itemtype = "furniture",
    singular = "Toilet Roll Holder",
    multiple = "Toilet Roll Holders",
    weight = 5.00,
    description = "A Toilet Roll Holder.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_toilet_roll_02", 0.1)
    end
}

itemdefs["medstation"] = {
    itemtype = "furniture",
    singular = "First Aid Cabinet",
    multiple = "First Aid Cabinets",
    weight = 3.00,
    description = "A First Aid Cabinet.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_medstation_01", 0.1)
    end
}

itemdefs["medstation2"] = {
    itemtype = "furniture",
    singular = "First Aid Cabinet 2",
    multiple = "First Aid Cabinets 2",
    weight = 3.00,
    description = "A First Aid Kit.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_medstation_03", 0.1)
    end
}

itemdefs["medstation3"] = {
    itemtype = "furniture",
    singular = "First Aid Cleaner",
    multiple = "First Aid Cleaners",
    weight = 1.00,
    description = "A First Aid Cleaner.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_medstation_04", 0.1)
    end
}

itemdefs["medcabinet"] = {
    itemtype = "furniture",
    singular = "Medicine Cabinet 1",
    multiple = "Medicine Cabinets 1",
    weight = 3.50,
    description = "A Medicine Cabinet.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "p_pharm_unit_01", 0.1)
    end
}

itemdefs["medcabinet2"] = {
    itemtype = "furniture",
    singular = "Medicine Cabinet 2",
    multiple = "Medicine Cabinets 2",
    weight = 3.50,
    description = "A Medicine Cabinet.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "p_pharm_unit_02", 0.1)
    end
}

itemdefs["lightfan"] = {
    itemtype = "furniture",
    singular = "Towel Basket",
    multiple = "Towel Basket",
    weight = 3.50,
    description = "A Towel Basket.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_mlaundry", 0.0)
    end
}

itemdefs["foldedtowels"] = {
    itemtype = "furniture",
    singular = "Folded Towels",
    multiple = "Folded Towels",
    weight = 0.20,
    description = "Some Folded Towels.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_fh_towelstack", 0.13)
    end
}

itemdefs["largetowel"] = {
    itemtype = "furniture",
    singular = "Large Towel",
    multiple = "Large Towels",
    weight = 0.25,
    description = "A large towel.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "p_shower_towel_s", 0.07)
    end
}

itemdefs["pottedplant2"] = {
    itemtype = "furniture",
    singular = "Small Potted Plant",
    multiple = "Small Potted Plants",
    weight = 0.25,
    description = "A Small Potted Plant.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_fa_plant01", 0.2)
    end
}

itemdefs["pottedplant3"] = {
    itemtype = "furniture",
    singular = "Small Potted Succulents",
    multiple = "Small Potted Succulents",
    weight = 0.25,
    description = "Some Small Potted Succulents.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_peyote_highland_02", 0.15)
    end
}

itemdefs["pottedplant4"] = {
    itemtype = "furniture",
    singular = "White Bird Of Paradise Vase",
    multiple = "White Bird Of Paradise Vases",
    weight = 2.00,
    description = "A White Bird Of Paradise Vase.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_ret_ps_flowers_01", 0.0)
    end
}

itemdefs["pottedplant5"] = {
    itemtype = "furniture",
    singular = "White Rose Vase",
    multiple = "White Rose Vases",
    weight = 2.00,
    description = "A White Rose Vase.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_rosevase", 0.0)
    end
}

itemdefs["pottedplant6"] = {
    itemtype = "furniture",
    singular = "Pink Lily Vase",
    multiple = "Pink Lily Vases",
    weight = 2.00,
    description = "A Pink Lily Vase.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_mflowers", 0.0)
    end
}

itemdefs["pottedplant7"] = {
    itemtype = "furniture",
    singular = "Green Bird Of Paradise Vase",
    multiple = "Green Bird Of Paradise Vases",
    weight = 2.00,
    description = "A Green Bird Of Paradise Vase.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_exoticvase", 0.0)
    end
}

itemdefs["pottedplant8"] = {
    itemtype = "furniture",
    singular = "Rubber Plant",
    multiple = "Rubber Plants",
    weight = 2.00,
    description = "A Rubber Plant.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_rubberplant", 0.0)
    end
}

itemdefs["pottedplant9"] = {
    itemtype = "furniture",
    singular = "Ivy Plant",
    multiple = "Ivy Plants",
    weight = 1.00,
    description = "A Ivy Plant.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_ivy", 0.0)
    end
}

itemdefs["pottedplant10"] = {
    itemtype = "furniture",
    singular = "Small House Plant",
    multiple = "Small House Plants",
    weight = 0.50,
    description = "A Small House Plant.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_plant_int_04a", 0.0)
    end
}

itemdefs["pottedplant11"] = {
    itemtype = "furniture",
    singular = "Bonsai Tree",
    multiple = "Bonsai Trees",
    weight = 0.55,
    description = "A Bonsai Tree.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_plant_int_04b", 0.0)
    end
}

itemdefs["pottedplant12"] = {
    itemtype = "furniture",
    singular = "Medium House Plant",
    multiple = "Medium House Plants",
    weight = 0.95,
    description = "A Medium House Plant.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_pot_plant_01a", 0.0)
    end
}

itemdefs["pottedplant13"] = {
    itemtype = "furniture",
    singular = "Large Calla Lily Vase",
    multiple = "Large Calla Lily Vases",
    weight = 0.55,
    description = "A Large Calla Lily Vase.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_acc_vase_flowers_01", 0.0)
    end
}

itemdefs["pottedplant14"] = {
    itemtype = "furniture",
    singular = "Hydrangea Vase",
    multiple = "Hydrangea Vases",
    weight = 0.95,
    description = "A Hydrangea Vase.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_acc_vase_flowers_02", 0.0)
    end
}

itemdefs["pottedplant15"] = {
    itemtype = "furniture",
    singular = "Large Calla Lily Pot",
    multiple = "Large Calla Lily Pots",
    weight = 0.95,
    description = "A Large Calla Lily Pot.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_acc_vase_flowers_03", 0.0)
    end
}

itemdefs["pottedplant16"] = {
    itemtype = "furniture",
    singular = "Chinese Lantern Flower Circular Vase",
    multiple = "Chinese Lantern Flower Circular Vases",
    weight = 0.95,
    description = "A Chinese Lantern Flower Circular Vase.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_acc_vase_flowers_04", 0.0)
    end
}

itemdefs["pottedplant17"] = {
    itemtype = "furniture",
    singular = "Chinese Lantern Flower Vase",
    multiple = "Chinese Lantern Flower Vases",
    weight = 0.95,
    description = "A Chinese Lantern Flower Vase.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "hei_heist_acc_flowers_02", 0.0)
    end
}

itemdefs["pottedplant18"] = {
    itemtype = "furniture",
    singular = "Chinese Lantern Flower Pot",
    multiple = "Chinese Lantern Flower Pots",
    weight = 0.95,
    description = "A Chinese Lantern Flower Pot.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_mvasechinese", 0.0)
    end
}

itemdefs["pottedplant19"] = {
    itemtype = "furniture",
    singular = "Small Calla Lily Vase",
    multiple = "Small Calla Lily Vases",
    weight = 0.95,
    description = "A Small Calla Lily Vase.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "hei_heist_acc_flowers_01", 0.0)
    end
}

itemdefs["pottedplant20"] = {
    itemtype = "furniture",
    singular = "Large Decorative House Plant",
    multiple = "Large Decorative House Plants",
    weight = 1.10,
    description = "A Large Decorative House Plant.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "p_int_jewel_plant_02", 0.2)
    end
}

itemdefs["pottedplant21"] = {
    itemtype = "furniture",
    singular = "Large Tree House Plant",
    multiple = "Large Tree House Plants",
    weight = 0.90,
    description = "A Large Tree House Plant.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_fbibombplant", 0.0)
    end
}

itemdefs["pottedplant22"] = {
    itemtype = "furniture",
    singular = "Large Leaf House Plant",
    multiple = "Large Leaf House Plants",
    weight = 1.30,
    description = "A Large Leaf House Plant.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_pot_plant_05a", 0.0)
    end
}

itemdefs["pottedplant23"] = {
    itemtype = "furniture",
    singular = "Large Palm House Plant",
    multiple = "Large Palm House Plants",
    weight = 1.90,
    description = "A Large Palm House Plant.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_acc_plant_palm_01", 0.0)
    end
}

itemdefs["pottedplant24"] = {
    itemtype = "furniture",
    singular = "Grey Box Snake Plant",
    multiple = "Grey Box Snake Plants",
    weight = 1.90,
    description = "A Grey Box Snake Plant.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_acc_plant_tall_01", 0.0)
    end
}

itemdefs["pottedplant25"] = {
    itemtype = "furniture",
    singular = "Round Pot Snake Plant",
    multiple = "Round Pot Snake Plants",
    weight = 2.10,
    description = "A Round Pot Snake Plant.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_mplanttongue", 0.0)
    end
}

--[[itemdefs["pottedplant26"] = {
    itemtype = "furniture",
    singular = "Tube Pot Snake Plant",
    multiple = "Tube Pot Snake Plants",
    weight = 2.10,
    description = "A Tube Pot Snake Plant.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_med_p_planter", 0.0)
    end
}]]

itemdefs["christmastree"] = {
    itemtype = "furniture",
    singular = "Christmas Tree",
    multiple = "Christmas Trees",
    weight = 2.10,
    description = "A Christmas Tree.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_xmas_tree_int", 0.26)
    end
}

itemdefs["rug"] = {
    itemtype = "furniture",
    singular = "Large Beige Wool Rug",
    multiple = "Large Beige Wool Rugs",
    weight = 0.50,
    description = "A Large Beige Wool Rug.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_acc_rugwooll_03", 0.0)
    end
}

itemdefs["rug2"] = {
    itemtype = "furniture",
    singular = "Large Wool Textured Rug",
    multiple = "Large Wool Textured Rugs",
    weight = 0.50,
    description = "A Large Wool Textured Rug.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_acc_rugwooll_04", 0.0)
    end
}

itemdefs["rug3"] = {
    itemtype = "furniture",
    singular = "Large Cow Skin Rug",
    multiple = "Large Cow Skin Rugs",
    weight = 0.50,
    description = "A Large Cow Skin Rug.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "hei_heist_acc_rughidel_01", 0.0)
    end
}

itemdefs["rug4"] = {
    itemtype = "furniture",
    singular = "Large Orange, Black And White Rug",
    multiple = "Large Orange, Black And White Rugs",
    weight = 0.50,
    description = "A Large Orange, Black And White Rug.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "hei_heist_acc_rugwooll_01", 0.0)
    end
}

itemdefs["rug5"] = {
    itemtype = "furniture",
    singular = "Medium Orange, Black And White Rug",
    multiple = "Medium Orange, Black And White Rugs",
    weight = 0.50,
    description = "A Medium Orange, Black And White Rug.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_acc_rugwoolm_01", 0.0)
    end
}

itemdefs["rug6"] = {
    itemtype = "furniture",
    singular = "Medium Blue, Black And White Rug",
    multiple = "Medium Blue, Black And White Rugs",
    weight = 0.50,
    description = "A Medium Blue, Black And White Rug.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_acc_rugwoolm_02", 0.0)
    end
}

itemdefs["rug7"] = {
    itemtype = "furniture",
    singular = "Medium White To Black Gradient Rug",
    multiple = "Medium White To Black Gradient Rugs",
    weight = 0.50,
    description = "A Medium White To Black Gradient Rug.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_acc_rugwoolm_03", 0.0)
    end
}

itemdefs["rug8"] = {
    itemtype = "furniture",
    singular = "Medium Grey Boxy Rug",
    multiple = "Medium Grey Boxy Rugs",
    weight = 0.50,
    description = "A Medium Grey Boxy Rug.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_acc_rugwoolm_04", 0.0)
    end
}

itemdefs["rug9"] = {
    itemtype = "furniture",
    singular = "Small Grey Circle Pattern Rug",
    multiple = "Small Grey Circle Pattern Rugs",
    weight = 0.50,
    description = "A Small Grey Circle Pattern Rug.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_acc_rugwools_01", 0.0)
    end
}

itemdefs["rug10"] = {
    itemtype = "furniture",
    singular = "Small Cream And Blue Rug",
    multiple = "Small Cream And Blue Rugs",
    weight = 0.50,
    description = "A Small Cream And Blue Rug.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_acc_rugwools_03", 0.0)
    end
}

itemdefs["rug11"] = {
    itemtype = "furniture",
    singular = "Red Yoga Mat",
    multiple = "Red Yoga Mats",
    weight = 0.50,
    description = "A Red Yoga Mat.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "p_yoga_mat_03_s", 0.0)
    end
}

itemdefs["rug12"] = {
    itemtype = "furniture",
    singular = "Grey Yoga Mat",
    multiple = "Grey Yoga Mats",
    weight = 0.50,
    description = "A Grey Yoga Mat.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "p_yoga_mat_02_s", 0.0)
    end
}

itemdefs["rug13"] = {
    itemtype = "furniture",
    singular = "White Towel",
    multiple = "White Towel",
    weight = 0.50,
    description = "A White Towel.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "p_shower_towel_s", 0.0)
    end
}

itemdefs["table5"] = {
    itemtype = "furniture",
    singular = "Large Glass Dining Table 2",
    multiple = "Large Glass Dining Tables 2",
    weight = 11.20,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_din_table_11", 0.0)
    end
}

itemdefs["table6"] = {
    itemtype = "furniture",
    singular = "Medium Glass Dining Table",
    multiple = "Medium Glass Dining Tables",
    weight = 11.20,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "hei_heist_din_table_04", 0.0)
    end
}

itemdefs["table7"] = {
    itemtype = "furniture",
    singular = "Round Wooden Dining Table",
    multiple = "Round Wooden Dining Tables",
    weight = 11.20,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_m_dinetble_replace", 0.0)
    end
}

itemdefs["table8"] = {
    itemtype = "furniture",
    singular = "Round Vintage Wooden Dining Table",
    multiple = "Round Vintage Wooden Dining Tables",
    weight = 11.20,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_m_dinetble", 0.0)
    end
}

itemdefs["table9"] = {
    itemtype = "furniture",
    singular = "Large Grey Coffee Table",
    multiple = "Large Grey Coffee Tables",
    weight = 8.00,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_tab_coffee_05", 0.0)
    end
}

itemdefs["table10"] = {
    itemtype = "furniture",
    singular = "Large Black Coffee Table",
    multiple = "Large Black Coffee Tables",
    weight = 8.00,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_t_coffe_table", 0.2)
    end
}

itemdefs["table11"] = {
    itemtype = "furniture",
    singular = "Medium Concrete Coffee Table",
    multiple = "Medium Concrete Coffee Tables",
    weight = 8.00,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "hei_heist_tab_coffee_06", 0.0)
    end
}

itemdefs["table12"] = {
    itemtype = "furniture",
    singular = "Large Glass Coffee Table",
    multiple = "Large Glass Coffee Tables",
    weight = 8.00,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_t_coffe_table_02", 0.2)
    end
}

--[[itemdefs["table13"] = {
    itemtype = "furniture",
    singular = "Large Metal Glass Coffee Table",
    multiple = "Large Metal Glass Coffee Tables",
    weight = 8.00,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_fh_coftbldisp", 0.0)
    end
}]]

itemdefs["table14"] = {
    itemtype = "furniture",
    singular = "Medium White Coffee Table",
    multiple = "Medium White Coffee Tables",
    weight = 8.00,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_tab_coffee_08", 0.0)
    end
}

--[[itemdefs["table15"] = {
    itemtype = "furniture",
    singular = "Medium Glass Wood Coffee Table",
    multiple = "Medium Glass Wood Coffee Tables",
    weight = 8.00,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_med_p_coffeetable", 0.0)
    end
}]]

itemdefs["table16"] = {
    itemtype = "furniture",
    singular = "Medium Glass Coffee Table 1",
    multiple = "Medium Glass Coffee Tables 1",
    weight = 8.00,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_tab_coffee_07", 0.0)
    end
}

itemdefs["table17"] = {
    itemtype = "furniture",
    singular = "Medium Glass Coffee Table 2",
    multiple = "Medium Glass Coffee Tables 2",
    weight = 8.00,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_tab_sidelrg_02", 0.0)
    end
}

itemdefs["table18"] = {
    itemtype = "furniture",
    singular = "Medium Glass Coffee Table 3",
    multiple = "Medium Glass Coffee Tables 3",
    weight = 8.00,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_tab_sidelrg_01", 0.0)
    end
}

itemdefs["table19"] = {
    itemtype = "furniture",
    singular = "Medium Light Grey Coffee Table",
    multiple = "Medium Light Grey Coffee Tables",
    weight = 8.00,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_fh_coftableb", 0.0)
    end
}

--[[itemdefs["table20"] = {
    itemtype = "furniture",
    singular = "Medium Dark Grey Coffee Table",
    multiple = "Medium Dark Grey Coffee Tables",
    weight = 8.00,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_fh_coftablea", 0.0)
    end
}]]

itemdefs["table21"] = {
    itemtype = "furniture",
    singular = "Small Glass Coffee Table",
    multiple = "Small Glass Coffee Tables",
    weight = 8.00,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_tab_sidelrg_07", 0.0)
    end
}

itemdefs["table22"] = {
    itemtype = "furniture",
    singular = "Stacked Glass Side Table",
    multiple = "Stacked Glass Side Tables",
    weight = 8.00,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_tab_sidesml_01", 0.0)
    end
}

itemdefs["table23"] = {
    itemtype = "furniture",
    singular = "Small Glass Side Table",
    multiple = "Small Glass Side Tables",
    weight = 8.00,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_tab_sidesml_02", 0.0)
    end
}

itemdefs["table24"] = {
    itemtype = "furniture",
    singular = "Round Black Table",
    multiple = "Round Black Tables",
    weight = 8.00,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_tab_sidelrg_04", 0.0)
    end
}

itemdefs["table25"] = {
    itemtype = "furniture",
    singular = "Round Metal Table",
    multiple = "Round Metal Tables",
    weight = 8.00,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_table_07", 0.0)
    end
}

itemdefs["table26"] = {
    itemtype = "furniture",
    singular = "Round Vintage Table",
    multiple = "Round Vintage Tables",
    weight = 8.00,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_msidetblemod", 0.0)
    end
}

itemdefs["table27"] = {
    itemtype = "furniture",
    singular = "Long Glass Side Table",
    multiple = "Long Glass Side Tables",
    weight = 8.00,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "hei_heist_str_sideboards_02", 0.0)
    end
}

itemdefs["table28"] = {
    itemtype = "furniture",
    singular = "Long Wooden Side Table",
    multiple = "Long Wooden Side Tables",
    weight = 8.00,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "ex_prop_ex_console_table_01", 0.0)
    end
}

itemdefs["table29"] = {
    itemtype = "furniture",
    singular = "Long Dark Wooden Side Table",
    multiple = "Long Dark Wooden Side Tables",
    weight = 8.00,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_m_console", 0.0)
    end
}

itemdefs["table30"] = {
    itemtype = "furniture",
    singular = "Small Wooden Table",
    multiple = "Small Wooden Tables",
    weight = 8.00,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "bkr_prop_fakeid_table", 0.0)
    end
}

itemdefs["table31"] = {
    itemtype = "furniture",
    singular = "Small Wooden Side Table",
    multiple = "Small Wooden Side Tables",
    weight = 8.00,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_fbi3_coffee_table", 0.0)
    end
}

itemdefs["table32"] = {
    itemtype = "furniture",
    singular = "Cluttered Wooden Table",
    multiple = "Cluttered Wooden Tables",
    weight = 8.00,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_ld_farm_table02", 0.2)
    end
}

itemdefs["table33"] = {
    itemtype = "furniture",
    singular = "Large Black Conference Table",
    multiple = "Large Black Conference Tables",
    weight = 8.00,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_corp_conftable2", 0.0)
    end
}

itemdefs["table34"] = {
    itemtype = "furniture",
    singular = "White Letter Desk",
    multiple = "White Letter Desks",
    weight = 8.00,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_mddesk", 0.0)
    end
}

itemdefs["table35"] = {
    itemtype = "furniture",
    singular = "White Vanity Desk",
    multiple = "White Vanity Desks",
    weight = 8.00,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_mddresser", 0.0)
    end
}

itemdefs["table36"] = {
    itemtype = "furniture",
    singular = "Vintage Wooden Desk",
    multiple = "Vintage Wooden Desks",
    weight = 8.00,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_mbdresser", 0.0)
    end
}

itemdefs["table37"] = {
    itemtype = "furniture",
    singular = "Black Office Computer Desk",
    multiple = "Black Office Computer Desks",
    weight = 8.00,
    description = "A place to eat!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_corp_officedesk", 0.0)
    end
}

itemdefs["lamp"] = {
    itemtype = "furniture",
    singular = "Angular Black Floor Lamp",
    multiple = "Angular Black Floor Lamps",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_lit_floorlamp_03", 0.0)
    end
}

itemdefs["lamp2"] = {
    itemtype = "furniture",
    singular = "Curved Black Floor Lamp",
    multiple = "Curved Black Floor Lamps",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_lit_floorlamp_06", 0.0)
    end
}

itemdefs["lamp3"] = {
    itemtype = "furniture",
    singular = "Angular White Floor Lamp",
    multiple = "Angular White Floor Lamps",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_floorlamp_b", 0.0)
    end
}

itemdefs["lamp4"] = {
    itemtype = "furniture",
    singular = "Angular Metal Floor Lamp",
    multiple = "Angular Metal Floor Lamps",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_lit_floorlamp_01", 0.0)
    end
}

itemdefs["lamp5"] = {
    itemtype = "furniture",
    singular = "Curved Grey Floor Lamp",
    multiple = "Curved Grey Floor Lamps",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_lit_floorlamp_05", 0.0)
    end
}

itemdefs["lamp6"] = {
    itemtype = "furniture",
    singular = "Grey Floor Lamp",
    multiple = "Grey Floor Lamps",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_floorlamp_c", 0.0)
    end
}

itemdefs["lamp7"] = {
    itemtype = "furniture",
    singular = "Blue Floor Lamp",
    multiple = "Blue Floor Lamps",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_lit_floorlampnight_07", 0.0)
    end
}

itemdefs["lamp8"] = {
    itemtype = "furniture",
    singular = "Cream Floor Lamp",
    multiple = "Cream Floor Lamps",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_lit_floorlampnight_14", 0.0)
    end
}

itemdefs["lamp9"] = {
    itemtype = "furniture",
    singular = "White Floor Lamp",
    multiple = "White Floor Lamps",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_lit_floorlamp_17", 0.0)
    end
}

itemdefs["lamp10"] = {
    itemtype = "furniture",
    singular = "Long Cream Floor Lamp",
    multiple = "Long Cream Floor Lamps",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_floorlamp_a", 0.0)
    end
}

itemdefs["lamp11"] = {
    itemtype = "furniture",
    singular = "Long Pink Floor Lamp",
    multiple = "Long Pink Floor Lamps",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_lit_floorlamp_13", 0.0)
    end
}

itemdefs["lamp12"] = {
    itemtype = "furniture",
    singular = "Spiky White Floor Lamp",
    multiple = "Spiky White Floor Lamps",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_lit_floorlamp_10", 0.0)
    end
}

itemdefs["lamp13"] = {
    itemtype = "furniture",
    singular = "Brown and White Floor Lamp",
    multiple = "Brown and White Floor Lamps",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_yacht_floor_lamp_01", 0.0)
    end
}

itemdefs["lamp14"] = {
    itemtype = "furniture",
    singular = "Tilted Cream Floor Lamp",
    multiple = "Tilted Cream Floor Lamps",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "hei_heist_lit_floorlamp_04", 0.0)
    end
}

itemdefs["lamp15"] = {
    itemtype = "furniture",
    singular = "Cream Squared Table Lamp",
    multiple = "Cream Squared Table Lamps",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_lit_lamptable_04", 0.0)
    end
}

itemdefs["lamp16"] = {
    itemtype = "furniture",
    singular = "White Squared Table Lamp",
    multiple = "White Squared Table Lamps",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_lit_lamptable_005", 0.0)
    end
}

itemdefs["lamp17"] = {
    itemtype = "furniture",
    singular = "Brown and White Table Lamp",
    multiple = "Brown and White Table Lamps",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_yacht_table_lamp_02", 0.0)
    end
}

itemdefs["lamp18"] = {
    itemtype = "furniture",
    singular = "Small Black and White Table Lamp",
    multiple = "Small Black and White Table Lamps",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_lit_lamptable_21", 0.0)
    end
}

itemdefs["lamp19"] = {
    itemtype = "furniture",
    singular = "Black and White Spherical Table Lamp",
    multiple = "Black and White Spherical Table Lamps",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "hei_heist_lit_lamptable_06", 0.0)
    end
}

itemdefs["lamp20"] = {
    itemtype = "furniture",
    singular = "Paper Lantern Table Lamp",
    multiple = "Paper Lantern Table Lamps",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_lit_lamptable_17", 0.0)
    end
}

itemdefs["lamp21"] = {
    itemtype = "furniture",
    singular = "Tilted Cream Table Lamp",
    multiple = "Tilted Cream Table Lamps",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "hei_heist_lit_lamptable_03", 0.0)
    end
}

itemdefs["lamp22"] = {
    itemtype = "furniture",
    singular = "White Table Lamp",
    multiple = "White Table Lamps",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_lit_lamptablenight_16", 0.0)
    end
}

itemdefs["lamp23"] = {
    itemtype = "furniture",
    singular = "Black Table Lamp",
    multiple = "Black Table Lamps",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_lit_lamptablenight_24", 0.0)
    end
}

itemdefs["lamp24"] = {
    itemtype = "furniture",
    singular = "Brown Table Lamp",
    multiple = "Brown Table Lamps",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_lit_lamptable_09", 0.0)
    end
}

itemdefs["lamp25"] = {
    itemtype = "furniture",
    singular = "Small Brown Table Lamp",
    multiple = "Small Brown Table Lamps",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_j_tablelamp2", 0.0)
    end
}

itemdefs["lamp26"] = {
    itemtype = "furniture",
    singular = "Wide Brown Table Lamp",
    multiple = "Wide Brown Table Lamps",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_j_tablelamp1", 0.0)
    end
}

itemdefs["lamp27"] = {
    itemtype = "furniture",
    singular = "Vintage Cream Table Lamp",
    multiple = "Vintage Cream Table Lamps",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_m_lamptbl", 0.0)
    end
}

itemdefs["candle"] = {
    itemtype = "furniture",
    singular = "Black and Red Candle",
    multiple = "Black and Red Candles",
    weight = 0.55,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_m_candle", 0.0)
    end
}

itemdefs["candle2"] = {
    itemtype = "furniture",
    singular = "Vintage White Candle",
    multiple = "Vintage White Candles",
    weight = 1.85,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_m_candlelrg", 0.0)
    end
}

itemdefs["lamp28"] = {
    itemtype = "furniture",
    singular = "Green Desk Lamp",
    multiple = "Green Desk Lamps",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "hei_prop_hei_bnk_lamp_01", 0.2)
    end
}

itemdefs["lamp29"] = {
    itemtype = "furniture",
    singular = "White Desk Lamp",
    multiple = "White Desk Lamps",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_lit_lamptable_14", 0.0)
    end
}

itemdefs["lamp30"] = {
    itemtype = "furniture",
    singular = "Black Desk Lamp",
    multiple = "Black Desk Lamps",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_lit_lamptable_02", 0.0)
    end
}

itemdefs["lamp31"] = {
    itemtype = "furniture",
    singular = "Orange Ceiling Light",
    multiple = "Orange Ceiling Lights",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "hei_heist_lit_lightpendant_02", 0.0)
    end
}

itemdefs["lamp32"] = {
    itemtype = "furniture",
    singular = "Black Ceiling Light",
    multiple = "Black Ceiling Lights",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_lit_lightpendant_05", 0.0)
    end
}

itemdefs["lamp33"] = {
    itemtype = "furniture",
    singular = "Wooden Ceiling Light",
    multiple = "Wooden Ceiling Lights",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_lit_lightpendant_05b", 0.0)
    end
}

itemdefs["lamp34"] = {
    itemtype = "furniture",
    singular = "Cream Squared Ceiling Light",
    multiple = "Cream Squared Ceiling Lights",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_lit_lightpendant_01", 0.0)
    end
}

itemdefs["lamp35"] = {
    itemtype = "furniture",
    singular = "Ceiling Fan Light",
    multiple = "Ceiling Fan Lights",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "bkr_prop_biker_ceiling_fan_base", 0.0)
    end
}

itemdefs["lamp36"] = {
    itemtype = "furniture",
    singular = "Metal Ceiling Light",
    multiple = "Metal Ceiling Lights",
    weight = 5.00,
    description = "So light it up up up!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_oldlight_01c", 0.0)
    end
}

itemdefs["bluebin"] = {
    itemtype = "furniture",
    singular = "Blue Bin",
    multiple = "Blue Bins",
    weight = 1.00,
    description = "A Blue Bin.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "hei_heist_kit_bin_01", 0.0)
    end
}

itemdefs["orangebin"] = {
    itemtype = "furniture",
    singular = "Orange Bin",
    multiple = "Orange Bins",
    weight = 1.00,
    description = "A Orange Bin.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_bin_10b", 0.0)
    end
}

itemdefs["fridge"] = {
    itemtype = "furniture",
    singular = "Small Drinks Fridge",
    multiple = "Small Drinks Fridge",
    weight = 5.50,
    description = "A Small Drinks Fridge.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_bar_fridge_03", 0.0)
    end
}

itemdefs["fridge2"] = {
    itemtype = "furniture",
    singular = "Double Drinks Fridge",
    multiple = "Double Drinks Fridge",
    weight = 8.50,
    description = "A Double Drinks Fridge.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_bar_fridge_04", 0.0)
    end
}

itemdefs["fridge3"] = {
    itemtype = "furniture",
    singular = "Large Drinks Fridge",
    multiple = "Large Drinks Fridge",
    weight = 8.50,
    description = "A Large Drinks Fridge.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_bar_fridge_01", 0.0)
    end
}

itemdefs["fryer"] = {
    itemtype = "furniture",
    singular = "Industrial Fryer",
    multiple = "Industrial Fryer",
    weight = 30.00,
    description = "An Industrial Fryer.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_chip_fryer", 0.0)
    end
}

itemdefs["cooker"] = {
    itemtype = "furniture",
    singular = "Industrial Cooker",
    multiple = "Industrial Cooker",
    weight = 20.00,
    description = "An Industrial Cooker.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_cooker_03", 0.0)
    end
}

itemdefs["icecooler"] = {
    itemtype = "furniture",
    singular = "Industrial Ice Cooler",
    multiple = "Industrial Ice Cooler",
    weight = 20.00,
    description = "An Industrial Ice Cooler.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_bar_ice_01", 0.0)
    end
}

itemdefs["industrialsink"] = {
    itemtype = "furniture",
    singular = "Industrial Sink",
    multiple = "Industrial Sinks",
    weight = 20.00,
    description = "An Industrial Sink.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_ff_sink_02", 0.0)
    end
}

itemdefs["smallindustrialsink"] = {
    itemtype = "furniture",
    singular = "Kitchen Sink",
    multiple = "Kitchen Sinks",
    weight = 20.00,
    description = "A Kitchen Sink.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_sink_02", 0.0)
    end
}

itemdefs["fridge4"] = {
    itemtype = "furniture",
    singular = "Industrial Fridge",
    multiple = "Industrial Fridge",
    weight = 8.50,
    description = "An Industrial Fridge.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_fridge_01", 0.15)
    end
}

itemdefs["fridge5"] = {
    itemtype = "furniture",
    singular = "White Fridge",
    multiple = "White Fridge",
    weight = 8.50,
    description = "A White Fridge.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_fridge_03", 0.0)
    end
}

itemdefs["washer"] = {
    itemtype = "furniture",
    singular = "Washer",
    multiple = "Washers",
    weight = 8.50,
    description = "A Washer.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_washer_02", 0.5)
    end
}

itemdefs["washer2"] = {
    itemtype = "furniture",
    singular = "Used Washer",
    multiple = "Used Washers",
    weight = 8.50,
    description = "A Used Washer.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_washer_03", 0.0)
    end
}

itemdefs["dryer"] = {
    itemtype = "furniture",
    singular = "Industrial Dryer",
    multiple = "Industrial Dryer",
    weight = 15.00,
    description = "An Industrial Dryer.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "dlc_gtao_heist_planning_board_heist_board_print", 0.0)
    end
}

itemdefs["juicer"] = {
    itemtype = "furniture",
    singular = "Juicer",
    multiple = "Juicer",
    weight = 0.80,
    description = "A Juicer.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "p_kitch_juicer_s", 0.1)
    end
}

itemdefs["kettle"] = {
    itemtype = "furniture",
    singular = "White Kettle",
    multiple = "White Kettle",
    weight = 0.80,
    description = "A White Kettle.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_cs_kettle_01", 0.07)
    end
}

itemdefs["kettle2"] = {
    itemtype = "furniture",
    singular = "Grey Kettle",
    multiple = "Grey Kettle",
    weight = 0.80,
    description = "A Grey Kettle.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_kettle", 0.0)
    end
}

itemdefs["coffeemachine"] = {
    itemtype = "furniture",
    singular = "Coffee Machine",
    multiple = "Coffee Machine",
    weight = 0.95,
    description = "A Coffee Machine.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_coffee_mac_02", 0.24)
    end
}

itemdefs["coffeemachine2"] = {
    itemtype = "furniture",
    singular = "Industrial Coffee Machine",
    multiple = "Industrial Coffee Machine",
    weight = 0.95,
    description = "An Industrial Coffee Machine.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_coffee_mac_01", 0.2)
    end
}

itemdefs["juicedispenser"] = {
    itemtype = "furniture",
    singular = "Juice Dispenser",
    multiple = "Juice Dispenser",
    weight = 0.95,
    description = "A Juice Dispenser.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_juice_dispenser", 0.0)
    end
}

itemdefs["slushdispenser"] = {
    itemtype = "furniture",
    singular = "Slush Dispenser",
    multiple = "Slush Dispenser",
    weight = 0.95,
    description = "A Slush Dispenser.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_slush_dispenser", 0.0)
    end
}

itemdefs["sodadispenser"] = {
    itemtype = "furniture",
    singular = "Soda Dispenser 1",
    multiple = "Soda Dispenser 1",
    weight = 1.05,
    description = "A Soda Dispenser.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_food_bs_soda_01", 0.0)
    end
}

itemdefs["sodadispenser2"] = {
    itemtype = "furniture",
    singular = "Soda Dispenser 2",
    multiple = "Soda Dispenser 2",
    weight = 1.05,
    description = "A Soda Dispenser.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_food_cb_soda_01", 0.0)
    end
}

itemdefs["gumballmachine"] = {
    itemtype = "furniture",
    singular = "Candy Machine",
    multiple = "Candy Machine",
    weight = 2.00,
    description = "A Candy Machine.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_gumball_01", 0.0)
    end
}

itemdefs["watercooler"] = {
    itemtype = "furniture",
    singular = "Water Cooler",
    multiple = "Water Cooler",
    weight = 2.00,
    description = "A Water Cooler.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_watercooler", 0.0)
    end
}

itemdefs["liquorshelf"] = {
    itemtype = "furniture",
    singular = "Liquor Collection Shelf",
    multiple = "Liquor Collection Shelves",
    weight = 5.30,
    description = "A Liquor Collection Shelf.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_ret_ml_liqshelfc", 0.95)
    end
}

itemdefs["microwave"] = {
    itemtype = "furniture",
    singular = "White Microwave",
    multiple = "White Microwaves",
    weight = 0.90,
    description = "A White Microwave.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_micro_02", 0.1)
    end
}

itemdefs["microwave2"] = {
    itemtype = "furniture",
    singular = "Grey Microwave",
    multiple = "Grey Microwaves",
    weight = 0.90,
    description = "A Grey Microwave.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_microwave_1", 0.0)
    end
}

itemdefs["microwave3"] = {
    itemtype = "furniture",
    singular = "Vintage Microwave",
    multiple = "Vintage Microwaves",
    weight = 0.90,
    description = "A Vintage Microwave.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_micro_04", 0.07)
    end
}

itemdefs["toaster"] = {
    itemtype = "furniture",
    singular = "White Toaster",
    multiple = "White Toasters",
    weight = 0.90,
    description = "A White Toaster.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_toaster_02", 0.0)
    end
}

itemdefs["toaster2"] = {
    itemtype = "furniture",
    singular = "Cream Toaster",
    multiple = "Cream Toasters",
    weight = 0.90,
    description = "A Cream Toaster.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_toaster_01", 0.15)
    end
}

itemdefs["kitchenmixer"] = {
    itemtype = "furniture",
    singular = "Kitchen Mixer",
    multiple = "Kitchen Mixers",
    weight = 0.90,
    description = "A Kitchen Mixer.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_tre_mixer", 0.22)
    end
}

itemdefs["choppingboard"] = {
    itemtype = "furniture",
    singular = "Chopping Board",
    multiple = "Chopping Boards",
    weight = 0.90,
    description = "A Chopping Board.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_mchopboard", 0.0)
    end
}

itemdefs["potrack"] = {
    itemtype = "furniture",
    singular = "Pot Rack",
    multiple = "Pot Racks",
    weight = 0.90,
    description = "A Pot Rack.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_pot_rack", -0.5)
    end
}

itemdefs["fruitbowl"] = {
    itemtype = "furniture",
    singular = "Wooden Fruit Bowl",
    multiple = "Wooden Fruit Bowls",
    weight = 0.90,
    description = "A Wooden Fruit Bowl.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_m_woodbowl", 0.0)
    end
}

itemdefs["fruitbowl2"] = {
    itemtype = "furniture",
    singular = "White Fruit Bowl",
    multiple = "White Fruit Bowls",
    weight = 0.90,
    description = "A White Fruit Bowl.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_acc_fruitbowl_02", 0.0)
    end
}

itemdefs["kniferack"] = {
    itemtype = "furniture",
    singular = "Knife Rack",
    multiple = "Knife Racks",
    weight = 0.30,
    description = "A Knife Rack.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_mkniferack", 0.0)
    end
}

itemdefs["champagneset"] = {
    itemtype = "furniture",
    singular = "Champagne Set",
    multiple = "Champagne Sets",
    weight = 0.10,
    description = "A Champagne Set.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_champset", 0.0)
    end
}

itemdefs["whiteplate"] = {
    itemtype = "furniture",
    singular = "White Plate",
    multiple = "White Plates",
    weight = 0.10,
    description = "A White Plate.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_mplatelrg", 0.0)
    end
}

itemdefs["cakedisplay"] = {
    itemtype = "furniture",
    singular = "Cake Display",
    multiple = "Cake Displays",
    weight = 0.10,
    description = "A Cake Display.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_cakedome", 0.0)
    end
}

itemdefs["barcaddy"] = {
    itemtype = "furniture",
    singular = "Bar Caddy",
    multiple = "Bar Caddy",
    weight = 0.10,
    description = "A Bar Caddy.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_bar_caddy", 0.0)
    end
}

itemdefs["beercollection"] = {
    itemtype = "furniture",
    singular = "Local Beer Collection",
    multiple = "Local Beer Collections",
    weight = 0.10,
    description = "A Local Beer Collection.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "beerrow_local", 0.0)
    end
}

itemdefs["beercollection2"] = {
    itemtype = "furniture",
    singular = "World Beer Collection",
    multiple = "World Beer Collections",
    weight = 0.10,
    description = "A World Beer Collection.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "beerrow_world", 0.0)
    end
}

itemdefs["ricejar"] = {
    itemtype = "furniture",
    singular = "Rice Jar",
    multiple = "Rice Jars",
    weight = 0.10,
    description = "A Rice Jar.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_foodjarb", 0.0)
    end
}

itemdefs["kitchenpan"] = {
    itemtype = "furniture",
    singular = "Kitchen Pan",
    multiple = "Kitchen Pans",
    weight = 0.10,
    description = "A Kitchen Pan.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_pot_05", 0.05)
    end
}

itemdefs["teapot"] = {
    itemtype = "furniture",
    singular = "Teapot",
    multiple = "Teapot",
    weight = 0.05,
    description = "A Teapot.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_r_teapot", 0.0)
    end
}

itemdefs["variousalcohols"] = {
    itemtype = "furniture",
    singular = "Various Alcohol",
    multiple = "Various Alcohol",
    weight = 0.05,
    description = "Some Various Alcohol.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_bikerset", 0.0)
    end
}

itemdefs["pepperjar"] = {
    itemtype = "furniture",
    singular = "Dried Pepper Jar",
    multiple = "Dried Pepper Jars",
    weight = 0.05,
    description = "A Dried Pepper Jar.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_foodjara", 0.0)
    end
}

itemdefs["whiskeybottle"] = {
    itemtype = "furniture",
    singular = "Whiskey Bottle",
    multiple = "Whiskey Bottles",
    weight = 0.05,
    description = "A bottle of Whiskey.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "p_whiskey_bottle_s", 0.15)
    end
}

itemdefs["pastajar"] = {
    itemtype = "furniture",
    singular = "Pasta Jar",
    multiple = "Pasta Jar",
    weight = 0.05,
    description = "A jar of Pasta.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_foodjarc", 0.0)
    end
}

itemdefs["whitebowl"] = {
    itemtype = "furniture",
    singular = "White Bowl",
    multiple = "White Bowl",
    weight = 0.05,
    description = "A White Bowl.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_mbowl", 0.0)
    end
}

itemdefs["whitemug"] = {
    itemtype = "furniture",
    singular = "White Mug",
    multiple = "White Mugs",
    weight = 0.05,
    description = "A White Mug.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_mmug", 0.0)
    end
}

itemdefs["whitecup"] = {
    itemtype = "furniture",
    singular = "White Cup",
    multiple = "White Cups",
    weight = 0.05,
    description = "A White Cup.",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_mcofcup", 0.0)
    end
}

itemdefs["shelveunit2"] = {
    itemtype = "furniture",
    singular = "Large White Shelves",
    multiple = "Large White Shelves",
    weight = 50.00,
    description = "A place to put stuff!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_str_shelffreel_01", 0.0)
    end
}

itemdefs["shelveunit3"] = {
    itemtype = "furniture",
    singular = "Small Wooden Shelves",
    multiple = "Small Wooden Shelves",
    weight = 50.00,
    description = "A place to put stuff!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_str_shelfwallm_01", 0.6)
    end
}

itemdefs["shelveunit4"] = {
    itemtype = "furniture",
    singular = "Large Metal Shelves",
    multiple = "Large Metal Shelves",
    weight = 50.00,
    description = "A place to put stuff!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_shelves_01", 0.0)
    end
}

itemdefs["shelveunit5"] = {
    itemtype = "furniture",
    singular = "Purple Dresser",
    multiple = "Purple Dressers",
    weight = 50.00,
    description = "A place to put stuff!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_bed_chestdrawer_02", 0.6)
    end
}

itemdefs["shelveunit6"] = {
    itemtype = "furniture",
    singular = "Medium White Dresser",
    multiple = "Medium White Dressers",
    weight = 50.00,
    description = "A place to put stuff!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_tre_storageunit", 0.0)
    end
}

itemdefs["shelveunit7"] = {
    itemtype = "furniture",
    singular = "Small White Dresser",
    multiple = "Small White Dressers",
    weight = 7.00,
    description = "A place to put stuff!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_tre_bedsidetableb", 0.0)
    end
}

itemdefs["shelveunit8"] = {
    itemtype = "furniture",
    singular = "Large White Sideboard",
    multiple = "Large White Sideboards",
    weight = 30.00,
    description = "A place to put stuff!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_str_sideboardl_06", 0.0)
    end
}

itemdefs["shelveunit9"] = {
    itemtype = "furniture",
    singular = "Medium White Sideboard",
    multiple = "Medium White Sideboards",
    weight = 15.00,
    description = "A place to put stuff!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_str_sideboardm_03", 0.0)
    end
}

itemdefs["shelveunit10"] = {
    itemtype = "furniture",
    singular = "Medium Grey Panel Sideboard",
    multiple = "Medium Grey Panel Sideboards",
    weight = 30.00,
    description = "A place to put stuff!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_str_sideboards_01", 0.0)
    end
}

itemdefs["shelveunit11"] = {
    itemtype = "furniture",
    singular = "Large Grey Sideboard",
    multiple = "Large Grey Sideboards",
    weight = 30.00,
    description = "A place to put stuff!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "hei_heist_str_sideboardl_02", 0.0)
    end
}

itemdefs["shelveunit12"] = {
    itemtype = "furniture",
    singular = "Large Grey Wooden Sideboard",
    multiple = "Large Grey Wooden Sideboards",
    weight = 30.00,
    description = "A place to put stuff!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_str_sideboardl_11", 0.0)
    end
}

itemdefs["shelveunit13"] = {
    itemtype = "furniture",
    singular = "Large Wooden Sideboard",
    multiple = "Large Wooden Sideboards",
    weight = 30.00,
    description = "A place to put stuff!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "hei_heist_str_sideboardl_03", 0.0)
    end
}

itemdefs["shelveunit14"] = {
    itemtype = "furniture",
    singular = "Medium Wooden Sideboard",
    multiple = "Medium Wooden Sideboards",
    weight = 10.00,
    description = "A place to put stuff!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "apa_mp_h_str_sideboardm_02", 0.0)
    end
}

itemdefs["greenlocker"] = {
    itemtype = "furniture",
    singular = "Large Green Locker",
    multiple = "Large Green Lockers",
    weight = 40.00,
    description = "A place to put stuff!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_ind_rc_locker", 0.0)
    end
}

itemdefs["shelveunit15"] = {
    itemtype = "furniture",
    singular = "Large Grey Office Cabinet",
    multiple = "Large Grey Office Cabinets",
    weight = 10.00,
    description = "A place to put stuff!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_cabinet_02b", 0.9)
    end
}

itemdefs["shelveunit16"] = {
    itemtype = "furniture",
    singular = "Small Grey Office Cabinet",
    multiple = "Small Grey Office Cabinets",
    weight = 2.00,
    description = "A place to put stuff!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_fbibombfile", 0.0)
    end
}

itemdefs["shelveunit17"] = {
    itemtype = "furniture",
    singular = "Large Black Office Shelves",
    multiple = "Large Black Office Shelves",
    weight = 15.00,
    description = "A place to put stuff!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_corp_offshelfdark", 0.0)
    end
}

itemdefs["shelveunit18"] = {
    itemtype = "furniture",
    singular = "Open Storage Box",
    multiple = "Open Storage Boxes",
    weight = 2.00,
    description = "A place to put stuff!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "p_devin_box_01_s", 0.3)
    end
}

itemdefs["shelveunit19"] = {
    itemtype = "furniture",
    singular = "Bamboo Storage Box",
    multiple = "Bamboo Storage Boxes",
    weight = 2.00,
    description = "A place to put stuff!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "v_res_tre_storagebox", 0.0)
    end
}

itemdefs["shelveunit20"] = {
    itemtype = "furniture",
    singular = "Safe",
    multiple = "Safes",
    weight = 5.00,
    description = "A place to put stuff!",
    canUse = true,
    canStack = true,
    reusable = true,
    onUse = function()
        TriggerEvent("Properties:Client:PrepFurniturePlacement", "prop_ld_int_safe_01", 0.5)
    end
}
