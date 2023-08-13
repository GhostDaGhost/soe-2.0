hud, minimap, streetOnTop, blackboxes = true, false, false, false
showMapBorder, setupRoundMap = false, false

-- KEY MAPPINGS
RegisterKeyMapping("hud", "[UI] Show/Hide UI", "KEYBOARD", "")
RegisterKeyMapping("cinematic_blackboxes", "[UI] Toggle Cinematic Blackboxes", "KEYBOARD", "")

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, TOGGLE LARGE GPS
local function ToggleLargeGPS()
    streetOnTop = not streetOnTop
    if streetOnTop then
        exports["soe-uchuu"]:UpdateSettings("largeGPS", false, true)
    else
        exports["soe-uchuu"]:UpdateSettings("largeGPS", true)
    end
end

-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, RETURN IF HUD IS VISIBLE
function HudVisible()
    return hud
end
exports("HudVisible", HudVisible)

-- WHEN TRIGGERED, ENABLE BIG GPS
function EnableBigGPS()
    streetOnTop = true
end
exports("EnableBigGPS", EnableBigGPS)

-- WHEN TRIGGERED, RETURN IF MINIMAP IS VISIBLE
function GetMinimap()
    return minimap
end
exports("GetMinimap", GetMinimap)

-- WHEN TRIGGERED, TOGGLE MINIMAP VISIBILITY
function ToggleMinimap(_minimap)
    minimap = _minimap
end
exports("ToggleMinimap", ToggleMinimap)

-- WHEN TRIGGERED, RESET ALL UI IN CASE OF MALFUNCTION
function ResetUI()
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)

    TriggerEvent("UI:Client:ResetNUI")
    SendNUIMessage({type = "UI.Reset"})
    SendAlert("success", "Resetting UI...", 1000)
end

-- WHEN TRIGGERED, CONTROL MINIMAP VISIBILITY
function ControlMinimap()
    if hud then
        local pauseActive, noWaypointActive = IsPauseMenuActive(), (GetFirstBlipInfoId(8) == 0)
        local isPhoneOpen = GetResourceState("soe-gphone") == "started" and exports["soe-gphone"]:IsPhoneOpen()
        if not (inVeh or isPhoneOpen) then
            DisplayRadar(minimap)
            if setupRoundMap then
                SendNUIMessage({type = "UI.RoundmapBorder", show = minimap and showMapBorder and not pauseActive, moreThick = noWaypointActive})
            end
        else
            DisplayRadar(true)
            if setupRoundMap then
                SendNUIMessage({type = "UI.RoundmapBorder", show = true and showMapBorder and not pauseActive, moreThick = noWaypointActive})
            end
        end
    else
        DisplayRadar(false)
        if setupRoundMap then
            SendNUIMessage({type = "UI.RoundmapBorder", show = false})
        end
    end
end

-- WHEN TRIGGERED, SET UP CIRCLE MINIMAP IF PLAYER ENABLED IT
function SetupRoundMinimap()
    if setupRoundMap then -- RESET BACK TO SQUARE MINIMAP
        setupRoundMap = false
        SetMinimapClipType(0)
        SendNUIMessage({type = "UI.RoundmapBorder", show = false})

        RemoveReplaceTexture("platform:/textures/graphics", "radarmasksm")
        SetMinimapComponentPosition("minimap", "L", "B", -0.0045, 0.002, 0.150, 0.188888)
        SetMinimapComponentPosition("minimap_mask", "L", "B", 0.020, 0.032, 0.111, 0.159)
        SetMinimapComponentPosition("minimap_blur", "L", "B", -0.03, 0.022, 0.266, 0.237)
    
        SetBigmapActive(true, false)
        Wait(5)
        SetBigmapActive(false, false)
    
        SetBlipAlpha(GetNorthRadarBlip(), 1.0)
        Wait(1000)
        SetRadarZoom(1100)
        return
    end

    -- SET UP ROUND MINIMAP IF IT WASN'T ALREADY ENABLED
    setupRoundMap = true
    RequestStreamedTextureDict("circlemap", false)
    while not HasStreamedTextureDictLoaded("circlemap") do
        Wait(100)
    end

    AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")

    SetMinimapClipType(1)
    --[[SetMinimapComponentPosition("minimap", "L", "B", -0.005, -0.03, 0.153, 0.22)
    SetMinimapComponentPosition("minimap_mask", "L", "B", -0.015, 0.12, 0.093, 0.164)
    SetMinimapComponentPosition("minimap_blur", "L", "B", -0.015, 0.022, 0.256, 0.337)]]
    SetMinimapComponentPosition("minimap", "L", "B", -0.005, -0.03, 0.153, 0.22)
    SetMinimapComponentPosition("minimap_mask", "L", "B", 0.045, 0.12, 0.093, 0.164)
    SetMinimapComponentPosition("minimap_blur", "L", "B", -0.0135, 0.022, 0.256, 0.337)

    local roundmap = RequestScaleformMovie("minimap")
    SetBigmapActive(true, false)
    Wait(5)
    SetBigmapActive(false, false)

    SetBlipAlpha(GetNorthRadarBlip(), 0.0) -- DISABLE NORTH BLIP BECAUSE ITS WEIRD WITH ROUNDED MINIMAP
    Wait(1200)
    SetRadarZoom(1150)
end

-- **********************
--        Commands
-- **********************
-- WHEN TRIGGERED, TOGGLE BLACKBOXES VISIBILITY
RegisterCommand("cinematic_blackboxes", function()
    blackboxes = not blackboxes
    SendNUIMessage({type = "Settings.ToggleBlackboxes", show = blackboxes})
end)

-- WHEN TRIGGERED, TOGGLE UI VISIBILITY
RegisterCommand("hud", function()
    hud = not hud
    exports["soe-chat"]:HideChat(hud)
    TriggerEvent("Hud:Client:ToggleHud", hud)
end)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, RESET ALL UI IN CASE OF MALFUNCTION
RegisterNetEvent("UI:Client:ResetUI", ResetUI)

-- WHEN TRIGGERED, TOGGLE LARGE GPS
RegisterNetEvent("UI:Client:ToggleLargeGPS", ToggleLargeGPS)
