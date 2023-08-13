local plantHashes = {"bkr_prop_weed_plantpot_stack_01b", "bkr_prop_weed_01_small_01b", "bkr_prop_weed_med_01b", "bkr_prop_weed_lrg_01b"}

-- DECORATORS
DecorRegister("weedplantID", 3)

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, SYNC WEED PLANTS WITH DATA FROM SERVER
local function SyncWeedPlants(data)
    if not data.status then return end
    if not data.type then return end

    if (data.type == "grow") then
        local plant = GetClosestObjectOfType(data.x, data.y, data.z, 1.0, GetHashKey(data.hash), 0, 0, 0)
        if not DoesEntityExist(plant) then
            local networked = 1
            if data.property then
                networked = 0
            end

            exports["soe-utils"]:LoadModel(GetHashKey(data.hash), 15)
            plant = CreateObject(GetHashKey(data.hash), data.x, data.y, data.z, networked, false, false)
            SetEntityAsMissionEntity(plant, true, true)
            SetEntityCoords(plant, data.x, data.y, data.z)

            DecorSetInt(plant, "weedplantID", data.plantID)
            PlaceObjectOnGroundProperly(plant)
        end
    elseif (data.type == "remove") then
        local plant = GetClosestObjectOfType(data.x, data.y, data.z, 1.0, GetHashKey(data.hash), 0, 0, 0)
        if DoesEntityExist(plant) then
            exports["soe-utils"]:GetEntityControl(plant)
            SetEntityAsMissionEntity(plant, true, true)
            DeleteObject(plant)
            DeleteEntity(plant)

            SetEntityAsNoLongerNeeded(plant)
            SetModelAsNoLongerNeeded(data.hash)
        end
    end
end

-- WHEN TRIGGERED, CHECK SOME THINGS BEFORE PLACING A WEED PLANT
local function PlantWeedPlant(data)
    if not data.status then return end

    -- MAKE SURE WE ARE ON SOLID GROUND
    local ped = PlayerPedId()
    if not IsPedOnFoot(ped) or IsEntityInWater(ped) or IsEntityInAir(ped) then
        exports["soe-ui"]:SendAlert("error", "You must be on solid ground to do this", 5000)
        return
    end

    -- START PLACING THE PLANT
    local pos = GetEntityCoords(PlayerPedId())
    if (GetClosestObjectOfType(pos, 1.0, GetHashKey(plantHashes[1]), 0, 0, 0) ~= 0) then
        exports["soe-ui"]:SendAlert("error", "You are too close to another plant!", 5000)
        return
    end

    exports["soe-utils"]:Progress(
        {
            name = "plantingWeedplant",
            duration = 9500,
            label = "Planting",
            useWhileDead = false,
            canCancel = false,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true
            },
            animation = {
                animDict = "amb@medic@standing@tendtodead@idle_a",
                anim = "idle_b",
                flags = 33
            }
        },
        function(cancelled)
            ClearPedTasks(PlayerPedId())
            if not cancelled then
                -- CALL TO SERVER AND MAKE THIS NEW PLANT IN THE DB
                local canPlant = exports["soe-nexus"]:TriggerServerCallback("Crime:Server:RegisterNewPlant", pos)
                if canPlant.status then
                    print("canPlant.status:", canPlant.status)
                end
            end
        end
    )
end

-- WHEN TRIGGERED, FIND THE CLOSEST WEED PLANT AND REMOVE IT
local function HarvestNearestPlant(data)
    if not data.status then return end

    -- GET THE NEAREST WEEDPLANT
    local nearestPlant
    local pos = GetEntityCoords(PlayerPedId())
    for _, hash in pairs(plantHashes) do
        local plant = GetClosestObjectOfType(pos, 1.0, GetHashKey(hash), 0, 0, 0)
        if DoesEntityExist(plant) then
            nearestPlant = {ent = plant, hash = hash}
            break
        end
    end

    -- IF WE FOUND OUR PLANT
    if nearestPlant then
        local plantID = DecorGetInt(nearestPlant.ent, "weedplantID")
        if (plantID ~= 0) then
            exports["soe-utils"]:Progress(
                {
                    name = "harvestingPlant",
                    duration = 10000,
                    label = "Harvesting Plant",
                    useWhileDead = false,
                    canCancel = false,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = true
                    },
                    animation = {
                        animDict = "amb@medic@standing@tendtodead@idle_a",
                        anim = "idle_b",
                        flags = 33
                    }
                },
                function(cancelled)
                    ClearPedTasks(PlayerPedId())
                    if not cancelled then
                        local removedPlant = exports["soe-nexus"]:TriggerServerCallback("Crime:Server:RemoveWeedPlant", plantID, nearestPlant.hash)

                        exports["soe-utils"]:GetEntityControl(nearestPlant.ent)
                        SetEntityAsMissionEntity(nearestPlant.ent, true, true)
                        DeleteObject(nearestPlant.ent)
                        DeleteEntity(nearestPlant.ent)

                        SetEntityAsNoLongerNeeded(nearestPlant.ent)
                        SetModelAsNoLongerNeeded(nearestPlant.hash)
                    end
                end
            )
        end
    else
        exports["soe-ui"]:SendAlert("error", "No plant nearby", 5000)
    end
end

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, SYNC WEED PLANTS
RegisterNetEvent("Crime:Client:SyncWeedPlants")
AddEventHandler("Crime:Client:SyncWeedPlants", SyncWeedPlants)

-- WHEN TRIGGERED, TRIGGER THE FUNCTION TO CHECK REQUIREMENTS FOR PLANTING
RegisterNetEvent("Crime:Client:PlantWeedPlant")
AddEventHandler("Crime:Client:PlantWeedPlant", PlantWeedPlant)

-- WHEN TRIGGERED, TRIGGER THE FUNCTION TO FIND NEAREST WEED PLANT
RegisterNetEvent("Crime:Client:HarvestNearestPlant")
AddEventHandler("Crime:Client:HarvestNearestPlant", HarvestNearestPlant)
