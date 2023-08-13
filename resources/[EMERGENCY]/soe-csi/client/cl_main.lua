local action
local lastPress, lastDroppedCasing, lastInflictedGSR = 0, 0, 0

nearbyCasings, nearbyBloodDrops, nearbyVehFragments = {}, {}, {}
casings, bloodDrops, fingerprints, vehicleFragments = {}, {}, {}, {}

local doorMappings = {
    [0] = -1,
    [1] = 0,
    [2] = 1,
    [3] = 2
}

-- KEY MAPPINGS
RegisterKeyMapping("pickupcasing", "[CSI] Pickup Casing", "KEYBOARD", "G")
RegisterKeyMapping("pickupbloodsplatter", "[CSI] Pickup Blood Splatter", "KEYBOARD", "G")
RegisterKeyMapping("pickupvehiclefragment", "[CSI] Pickup Vehicle Fragment", "KEYBOARD", "G")

-- ***********************
--     Local Functions
-- ***********************
-- WHEN TRIGGERED, IDENTIFIES CLOSEST PLAYER BY FINGERPRINT
local function IdentifyPlayer()
    local closestPlayer = exports["soe-utils"]:GetClosestPlayer(5) -- FIND CLOSEST PLAYER
    if (closestPlayer ~= nil) then
        if exports["soe-challenge"]:Skillbar(6000, math.random(5, 15)) then -- SKILLBAR MINIGAME
            Wait(200)
            if exports["soe-challenge"]:Skillbar(7000, math.random(5, 12)) then
                TriggerServerEvent("CSI:Server:IdentifyPlayer", {["status"] = true, ["target"] = GetPlayerServerId(closestPlayer)})
            else
                exports["soe-ui"]:SendAlert("error", "Learn how to properly use the fingerprint scanner...", 5000)
            end
        else
            exports["soe-ui"]:SendAlert("error", "Learn how to properly use the fingerprint scanner...", 5000)
        end
    else
        exports["soe-ui"]:SendAlert("error", "Nobody close enough", 5000)
    end
end

-- WHEN TRIGGERED, PICK UP THE NEAREST VEHICLE FRAGMENT
local function PickupVehicleFragment()
    if (lastPress > GetGameTimer()) then -- COOLDOWN CHECK
        return
    end

    local nearestFragment
    local pos = GetEntityCoords(PlayerPedId())

    for fragmentID, fragmentData in pairs(nearbyVehFragments) do
        if #(pos - fragmentData["pos"]) <= 1.0 then
            nearestFragment = {["id"] = fragmentID, ["data"] = fragmentData}
            break
        end
    end

    if (nearestFragment ~= nil) then
        local fragmentMeta = {
            ["fragmentID"] = nearestFragment["id"],
            ["genericColor"] = nearestFragment["data"]["genericColor"],
            ["detailedColor"] = nearestFragment["data"]["detailedColor"],
            ["location"] = exports["soe-utils"]:GetLocation(nearestFragment["data"]["pos"])
        }
        TriggerServerEvent("CSI:Server:GiveItem", "Vehicle Fragment", fragmentMeta)

        vehicleFragments[nearestFragment["id"]] = nil
        nearbyVehFragments[nearestFragment["id"]] = nil
        lastPress = GetGameTimer() + 1200

        TaskPlayAnim(PlayerPedId(), "random@domestic", "pickup_low", 1.5, 1.5, 1200, 1, 0, 0, 0, 0)
    end
end

-- WHEN TRIGGERED, PICK UP THE NEAREST BLOOD DROP
local function PickupBloodSplatter()
    if (lastPress > GetGameTimer()) then -- COOLDOWN CHECK
        return
    end

    local nearestDrop
    local pos = GetEntityCoords(PlayerPedId())

    for dropID, dropData in pairs(nearbyBloodDrops) do
        if #(pos - dropData["pos"]) <= 1.0 then
            if not exports["soe-inventory"]:HasInventoryItem("collectionvial") then -- IF PLAYER DOES NOT HAVE A COLLECTION VIAL
                exports["soe-ui"]:SendAlert("error", "Find something to collect the blood with...", 5000)
                return
            end

            nearestDrop = {["id"] = dropID, ["data"] = dropData}
            break
        end
    end

    if (nearestDrop ~= nil) then
        local bloodMeta = {
            ["bloodID"] = nearestDrop["id"],
            ["dna"] = nearestDrop["data"]["dna"],
            ["location"] = exports["soe-utils"]:GetLocation(nearestDrop["data"]["pos"])
        }
        TriggerServerEvent("CSI:Server:GiveItem", "casing", bloodMeta)

        bloodDrops[nearestDrop["id"]] = nil
        nearbyBloodDrops[nearestDrop["id"]] = nil
        lastPress = GetGameTimer() + 1200
        TaskPlayAnim(PlayerPedId(), "random@domestic", "pickup_low", 1.5, 1.5, 1200, 1, 0, 0, 0, 0)
    end
end

-- WHEN TRIGGERED, PICK UP THE NEAREST BULLET CASING
local function PickupBulletCasing()
    if (lastPress > GetGameTimer()) then -- COOLDOWN CHECK
        return
    end

    local nearestCasing
    local pos = GetEntityCoords(PlayerPedId())

    for casingID, casingData in pairs(nearbyCasings) do
        if #(pos - casingData["pos"]) <= 1.0 then
            nearestCasing = {["id"] = casingID, ["data"] = casingData}
            break
        end
    end

    if (nearestCasing ~= nil) then
        local casingMeta = {
            ["casingID"] = nearestCasing["id"],
            ["gunType"] = nearestCasing["data"]["type"],
            ["gunModel"] = nearestCasing["data"]["model"],
            ["serialNum"] = nearestCasing["data"]["serial"],
            ["location"] = exports["soe-utils"]:GetLocation(nearestCasing["data"]["pos"])
        }
        TriggerServerEvent("CSI:Server:GiveItem", "casing", casingMeta)

        casings[nearestCasing["id"]] = nil
        nearbyCasings[nearestCasing["id"]] = nil
        lastPress = GetGameTimer() + 1200
        TaskPlayAnim(PlayerPedId(), "random@domestic", "pickup_low", 1.5, 1.5, 1200, 1, 0, 0, 0, 0)
    end
end

-- ***********************
--    Global Functions
-- ***********************
-- WHEN TRIGGERED, MAKE A BLOOD DROP
function AddBloodDrop()
    TriggerServerEvent("CSI:Server:SpillBlood", {["status"] = true})
end

-- WHEN TRIGGERED, SET GSR INFLICTION STATE
function SetGSRInfliction()
    if lastInflictedGSR < GetGameTimer() then
        lastInflictedGSR = GetGameTimer() + 55000
        TriggerServerEvent("CSI:Server:InflictGSR", {["status"] = true})
    end
end

-- WHEN TRIGGERED, CREATE ANALYSIS ZONES
function CreateZones()
    exports["soe-utils"]:AddCircleZone("MRPD-CSI-CasingScanning", vector3(482.69, -988.71, 30.69), 0.5, {
        ["name"] = "MRPD-CSI-CasingScanning",
        ["useZ"] = true
    })

    exports["soe-utils"]:AddCircleZone("MRPD-CSI-BloodTesting", vector3(485.84, -984.32, 30.69), 0.5, {
        ["name"] = "MRPD-CSI-BloodTesting",
        ["useZ"] = true
    })

    exports["soe-utils"]:AddCircleZone("MRPD-CSI-PrintAnalysis", vector3(485.19, -993.32, 30.69), 0.5, {
        ["name"] = "MRPD-CSI-PrintAnalysis",
        ["useZ"] = true
    })

    exports["soe-utils"]:AddCircleZone("MRPD-CSI-FragmentAnalysis", vector3(486.9, -987.73, 30.69), 0.5, {
        ["name"] = "MRPD-CSI-FragmentAnalysis",
        ["useZ"] = true
    })
end

-- WHEN TRIGGERED, MAKE A BULLET CASING
function AddBulletCasing()
    local ped = PlayerPedId() -- IF WE ARE IN WATER OR IF CASING COOLDOWN IS ACTIVE, DON'T DROP
    if (lastDroppedCasing > GetGameTimer()) or IsEntityInWater(ped) then
        return
    end

    -- GRAB THE WEAPON AND WEAPON TYPE
    local weapon, weaponType
    local myWeapon = GetSelectedPedWeapon(ped)
    for firearmType, firearmData in pairs(firearms) do
        for _, model in pairs(firearmData) do
            if (GetHashKey(model) == myWeapon) then
                weapon, weaponType = string.gsub(model, "WEAPON_", ""), firearmType
            end
        end
    end

    -- IF WEAPONS AREN'T NIL
    if (weapon ~= nil and weaponType ~= nil and exports["soe-inventory"]:GetMyCurrentWeapon()) then
        lastDroppedCasing = GetGameTimer() + 1000

        local wearingGloves = exports["soe-appearance"]:IsWearingGloves()
        local weather = exports["soe-climate"]:GetWeather()["weatherType"]
        local serialNumber = exports["soe-inventory"]:GetMyCurrentWeapon()["serial"]

        TriggerServerEvent("CSI:Server:AddCasing", serialNumber, weapon, weaponType, weather, wearingGloves)
    end
end

-- WHEN TRIGGERED, USE GUNSHOT RESIDUE KIT
function UseGSRKit()
    local player = exports["soe-utils"]:GetClosestPlayer(5)
    -- local player = PlayerId() -- USE TO TEST WITH SELF
    if (player ~= nil) then
        exports["soe-utils"]:Progress(
            {
                name = "gsrTesting",
                duration = 10000,
                label = "Testing for GSR",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = false,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true
                },
                animation = {
                    animDict = "mp_weapons_deal_sting",
                    anim = "crackhead_bag_loop",
                    flags = 49
                }
            },
            function(cancelled)
                if not cancelled then
                    exports["soe-input"]:OpenInputDialogue("name", "What name should be written on the test kit?", function(returnData)
                        if (returnData ~= nil) then
                            TriggerServerEvent("CSI:Server:UseGSRKit", {["status"] = true, ["target"] = GetPlayerServerId(player), ["kitName"] = returnData})
                        end
                    end)
                end
            end
        )
    else
        exports["soe-ui"]:SendAlert("error", "Nobody close enough", 5000)
    end
end

-- ***********************
--        Commands
-- ***********************
-- WHEN TRIGGERED, PICK UP NEAREST BULLET CASING
RegisterCommand("pickupcasing", PickupBulletCasing)

-- WHEN TRIGGERED, PICK UP NEAREST BLOOD SPLATTER
RegisterCommand("pickupbloodsplatter", PickupBloodSplatter)

-- WHEN TRIGGERED, PICK UP NEAREST VEHICLE FRAGMENT
RegisterCommand("pickupvehiclefragment", PickupVehicleFragment)

-- ***********************
--         Events
-- ***********************
-- WHEN TRIGGERED, IDENTIFY NEAREST PLAYER
RegisterNetEvent("CSI:Client:IdentifyPlayer", IdentifyPlayer)

-- WHEN TRIGGERED, ADD BULLET CASING TO CLIENT'S TABLE
RegisterNetEvent("CSI:Client:AddCasing", function(caseID, casingData)
    casings[caseID] = casingData
end)

-- WHEN TRIGGERED, ADD BLOOD DROP TO CLIENT'S TABLE
RegisterNetEvent("CSI:Client:SpillBlood", function(bloodID, bloodData)
    bloodDrops[bloodID] = bloodData
end)

-- WHEN TRIGGERED, ADD FINGERPRINT TO CLIENT'S TABLE
RegisterNetEvent("CSI:Client:AddFingerprint", function(printID, printData)
    fingerprints[printID] = printData
end)

-- WHEN TRIGGERED, ADD VEHICLE FRAGMENT TO CLIENT'S TABLE
RegisterNetEvent("CSI:Client:AddVehicleFragment", function(fragmentID, fragmentData)
    vehicleFragments[fragmentID] = fragmentData
end)

-- WHEN TRIGGERED, SYNC CASINGS AND BLOOD DROPS
RegisterNetEvent("CSI:Client:SyncEvidence", function(_casings, _bloodDrops)
    casings, bloodDrops = _casings, _bloodDrops
    nearbyCasings, nearbyBloodDrops = {}, {}
end)

-- WHEN TRIGGERED, DROP A VEHICLE FRAGMENT UNDER CERTAIN CONDITIONS
AddEventHandler("BaseEvents:Client:VehicleCrashed", function(veh, seat, currentSpeed, previousSpeed, previousVelocity)
    if (seat ~= -1) then return end
    TriggerServerEvent("CSI:Server:AddVehicleFragment", {["status"] = true, ["veh"] = VehToNet(veh)})
end)

-- WHEN TRIGGERED, DO ZONE EXIT TASKS
AddEventHandler("Utils:Client:ExitedZone", function(name)
    if (name == "MRPD-CSI-BloodTesting" or name == "MRPD-CSI-CasingScanning" or name == "MRPD-CSI-PrintAnalysis" or name == "MRPD-CSI-FragmentAnalysis") then
        action = nil
        exports["soe-ui"]:HideTooltip()
    end
end)

-- WHEN TRIGGERED, GIVE THE VEHICLE A FINGERPRINT WHEN TOUCHED
AddEventHandler("BaseEvents:Client:EnteredVehicle", function(veh, seat)
    if exports["soe-appearance"]:IsWearingGloves() then return end

    local street = exports["soe-utils"]:GetLocation(GetEntityCoords(PlayerPedId()))
    TriggerServerEvent("CSI:Server:AddVehFingerprint", {["plate"] = GetVehicleNumberPlateText(veh), ["door"] = seat, ["pos"] = street})
end)

-- WHEN TRIGGERED, DO INTERACTION KEYPRESS
AddEventHandler("Utils:Client:InteractionKey", function()
    if not action then return end
    if (action["name"] == "Blood Analyzing") then
        TriggerEvent("Inventory:Client:ShowInventory", "bloodanalysis", false, 2)
    elseif (action["name"] == "Casing Scanning") then
        TriggerEvent("Inventory:Client:ShowInventory", "casinganalysis", false, 1)
    elseif (action["name"] == "Fingerprint Analysis") then
        TriggerEvent("Inventory:Client:ShowInventory", "printanalysis", false, 3)
    elseif (action["name"] == "Vehicle Fragment Analysis") then
        TriggerEvent("Inventory:Client:ShowInventory", "vehfragmentanalysis", false, 4)
    end
end)

-- WHEN TRIGGERED, DO ZONE ENTRANCE TASKS
AddEventHandler("Utils:Client:EnteredZone", function(name)
    if (name == "MRPD-CSI-BloodTesting") then
        action = {["status"] = true, ["name"] = "Blood Analyzing"}
        exports["soe-ui"]:ShowTooltip("fas fa-eye-dropper", "[E] Analyze Blood Drop", "inform")
    elseif (name == "MRPD-CSI-CasingScanning") then
        action = {["status"] = true, ["name"] = "Casing Scanning"}
        exports["soe-ui"]:ShowTooltip("fas fa-barcode", "[E] Analyze Bullet Casing", "inform")
    elseif (name == "MRPD-CSI-PrintAnalysis") then
        action = {["status"] = true, ["name"] = "Fingerprint Analysis"}
        exports["soe-ui"]:ShowTooltip("fas fa-fingerprint", "[E] Analyze Lifted Fingerprint", "inform")
    elseif (name == "MRPD-CSI-FragmentAnalysis") then
        action = {["status"] = true, ["name"] = "Vehicle Fragment Analysis"}
        exports["soe-ui"]:ShowTooltip("fas fa-car-alt", "[E] Analyze Paint", "inform")
    end
end)
