local veh = nil
local cooldown = 0
local explosive = nil
local robbingTruck = false
local usedThermite = false
local completedRobbery = false

local startMissionSpots = {
    [1] = {pos = vector3(1275.55, -1710.4, 54.77)} -- LESTER'S HOUSE
}

-- ROBS THE TRUCK'S MONEY
local function RobTheMoney()
    -- RANDOMIZE MONEY
    local minMoney = 2500
    local maxMoney = 7500

    math.randomseed(GetGameTimer())
    local amount = math.random(minMoney, maxMoney)

    -- ANIMATION CONTROL
    local ped = PlayerPedId()
    exports["soe-utils"]:LoadAnimDict("anim@heists@ornate_bank@grab_cash_heels")
    TaskPlayAnim(ped, "anim@heists@ornate_bank@grab_cash_heels", "grab", 8.0, -8.0, (10 * 1000), 1, 0, 0, 0, 0)

    Wait((10 * 1000))
    TriggerEvent("Chat:Client:Message", "[Truck Robbery]", string.format("You have stolen the truck's contents which contained $%s.", amount), "standard")
    TriggerServerEvent("Crime:Server:HandleRewards", {status = true, name = "cash", amt = amount})

    -- SET EVERYTHING BACK TO FALSE
    usedThermite = false
    robbingTruck = false
    Wait(1000)
    completedRobbery = true
end

-- BLOWS UP THE REAR DOORS
local function BlowDoorsUp()
    -- CHECK IF THE PLAYER HAS THERMITE
    --if (exports["soe-inventory"]:GetItemQuantity("item", "thermite") < 1) then
        -- CHECKS IF VEHICLE IS STATIONARY
        if IsVehicleStopped(veh) then
            -- IF DRIVER, PASSENGER AND REAR PASSENGER SEATS ARE CLEAR
            if IsVehicleSeatFree(veh, -1) and IsVehicleSeatFree(veh, 0) and IsVehicleSeatFree(veh, 1) then
                exports["soe-utils"]:LoadAnimDict("anim@heists@ornate_bank@thermal_charge_heels", 15)

                -- SEND CAD ALERT
                local ped = PlayerPedId()
                local pos = GetEntityCoords(ped)
                local primary = GetVehicleColours(veh)
                local plate = GetVehicleNumberPlateText(veh)
                local location = exports["soe-utils"]:GetLocation(pos)
                TriggerServerEvent("Crime:Server:SendTruckRobberyAlert", location, pos, {model = GetEntityModel(veh), color = primary, plate = plate})

                -- EXPLODE THE DOORS
                explosive = CreateObject(GetHashKey("prop_c4_final_green"), pos.x, pos.y, (pos.z + 0.2), true, true, true)
                TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge_heels", "thermal_charge", 3.0, -8, 5500, 63, 0, 0, 0, 0)
                AttachEntityToEntity(explosive, ped, GetPedBoneIndex(ped, 60309), 0.06, 0.0, 0.06, 90.0, 0.0, 0.0, true, true, false, true, 1, true)

                Wait(5500)
                DetachEntity(explosive)
                AttachEntityToEntity(explosive, veh, GetEntityBoneIndexByName(veh, "door_pside_r"), -0.7, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
                Wait(500)

                exports["soe-utils"]:Progress(
                    {
                        name = "detonationWarning",
                        duration = (10 * 1000),
                        label = "Time Until Detonation",
                        useWhileDead = false,
                        canCancel = false,
                        controlDisables = {
                            disableMovement = false,
                            disableCarMovement = false,
                            disableMouse = false,
                            disableCombat = false
                        }
                    },
                    function(cancelled)
                        if not cancelled then
                            -- EXPLOSION EFFECT
                            local truckPos = GetEntityCoords(veh)
                            SetVehicleDoorBroken(veh, 2, false)
                            SetVehicleDoorBroken(veh, 3, false)
                            AddExplosion(truckPos.x, truckPos.y, truckPos.z, "EXPLOSION_TANKER", 2.0, true, false, 2.0)
                            ApplyForceToEntity(veh, 0, truckPos.x, truckPos.y, truckPos.z, 0.0, 0.0, 0.0, 1, false, true, true, true, true)
                            usedThermite = true
                        end
                    end
                )
            end
        end
    --[[else
        exports["soe-ui"]:SendAlert("error", "You do not have thermite", 5000)
    end]]
end

-- PING THE TRUCK'S LOCATION
local function SpawnTruck(truck)
    -- GET TRUCK'S LOCATION AND SET AS "BEING ROBBED"
    local pos = armoredTrucks[truck]
    armoredTrucks[truck].beingRobbed = true

    -- LOADS STOCKADE AND CLEARS AREA OF VEHICLES
    local stockade = GetHashKey("stockade")
    exports["soe-utils"]:LoadModel(stockade, 15)
    ClearAreaOfVehicles(pos.x, pos.y, pos.z, 15.0, 0, 0, 0, 0, 0)
    veh = CreateVehicle(stockade, pos.x, pos.y, pos.z, -2.436, true, true)

    -- SET VEHICLE PROPERTIES
    local taken = false
    SetEntityHeading(veh, 52.00)
    SetEntityAsMissionEntity(veh, true, true)

    -- SET BLIP
    local blip = AddBlipForEntity(veh)
    SetBlipSprite(blip, 477)
    SetBlipColour(blip, 2)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Armored Truck")
    EndTextCommandSetBlipName(blip)

    SetBlipScale(blip, 0.75) 
    SetBlipAsShortRange(blip, true)

    -- CREATE PEDS
    local securityGuard = "s_m_m_armoured_01"
    exports["soe-utils"]:LoadModel(securityGuard, 15)

    local driver = CreatePedInsideVehicle(veh, 1, securityGuard, -1, true, true)
    local passenger = CreatePedInsideVehicle(veh, 1, securityGuard, 0, true, true)

    SetPedFleeAttributes(driver, 0, 0)
    SetPedFleeAttributes(passenger, 0, 0)

    SetPedCombatAttributes(driver, 46, 1)
    SetPedCombatAttributes(passenger, 46, 1)

    SetPedCombatAbility(driver, 100)
    SetPedCombatAbility(passenger, 100)

    SetPedCombatMovement(driver, 2)
    SetPedCombatMovement(passenger, 2)

    SetPedCombatRange(driver, 2)
    SetPedCombatRange(passenger, 2)

    SetPedKeepTask(driver, true)
    SetPedKeepTask(passenger, true)

    TaskEnterVehicle(passenger, veh, -1, 0, 1.0, 1)
    GiveWeaponToPed(driver, GetHashKey("WEAPON_COMBATPISTOL"), 250, false, true)
    GiveWeaponToPed(passenger, GetHashKey("WEAPON_SMG"), 250, false, true)

    SetPedAsCop(driver, true)
    SetPedAsCop(passenger, true)

    SetPedDropsWeaponsWhenDead(driver, false)
    SetPedDropsWeaponsWhenDead(passenger, false)

    TaskVehicleDriveWander(driver, veh, 80.0, 443)

    robbingTruck = true
    while not taken do
        Wait(5)
        local ped = PlayerPedId()
        local myPos = GetEntityCoords(ped)
        local truckPos = GetEntityCoords(veh) 
        local dist = GetDistanceBetweenCoords(myPos.x, myPos.y, myPos.z, truckPos.x, truckPos.y, truckPos.z, false)

        if robbingTruck then			
            if (dist <= 5) and not usedThermite then
                exports["soe-utils"]:HelpText("Press ~INPUT_DETONATE~ to open the door")
                if IsControlJustPressed(1, 47) then 
                    BlowDoorsUp()
                    Wait(500)
                end
            end
        end
        
        if usedThermite then
            if (dist > 45.0) then
                Wait(500)
            end
			
            if (dist <= 4.5) then
                exports["soe-utils"]:HelpText("Press ~INPUT_PICKUP~ to rob the truck")
                if IsControlJustPressed(0, 38) then 
                    usedThermite = false
                    RobTheMoney()
                    Wait(500)
                end
            end
        end
        
        if completedRobbery then
            armoredTrucks[truck].beingRobbed = false
            RemoveBlip(blip)
            taken = true
            robbingTruck = false
            completedRobbery = false

            -- 15 MINUTE COOLDOWN
            cooldown = GetGameTimer() + 900000
            break
        end
    end
end

-- START TRUCK ROBBERY MISSION
local function StartMission()
    -- CHECK COOLDOWN
    if (cooldown < GetGameTimer()) then
        -- RANDOMLY GENERATE OUR ARMORED TRUCK SPAWN LOCATION
        math.randomseed(GetGameTimer())
        local truck = math.random(1, #armoredTrucks)

        -- IF THE TRUCK IS ALREADY BEING ROBBED, REGENERATE
        local n = 0
        while (armoredTrucks[truck].beingRobbed and (n < 100)) do
            n = n + 1
            truck = math.random(1, #armoredTrucks)
        end

        -- START MISSION OR REPORT NONE AVAILABLE
        if (n) then
            TriggerEvent("Chat:Client:Message", "[Truck Robbery]", "It appears that no trucks are currently out there.", "standard")
        else
            TriggerEvent("Chat:Client:Message", "[Truck Robbery]", "You hack into the Gruppe6 database and found a truck to hit. Coordinates have been entered into your GPS.", "standard")
            SpawnTruck(truck)
        end
    end
end

-- HACK TO SEE WHERE THE ARMORED TRUCK IS
local function AcceptTruckRobberyMission()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    for _, v in pairs(startMissionSpots) do
        -- CHECK IF WE ARE NEAR THE STARTING POINT
        local dist = Vdist(pos, v.pos)
        if (dist <= 1.0) then
            -- RANDOMIZE HACKING DIFFICULTY
            math.randomseed(GetGameTimer())

            -- SKILLBAR AND ANIMATION
            exports["soe-utils"]:LoadAnimDict("anim@heists@prison_heiststation@cop_reactions", 15)
            TaskPlayAnim(ped, "anim@heists@prison_heiststation@cop_reactions", "cop_b_idle", 1.0, 1.0, -1, 49, 1.0, 0, 0, 0)
            exports["soe-ui"]:SendAlert("inform", "You begin hacking the Gruppe6 database", 4500)
        
            -- SKILLBAR MINIGAME
            if exports["soe-challenge"]:Skillbar(4000, math.random(5, 15)) then
                Wait(200)
                if exports["soe-challenge"]:Skillbar(3000, math.random(5, 15)) then
                    Wait(200)
                    if exports["soe-challenge"]:Skillbar(2500, math.random(5, 15)) then
                        Wait(200)
                        if exports["soe-challenge"]:Skillbar(2000, math.random(5, 15)) then
                            Wait(200)
                            if exports["soe-challenge"]:Skillbar(1950, math.random(5, 13)) then
                                Wait(200)
                                if exports["soe-challenge"]:Skillbar(1935, math.random(5, 10)) then
                                    Wait(200)
                                    if exports["soe-challenge"]:Skillbar(1750, math.random(5, 7)) then
                                        ClearPedTasks(ped)
                                        StartMission()
                                    end
                                end
                            end
                        end
                    end
                end
            end
            ClearPedTasks(ped)
        end
    end
end

-- RETURNS STARTING SPOTS
function GetTruckRobberyStartSpots()
    return startMissionSpots
end

AddEventHandler("Crime:Client:FindGruppe6Truck", AcceptTruckRobberyMission)

-- SYNCS TRUCK ROBBERY ALARM WITH LEOS
RegisterNetEvent("Crime:Client:SendTruckRobberyAlert")
AddEventHandler(
    "Crime:Client:SendTruckRobberyAlert",
    function(location, pos, details)
        -- GET CHARACTER DATA AND DUTY STATUS
        local char = exports["soe-uchuu"]:GetPlayer()
        local isOnDuty = exports["soe-jobs"]:IsOnDuty()
        if isOnDuty and (char.CivType == "POLICE") then
            -- TRUCK ROBBERY CAD ALERT
            local colors = exports["soe-utils"]:GrabVehicleColors()
            local desc = string.format(
                "An armored cash transport vehicle has activated its panic button in the area of %s.<br><br> The vehicle is a %s in color %s. Plate: %s",
                location,
                colors[tostring(details.color)],
                GetLabelText(GetDisplayNameFromVehicleModel(details.model)),
                details.plate
            )

            local volume = exports["soe-utils"]:GetSoundLevel()
            exports["soe-utils"]:PlaySound("1090-Alert.ogg", volume, true)
            TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = false, type = "Armored Cash Transport Robbery", desc = desc, code = "10-90", coords = pos})

            -- TRUCK ALERT LOCATION BLIP
            local opacity = 120
            local blip = AddBlipForRadius(pos.x, pos.y, pos.z, 70.0)

            SetBlipColour(blip, 38)
            SetBlipAlpha(blip, opacity)
            SetBlipFlashes(blip, true)
            SetBlipFlashInterval(blip, 550)

            while (opacity ~= 0) do
                Wait(250 * 4)
                opacity = opacity - 1
                SetBlipAlpha(blip, opacity)
                if (opacity == 0) then
                    RemoveBlip(blip)
                    return
                end
            end
        end
    end
)
