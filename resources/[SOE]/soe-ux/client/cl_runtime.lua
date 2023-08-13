local lastShot, loopIndex, cooldown = 0, 0, 0

-- CREATE MAP BLIPS
local function SetupBlips()
    for i = 1, #blips do
        local blip = AddBlipForCoord(blips[i].x, blips[i].y, 0)
        SetBlipAsShortRange(blip, true)
        SetBlipSprite(blip, (tonumber(blips[i].id) or 57))
        SetBlipColour(blip, (tonumber(blips[i].color) or 1))
        SetBlipScale(blip, (tonumber(blips[i].size) or 0.6))
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(tostring(blips[i].name))
        EndTextCommandSetBlipName(blip)
        Wait(10)
    end
end

CreateThread(function()
    Wait(3500)
    SetupBlips()

    -- KEEP WEAPON EVEN WHEN EMPTY
    SetWeaponsNoAutoswap(true)
    SetWeaponsNoAutoreload(true)

    -- LOAD WEAPON DRAWING ANIMATION DICTIONARIES
    exports["soe-utils"]:LoadAnimDict("rcmjosh4", 15)
    exports["soe-utils"]:LoadAnimDict("missminuteman_1ig_2", 15)
    exports["soe-utils"]:LoadAnimDict("reaction@intimidation@1h", 15)
    exports["soe-utils"]:LoadAnimDict("reaction@intimidation@cop@unarmed", 15)
    TriggerEvent("UX:Client:HolsterCooldown", 5000)

    while true do
        Wait(5)
        -- START RUNTIME FOR DRAWING WEAPONS
        DrawingWeaponRuntime()

        -- SLING WEAPONS
        local ped = PlayerPedId()
        loopIndex = loopIndex + 1
        if (loopIndex % 15 == 0) then
            loopIndex = 0
            SlingMyLongGuns(ped)
        end

        -- IF WEAPON SAFETY IS ON
        if weapons.safetyMode then
            DisablePlayerFiring(PlayerId(), true)

            if IsPlayerFreeAiming(PlayerId()) and IsDisabledControlJustPressed(0, 24) then
                PlaySoundFrontend(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", false)
                exports["soe-ui"]:SendUniqueAlert("gunSafetyMode", "warning", "Safety mode is engaged!", 300)
            end
        end

        -- APPLY GSR/DROP BULLET CASING AND RECOIL WHEN SHOOTING
        if IsPedShooting(ped) then
            -- DRIVE-BYS CAUSES ISSUES WITH RECOIL
            if not IsPedDoingDriveby(ped) then
                ShootingRecoil(ped)
            end

            -- UPDATE GUN AMMO OF CURRENT WEAPON
            local myWeapon = GetSelectedPedWeapon(ped)
            if (cooldown < GetGameTimer()) then -- COOLDOWN
                if (myWeapon ~= -1418622871) then -- IF THIS ISN'T A PEPPER SPRAY
                    -- PREVENT AIRCRAFT SHOOTING AFFECT THIS
                    if IsPedInAnyHeli(ped) or IsPedInAnyPlane(ped) and (GetPedInVehicleSeat(myVeh, -1) == ped) then
                        return
                    end

                    local currentAmmo = GetAmmoInPedWeapon(ped, myWeapon)
                    TriggerServerEvent("UX:Server:UpdateGunAmmo", exports["soe-inventory"]:GetMyCurrentWeapon(), currentAmmo)
                    cooldown = GetGameTimer() + 950
                --[[else
                    local nearbyPeds = {}
                    for localPed in exports["soe-utils"]:EnumeratePeds() do
                        if #(GetEntityCoords(ped) - GetEntityCoords(localPed)) <= 5.5 and IsPedHuman(localPed) and not IsEntityDead(localPed) and not (localPed == ped) and not IsPedAPlayer(localPed) then
                            nearbyPeds[#nearbyPeds + 1] = localPed
                        end
                    end

                    for _, nearbyPed in pairs(nearbyPeds) do
                        SetBlockingOfNonTemporaryEvents(nearbyPed, true)
                        ClearPedTasks(nearbyPed)

                        TaskPlayAnim(nearbyPed, "missminuteman_1ig_2", "tasered_1", 3.0, 3.0, 20000, 1, 0, 0, 0, 0)
                        SetTimeout(20000, function()
                            SetBlockingOfNonTemporaryEvents(nearbyPed, false)
                        end)
                    end
                    cooldown = GetGameTimer() + 3500]]
                end
            end

            -- IF GSR/CASING BLACKLIST CHECK IS PASSED
            if (gsrBlacklist[GetWeapontypeGroup(GetSelectedPedWeapon(ped))] == nil) then
                -- DROP CASING / INFLICT GUNSHOT RESIDUE
                exports["soe-csi"]:AddBulletCasing()
                exports["soe-csi"]:SetGSRInfliction()

                -- SET OFF CAD ALERT FOR SHOTS FIRED
                if not sentAlert then
                    SendShotsFiredAlert()
                end
            end
        end
    end
end)
