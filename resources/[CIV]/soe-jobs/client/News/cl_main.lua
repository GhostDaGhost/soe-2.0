local news = {}
local action = nil
local cooldown = 0
local usingCamera = false

-- CAMERA VARIABLES
local zoomSpeed = 10.0
local new_x, new_z = 0, 0
local fov_min, fov_max = 5.0, 70.0
local speed_lr, speed_ud = 8.0, 8.0
local fov = (fov_max + fov_min) * 0.5

local function CheckInputRotation(cam, zoomValue)
    local rotation = GetCamRot(cam, 2)
    local rightAxisX, rightAxisY = GetDisabledControlNormal(0, 220), GetDisabledControlNormal(0, 221)
    if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
        new_z = rotation.z + rightAxisX * -1.0 * (speed_ud) * (zoomValue + 0.1)
        new_x = math.max(math.min(20.0, rotation.x + rightAxisY * -1.0 * (speed_lr) * (zoomValue + 0.1)), -89.5)
        SetCamRot(cam, new_x, 0.0, new_z, 2)
    end
end

local function HideHUDThisFrame()
    HideHelpTextThisFrame()
    HideHudAndRadarThisFrame()
    HideHudComponentThisFrame(1)
    HideHudComponentThisFrame(2)
    HideHudComponentThisFrame(6)
    HideHudComponentThisFrame(8)
    HideHudComponentThisFrame(13)
    HideHudComponentThisFrame(11)
    HideHudComponentThisFrame(12)
    HideHudComponentThisFrame(15)
    HideHudComponentThisFrame(18)
    HideHudComponentThisFrame(19)
end

-- FUNCTION TO SPAWN NEWS VAN
local function ManageDeliveryVehicle(pos, needsSpawning)
    if needsSpawning then
        -- SPAWN NEWS VAN AND GIVE PLAYER THE KEYS
        news.veh = exports["soe-utils"]:SpawnVehicle("rumpo", pos)
        SetVehicleLivery(news.veh, 2)

        local plate = exports["soe-utils"]:GenerateRandomPlate()
        SetVehicleNumberPlateText(news.veh, plate)
        Wait(500)

        exports["soe-valet"]:UpdateKeys(news.veh)

        -- SET IT AS A RENTAL
        exports["soe-utils"]:SetRentalStatus(news.veh)
        SetEntityAsMissionEntity(news.veh, true, true)
        DecorSetBool(news.veh, "noInventoryLoot", true)
    else
        -- IF VAN IS IN PROXIMITY, DESPAWN IT
        if #(GetEntityCoords(news.veh) - vector3(pos.x, pos.y, pos.z)) <= 15.5 then
            --exports["soe-valet"]:RemoveKey(news.veh)
            TriggerServerEvent("Utils:Server:DeleteEntity", VehToNet(news.veh))
        else
            local plate = GetVehicleNumberPlateText(news.veh)
            TriggerServerEvent("Emergency:Server:MarkStolen", plate, true, true)
            exports["soe-ui"]:SendAlert("error", "The manager does not see the van anywhere. They reported it stolen.")
        end

        news.veh = nil
    end
end

-- TOGGLES NEWS REPORTING DUTY
local function ToggleDuty(state)
    if state then
        if (cooldown > GetGameTimer()) then
            exports["soe-ui"]:SendAlert("error", "Wait a bit before doing that again", 5000)
            return
        end

        ManageDeliveryVehicle(action.spawnLoc, true)
        TriggerServerEvent("Jobs:Server:ToggleDuty", {status = true, dutyStatus = true, job = "NEWS"})
    else
        cooldown = GetGameTimer() + 5000
        ManageDeliveryVehicle(action.spawnLoc, false)
        TriggerServerEvent("Jobs:Server:ToggleDuty", {status = true, dutyStatus = false, job = "NEWS"})
        news = {}
    end
end

local function HandleZoom(cam)
    if not IsPedSittingInAnyVehicle(PlayerPedId()) then
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
    else
        if IsControlJustPressed(0, 17) then
            fov = math.max(fov - zoomSpeed, fov_min)
        end

        if IsControlJustPressed(0, 16) then
            fov = math.min(fov + zoomSpeed, fov_max)
        end

        local current_fov = GetCamFov(cam)
        if math.abs(fov - current_fov) < 0.1 then
            fov = current_fov
        end
        SetCamFov(cam, current_fov + (fov - current_fov) * 0.05)
    end
end

-- A FUNCTION THAT ALLOWS CAMERA USAGE
function UseCamera(title)
    if not usingCamera then
        usingCamera = true
        exports["soe-utils"]:LoadAnimDict("oddjobs@bailbond_mountain", 15)

        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local cam = exports["soe-utils"]:SpawnObject("prop_v_cam_01")
        AttachEntityToEntity(cam, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
        TaskPlayAnim(ped, "oddjobs@bailbond_mountain", "idle_camman", 1.0, 1.0, -1, 49, 0, 0, 0, 0)
        Wait(1500)

        --local scaleform = RequestScaleformMovie("security_camera")
        --while not HasScaleformMovieLoaded(scaleform) do Wait(15) end

        local scaleform2 = RequestScaleformMovie("breaking_news")
        while not HasScaleformMovieLoaded(scaleform2) do Wait(15) end

        local cam2 = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
        AttachCamToEntity(cam2, ped, 0.0, 0.0, 1.0, true)
        SetCamRot(cam2, 2.0, 1.0, GetEntityHeading(ped))
        SetCamFov(cam2, fov)
        RenderScriptCams(true, false, 0, 1, 0)
        PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
        PushScaleformMovieFunction(scaleform2, "breaking_news")
        PopScaleformMovieFunctionVoid()

        BeginScaleformMovieMethod(scaleform2, "SET_TEXT")
        PushScaleformMovieMethodParameterString(title or "")
        PushScaleformMovieMethodParameterString(string.upper(exports["soe-utils"]:GetAreaNames()[GetNameOfZone(pos.x, pos.y, pos.z)]))
        EndScaleformMovieMethod()


        local veh = GetVehiclePedIsIn(ped)
        while usingCamera and not IsEntityDead(ped) and (GetVehiclePedIsIn(ped) == veh) and true do
            if not IsEntityPlayingAnim(ped, "oddjobs@bailbond_mountain", "idle_camman", 3) then
                usingCamera = false
            end

            DisableControlAction(0, 200, true)
            if IsDisabledControlJustReleased(0, 200) then
                usingCamera = false
            end

            SetEntityRotation(ped, 0, 0, new_z, 2, true)
            local zoomValue = (1.0 / (fov_max - fov_min)) * (fov - fov_min)
            CheckInputRotation(cam2, zoomValue)

            HandleZoom(cam2)
            HideHUDThisFrame()

            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
            DrawScaleformMovie(scaleform2, 0.5, 0.63, 1.0, 1.0, 255, 255, 255, 255)

            local camHeading = GetGameplayCamRelativeHeading()
            local camPitch = GetGameplayCamRelativePitch()
            if camPitch < -70.0 then
                camPitch = -70.0
            elseif camPitch > 42.0 then
                camPitch = 42.0
            end
            camPitch = (camPitch + 70.0) / 112.0

            if camHeading < -180.0 then
                camHeading = -180.0
            elseif camHeading > 180.0 then
                camHeading = 180.0
            end
            camHeading = (camHeading + 180.0) / 360.0

            SetTaskMoveNetworkSignalFloat(ped, "Pitch", camPitch)
            SetTaskMoveNetworkSignalFloat(ped, "Heading", camHeading * -1.0 + 1.0)
            Wait(5)
        end

        fov = (fov_max + fov_min) * 0.5
        RenderScriptCams(false, false, 0, 1, 0)
        SetScaleformMovieAsNoLongerNeeded(scaleform)
        DestroyCam(cam2, false)
        TriggerServerEvent("Utils:Server:DeleteEntity", ObjToNet(cam))
        StopAnimTask(ped, "oddjobs@bailbond_mountain", "idle_camman", -2.0)
        cam = nil
    else
        usingCamera = false
    end
end

RegisterCommand("newscam", function(source, args)
    if not exports["soe-inventory"]:HasInventoryItem("weazelcamera") then
        exports["soe-ui"]:SendAlert("error", "You need a weazel news camera to do this!", 5000)
        return
    end

    local title = ""
    for _, arg in pairs(args) do
        title = title .. arg .. " "
    end
    UseCamera(title)
end)

AddEventHandler("Utils:Client:EnteredZone", function(name, zoneData)
    if name:match("news") then
        action = {status = true, spawnLoc = zoneData.spawn}
        if (GetMyJob() == "NEWS") then
            exports["soe-ui"]:ShowTooltip("fas fa-newspaper", "[E] Quit Job", "inform")
        else
            exports["soe-ui"]:ShowTooltip("fas fa-newspaper", "[E] Start Job", "inform")
        end
    end
end)

AddEventHandler("Utils:Client:ExitedZone", function(name)
    if name:match("news") then
        action = nil
        exports["soe-ui"]:HideTooltip()
    end
end)

AddEventHandler("Utils:Client:InteractionKey", function()
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
        return
    end

    -- ZONE FUNCTIONS RELATED TO NEWS REPORTING DUTY TOGGLE
    if not action then return end
    if action.status then
        if (GetMyJob() == "NEWS") then
            ToggleDuty(false)
        else
            ToggleDuty(true)
        end
    end
end)

-- CALLED FROM SERVER TO LET THOSE WHO ARE NEWS REPORTING OF A POSSIBLE STORY
RegisterNetEvent("Jobs:Client:SendNewsReport")
AddEventHandler("Jobs:Client:SendNewsReport", function(location, pos, name)
    --print(location, pos, name)
    local found = false
    if (name == "Vangelico Jewelry Store") then
        found = true
        local text = ("We received tips from civilians of some alarm going off at %s! Go and check it out!"):format(location)
        TriggerEvent("Chat:Client:Message", "[News Station]", text, "system")
        exports["soe-utils"]:PlaySound("radio_chatter.ogg", exports["soe-utils"]:GetSoundLevel(), true)
    elseif (name == "Fire") then
        found = true
        local text = ("We received reports of a large fire at %s! Unsure if SAFR or any LEO are on scene."):format(location)
        TriggerEvent("Chat:Client:Message", "[News Station]", text, "system")
        exports["soe-utils"]:PlaySound("radio_chatter.ogg", exports["soe-utils"]:GetSoundLevel(), true)
    elseif name:match("24/7") or name:match("Ammu-Nation") or name:match("Liquor Store") or name:match("LTD") or name:match("Digital Den") then
        found = true
        local text = ("We received tips from civilians that some store is possibly being robbed at %s! Go and check it out!"):format(location)
        TriggerEvent("Chat:Client:Message", "[News Station]", text, "system")
        exports["soe-utils"]:PlaySound("radio_chatter.ogg", exports["soe-utils"]:GetSoundLevel(), true)
    end

    if found then
        -- CREATE A BLIP FOR THE POSSIBLE REPORT LOCATION
        local opacity = 100
        local blip = AddBlipForCoord(pos)
        SetBlipSprite(blip, 459)
        SetBlipColour(blip, 6)
        SetBlipScale(blip, 1.35)
        SetBlipAlpha(blip, opacity)
        SetBlipFlashes(blip, true)
        SetBlipFlashInterval(blip, 200)

        while (opacity ~= 0) do
            Wait(250 * 4)
            opacity = opacity - 1
            SetBlipAlpha(blip, opacity)
            if (opacity == 0) then
                RemoveBlip(blip)
                return
            end
        end
    end
end)
