-- SCUBA VARIABLES
local tank, mask
local scuba = false
local myScubaUID, myScubagear
local scubaAir, progress = 30.0, 100

-- DRAGGING/ESCORTING/CARRYING VARIABLES
local holding, carrying, dragging, escorting, piggybacking

local isHeld = false
local isCarried = false
local isDragged = false
local isEscorted = false
local isPiggybacked = false

local isHoldingNPC = false
local isCarryingNPC = false
local isDraggingNPC = false
local isEscortingNPC = false
local isPiggybackingNPC = false

-- BINOCULARS VARIABLES
local fov_min = 5.0
local fov_max = 70.0
local speed_lr = 8.0
local speed_ud = 8.0
local zoomspeed = 10.0
local usingBinoculars = false
local fov = ((fov_max + fov_min) * 0.5)

-- PUSH VEHICLES VARIABLES
local myPushingAngle = 0.0
local firstDimension = vector3(0.0, 0.0, 0.0)
local secondDimension = vector3(5.0, 5.0, 5.0)
local Vehicle = {Coords = nil, Vehicle = nil, Dimension = nil, IsInFront = false, Distance = nil}

-- ALCOHOL RELATED VARIABLES
alcoholLevel = 0

-- OPEN CONTAINER VARIABLE
local isOpeningContainer = false

-- CRAFT MENU
SOEMenu = assert(MenuV)
isCraftMenuOpen = false
craftPos, craftMenuRadius = 0.0, 1.25
local craftMenuMain = SOEMenu:CreateMenu(false, "Select an item", 'topright', 255, 255, 255, 'size-100', 'default', 'menuv', 'craftMenuMain', 'native')
local isCreatingRecipe = false

DecorRegister("notInteractable", 3)

-- KEY MAPPINGS
RegisterKeyMapping("hold", "Hold Player/NPC", "keyboard", "")
RegisterKeyMapping("drag", "Drag Player/NPC", "keyboard", "")
RegisterKeyMapping("carry", "Carry Player/NPC", "keyboard", "")
RegisterKeyMapping("escort", "Escort Player/NPC", "keyboard", "")
RegisterKeyMapping("binos", "Toggle Binoculars", "keyboard", "HOME")
RegisterKeyMapping("pushveh", "Push Vehicle (HOLD SHIFT AS WELL)", "keyboard", "V")

-- **********************
--    Local Functions
-- **********************
-- REQUIRED FUNCTION FOR BINOCULARS
local function CheckInputRotation(cam, zoomvalue)
    local rotation = GetCamRot(cam, 2)
    local rightAxisX = GetDisabledControlNormal(0, 220)
    local rightAxisY = GetDisabledControlNormal(0, 221)
    if (rightAxisX ~= 0.0 or rightAxisY ~= 0.0) then
        new_z = rotation.z + rightAxisX * -1.0 * (speed_ud) * (zoomvalue + 0.1)
        new_x = math.max(math.min(20.0, rotation.x + rightAxisY * -1.0 * (speed_lr) * (zoomvalue + 0.1)), -89.5)
        SetCamRot(cam, new_x, 0.0, new_z, 2)
    end
end

-- TASKS FOR THE PLAYER TACKLING
local function TacklePeople()
    if exports["soe-emergency"]:IsRestrained() then return end

    local ped = PlayerPedId()
    if IsPedSprinting(ped) and not IsPedInAnyVehicle(ped, true) then
        if exports["soe-utils"]:IsModelADog(ped) then
            SetPedToRagdoll(ped, 200, 50, 0, 1, 1, 0)
            TriggerServerEvent("Civ:Server:TacklePlayers", {status = true})
            return
        end

        exports["soe-utils"]:LoadAnimDict("move_jump", 15)
        TaskPlayAnim(ped, "move_jump", "dive_start_run", 8.0, 1.0, -1, 0, 0, 0, 0, 0)
        Wait(645)

        -- MAKE ANY PLAYER NEAREST TO THIS PLAYER RAGDOLL AS THEY HAVE BEEN TACKLED
        ClearPedSecondaryTask(ped)
        SetPedToRagdoll(ped, 500, 500, 0, 1, 1, 0)
        TriggerServerEvent("Civ:Server:TacklePlayers", {status = true})

        -- THIS CODE BELOWS ALLOWS LOCAL PEDS TO BE TACKLED AS WELL
        local nearbyPeds = {}
        for localPed in exports["soe-utils"]:EnumeratePeds() do
            if #(GetEntityCoords(ped) - GetEntityCoords(localPed)) <= 3.0 and not IsEntityDead(localPed) then
                nearbyPeds[#nearbyPeds + 1] = localPed
            end
        end

        for _, nearbyPed in pairs(nearbyPeds) do
            ClearPedSecondaryTask(nearbyPed)
            SetPedToRagdoll(nearbyPed, 500, 500, 0, 1, 1, 0)
        end
    end
end

-- REQUIRED FUNCTION FOR BINOCULARS
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

-- REQUIRED FUNCTION FOR BINOCULARS
local function HandleZoom(cam)
    local ped = PlayerPedId()
    if not IsPedSittingInAnyVehicle(ped) then
        if IsControlJustPressed(0, 241) then
            fov = math.max(fov - zoomspeed, fov_min)
        end

        if IsControlJustPressed(0, 242) then
            fov = math.min(fov + zoomspeed, fov_max)
        end

        local current_fov = GetCamFov(cam)
        if math.abs(fov - current_fov) < 0.1 then
            fov = current_fov
        end
        SetCamFov(cam, current_fov + (fov - current_fov) * 0.05)
    else
        if IsControlJustPressed(0, 17) then
            fov = math.max(fov - zoomspeed, fov_min)
        end

        if IsControlJustPressed(0, 16) then
            fov = math.min(fov + zoomspeed, fov_max)
        end

        local current_fov = GetCamFov(cam)
        if (math.abs(fov - current_fov) < 0.1) then
            fov = current_fov
        end
        SetCamFov(cam, current_fov + (fov - current_fov) * 0.05)
    end
end

local function HoldNPCs(entity)
    local ped = PlayerPedId()
    if (entity == nil) then
        exports["soe-ui"]:SendAlert("error", "Nobody close enough", 5000)
        return
    end

    if DecorExistOn(entity, "notInteractable") then return end
    if not IsPedHuman(entity) then
        exports["soe-ui"]:SendAlert("error", "You need a human for this", 5000)
        return
    end

    if not isHoldingNPC then
        if (entity ~= nil) and not IsEntityAttachedToAnyPed(entity) then
            -- MAKE SURE THE NEAREST PLAYER ISN'T ALREADY DRAGGING THE NPC
            local closestPlayer = exports["soe-utils"]:GetClosestPlayer(3)
            if (closestPlayer ~= nil) then
                if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "anim@heists@box_carry@", "idle", 3) then
                    exports["soe-ui"]:SendAlert("error", "Somebody is already holding this person!", 4000)
                    return
                end
            end

            -- GAIN CONTROL OF NPC
            isHoldingNPC = true
            exports["soe-utils"]:GetEntityControl(entity)
            SetEntityAsMissionEntity(entity, true, true)

            -- ANIMATION CONTROLLER
            exports["soe-utils"]:LoadAnimDict("anim@heists@box_carry@", 15)
            exports["soe-utils"]:LoadAnimDict("amb@world_human_bum_slumped@male@laying_on_right_side@base", 15)
            TaskPlayAnim(ped, "anim@heists@box_carry@", "idle", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
            TaskPlayAnim(entity, "amb@world_human_bum_slumped@male@laying_on_right_side@base", "base", 3.0, 3.0, -1, 9, 0, 0, 0, 0)

            -- IF NPC IS DEAD, TRY REVIVE
            if IsEntityDead(entity) then
                ResurrectPed(entity)
            end

            while isHoldingNPC do
                Wait(5)
                DisableControlAction(0, 23, true)
                -- ENSURE BOTH PARTIES PLAY THE ANIMATION
                if not IsEntityPlayingAnim(entity, "amb@world_human_bum_slumped@male@laying_on_right_side@base", "base", 3) then
                    TaskPlayAnim(entity, "amb@world_human_bum_slumped@male@laying_on_right_side@base", "base", 3.0, 3.0, -1, 9, 0, 0, 0, 0)
                end

                if not IsEntityPlayingAnim(ped, "anim@heists@box_carry@", "idle", 3) then
                    TaskPlayAnim(ped, "anim@heists@box_carry@", "idle", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
                end

                -- ENSURE PARTIES ARE ATTACHED
                AttachEntityToEntity(entity, ped, GetPedBoneIndex(ped, 57005), -0.32, -0.6, -0.35, 240.0, 35.0, 149.0, 1, 1, 1, 1, 1, 1)
                SetEntityAsNoLongerNeeded(entity)
            end

            DetachEntity(ped, 1, true)
            DetachEntity(entity, 1, true)
        end
    else
        isHoldingNPC = false
        DetachEntity(ped, 1, true)
        DetachEntity(entity, 1, true)
        StopAnimTask(ped, "anim@heists@box_carry@", "idle", 2.0)
        StopAnimTask(entity, "amb@world_human_bum_slumped@male@laying_on_right_side@base", "base", 2.0)
    end
end

local function DragNPCs(entity)
    local ped = PlayerPedId()
    if (entity == nil) then
        exports["soe-ui"]:SendAlert("error", "Nobody close enough", 5000)
        return
    end

    -- MAKE SURE THIS LOCAL ISN'T BLOCKED
    if DecorExistOn(entity, "notInteractable") then return end
    if not IsPedHuman(entity) then
        exports["soe-ui"]:SendAlert("error", "You need a human for this", 5000)
        return
    end

    if not isDraggingNPC then
        if (entity ~= nil) and not IsEntityAttachedToAnyPed(entity) then
            -- MAKE SURE THE NEAREST PLAYER ISN'T ALREADY DRAGGING THE NPC
            local closestPlayer = exports["soe-utils"]:GetClosestPlayer(3)
            if (closestPlayer ~= nil) then
                if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "combat@drag_ped@", "injured_drag_plyr", 3) then
                    exports["soe-ui"]:SendAlert("error", "Somebody is already dragging this person!", 4000)
                    return
                end
            end

            -- GAIN CONTROL OF NPC
            isDraggingNPC = true
            exports["soe-utils"]:GetEntityControl(entity)
            SetEntityAsMissionEntity(entity, true, true)

            -- ANIMATION CONTROLLER
            exports["soe-utils"]:LoadAnimDict("combat@drag_ped@", 15)
            TaskPlayAnim(ped, "combat@drag_ped@", "injured_drag_plyr", 8.0, -8, -1, 33, 0, 0, 0, 0)
            TaskPlayAnim(entity, "combat@drag_ped@", "injured_drag_ped", 8.0, -8, -1, 33, 0, 0, 0, 0)

            -- IF NPC IS DEAD, TRY REVIVE
            if IsEntityDead(entity) then
                ResurrectPed(entity)
            end

            while isDraggingNPC do
                Wait(5)
                DisableControlAction(0, 23, true)
                -- ENSURE BOTH PARTIES PLAY THE ANIMATION
                if not IsEntityPlayingAnim(entity, "combat@drag_ped@", "injured_drag_ped", 3) then
                    TaskPlayAnim(entity, "combat@drag_ped@", "injured_drag_ped", 8.0, -8, -1, 33, 0, 0, 0, 0)
                end

                if not IsEntityPlayingAnim(ped, "combat@drag_ped@", "injured_drag_plyr", 3) then
                    TaskPlayAnim(ped, "combat@drag_ped@", "injured_drag_plyr", 8.0, -8, -1, 33, 0, 0, 0, 0)
                end

                -- ENSURE PARTIES ARE ATTACHED
                AttachEntityToEntity(entity, ped, 11816, 4103, 0.48, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 1, 1, 0, 2, 1)
                SetEntityAsNoLongerNeeded(entity)
            end

            DetachEntity(ped, 1, true)
            DetachEntity(entity, 1, true)
        end
    else
        isDraggingNPC = false
        DetachEntity(ped, 1, true)
        DetachEntity(entity, 1, true)
        StopAnimTask(ped, "combat@drag_ped@", "injured_drag_plyr", 2.0)
        StopAnimTask(entity, "combat@drag_ped@", "injured_drag_ped", 2.0)
    end
end

local function EscortNPCs(entity)
    local ped = PlayerPedId()
    if (entity == nil) then
        exports["soe-ui"]:SendAlert("error", "Nobody close enough", 5000)
        return
    end

    if DecorExistOn(entity, "notInteractable") then return end
    if not isEscortingNPC then
        if (entity ~= nil) and not IsEntityAttachedToAnyPed(entity) then
            -- GAIN CONTROL OF NPC
            isEscortingNPC = true
            exports["soe-utils"]:GetEntityControl(entity)
            SetEntityAsMissionEntity(entity, true, true)

            -- IF NPC IS DEAD, TRY REVIVE
            if IsEntityDead(entity) then
                ResurrectPed(entity)
            end

            while isEscortingNPC do
                Wait(5)
                DisableControlAction(0, 23, true)
                -- ENSURE PARTIES ARE ATTACHED
                AttachEntityToEntity(entity, ped, 11816, 0.45, 0.45, 0.0, 0.0, 0.0, 0.0, 0, 1, 1, 0, 2, 1)
                SetEntityAsNoLongerNeeded(entity)
            end

            DetachEntity(ped, 1, true)
            DetachEntity(entity, 1, true)
        end
    else
        isEscortingNPC = false
        DetachEntity(ped, 1, true)
        DetachEntity(entity, 1, true)
    end
end

local function CarryNPCs(entity)
    local ped = PlayerPedId()
    if (entity == nil) then
        exports["soe-ui"]:SendAlert("error", "Nobody close enough", 5000)
        return
    end

    if DecorExistOn(entity, "notInteractable") then return end
    if not isCarryingNPC then
        if (entity ~= nil) and not IsEntityAttachedToAnyPed(entity) then
            -- MAKE SURE THE NEAREST PLAYER ISN'T ALREADY CARRYING THE NPC
            local closestPlayer = exports["soe-utils"]:GetClosestPlayer(3)
            if (closestPlayer ~= nil) then
                if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 3) then
                    exports["soe-ui"]:SendAlert("error", "Somebody is already carrying this person!", 4000)
                    return
                end
            end

            -- GAIN CONTROL OF NPC
            isCarryingNPC = true
            exports["soe-utils"]:GetEntityControl(entity)
            SetEntityAsMissionEntity(entity, true, true)

            -- ANIMATION CONTROLLER
            exports["soe-utils"]:LoadAnimDict("nm", 15)
            exports["soe-utils"]:LoadAnimDict("missfinale_c2mcs_1", 15)
            TaskPlayAnim(entity, "nm", "firemans_carry", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
            TaskPlayAnim(ped, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 1.0, 1.0, -1, 49, 0, 0, 0, 0)

            -- IF NPC IS DEAD, TRY REVIVE
            if IsEntityDead(entity) then
                ResurrectPed(entity)
            end

            while isCarryingNPC do
                Wait(5)
                DisableControlAction(0, 23, true)
                -- ENSURE BOTH PARTIES PLAY THE ANIMATION
                if not IsEntityPlayingAnim(entity, "nm", "firemans_carry", 3) then
                    TaskPlayAnim(entity, "nm", "firemans_carry", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
                end

                if not IsEntityPlayingAnim(ped, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 3) then
                    TaskPlayAnim(ped, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 1.0, 1.0, -1, 49, 0, 0, 0, 0)
                end

                -- ENSURE PARTIES ARE ATTACHED
                AttachEntityToEntity(entity, ped, 0, 0.2, 0.2, 0.5, 0.0, 0.0, 0.0, 1, 1, 1, 1, 1, 1)
                SetEntityAsNoLongerNeeded(entity)
            end

            DetachEntity(ped, 1, true)
            DetachEntity(entity, 1, true)
        end
    else
        isCarryingNPC = false
        DetachEntity(ped, 1, true)
        DetachEntity(entity, 1, true)
        StopAnimTask(ped, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 2.0)
        StopAnimTask(entity, "nm", "firemans_carry", 2.0)
    end
end

local function PiggybackNPCs(entity)
    local ped = PlayerPedId()
    if (entity == nil) then
        exports["soe-ui"]:SendAlert("error", "Nobody close enough", 5000)
        return
    end

    if DecorExistOn(entity, "notInteractable") then return end
    if not IsPedHuman(entity) then
        exports["soe-ui"]:SendAlert("error", "You need a human for this", 5000)
        return
    end

    if not isPiggybackingNPC then
        if (entity ~= nil) and not IsEntityAttachedToAnyPed(entity) then
            -- MAKE SURE THE NEAREST PLAYER ISN'T ALREADY PIGGYBACK RIDING THE NPC
            local closestPlayer = exports["soe-utils"]:GetClosestPlayer(3)
            if (closestPlayer ~= nil) then
                if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "anim@arena@celeb@flat@paired@no_props@", "piggyback_c_player_a", 3) then
                    exports["soe-ui"]:SendAlert("error", "Somebody is already piggyback riding this person!", 4000)
                    return
                end
            end

            -- GAIN CONTROL OF NPC
            isPiggybackingNPC = true
            exports["soe-utils"]:GetEntityControl(entity)
            SetEntityAsMissionEntity(entity, true, true)

            -- ANIMATION CONTROLLER
            exports["soe-utils"]:LoadAnimDict("anim@arena@celeb@flat@paired@no_props@", 15)
            TaskPlayAnim(entity, "anim@arena@celeb@flat@paired@no_props@", "piggyback_c_player_b", 8.0, -8.0, -1, 1, 0, 0, 0, 0)
            TaskPlayAnim(ped, "anim@arena@celeb@flat@paired@no_props@", "piggyback_c_player_a", 8.0, -8.0, -1, 49, 0, 0, 0, 0)

            -- IF NPC IS DEAD, TRY REVIVE
            if IsEntityDead(entity) then
                ResurrectPed(entity)
            end

            while isPiggybackingNPC do
                Wait(5)
                DisableControlAction(0, 23, true)
                -- ENSURE BOTH PARTIES PLAY THE ANIMATION
                if not IsEntityPlayingAnim(entity, "anim@arena@celeb@flat@paired@no_props@", "piggyback_c_player_b", 3) then
                    TaskPlayAnim(entity, "anim@arena@celeb@flat@paired@no_props@", "piggyback_c_player_b", 8.0, -8.0, -1, 1, 0, 0, 0, 0)
                end

                if not IsEntityPlayingAnim(ped, "anim@arena@celeb@flat@paired@no_props@", "piggyback_c_player_a", 3) then
                    TaskPlayAnim(ped, "anim@arena@celeb@flat@paired@no_props@", "piggyback_c_player_a", 8.0, -8.0, -1, 49, 0, 0, 0, 0)
                end

                -- ENSURE PARTIES ARE ATTACHED
                AttachEntityToEntity(entity, ped, 0, 0.0, -0.07, 0.45, 0.5, 0.5, 0.0, 0, 0, 1, 1, 2, 0)
                SetEntityAsNoLongerNeeded(entity)
            end

            DetachEntity(ped, 1, true)
            DetachEntity(entity, 1, true)
        end
    else
        isPiggybackingNPC = false
        DetachEntity(ped, 1, true)
        DetachEntity(entity, 1, true)
        StopAnimTask(ped, "anim@arena@celeb@flat@paired@no_props@", "piggyback_c_player_a", 2.0)
        StopAnimTask(entity, "anim@arena@celeb@flat@paired@no_props@", "piggyback_c_player_b", 2.0)
    end
end

local function PushVehicle()
    if IsControlPressed(0, 21) then
        if exports["soe-emergency"]:IsRestrained() then
            return
        end

        local ped = PlayerPedId()
        local isBeingPushed = false
        local pos = GetEntityCoords(ped)
        local veh = exports["soe-utils"]:GetVehInFrontOfPlayer(4.0)
        local model = GetEntityModel(veh)
        local class = {isNotACar = IsThisModelAHeli(model) or IsThisModelAPlane(model) or IsThisModelATrain(model) or IsThisModelABicycle(model) or IsThisModelABoat(model)}

        local vPos = GetEntityCoords(veh)
        local vDist = GetDistanceBetweenCoords(vPos, pos, false)
        local vDimensions = GetModelDimensions(GetEntityModel(veh), firstDimension, secondDimension)
        if vDist < 6.0 and not IsPedInAnyVehicle(ped, false) and not IsVehicleTyreBurst(veh, 0, true) and IsVehicleOnAllWheels(veh, true) and IsVehicleSeatFree(veh, -1) and not IsEntityAttachedToEntity(ped, veh) and not class.isNotACar then
            local closestPlayer = exports["soe-utils"]:GetClosestPlayer(3)
            if (closestPlayer ~= nil) then
                if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "missfinale_c2ig_11", "pushcar_offcliff_m", 3) then
                    exports["soe-ui"]:SendAlert("error", "Somebody is already pushing this vehicle!", 4000)
                    isBeingPushed = true
                end
            end

            if not isBeingPushed then
                Vehicle.Coords = vPos
                Vehicle.Vehicle = veh
                Vehicle.Distance = vDist
                Vehicle.Dimensions = vDimensions
                if GetDistanceBetweenCoords(GetEntityCoords(veh) + GetEntityForwardVector(veh), GetEntityCoords(ped, true)) > GetDistanceBetweenCoords(GetEntityCoords(veh) + GetEntityForwardVector(veh) * -1, GetEntityCoords(ped, true)) then
                    Vehicle.IsInFront = false
                else
                    Vehicle.IsInFront = true
                end
                Wait(500)

                exports["soe-utils"]:GetEntityControl(Vehicle.Vehicle)
                if Vehicle.IsInFront then
                    AttachEntityToEntity(ped, Vehicle.Vehicle, GetPedBoneIndex(6286), 0.0, Vehicle.Dimensions.y * -1 + 0.1, Vehicle.Dimensions.z + 1.0, 0.0, 0.0, 180.0, 0.0, 0, 0, 1, 0, 1)
                else
                    AttachEntityToEntity(ped, Vehicle.Vehicle, GetPedBoneIndex(6286), 0.0, Vehicle.Dimensions.y - 0.3, Vehicle.Dimensions.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 1, 0, 1)
                end

                exports["soe-utils"]:LoadAnimDict("missfinale_c2ig_11", 15)
                TaskPlayAnim(ped, "missfinale_c2ig_11", "pushcar_offcliff_m", 2.0, -8.0, -1, 35, 0, 0, 0, 0)

                Wait(200)
                while IsDisabledControlPressed(0, 21) do
                    Wait(5)

                    local pedPitch = GetEntityPitch(ped)
                    local pitch = GetEntityPitch(Vehicle.Vehicle)
                    exports["soe-ui"]:PersistentAlert("end", "pitch")
                    if (pedPitch >= 8.5) then
                        exports["soe-ui"]:PersistentAlert("start", "pitch", "error", "Angle too steep!", 4000)
                        exports["soe-ui"]:PersistentAlert("end", "pitch")
                        break
                    end

                    local speed = GetFrameTime() * 50
                    if IsDisabledControlPressed(0, 34) then
                        SetVehicleSteeringAngle(Vehicle.Vehicle, myPushingAngle)
                        myPushingAngle = myPushingAngle + speed
                    elseif IsDisabledControlPressed(0, 35) then
                        SetVehicleSteeringAngle(Vehicle.Vehicle, myPushingAngle)
                        myPushingAngle = myPushingAngle - speed
                    else
                        -- SLOWLY RESOTRE TO CENTER
                        SetVehicleSteeringAngle(Vehicle.Vehicle, myPushingAngle)
                        if myPushingAngle < -0.02 then
                            myPushingAngle = myPushingAngle + speed
                        elseif myPushingAngle > 0.02 then
                            myPushingAngle = myPushingAngle - speed
                        else
                            myPushingAngle = 0.0
                        end
                    end

                    -- CLAMP THE VALUES BETWEEN -15 AND 15
                    if (myPushingAngle > 15.0) then
                        myPushingAngle = 15.0
                    elseif (myPushingAngle < -15.0) then
                        myPushingAngle = -15.0
                    end

                    if Vehicle.IsInFront then
                        SetVehicleForwardSpeed(Vehicle.Vehicle, -1.0)
                    else
                        SetVehicleForwardSpeed(Vehicle.Vehicle, 1.0)
                    end

                    if HasEntityCollidedWithAnything(Vehicle.Vehicle) then
                        SetVehicleOnGroundProperly(Vehicle.Vehicle)
                    end
                end

                DetachEntity(ped, false, false)
                StopAnimTask(ped, "missfinale_c2ig_11", "pushcar_offcliff_m", 2.0)
                FreezeEntityPosition(ped, false)
            end
        elseif IsVehicleOnAllWheels(veh, true) then
            exports["soe-ui"]:SendAlert("error", "Vehicle must be on all 4 tires!", 4000)
        else
            local veh = exports["soe-utils"]:GetVehInFrontOfPlayer(4.0)
            if veh ~= nil then
                exports["soe-ui"]:SendAlert("error", "You can only push vehicles!", 4000)
            end
            Vehicle = {Coords = nil, Vehicle = nil, Dimensions = nil, IsInFront = false, Distance = nil}
        end
    end
end

local function OpenContainer(containerData)
    -- CHECK IF PLAYER HAS A CROWBAR
    if containerData.requiresCrowbar and not exports["soe-inventory"]:HasInventoryItem("WEAPON_CROWBAR") then
        exports["soe-ui"]:SendAlert("error", "You need a crowbar to open this container!", 4000)
        return
    end

    -- EXIT IF PLAYER IS ALREADY OPENING A CONTAINER
    if isOpeningContainer then
        exports["soe-ui"]:SendAlert("error", "You are already opening a container!", 4000)
        return
    end

    -- SET HOW LONG IT TAKES TO OPEN THE CONTAINER IF NOT DEFINED
    if containerData.duration == nil then
        duration = 25000
    else
        duration = containerData.duration
    end

    -- DETERMINE WHETHER THE CONTENTS CAN BE DAMAGED
    if containerData.canDamage == nil then
        canDamage = true
    end

    -- DETERMINE WHETHER PLAYER NEEDS TO DO SKILL CHECK MINIGAME
    if containerData.requiresSkill == nil then
        requiresSkill = true
    end

    -- DO OPENING CONTAINER STUFF HERE
    isOpeningContainer = true
    exports["soe-utils"]:Progress(
        {
            name = "openingContainer",
            duration = duration,
            label = ("Opening %s"):format(containerData.containerName),
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
            },
            animation = {
                animDict = "mp_arresting",
                anim = "a_uncuff",
                flags = 49
            }
        },
        function(cancelled)
            if not cancelled then
                local quantity = containerData.maxQuantity
                local damagedQuantity = 0

                -- SKILLBAR MINIGAME
                if containerData.requiresSkill then
                    if not exports["soe-challenge"]:Skillbar(5000, 10) and containerData.canDamage then
                        --print("FAILED")
                        damagedQuantity = tonumber(string.format("%." .. (0) .. "f", containerData.maxQuantity * 0.25))
                        quantity = containerData.maxQuantity - damagedQuantity
                    end
                end

                -- OPEN CONTAINER SERVER SIDE TO GIVE ITEMS
                print(containerData.item, containerData.maxQuantity, quantity, damagedQuantity, containerData.containerItem, containerData.containerName, duration)
                TriggerServerEvent("Civ:Server:OpenContainer", {status = true, item = containerData.item, quantity = quantity, damagedQuantity = damagedQuantity, containerItem = containerData.containerItem, containerName = containerData.containerName})
            end
            -- ALLOW PLAYER TO OPEN ANOTHER CONTAINER
            isOpeningContainer = false
        end
    )
end

local function ActionThread()
    CreateThread(function()
        while holding or carrying or dragging or escorting or piggybacking or isHoldingNPC or isCarryingNPC or isDraggingNPC or isEscortingNPC or isPiggybackingNPC do
            Wait(1750)
            -- VEHICLE DRIVER CHECK WHILE
            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped, false) then
                local pedVehicle = GetVehiclePedIsIn(ped, false)
                if GetPedInVehicleSeat(pedVehicle, -1) == ped then
                    if holding or carrying or dragging or escorting or piggybacking then
                        exports["soe-ui"]:SendUniqueAlert("cannotDrive", "warning", "You cannot drive while doing this action.", 4000)
                    end
                    TaskLeaveVehicle(ped, pedVehicle, 256)
                end
            end
        end
    end)
end

local function closeMenus()
    craftMenuMain:ClearItems()
    SOEMenu:CloseAll()
    isCraftMenuOpen = false
end

local function CreateRecipe(recipeData)
    -- EXIT IF PLAYER IS ALREADY CREATING A RECIPE
    if isCreatingRecipe then
        exports["soe-ui"]:SendAlert("error", "You are already making something!", 4000)
        return
    end

    -- SET HOW LONG IT TAKES TO CREATE THE RECIPE IF NOT DEFINED
    if recipeData.duration == nil then
        duration = 25000
    else
        duration = recipeData.duration
    end

    -- DO CREATING RECIPE STUFF HERE
    isCreatingRecipe = true
    exports["soe-utils"]:Progress(
        {
            name = "creatingRecipe",
            duration = duration,
            label = ("Making %s"):format(recipeData.itemDisplayName),
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
            },
            animation = {
                animDict = "mp_arresting",
                anim = "a_uncuff",
                flags = 49
            }
        },
        function(cancelled)
            if not cancelled then
                -- OPEN CONTAINER SERVER SIDE TO GIVE ITEMS
                --print(recipeData.item, recipeData.itemDisplayName, recipeData.amount, recipeData.containerItem, recipeData.containerName, duration)
                TriggerServerEvent("Jobs:Server:CreateRecipe", {status = true, item = recipeData.item, amount = recipeData.amount, containerItem = recipeData.containerItem, recipeIngredients = recipeData.recipeIngredients, craft = recipeData.craft})
            end
            -- ALLOW PLAYER TO CREATE ANOTER RECIPE
            isCreatingRecipe = false
        end
    )

end

-- JOB INTERACTION MENU
local function CraftInteractionMenu(craftData, pos)
    -- RESET THE MENU
    craftMenuMain:ClearItems()
    craftMenuMain:SetTitle(craftData.name)

    -- SET THE POS FOR RUNTIME TO CLOSE MENU IF TOO FAR
    craftPos = pos

    -- ADD CRAFT ITEMS AND DISPLAY MENU
    for buttonIndex, recipe in pairs(craftData.recipes) do
        local buttonIndex = craftMenuMain:AddButton({ icon = recipe.itemIcon, label = recipe.name, select = function()
            -- CHECK FOR MISSING ITEMS
            local missingItems, recipeIngredients = {}, recipe.ingredients
            for _, data in pairs(recipe.ingredients) do
                local haveAmount = exports["soe-inventory"]:HasInventoryItemByAmt(data.itemName)
                if haveAmount < data.requiredAmount then
                    missingItems[#missingItems + 1] = {name = data.itemDisplayName, amount = data.requiredAmount - haveAmount}
                end
            end

            -- CONTINUE TO CRAFT IF NO MISSING ITEMS ELSE DISPLAY WHAT ITEMS ARE MISSING AND AMOUNT
            if #missingItems == 0 then
                local recipeData = {
                    item = recipe.itemName,
                    itemDisplayName = recipe.itemDisplayName,
                    amount = recipe.amount,
                    duration = recipe.craftTime,
                    recipeIngredients = recipeIngredients,
                    craft = true,
                }
                CreateRecipe(recipeData)
            elseif #missingItems > 1 then
                exports["soe-ui"]:SendAlert("error", "You are missing some items to make this", 9000)
                local missingString = ("%s x%s"):format(missingItems[1].name, missingItems[1].amount)
                for index = 2, #missingItems do
                    missingString = ("%s, %s x%s"):format(missingString, missingItems[index].name, missingItems[index].amount)
                end
                TriggerEvent("Chat:Client:Message", ("[%s]"):format(craftData.name), ("Missing: %s"):format(missingString), "taxi")
            elseif #missingItems == 1 then
                exports["soe-ui"]:SendAlert("error", "You are missing an item to make this", 9000)
                local missingString = ("%s x%s"):format(missingItems[1].name, missingItems[1].amount)
                TriggerEvent("Chat:Client:Message", ("[%s]"):format(craftData.name), ("Missing: %s"):format(missingString), "taxi")
            end

            -- CLOSE THE MENU
            closeMenus()
        end})
    end

    -- OPEN MENU AND FREEZE PLAYER/CONTROLS
    craftMenuMain:Open()
    isCraftMenuOpen = true
    while isCraftMenuOpen do
        Wait(5)
        DisableControlAction(0, 23)
        DisableControlAction(0, 75)
    end
end

local function UseCampFire()
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
        return
    end

    local playerCoords = GetEntityCoords(PlayerPedId())
    CraftInteractionMenu(craft.campFire, playerCoords)
end

-- **********************
--    Global Functions
-- **********************
function IsHeld()
    return isHeld
end

function IsDragged()
    return isDragged
end

function IsEscorted()
    return isEscorted
end

function IsCarried()
    return isCarried
end

function IsHolding()
    return holding
end

function IsDragging()
    return dragging
end

function IsEscorting()
    return escorting
end

function IsCarrying()
    return carrying
end

function SetHoldingState(state)
    holding = state
end

function SetDraggingState(state)
    dragging = state
end

function SetEscortingState(state)
    escorting = state
end

function SetCarryingState(state)
    carrying = state
end

function IsRestrained()
    if isHeld then
        return true
    elseif isDragged then
        return true
    elseif isEscorted then
        return true
    elseif isPiggybacked then
        return true
    elseif isCarried then
        return true
    end
    return false
end

function UseBinoculars()
    -- DENY USAGE IF HANDCUFFED
    if exports["soe-emergency"]:IsRestrained() then
        return
    end

    if not usingBinoculars and exports["soe-inventory"]:HasInventoryItem("binos") then
        local ped = PlayerPedId()
        exports["soe-utils"]:LoadAnimDict("amb@lo_res_idles@", 15)
        TaskPlayAnim(ped, "amb@lo_res_idles@", "world_human_binoculars_lo_res_base", 1.0, 1.0, -1, 49, 0, 0, 0, 0)

        -- TODO:
        -- ADD THE BINOCULARS PROP FOR THE PLAYER TO HOLD ~ Ghost 12/1/2020

        SetTimecycleModifier("default")
        SetTimecycleModifierStrength(0.3)
        usingBinoculars = true

        local scaleform = RequestScaleformMovie("BINOCULARS")
        while not HasScaleformMovieLoaded(scaleform) do
            Wait(15)
        end

        Wait(2000)
        SetTimecycleModifier("default")
        SetTimecycleModifierStrength(0.3)
        local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
        AttachCamToEntity(cam, ped, 0.0, 0.0, 1.0, true)
        SetCamRot(cam, 0.0, 0.0, GetEntityHeading(ped))
        SetCamFov(cam, fov)
        RenderScriptCams(true, false, 0, 1, 0)

        while usingBinoculars and not IsEntityDead(ped) do
            local zoomvalue = (1.0 / (fov_max - fov_min)) * (fov - fov_min)
            CheckInputRotation(cam, zoomvalue)
            HandleZoom(cam)
            HideHUDThisFrame()
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
            Wait(6)
        end

        ClearTimecycleModifier()
        fov = (fov_max + fov_min) * 0.5
        RenderScriptCams(false, false, 0, 1, 0)
        SetScaleformMovieAsNoLongerNeeded(scaleform)
        DestroyCam(cam, false)
        SetNightvision(false)
        SetSeethrough(false)
        ClearPedTasks(ped)
    else
        usingBinoculars = false
    end
end

-- KITTY LITTER
function UseKittyLitter()
    exports["soe-utils"]:Progress(
        {
            name = "usingKittyLitter",
            duration = 5500,
            label = "Pouring Kitty Litter",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = false,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
            },
            animation = {
                animDict = "weapon@w_sp_jerrycan",
                anim = "fire",
                flags = 49
            }
        },
        function(cancelled)
            if not cancelled then
                TriggerServerEvent("Civ:Server:KittyLitter")
            end
        end
    )
end

function UseScuba(type, uid, skipTimer)
    local ped = PlayerPedId()
    if not scuba and type ~= 0 then
        local scubagearItem = "scubagear"
        if type == "MkII" then
            scubagearItem = "scubagearmkii"
        end

        -- CHECK IF PLAYER IS IN WATER PRIOR TO EQUIPPING
        local isSwimming = IsPedSwimming(ped)
        local isUnderwater = IsPedSwimmingUnderWater(ped)

        if isUnderwater or isSwimming then
            exports["soe-ui"]:SendAlert("error", "You cannot put on scuba gear while in the water", 5000)
            return
        end

        -- PROGRESS BAR FOR EQUIPPING
        exports["soe-utils"]:Progress(
            {
                name = "equipScubaGear",
                duration = 5000,
                label = "Equipping Scuba Gear",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true
                },
                animation = {
                    animDict = "clothingshirt",
                    anim = "try_shirt_positive_d",
                    flags = 49
                }
            },
            function(cancelled)
                if not cancelled then
                    -- CHECK IF PLAYER STILL HAS THE SCUBAGEAR
                    --print("scubagearItem", scubagearItem)
                    local scubagears = exports["soe-inventory"]:GetItemData(scubagearItem, "left")
                    for scubagearUID, scubagearData in pairs(scubagears) do
                        if tonumber(scubagearUID) == tonumber(uid) then
                            myScubagear = scubagearData
                            myScubaUID = uid
                        end
                    end

                    --[[print("myScubagear", myScubagear)
                    print("myScubaUID", myScubaUID)]]

                    if myScubagear == nil or myScubagear == 0 then
                        exports["soe-ui"]:SendAlert("error", "Scubagear missing", 5000)
                        return
                    end

                    local name = exports["soe-chat"]:GetDisplayName()
                    TriggerServerEvent("Chat:Server:ProximityMsg", 10.0, "me", "", name, "equips their scuba gear.")

                    -- UPDATE THE ITEM WITH NEW META DATA
                    local itemMeta = json.decode(myScubagear.ItemMeta)
                    itemMeta.equipped = true
                    TriggerServerEvent("Inventory:Server:EditItemMeta", myScubaUID, itemMeta)

                    -- MASK/TANK MODEL
                    local tankModel = "p_michael_scuba_tank_s"
                    local maskModel = "p_michael_scuba_mask_s"
                    local pedModelDimMin, pedModelDimMax = GetModelDimensions(GetEntityModel(ped))

                    local xOffset = -0.2775
                    local yOffset = -(pedModelDimMax.y / 2.0) - 0.0885

                    if (type == "MkII") then
                        tankModel = "p_s_scuba_tank_s"
                        maskModel = "p_s_scuba_mask_s"
                        xOffset = -0.27
                        yOffset = -(pedModelDimMax.y / 2.0) - 0.11
                    end

                    exports["soe-utils"]:LoadModel(tankModel, 15)
                    exports["soe-utils"]:LoadModel(maskModel, 15)
                    tank = CreateObjectNoOffset(tankModel, 0.0, 0.0, 0.0, true, true, false)
                    mask = CreateObjectNoOffset(maskModel, 0.0, 0.0, 0.0, true, true, false)

                    AttachEntityToEntity(tank, ped, GetPedBoneIndex(ped, 24818), xOffset, yOffset, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 1, 2, 1)

                    -- IF THE UPPER LIP BONE EXISTS, ATTACH IT THERE, ELSE ATTEMPT TO USE THE HEAD BONE
                    if (GetPedBoneIndex(playerPed, 20178) ~= -1) then
                        AttachEntityToEntity(mask, ped, GetPedBoneIndex(ped, 20178), -0.065, 0.0, 0.015, 0.0, 0.0, 90.0, 1, 1, 0, 1, 2, 1)
                    else
                        AttachEntityToEntity(mask, ped, GetPedBoneIndex(ped, 31086), 0.01, -0.02, 0.005, 180.0, 90.0, 0.0, 1, 1, 0, 1, 2, 1)
                    end

                    -- SET SCUBA FLAG AND UNDERWATER TIME
                    scuba = true

                    -- GET UPDATED DATA
                    local scubagears = exports["soe-inventory"]:GetItemData(scubagearItem, "left")
                    for scubagearUID, scubagearData in pairs(scubagears) do
                        if tonumber(scubagearUID) == tonumber(uid) then
                            myScubagear = scubagearData
                            myScubaUID = uid
                        end
                    end

                    itemMeta = json.decode(myScubagear.ItemMeta)
                    -- SET THE SCUBA AIR REMAINING TO THE VALUE FROM THE ITEM
                    --[[print("itemMeta.loopTime", itemMeta.loopTime)
                    print("itemMeta.progress", itemMeta.progress)
                    print("itemMeta.remaining", itemMeta.remaining)
                    print("itemMeta.equipped", itemMeta.equipped)]]

                    local loopTime = itemMeta.loopTime
                    progress = itemMeta.progress
                    scubaAir = itemMeta.remaining
                    itemMeta.equipped = true

                    -- SAFEGUARD INCASE THE ITEM DOESN'T HAVE METADATA
                    if loopTime == nil then
                        if scubagearItem == "scubagearmkii" then
                            loopTime = 6000.0
                        else
                            loopTime = 3000
                        end
                    end
                    if progress == nil then
                        progress = 100
                    end
                    if scubaAir == nil then
                        if scubagearItem == "scubagearmkii" then
                            scubaAir = 600.0
                        else
                            scubaAir = 300.0
                        end
                    end

                    -- SET THE AIR
                    SetPedMaxTimeUnderwater(ped, scubaAir)

                    -- SET NUI PROPERTIES AND DATA
                    SendNUIMessage({type = "toggleScubaUI", bool = true})
                    SendNUIMessage({type = "setScubaStatus", percent = math.abs(progress - 100)})

                    while scuba do
                        Wait(loopTime)
                        if scuba then
                            -- CHECK IF PLAYER STILL HAS THE EQUIPPED SCUBA GEAR
                            local itemCheck = false
                            local scubagears = exports["soe-inventory"]:GetItemData(scubagearItem, "left")
                            for scubagearUID, scubagearData in pairs(scubagears) do
                                if tonumber(scubagearUID) == tonumber(uid) then
                                    itemCheck = true
                                end
                            end

                            if not itemCheck then
                                exports["soe-ui"]:SendAlert("error", "Scubagear missing", 5000)
                                UseScuba(type, uid, true)
                                return
                            end

                            if IsPedSwimmingUnderWater(ped) then
                                SendNUIMessage({type = "setScubaStatus", percent = math.abs(progress - 100)})
                                progress = progress - 1
                                scubaAir = scubaAir - (loopTime/1000)

                                --[[print("progress", progress)
                                print("scubaAir", scubaAir)
                                print("itemMeta.equipped", itemMeta.equipped)]]

                                -- UPDATE THE ITEM WITH NEW META DATA
                                local itemMeta = json.decode(myScubagear.ItemMeta)
                                itemMeta.remaining = scubaAir
                                itemMeta.progress = progress
                                TriggerServerEvent("Inventory:Server:EditItemMeta", myScubaUID, itemMeta)

                                if (progress < 0) then
                                    SetPedMaxTimeUnderwater(ped, 30.0)
                                    break
                                end
                            end
                        end
                    end
                end
            end
        )
    elseif scuba and myScubaUID == uid then
        local duration = 5000
        if skipTimer then
            duration = 0
        end
        exports["soe-utils"]:Progress(
            {
                name = "removeScubaGear",
                duration = duration,
                label = "Removing Scuba Gear",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true
                },
                animation = {
                    animDict = "clothingshirt",
                    anim = "try_shirt_positive_d",
                    flags = 49
                }
            },
            function(cancelled)
                if not cancelled then
                    local name = exports["soe-chat"]:GetDisplayName()
                    TriggerServerEvent("Chat:Server:ProximityMsg", 10.0, "me", "", name, "removes their scuba gear.")

                    exports["soe-utils"]:GetEntityControl(mask)
                    exports["soe-utils"]:GetEntityControl(tank)
                    DeleteObject(mask)
                    DeleteObject(tank)

                    -- UPDATE THE ITEM WITH NEW META DATA
                    local itemMeta = json.decode(myScubagear.ItemMeta)
                    itemMeta.remaining = scubaAir
                    itemMeta.progress = progress
                    itemMeta.equipped = false
                    TriggerServerEvent("Inventory:Server:EditItemMeta", myScubaUID, itemMeta)

                    -- RESET VARIABLES
                    scuba = false
                    scubaAir = 30.0
                    progress = 100
                    myScubagear = nil
                    myScubaUID = nil
                    SetPedMaxTimeUnderwater(ped, 30.0)
                    SendNUIMessage({type = "toggleScubaUI", bool = false})
                end
            end
        )
    else
        exports["soe-ui"]:SendAlert("error", "You already have scuba gear on!", 5000)
    end
end

-- BREATHALYZER
function UseBreathalyzer()
    local player = exports["soe-utils"]:GetClosestPlayer(5)
    if (player ~= nil) then
        exports["soe-utils"]:Progress(
            {
                name = "breathalyzing",
                duration = 6500,
                label = "Breathalyzing",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = false
                },
                animation = {
                    animDict = "weapons@first_person@aim_rng@generic@projectile@shared@core",
                    anim = "idlerng_med",
                    flags = 49
                }
            },
            function(cancelled)
                if not cancelled then
                    TriggerServerEvent("Civ:Server:Breathalyze", GetPlayerServerId(player))
                end
            end
        )
    else
        exports["soe-ui"]:SendAlert("error", "Nobody close enough", 5000)
    end
end

function SetAlcoholLevel(level)
    -- SET ALCOHOL LEVEL
    alcoholLevel = alcoholLevel + level
    if (alcoholLevel > 100) then
        alcoholLevel = 100
    elseif (alcoholLevel < 0) then
        alcoholLevel = 0
    elseif (alcoholLevel > 10) then
        StartScreenEffect("MenuMGSelectionTint", 3600000, false)
    end

    -- SET SOME GAMEPLAY ALTERING EFFECTS
    SetGameplayCamShakeAmplitude(alcoholLevel / 10)
    ShakeGameplayCam("DRUNK_SHAKE", (alcoholLevel / 10))

    local ped = PlayerPedId()
    if (alcoholLevel >= 60) then
        SetPedMovementClipset(ped, "move_m@drunk@verydrunk", 0.0)
        SetPedStrafeClipset(ped, "move_strafe@first_person@drunk")
    elseif (alcoholLevel > 20) then
        SetPedMovementClipset(ped, "move_m@drunk@moderatedrunk", 0.0)
        SetPedStrafeClipset(ped, "move_strafe@first_person@drunk")
    elseif (alcoholLevel < 10 and alcoholLevel ~= 0) then
        StopScreenEffect("MenuMGSelectionTint")
    elseif (alcoholLevel == 0) then
        StopGameplayCamShaking(true)
        ResetPedMovementClipset(ped)
        ResetPedStrafeClipset(ped)
        StopScreenEffect("MenuMGSelectionTint")
    else
        SetPedMovementClipset(ped, "move_m@drunk@slightlydrunk", 0.0)
        SetPedStrafeClipset(ped, "move_strafe@first_person@drunk")
    end
end

function UseMeasuringTape()
    local pointA, pointB
    local measuring = true
    while measuring do
        Wait(5)
        local ray = exports["soe-utils"]:Raycast(100)
        DrawMarker(21, ray.HitPosition.x, ray.HitPosition.y, (ray.HitPosition.z + 0.5), 0.0, 0.0, 0.0, 180.0, 0.0, 180.0, 0.71, 0.71, 0.71, 102, 24, 13, 125, 1, 1, 2, 0, 0, 0, 0)
        if (pointA == nil) then
            exports["soe-utils"]:HelpText("Press ~INPUT_CONTEXT~ to select Point A")
        else
            exports["soe-utils"]:HelpText("Press ~INPUT_CONTEXT~ to select Point B")
        end

        -- IF "E" IS PRESSED, RECORD POINT A/B
        if IsControlJustPressed(0, 38) then
            if (pointA == nil) then
                pointA = ray.HitPosition
            elseif (pointB == nil) then
                pointB = ray.HitPosition
            end
        end

        -- IF POINT B WAS SET, BREAK THE LOOP
        if (pointB ~= nil) then
            measuring = false
            TriggerEvent("Chat:Client:Message", "[Measuring Tape]", string.format("%s Meters.", tonumber(string.format('%.2f', Vdist(pointA, pointB)))), "standard")
        end
    end
end

-- **********************
--       Commands
-- **********************
-- WHEN TRIGGERED, TACKLE NEAREST PLAYERS
RegisterCommand("tackle", TacklePeople)

-- WHEN TRIGGERED, USE BINOCULARS
RegisterCommand("binos", UseBinoculars)

-- WHEN TRIGGERED, PUSH NEAREST VEHICLE
RegisterCommand("pushveh", PushVehicle)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, OPEN A CONTAINER
AddEventHandler("Civ:Client:OpenContainer", OpenContainer)

-- CALLED FROM SERVER TO SYNC KITTY LITTER EFFECT
RegisterNetEvent("Civ:Client:KittyLitter", function(pos)
    RemoveDecalsInRange(pos, 20.0)
end)

-- WHEN TRIGGERED, FORCE A RAGDOLL AS THIS PLAYER WAS TACKLED (REPLACED WITH RPC AS TEST)
--[[RegisterNetEvent("Civ:Client:TacklePlayers", function(data)
    if not data.status then return end
    SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 1, 1, 0)
end)]]

RegisterNetEvent("Civ:Client:HoldOptions", function()
    if isCarried or isDragged or isPiggybacked or isEscorted or isHeld then
        return
    end

    if IsPedSittingInAnyVehicle(PlayerPedId()) or exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
        return
    end

    local player = exports["soe-utils"]:GetClosestPlayer(5)
    local ped = exports["soe-utils"]:GetPedInFrontOfPlayer(5)
    if (ped ~= nil and ped ~= 0) and not IsPedAPlayer(ped) then
        if IsPedSittingInAnyVehicle(ped) then
            return
        end
        HoldNPCs(ped)
    else
        local myPed = PlayerPedId()
        if (holding == nil) then
            if (player ~= nil) then
                if IsPedSittingInAnyVehicle(GetPlayerPed(player)) then return end

                if IsEntityPlayingAnim(GetPlayerPed(player), "missfinale_c2ig_11", "pushcar_offcliff_f", 3) then return end

                if IsEntityPlayingAnim(GetPlayerPed(player), "mp_common_miss", "dead_ped_idle", 3) then return end

                holding = GetPlayerServerId(player)
                exports["soe-utils"]:LoadAnimDict("anim@heists@box_carry@", 15)
                TriggerServerEvent("Civ:Server:HoldPlayer", holding, true)
                TaskPlayAnim(myPed, "anim@heists@box_carry@", "idle", 3.0, 3.0, -1, 49, 0, 0, 0, 0)

                -- START THREAD FOR MAKE PLAYER EXIT DRIVER SEAT WHILE PERFORMING ACTION
                ActionThread()
            else
                exports["soe-ui"]:SendAlert("error", "Nobody close enough", 2000)
            end
        else
            TriggerServerEvent("Civ:Server:HoldPlayer", holding, false)
            holding = nil
            StopAnimTask(myPed, "anim@heists@box_carry@", "idle", 2.0)
        end
    end
end)

RegisterNetEvent("Civ:Client:DragOptions")
AddEventHandler(
    "Civ:Client:DragOptions",
    function()
        if isCarried or isDragged or isPiggybacked or isEscorted or isHeld then
            return
        end

        if IsPedSittingInAnyVehicle(PlayerPedId()) or exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
            return
        end

        local player = exports["soe-utils"]:GetClosestPlayer(5)
        local ped = exports["soe-utils"]:GetPedInFrontOfPlayer(5)
        if (ped ~= nil and ped ~= 0) and not IsPedAPlayer(ped) then
            if IsPedSittingInAnyVehicle(ped) then
                return
            end
            DragNPCs(ped)
        else
            local myPed = PlayerPedId()
            if (dragging == nil) then
                if (player ~= nil) then
                    if IsPedSittingInAnyVehicle(GetPlayerPed(player)) then return end

                    if IsEntityPlayingAnim(GetPlayerPed(player), "missfinale_c2ig_11", "pushcar_offcliff_f", 3) then return end

                    if IsEntityPlayingAnim(GetPlayerPed(player), "mp_common_miss", "dead_ped_idle", 3) then return end

                    dragging = GetPlayerServerId(player)
                    exports["soe-utils"]:LoadAnimDict("combat@drag_ped@", 15)
                    TriggerServerEvent("Civ:Server:DragPlayer", dragging, true)
                    TaskPlayAnim(myPed, "combat@drag_ped@", "injured_drag_plyr", 8.0, -8, -1, 33, 0, 0, 0, 0)

                    -- START THREAD FOR MAKE PLAYER EXIT DRIVER SEAT WHILE PERFORMING ACTION
                    ActionThread()
                else
                    exports["soe-ui"]:SendAlert("error", "Nobody close enough", 2000)
                end
            else
                TriggerServerEvent("Civ:Server:DragPlayer", dragging, false)
                dragging = nil
                StopAnimTask(myPed, "combat@drag_ped@", "injured_drag_plyr", 2.0)
            end
        end
    end
)

RegisterNetEvent("Civ:Client:EscortOptions")
AddEventHandler(
    "Civ:Client:EscortOptions",
    function()
        if isCarried or isDragged or isPiggybacked or isEscorted or isHeld then
            return
        end

        if IsPedSittingInAnyVehicle(PlayerPedId()) or exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
            return
        end

        local player = exports["soe-utils"]:GetClosestPlayer(5)
        local ped = exports["soe-utils"]:GetPedInFrontOfPlayer(5)
        if (ped ~= nil and ped ~= 0) and not IsPedAPlayer(ped) then
            if IsPedSittingInAnyVehicle(ped) then
                return
            end
            EscortNPCs(ped)
        else
            if IsPedSittingInAnyVehicle(GetPlayerPed(player)) then return end

            if IsEntityPlayingAnim(GetPlayerPed(player), "missfinale_c2ig_11", "pushcar_offcliff_f", 3) then return end

            if IsEntityPlayingAnim(GetPlayerPed(player), "mp_common_miss", "dead_ped_idle", 3) then return end

            if (escorting == nil) then
                if (player ~= nil) then
                    escorting = GetPlayerServerId(player)
                    TriggerServerEvent("Civ:Server:EscortPlayer", escorting, true)

                    -- START THREAD FOR MAKE PLAYER EXIT DRIVER SEAT WHILE PERFORMING ACTION
                    ActionThread()
                else
                    exports["soe-ui"]:SendAlert("error", "Nobody close enough", 2000)
                end
            else
                TriggerServerEvent("Civ:Server:EscortPlayer", escorting, false)
                escorting = nil
            end
        end
    end
)

RegisterNetEvent("Civ:Client:CarryOptions")
AddEventHandler(
    "Civ:Client:CarryOptions",
    function()
        if isCarried or isDragged or isPiggybacked or isEscorted or isHeld then
            return
        end

        if IsPedSittingInAnyVehicle(PlayerPedId()) or exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
            return
        end

        local player = exports["soe-utils"]:GetClosestPlayer(5)
        local ped = exports["soe-utils"]:GetPedInFrontOfPlayer(5)
        if (ped ~= nil and ped ~= 0) and not IsPedAPlayer(ped) then
            if IsPedSittingInAnyVehicle(ped) then
                return
            end
            CarryNPCs(ped)
        else
            local myPed = PlayerPedId()
            if (carrying == nil) then
                if (player ~= nil) then
                    if IsPedSittingInAnyVehicle(GetPlayerPed(player)) then return end

                    if IsEntityPlayingAnim(GetPlayerPed(player), "missfinale_c2ig_11", "pushcar_offcliff_f", 3) then return end

                    if IsEntityPlayingAnim(GetPlayerPed(player), "mp_common_miss", "dead_ped_idle", 3) then return end

                    -- SEND TO SERVER AND FILL THE VARIABLE
                    carrying = GetPlayerServerId(player)
                    TriggerServerEvent("Civ:Server:CarryPlayer", carrying, true)

                    -- CARRYING ANIMATION START
                    exports["soe-utils"]:LoadAnimDict("missfinale_c2mcs_1", 10)
                    TaskPlayAnim(myPed, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 1.0, 1.0, -1, 49, 0, 0, 0, 0)

                    -- START THREAD FOR MAKE PLAYER EXIT DRIVER SEAT WHILE PERFORMING ACTION
                    ActionThread()
                else
                    exports["soe-ui"]:SendAlert("error", "Nobody close enough", 2000)
                end
            else
                -- SEND TO SERVER AND NIL THE VARIABLE
                TriggerServerEvent("Civ:Server:CarryPlayer", carrying, false)
                carrying = nil
                -- CARRYING ANIMATION STOP
                StopAnimTask(myPed, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 2.0)
            end
        end
    end
)

RegisterNetEvent("Civ:Client:PiggybackOptions")
AddEventHandler(
    "Civ:Client:PiggybackOptions",
    function()
        if isCarried or isDragged or isPiggybacked or isEscorted or isHeld then
            return
        end

        if IsPedSittingInAnyVehicle(PlayerPedId()) or exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
            return
        end

        local player = exports["soe-utils"]:GetClosestPlayer(5)
        local ped = exports["soe-utils"]:GetPedInFrontOfPlayer(5)
        if (ped ~= nil and ped ~= 0) and not IsPedAPlayer(ped) then
            if IsPedSittingInAnyVehicle(ped) then
                return
            end
            PiggybackNPCs(ped)
        else
            local myPed = PlayerPedId()
            if (piggybacking == nil) then
                if (player ~= nil) then
                    if IsPedSittingInAnyVehicle(GetPlayerPed(player)) then return end

                    if IsEntityPlayingAnim(GetPlayerPed(player), "missfinale_c2ig_11", "pushcar_offcliff_f", 3) then return end

                    if IsEntityPlayingAnim(GetPlayerPed(player), "mp_common_miss", "dead_ped_idle", 3) then return end

                    -- SEND TO SERVER AND FILL THE VARIABLE
                    piggybacking = GetPlayerServerId(player)
                    TriggerServerEvent("Civ:Server:PiggybackPlayer", piggybacking, true)

                    -- PIGGYBACKING ANIMATION START
                    exports["soe-utils"]:LoadAnimDict("anim@arena@celeb@flat@paired@no_props@", 10)
                    TaskPlayAnim(myPed, "anim@arena@celeb@flat@paired@no_props@", "piggyback_c_player_a", 8.0, -8.0, -1, 49, 0, 0, 0, 0)

                    -- START THREAD FOR MAKE PLAYER EXIT DRIVER SEAT WHILE PERFORMING ACTION
                    ActionThread()
                else
                    exports["soe-ui"]:SendAlert("error", "Nobody close enough", 2000)
                end
            else
                -- SEND TO SERVER AND NIL THE VARIABLE
                TriggerServerEvent("Civ:Server:PiggybackPlayer", piggybacking, false)
                piggybacking = nil
                -- PIGGYBACKING ANIMATION STOP
                StopAnimTask(myPed, "anim@arena@celeb@flat@paired@no_props@", "piggyback_c_player_a", 2.0)
            end
        end
    end
)

RegisterNetEvent("Civ:Client:HoldPlayer")
AddEventHandler("Civ:Client:HoldPlayer", function(toHold, src)
    local ped = PlayerPedId()
    if toHold then
        isHeld = true
        exports["soe-utils"]:LoadAnimDict("amb@world_human_bum_slumped@male@laying_on_right_side@base", 15)
        TaskPlayAnim(ped, "amb@world_human_bum_slumped@male@laying_on_right_side@base", "base", 3.0, 3.0, -1, 9, 0, 0, 0, 0)
        AttachEntityToEntity(ped, GetPlayerPed(GetPlayerFromServerId(src)), GetPedBoneIndex(GetPlayerPed(GetPlayerFromServerId(src)), 57005), -0.32, -0.6, -0.35, 240.0, 35.0, 149.0, 1, 1, 0, 1, 1, 1)
        TriggerEvent("Chat:Client:SendMessage", "me", "You're being held.")

        -- CHECK IF PLAYER IS DRAGGED, THEN DISABLE CONTROLS
        while isHeld do
            Wait(5)
            DisableControlAction(0, 22)
            DisableControlAction(0, 23)
            DisableControlAction(0, 311)
            DisableControlAction(0, 37, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 257, true)
        end
    else
        isHeld = false
        DetachEntity(ped, true, false)
        StopAnimTask(ped, "amb@world_human_bum_slumped@male@laying_on_right_side@base", "base", 2.0)
        StopAnimTask(GetPlayerPed(GetPlayerFromServerId(src)), "anim@heists@box_carry@", "idle", 2.0)
        TriggerEvent("Chat:Client:SendMessage", "me", "You're no longer being held.")
    end
end)

RegisterNetEvent("Civ:Client:DragPlayer")
AddEventHandler(
    "Civ:Client:DragPlayer",
    function(toDrag, src)
        local ped = PlayerPedId()
        if toDrag then
            isDragged = true
            exports["soe-utils"]:LoadAnimDict("combat@drag_ped@", 15)
            TaskPlayAnim(ped, "combat@drag_ped@", "injured_drag_ped", 8.0, -8, -1, 33, 0, 0, 0, 0)
            AttachEntityToEntity(ped, GetPlayerPed(GetPlayerFromServerId(src)), 11816, 4103, 0.48, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
            TriggerEvent("Chat:Client:SendMessage", "me", "You're being dragged.")

            -- CHECK IF PLAYER IS DRAGGED, THEN DISABLE CONTROLS
            while isDragged do
                Wait(5)
                DisableControlAction(0, 22)
                DisableControlAction(0, 23)
                DisableControlAction(0, 311)
                DisableControlAction(0, 37, true)
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 25, true)
                DisableControlAction(0, 257, true)
            end
        else
            isDragged = false
            DetachEntity(ped, true, false)
            StopAnimTask(ped, "combat@drag_ped@", "injured_drag_ped", 2.0)
            TriggerEvent("Chat:Client:SendMessage", "me", "You're no longer being dragged.")
        end
    end
)

RegisterNetEvent("Civ:Client:EscortPlayer")
AddEventHandler(
    "Civ:Client:EscortPlayer",
    function(toEscort, src)
        local ped = PlayerPedId()
        if toEscort then
            isEscorted = true
            AttachEntityToEntity(ped, GetPlayerPed(GetPlayerFromServerId(src)), 11816, 0.45, 0.45, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 2, 1)
            TriggerEvent("Chat:Client:SendMessage", "me", "You're being escorted.")

            -- CHECK IF PLAYER IS ESCORTED, THEN DISABLE CONTROLS
            exports["soe-utils"]:LoadAnimDict("dead", 15)
            while isEscorted do
                Wait(5)
                DisableControlAction(0, 22)
                DisableControlAction(0, 23)
                DisableControlAction(0, 311)
                DisableControlAction(0, 37, true)
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 25, true)
                DisableControlAction(0, 257, true)
            end
        else
            isEscorted = false
            DetachEntity(ped, true, false)
            TriggerEvent("Chat:Client:SendMessage", "me", "You're no longer being escorted.")
        end
    end
)

RegisterNetEvent("Civ:Client:CarryPlayer")
AddEventHandler(
    "Civ:Client:CarryPlayer",
    function(toCarry, src)
        local ped = PlayerPedId()
        if toCarry then
            isCarried = true
            exports["soe-utils"]:LoadAnimDict("nm", 15)
            TaskPlayAnim(ped, "nm", "firemans_carry", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
            AttachEntityToEntity(ped, GetPlayerPed(GetPlayerFromServerId(src)), 0, 0.2, 0.2, 0.5, 0.0, 0.0, 0.0, 1, 1, 0, 1, 1, 1)
            TriggerEvent("Chat:Client:SendMessage", "me", "You're being carried.")

            while isCarried do
                Wait(5)
                DisableControlAction(0, 22)
                DisableControlAction(0, 23)
                DisableControlAction(0, 311)
                DisableControlAction(0, 37, true)
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 25, true)
                DisableControlAction(0, 257, true)
            end
        else
            isCarried = false
            DetachEntity(ped, true, false)
            StopAnimTask(ped, "nm", "firemans_carry", 2.0)
            StopAnimTask(GetPlayerPed(GetPlayerFromServerId(src)), "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 2.0)
            TriggerEvent("Chat:Client:SendMessage", "me", "You're no longer being carried.")
        end
    end
)

RegisterNetEvent("Civ:Client:PiggybackPlayer")
AddEventHandler(
    "Civ:Client:PiggybackPlayer",
    function(toPiggyback, src)
        local ped = PlayerPedId()
        if toPiggyback then
            isPiggybacked = true
            exports["soe-utils"]:LoadAnimDict("anim@arena@celeb@flat@paired@no_props@", 15)
            TaskPlayAnim(ped, "anim@arena@celeb@flat@paired@no_props@", "piggyback_c_player_b", 8.0, -8.0, -1, 1, 1.0, 0, 0, 0)
            AttachEntityToEntity(ped, GetPlayerPed(GetPlayerFromServerId(src)), 0, 0.0, -0.07, 0.45, 0.5, 0.5, 0.0, false, false, false, false, 2, false)

            while isPiggybacked do
                Wait(5)
                DisableControlAction(0, 22)
                DisableControlAction(0, 23)
                DisableControlAction(0, 311)
                DisableControlAction(0, 37, true)
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 25, true)
                DisableControlAction(0, 257, true)
            end
        else
            isPiggybacked = false
            DetachEntity(ped, true, false)
            StopAnimTask(ped, "anim@arena@celeb@flat@paired@no_props@", "piggyback_c_player_b", 2.0)
        end
    end
)

AddEventHandler("Civ:Client:UseCampFire", UseCampFire)

-- ON MENU CLOSED
craftMenuMain:On('close', function(menu)
    closeMenus()
end)