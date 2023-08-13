local isHarvesting = false
local harvestWeapon = "WEAPON_KNIFE"

-- CHECKS ANIMAL'S CAUSE OF DEATH
local function CheckCauseOfDeath(animalEntity)
    -- IF THE ANIMAL WAS MURDERED BY VEHICLE
    local causeOfDeath = GetPedCauseOfDeath(animalEntity)
    if (causeOfDeath == GetHashKey("WEAPON_RUN_OVER_BY_CAR") or causeOfDeath == GetHashKey("WEAPON_RAMMED_BY_CAR")) or HasEntityBeenDamagedByAnyVehicle(animalEntity) then
        return false
    -- IF THE ANIMAL WAS MURDERED BY WEAPON
    elseif GetWeapontypeGroup(causeOfDeath) ~= nil then
        local weaponGroup = GetWeapontypeGroup(causeOfDeath)
        if (weaponGroup == GetHashKey("GROUP_UNARMED") or weaponGroup == GetHashKey("GROUP_MELEE")) then
            return "Perfect"
        elseif (weaponGroup == GetHashKey("GROUP_SNIPER")) then
            return "Good"
        elseif (weaponGroup == GetHashKey("GROUP_MG") or weaponGroup == GetHashKey("GROUP_SHOTGUN") or weaponGroup == GetHashKey("GROUP_RIFLE") or weaponGroup == GetHashKey("GROUP_PISTOL") or weaponGroup == GetHashKey("GROUP_SMG")) then
            return "Poor"
        else
            return false
        end
    end
    return false
end

-- HARVESTS ANIMAL
function DoHarvest()
    -- LOOK FOR ENTITIES
    local pedList = exports["soe-utils"]:IteratePeds()

    -- DISTANCE CHECKER
    local dist = 1000
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local closest
    for _, v in pairs(pedList) do
        if (v ~= ped) then
            local ePos = GetEntityCoords(v)
            if (Vdist2(pos, ePos) < dist) then
                closest = v
                dist = Vdist2(pos, ePos)
            end
        end
    end

    if (dist <= 2.5) then
        if IsEntityDead(closest) and not IsPedHuman(closest) then
            for _, animal in ipairs(pedList) do
                if #(GetEntityCoords(animal) - pos) < 1.5 then
                    for k, v in pairs(huntableAnimals) do
                        local hash = GetHashKey(k)
                        if (GetEntityModel(animal) == hash) and not IsPedInAnyVehicle(ped) and not isHarvesting then
                            if HasPedGotWeapon(ped, harvestWeapon, false) then
                                HarvestAnimal(v, animal)
                            end
                        end
                    end
                end
            end
        end
    end
end

-- MAIN HUNTING FUNCTION
function HarvestAnimal(animalData, animalEntity)
    local isBird = animalData.isBird
    local causeOfDeath = CheckCauseOfDeath(animalEntity)
    if isHarvesting then return end

    -- MAKE PED FACE ANIAML AND UNEQUIP PLAYER WEAPON
    local ped = PlayerPedId()
    isHarvesting = true
    TaskTurnPedToFaceEntity(ped, animalEntity, -1)
    Wait(1000)

    -- START PROGRESS BAR TO FORCE PLAYER INTO ANIMATION
    exports["soe-utils"]:Progress(
        {
            name = "harvestAnimal",
            duration = 9500,
            label = "Harvesting",
            useWhileDead = false,
            canCancel = true,
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
            if cancelled then
                isHarvesting = false
                Wait(500)
                ClearPedTasks(ped)
            elseif not cancelled then
                if DoesEntityExist(animalEntity) then
                    TriggerServerEvent("Utils:Server:DeleteEntity", NetworkGetNetworkIdFromEntity(animalEntity))
                end

                isHarvesting = false
                Wait(300)
                ClearPedTasks(ped)

                -- CHECK CAUSE OF DEATH AND GIVE ITEMS ACCORDINGLY
                if causeOfDeath then
                    math.randomseed(GetGameTimer())
                    local randomMeat = math.random(1, animalData.maxMeat)

                    -- GIVE FEATHERS IF ANIMAL IS A BIRD
                    math.randomseed(GetGameTimer())
                    local randomFeather = math.random(2, 4)
                    if isBird then
                        -- GIVE FEATHER DEPENDING ON CAUSE OF DEATH
                        local featherType = "feather"
                        if causeOfDeath == "Poor" then
                            featherType = "featherraggedy"
                        elseif causeOfDeath == "Perfect" then
                            featherType = "featherperfect"
                        end
                        TriggerServerEvent("Jobs:Server:HarvestAnimal", {status = true, animalName = animalData.name, item = featherType, amt = randomFeather})
                    else
                        -- GIVE PELT DEPENDING ON CAUSE OF DEATH
                        local peltType = animalData.itemNamePelt
                        if causeOfDeath == "Poor" then
                            peltType = animalData.itemNamePelt .. "poor"
                        elseif causeOfDeath == "Perfect" then
                            peltType = animalData.itemNamePelt .. "perfect"
                        end
                        TriggerServerEvent("Jobs:Server:HarvestAnimal", {status = true, animalName = animalData.name, item = peltType, amt = 1})
                    end

                    -- ALWAYS GIVE MEAT
                    Wait(2000)
                    TriggerServerEvent("Jobs:Server:HarvestAnimal", {status = true, animalName = animalData.name, item = animalData.itemNameMeat, amt = randomMeat})
                else
                    if isBird then
                        exports["soe-ui"]:SendAlert("inform", "The feathers and meat were too badly damaged to be worth harvesting.", 4000)
                    else
                        exports["soe-ui"]:SendAlert("inform", "The meat was too badly damaged to be worth harvesting.", 4000)
                    end
                end
            end
        end
    )
end

AddEventHandler("Jobs:Client:HarvestAnimal", DoHarvest)
