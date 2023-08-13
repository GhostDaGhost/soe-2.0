CreateThread(function()
    while true do
        Wait(100)
        if isOnCall and not hasAnswered then
            if ringLoops > 4 and theirNumberOnCall ~= "911" and theirNumberOnCall ~= "311" then
                exports["soe-utils"]:PlaySound("phone-no-answer.ogg", phoneVolume, false)
                Wait(5000)
                ringLoops = 0
                Wait(200)
                EndPhoneCall(false)
            else
                playingRing = true
                ringLoops = ringLoops + 1

                Wait(6000)
                playingRing = false
            end
        end

        if ringLoops ~= 0 and (hasAnswered or not isOnCall) then
            ringLoops = 0
        end
    end
end)

-- RUNTIME TO CHECK FOR KEYPRESS AND DISABLE CONTROLS IF IN PHONE UI
CreateThread(function()
    local sleep = 5
    while true do
        Wait(sleep)
        sleep = 5
        -- CHECK IF PRIMARY PHONE EXISTS
        if (primaryPhoneUID ~= nil) then
            if isPhoneOpen then
                local ped = PlayerPedId()
                local veh = GetVehiclePedIsIn(ped, false)
                if (veh == 0 or GetVehicleClass(veh) == 8 or GetVehicleClass(veh) == 13) then
                    -- Player is not in vehicle
                    if not exports["soe-emergency"]:IsDead() then
                        if isOnCall then
                            if not IsEntityPlayingAnim(ped, "cellphone@", "cellphone_call_listen_base", 3) then
                                exports["soe-emotes"]:StartEmote("phone")
                            end
                        else
                            if not IsEntityPlayingAnim(ped, "cellphone@", "cellphone_text_in", 3) then
                                exports["soe-emotes"]:EliminateAllProps()
                                exports["soe-emotes"]:StartEmote("phone2")
                            end
                        end
                    end
                else
                    -- Player is in a vehicle
                    if isOnCall then
                        if not IsEntityPlayingAnim(ped, "cellphone@in_car@ds", "cellphone_call_listen_base", 3) then
                            exports["soe-emotes"]:EliminateAllProps()
                            exports["soe-emotes"]:StartEmote("phone3")
                        end
                    else
                        if not IsEntityPlayingAnim(ped, "cellphone@in_car@ds", "cellphone_text_read_base", 3) then
                            exports["soe-emotes"]:EliminateAllProps()
                            exports["soe-emotes"]:StartEmote("phone5")
                        end
                    end
                end
            end

            if isPhoneFake then
                exports["soe-emotes"]:EliminateAllProps()
            end

            if isPhoneOpen then
                sleep = 0
                if disableCamera then
                    DisableControlAction(1, 1, true) -- CAMERA CONTROL
                    DisableControlAction(1, 2, true) -- CAMERA CONTROL
                    DisableControlAction(1, 3, true) -- CAMERA CONTROL
                    DisableControlAction(1, 4, true) -- CAMERA CONTROL
                    DisableControlAction(1, 5, true) -- CAMERA CONTROL
                    DisableControlAction(1, 6, true) -- CAMERA CONTROL
                end

                DisableControlAction(0, 24, true) -- ATTACK (L-CLICK)
                DisableControlAction(0, 25, true) -- AIM (R-CLICK)
                DisableControlAction(0, 68, true) -- ATTACK (L-CLICK)
                DisableControlAction(0, 69, true) -- AIM (R-CLICK)
                DisableControlAction(0, 70, true) -- AIM (R-CLICK)
                DisableControlAction(0, 91, true) -- AIM (R-CLICK)
                DisableControlAction(0, 92, true) -- AIM (R-CLICK)
                DisableControlAction(0, 114, true) -- AIM (R-CLICK)
                DisableControlAction(0, 330, true) -- AIM (R-CLICK)
                DisableControlAction(0, 331, true) -- AIM (R-CLICK)
                DisableControlAction(0, 347, true) -- AIM (R-CLICK)
                DisableControlAction(0, 245, true) -- OPEN CHAT (T)
                DisableControlAction(0, 168, true) -- OPEN INVENTORY (F7)
                DisableControlAction(0, 199, true) -- PAUSE (P)
                DisableControlAction(0, 200, true) -- PAUSE(ESC)
                DisableControlAction(0, 12, true) -- PAUSE(ESC)
                DisableControlAction(0, 13, true) -- PAUSE(ESC)
                DisableControlAction(0, 14, true) -- PAUSE(ESC)
                DisableControlAction(0, 15, true) -- PAUSE(ESC)
                DisableControlAction(0, 16, true) -- PAUSE(ESC)
                DisableControlAction(0, 17, true) -- PAUSE(ESC)
                DisableControlAction(0, 210, true) -- L CTRL
            end
        end

        if (GetGameTimer() - lastClimateCheck > 5000) then
            lastClimateCheck = GetGameTimer()
            RecordTimeWeather()
        end
    end
end)
