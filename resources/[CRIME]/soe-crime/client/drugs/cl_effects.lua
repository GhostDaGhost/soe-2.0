local currentDrug

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, DO DRUG EFFECTS BASED OFF DRUG
local function DoDrugEffects(type, name, doAnimation)
    if not type then return end
    local ped = PlayerPedId()

    -- MARIJUANA
    if (type == "Weed") then
        currentDrug = "Marijuana"

        local duration = 120000
        local msg = "You smoke a joint"
        if name:match("SOTW") then
            duration = 300000
            msg = "You smoke a SOTW Joint"
        elseif name:match("Best Buds Edibles") then
            duration = 60000
            msg = "You feel a bit high"
        elseif name:match("Best Buds") then
            duration = 300000
            msg = "You smoke a Best Buds Joint"
        end

        if doAnimation ~= false then
            exports["soe-emotes"]:StartEmote("smokejoint")
        end

        exports["soe-ui"]:SendAlert("warning", msg, 5000)
        Wait(850)

        AnimpostfxPlay("FocusIn", 0, true)
        SetGameplayCamShakeAmplitude(0.05)
        SetTimeout(duration, function()
            AnimpostfxStop("FocusIn")
            StopGameplayCamShaking(true)
        end)
    -- MAGIC MUSHROOMS
    elseif (type == "Shrooms") then
        local duration = 85000
        currentDrug = "Magic Mushrooms"

        exports["soe-utils"]:LoadAnimDict("mp_player_inteat@burger", 15)
        TaskPlayAnim(ped, "mp_player_inteat@burger", "mp_player_int_eat_burger_fp", 2.0, 2.0, 1750, 49, 0, 0, 0, 0)
        exports["soe-ui"]:SendAlert("warning", "You consume some magic mushrooms", 5000)

        Wait(3500)
        AnimpostfxPlay("PeyoteIn", 700, false)
        Wait(5000)
        AnimpostfxStop("PeyoteIn")
        AnimpostfxPlay("Damage", duration, false)
        AnimpostfxPlay("RaceTurbo", duration, false)

        SetTimeout(duration, function()
            SetCamEffect(0)
            AnimpostfxStopAll()
        end)
    -- METHAMPHETAMINE
    elseif (type == "Meth") then
        local duration = 180000
        currentDrug = "Methamphetamine"
        exports["soe-emotes"]:StartEmote("smokejoint")
        exports["soe-ui"]:SendAlert("warning", "You smoke some meth", 5000)
        Wait(3500)

        SetPedMotionBlur(ped, true)
        exports["soe-utils"]:LoadAnimSet("move_m@drunk@slightlydrunk", 15)
        SetPedMovementClipset(ped, "move_m@drunk@slightlydrunk", true)

        SetTimecycleModifier("spectator5")
        AnimpostfxPlay("SuccessMichael", 10000001, true)
        ShakeGameplayCam("DRUNK_SHAKE", 1.5)

        SetTimeout(duration, function()
            AnimpostfxStopAll()
            SetTimecycleModifierStrength(0.0)
            ShakeGameplayCam("DRUNK_SHAKE", 0.0)

            SetPedMotionBlur(ped, false)
            exports["soe-emotes"]:RestoreSavedWalkstyle()
        end)
    end
end

-- **********************
--    Global Functions
-- **********************
-- COCAINE
function SmokeCocaine()
    exports["soe-emotes"]:StartEmote("smokejoint")
    exports["soe-ui"]:SendAlert("inform", "You use some cocaine", 5000)

    Wait(3500)
    local timer = 0
    local ped = PlayerPedId()
    while (timer < 60) do
        Wait(5000)
        SetPedMotionBlur(ped, true)
        ResetPlayerStamina(PlayerId())
        SetTimecycleModifier("spectator5")
        SetRunSprintMultiplierForPlayer(ped, 1.2)
        timer = timer + 2
    end

    SetPedMotionBlur(ped, false)
    SetTimecycleModifier("default")
    SetRunSprintMultiplierForPlayer(ped, 1.0)
end

-- MORPHINE
function InjectMorphine()
    local player = exports["soe-utils"]:GetClosestPlayer(3)
    if (player ~= nil) then
        exports["soe-utils"]:Progress(
            {
                name = "injectMorphine",
                duration = 3000,
                label = "Injecting Morphine",
                useWhileDead = true,
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
                    TriggerEvent("Chat:Client:SendMessage", "me", "You administer the appropriate dose of morphine.")
                    TriggerServerEvent("Crime:Server:InjectMorphine", GetPlayerServerId(player))
                end
            end
        )
    else
        exports["soe-ui"]:SendAlert("error", "Nobody close enough", 5000)
    end
end

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, DO DRUG EFFECTS BASED OFF DRUG
AddEventHandler("Crime:Client:DoDrugEffects", DoDrugEffects)

-- WHEN TRIGGERED, GIVE MORPHINE DRUG EFFECTS
RegisterNetEvent("Crime:Client:MorphineEffects")
AddEventHandler("Crime:Client:MorphineEffects", function()
    local morphineTimer = 0
    local ped = PlayerPedId()
    local isOnMorphine = false
    SetCamEffect(2)
    Wait(100)

    SetPedMoveRateOverride(PlayerId(), 10.0)
    SetSwimMultiplierForPlayer(PlayerId(), 1.06)
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.03)

    exports["soe-utils"]:LoadAnimSet("move_m@buzzed", 15)
    SetPedMovementClipset(ped, "move_m@buzzed", 1.0)
    if not isOnMorphine then
        isOnMorphine = true
        exports["soe-ui"]:SendAlert("inform", "You feel some morphine effects", 5000)

        while (morphineTimer < 150) do
            morphineTimer = morphineTimer + 1
            local health = GetEntityHealth(ped)
            SetEntityHealth(ped, health + 1)
            Wait(1000)
        end

        if isOnMorphine then
            isOnMorphine = false
            exports["soe-ui"]:SendAlert("inform", "Your morphine effects have run out", 5000)

            SetCamEffect(0)
            morphineTimer = 0
            SetPedMoveRateOverride(PlayerId(), 10.0)
            SetSwimMultiplierForPlayer(PlayerId(), 1.0)
            SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)

            ResetPedStrafeClipset(ped)
            ResetPedMovementClipset(ped)
            ResetPedWeaponMovementClipset(ped)
        end
    end
end)
