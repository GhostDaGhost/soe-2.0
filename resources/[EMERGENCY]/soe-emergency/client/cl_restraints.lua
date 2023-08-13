local restraints = {}
local inVehDisabledKeys = {30, 34, 35, 59, 60, 61, 62, 63, 64, 107, 108, 109, 110, 111, 112, 114}
local disabledKeys = {241, 242, 45, 140, 141, 142, 263, 264, 25, 12, 13, 14, 15, 16, 17, 157, 158, 159, 160, 161, 162, 163, 164, 165, 261, 262}

-- ***********************
--     Local Functions
-- ***********************
-- WHEN TRIGGERED, HAVE A RANDOM CHANCE OF TRIPPING IN WRIST RESTRAINTS
local function RandomTripping(ped)
    local roll = GetRandomIntInRange(1, 100)
    if IsPedRunning(ped) and (roll <= 10) then
        SetPedToRagdoll(ped, 50, 2000, 3, true, true, true)
        ClearPedSecondaryTask(ped)
    end
end

-- WHEN TRIGGERED, GIVE PLAYER AN OPPORTUNITY TO RESIST RESTRAINT
local function RestraintResistance(soft)
    -- DEAD PLAYERS SHOULD NOT HAVE A CHANCE TO RESIST
    if IsDead() then
        TriggerServerEvent("Emergency:Server:RestraintResistance", {status = true, success = false})
        return
    end

    -- CALCULATE DIFFICULTY OF MINIGAME
    local time, thickness = 750, 6
    if soft then
        time, thickness = 950, 8
    end

    -- START MINIGAME AND WINNER GETS TO RESIST THE RESTRAINT
    if exports["soe-challenge"]:Skillbar(time, thickness) then
        TriggerServerEvent("Emergency:Server:RestraintResistance", {status = true, success = true})
    else
        TriggerServerEvent("Emergency:Server:RestraintResistance", {status = true, success = false})
    end
end

-- WHEN TRIGGERED, DO RESTRAINING ANIMATIONS FOR INTIIAL RESTRAINEE
local function PerformRestrainingAnimation(ped, releasing, soft)
    if not releasing then
        -- LOAD ANIMATION DICTIONARIES FOR HARD/SOFT RESTRAINING
        exports["soe-utils"]:LoadAnimDict("rcmpaparazzo_3", 15)
        exports["soe-utils"]:LoadAnimDict("mp_arrest_paired", 15)

        -- WAIT 1.2 SECONDS BEFORE DOING ANIMATION
        Wait(500)
        if not soft then
            TaskPlayAnim(ped, "mp_arrest_paired", "cop_p2_back_right", 3.0, 3.0, 2500, 49, 0, 0, 0, 0)
        else
            local pos, hdg = GetEntityCoords(ped), GetEntityHeading(ped)
            TaskPlayAnimAdvanced(ped, "rcmpaparazzo_3", "poppy_arrest_cop", pos, 0, 0, hdg, 1.0, 1.0, 4200, 1, 0.578, 0, 0)
        end
    else
        exports["soe-utils"]:LoadAnimDict("mp_arresting", 15)
        TaskPlayAnim(ped, "mp_arresting", "a_uncuff", 1.0, 1.0, 2500, 49, 0, 0, 0, 0)
    end
end

-- WHEN TRIGGERED, PERFORM INITIAL RESTRAINT TASKS
local function RestrainPlayer(type, soft)
    if not type then return end

    -- MAKE SURE THE PLAYER CAN RESTRAIN
    local ped = PlayerPedId()
    if IsPedSittingInAnyVehicle(ped) or IsDead() or IsRestrained() then
        exports["soe-ui"]:SendAlert("error", "You cannot do this now!", 3500)
        return
    end

    -- GET THE CLOSEST PLAYER TO RESTRAIN
    local closestPlayer = exports["soe-utils"]:GetClosestPlayer(3)
    if (closestPlayer ~= nil) then
        local canCuff = false
        local target = GetPlayerPed(closestPlayer)
        local dist = #(GetEntityCoords(ped) - GetEntityCoords(target))

        -- CONDITION CHECKS FOR PROPER RESTRAINING
        if (exports["soe-jobs"]:GetMyJob() == "POLICE") then
            canCuff = true
        elseif exports["soe-emotes"]:IsDoingDeathAnimation(target) or IsEntityPlayingAnim(target, "missminuteman_1ig_2", "handsup_enter", 3) or IsPedRagdoll(target) or IsPedCuffed(target) or IsEntityDead(target) then
            canCuff = true
        end

        if canCuff then
            local newDist = #(GetEntityCoords(ped) - GetEntityCoords(target))
            if (math.abs(dist - newDist) <= 3.5) then
                local handcuff = exports["soe-nexus"]:TriggerServerCallback("Emergency:Server:RestrainPlayer", GetPlayerServerId(closestPlayer), type, soft)
                if handcuff.status then
                    PerformRestrainingAnimation(ped, handcuff.releasing, soft)
                end
            else
                exports["soe-ui"]:SendAlert("error", "The target got too far!", 5000)
            end
        else
            exports["soe-ui"]:SendAlert("error", "Make sure target has their hands up or downed!")
        end
    else
        exports["soe-ui"]:SendAlert("error", "Nobody nearby to " .. type:lower(), 5000)
    end
end

-- WHEN TRIGGERED, PERFORM RESTRAINT TASKS ON TARGET
local function GetRestrained(src, type, soft, releasing)
    local ped = PlayerPedId()

    -- DISABLE/ENABLE SOME NATIVES TO RESTORE FUNCTIONALITY
    if releasing then
        Wait(2500)
        UncuffPed(ped)
        SetEnableHandcuffs(ped, false)

        SetPedCanSwitchWeapon(ped, true)
        StopAnimTask(ped, "mp_arresting", "idle", 2.0)

        -- REMOVE RESTRAINT PROP
        if restraints.prop and DoesEntityExist(restraints.prop) then
            DeleteEntity(restraints.prop)
            DetachEntity(ped, true, false)

            SetEntityAsNoLongerNeeded(restraints.prop)
            TriggerServerEvent("Utils:Server:DeleteEntity", ObjToNet(restraints.prop))
            restraints.prop = nil
        end

        if (type == "Cuff") then
            restraints.isHandcuffed = false
            exports["soe-uchuu"]:UpdateGamestate("cuffed", true)
        elseif (type == "Zip-Tie") then
            restraints.isZipTied = false
            exports["soe-uchuu"]:UpdateGamestate("zip-tied", true)
        end
    else
        -- LOAD ANIMATION DICTIONARIES
        exports["soe-utils"]:LoadAnimDict("mp_arresting", 15)
        exports["soe-utils"]:LoadAnimDict("rcmpaparazzo_3", 15)
        exports["soe-utils"]:LoadAnimDict("mp_arrest_paired", 15)

        Wait(500)
        if src then
            AttachEntityToEntity(ped, GetPlayerPed(GetPlayerFromServerId(src)), 11816, 4103, 0.48, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 2, 1)
        end

        -- ANIMATION CONTROL FOR OUR PRISONER
        if not soft then
            if not IsDead() then
                TaskPlayAnim(ped, "mp_arrest_paired", "crook_p2_back_right", 3.0, 3.0, 2750, 49, 0, 0, 0, 0)
            end

            Wait(2450)
            if (type == "Cuff") then
                exports["soe-utils"]:PlayProximitySound(3.0, "handcuff.ogg", 0.5)
            elseif (type == "Zip-Tie") then
                exports["soe-utils"]:PlayProximitySound(3.0, "ziptie.ogg", 0.5)
            end
        else
            -- STOP HANDSUP ANIMATION IF PLAYING AS IT INTERFERES WITH SOFT-CUFF ANIMS
            if IsEntityPlayingAnim(ped, "missminuteman_1ig_2", "handsup_enter", 3) then
                StopAnimTask(ped, "missminuteman_1ig_2", "handsup_enter", 2.0)
            end

            if not IsDead() then
                local pos, hdg = GetEntityCoords(ped), GetEntityHeading(ped)
                TaskPlayAnimAdvanced(ped, "rcmpaparazzo_3", "poppy_arrest_popm", pos, 0, 0, hdg, 1.0, 1.0, 4150, 1, 0.579, 0, 0)
            end

            Wait(2180)
            if (type == "Cuff") then
                exports["soe-utils"]:PlayProximitySound(3.0, "handcuff.ogg", 0.5)
            elseif (type == "Zip-Tie") then
                exports["soe-utils"]:PlayProximitySound(3.0, "ziptie.ogg", 0.5)
            end
        end

        -- ENABLE SOME NATIVES TO PREVENT GLITCHING/FAIL-RP
        DetachEntity(ped, true, false)
        SetEnableHandcuffs(ped, true)
        SetPedCanSwitchWeapon(ped, false)
        SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)

        -- CREATE HANDCUFFS PROP TO ATTACH TO ARM
        if not restraints.prop and not DoesEntityExist(restraints.prop) then
            local hash, rotX = GetHashKey("p_cs_cuffs_02_s"), 45.0
            if (type == "Zip-Tie") then
                hash, rotX = GetHashKey("hei_prop_zip_tie_positioned"), 20.0
            end
            exports["soe-utils"]:LoadModel(hash, 15)

            restraints.prop = CreateObject(hash, GetEntityCoords(ped), true, true, true)
            AttachEntityToEntity(restraints.prop, ped, GetPedBoneIndex(ped, 57005), 0.0, 0.068, 0.0, rotX, 0.0, 80.0, 1, 0, 0, 0, 0, 1)
        end

        -- PLAY THE CUFFED ANIMATION
        if (type == "Cuff") then
            restraints.isHandcuffed = true
            exports["soe-uchuu"]:UpdateGamestate("cuffed", false, true)
        elseif (type == "Zip-Tie") then
            restraints.isZipTied = true
            exports["soe-uchuu"]:UpdateGamestate("zip-tied", false, true)
        end
        TaskPlayAnim(ped, "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)

        local loopIndex = 0
        while restraints.isHandcuffed or restraints.isZipTied do
            Wait(5)
            -- CHECK IF IN CUFFS, DISABLE CONTROLS AND CUFF ANIMATION
            for key = 1, #disabledKeys do
                DisableControlAction(0, disabledKeys[key], true)
            end

            if IsPedInAnyVehicle(PlayerPedId(), false) then
                for key = 1, #inVehDisabledKeys do
                    DisableControlAction(0, inVehDisabledKeys[key], true)
                end
            end

            loopIndex = loopIndex + 1
            if (loopIndex % 350 == 0) then
                loopIndex = 0
                if not IsEntityPlayingAnim(PlayerPedId(), "mp_arresting", "idle", 3) then
                    TaskPlayAnim(PlayerPedId(), "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
                end
                RandomTripping(PlayerPedId())
            end
        end
    end
end

-- ***********************
--     Global Functions
-- ***********************
-- WHEN TRIGGERED, RETURN IF PLAYER IS ZIP-TIED
function IsZipTied()
    if restraints.isZipTied then
        return true
    end
    return false
end

-- WHEN TRIGGERED, RETURN IF PLAYER IS HANDCUFFED
function IsHandcuffed()
    if restraints.isHandcuffed then
        return true
    end
    return false
end

-- WHEN TRIGGERED, RETURN IF PLAYER IS COMPLETELY RESTRAINED EITHER BY CUFFS OR ZIP-TIES
function IsRestrained()
    if restraints.isHandcuffed or restraints.isZipTied then
        return true
    end
    return false
end

-- ***********************
--        Events
-- ***********************
-- WHEN TRIGGERED, PERFORM INITIAL RESTRAINT TASKS
RegisterNetEvent("Emergency:Client:RestrainPlayer", RestrainPlayer)

-- WHEN TRIGGERED, PERFORM RESTRAINT TASKS ON TARGET
RegisterNetEvent("Emergency:Client:GetRestrained", GetRestrained)

-- WHEN TRIGGERED, GIVE PLAYER AN OPPORTUNITY TO RESIST RESTRAINT
RegisterNetEvent("Emergency:Client:RestraintResistance", RestraintResistance)

-- WHEN TRIGGERED, RESET EVERYTHING
AddEventHandler("onResourceStop", function(resource)
    if (GetCurrentResourceName() ~= resource) then return end

    -- DELETE LEFTOVER RESTRAINT PROP
    if restraints.prop and DoesEntityExist(restraints.prop) then
        DeleteEntity(restraints.prop)
        SetEntityAsNoLongerNeeded(restraints.prop)
        TriggerServerEvent("Utils:Server:DeleteEntity", ObjToNet(restraints.prop))

        UncuffPed(PlayerPedId())
        SetEnableHandcuffs(PlayerPedId(), false)
        SetPedCanSwitchWeapon(PlayerPedId(), true)
    end

    -- RESET ANIMATION
    if IsEntityPlayingAnim(PlayerPedId(), "mp_arresting", "idle", 3) then
        ClearPedTasksImmediately(PlayerPedId())
    end
end)
