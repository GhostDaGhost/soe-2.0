--[[local cctvCam = 0
local tableProp = nil
local inCamera = false

-- KEY MAPPINGS
RegisterKeyMapping("securitycamera_up", "Security Camera: Look Up", "keyboard", "UP")
RegisterKeyMapping("securitycamera_down", "Security Camera: Look Down", "keyboard", "DOWN")
RegisterKeyMapping("securitycamera_left", "Security Camera: Look Left", "keyboard", "LEFT")
RegisterKeyMapping("securitycamera_right", "Security Camera: Look Right", "keyboard", "RIGHT")

local function ViewCamera(camNumber)
    local camNumber = tonumber(camNumber)
    local x = cctvCamLocations[camNumber].x
    local y = cctvCamLocations[camNumber].y
    local z = cctvCamLocations[camNumber].z
    local h = cctvCamLocations[camNumber].h

    inCamera = true
    SetTimecycleModifier("heliGunCam")
    SetTimecycleModifierStrength(1.0)
    local scaleform = RequestScaleformMovie("TRAFFIC_CAM")
    while not HasScaleformMovieLoaded(scaleform) do
        Wait(15)
    end

    cctvCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(cctvCam, x, y, (z + 1.2))
    SetCamRot(cctvCam, -15.0, 0.0, h)
    SetCamFov(cctvCam, 110.0)
    RenderScriptCams(true, false, 0, 1, 0)
    PushScaleformMovieFunction(scaleform, "PLAY_CAM_MOVIE")
    SetFocusArea(x, y, z, 0.0, 0.0, 0.0)
    PopScaleformMovieFunctionVoid()

    while inCamera do
        Wait(5)
        SetCamCoord(cctvCam, x, y, (z + 1.2))
        PushScaleformMovieFunction(scaleform, "SET_ALT_FOV_HEADING")
        PushScaleformMovieFunctionParameterFloat(GetEntityCoords(h).z)
        PushScaleformMovieFunctionParameterFloat(1.0)
        PushScaleformMovieFunctionParameterFloat(GetCamRot(cctvCam, 2).z)
        PopScaleformMovieFunctionVoid()
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
    end

    ClearFocus()
    ClearTimecycleModifier()
    RenderScriptCams(false, false, 0, 1, 0)
    SetScaleformMovieAsNoLongerNeeded(scaleform)
    DestroyCam(cctvCam, false)
end

local function SelectCCTVCamera(camNumber)
    local ped = PlayerPedId()
    camNumber = tonumber(camNumber)
    if inCamera then
        PlaySoundFrontend(-1, "HACKING_SUCCESS", false)
        inCamera = false
        Wait(1500)
        DeleteEntity(tableProp)
        Wait(50)
        ClearPedTasks(ped)
        tableProp = nil
    else
        if (camNumber > 0 and camNumber < #cctvCamLocations + 1) then
            local pos = GetEntityCoords(ped)
            exports["soe-utils"]:LoadModel(GetHashKey("prop_cs_tablet"), 15)
            tableProp = CreateObject(GetHashKey("prop_cs_tablet"), pos, 1, 1, 1)
            AttachEntityToEntity(GetHashKey("prop_cs_tablet"), ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.03, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)

            local dict = "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a"
            exports["soe-utils"]:LoadAnimDict(dict, 15)
            TaskPlayAnim(ped, dict, "idle_a", 8.0, 1.0, -1, 49, 0, 0, 0, 0)

            PlaySoundFrontend(-1, "HACKING_SUCCESS", false)
            ViewCamera(camNumber)
        else
            exports["soe-ui"]:SendAlert("error", "This camera appears to be faulty", 5000)
        end
    end
end

RegisterCommand("cctv", function(source, args)
    local char = exports["soe-uchuu"]:GetPlayer()
    if (char.CivType == "POLICE" or char.CivType == "EMS") then
        SelectCCTVCamera(args[1])
    else
        TriggerEvent("Chat:Client:SendMessage", "system", "This command is only available for Emergency Services.")
    end
end)

RegisterCommand("securitycamera_left", function()
    if inCamera then
        local rot = GetCamRot(cctvCam, 2)
        SetCamRot(cctvCam, rot.x, 0.0, (rot.z + 0.7), 2)
    end
end)

RegisterCommand("securitycamera_right", function()
    if inCamera then
        local rot = GetCamRot(cctvCam, 2)
        SetCamRot(cctvCam, rot.x, 0.0, (rot.z - 0.7), 2)
    end
end)

RegisterCommand("securitycamera_up", function()
    if inCamera then
        local rot = GetCamRot(cctvCam, 2)
        SetCamRot(cctvCam, (rot.x + 0.7), 0.0, rot.z, 2)
    end
end)

RegisterCommand("securitycamera_down", function()
    if inCamera then
        local rot = GetCamRot(cctvCam, 2)
        SetCamRot(cctvCam, (rot.x - 0.7), 0.0, rot.z, 2)
    end
end)]]
