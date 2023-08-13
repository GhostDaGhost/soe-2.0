weapons = {}

local timer, slungWeapon = 0, 0
local unarmed = GetHashKey("WEAPON_UNARMED")
local currentWeapon = GetSelectedPedWeapon(ped)
local typePistol, typeThrown = 416676503, 1548507267
local inVeh, canFire, holdingWeapon = false, true, false

-- KEY MAPPINGS
RegisterKeyMapping("weapons_safety", "[Weapons] Gun Safety Mode", "KEYBOARD", "")

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, TOGGLE WEAPON SAFETY MODE
local function ToggleSafetyMode()
    if not IsPedArmed(PlayerPedId(), 4) then return end

    PlaySoundFrontend(-1, "Place_Prop_Success", "DLC_Dmod_Prop_Editor_Sounds", false)
    if not weapons.safetyMode then
        weapons.safetyMode = true
        exports["soe-ui"]:SendAlert("debug", "Safety Mode: On", 500)
    else
        weapons.safetyMode = false
        exports["soe-ui"]:SendAlert("debug", "Safety Mode: Off", 500)
    end
end

-- WHEN TRIGGERED, DO DIFFERENT HOLSTER ANIMATIONS FOR LARGE WEAPONS
local function HolsterDrawLarge(ped)
    canFire = false
    CreateThread(function()
        while not canFire do
            Wait(1)
            DisablePlayerFiring(PlayerId(), true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
        end
    end)

    SetPedCurrentWeaponVisible(ped, false, false, false, false)
    local myJob = exports["soe-jobs"]:GetMyJob()
    if not (myJob == "POLICE" or myJob == "EMS") then
        TaskPlayAnim(ped, "reaction@intimidation@1h", "intro", 8.0, 3.0, 2500, 50, 0, 0, 0, 0)
        Wait(1000)
        SetPedCurrentWeaponVisible(ped, true, false, false, false)
        Wait(1500)
    else
        TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "intro", 8.0, 3.0, 600, 50, 0, 0, 0, 0)
        Wait(600)
        SetPedCurrentWeaponVisible(ped, true, false, false, false)
    end
    holdingWeapon = true
    canFire = true
end

-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, SLING LONG GUNS ON PLAYER'S BACK
function SlingMyLongGuns(ped)
    for k, v in pairs(slungWeaponList) do
        if HasPedGotWeapon(ped, v.Hash, false) then
            if (slungWeapon == v.Hash) then
                if v.obj then
                    DeleteObject(v.obj)
                    slungWeaponList[k].obj = nil
                end
            else
                if not v.obj then
                    slungWeaponList[k].obj = exports["soe-utils"]:SpawnObject(v.model)
                    AttachEntityToEntity(slungWeaponList[k].obj, ped, GetPedBoneIndex(ped, 24818), v.pos, v.rot, 0, 0, 0, 0, 0, 1)
                end
            end
        else
            if v.obj then
                DeleteObject(v.obj)
                slungWeaponList[k].obj = nil
            end
        end
    end
end

-- WHEN TRIGGERED, MIMICK RECOIL WHEN SHOOTING A GUN
function ShootingRecoil(ped)
    local weaponName = exports["soe-utils"]:GetWeaponNameFromHashKey(GetSelectedPedWeapon(ped))
    if recoils[weaponName] and (recoils[weaponName] ~= 0) then
        local tv = 0
        if (GetFollowPedCamViewMode() ~= 4) then
            repeat
                Wait(0)
                p = GetGameplayCamRelativePitch()
                SetGameplayCamRelativePitch(p + 0.1, 0.2)
                tv = (tv + 0.1)
            until tv >= recoils[weaponName]
        else
            repeat
                Wait(0)
                p = GetGameplayCamRelativePitch()
                if (recoils[weaponName] > 0.1) then
                    SetGameplayCamRelativePitch(p + 0.6, 1.2)
                    tv = (tv + 0.6)
                else
                    SetGameplayCamRelativePitch(p + 0.016, 0.333)
                    tv = (tv + 0.1)
                end
            until tv >= recoils[weaponName]
        end
    end
end

-- WHEN TRIGGERED, DO HOLSTER ANIMATIONS
function DrawingWeaponRuntime()
    local ped = PlayerPedId()
    local heldWeapon = GetSelectedPedWeapon(ped)
    if (heldWeapon ~= currentWeapon) then
        slungWeapon = heldWeapon
        if (heldWeapon ~= GetHashKey("WEAPON_UNARMED")) then
            TriggerEvent("Inventory:Client:ValidateWeapon", heldWeapon)
        end

        if not IsPedActiveInScenario(ped) and not IsPedUsingAnyScenario(ped) and GetGameTimer() > timer then
            if IsPedSittingInAnyVehicle(ped) or IsPedGettingIntoAVehicle(ped) then
                -- Handles weapon being changed while in the vehicle So the anim doesn't play on exit
                inVeh = true
                if heldWeapon ~= unarmed then
                    holdingWeapon = true
                else
                    holdingWeapon = false
                end
            else
                if GetPedParachuteState(ped) ~= 2 and not inVeh then
                    -- Stops from plummeting to doom when changing weapons with a parachute
                    local pos = GetEntityCoords(ped)
                    local rot = GetEntityHeading(ped)
                    if heldWeapon ~= unarmed and holdingWeapon == false then
                        -- Pulling Out Weapon.
                        if GetWeapontypeGroup(heldWeapon) == typePistol or GetWeapontypeGroup(heldWeapon) == typeThrown or heldWeapon == GetHashKey('WEAPON_STUNGUN') then
                            -- Small Weapons
                            canFire = false
                            CreateThread(function()
                                while not canFire do
                                    Wait(1)
                                    DisablePlayerFiring(PlayerId(), true)
                                    DisableControlAction(0, 24, true)
                                    DisableControlAction(0, 25, true)
                                end
                            end)

                            local myJob = exports["soe-jobs"]:GetMyJob()
                            if not (myJob == "POLICE" or myJob == "EMS") then
                                SetPedCurrentWeaponVisible(ped, false, false, false, false)
                                TaskPlayAnimAdvanced( ped, "reaction@intimidation@1h", "intro", pos, 0, 0, rot, 8.0, 3.0, 1100, 50, 0.325, 0, 0)
                                Wait(400)
                                SetPedCurrentWeaponVisible(ped, true, false, false, false)
                                Wait(700)
                            else
                                TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 20.0, 3.0, 600, 48, 10, 0, 0, 0)
                            end
                            holdingWeapon = true
                            canFire = true
                        else
                            -- Large Weapons (SMGs, ARs, etc.)
                            HolsterDrawLarge(ped)
                        end
                    elseif heldWeapon == unarmed and holdingWeapon == true then
                        -- Putting Away Weapon.
                        canFire = false
                        CreateThread(function()
                            while not canFire do
                                Wait(1)
                                DisablePlayerFiring(PlayerId(), true)
                                DisableControlAction(0, 24, true)
                                DisableControlAction(0, 25, true)
                            end
                        end)

                        local num = 1400
                        if GetHashKey(currentWeapon) ~= 951415626 then
                            local myJob = exports["soe-jobs"]:GetMyJob()
                            if (myJob == "POLICE" or myJob == "EMS") then
                                TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "intro", 8.0, 3.0, 600, 50, 0, 0, 0, 0)
                                num = 600
                            else
                                TaskPlayAnimAdvanced( ped, "reaction@intimidation@1h", "outro", pos, 0, 0, rot, 8.0, 3.0, num, 50, 0.125, 0, 0)
                            end
                        end
                        Wait(num)
                        holdingWeapon = false
                        canFire = true
                    elseif holdingWeapon == true then
                        -- Holding a weapon and switching weapons.
                        HolsterDrawLarge(ped)
                    end
                end
                inVeh = false
            end
        end
        currentWeapon = heldWeapon
    end
end

-- **********************
--       Commands
-- **********************
-- WHEN TRIGGERED, TOGGLE WEAPON SAFETY MODE
RegisterCommand("weapons_safety", ToggleSafetyMode)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, SET COOLDOWN FOR HOLSTER ANIMATION
AddEventHandler("UX:Client:HolsterCooldown", function(timeout)
    timer = GetGameTimer() + timeout
end)

-- WHEN TRIGGERED, DELETE SLUNG LONG GUNS
AddEventHandler("onResourceStop", function(resource)
    if (GetCurrentResourceName() ~= resource) then return end

    for slungIndex, slungData in pairs(slungWeaponList) do
        if slungData.obj then
            DeleteEntity(slungData.obj)
            slungWeaponList[slungIndex].obj = nil
        end
    end
end)

-- WHEN TRIGGERED, RELOAD PLAYER'S WEAPON
RegisterNetEvent("UX:Client:ReloadMyGun")
AddEventHandler("UX:Client:ReloadMyGun", function(ammoToAdd, clearing)
    local ped = PlayerPedId()
    local myGun = GetSelectedPedWeapon(ped)

    if not clearing then
        local current = GetAmmoInPedWeapon(ped, myGun)
        SetPedAmmo(ped, myGun, current + ammoToAdd)
    else
        SetPedAmmo(ped, myGun, 0)
    end
    TaskReloadWeapon(ped, true)
end)
