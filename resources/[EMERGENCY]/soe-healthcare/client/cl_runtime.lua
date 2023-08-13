local lastHealth
local loopIndex = 0
local fireDamage, impactDamage, projectileDamage = false, false, false

-- RUNTIME LOOP RESPONSIBLE FOR PLAYER TRIAGE FUNCTIONALITY
CreateThread(function()
    Wait(3500)

    CreateZones()
    while true do
        Wait(5)
        local ped = PlayerPedId()
        -- DISABLE AUTO HEALING WHEN UNDER A CERTAIN HEALTH %
        SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)

        loopIndex = loopIndex + 1
        if (loopIndex % 30 == 0) then
            local health = GetEntityHealth(ped)
            if (health ~= lastHealth) then
                local damage = {}
                local causeBleed, causeLimp = false, false
                for _, v in pairs(weapons) do
                    local hash = weaponGroups[GetWeapontypeGroup(GetHashKey(v))]
                    if HasEntityBeenDamagedByWeapon(ped, GetHashKey(v), 0) then
                        if (v == "WEAPON_UNARMED") then
                            hash = "Melee"
                            if (math.random(1, 100) <= 25) then 
                                causeBleed = true
                            end
                        elseif (v == "WEAPON_HIT_BY_WATER_CANNON") then
                            hash = "Water Cannon"
                            if (math.random(1, 100) <= 55) then 
                                causeLimp = true
                            end
                        elseif (v == "WEAPON_SNOWBALL") then
                            hash = "Snowball"
                        elseif (v == "WEAPON_RUN_OVER_BY_CAR") then
                            hash = "Vehicle"
                            if (math.random(1, 100) <= 55) then 
                                causeBleed = true
                                causeLimp = true
                            end
                        elseif (v == "WEAPON_COUGAR") then
                            hash = "Mountain Lion"
                        elseif (v == "WEAPON_STUNGUN") then
                            hash = "Taser Prong"
                        elseif (v == "WEAPON_SMOKEGRENADE") then
                            causeBleed = false
                            DoTearGasConsequences()
                        else
                            if (hash ~= nil and hash ~= "Blunt") then
                                causeBleed = true
                            end
                        end

                        if (knives[v] ~= nil) then
                            hash = "Stab"
                            causeBleed = true
                        end

                        if (hash == "Projectile") then
                            if projectileDamage then
                                break
                            else
                                projectileDamage = true
                                SetTimeout(15000, function()
                                    projectileDamage = false
                                end)
                            end
                        end

                        local _, bone = GetPedLastDamageBone(ped)
                        if (hash == nil) then hash = "Unknown" end
                        damage[#damage + 1] = {type = hash, bone = bone}
                        break
                    end
                end

                if IsEntityOnFire(ped) then
                    if not fireDamage then
                        local _, bone = GetPedLastDamageBone(ped)
                        fireDamage = true
                        damage[#damage + 1] = {type = "Burn", bone = bone}
                        SetTimeout(15000, function()
                            fireDamage = false
                        end)
                    end
                end

                if HasEntityCollidedWithAnything(ped) then
                    if not impactDamage then
                        local _, bone = GetPedLastDamageBone(ped)
                        impactDamage = true
                        damage[#damage + 1] = {type = "Bruised", bone = bone}
                        SetTimeout(2000, function()
                            impactDamage = false
                        end)
                    end
                end

                if #damage > 0 then
                    TriggerServerEvent("Healthcare:Server:UpdatePedDamage", damage)
                    if causeBleed then
                        StartBleeding(1)
                    end

                    if causeLimp then
                        ModifyMyMovement(true)
                    end

                    ClearPedLastDamageBone(ped)
                    ClearEntityLastDamageEntity(ped)
                    ClearEntityLastWeaponDamage(ped)
                end
            end
            loopIndex = 0
            lastHealth = GetEntityHealth(ped)
        end
    end
end)
