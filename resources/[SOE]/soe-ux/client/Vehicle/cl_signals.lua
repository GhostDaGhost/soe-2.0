local neutral, heading, indicatorTime, indicator = false, 0.0, 0, "Off"

-- KEY MAPPINGS
RegisterKeyMapping("hazards", "[Veh] Hazard Lights", "KEYBOARD", "OEM_5")
RegisterKeyMapping("leftblinker", "[Veh] Left Turn Signal", "KEYBOARD", "OEM_4")
RegisterKeyMapping("rightblinker", "[Veh] Right Turn Signal", "KEYBOARD", "RBRACKET")

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, SYNC TURN SIGNALS WITH THE REST OF THE SERVER
local function SyncTurnSignals(veh, status)
    veh = NetToVeh(veh)
    local hasTrailer, vehTrailer = GetVehicleTrailerVehicle(veh, vehTrailer)

    if (status == "Off") then
        SetVehicleIndicatorLights(veh, 0, false)
        SetVehicleIndicatorLights(veh, 1, false)

        if hasTrailer then
            SetVehicleIndicatorLights(vehTrailer, 0, false)
            SetVehicleIndicatorLights(vehTrailer, 1, false)
        end
    elseif (status == "Left") then
        SetVehicleIndicatorLights(veh, 0, false)
        SetVehicleIndicatorLights(veh, 1, true)

        if hasTrailer then
            SetVehicleIndicatorLights(vehTrailer, 0, false)
            SetVehicleIndicatorLights(vehTrailer, 1, true)
        end
    elseif (status == "Right") then
        SetVehicleIndicatorLights(veh, 0, true)
        SetVehicleIndicatorLights(veh, 1, false)

        if hasTrailer then
            SetVehicleIndicatorLights(vehTrailer, 0, true)
            SetVehicleIndicatorLights(vehTrailer, 1, false)
        end
    elseif (status == "Both") then
        SetVehicleIndicatorLights(veh, 0, true)
        SetVehicleIndicatorLights(veh, 1, true)

        if hasTrailer then
            SetVehicleIndicatorLights(vehTrailer, 0, true)
            SetVehicleIndicatorLights(vehTrailer, 1, true)
        end
    end
end

-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, ENABLE NEUTRAL GEAR
function SetNeutralGear()
    neutral = true
end

-- WHEN TRIGGERED, MAINTAIN NEUTRAL GEAR STATUS IF ENABLED
function MaintainNeutralGear()
    if myVeh and IsVehicleEngineOn(myVeh) and (GetPedInVehicleSeat(myVeh, -1) == PlayerPedId()) then
        if (GetEntitySpeed(myVeh) < 4) and not IsControlPressed(1, 32) then
            if neutral then
                SetVehicleBrakeLights(myVeh, false)
            else
                SetVehicleBrakeLights(myVeh, true)
            end
        else
            if neutral then
                neutral = false
            end
        end
    end
end

-- WHEN TRIGGERED, PREPARE TO TOGGLE TURN SIGNALS
function ToggleTurnSignal(signal)
    if myVeh and (GetPedInVehicleSeat(myVeh, -1) == PlayerPedId()) then
        indicatorTime = 0
        if (indicator == signal) then
            indicator = "Off"
        else
            indicator = signal
            heading = GetEntityHeading(myVeh)
        end

        PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
        exports["soe-nexus"]:TriggerServerCallback("UX:Server:SyncTurnSignals", VehToNet(myVeh), indicator)
    end
end

-- WHEN TRIGGERED, CHECK IF TURN SIGNAL SHOULD TURN OFF BY HEADING CHANGE
function ControlTurnSignals()
    if myVeh and (GetPedInVehicleSeat(myVeh, -1) == PlayerPedId()) then
        if (indicatorTime == 0) then
            if (indicator ~= "Off") then
                if (math.abs(GetEntityHeading(myVeh) - heading) > 60.0) then
                    indicatorTime = (GetGameTimer() + 1500)
                end
            end
        else
            if GetGameTimer() >= indicatorTime and indicator ~= "Both" and (indicator == "Left" or indicator == "Right") then
                indicator = "Off"

                PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                exports["soe-nexus"]:TriggerServerCallback("UX:Server:SyncTurnSignals", VehToNet(myVeh), indicator)
            end
        end
    end
end

-- **********************
--       Commands
-- **********************
-- WHEN TRIGGERED, ENABLE NEUTRAL GEAR
RegisterCommand("neutral", SetNeutralGear)

-- WHEN TRIGGERED, TOGGLE HAZARDS
RegisterCommand("hazards", function()
    ToggleTurnSignal("Both")
end)

-- WHEN TRIGGERED, TOGGLE LEFT TURN SIGNAL
RegisterCommand("leftblinker", function()
    ToggleTurnSignal("Left")
end)

-- WHEN TRIGGERED, TOGGLE RIGHT TURN SIGNAL
RegisterCommand("rightblinker", function()
    ToggleTurnSignal("Right")
end)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, SYNCS CAR BLINKERS WITH THE REST OF THE POPULATION
RegisterNetEvent("UX:Client:SyncTurnSignals", SyncTurnSignals)
