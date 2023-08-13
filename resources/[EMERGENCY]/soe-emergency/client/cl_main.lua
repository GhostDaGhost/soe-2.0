local cycling, cycledWeaponSelected = false, 1
local inRehab, activeHeal, isFindingPeds = false, false, false
dispatch = {}

-- KEY MAPPINGS
RegisterKeyMapping("cycleguns", "Cycle Weapons (LEO ONLY)", "keyboard", "Z")

-- CYCLE WEAPONS THROUGH THE "Z" KEY
local function CycleWeapons()
    local ped = PlayerPedId()
    local myJob = exports["soe-jobs"]:GetMyJob()
    if IsPedInAnyVehicle(ped, false) and (myJob == "POLICE") and not cycling then
        cycling = true
        if (cycledWeaponSelected == 1) then
            if HasPedGotWeapon(ped, "WEAPON_COMBATPISTOL", false) then
                SetCurrentPedWeapon(ped, GetHashKey("WEAPON_COMBATPISTOL"), true)
                TriggerEvent("Chat:Client:Message", "[Police]", "Combat Pistol readied.", "standard")
            else
                exports["soe-ui"]:SendAlert("error", "You do not have a Combat Pistol equipped", 5000)
            end
            cycledWeaponSelected = 2
        elseif (cycledWeaponSelected == 2) then
            if HasPedGotWeapon(ped, "WEAPON_STUNGUN", false) then
                SetCurrentPedWeapon(ped, GetHashKey("WEAPON_STUNGUN"), true)
                TriggerEvent("Chat:Client:Message", "[Police]", "Taser readied.", "standard")
            else
                exports["soe-ui"]:SendAlert("error", "You do not have a Taser equipped", 5000)
            end
            cycledWeaponSelected = 3
        elseif (cycledWeaponSelected == 3) then
            if HasPedGotWeapon(ped, "WEAPON_CARBINERIFLE", false) then
                SetCurrentPedWeapon(ped, GetHashKey("WEAPON_CARBINERIFLE"), true)
                TriggerEvent("Chat:Client:Message", "[Police]", "Carbine Rifle readied.", "standard")
            else
                exports["soe-ui"]:SendAlert("error", "You do not have a Carbine Rifle equipped", 5000)
            end
            cycledWeaponSelected = 4
        elseif (cycledWeaponSelected == 4) then
            if HasPedGotWeapon(ped, "WEAPON_PUMPSHOTGUN", false) then
                SetCurrentPedWeapon(ped, GetHashKey("WEAPON_PUMPSHOTGUN"), true)
                TriggerEvent("Chat:Client:Message", "[Police]", "Pump Shotgun readied.", "standard")
            else
                exports["soe-ui"]:SendAlert("error", "You do not have a Pump Shotgun equipped", 5000)
            end
            cycledWeaponSelected = 5
        elseif (cycledWeaponSelected == 5) then
            if HasPedGotWeapon(ped, "WEAPON_CARBINERIFLE_MK2", false) then
                SetCurrentPedWeapon(ped, GetHashKey("WEAPON_CARBINERIFLE_MK2"), true)
                TriggerEvent("Chat:Client:Message", "[Police]", "Carbine Rifle MK II readied.", "standard")
            else
                exports["soe-ui"]:SendAlert("error", "You do not have a Carbine Rifle MK II equipped", 5000)
            end
            cycledWeaponSelected = 6
        elseif (cycledWeaponSelected == 6) then
            if HasPedGotWeapon(ped, "WEAPON_PISTOL_MK2", false) then
                SetCurrentPedWeapon(ped, GetHashKey("WEAPON_PISTOL_MK2"), true)
                TriggerEvent("Chat:Client:Message", "[Police]", "Pistol MK II readied.", "standard")
            else
                exports["soe-ui"]:SendAlert("error", "You do not have a Pistol MK II equipped", 5000)
            end
            cycledWeaponSelected = 7
        elseif (cycledWeaponSelected == 7 and HasPedGotWeapon(ped, GetHashKey("WEAPON_UNARMED"), false)) then
            SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
            TriggerEvent("Chat:Client:Message", "[Police]", "Nothing readied.", "standard")
            cycledWeaponSelected = 1
        else
            cycledWeaponSelected = cycledWeaponSelected + 1
            if (cycledWeaponSelected == 7) then
                cycledWeaponSelected = 1
            end
            CycleWeapons()
        end
    end
    Wait(250)
    cycling = false
end

-- GET DESCRIPTION OF THE PLAYER // WIP
local function GetMyDescription(ped)
    local myDescription
    -- PROVIDE A 75% CHANCE OF SOME DESCRIPTION BEING PROVIDED
    math.randomseed(GetGameTimer())
    if (math.random(0, 100) < 75) then
        -- DEFAULT DESCRIPTION VARIABLES
        local myGender = "Unknown Gender"
        local carryingWeapon = "appears to be unarmed"

        -- START GRABBING OUR DESCRIPTION
        local male = GetHashKey("mp_m_freemode_01")
        local female = GetHashKey("mp_f_freemode_01")
        if (GetEntityModel(ped) == male) then
            myGender = "Male"
        elseif (GetEntityModel(ped) == female) then
            myGender = "Female"
        end

        -- CHECK IF THE PLAYER IS WEARING A HELMET
        local wearingHelmet = false
        -- TO BE CONTINUED INDEXING ~ Ghost 11/17/2020
        if (myGender == "Male" or myGender == "Female") then
            local helmetIndex = GetPedPropIndex(ped, 0)
            if (helmetIndex == 16 or helmetIndex == 17 or helmetIndex == 18 or helmetIndex == 38 or helmetIndex == 39 or helmetIndex == 47 or helmetIndex == 48 or helmetIndex == 49 or helmetIndex == 50 or helmetIndex == 51 or helmetIndex == 52 or helmetIndex == 53 or helmetIndex == 60 or helmetIndex == 62 or helmetIndex == 67 or helmetIndex == 68) then
                wearingHelmet = true
            end
        end

        -- CHECK IF THE PLAYER IS MASKED
        local isMasked = false
        if (myGender == "Male" or myGender == "Female") then
            local maskIndex = GetPedDrawableVariation(ped, 1)
            if (maskIndex ~= 0 and maskIndex ~= 27 and maskIndex ~= 73 and maskIndex ~= 109 and maskIndex ~= 120 and maskIndex ~= 121 and maskIndex ~= 122) then
                isMasked = true
            end
        end

        -- CHECK IF WE ARE INJURED
        local looksHurt = false
        if (GetEntityHealth(ped) < 170) then
            looksHurt = true
        end

        -- CHECK WHAT WE ARE ARMED WITH
        if IsPedArmed(ped, 1) then
            carryingWeapon = "carrying a melee weapon"
        elseif IsPedArmed(ped, 2) then
            carryingWeapon = "carrying an explosive device"
        elseif IsPedArmed(ped, 4) then
            carryingWeapon = "carrying a firearm"
        end

        -- CONSTRUCT OUR DESCRIPTION
        if looksHurt then
            -- IF THEY ARE WEARING A HELMET, ADD IT TO THE DESCRIPTION
            if wearingHelmet then
                -- IF THEY ARE MASKED, ADD IT TO THE DESCRIPTION
                if isMasked then
                    myDescription = string.format("Description of individual is a masked %s wearing a helmet and %s. Caller states that it looks like they're hurt.", myGender, carryingWeapon)
                else
                    myDescription = string.format("Description of individual is a %s wearing a helmet and %s. Caller states that it looks like they're hurt.", myGender, carryingWeapon)
                end
            else
                -- IF THEY ARE MASKED, ADD IT TO THE DESCRIPTION
                if isMasked then
                    myDescription = string.format("Description of individual is a masked %s %s. Caller states that it looks like they're hurt.", myGender, carryingWeapon)
                else
                    myDescription = string.format("Description of individual is a %s %s. Caller states that it looks like they're hurt.", myGender, carryingWeapon)
                end
            end
        else
            -- IF THEY ARE WEARING A HELMET, ADD IT TO THE DESCRIPTION
            if wearingHelmet then
                -- IF THEY ARE MASKED, ADD IT TO THE DESCRIPTION
                if isMasked then
                    myDescription = string.format("Description of individual is a masked %s wearing a helmet and %s.", myGender, carryingWeapon)
                else
                    myDescription = string.format("Description of individual is a %s wearing a helmet and %s.", myGender, carryingWeapon)
                end
            else
                -- IF THEY ARE MASKED, ADD IT TO THE DESCRIPTION
                if isMasked then
                    myDescription = string.format("Description of individual is a masked %s %s.", myGender, carryingWeapon)
                else
                    myDescription = string.format("Description of individual is a %s %s.", myGender, carryingWeapon)
                end
            end
        end
    else
        -- NO DESCRIPTION DUE TO UNLUCKINESS
        myDescription = "No description provided by the caller."
    end
    -- FINALLY RETURN OUR PED DESCRIPTION
    return myDescription
end

-- WHEN TRIGGERED, HANDLE CAD ALERTS BASED OFF DATA
local function HandleCADAlerts(call)
    if not call.status then return end
    local alert = alerts[tostring(call.data.type)]

    -- SET SOME DESCRIPTION VARIABLES
    --print(json.encode(call.data))
    local color, model
    if call.data.model then
        model = GetLabelText(GetDisplayNameFromVehicleModel(call.data.model))
        color = exports["soe-utils"]:GrabVehicleColors()[tostring(call.data.color)]
    end

    -- IF THE CALL TYPE USES A CUSTOM CODE, DO THIS
    local code = "10-31"
    local plate = call.data.plate
    local offSet, radius = true, true
    local blipType, blipColor, blipSize = 459, 1, 1.0
    if not alert then
        code = call.data.code
    else
        -- DEFAULT TO CODE INPUTTED IN THE DATA
        code = alert.code

        -- IF THE CALL TYPE USES PARTIAL PLATE, DO THIS
        if alert.partialPlate then
            plate = (plate):sub(2, 5)
        end
    end

    -- CONSTRUCT OUR ALERT MESSAGE
    local msg = "No further information provided. (ERR-NO-DATA)"
    if (call.data.type == "Shots Fired") then
        msg = (alert.desc):format(call.data.loc)
        blipType = 110
        blipColor = 40
    elseif (call.data.type == "Drive-By Shooting") then
        msg = (alert.desc):format(call.data.loc, color, model, plate)
        blipType = 229
        blipColor = 40
    elseif (call.data.type == "Homicide") then
        msg = (alert.desc):format(call.data.loc)
        blipType = 303
        blipColor = 4
    elseif (call.data.type == "Tire Slashing") then
        msg = (alert.desc):format(call.data.loc)
    elseif (call.data.type == "Parking Meter Tampering") then
        msg = (alert.desc):format(call.data.loc)
    elseif (call.data.type == "Mugging") then
        msg = (alert.desc):format(call.data.loc)
        blipType = 280
    elseif (call.data.type == "ATM Tampering") then
        msg = call.data.desc
        blipType = 642
        blipSize = 0.8
        offSet = false
    elseif (call.data.type == "Attempted Vehicle Break-In") then
        msg = (alert.desc):format(call.data.loc)
        blipType = 225
        blipColor = 29
    elseif (call.data.type == "Armed Carjacking") then
        msg = (alert.desc):format(call.data.loc, color, model, plate)
        blipType = 229
        blipColor = 29
    elseif (call.data.type == "Carjacking") then
        msg = (alert.desc):format(call.data.loc, color, model, plate)
        blipType = 225
        blipColor = 29
    elseif (call.data.type == "Grand Theft Auto") then
        msg = (alert.desc):format(call.data.loc, color, model, plate)
        blipType = 225
        blipColor = 29
    elseif (call.data.type == "Vehicle Break-In") then
        msg = (alert.desc):format(call.data.loc, color, model, plate)
        blipType = 225
        blipColor = 29
    elseif (call.data.type == "Attempted Carjacking") then
        msg = (alert.desc):format(call.data.loc, color, model, plate)
        blipType = 225
        blipColor = 29
    elseif (call.data.type == "Attempted Armed Carjacking") then
        msg = (alert.desc):format(call.data.loc, color, model, plate)
        blipType = 229
        blipColor = 29
    elseif (call.data.type == "Suspicious Transaction") then
        msg = (alert.desc):format(call.data.loc, color, model, plate)
        blipType = 501
        blipColor = 40
    elseif (call.data.type == "Motor Vehicle Collision") then
        msg = (alert.desc):format(call.data.loc, color, model)
        blipType = 380
    elseif (call.data.type == "Attempted Drug Sale") then
        msg = (alert.desc):format(call.data.loc)
        blipType = 501
        blipColor = 40
    elseif (call.data.type == "Illegal Fishing") then
        msg = (alert.desc):format(call.data.loc)
        blipColor = 40
    elseif (call.data.type == "Commercial Alarm") then
        msg = call.data.desc
        blipType = 642
        blipSize = 0.8
        offSet = false
    elseif (call.data.type == "Commercial Alarm (Store)") then
        msg = call.data.desc
        blipType = 642
        blipSize = 0.8
        offSet = false
    elseif (call.data.type == "Home Invasion") then
        msg = call.data.desc
        blipType = 418
        blipSize = 0.8
        offSet = false
    elseif (call.data.type == "Warehouse Burglary") then
        msg = call.data.desc
        blipType = 473
        blipSize = 0.8
        offSet = false
    elseif (call.data.type == "10-38") then
        msg = (alert.desc):format(call.data.callSign, color, model, plate, call.data.loc)
        blipType = 56
        blipColor = 32
        blipSize = 0.8
        offSet = false
        radius = false
    elseif (call.data.type == "10-78") then
        msg = (alert.desc):format(call.data.callSign, call.data.loc)
        blipColor = 46
        blipSize = 1.25
        offSet = false
        radius = false
    elseif (call.data.type == "10-75") then
        msg = (alert.desc):format(call.data.callSign, call.data.loc, call.data.callSign)
        blipType = 540
        blipColor = 44
        blipSize = 0.75
        offSet = false
        radius = false
    else
        msg = call.data.desc
    end

    -- UPDATE LOCAL DATA WITH SERVER DATA
    CADAlerts = exports["soe-nexus"]:TriggerServerCallback("Emergency:Server:GetCADs")
    TriggerEvent("Chat:Client:Message", ("[CAD #%s (%s)]"):format(call.data.cadID, call.time), ("^1[%s] ^7%s"):format(code, msg), "cad")
    if not dispatch.isMuted then
        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    end

    -- CREATE BLIP FOR CAD
    --[[print("code", code)
    print("call.data.type", call.data.type)
    print("call.data.coords", call.data.coords)]]

    local blipCoords = call.data.coords
    local x, y, z = table.unpack(blipCoords)
    --print("Original blipCoords", blipCoords)

    if offSet then
        -- BLIP OFFSET
        x = call.data.offSet.xOffset
        y = call.data.offSet.yOffset
        blipCoords = vector3(x, y, z)
        --print("New blipCoords", blipCoords)
    end

    local blip = AddBlipForCoord(blipCoords)
    SetBlipSprite(blip, blipType)
    SetBlipColour(blip, blipColor)
    SetBlipScale(blip, blipSize)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(code)
    EndTextCommandSetBlipName(blip)

    local radiusBlip, opacity, alternate = nil, 100, false
    if radius then
        radiusBlip = AddBlipForRadius(blipCoords, 50.0)
        SetBlipColour(radiusBlip, 1)
        SetBlipAlpha(radiusBlip, opacity)
        SetBlipFlashes(radiusBlip, true)
        SetBlipFlashInterval(radiusBlip, 200)
    end

    while opacity >= 0 do
        Wait(750)

        opacity = opacity - 1
        if radius then
            -- GRADUALLY FADES THE RADIUS BLIP
            SetBlipAlpha(radiusBlip, opacity)

            -- FLASHES THE BLIP BETWEEN RED AND BLUE
            alternate = not alternate
            if alternate then
                SetBlipColour(radiusBlip, 1)
            else
                SetBlipColour(radiusBlip, 38)
            end
        end

        -- REMOVES THE BLIPS WHEN OPACITY REACHES 0
        if opacity <= 0 then
            RemoveBlip(blip)
            RemoveBlip(radiusBlip)
            return
        end
    end
end

-- RETURNS IF PLAYER IS IN REHAB
function IsInRehab()
    return inRehab
end

-- USES THE TINT METER TO RETURN TINT LEVEL
function UseTintMeter()
    local veh = exports["soe-utils"]:GetVehInFrontOfPlayer(5.0)
    if (veh ~= nil) then
        -- GET TINT LEVEL NAMES
        TriggerEvent("Chat:Client:SendMessage", "me", "You start measuring the window tint.")

        -- ANIMATION CONTROL
        local ped = PlayerPedId()
        local dict = "weapons@first_person@aim_rng@generic@projectile@shared@core"
        local anim = "idlerng_med"
        exports["soe-utils"]:LoadAnimDict(dict, 15)
        TaskPlayAnim(ped, dict, anim, 1.0, -1.0, 5000, 49, 0, 0, 0, 0)

        Wait(5000)
        local result
        local tint = GetVehicleWindowTint(veh)
        -- SEARCH THROUGH OUR TINT TABLE FOR THE NAME
        if (tintLevels[tint] == nil) then
            result = "Unknown Tint"
        else
            result = tintLevels[tint]
        end

        -- RETURN THE TINT LEVEL
        TriggerEvent("Chat:Client:Message", "[Tint Meter]", string.format("The tint meter returns as: %s.", result), "standard")
    end
end

-- SEARCHES THE PLAYER'S ZONE FOR PEDS AND RETURNS A VALUE IF A PLAYER IS SEEN
function ShouldReportInThisArea()
    local player = PlayerPedId()
    local myPos = GetEntityCoords(player)
    local zone = GetNameOfZone(myPos)
    local seenChance = reportChances[zone]
    local oldped = nil
    if (seenChance == nil) then
        seenChance = 0.3
    end

    -- NORMALIZE TO SCORE IN 0-100
    chance = seenChance * 100
    -- CHECK TO SEE IF PLAYER IS DIRECTLY SEEN
    local handle, ped = FindFirstPed()
    local success
    if isFindingPeds then
        return
    end

    repeat
        isFindingPeds = true
        success, ped = FindNextPed(handle)
        local pos = GetEntityCoords(ped)
        local pedType = GetPedType(ped)
        local dist = GetDistanceBetweenCoords(pos, myPos, true)
        if DoesEntityExist(ped) and not IsPedDeadOrDying(ped) and dist <= 50.0 and ped ~= player and ped ~= oldped and pedType ~= 28 and not IsPedAPlayer(ped) then
            oldped = ped
            if HasEntityClearLosToEntity(ped, player, 17) or dist <= 15.0 then
                local rannum = math.random(1, 100)
                if (rannum <= chance) then
                    EndFindPed(handle)
                    isFindingPeds = false
                    return true
                end
            end
        end
    until not success
    EndFindPed(handle)
    isFindingPeds = false

    -- IF PLAYER IS NOT SEEN, LET THERE STILL BE CHANCE TO REPORT
    chance = ((seenChance * 0.6) - ((1.0 - seenChance) * 0.2)) * 100
    if chance < 0.0 then
        chance = 0.0
    end

    local rannum = math.random(1, 100)
    if rannum <= chance then
        return true
    end
    return false
end

-- ***********************
--        Commands
-- ***********************
-- WHEN TRIGGERED, CYCLE WEAPONS
RegisterCommand("cycleguns", CycleWeapons)

-- WHEN TRIGGERED, ACTIVATE 10-13
RegisterCommand("13", function()
    local myJob = exports["soe-jobs"]:GetMyJob()
    if (myJob == "POLICE" or myJob == "EMS") then
        exports["soe-utils"]:LoadAnimDict("random@arrests", 15)
        TaskPlayAnim(PlayerPedId(), "random@arrests", "generic_radio_chatter", 3.0, 3.0, 1000, 49, 0, 0, 0, 0)

        local pos = GetEntityCoords(PlayerPedId())
        local loc = exports["soe-utils"]:GetLocation(pos)
        TriggerServerEvent("Emergency:Server:Declare1013", {status = true, pos = pos, loc = loc})
    else
        TriggerEvent("Chat:Client:SendMessage", "system", "This command is only available for Emergency Services.")
    end
end)

-- ***********************
--         Events
-- ***********************
-- WHEN TRIGGERED, HANDLE CAD ALERTS FROM THE SERVER
RegisterNetEvent("Emergency:Client:CADAlerts")
AddEventHandler("Emergency:Client:CADAlerts", HandleCADAlerts)

-- CALLED FROM THE SERVER AFTER "/bodybag" IS EXECUTED
RegisterNetEvent("Emergency:Client:DeletePed")
AddEventHandler("Emergency:Client:DeletePed", function()
    local ped = exports["soe-utils"]:GetPedInFrontOfPlayer(5.0)
    if (ped ~= nil and ped ~= 0) and IsEntityDead(ped) then
        TriggerServerEvent("Utils:Server:DeleteEntity", PedToNet(ped))
    end
end)

-- RETURN CHARACTER KEYS IF THEY HAD SOME
AddEventHandler("Uchuu:Client:CharacterSelected", function()
    Wait(3500)
    local setting = json.encode(exports["soe-uchuu"]:GetPlayer().Settings)
    setting = json.decode(setting)
    if setting["mutedDispatch"] then
        dispatch.isMuted = true
    end
end)

RegisterNetEvent("Emergency:Client:OpenDogDoors")
AddEventHandler("Emergency:Client:OpenDogDoors", function(data)
    if not data.status then return end
    local veh = GetVehiclePedIsIn(PlayerPedId(), true)
    SetVehicleDoorOpen(veh, 2, false, false)
end)

RegisterNetEvent("Emergency:Client:MuteDispatchNotifs")
AddEventHandler("Emergency:Client:MuteDispatchNotifs", function(data)
    if not data.status then return end

    dispatch.isMuted = not dispatch.isMuted
    if dispatch.isMuted then
        exports['soe-ui']:SendAlert("inform", "Dispatch: Muted", 3500)
        exports["soe-uchuu"]:UpdateSettings("mutedDispatch", false, true)
    else
        exports['soe-ui']:SendAlert("inform", "Dispatch: Unmuted", 3500)
        exports["soe-uchuu"]:UpdateSettings("mutedDispatch", true)
    end
end)

-- CALLED FROM THE SERVER AFTER "/impound" IS EXECUTED
RegisterNetEvent("Emergency:Client:ImpoundVehicle")
AddEventHandler("Emergency:Client:ImpoundVehicle", function(courtesy)
    local veh = exports["soe-utils"]:GetVehInFrontOfPlayer(5.0)
    if (veh ~= nil) and IsEntityAVehicle(veh) then
        -- POSSIBLY MAKE IT PERSIST
        SetEntityAsMissionEntity(veh, true)
        local plate = GetVehicleNumberPlateText(veh)
        local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh)))
        TriggerServerEvent("Emergency:Server:ImpoundVehicle", model, plate, courtesy)
    end
end)

-- CALLED FROM THE SERVER AFTER "/doggo" IS EXECUTED
RegisterNetEvent("Emergency:Client:TransformToDog")
AddEventHandler("Emergency:Client:TransformToDog", function()
    local doggo = GetHashKey("a_c_shepherd")
    exports["soe-utils"]:LoadModel(doggo, 15)

    SetPlayerModel(PlayerId(), doggo)
    SetModelAsNoLongerNeeded(doggo)

    local ped = PlayerPedId()
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
    SetPedRandomComponentVariation(ped, false)

    while exports["soe-utils"]:IsModelADog(PlayerPedId()) do
        Wait(1550)
        if not exports["soe-utils"]:IsModelADog(ped) then return end

        RemoveAllPedWeapons(ped, true)
        GiveWeaponToPed(ped, GetHashKey("WEAPON_ANIMAL"), 200, false, true)
        SetWeaponDamageModifier(GetHashKey("WEAPON_ANIMAL"), 3.5)

        ResetPlayerStamina(PlayerId())
        SetPlayerMeleeWeaponDamageModifier(PlayerId(), 3.5)
        SetPlayerWeaponDamageModifier(PlayerId(), 3.5)
    end
end)

-- CALLED FROM THE SERVER AFTER "/removeh" IS EXECUTED
RegisterNetEvent("Emergency:Client:DeleteVehicle")
AddEventHandler("Emergency:Client:DeleteVehicle", function()
    local veh = exports["soe-utils"]:GetVehInFrontOfPlayer(5.0)
    if (veh ~= nil) and IsEntityAVehicle(veh) then
        -- ALT
        --TriggerEvent('persistent-vehicles/forget-vehicle', veh)

        TriggerServerEvent("Utils:Server:DeleteEntity", VehToNet(veh))
        Wait(750)
        if DoesEntityExist(veh) then
            DeleteEntity(veh)
        end
    end
end)

-- CALLED FROM THE SERVER AFTER "/pullout" IS EXECUTED
RegisterNetEvent("Emergency:Client:PulloutOptions")
AddEventHandler("Emergency:Client:PulloutOptions", function()
    local veh = exports["soe-utils"]:GetVehInFrontOfPlayer(5.0)
    if veh then
        -- LOCK CHECK BEFORE PULLING OUT
        if (GetVehicleDoorLockStatus(veh) == 2) then
            exports["soe-ui"]:SendAlert("error", "Vehicle is locked!", 5000)
            return
        end

        -- ITERATE THROUGH ALL SEATS AND PULL EACH ONE OUT
        for i = GetVehicleMaxNumberOfPassengers(veh), -1, -1 do
            if not IsVehicleSeatFree(veh, i) then
                local ped = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(veh, i))
                if (ped ~= -1) then
                    TriggerServerEvent("Emergency:Server:Pullout", GetPlayerServerId(ped))
                end
            end
        end
    end
end)

-- CALLED FROM THE SERVER AFTER "/heal" IS DIRECTLY EXECUTED
RegisterNetEvent("Emergency:Client:Heal")
AddEventHandler("Emergency:Client:Heal", function()
    local char = exports["soe-uchuu"]:GetPlayer()
    if (char.CivType == "EMS") then
        local player = exports["soe-utils"]:GetClosestPlayer(5)
        if (player ~= nil) then
            TriggerServerEvent("Emergency:Server:HealPlayer", GetPlayerServerId(player))
        end
    else
        TriggerEvent("Chat:Client:SendMessage", "system", "This command is only available to SAFR.")
    end
end)

-- CALLED FROM SERVER AFTER "/vin" IS EXECUTED
RegisterNetEvent("Emergency:Client:FindVehicleVin")
AddEventHandler("Emergency:Client:FindVehicleVin", function()
    local veh = exports["soe-utils"]:GetVehInFrontOfPlayer(5.0)
    if (veh ~= nil) then
        local vin = DecorGetInt(veh, "vin")
        if (vin ~= 0) then
            TriggerEvent("Chat:Client:Message", "[VIN]", ("You look for the vehicle's VIN and read out: %s"):format(vin), "standard")
        else
            TriggerEvent("Chat:Client:Message", "[VIN]", "You look around for the vehicle's VIN but find it unreadable.", "standard")
        end
    else
        exports["soe-ui"]:SendAlert("error", "No vehicle found", 5000)
    end
end)

-- CALLED FROM THE SERVER AFTER "/heal" AND ITS PRE-REQUISITE CLIENT EVENT "Emergency:Client:Heal"
RegisterNetEvent("Emergency:Client:HealPlayer")
AddEventHandler("Emergency:Client:HealPlayer", function()
    if not activeHeal then
        activeHeal = true
        exports["soe-healthcare"]:StopBleeding()
        local time = 0
        local ped = PlayerPedId()
        local health = GetEntityHealth(ped)
        while (time < 100) do
            Wait(500)
            time = time + 1
            health = health + 1
            SetEntityHealth(ped, health)
        end
        activeHeal = false
    end
end)

-- WHEN TRIGGERED, ADD A 10-13 BLIP WHERE THE ALERT CAME FROM
RegisterNetEvent("Emergency:Client:Declare1013")
AddEventHandler("Emergency:Client:Declare1013", function(data)
    if not data.status then return end
    if not data.pos then return end
    exports["soe-utils"]:PlayProximitySound(3.0, "panic_alert.ogg", 0.2)

    local blip = AddBlipForCoord(data.pos)

    -- SETS THE BLIP SPRITE DEPENDING ON ROLE
    if data.role == "POLICE" or data.role == "DISPATCH" then
        SetBlipSprite(blip, 60)
    elseif data.role == "EMS" then
        SetBlipSprite(blip, 61)
    end

    SetBlipColour(blip, 1)
    SetBlipScale(blip, 1.0)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("10-13")
    EndTextCommandSetBlipName(blip)

    local opacity = 105
    local radiusBlip = AddBlipForRadius(data.pos, 105.0)
    local alternate = false

    SetBlipColour(radiusBlip, 1)
    SetBlipAlpha(radiusBlip, opacity)
    SetBlipFlashes(radiusBlip, true)
    SetBlipFlashInterval(radiusBlip, 200)

    while opacity >= 0 do
        Wait(750)

        -- GRADUALLY FADES THE RADIUS BLIP
        opacity = opacity - 1
        SetBlipAlpha(radiusBlip, opacity)

        -- FLASHES THE BLIP BETWEEN RED AND BLUE
        alternate = not alternate
        if alternate then
            SetBlipColour(blip, 38)
            SetBlipColour(radiusBlip, 1)
        else
            SetBlipColour(blip, 1)
            SetBlipColour(radiusBlip, 38)
        end

        -- REMOVES THE BLIPS WHEN OPACITY REACHES 0
        if opacity <= 0 then
            RemoveBlip(blip)
            RemoveBlip(radiusBlip)
            return
        end
    end
end)

-- CALLED FROM THE SERVER AFTER "/putincar" IS EXECUTED
RegisterNetEvent("Emergency:Client:PutInCarOptions")
AddEventHandler("Emergency:Client:PutInCarOptions", function()
    local veh = exports["soe-utils"]:GetVehInFrontOfPlayer(3.0)
    if (veh ~= nil) then
        if IsEntityDead(veh) then return end

        local seat
        if IsVehicleSeatFree(veh, 2) then
            seat = 2
        elseif IsVehicleSeatFree(veh, 1) then
            seat = 1
        elseif IsVehicleSeatFree(veh, 0) then
            seat = 0
        end

        if (seat ~= nil) then
            -- RESET ESCORTING/CARRYING/DRAGGING STATUS
            local holding = exports["soe-civ"]:IsHolding()
            local dragging = exports["soe-civ"]:IsDragging()
            local carrying = exports["soe-civ"]:IsCarrying()
            local escorting = exports["soe-civ"]:IsEscorting()
            if (escorting ~= nil) then
                TriggerServerEvent("Civ:Server:EscortPlayer", escorting, false)
                TriggerServerEvent("Emergency:Server:PutInCar", escorting, VehToNet(veh), seat)
                exports["soe-civ"]:SetEscortingState(nil)
                ClearPedTasks(PlayerPedId())
            elseif (carrying ~= nil) then
                TriggerServerEvent("Civ:Server:CarryPlayer", carrying, false)
                TriggerServerEvent("Emergency:Server:PutInCar", carrying, VehToNet(veh), seat)
                exports["soe-civ"]:SetCarryingState(nil)
                ClearPedTasks(PlayerPedId())
            elseif (dragging ~= nil) then
                TriggerServerEvent("Civ:Server:DragPlayer", dragging, false)
                TriggerServerEvent("Emergency:Server:PutInCar", dragging, VehToNet(veh), seat)
                exports["soe-civ"]:SetDraggingState(nil)
                ClearPedTasks(PlayerPedId())
            elseif (holding ~= nil) then
                TriggerServerEvent("Civ:Server:HoldPlayer", holding, false)
                TriggerServerEvent("Emergency:Server:PutInCar", holding, VehToNet(veh), seat)
                exports["soe-civ"]:SetHoldingState(nil)
                ClearPedTasks(PlayerPedId())
            end
        end
    end
end)

-- CALLED FROM THE SERVER FROM "/rehab" TO SEND PLAYER TO PARSONS
RegisterNetEvent("Emergency:Client:RehabPlayer")
AddEventHandler("Emergency:Client:RehabPlayer", function(value, reason, heldBy)
    local ped = PlayerPedId()
    local parsons = vector3(-1550.44, 838.52, 182.71)
    if value then
        -- SEND THE PLAYER TO PARSONS
        DoScreenFadeOut(500)
        Wait(500)
        exports["soe-fidelis"]:AuthorizeTeleport()
        SetEntityCoords(ped, parsons)
        Wait(750)
        DoScreenFadeIn(500)
        inRehab = true
        TriggerEvent("Chat:Client:Message", "[Rehab]", "You're currently in a rehab hold here awaiting evaluation.", "standard")
        TriggerEvent("Chat:Client:Message", "[Rehab]", string.format("You were booked in by: %s", heldBy), "standard")
        TriggerEvent("Chat:Client:Message", "[Rehab]", string.format("Reason for Rehab: %s", reason), "standard")

        -- ADD A LOOP TO ENSURE THE PLAYER STAYS
        while inRehab do
            Wait(650)
            local pos = GetEntityCoords(ped)
            if (Vdist2(parsons, pos) > 22000.0) then
                DoScreenFadeOut(500)
                Wait(500)
                exports["soe-fidelis"]:AuthorizeTeleport()
                SetEntityCoords(ped, parsons)
                Wait(750)
                DoScreenFadeIn(500)
            end
        end
    else
        inRehab = false
    end
end)

-- CALLED FROM THE SERVER AFTER "/10-38" IS EXECUTED
RegisterNetEvent("Emergency:Client:10-38")
AddEventHandler("Emergency:Client:10-38", function(callSign)
    local veh = exports["soe-utils"]:GetVehInFrontOfPlayer(20.0)
    if veh ~= nil then
        -- POSITION DATA
        local pos = GetEntityCoords(PlayerPedId())
        local loc = exports["soe-utils"]:GetLocation(pos)

        -- VEHICLE DATA
        local primary = GetVehicleColours(veh)
        local plate = GetVehicleNumberPlateText(veh)

        -- TRIGGER CAD FOR 10-38
        TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = true, type = "10-38",
            loc = loc, model = GetEntityModel(veh), color = primary, plate = plate, callSign = callSign, coords = pos
        })
    else
        exports["soe-ui"]:SendAlert("error", "You must be looking at a vehicle.", 5000)
    end
end)

-- CALLED FROM THE SERVER AFTER "/10-78" IS EXECUTED
RegisterNetEvent("Emergency:Client:10-78")
AddEventHandler("Emergency:Client:10-78", function(callSign)
    -- POSITION DATA
    local pos = GetEntityCoords(PlayerPedId())
    local loc = exports["soe-utils"]:GetLocation(pos)

    -- TRIGGER CAD FOR 10-38
    TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = true, type = "10-78",
        loc = loc, callSign = callSign, coords = pos
    })
end)

-- CALLED FROM THE SERVER AFTER "/10-38" IS EXECUTED
RegisterNetEvent("Emergency:Client:Forensics")
AddEventHandler("Emergency:Client:Forensics", function(callSign)
    local pos = GetEntityCoords(PlayerPedId())
    local loc = exports["soe-utils"]:GetLocation(pos)
    
    TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = true, type = "10-75",
        loc = loc, callSign = callSign, coords = pos, crimelab = true
    })
end)

-- CALLED FROM THE SERVER AFTER "/respond" IS EXECUTED
RegisterNetEvent("Emergency:Client:RespondToCAD")
AddEventHandler("Emergency:Client:RespondToCAD", function(cadID)
    --[[print("-----")
    print("cadID", cadID)]]
    if CADAlerts[cadID] ~= nil then
        local x, y = nil, nil

        --[[print("xOffset", CADAlerts[cadID].data.offSet.xOffset)
        print("yOffset", CADAlerts[cadID].data.offSet.yOffset)
        print("coordsx", CADAlerts[cadID].data.coords.x)
        print("coordsy", CADAlerts[cadID].data.coords.y)]]

        if CADAlerts[cadID].data.offSet.xOffset ~= nil and CADAlerts[cadID].data.offSet.yOffset ~= nil then
            x = CADAlerts[cadID].data.offSet.xOffset
            y = CADAlerts[cadID].data.offSet.yOffset
        else
            x = CADAlerts[cadID].data.coords.x
            y = CADAlerts[cadID].data.coords.y
        end
        --print(x, y)

        -- ADD WAYPOINT TO CAD
        SetWaypointOff()
        SetNewWaypoint(x, y)
        exports["soe-ui"]:SendAlert("success", string.format("Waypoint set for CAD ID %s.", cadID), 5000)
    else
        exports["soe-ui"]:SendAlert("error", "Invalid CAD ID.", 5000)
    end
end)
