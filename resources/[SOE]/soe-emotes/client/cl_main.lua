local emotes = {}
local myProps = {}

local isProne, crouching = false, false
local ragdolled, areHandsUp = false, false
local hasProp, hasSecondaryProp = false, false
local isPlayingEmote, isPlayingScenario = false, false

-- KEY MAPPINGS
RegisterKeyMapping("prone", "[Emotes] Prone", "KEYBOARD", "Y")
RegisterKeyMapping("crouch", "[Emotes] Crouch", "KEYBOARD", "U")
RegisterKeyMapping("handsup", "[Emotes] Hands Up", "KEYBOARD", "Z")
RegisterKeyMapping("+point", "[Emotes] Point", "KEYBOARD", "B")
RegisterKeyMapping("ec", "[Emotes] Cancel Emote", "KEYBOARD", "X")
RegisterKeyMapping("ragdoll", "[Emotes] Toggle Ragdoll", "KEYBOARD", "O")

RegisterKeyMapping("dogjump", "[Emotes] Dog Jump", "KEYBOARD", "SPACE")

RegisterKeyMapping("acceptemote", "[Emotes] Accept Request", "KEYBOARD", "G")
RegisterKeyMapping("denyemote", "[Emotes] Deny Request", "KEYBOARD", "H")

-- WHEN TRIGGERED, MAKE KEYBINDS FOR SAVED EMOTES
for bind = 1, amountOfBinds do
    RegisterKeyMapping("emote_bind" .. bind, "[Emotes] Saved Bind " .. bind, "KEYBOARD", "")

    RegisterCommand("emote_bind" .. bind, function()
        PerformSavedEmote(bind)
    end)
end

-- ***********************
--    Global Functions
-- ***********************
-- WHEN TRIGGERED, PERFORM A SAVED EMOTE FROM A KEYBIND
function PerformSavedEmote(bind)
    bind = tostring(bind)
    local charSettings = exports["soe-uchuu"]:GetPlayer().Settings
    if (type(charSettings) == "string") then
        charSettings = json.decode(exports["soe-uchuu"]:GetPlayer().Settings)
    end

    local emote = charSettings["emote_bind" .. bind]
    if emote then
        StartEmote(emote)
    end
end

-- ***********************
--     Local Functions
-- ***********************
-- CHECKS PLAYER'S GENDER
local function CheckMyGender(ped)
    local myGender = "Unknown"
    if (GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then
        myGender = "male"
    end
    return myGender
end

-- WHEN TRIGGERED, DO EMOTE REQUEST NOTIFICATION THINGS
local function EmoteRequestNotify(data)
    if not data.status then return end
    if not data.emote then return end

    emotes.hasRequest = true
    local msg = "Emote Request: " .. data.emote .. " | [G] Accept | [H] Deny"
    exports["soe-ui"]:PersistentAlert("start", "emoteRequest", "debug", msg, 10)
    PlaySound(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 0, 0, 1)
end

-- ADDS PROP TO PLAYER AS PART OF AN EMOTE
local function AddPropToPlayer(prop, bone, posX, posY, posZ, rotX, rotY, rotZ)
    local ped = PlayerPedId()
    hasProp = true

    exports["soe-utils"]:LoadModel(prop, 15)
    local obj = CreateObject(prop, GetEntityCoords(ped), true, true, true)
    AttachEntityToEntity(obj, ped, GetPedBoneIndex(ped, bone), posX, posY, posZ, rotX, rotY, rotZ, 1, 1, 0, 1, 1, 1)

    table.insert(myProps, obj)
    SetModelAsNoLongerNeeded(prop)
end

-- WHEN TRIGGERED, PERFORM DOG JUMP
local function DoDogJump()
    if exports["soe-emergency"]:IsDead() then return end

    local ped = PlayerPedId()
    if IsPedSittingInAnyVehicle(ped) then return end
    if exports["soe-utils"]:IsModelADog(ped) and not emotes.isDogJumping then
        emotes.isDogJumping = true
        local pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 3.0, 1.5)
        SetEntityCoords(ped, pos.x, pos.y, pos.z, true, true, true, true)

        Wait(3000)
        emotes.isDogJumping = false
    end
end

-- WHEN TRIGGERED, TOGGLES RAGDOLL STATUS OF PLAYER
local function DoRagdoll()
    local ped = PlayerPedId()
    if not ragdolled and IsPedOnFoot(ped) then
        ragdolled = true
        while ragdolled do
            Wait(50)
            SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
        end
    else
        ragdolled = false
    end
end

-- WHEN TRIGGERED, FULFILL EMOTE REQUEST WITH THE TARGET IF THEY ACCEPTED
local function PerformEmoteRequest(data)
    if not data.status then return end
    if not data.emote then return end

    emotes.hasRequest = false
    exports["soe-ui"]:PersistentAlert("end", "emoteRequest")
    if data.response then
        local ped = GetPlayerPed(GetPlayerFromServerId(data.src))
        local pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.0, 0.0)

        SetEntityHeading(PlayerPedId(), GetEntityHeading(ped) - 180.1)
        SetEntityCoordsNoOffset(PlayerPedId(), pos.x, pos.y, pos.z, 0)

        CancelEmote()
        Wait(300)
        local emote = animations[data.emote]
        if emote.shared and emote.receiver then
            emote = animations[emote.receiver]
        end
        PlayAnimation(emote)
    end
end

-- ALLOWS PLAYER TO PUT THEIR HANDS UP/DOWN WHEN TRIGGERED
local function DoSurrender()
    local ped = PlayerPedId()
    if not IsPedInAnyVehicle(ped, false) and not IsPedCuffed(ped) and not IsEntityInWater(ped) then
        if not areHandsUp then
            areHandsUp = true
            exports["soe-utils"]:LoadAnimDict("missminuteman_1ig_2", 15)
            TaskPlayAnim(ped, "missminuteman_1ig_2", "handsup_enter", 8.0, 8.0, -1, 50, 0, 0, 0, 0)
            while areHandsUp do
                Wait(1)
                DisablePlayerFiring(PlayerId(), true)
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 25, true)
            end
        else
            if areHandsUp then
                areHandsUp = false
                StopAnimTask(ped, "missminuteman_1ig_2", "handsup_enter", -2.5)
            end
        end
    end
end

-- WHEN TRIGGERED, LOOK FOR THE CLOSEST PLAYER AND REQUEST A SYNCED EMOTE
local function GetClosestForSync(data)
    if not data.status then return end
    if not data.emote then return end

    -- CHECK IF PLAYER IS DEAD OR HANDCUFFED
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
        exports["soe-ui"]:SendAlert("error", "Not now!", 5000)
        return
    end

    -- CHECK IF PLAYER IS IN A VEHICLE, IF YES THEN AUTO-DENY
    if IsPedSittingInAnyVehicle(PlayerPedId()) then
        exports["soe-ui"]:SendAlert("error", "Not while in a vehicle!", 5000)
        return
    end

    -- GET CLOSEST PLAYER, ERROR OUT IF NON-EXISTENT
    local closestPlayer = exports["soe-utils"]:GetClosestPlayer(3)
    if not closestPlayer then
        exports["soe-ui"]:SendAlert("error", "Nobody close enough", 5000)
        return
    end

    -- SEND TO SERVER
    local emoteRequest = exports["soe-nexus"]:TriggerServerCallback("Emotes:Server:SendEmoteRequest", GetPlayerServerId(closestPlayer), data.emote)
    if emoteRequest.accepted then
        exports["soe-ui"]:SendAlert("success", "Shared emote request accepted!", 5000)
        CancelEmote()
        Wait(300)
        PlayAnimation(animations[data.emote])
    else
        exports["soe-ui"]:SendAlert("error", "Shared emote request denied!", 5000)
    end
end

-- CROUCHING FUNCTION
local function DoCrouch()
    local ped = PlayerPedId()
    if IsPedSittingInAnyVehicle(ped) or exports["soe-emergency"]:IsDead() then
        return
    end

    if exports["soe-civ"]:IsRestrained() or exports["soe-utils"]:IsModelADog(ped) then
        return
    end

    if isProne then return end
    if not crouching then
        crouching = true
        exports["soe-utils"]:LoadAnimSet("move_ped_crouched", 15)
        exports["soe-utils"]:LoadAnimSet("move_m@tough_guy@", 15)
        SetPedMovementClipset(ped, "move_ped_crouched", 0.55)
        SetPedStrafeClipset(ped, "move_ped_crouched_strafing")
        while crouching do
            Wait(1050)
            SetPedMovementClipset(ped, "move_ped_crouched", 0.55)
            SetPedStrafeClipset(ped, "move_ped_crouched_strafing")
        end
        SetPedMovementClipset(ped, "move_m@tough_guy@", 0.5)
        Wait(750)
        ResetPedMovementClipset(ped)
        ResetPedStrafeClipset(ped)
        exports["soe-emotes"]:RestoreSavedWalkstyle()
    else
        crouching = false
    end
end

-- PRONING FUNCTION
local function DoProne()
    local ped = PlayerPedId()
    if IsPedSittingInAnyVehicle(ped) or exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
        return
    end

    if exports["soe-civ"]:IsRestrained() or exports["soe-utils"]:IsModelADog(ped) then
        return
    end

    if crouching then
        crouching = false
    end

    if not isProne then
        isProne = true
        exports["soe-utils"]:LoadAnimSet("move_crawl", 15)
        TaskPlayAnimAdvanced(ped, "move_crawl", "onfront_fwd", GetEntityCoords(ped), 0.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 46, 1.0, 0, 0)
        while isProne do
            Wait(3)
            DisableControlAction(0, 75)
            if IsPedSittingInAnyVehicle(ped) then
                TaskLeaveVehicle(ped, GetVehiclePedIsIn(ped, false), 256)
            end

            if IsControlJustPressed(0, 32) and not movefwd then
                movefwd = true
                TaskPlayAnimAdvanced(ped, "move_crawl", "onfront_fwd", GetEntityCoords(ped), 1.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 47, 1.0, 0, 0)
            elseif IsControlJustReleased(0, 32) and movefwd then
                TaskPlayAnimAdvanced(ped, "move_crawl", "onfront_fwd", GetEntityCoords(ped), 1.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 46, 1.0, 0, 0)
                movefwd = false
            end

            if IsControlJustPressed(0, 33) and not movebwd then
                movebwd = true
                TaskPlayAnimAdvanced(ped, "move_crawl", "onfront_bwd", GetEntityCoords(ped), 1.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 47, 1.0, 0, 0)
            elseif IsControlJustReleased(0, 33) and movebwd then
                TaskPlayAnimAdvanced(ped, "move_crawl", "onfront_bwd", GetEntityCoords(ped), 1.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 46, 1.0, 0, 0)
                movebwd = false
            end

            if IsControlPressed(0, 34) then
                SetEntityHeading(ped, GetEntityHeading(ped) + 2.0)
            elseif IsControlPressed(0, 35) then
                SetEntityHeading(ped, GetEntityHeading(ped) - 2.0)
            end
        end
    else
        ClearPedTasks(ped)
        exports["soe-utils"]:LoadAnimDict("get_up@directional@transition@prone_to_knees@crawl", 15)
        TaskPlayAnim(ped, "get_up@directional@transition@prone_to_knees@crawl", "front", 8.0, 1.0, 500, 1, 0, 0, 0, 0)
        Wait(500)
        exports["soe-utils"]:LoadAnimDict("get_up@directional@movement@from_knees@action", 15)
        TaskPlayAnim(ped, "get_up@directional@movement@from_knees@action", "getup_l_0", 8.0, 1.0, 850, 1, 0, 0, 0, 0)
        isProne = false
    end
end

-- ***********************
--    Global Functions
-- ***********************
-- RESTORES PLAYER'S SAVED WALKSTYLE
function RestoreSavedWalkstyle()
    TriggerServerEvent("Emotes:Server:GetMyWalkstyle", {status = true})
end

-- DESTROYS ANY PROPS THE PLAYER HAS
function EliminateAllProps()
    for _, prop in pairs(myProps) do
        DeleteEntity(prop)
    end
    hasProp = false
end

-- EXPORTED TO LET SCRIPTS USE THIS
function StartEmote(emote)
    if (emote == nil) then return end
    if animations[emote] then
        PlayAnimation(animations[emote])
    end
end

-- CHANGES PLAYER'S FACIAL EXPRESSION
function PlayFacialExpression(expression)
    local ped = PlayerPedId()
    if (expression == "reset") then
        ClearFacialIdleAnimOverride(ped)
        return
    end
    SetFacialIdleAnimOverride(ped, expression.mood)
end

-- CHANGES PLAYER'S AIMING STYLE
function PlayAimingStyle(aimingStyle)
    local ped = PlayerPedId()
    if (aimingStyle == "reset") then
        SetWeaponAnimationOverride(ped, GetHashKey("Default"))
        return
    end
    SetWeaponAnimationOverride(ped, aimingStyle.anim)
end

-- CANCELS EMOTES ENTIRELY AND CLEARS PROPS
function CancelEmote()
    local ped = PlayerPedId()
    if isPlayingScenario then
        isPlayingScenario = false
        ClearPedTasksImmediately(ped)
    end

    if isPlayingEmote then
        isPlayingEmote = false
        ClearPedTasks(ped)
        EliminateAllProps()
    end
end

-- CHANGES PLAYER'S WALKSTYLE
function SetWalkstyle(walkstyle)
    local ped = PlayerPedId()
    if (walkstyle == "reset") then
        ResetPedMovementClipset(ped)
        exports["soe-uchuu"]:UpdateSettings("walkstyle", true)
        return
    end

    -- LOAD AND SET OUR WALKSTYLE
    exports["soe-utils"]:LoadAnimSet(walkstyle.anim, 15)
    SetPedMovementClipset(ped, walkstyle.anim, 1.0)

    -- MAKE OUR WALKSTYLE PERSISTENT BY SAVING IT
    exports["soe-uchuu"]:UpdateSettings("walkstyle", false, walkstyle.anim)
end

-- CHECKS IF THE PLAYER IS PLAYING A DEATH ANIMATION
function IsDoingDeathAnimation(ped)
    if IsEntityPlayingAnim(ped, "dead", "dead_a", 3) then
        return true
    elseif IsEntityPlayingAnim(ped, "dead", "dead_b", 3) then
        return true
    elseif IsEntityPlayingAnim(ped, "dead", "dead_c", 3) then
        return true
    elseif IsEntityPlayingAnim(ped, "dead", "dead_d", 3) then
        return true
    elseif IsEntityPlayingAnim(ped, "dead", "dead_e", 3) then
        return true
    elseif IsEntityPlayingAnim(ped, "dead", "dead_f", 3) then
        return true
    elseif IsEntityPlayingAnim(ped, "dead", "dead_g", 3) then
        return true
    end
    return false
end

-- PLAYS ANIMATION
function PlayAnimation(animation)
    local ped = PlayerPedId()
    if IsPedBeingStunned(ped) then return end -- PREVENTS PLAYER FROM DOING EMOTES TO CANCEL OUT OF STUNNED

    if hasProp then EliminateAllProps() end -- ELIMINATES ANY PROPS MADE TO PREVENT STICKYNESS

    -- IF "/e c" WAS ENTERED, CANCEL EMOTE
    if (animation == "reset") then
        CancelEmote()
        return
    end

    -- CHECK IF THIS SPECIFIC EMOTE IS A WORLD SCENARIO
    if animation.scenario then
        isPlayingScenario = true
        if IsPedSittingInAnyVehicle(ped) then
            isPlayingEmote = false
            exports["soe-ui"]:SendAlert("error", "You cannot perform this while in a vehicle", 5000)
            return
        end

        local allowed, myGender = false, CheckMyGender(ped)
        if (animation.type == "neutral") then
            allowed = true
        elseif (animation.type == "male") then
            if (myGender == "male") then
                allowed = true
            end
        elseif (animation.type == "object") then
            ClearPedTasks(ped)
            local pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0 - 0.5, -0.5)
            TaskStartScenarioAtPosition(ped, animation.anim, pos, GetEntityHeading(ped), 0, 1, false)
        end

        if allowed then
            ClearPedTasks(ped)
            TaskStartScenarioInPlace(ped, animation.anim, 0, true)
        end

        return
    end

    -- LOAD ANIMATION DICTIONARY AND PERFORM ANIMATION
    isPlayingEmote = true
    exports["soe-utils"]:LoadAnimDict(animation.dict, 15)
    TaskPlayAnim(ped, animation.dict, animation.anim, animation.blendIn or 3.0, animation.blendOut or 3.0, animation.duration or -1, animation.flag or 49, 0, 0, 0, 0)

    -- START ADDING PROPS IF AN EMOTE HAS ONE
    if animation.isProp then
        --print("DEBUG: HAS PRIMARY PROP.")
        local posX, posY, posZ = animation.propOptions.posX, animation.propOptions.posY, animation.propOptions.posZ
        local rotX, rotY, rotZ = animation.propOptions.rotX, animation.propOptions.rotY, animation.propOptions.rotZ
        AddPropToPlayer(animation.propOptions.model, animation.propOptions.bone, posX, posY, posZ, rotX, rotY, rotZ)

        -- IF AN EMOTE HAS A SECONDARY PROP | ATTACH ANOTHER (NOTEPAD ETC)
        if animation.hasSecondaryProp then
            --print("DEBUG: HAS SECONDARY PROP.")
            posX, posY, posZ = animation.secondaryPropOptions.posX, animation.secondaryPropOptions.posY, animation.secondaryPropOptions.posZ
            rotX, rotY, rotZ = animation.secondaryPropOptions.rotX, animation.secondaryPropOptions.rotY, animation.secondaryPropOptions.rotZ
            AddPropToPlayer(animation.secondaryPropOptions.model, animation.secondaryPropOptions.bone, posX, posY, posZ, rotX, rotY, rotZ)
        end
    end
end

-- ***********************
--        Commands
-- ***********************
-- WHEN TRIGGERED, CANCEL EMOTE
RegisterCommand("ec", CancelEmote)

-- WHEN TRIGGERED, PERFORM PRONE
RegisterCommand("prone", DoProne)

-- WHEN TRIGGERED, PERFORM CROUCH
RegisterCommand("crouch", DoCrouch)

-- WHEN TRIGGERED, TOGGLE HANDS UP
RegisterCommand("handsup", DoSurrender)

-- WHEN TRIGGERED, TOGGLE RAGDOLL
RegisterCommand("ragdoll", DoRagdoll)

-- WHEN TRIGGERED, PERFORM DOG JUMP
RegisterCommand("dogjump", DoDogJump)

-- WHEN TRIGGERED, SEND A CONFIRMATION TO THE SHARED EMOTE REQUEST
RegisterCommand("acceptemote", function()
    if emotes.hasRequest then
        exports["soe-ui"]:SendAlert("success", "You accepted this emote request!")
        TriggerServerEvent("Emotes:Server:RespondEmoteRequest", {status = true, response = true})
    end
end)

-- WHEN TRIGGERED, SEND A CONFIRMATION TO THE SHARED EMOTE REQUEST
RegisterCommand("denyemote", function()
    if emotes.hasRequest then
        exports["soe-ui"]:SendAlert("error", "You denied this emote request!")
        TriggerServerEvent("Emotes:Server:RespondEmoteRequest", {status = true, response = false})
    end
end)

-- ***********************
--         Events
-- ***********************
-- CALLED FROM SERVER AFTER "/emote" or "/e" IS EXECUTED
RegisterNetEvent("Emotes:Client:PlayAnimation")
AddEventHandler("Emotes:Client:PlayAnimation", PlayAnimation)

-- CALLED FROM SERVER AFTER "/walk" IS EXECUTED
RegisterNetEvent("Emotes:Client:ChangeWalkstyle")
AddEventHandler("Emotes:Client:ChangeWalkstyle", SetWalkstyle)

-- CALLED FROM SERVER AFTER "/mood" IS EXECUTED
RegisterNetEvent("Emotes:Client:PlayExpression")
AddEventHandler("Emotes:Client:PlayExpression", PlayFacialExpression)

-- CALLED FROM SERVER AFTER "/aim" IS EXECUTED
RegisterNetEvent("Emotes:Client:PlayAimingStyle")
AddEventHandler("Emotes:Client:PlayAimingStyle", PlayAimingStyle)

-- WHEN TRIGGERED, DO EMOTE REQUEST NOTIFICATION THINGS
RegisterNetEvent("Emotes:Client:EmoteRequestNotify")
AddEventHandler("Emotes:Client:EmoteRequestNotify", EmoteRequestNotify)

-- WHEN TRIGGERED, FULFILL EMOTE REQUEST WITH THE TARGET IF THEY ACCEPTED
RegisterNetEvent("Emotes:Client:PerformEmoteRequest")
AddEventHandler("Emotes:Client:PerformEmoteRequest", PerformEmoteRequest)

-- WHEN TRIGGERED, LOOK FOR THE CLOSEST PLAYER AND REQUEST A SYNCED EMOTE
RegisterNetEvent("Emotes:Client:GetClosestForSync")
AddEventHandler("Emotes:Client:GetClosestForSync", GetClosestForSync)

-- WHEN TRIGGERED, IF THE MODEL IS A DOG... CANCEL THE SITTING EMOTE
AddEventHandler("BaseEvents:Client:LeftVehicle", function()
    emotes.noPretzeling = false
end)

-- WHEN RESOURCE STOPS OR RESTARTS
AddEventHandler("onResourceStop", function(resource)
    if (GetCurrentResourceName() ~= resource) then return end

    exports["soe-ui"]:PersistentAlert("end", "emoteRequest")
    ClearPedTasksImmediately(PlayerPedId())
    EliminateAllProps()
end)

-- ON RESOURCE START, GRAB POINTING NATIVES
AddEventHandler("onClientResourceStart", function(resource)
    if (GetCurrentResourceName() ~= resource) then return end
    Wait(3500)

    TriggerServerEvent("Emotes:Server:InitResource", {status = true})
    CreatePoleDanceZones()
end)

-- CALLED FROM SERVER TO RESTORE A SAVED WALKSTYLE
RegisterNetEvent("Emotes:Client:GetMyWalkstyle", function(walkstyle)
    if not walkstyle then return end -- RETURN IF IT COMES BACK NIL

    -- SET THE WALKSTYLE
    exports["soe-utils"]:LoadAnimSet(walkstyle, 15)
    SetPedMovementClipset(PlayerPedId(), walkstyle, 1.0)
end)

-- WHEN TRIGGERED, DO DANCE ANIMATION
RegisterNetEvent("Emotes:Client:DoDanceAnim", function(danceSelected)
    local noAnimations = #danceAnimations
    if (danceSelected == -1) then
        danceSelected = math.random(noAnimations)
        exports["soe-ui"]:SendAlert("inform", "You randomly selected dance #" .. danceSelected, 5000)
    end

    if (danceSelected > noAnimations or danceSelected <= 0) then
        exports["soe-ui"]:SendAlert("error", ("There are only %s dances, select a number in between or random (no input)"):format(noAnimations), 5000)
        return
    end

    isPlayingEmote = true
    exports["soe-utils"]:LoadAnimDict(danceAnimations[danceSelected]["dict"], 15)
    TaskPlayAnim(PlayerPedId(), danceAnimations[danceSelected]["dict"], danceAnimations[danceSelected]["anim"], 3.0, 3.0, -1, 1, 0, 0, 0, 0)
end)

-- WHEN TRIGGERED, IF THE MODEL IS A DOG... DO A CERTAIN SIT ANIMATION SO NO PRETZELING
AddEventHandler("BaseEvents:Client:EnteredVehicle", function()
    Wait(50)
    local ped = PlayerPedId()
    if exports["soe-utils"]:IsModelADog(ped) then
        emotes.noPretzeling = true
        exports["soe-utils"]:LoadAnimDict("creatures@rottweiler@in_vehicle@std_car", 15)
        TaskPlayAnim(ped, "creatures@rottweiler@in_vehicle@std_car", "sit", 2.0, 2.0, -1, 32, 0, 0, 0, 0)
        
        -- WHILST DRIVING, THE DOG TENDS TO PRETZEL ITSELF AGAIN. MAKE SURE THIS DOES NOT HAPPEN
        while emotes.noPretzeling do
            Wait(1500)
            if not emotes.noPretzeling then return end
            if not IsEntityPlayingAnim(ped, "creatures@rottweiler@in_vehicle@std_car", "sit", 3) then
                TaskPlayAnim(ped, "creatures@rottweiler@in_vehicle@std_car", "sit", 2.0, 2.0, -1, 32, 0, 0, 0, 0)
            end
        end
    end
end)
