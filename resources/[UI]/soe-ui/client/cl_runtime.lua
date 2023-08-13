-- **********************
--         Loops
-- **********************
-- MAIN RESOURCE RUNTIME
CreateThread(function()
    Wait(3500)
    -- SET DEFAULT RANGE
    SetVoiceRangeState(2)

    -- SET PAUSE MENU NAME
    AddTextEntryByHash(GetHashKey("FE_THDR_GTAO"), "State of Emergency | https://evolpcgaming.com/")

    -- SET UP CIRCLE MINIMAP IF PLAYER ENABLED IT
    if (GetResourceKvpString("uidata.roundedMap") == "true") then
        SetupRoundMinimap()
    end

    if (GetResourceKvpString("uidata.showMapBorder") == "true") then
        showMapBorder = true
    end
    SetupLicensePreferences()

    local loopIndex = 0
    while true do
        Wait(3)
        HideHUDComponents()

        loopIndex = loopIndex + 1
        if (loopIndex % 15 == 0) then
            if NetworkIsPlayerTalking(PlayerId()) and not isTalking then
                isTalking = true
                SendNUIMessage({type = "Status.UpdateVoice", isTalking = true})
            elseif isTalking and not NetworkIsPlayerTalking(PlayerId()) then
                isTalking = false
                SendNUIMessage({type = "Status.UpdateVoice", isTalking = false})
            end
        end

        if (loopIndex % 43 == 0) then
            ControlMinimap()
        end

        if (loopIndex % 55 == 0) then
            UpdateCoreStatus()
        end

        if inVeh and myVeh then
            if (loopIndex % 20 == 0) then
                SendNUIMessage({type = "Vehicle.UpdateUI", show = (not hud or IsPauseMenuActive())})
                if (GetVehicleDoorLockStatus(myVeh) == 2) then
                    SendNUIMessage({type = "Vehicle.PopulateUI.Locks", locks = true})
                else
                    SendNUIMessage({type = "Vehicle.PopulateUI.Locks", locks = false})
                end

                local altitude = 0
                local speed = (GetEntitySpeed(myVeh) * 2.236936)
                if isAircraft or isBoat then
                    speed = (GetEntitySpeed(myVeh) * 1.94384)
                end

                if isAircraft then
                    altitude = math.floor(GetEntityCoords(myVeh).z * 3.28084)
                end
                SendNUIMessage({type = "Vehicle.PopulateUI.Speed", speed = speed, altitude = altitude})
            end

            if (loopIndex % 60 == 0) then
                local loc = exports["soe-utils"]:GetLocation(GetEntityCoords(myVeh))
                local direction = exports["soe-utils"]:GetDirection(GetEntityHeading(myVeh))
                SendNUIMessage({type = "Vehicle.PopulateUI.Fuel", fuel = exports["soe-fuel"]:GetFuel(myVeh)})
                SendNUIMessage({type = "Vehicle.PopulateUI.Street", streetOnTop = streetOnTop, direction = direction, location = loc})
            end

            if (loopIndex % 150 == 0) then
                if (GetVehicleEngineHealth(myVeh) < 400.0) then
                    SendNUIMessage({type = "Vehicle.PopulateUI.Engine", show = true})
                else
                    SendNUIMessage({type = "Vehicle.PopulateUI.Engine", show = false})
                end
            end
    
            if (loopIndex % 180 == 0) then
                SendNUIMessage({type = "Vehicle.PopulateUI.Time", time = GetCurrentGameTime()})
                loopIndex = 0
            end
        end
    end
end)
