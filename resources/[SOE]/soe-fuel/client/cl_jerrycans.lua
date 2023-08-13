local isUsingJerryCan = false

-- KEY MAPPINGS
RegisterKeyMapping("+usejerrycan", "[Fuel] Use Jerry Can", "KEYBOARD", "E")

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, MAKE A BAR TO SHOW JERRY CAN FUEL PROGRESS (TO BE DONE IN NUI SOON)
local function FillingBar(fuel)
    local health = fuel
    if (health > 100) then
        health = 100
    end

    local width = (health * 0.0014)
    local offset = 0.0445 - ((0.059 - width) / 2)
    DrawRect(0.085, 0.950, 0.142, 0.015, 0, 0, 0, 150)
    DrawRect(0.085, 0.950, 0.137, 0.011, 255, 179, 0, 50)
    DrawRect(offset, 0.950, width, 0.011, 255, 179, 0, 150)
end

-- WHEN TRIGGERED, USE JERRY CAN AND MAKE IT FUEL THE NEAREST VEHICLE
local function UseJerryCan(filling)
    local ped = PlayerPedId()
    local myWeapon = GetSelectedPedWeapon(ped)
    if (myWeapon ~= GetHashKey("WEAPON_PETROLCAN")) then return end

    if filling then
        local veh = exports["soe-utils"]:GetVehInFrontOfPlayer(1.0)
        if (veh and GetAmmoInPedWeapon(ped, myWeapon) > 0) then
            exports["soe-utils"]:GetEntityControl(veh)

            -- IF THE FUEL TANK IS FULL
            if (GetVehicleFuelLevel(veh) > 99) then
                exports["soe-ui"]:SendAlert("error", "The fuel tank is already full", 5000)
                return
            end

            isUsingJerryCan = true
            exports["soe-utils"]:LoadAnimDict("weapon@w_sp_jerrycan", 15)
            TaskPlayAnim(ped, "weapon@w_sp_jerrycan", "fire", 2.0, 2.0, -1, 1, 0, 0, 0, 0)
            exports["soe-ui"]:SendAlert("warning", "You start filling the tank up with your jerry can", 5000)

            local loopIndex = 0
            while isUsingJerryCan do
                Wait(5)
                local currentFuel = GetVehicleFuelLevel(veh)
                FillingBar(currentFuel)

                loopIndex = loopIndex + 1
                if (loopIndex % 85 == 0) then
                    -- IF VEHICLE DISAPPEARED
                    if not DoesEntityExist(veh) then
                        isUsingJerryCan = false
                        break
                    end

                    -- CHECK IF THE VEHICLE IS THE VEHICLE WE ARE STILL FILLING
                    if (exports["soe-utils"]:GetVehInFrontOfPlayer(1.0) ~= veh) then
                        isUsingJerryCan = false
                        break
                    end

                    -- IF AMMO IN THE JERRY CAN IS OUT
                    if (GetAmmoInPedWeapon(ped, myWeapon) <= 0) then
                        isUsingJerryCan = false
                        break
                    end

                    -- MAKE SURE WE ARE PLAYING THE FUELING ANIMATION
                    if not IsEntityPlayingAnim(ped, "weapon@w_sp_jerrycan", "fire", 3) then
                        TaskPlayAnim(ped, "weapon@w_sp_jerrycan", "fire", 2.0, 2.0, -1, 1, 0, 0, 0, 0)
                    end

                    -- -- START FILLING TANK UP
                    local oldFuel = DecorGetFloat(veh, "fuelLevel")
                    local fuelToAdd = (math.random(10, 20) / 10.0)
                    currentFuel = (oldFuel + fuelToAdd)
                    if (currentFuel > 100.0) then
                        currentFuel = 100.0
                        isUsingJerryCan = false
                    end

                    SetFuel(veh, currentFuel)
                    SetPedAmmo(ped, myWeapon, GetAmmoInPedWeapon(ped, myWeapon) - 10)
                end
            end
            StopAnimTask(ped, "weapon@w_sp_jerrycan", "fire", -2.0)
        end
    else
        isUsingJerryCan = false
    end
end

-- **********************
--       Commands
-- **********************
-- ON KEYPRESS
RegisterCommand("+usejerrycan", function()
    UseJerryCan(true)
end)

-- ON KEY-RELEASE
RegisterCommand("-usejerrycan", function()
    UseJerryCan(false)
end)
