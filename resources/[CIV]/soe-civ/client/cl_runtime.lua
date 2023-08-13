local loopIndex = 0

-- SETS RANDOM STEERING WHILE INTOXICATED
local function HandleDrunkDriving(veh, steer)
    CreateThread(function()
        local n = 0
        while (n < 15) do
            Wait(5)
            n = n + 1
            SetVehicleSteerBias(veh, steer)
        end
    end)
end

-- ALCOHOL EFFECTS/CONSEQUENCES RUNTIME
CreateThread(function()
    Wait(3500)

    exports["soe-utils"]:LoadAnimDict("mp_player_int_upperwank", 15)
    while true do
        Wait(2000)
        if (alcoholLevel > 0) then
            local ped = PlayerPedId()

            -- MESS WITH THE VEHICLE'S STEERING WHEEL WHILE INTOXICATED
            math.randomseed(GetGameTimer())
            if (alcoholLevel > 20) and (math.random(1, 100) <= alcoholLevel) then
                if IsPedInAnyVehicle(ped, false) then
                    local veh = GetVehiclePedIsIn(ped, false)
                    if (GetPedInVehicleSeat(veh, -1) == ped) then
                        local steer = 1.0
                        if (math.random(1, 2) == 2) then
                            steer = -1.0
                        end

                        if (GetEntitySpeed(veh) > 1) then
                            HandleDrunkDriving(veh, steer)
                        end
                    end
                end
            end

            -- DECREASE "BAC" OVER TIME AND MAINTAIN WALKSTYLES/SCREEN EFFECTS
            math.randomseed(GetGameTimer())
            if (math.random(1, 20) <= 1) then
                alcoholLevel = alcoholLevel - 1
                SetGameplayCamShakeAmplitude(alcoholLevel / 10)
                if alcoholLevel >= 60 then
                    print("VERY DRUNK")
                    SetPedMovementClipset(ped, "move_m@drunk@verydrunk", 0.0)
                elseif alcoholLevel > 20 then
                    print("MODERATELY DRUNK")
                    SetPedMovementClipset(ped, "move_m@drunk@moderatedrunk", 0.0)
                elseif alcoholLevel < 10 and alcoholLevel ~= 0 then
                    print("STOP EFFECT")
                    StopScreenEffect("MenuMGSelectionTint")
                elseif alcoholLevel == 0 then
                    StopGameplayCamShaking(true)
                    ResetPedMovementClipset(ped)
                    ResetPedStrafeClipset(ped)
                    StopScreenEffect("MenuMGSelectionTint")
                else
                    print("SLIGHTLY DRUNK")
                    SetPedMovementClipset(ped, "move_m@drunk@slightlydrunk", 0.0)
                    SetPedStrafeClipset(ped, "move_strafe@first_person@drunk")
                end
            end

            -- UPDATE THIS CLIENT'S BAC LEVEL
            TriggerServerEvent("Civ:Server:UpdateBAC", alcoholLevel)
        else
            Wait(7500)
        end
    end
end)

-- MENU LOOPS
CreateThread(function()
    Wait(3500)
    while true do
        Wait(5)
        -- CIV RUNTIME
        if (loopIndex % 200 == 0) then
            -- MENU CHECK
            if isCraftMenuOpen then
                -- DO DISTANCE CHECK ONLY IS MENU IS OPEN
                local playerCoords = GetEntityCoords(PlayerPedId())
                local distance = #(playerCoords - craftPos)
                if distance > craftMenuRadius then
                    SOEMenu:CloseAll()
                end
            end
        end
    end
end)
