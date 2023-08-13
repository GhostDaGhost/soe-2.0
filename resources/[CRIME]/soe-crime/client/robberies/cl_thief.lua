local stolenPlate = ""
local isMugging = false
local parkingMeters = {`prop_parknmeter_01`, `prop_parknmeter_02`}

recentMuggings, robbedParkingMeters = {}, {}

-- DECORATORS
DecorRegister("noMugging", 3)

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, ROB THE CLOSEST PARKING METER
local function RobParkingMeter()
    local ped = PlayerPedId()
    if IsPedSittingInAnyVehicle(ped) then
        return
    end

    if (GetSelectedPedWeapon(ped) ~= `WEAPON_CROWBAR`) then
        exports["soe-ui"]:SendAlert("error", "You need a crowbar equipped to do this!", 5000)
        return
    end

    local pos = GetEntityCoords(ped)
    for i = 1, #parkingMeters do
        local meter = GetClosestObjectOfType(pos, 1.0, parkingMeters[i], 0, 0, 0)
        if DoesEntityExist(meter) and robbedParkingMeters[meter] then
            exports["soe-ui"]:SendAlert("error", "This meter was already hit!", 5000)
        elseif DoesEntityExist(meter) then
            TaskPlayAnim(ped, "melee@small_wpn@streamed_core", "car_down_attack", 2.5, 2.5, 1300, 1, 0, 0, 0, 0)
            Wait(900)
            PlaySoundFrontend(-1, "Drill_Pin_Break", "DLC_HEIST_FLEECA_SOUNDSET", 1)
            Wait(600)
            TaskPlayAnim(ped, "anim@am_hold_up@male", "shoplift_mid", 3.0, 3.0, 1000, 49, 0, 0, 0, 0)
            Wait(1000)

            math.randomseed(GetGameTimer())
            local config = exports["soe-config"]:GetConfigValue("economy", "parking_meter")
            local amount = math.random(config["min"], config["max"])

            -- NOTIFY THE REWARD AMOUNT
            robbedParkingMeters[meter] = true
            exports["soe-ui"]:SendAlert("warning", ("You earned $%s from smashing into this parking meter."):format(amount), 8500)
            TriggerServerEvent("Crime:Server:HandleRewards", {status = true, name = "cash", amt = amount})

            -- CAD ALERT
            math.randomseed(GetGameTimer())
            if (math.random(1, 100) <= 65) and exports["soe-emergency"]:ShouldReportInThisArea() then
                local loc = exports["soe-utils"]:GetLocation(pos)
                TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = true, type = "Parking Meter Tampering", loc = loc, coords = pos})
            end
        end
    end
end

-- MAIN MUGGING FUNCTION
local function MugLocal(entity)
    local ped = PlayerPedId()

    -- MAKE SURE THIS LOCAL ISN'T BLOCKED FROM MUGGING AND CHECK IF ITS A PLAYER TO BE SAFE
    if IsPedSittingInAnyVehicle(ped) or DecorExistOn(entity, "noMugging") or IsPedAPlayer(entity) or recentMuggings[entity] then
        return
    end

    -- IF THIS LOCAL IS A BANK TELLER
    if DecorExistOn(entity, "isBankTeller") and CanRobBankTeller() then
        DoBankTellerRobbery(entity)
        return
    end

    local pos, entPos = GetEntityCoords(ped), GetEntityCoords(entity)
    if #(pos - entPos) > 6.0 then
        return
    end

    local myJob = exports["soe-jobs"]:GetMyJob()
    if (myJob == "POLICE" or myJob == "EMS") then
        return
    end
    exports["soe-utils"]:GetEntityControl(entity)

    -- CALMING TASKS TO MAKE SURE LOCAL COMPLIES
    ClearPedTasks(entity)
    TaskTurnPedToFaceEntity(entity, ped, -1)
    TaskSetBlockingOfNonTemporaryEvents(entity, true)
    SetPedFleeAttributes(entity, 0, 0)

    -- START MUGGING PROCESS
    isMugging = true
    recentMuggings[entity] = true
    CreateThread(function()
        exports["soe-utils"]:LoadAnimDict("missfbi5ig_22", 15)
        while isMugging do
            Wait(150)
            -- ANIMATION PERSISTENCE
            if not IsEntityPlayingAnim(entity, "missfbi5ig_22", "hands_up_anxious_scientist", 3) then
                TaskPlayAnim(entity, "missfbi5ig_22", "hands_up_anxious_scientist", 5.0, 1.0, -1, 1, 0, 0, 0, 0)
            end

            -- IF TOO FAR FROM LOCAL, CANCEL ALL
            pos = GetEntityCoords(ped)
            entPos = GetEntityCoords(entity)
            if #(pos - entPos) > 7.0 then
                isMugging = false
                StopAnimTask(entity, "missfbi5ig_22", "hands_up_anxious_scientist", -2.0)
                TaskSmartFleePed(entity, ped, 5000.0, -1, true, true)
                exports["soe-ui"]:SendAlert("error", "You got too far from this individual!", 5000)
            end

            -- CHECK IF THE LOCAL GOT MURDERED IN THE PROCESS
            if IsEntityDead(entity) then
                isMugging = false
                exports["soe-ui"]:SendAlert("error", "The individual died before you could mug them!", 5000)
            end
        end
    end)

    Wait(8500)
    if isMugging then
        isMugging = false
        StopAnimTask(entity, "missfbi5ig_22", "hands_up_anxious_scientist", -2.0)

        -- A 75% CHANCE OF A (POSSIBLY) SUCCESSFUL MUGGING. IF UNLUCKY, LOCAL WILL FIGHT BACK WITH A GUN
        math.randomseed(GetGameTimer())
        math.random() math.random() math.random()
        Wait(1500)

        if (math.random(0, 100) <= 75) then
            exports["soe-utils"]:LoadAnimDict("mp_common", 15)
            TaskPlayAnim(entity, "mp_common", "givetake1_a", 1.0, 1.0, 2000, 1, 0, 0, 0, 0)
            TriggerServerEvent("Crime:Server:MugLocal")

            Wait(2000)
            ClearPedTasksImmediately(entity)
            TaskSmartFleePed(entity, ped, 5000.0, -1, true, true)

            if exports["soe-emergency"]:ShouldReportInThisArea() then
                Wait(2500)
                local loc = exports["soe-utils"]:GetLocation(pos)
                --TriggerServerEvent("Emergency:Server:CADAlerts", "Mugging", location, '', pos)
                TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = true, type = "Mugging", loc = loc, coords = pos})
            end
        else
            ClearPedTasksImmediately(entity)
            -- SET COMBAT ATTRIBUTES
            SetPedCombatAttributes(entity, 2, true)
            SetPedCombatAttributes(entity, 20, true)
            SetPedCombatAttributes(entity, 46, true)

            -- GIVE A WEAPON TO THE PED AND COMMAND TO ATTACK PLAYER
            GiveWeaponToPed(entity, GetHashKey("WEAPON_COMBATPISTOL"), 90, 0, 1)
            TaskCombatPed(entity, ped, 0, 16)
            SetPedDropsWeaponsWhenDead(entity, false)
        end
    end
end

local function RemoveLicensePlate()
    local removalTime = math.random(6500, 9500)
    local veh = exports["soe-utils"]:GetVehInFrontOfPlayer(5.0)
    if (veh ~= nil and stolenPlate == "") then
        exports["soe-utils"]:Progress(
            {
                name = "removingPlate",
                duration = removalTime,
                label = "Removing License Plate",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true
                },
                animation = {
                    animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                    anim = "machinic_loop_mechandplayer",
                    flags = 1
                }
            },
            function(cancelled)
                if not cancelled then
                    local ped = PlayerPedId()
                    local plate = GetVehicleNumberPlateText(veh)
                    stolenPlate = plate

                    ClearPedTasks(ped)
                    SetVehicleNumberPlateText(veh, "")
                    TriggerServerEvent("Crime:Server:GiveFakePlate", plate)
                    exports["soe-ui"]:SendAlert("inform", string.format("You have taken a license plate | Plate: %s", plate), 5000)

                    -- HAVE A CHANCE FOR A LOCAL TO SEE THE PLATE GET STOLEN
                    local shouldReport = exports["soe-emergency"]:ShouldReportInThisArea()
                    if shouldReport then
                        TriggerServerEvent("Emergency:Server:MarkStolen", plate, true, true)
                    end
                end
            end
        )
    else
        exports["soe-ui"]:SendAlert("error", "No vehicle nearby or you already have a plate", 3500)
    end
end

local function InstallNewLicensePlate()
    local placingTime = math.random(6500, 9500)
    local veh = exports["soe-utils"]:GetVehInFrontOfPlayer(5.0)
    if veh ~= nil and stolenPlate ~= "" then
        exports["soe-utils"]:Progress(
            {
                name = "placingPlate",
                duration = placingTime,
                label = "Placing License Plate",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true
                },
                animation = {
                    animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                    anim = "machinic_loop_mechandplayer",
                    flags = 1
                }
            },
            function(cancelled)
                if not cancelled then
                    local ped = PlayerPedId()

                    ClearPedTasks(ped)
                    SetVehicleNumberPlateText(veh, stolenPlate)
                    exports["soe-ui"]:SendAlert("inform", string.format("You have placed a new license plate | Plate: %s", stolenPlate), 5000)
                    stolenPlate = ""
                end
            end
        )
    else
        exports["soe-ui"]:SendAlert("error", "No vehicle nearby or you don't have a plate", 3500)
    end
end

-- **********************
--    Global Functions
-- **********************
-- START A LOCKPICK MINIGAME ON VEHICLE YOU ARE FACING
function LockpickVehicle()
    local veh = exports["soe-utils"]:GetVehInFrontOfPlayer(5.0)
    if (veh ~= nil) then
        -- HAVE A 40% CHANCE TO PLAY AN ALARM
        math.randomseed(GetGameTimer())
        if (math.random(1, 100) <= 40) then
            SetVehicleAlarm(veh, true)
            SetVehicleAlarmTimeLeft(veh, 12000)
        end

        -- BEGIN LOCKPICK MINIGAME
        if exports["soe-challenge"]:StartLockpicking(true) then
            -- DRIVER VARIABLES
            local driver = GetPedInVehicleSeat(veh, -1)
            local occupied = (driver ~= nil and driver ~= 0)

            -- GET ENTITY CONTROL
            DecorSetBool(veh, "unlocked", true)
            exports["soe-utils"]:GetEntityControl(veh)

            -- UNLOCK VEHICLE
            SetVehicleDoorsLocked(veh, 1)
            SetVehicleDoorsLockedForAllPlayers(veh, false)

            -- SEND CAD ALERT IF VEHICLE WAS OCCUPIED
            if occupied then
                local pos = GetEntityCoords(PlayerPedId())
                local primary = GetVehicleColours(veh)
                local plate = GetVehicleNumberPlateText(veh)
                local loc = exports["soe-utils"]:GetLocation(pos)

                TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = true, type = "Carjacking",
                    loc = loc, model = GetEntityModel(veh), color = primary, plate = plate, coords = pos
                })
            else
                -- SILENTLY REPORT VEHICLE STOLEN
                local plate = GetVehicleNumberPlateText(veh)
                TriggerServerEvent("Emergency:Server:MarkStolen", plate, true, true)
            end
        end
    end
end

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, ROB PARKING METER
AddEventHandler("Crime:Client:RobMeter", RobParkingMeter)

-- CALLED WHEN A LOCKPICK IS USED TO LOCKPICK A VEHICLE
AddEventHandler("Inventory:Client:UseLockpick", LockpickVehicle)

-- CALLED AFTER "/removeplate" IS EXECUTED
RegisterNetEvent("Crime:Client:RemovePlate", RemoveLicensePlate)

-- CALLED AFTER "/placeplate" IS EXECUTED // WIP
RegisterNetEvent("Crime:Client:PlacePlate", InstallNewLicensePlate)

-- INTERACTION KEYPRESS
AddEventHandler("Utils:Client:InteractionKey", function()
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
        return
    end

    local found, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
    if found and IsEntityAPed(entity) and IsPedHuman(entity) and not IsEntityDead(entity) and not IsPedSittingInAnyVehicle(entity) then
        MugLocal(entity)
    end
end)
