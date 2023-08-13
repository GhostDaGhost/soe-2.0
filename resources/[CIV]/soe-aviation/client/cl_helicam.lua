local myAircraft
local isUsingHelicam, isInsideAircraft = false, false

-- HELICAM CONFIGURATION SETTINGS
local zoomSpeed = 4.0
local cam, lockedOnVehicle
local fov_min, fov_max = 5.0, 80.0
local speed_lr, speed_ud = 5.5, 5.5
local visionState, targetLostTime = 0, 0
local fov = ((fov_max + fov_min) * 0.5)

-- KEY MAPPINGS
RegisterKeyMapping("helicam", "[Helicam] Toggle", "KEYBOARD", "E")
RegisterKeyMapping("helicam_lock", "[Helicam] Lock Target", "MOUSE_BUTTON", "MOUSE_LEFT")
RegisterKeyMapping("helicam_vision", "[Helicam] Change Vision", "MOUSE_BUTTON", "MOUSE_RIGHT")
RegisterKeyMapping("helicam_searchlight", "[Helicam] Search Light", "KEYBOARD", "G")

-- ***********************
--     Local Functions
-- ***********************
-- IF THIS HELICAM IS USABLE, SHOW PROMPT
local function ShowHelicamPrompt()
    exports["soe-ui"]:PersistentAlert("start", "helicamPrompt", "inform", "[E] Helicam", 100)
end

-- WHEN TRIGGERED, TOGGLE HELICOPTER SEARCHLIGHT
local function DoSearchlight()
    if not myAircraft then return end
    if (GetPedInVehicleSeat(myAircraft, -1) == PlayerPedId()) then
		searchlight = not searchlight

        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
		TriggerServerEvent("Aviation:Server:SearchLight", {status = true, veh = VehToNet(myAircraft), state = searchlight})
	end
end

-- SETS UP HELICAM CAMERA
local function SetHelicamCameraUp()
    local _cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
    AttachCamToEntity(_cam, myAircraft, 0.0, 0.0, -1.5, true)

    SetCamRot(_cam, 0.0, 0.0, GetEntityHeading(myAircraft))
    SetCamFov(_cam, fov)
    SetCamFarClip(_cam, 1000.0)
    RenderScriptCams(true, false, 0, 1, 0)
    return _cam
end

-- UNLOCKS CAMERA AFTER TARGET LOSS
local function UnlockCamera()
    local _fov = GetCamFov(cam)
    local rot = GetCamRot(cam, 2)

    DestroyCam(cam, false)
    cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
    AttachCamToEntity(cam, myAircraft, 0.0, 0.0, -1.5, true)
    SetCamRot(cam, rot, 2)
    SetCamFov(cam, _fov)
    SetCamFarClip(cam, 1000.0)
    RenderScriptCams(true, false, 0, 1, 0)
end

-- GETS VEHICLE THE CAMERA IS AIMING AT
local function GetVehicleInView(cam)
    local coords = GetCamCoord(cam)
    local forward_vector = exports["soe-utils"]:RotAnglesToVec(GetCamRot(cam, 2))
    local rayHandle = CastRayPointToPoint(coords, coords + (forward_vector * 800.0), 10, myAircraft, 0)
    local _, _, _, _, entityHit = GetRaycastResult(rayHandle)

    if entityHit > 0 and IsEntityAVehicle(entityHit) then
        return entityHit
    end
    return nil
end

-- CHECKS INPUT ROTATION FOR CAMERA
local function CheckInputRotation(cam, zoomValue)
    local rightAxisX, rightAxisY = GetDisabledControlNormal(0, 220), GetDisabledControlNormal(0, 221)
    local rotation = GetCamRot(cam, 2)

    if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
        local new_z = rotation.z + rightAxisX * -1.0 * (speed_ud) * (zoomValue + 0.1)
        local new_x = math.max(math.min(20.0, rotation.x + rightAxisY * -1.0 * (speed_lr) * (zoomValue + 0.1)), -89.5)
        SetCamRot(cam, new_x, 0.0, new_z, 2)
    end
end

-- GRABS RELEVANT VEHICLE INFORMATION
local function RenderVehicleInfo(veh)
    -- GET VEHICLE LOCATION
    local loc = exports["soe-utils"]:GetLocation(GetEntityCoords(veh))

    -- GET VEHICLE DESCRIPTION
    local name = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh)))
    local speed, plate = GetEntitySpeed(veh), GetVehicleNumberPlateText(veh)
    local hdg = exports["soe-utils"]:GetDirection(GetEntityHeading(veh))

	SendNUIMessage({
        type = "Helicam.PopulateUI",
        vehData = {
            model = name,
            plate = plate,
            speed = speed,
            street = loc,
            hdg = hdg
        }
    })
end

-- HANDLES CAMERA ZOOMING
local function HandleZoom(cam)
    if IsControlJustPressed(0, 241) then
        fov = math.max(fov - zoomSpeed, fov_min)
    end

    if IsControlJustPressed(0, 242) then
        fov = math.min(fov + zoomSpeed, fov_max)
    end

    local current_fov = GetCamFov(cam)
    if math.abs(fov - current_fov) < 0.1 then
        fov = current_fov
    end
    SetCamFov(cam, current_fov + (fov - current_fov) * 0.05)
end

-- LOCKS ONTO HELICAM TARGET
local function LockTarget()
    if not myAircraft then return end
    if not isUsingHelicam then return end

    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
    if not lockedOnVehicle then
        local vehicleDetected = GetVehicleInView(cam)
        if DoesEntityExist(vehicleDetected) then
            lockedOnVehicle = vehicleDetected
            exports["soe-ui"]:SendAlert("warning", "You locked onto a target", 3500)
        else
            exports["soe-ui"]:SendAlert("error", "No vehicle found", 2500)
        end
    else
        lockedOnVehicle = nil
        UnlockCamera()
        exports["soe-ui"]:SendAlert("warning", "You unlocked from a target", 3500)
    end
end

-- CYCLES HELICAM VISION STATES
local function CycleHelicamVision()
    if not myAircraft then return end
    if not isUsingHelicam then return end

    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
    if (visionState == 0) then
        SetNightvision(true)
        visionState = 1
    elseif (visionState == 1) then
        SetNightvision(false)
        SetSeethrough(true)
        visionState = 2
    else
        SetSeethrough(false)
        visionState = 0
    end
end

-- TOGGLES HELICAM STATE
local function ToggleHelicam()
    if not myAircraft then return end
    if (GetPedInVehicleSeat(myAircraft, 0) ~= PlayerPedId()) then
        return
    end

    if not isUsingHelicam then
        --[[if (GetEntityHeightAboveGround(myAircraft) < 1.5) then
            exports["soe-ui"]:SendAlert("error", "Not high enough", 3500)
            return
        end]]

        isUsingHelicam = true
        SendNUIMessage({type = "Helicam.ToggleUI", show = true})
        exports["soe-ui"]:PersistentAlert("end", "helicamPrompt")

        -- START SETTING UP SCALEFORM
        SetTimecycleModifier("heliGunCam")
        SetTimecycleModifierStrength(0.3)
        local scaleform = RequestScaleformMovie("HELI_CAM")
        while not HasScaleformMovieLoaded(scaleform) do
            Wait(15)
        end

        PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
        PushScaleformMovieFunctionParameterInt(0)
        PopScaleformMovieFunctionVoid()

        -- SET CAMERA UP
        local loopIndex = 0
        cam = SetHelicamCameraUp()
        while isUsingHelicam do
            Wait(5)
            HandleZoom(cam)
            local zoomValue = (1.0 / (fov_max - fov_min)) * (fov - fov_min)
            CheckInputRotation(cam, zoomValue)

            PushScaleformMovieFunction(scaleform, "SET_ALT_FOV_HEADING")
            PushScaleformMovieFunctionParameterFloat(GetEntityCoords(myAircraft).z)
            PushScaleformMovieFunctionParameterFloat(zoomValue)
            PushScaleformMovieFunctionParameterFloat(GetCamRot(cam, 2).z)
            PopScaleformMovieFunctionVoid()
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)

            loopIndex = loopIndex + 1
            if (loopIndex % 10 == 0) then
                if lockedOnVehicle then
                    if DoesEntityExist(lockedOnVehicle) then
                        PointCamAtEntity(cam, lockedOnVehicle, 0.0, 0.0, 0.0, true)
                        RenderVehicleInfo(lockedOnVehicle)
                        if HasEntityClearLosToEntity(myAircraft, lockedOnVehicle, 17) then
                            targetLostTime = GetGameTimer()
                        end

                        local tooLongSinceLastLock = targetLostTime
                        if (exports["soe-utils"]:TimeSince(tooLongSinceLastLock) > 1000) then
                            exports["soe-ui"]:SendAlert("error", "Locked target lost!", 5000)
                            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                            lockedOnVehicle = nil
                            UnlockCamera()
                        end
                    end
                end
                loopIndex = 0
            end
        end
    else
        isUsingHelicam = false
        SendNUIMessage({type = "Helicam.ToggleUI", show = false})

        -- RESET SCALEFORM FACTORS
        ClearTimecycleModifier()
        RenderScriptCams(false, false, 0, 1, 0)
        SetScaleformMovieAsNoLongerNeeded(scaleform)
        DestroyCam(cam, false)
        SetNightvision(false)
        SetSeethrough(false)
        cam = nil

        Wait(250)
        ShowHelicamPrompt()
    end
end

-- ***********************
--    Global Functions
-- ***********************
-- RETURNS IF PLAYER IS USING HELICAM
function IsUsingHelicam()
    return isUsingHelicam
end

-- ***********************
--        Commands
-- ***********************
-- WHEN TRIGGERED, TOGGLE HELICAM
RegisterCommand("helicam", ToggleHelicam)
-- WHEN TRIGGERED, LOCK ONTO TARGET
RegisterCommand("helicam_lock", LockTarget)
-- WHEN TRIGGERED, CYCLE VISION STAGE
RegisterCommand("helicam_vision", CycleHelicamVision)
-- WHEN TRIGGERED, DO SEARCH LIGHT
RegisterCommand("helicam_searchlight", DoSearchlight)

-- ***********************
--         Events
-- ***********************
-- WHEN TRIGGERED, RESET ALL NUI INSTANCES
AddEventHandler("UI:Client:ResetNUI", function()
    SendNUIMessage({type = "Helicam.ResetUI"})
end)

-- WHEN TRIGGERED, TOGGLE HELICOPTER SEARCHLIGHT
RegisterNetEvent("Aviation:Client:SearchLight", function(veh, state)
    veh = NetToVeh(veh)
    SetVehicleSearchlight(veh, state, false)
end)

-- RECORD CURRENT AIRCRAFT EXIT STATUS
AddEventHandler("BaseEvents:Client:LeftVehicle", function()
    -- RESET GENERAL HELICAM STATES
    myAircraft, isInsideAircraft, isUsingHelicam = nil, false, false
    exports["soe-ui"]:PersistentAlert("end", "helicamPrompt")
end)

-- RECORD CURRENT AIRCRAFT ENTRY STATUS
AddEventHandler("BaseEvents:Client:EnteredVehicle", function(veh, seat)
    if IsThisModelAHeli(GetEntityModel(veh)) then
        myAircraft, isInsideAircraft = veh, true

        if (seat == 0) then
            ShowHelicamPrompt()
        end
    end
end)
