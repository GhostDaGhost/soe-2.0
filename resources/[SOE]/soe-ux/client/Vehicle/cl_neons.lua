local flashNeons, sequenceNeons = false, false

-- **********************
--    Local Functions
-- **********************
-- TOGGLES NEON LIGHTS BASED ON ARGUMENT BOOLEAN
local function ToggleAllNeons(bool)
    SetVehicleNeonLightEnabled(myVeh, 0, bool)
    SetVehicleNeonLightEnabled(myVeh, 1, bool)
    SetVehicleNeonLightEnabled(myVeh, 2, bool)
    SetVehicleNeonLightEnabled(myVeh, 3, bool)
end

-- FLASHES ALL NEON LIGHTS OFF AND ON
local function FlashNeonLights()
    if flashNeons then
        ToggleAllNeons(true)
        Wait(500)
        ToggleAllNeons(false)
        Wait(500)
        FlashNeonLights()
    end
end

-- DOES LIGHT SEQUENCES WITH NEON LIGHTS
local function Sequence()
    if sequenceNeons then
        ToggleAllNeons(false)
        Wait(100)
        SetVehicleNeonLightEnabled(myVeh, 2, true)
        Wait(100)
        ToggleAllNeons(false)
        Wait(100)
        SetVehicleNeonLightEnabled(myVeh, 1, true)
        Wait(100)
        ToggleAllNeons(false)
        Wait(100)
        SetVehicleNeonLightEnabled(myVeh, 3, true)
        Wait(100)
        ToggleAllNeons(false)
        Wait(100)
        SetVehicleNeonLightEnabled(myVeh, 0, true)
        Wait(100)
        Sequence()
    end
end

-- WHEN TRIGGERED, CONTROL NEON UNDERGLOW
local function DoNeonUnderglow(data)
    if not data.status then return end
    if not data.type then return end

    -- VEHICLE CHECKS
    if not myVeh then return end
    if (GetPedInVehicleSeat(myVeh, -1) ~= PlayerPedId()) then return end

    -- CHECK IF VEHICLE EVEN HAS NEONS INSTALLED
    local canUse = true
    local modData = exports["soe-shops"]:GetModDataFromVehicle(myVeh, true)
    if modData.toggles then
        if not modData.toggles.neons then
            canUse = false
        end
    else
        canUse = false
    end

    -- DO SPECIFIED NEON UNDERGLOW ACTION
    if canUse then
        if (data.type == "Controller") then
            SetNuiFocus(true, true)
            SendNUIMessage({type = "OpenNeonUnderglowController"})
        elseif (data.type == "On") then
            ToggleAllNeons(true)
            flashNeons, sequenceNeons = false, false
        elseif (data.type == "Off") then
            ToggleAllNeons(false)
            flashNeons, sequenceNeons = false, false
        elseif (data.type == "Flash") then
            if flashNeons then
                flashNeons = false
                exports["soe-ui"]:SendAlert("success", "Flash mode deactivated!", 5000)
            else
                sequenceNeons = false
                flashNeons = true
                exports["soe-ui"]:SendAlert("success", "Flash mode activated!", 5000)
            end
            ToggleAllNeons(false)
            FlashNeonLights()
        elseif (data.type == "Sequence") then
            if sequenceNeons then
                sequenceNeons = false
                exports["soe-ui"]:SendAlert("success", "Sequence mode deactivated!", 5000)
            else
                flashNeons = false
                sequenceNeons = true
                exports["soe-ui"]:SendAlert("success", "Sequence mode activated!", 5000)
            end
            ToggleAllNeons(false)
            Sequence()
        elseif (data.type == "Color") then
            if data.r and data.g and data.b then
                SetVehicleNeonLightsColour(myVeh, data.r, data.g, data.b)
                exports["soe-ui"]:SendAlert("success", "Neon colors changed!", 5000)
            end
        end
    else
        exports["soe-ui"]:SendAlert("error", "Neons are not installed in this vehicle", 5000)
    end
end

-- **********************
--     NUI Callbacks
-- **********************
-- WHEN TRIGGERED, SHUT OFF NUI FOCUS
RegisterNUICallback("NeonController.CloseUI", function()
    SetNuiFocus(false, false)
end)

-- WHEN TRIGGERED, SHUT OFF NUI FOCUS
RegisterNUICallback("NeonController.PushEvent", function(data)
    if (data.type == "RGB Setting") then
        DoNeonUnderglow({status = true, type = "Color", r = tonumber(data.red), g = tonumber(data.green), b = tonumber(data.blue)})
    elseif (data.type == "Sequence") then
        DoNeonUnderglow({status = true, type = "Sequence"})
    elseif (data.type == "Flash") then
        DoNeonUnderglow({status = true, type = "Flash"})
    elseif (data.type == "Off") then
        DoNeonUnderglow({status = true, type = "Off"})
    elseif (data.type == "On") then
        DoNeonUnderglow({status = true, type = "On"})
    end
end)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, CONTROL NEON UNDERGLOW
RegisterNetEvent("UX:Client:DoNeonUnderglow")
AddEventHandler("UX:Client:DoNeonUnderglow", DoNeonUnderglow)
