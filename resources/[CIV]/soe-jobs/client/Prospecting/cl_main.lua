local scannerState = "none"
local scannerEntity, previousAnim
local targets, attachedEntities, debugBlips = {}, {}, {}

local cooldown = 0
local blip_location = vector3(134.377, 2008.930, 152.241)
local scannerScale, scannerFrametime, maxTargetRange, area_size = 0.0, 0.0, 200.0, 5000.0
local pauseProspecting, didCancelProspecting, isProspecting, scannerAudio = false, false, false, true

-- KEY MAPPINGS
RegisterKeyMapping("prospecting_dig", "[Prospecting] Dig", "KEYBOARD", "E")
RegisterKeyMapping("prospecting_cancel", "[Prospecting] Stop", "KEYBOARD", "X")
RegisterKeyMapping("prospecting_toggleaudio", "[Prospecting] Toggle Detector Audio", "KEYBOARD", "RSHIFT")

-- ***********************
--    Local Functions
-- ***********************
-- WHEN TRIGGERED, GET CURRENT GROUND THAT PLAYER IS ON
local function GetGroundHash(ped)
    local pos = GetEntityCoords(ped)
    local num = StartShapeTestCapsule(pos.x, pos.y, pos.z + 4, pos.x, pos.y, pos.z - 2.0, 2, 1, ped, 7)
    local _, _, _, _, arg5 = GetShapeTestResultEx(num)
    return arg5
end

-- ***********************
--    Global Functions
-- ***********************
function StartProspecting()
    if not isProspecting then
        ProspectingThreads()
    end
end

function CleanupModels()
    for _, entity in pairs(attachedEntities) do
        DetachEntity(entity, 0, 0)
        DeleteEntity(entity)
    end
    attachedEntities = {}
    scannerEntity = nil
end

function AttachMetalDetector(ped, model)
    exports["soe-utils"]:LoadModel(model, 15)
    local ent = CreateObjectNoOffset(model, GetEntityCoords(ped), 1, 1, 0)

    scannerEntity = ent
    attachedEntities[#attachedEntities + 1] = ent
    AttachEntityToEntity(ent, ped, GetPedBoneIndex(ped, 18905), vector3(0.15, 0.1, 0.0), vector3(270.0, 90.0, 80.0), 1, 1, 0, 0, 2, 1)
end

function PlayAnimFlags(ped, dict, anim, flags)
    if previousAnim then
        StopEntityAnim(ped, previousAnim[2], previousAnim[1], true)
        previousAnim = nil
    end

    exports["soe-utils"]:LoadAnimDict(dict, 15)
    local animLength = GetAnimDuration(dict, anim)

    TaskPlayAnim(ped, dict, anim, 1.0, -1.0, animLength, flags, 0, 0, 0, 0)
    previousAnim = {dict, anim}
end

function GetClosestTarget(pos)
    local closest, index, closestdist, difficulty
    for targetIdx, target in pairs(targets) do
        local dist = #(pos.xy - target[1].xy)
        if not closest or closestdist > dist then
            closest, index, closestdist, difficulty = target, targetIdx, dist, target[2]
        end
    end
    return closest or vector3(0.0, 0.0, 0.0), closestdist, index, difficulty
end

function CanDigHere()
    local canDigHere = true
    local groundHash = GetGroundHash(PlayerPedId())

    for i = 1, #diggingBlacklist do
        if (diggingBlacklist[i] == groundHash) then
            canDigHere = false
            break
        end
    end
    return canDigHere
end

function DigSequence(cb)
    CleanupModels()

    local ped = PlayerPedId()
    StopAnimTask(ped, "wood_idle_a", "mini@golfai", -2.0)
    PlayAnimFlags(ped, "amb@world_human_gardener_plant@male@enter", "enter", 0)

    Wait(100)
    while IsEntityPlayingAnim(ped, "amb@world_human_gardener_plant@male@enter", "enter", 3) do
        Wait(5)
    end

    if cb and CanDigHere() then
        local progressCancelled = false
        cb()
        Wait(10000)
    elseif not CanDigHere() then
        exports["soe-ui"]:SendAlert("error", "You cannot dig at this location!", 4000)
    end

    if not progressCancelled then
        PlayAnimFlags(ped, "amb@world_human_gardener_plant@male@exit", "exit", 0)
        Wait(100)
        while IsEntityPlayingAnim(ped, "amb@world_human_gardener_plant@male@exit", "exit", 3) do
            Wait(5)
        end
    end
    AttachMetalDetector(PlayerPedId(), "w_am_digiscanner")
end

function DigTarget(index)
    pauseProspecting = true
    local target = table.remove(targets, index)
    local pos = target[1]

    DigSequence(function()
        exports["soe-utils"]:Progress(
            {
                name = "prospectDig",
                duration = 10000,
                label = "Digging",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true
                },
                animation = {
                    animDict = "amb@world_human_gardener_plant@male@base",
                    anim = "base",
                    flags = 35
                }
            },
            function(cancelled)
                if cancelled then
                    progressCancelled = true
                else
                    exports["soe-nexus"]:TriggerServerCallback("Jobs:Server:CollectedProspectNode", index, pos.x, pos.y, pos.z)
                end
            end
        )
    end)
    scannerState = "none"
    pauseProspecting = false
end

function StopProspecting()
    if didCancelProspecting then return end
    didCancelProspecting = true
    CleanupModels()

    StopEntityAnim(PlayerPedId(), "wood_idle_a", "mini@golfai", true)
    circleScale = 0.0
    scannerScale = 0.0

    scannerState = "none"
    isProspecting = false
    exports["soe-nexus"]:TriggerServerCallback("Jobs:Server:UserStoppedProspecting")
end

function ProspectingThreads()
    if IsProspecting then return false end

    exports["soe-nexus"]:TriggerServerCallback("Jobs:Server:UserStartedProspecting")
    didCancelProspecting = false
    pauseProspecting = false
    isProspecting = true

    CreateThread(function()
        AttachMetalDetector(PlayerPedId(), "w_am_digiscanner")
        while isProspecting do
            Wait(0)
            local ped, ply = PlayerPedId(), PlayerId()
            local canProspect = true

            if not IsEntityPlayingAnim(ped, "mini@golfai", "wood_idle_a", 3) and not pauseProspecting then
                PlayAnimFlags(ped, "mini@golfai", "wood_idle_a", 49)
            end

            -- ACTIONS THAT COULD HALT PROSPECTING ANIMATIONS/SCANNING
            local restrictedMovement = false
            restrictedMovement = restrictedMovement or IsPedFalling(ped)
            restrictedMovement = restrictedMovement or IsPedJumping(ped)
            restrictedMovement = restrictedMovement or IsPedSprinting(ped)
            restrictedMovement = restrictedMovement or IsPedRunning(ped)
            restrictedMovement = restrictedMovement or IsPlayerFreeAiming(ply)
            restrictedMovement = restrictedMovement or IsPedRagdoll(ped)
            restrictedMovement = restrictedMovement or IsPedInAnyVehicle(ped)
            restrictedMovement = restrictedMovement or IsPedInCover(ped)
            restrictedMovement = restrictedMovement or IsPedInMeleeCombat(ped)

            if restrictedMovement then
                canProspect = false
            end

            if canProspect then
                local pos = GetEntityCoords(ped) + vector3(GetEntityForwardX(ped) * 0.75, GetEntityForwardY(ped) * 0.75, -0.75)
                local target, dist, index, difficultyModifier = GetClosestTarget(pos)

                if (GetEntityHeightAboveGround(ped) <= 1.25) then
                    if index then
                        local dist = dist * difficultyModifier
                        if (dist < 3.0) and not pauseProspecting then
                            exports["soe-utils"]:FloatingHelpText("You found something!", pos)
                        end

                         if (dist < 3.0) then
                            circleScale, scannerScale, scannerState = 0.0, 0.0, "ultra"
                        elseif (dist < 4.0) then
                            scannerFrametime, scannerScale, scannerState = 0.35, 4.50, "fast"
                        elseif (dist < 5.0) then
                            scannerFrametime, scannerScale, scannerState = 0.4, 3.75, "fast"
                        elseif (dist < 6.5) then
                            scannerFrametime, scannerScale, scannerState = 0.425, 3.00, "fast"
                        elseif (dist < 7.5) then
                            scannerFrametime, scannerScale, scannerState = 0.45, 2.50, "fast"
                        elseif (dist < 10.0) then
                            scannerFrametime, scannerScale, scannerState = 0.5, 1.75, "fast"
                        elseif (dist < 12.5) then
                            scannerFrametime, scannerScale, scannerState = 0.75, 1.25, "medium"
                        elseif (dist < 15.0) then
                            scannerFrametime, scannerScale, scannerState = 1.0, 1.00, "medium"
                        elseif (dist < 20.0) then
                            scannerFrametime, scannerScale, scannerState = 1.25, 0.875, "medium"
                        elseif (dist < 25.0) then
                            scannerFrametime, scannerScale, scannerState = 1.5, 0.75, "slow"
                        elseif dist < 30.0 then
                            scannerFrametime, scannerScale, scannerState = 2.0, 0.5, "slow"
                        else
                            circleScale, scannerScale, scannerState = 0.0, 0.0, "none"
                        end
                        scannerDistance = dist
                    else
                        circleScale, scannerScale, scannerState = 0.0, 0.0, "none"
                    end
                end
            end

            -- IF THE PED IS BUSY AND CAN'T PROSPECT (FALLING OR WHATEVER)
            if not canProspect then
                StopEntityAnim(ped, "wood_idle_a", "mini@golfai", true)
                circleScale, scannerScale, scannerState = 0.0, 0.0, "none"
            end

            -- WE STOPPED PROSPECTING MID-FRAME
            if not isProspecting then
                CleanupModels()
                StopEntityAnim(ped, "wood_idle_a", "mini@golfai", true)
                circleScale, scannerScale, scannerState = 0.0, 0.0, "none"
            end
        end
        StopProspecting()
    end)

    -- RENDER MARKERS
    CreateThread(
        function()
            local renderCircle = false
            local framecount, frametime, loopIndex = 0, 0, 0
            local _circleR, _circleG, _circleB = 255, 255, 255
            local circleScale, circleScaleMultiplier = 0.0, 1.5
            local circleR, circleG, circleB, circleA = 255, 255, 255, 255

            while isProspecting do
                Wait(3)
                loopIndex = loopIndex + 1
                if (loopIndex % 755 == 0) then
                    loopIndex = 0
                    local newTargets = {}
                    local pos = GetEntityCoords(PlayerPedId())
                    for targetIdx, target in pairs(targetPool) do
                        --print(json.encode(target))
                        if #(pos.xy - target[1].xy) < maxTargetRange then
                            newTargets[#newTargets + 1] = {target[1], target[2], targetIdx}
                        end
                    end
                    targets = newTargets
                end

                if not pauseProspecting then
                    local ped = PlayerPedId()
                    local pos = GetEntityCoords(ped) + vector3(GetEntityForwardX(ped) * 0.75, GetEntityForwardY(ped) * 0.75, -0.75)

                    if scannerState == "none" then
                        renderCircle = false
                        circleR, circleG, circleB = 150, 255, 150
                        _circleR, _circleG, _circleB = 150, 255, 150
                    elseif scannerState == "slow" then
                        renderCircle = true
                        circleScale = circleScale + scannerScale
                        circleR, circleG, circleB = 150, 255, 150
                        if (frametime > scannerFrametime) then
                            frametime = 0.0
                        end
                    elseif scannerState == "medium" then
                        renderCircle = true
                        circleScale = circleScale + scannerScale
                        circleR, circleG, circleB = 255, 255, 150
                        if (frametime > scannerFrametime) then
                            frametime = 0.0
                        end
                    elseif scannerState == "fast" then
                        renderCircle = true
                        circleScale = circleScale + scannerScale
                        circleR, circleG, circleB = 255, 150, 150
                        if (frametime > scannerFrametime) then
                            frametime = 0.0
                        end
                    elseif scannerState == "ultra" then
                        renderCircle = false
                        circleScale = circleScale + scannerScale
                        circleR, circleG, circleB = 255, 100, 100

                        if (frametime > 0.125) then
                            frametime = 0.0
                            if scannerAudio then
                                PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
                                PlaySoundFrontend(-1, "BOATS_PLANES_HELIS_BOOM", "MP_LOBBY_SOUNDS", 0)
                            end
                        end

                        -- Draw the triple "found it" marker
                        circleA = 150
                        circleSize = 1.20 * circleScaleMultiplier
                        DrawMarker(1, pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, circleSize, circleSize, 0.2, circleR, circleG, circleB, circleA)
                        DrawMarker(6, pos, 0.0, 0.0, 0.0, 270.0, 0.0, 0.0, circleSize, 0.1, circleSize, circleR, circleG, circleB, circleA)

                        circleA = 200
                        circleSize = 0.70 * circleScaleMultiplier
                        DrawMarker(1, pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, circleSize, circleSize, 0.2, circleR, circleG, circleB, circleA)
                        DrawMarker(6, pos, 0.0, 0.0, 0.0, 270.0, 0.0, 0.0, circleSize, 0.1, circleSize, circleR, circleG, circleB, circleA)

                        circleA = 255
                        circleSize = 0.20 * circleScaleMultiplier
                        DrawMarker(1, pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, circleSize, circleSize, 0.2, circleR, circleG, circleB, circleA)
                        DrawMarker(6, pos, 0.0, 0.0, 0.0, 270.0, 0.0, 0.0, circleSize, 0.1, circleSize, circleR, circleG, circleB, circleA)
                    end

                    if renderCircle then
                        if (circleScale > 100) then
                            while (circleScale > 100) do
                                circleScale = circleScale - 100
                            end
                            _circleR, _circleG, _circleB = circleR, circleG, circleB

                            if scannerAudio then
                                PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
                            end
                        end

                        circleSize = ((circleScale % 100) / 100) * circleScaleMultiplier
                        circleA = math.floor(255 - ((circleScale % 100) / 100) * 155)
                        DrawMarker(1, pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, circleSize, circleSize, 0.2, _circleR, _circleG, _circleB, circleA)
                        DrawMarker(6, pos, 0.0, 0.0, 0.0, 270.0, 0.0, 0.0, circleSize, 0.1, circleSize, _circleR, _circleG, _circleB, circleA)
                    end

                    framecount = (framecount + 1) % 120
                    frametime = frametime + Timestep()
                end
            end
        end
    )
    return true
end

-- ***********************
--        Commands
-- ***********************
-- WHEN TRIGGERED, CANCEL PROSPECTING
RegisterCommand("prospecting_cancel", function()
    if isProspecting then
        isProspecting = false
        exports["soe-ui"]:SendAlert("inform", "You stop prospecting", 5000)
    end
end)

-- WHEN TRIGGERED, TOGGLE METAL DETECTOR AUDIO
RegisterCommand("prospecting_toggleaudio", function()
    if isProspecting then
        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
        scannerAudio = not scannerAudio

        if scannerAudio then
            exports["soe-ui"]:SendAlert("debug", "Metal Detector Audio: On", 2500)
        else
            exports["soe-ui"]:SendAlert("debug", "Metal Detector Audio: Off", 2500)
        end
    end
end)

-- WHEN TRIGGERED, DIG WHILST PROSPECTING
RegisterCommand("prospecting_dig", function()
    if isProspecting and not pauseProspecting then
        if (cooldown > GetGameTimer()) then
            exports["soe-ui"]:SendAlert("error", "Wait a bit before doing that again", 5000)
            return
        end

        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped) + vector3(GetEntityForwardX(ped) * 0.75, GetEntityForwardY(ped) * 0.75, -0.75)
        local _, dist, index, difficultyModifier = GetClosestTarget(pos)

        if (GetEntityHeightAboveGround(ped) <= 1.25) then
            if index then
                local dist = dist * difficultyModifier
                if (dist < 3.0) then
                    cooldown = GetGameTimer() + 8000
                    DigTarget(index)
                end
            end
        end
    end
end)

-- ***********************
--         Events
-- ***********************
-- WHEN TRIGGERED, STOP PROSPECTING
RegisterNetEvent("Jobs:Client:ForceStopProspect", StopProspecting)

-- WHEN TRIGGERED, START PROSPECTING
RegisterNetEvent("Jobs:Client:ForceStartProspect", StartProspecting)

-- WHEN TRIGGERED, REMOVE MODELS AND STOP PROSPECTING
AddEventHandler("onResourceStop", function(resource)
    if (GetCurrentResourceName() ~= resource) then return end

    CleanupModels()
    StopProspecting()
end)

-- WHEN TRIGGERED, GET PROSPECTING TARGETS FROM THE SERVER
AddEventHandler("onClientResourceStart", function(resource)
    if (GetCurrentResourceName() ~= resource) then return end
    Wait(2500)

    exports["soe-nexus"]:TriggerServerCallback("Jobs:Server:GetProspectTargets")
end)

-- WHEN TRIGGERED, SET PROSPECTING TARGETS FROM THE SERVER
RegisterNetEvent("Jobs:Client:SetProspectTargetPool", function(_targetPool)
    targetPool = {}
    --[[for _, blip in pairs(debugBlips) do
        RemoveBlip(blip)
    end
    debugBlips = {}]]

    for idx, pos in pairs(_targetPool) do
        targetPool[idx] = {vector3(pos[1], pos[2], pos[3]), pos[4], idx}
        --[[local blip = AddBlipForCoord(pos[1], pos[2], pos[3])
        SetBlipSprite(blip, 1)
        debugBlips[#debugBlips + 1] = blip]]
    end
end)

-- WHEN TRIGGERED, CHECK ELGIBILITY IF YOU CAN PROSPECT
AddEventHandler("Jobs:Client:BeginProspect", function()
    local pos = GetEntityCoords(PlayerPedId())
    local isInVeh = IsPedSittingInAnyVehicle(PlayerPedId())

    if #(pos - blip_location) < area_size and not isInVeh then
        exports["soe-nexus"]:TriggerServerCallback("Jobs:Server:ActivateProspecting")
    elseif isInVeh then
        exports["soe-ui"]:SendAlert("error", "You cannot prospect while in a vehicle", 4000)
    else
        exports["soe-ui"]:SendAlert("error", "You cannot prospect here", 4000)
    end
end)
