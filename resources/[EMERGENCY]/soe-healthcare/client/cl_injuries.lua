-- BLEEDING VARIABLES
local currentlyBleeding = false
local bloodLossRate, myBleedingBone = 1, "mid-section"

-- DRUG VARIABLES
local painkillerLevel = 1
local hasOverdosed = false
local isOnPainkillers, isDruggedByTearGas = false, false

-- DEFINE OUR BLEEDING LEVELS
local bleedingLevels = {"minor", "moderate", "significant", "extreme"}

-- ***********************
--     Global Functions
-- ***********************
-- RETURNS IF PLAYER IS BLEEDING OR NOT
function IsBleeding()
    return currentlyBleeding
end

-- PUTS A STOP TO INJURIES/BLEEDING
function HealInjuriesAndBleeding()
    HealInjuries()
    StopBleeding()
end

-- PUTS A STOP IN INJURIES/INJURED WALK
function HealInjuries()
    ModifyMyMovement(false)
    --TriggerServerEvent("Healthcare:Server:ResetPedDamage")
end

-- PUTS A STOP IN BLEEDING
function StopBleeding()
    if currentlyBleeding then
        exports["soe-ui"]:SendAlert("medical", "You notice that your bloodloss has stopped", 10000)
    end
    bloodLossRate = 1
    currentlyBleeding = false
end

-- MODIFIES PLAYER MOVEMENT
function ModifyMyMovement(shouldLimp)
    local ped = PlayerPedId()
    if shouldLimp and not isOnPainkillers then
        SetPedConfigFlag(ped, 166, true)
        --SetPlayerSprint(PlayerId(), false)
        exports["soe-ui"]:SendAlert("medical", "You start feeling like your legs are sore...", 5000)
    else
        if GetPedConfigFlag(ped, 166, 1) then
            exports["soe-ui"]:SendAlert("medical", "You notice that your legs seem to be improving...", 5000)
        end
        SetPedConfigFlag(ped, 166, false)
        --SetPlayerSprint(PlayerId(), true)
    end
end

-- WHEN TRIGGERED, DO TEAR GAS CONSEQUENCE EFFECTS
function DoTearGasConsequences()
    if isDruggedByTearGas then return end

    isDruggedByTearGas = true
    AnimpostfxPlay("Damage", 60000, true)
    AnimpostfxPlay("RaceTurbo", 60000, true)
    exports["soe-ui"]:SendAlert("medical", "You start feeling the effects of tear gas", 12000)

    if not exports["soe-emergency"]:IsDead() then
        exports["soe-utils"]:LoadAnimDict("missminuteman_1ig_2", 15)
        TaskPlayAnim(PlayerPedId(), "missminuteman_1ig_2", "tasered_1", 3.0, 3.0, 20000, 49, 0, 0, 0, 0)
    end

    SetTimeout(60000, function()
        isDruggedByTearGas = false
        AnimpostfxStop("Damage")
        AnimpostfxStop("RaceTurbo")
        exports["soe-ui"]:SendAlert("medical", "You feel the effects of tear gas subside", 5000)
    end)
end

-- INVENTORY ITEM USAGE OF A FIRST AID KIT
function UsePainKillers()
    exports["soe-utils"]:Progress(
        {
            name = "takingPainkillers",
            duration = 2800,
            label = "Taking Painkillers",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = false,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
            },
            animation = {
                animDict = "mp_suicide",
                anim = "pill",
                flags = 49
            }
        },
        function(cancelled)
            if not cancelled then
                if not isOnPainkillers then
                    isOnPainkillers = true
                end

                painkillerLevel = painkillerLevel + 1
                if painkillerLevel >= 5 then
                    painkillerLevel = 5
                    if not hasOverdosed then
                        hasOverdosed = true
                        AnimpostfxPlay("FocusIn", 0, false)
                        SetPedToRagdoll(PlayerPedId(), 5000, 1, 2)
                        ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 0.08)

                        exports["soe-ui"]:SendAlert("medical", "You realize you took way too many painkillers...", 10000)
                        ApplyDamageToPed(PlayerPedId(), 20, 0)

                        -- OVERDOSE EFFECTS WEAR OFF AFTER 2 MINUTES
                        SetTimeout(120000, function()
                            hasOverdosed = false
                            AnimpostfxStop("FocusIn")
                            AnimpostfxPlay("FocusOut", 0, false)
                            exports["soe-ui"]:SendAlert("medical", "You feel the overdose subside a bit...", 10000)
                        end)
                    end
                else
                    if currentlyBleeding then
                        exports["soe-ui"]:SendAlert("medical", "You noticed your bleeding has slowed down a bit", 5000)
                    end
                    exports["soe-ui"]:SendAlert("medical", "You feel the pain subside temporarily", 5000)
                end

                -- PAINKILLERS WEAR OFF AFTER 3 MINUTES
                SetTimeout(180000, function()
                    if (painkillerLevel ~= 1) then
                        painkillerLevel = painkillerLevel - 1
                        exports["soe-ui"]:SendAlert("medical", "You feel like the painkillers aren't doing much anymore", 7500)
                        if (painkillerLevel <= 1) then
                            painkillerLevel = 1
                            isOnPainkillers = false
                        end
                    end
                end)
            end
        end
    )
end

-- STARTS BLEEDING LOOP AND EVENTS
function StartBleeding(rate)
    local ped = PlayerPedId()
    -- DETERMINE CHANCE OF BLEEDING WHILE HAVING ARMOR
    if (GetPedArmour(ped) ~= 0) then
        local myLuck = GetRandomIntInRange(1, 100)
        if (myLuck <= 85) then
            return
        end
    end

    if not currentlyBleeding then
        local _, bone = GetPedLastDamageBone(ped)
        myBleedingBone = bones[bone]
        TriggerServerEvent("Healthcare:Server:MarkBoneAsBleeding", bones[bone])

        -- SET BLOODLOSS RATE
        bloodLossRate = rate
        exports["soe-ui"]:SendAlert("medical", ("You notice that you started having %s bleeding coming from the %s."):format(bleedingLevels[bloodLossRate], myBleedingBone), 15000)

        -- SET BLEEDING STATE AND CREATE LOOP
        currentlyBleeding = true
        CreateThread(function()
            local sleep, damage = 30000, 3
            while currentlyBleeding do
                Wait(sleep * painkillerLevel)
                if not currentlyBleeding then return end
                -- CHANGE WAIT TIME/DAMAGE BASED OFF SEVERITY
                if (bloodLossRate == 1) then
                    sleep, damage = 30000, 3
                elseif (bloodLossRate == 2) then
                    sleep, damage = 25000, 5
                elseif (bloodLossRate == 3) then
                    sleep, damage = 15000, 7
                elseif (bloodLossRate == 4) then
                    sleep, damage = 12000, 10
                end

                -- DAMAGE PLAYER
                ApplyDamageToPed(ped, damage, 0)
                exports["soe-csi"]:AddBloodDrop()

                -- PERFORM A TEMPORARY SCREEN EFFECT WHEN VERY INJURED
                if (GetEntityHealth(ped) <= 145) then
                    AnimpostfxPlay("MinigameEndTrevor", 0, false)
                    exports["soe-ui"]:SendAlert("medical", "You start feeling a headache...", 5000)
                end
                exports["soe-ui"]:SendAlert("medical", ("You notice %s bloodloss is continuing from the %s."):format(bleedingLevels[bloodLossRate], myBleedingBone), 15000)
            end
        end)
    else
        -- 45% CHANCE OF BLEEDING BEING WORSENED
        math.randomseed(GetGameTimer())
        if (math.random(1, 100) <= 45) then 
            -- MAKE BLEEDING WORSE IF ALREADY ACTIVE AND MAKE SURE NOT TO GO OVER
            exports["soe-ui"]:SendAlert("medical", "You notice that your bloodloss is worsening", 15000)
            bloodLossRate = bloodLossRate + 1
            if (bloodLossRate > 4) then
                bloodLossRate = 4
            end
        end
    end
end

-- ***********************
--         Events
-- ***********************
-- WHEN TRIGGERED, RESET TEAR GAS EFFECTS
AddEventHandler("onResourceStop", function(resource)
    if (GetCurrentResourceName() ~= resource) then return end

    AnimpostfxStop("Damage")
    AnimpostfxStop("RaceTurbo")
end)
