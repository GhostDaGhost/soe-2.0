local looted = {}
local myHouse = nil
local cooldown = false
local isRobbing = false
local enteredFrom = nil
local isInsideProperty = false

-- DEFINE OUR HOUSE TIERS / GET ITS LOCATION / ADD DOG LOCATION / ADD OWNER LOCATION
local interiors = {
    ["low"] = {pos = vector4(266.15, -1007.24, -101.01, 360.0), dog = vector3(260.48, -1003.35, -99.0), owner = vector3(260.91, -1003.65, -99.01)},
    ["med"] = {pos = vector4(346.33, -1012.96, -99.2, 350.0), dog = vector3(340.27, -998.91, -99.2), owner = vector3(349.72, -996.2, -98.54)},
    ["high"] = {pos = vector4(117.12, 559.8, 184.3, 188.7), dog = vector3(122.1, 546.58, 180.5), owner = vector3(124.9, 546.79, 180.5)}
}

-- DEFINE OUR DOG MODELS
local dogs = {"a_c_westy", "a_c_chop", "a_c_husky", "a_c_poodle", "a_c_pug", "a_c_retriever", "a_c_rottweiler"}

-- DEFINE OUR HOMEOWNER PED MODELS
local homeOwners = {"a_f_m_business_02", "a_f_m_prolhost_01", "a_f_m_eastsa_01", "a_f_m_eastsa_02", "a_f_m_soucentmc_01", "a_m_m_afriamer_01", 
"a_m_m_bevhills_02", "a_m_m_eastsa_01", "a_m_m_eastsa_02", "a_m_m_farmer_01", "a_m_m_ktown_01", "a_m_m_stlat_02", "a_m_y_beach_03"}

-- DEFINE OUR HOMEOWNER'S WEAPONS
local weapons = {"WEAPON_KNIFE", "WEAPON_HAMMER", "WEAPON_BAT", "WEAPON_WRENCH", "WEAPON_FLASHLIGHT", "WEAPON_POOLCUE", "WEAPON_GOLFCLUB",
"WEAPON_COMBATPISTOL", "WEAPON_PISTOL", "WEAPON_DOUBLEACTION"}

-- STARTS HOUSE ROBBERY RUNTIME AND FUNCTIONS
local function SpawnEnemies(interior)
    local dog, owner
    local ped = PlayerPedId()

    -- 30% CHANCE TO SPAWN DOG
    math.randomseed(GetGameTimer())
    if (math.random(1, 100) <= 65) then
        print("WOOF :D")

        -- RANDOMIZE DOG MODEL
        local hash = dogs[math.random(#dogs)]
        exports["soe-utils"]:LoadModel(GetHashKey(hash), 15)
        dog = CreatePed(4, hash, interiors[interior].dog, 0, true, true)
        SetBlockingOfNonTemporaryEvents(dog, true)
        TriggerServerEvent("Instance:Server:SetEntityInstance", myHouse.data.address, NetworkGetNetworkIdFromEntity(dog))
        
        -- HAVE IT WANDER ABOUT
        Wait(1000)
        TaskWanderStandard(dog, 10.0, 10)
        Wait(1000)

        -- 50% CHANCE IT WILL ATTACK THE PLAYER
        if (math.random(1, 100) < 50) then
            print("GROWL :D")
            TaskCombatPed(dog, ped, 0, 16)
        end
        SetModelAsNoLongerNeeded(hash)
    end

    -- 35% CHANCE TO SPAWN HOME OWNER
    math.randomseed(GetGameTimer())
    if (math.random(1, 100) <= 55) then
        print("UH OH D:")

        -- RANDOMIZE PED MODEL
        local hash = homeOwners[math.random(#homeOwners)]
        exports["soe-utils"]:LoadModel(GetHashKey(hash), 15)
        owner = CreatePed(4, hash, interiors[interior].owner, 0, true, true)
        SetBlockingOfNonTemporaryEvents(owner, true)
        TriggerServerEvent("Instance:Server:SetEntityInstance", myHouse.data.address, NetworkGetNetworkIdFromEntity(owner))
        
        -- HAVE IT WANDER ABOUT
        Wait(1000)
        TaskWanderStandard(owner, 10.0, 10)
        Wait(1000)

        -- 40% CHANCE THE HOME OWNER WILL HAVE A WEAPON
        math.randomseed(GetGameTimer())
        if (math.random(1, 100) < 85) then
            SetPedDropsWeaponsWhenDead(owner, false)
            GiveWeaponToPed(owner, GetHashKey(weapons[math.random(1, #weapons)]), 150, 0, 1)
        end

        -- COMMAND TO ATTACK THE PLAYER
        TaskCombatPed(owner, ped, 0, 16)
        SetPedKeepTask(owner, true)
        SetModelAsNoLongerNeeded(hash)
    end

    CreateThread(function()
        Wait(5000)
        while isInsideProperty do
            Wait(5)
            for _, spot in pairs(houseLootSpots[interior]) do
                DrawMarker(21, spot.pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 153, 43, 43, 110, 0, 1, 2, 0, 0, 0, 0)
            end
        end
    end)
end

-- ATTEMPTS HOUSE ROBBERY
local function AttemptHouseRobbery(isBreaching)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    for index, house in pairs(houses) do
        if #(pos - house.pos) <= 5.0 then
            myHouse = {data = house, index = index}
            break
        end
    end

    if myHouse then
        local acceptEntry = false
        if not isBreaching then
            print("NOT BREACHINGGG.")
            if not myHouse.data.invaded then
                if cooldown then
                    exports["soe-ui"]:SendAlert("error", "You are laying low from the last burglary", 5000)
                    return
                end

                if not exports["soe-inventory"]:HasInventoryItem("lockpick") then
                    exports["soe-ui"]:SendAlert("error", "You do not have a lockpick", 5000)
                    return
                end

                -- IF CLOSE ENOUGH, START LOCKPICK MINIGAME
                if exports["soe-challenge"]:StartLockpicking(true) then
                    acceptEntry = true
                    cooldown = true
                    SpawnEnemies(myHouse.data.class)
                    local location = exports["soe-utils"]:GetLocation(pos)
                    TriggerServerEvent("Crime:Server:StartHouseRobbery", location, pos, myHouse)
                end
            else
                -- DOOR WAS ALREADY BROKEN INTO
                acceptEntry = true
                exports["soe-ui"]:SendAlert("warning", "You notice the door was already unlocked...", 8000)
            end
        else
            -- AUTOMATICALLY GET IN WHEN BREACHING
            print("BREACHINGGG.")
            exports["soe-utils"]:Progress(
                {
                    name = "gainingHouseEntry",
                    duration = 3500,
                    label = "Gaining Entry",
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                        disableMovement = false,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = false
                    },
                    animation = {
                        animDict = "mp_arresting",
                        anim = "a_uncuff",
                        flags = 49
                    }
                },
                function(cancelled)
                    if not cancelled then
                        acceptEntry = true
                    end
                end
            )
            Wait(5000)
        end

        if acceptEntry then
            -- TELEPORT PLAYER INTO HOUSE
            enteredFrom = GetEntityCoords(ped)
            DoScreenFadeOut(500)
            Wait(500)
            exports["soe-fidelis"]:AuthorizeTeleport()
            SetEntityCoords(ped, interiors[myHouse.data.class].pos)
            SetEntityHeading(ped, interiors[myHouse.data.class].pos.w)

            -- FADE IN AND MARK US IN A HOUSE
            isInsideProperty = true
            Wait(500)
            DoScreenFadeIn(500)
            TriggerServerEvent("Instance:Server:SetPlayerInstance", myHouse.data.address)
        end
    end
end

-- RETURNS IF PLAYER IS DOING A HOUSE ROBBERY
function IsRobbingAHouse()
    return isInsideProperty
end

-- RETURNS IF PLAYER IS NEAR A HOUSE ITEM THAT CAN BE LOOTED
function IsNearRobbableHouse()
    local pos = GetEntityCoords(PlayerPedId())
    for _, house in pairs(houses) do
        if #(pos - house.pos) <= 5.0 then
            return true
        end
    end
    return false
end

-- RETURNS IF PLAYER IS NEAR A HOUSE ITEM THAT CAN BE LOOTED
function IsNearHouseItem()
    if not isInsideProperty then return false end

    local pos = GetEntityCoords(PlayerPedId())
    for _, spot in pairs(houseLootSpots[myHouse.data.class]) do
        if #(pos - spot.pos) <= 0.7 then
            return true
        end
    end
    return false
end

-- DEBUG COMMAND
--[[RegisterCommand("devinvasionblips", function()
    for _, house in pairs(houses) do
        local blip = AddBlipForCoord(house.pos)
        SetBlipSprite(blip, 40)

        if (house.class == "low") then
            SetBlipColour(blip, 6)
        elseif (house.class == "med") then
            SetBlipColour(blip, 3)
        elseif (house.class == "high") then
            SetBlipColour(blip, 18)
        end

        BeginTextCommandSetBlipName("STRING")
        if (house.class == "low") then
            AddTextComponentString("[1] Home Invasion Target")
        elseif (house.class == "med") then
            AddTextComponentString("[2] Home Invasion Target")
        elseif (house.class == "high") then
            AddTextComponentString("[3] Home Invasion Target")
        end
        EndTextCommandSetBlipName(blip)
        SetBlipScale(blip, 0.63)
    end
end)]]

-- REQUESTED BY RADIAL MENU TO ROB HOUSE IF NEARBY
RegisterNetEvent("Crime:Client:BreakIntoHouse")
AddEventHandler("Crime:Client:BreakIntoHouse", AttemptHouseRobbery)

-- RESETS THIS PLAYER'S COOLDOWN STATE
RegisterNetEvent("Crime:Client:ResetHomeCooldown")
AddEventHandler("Crime:Client:ResetHomeCooldown", function()
    looted = {}
    cooldown = false
end)

-- SYNCS HOUSE STATE WITH ALL PLAYERS
RegisterNetEvent("Crime:Client:SetHouseState")
AddEventHandler("Crime:Client:SetHouseState", function(house, state)
    houses[house].invaded = state
end)

-- REQUESTED BY RADIAL MENU TO LOOT A HOUSE ITEM
AddEventHandler("Crime:Client:LootHouseItem", function()
    if not myHouse then return end
    -- GET CLOSEST LOOT SPOT
    local closestLootSpot = nil
    for spotIndex, spotData in pairs(houseLootSpots[myHouse.data.class]) do
        if #(GetEntityCoords(PlayerPedId()) - spotData.pos) <= 0.7 then
            closestLootSpot = spotIndex
            break
        end
    end

    if closestLootSpot then
        -- MAKE SURE IT IS NOT ALREADY LOOTED
        if looted[closestLootSpot] then
            exports["soe-ui"]:SendAlert("error", "This was already looted!", 5000)
            return
        end

        exports["soe-utils"]:Progress(
            {
                name = "lootingHouse",
                duration = 6500,
                label = "Looting",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = false
                },
                animation = {
                    animDict = "amb@prop_human_bum_bin@base",
                    anim = "base",
                    flags = 1
                }
            },
            function(cancelled)
                if not cancelled then
                    looted[closestLootSpot] = true
                    StopAnimTask(PlayerPedId(), "amb@prop_human_bum_bin@base", "base", 2.0)
                    TriggerServerEvent("Crime:Server:DoHouseLootTasks")
                end
            end
        )
    end
end)

-- INTERACTION KEY TO LEAVE HOUSE IF ROBBING IT
AddEventHandler("Utils:Client:InteractionKey", function()
    --print("Is inside a house: ", isInsideProperty)
    if isInsideProperty then
        local ped = PlayerPedId()
        if #(GetEntityCoords(ped) - vector3(interiors[myHouse.data.class].pos.x, interiors[myHouse.data.class].pos.y, interiors[myHouse.data.class].pos.z)) <= 3.0 then
            DoScreenFadeOut(500)
            Wait(500)
            TriggerServerEvent("Instance:Server:SetPlayerInstance", -1)

            -- DELETE THE HOMEOWNER
            if DoesEntityExist(owner) then
                DeletePed(owner)
            -- DELETE THE HOUSE PET
            elseif DoesEntityExist(dog) then
                DeletePed(dog)
            end

            -- RESET VARIABLES AND TELEPORT BACK TO DOOR
            exports["soe-fidelis"]:AuthorizeTeleport()
            SetEntityCoords(ped, enteredFrom)
            myHouse = nil
            isInsideProperty = false
            enteredFrom = nil
            DoScreenFadeIn(500)
        end
    end
end)

-- SYNCS HOUSE ROBBERY ALARM WITH LEOS
RegisterNetEvent("Crime:Client:SendHouseRobberyAlert")
AddEventHandler("Crime:Client:SendHouseRobberyAlert", function(location, pos, address)
    -- HOUSE ROBBERY CAD ALERT
    local desc = ("A security company is reporting an home intruder alarm activation at %s. The residence is reportedly in the area of %s."):format(address, location)
    TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = false, type = "Home Invasion", desc = desc, code = "10-35", coords = pos})
end)
