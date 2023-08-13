local cooldown = 0
isPlayerDead = false

-- ***********************
--     Local Functions
-- ***********************
-- CALCULATES DISTANCE TO THE NEAREST HOSPITAL, CHOOSES ONE
local function GetClosestHospital()
    local minDist = 100000.0
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local closestHospital = vector4(360.66, -585.12, 28.82, 242.03)

    -- FIND THE CLOSEST HOSPITAl, DEFAULT WILL BE PILLBOX
    for _, hospital in pairs(hospitals) do
        local hospitalPos = vector3(hospital.pos.x, hospital.pos.y, hospital.pos.z)
        local dist = #(pos - hospitalPos)
        if (dist < minDist) then
            closestHospital = hospital.pos
            minDist = dist
        end
    end
    return closestHospital
end

-- RANDOMIZE DEATH ANIMATION
local function RandomizeAnimation()
    local anim
    math.randomseed(GetGameTimer())
    local math = math.random(0, 7)
    if (math == 7) then
        anim = "dead_a"
    elseif (math == 6) then
        anim = "dead_b"
    elseif (math == 5) then
        anim = "dead_c"
    elseif (math == 4) then
        anim = "dead_d"
    elseif (math == 3) then
        anim = "dead_e"
    elseif (math == 2) then
        anim = "dead_f"
    else
        anim = "dead_g"
    end
    return anim
end

-- WHEN TRIGGERED, HANDLE EMS-RELATED CAD ALERTS
local function HandleEMSAlerts(call)
    if not call.status then return end

    local code = "10-52"
    local msg = "No further information provided. (ERR-NO-DATA)"
    if call.data.customMsg ~= nil then
        code = "10-78"
        if call.data.customMsg ~= nil then
            msg = ("A caller is reporting '%s'. Call originated from %s with caller ID: %s"):format(call.data.customMsg, call.data.loc, call.src)
        end
    elseif (call.data.type == "Local 911") then
        msg = ("A caller is reporting a medical emergency with unknown circumstances in the area of %s. Medevac ID: %s"):format(call.data.loc, call.src)

        if (exports["soe-jobs"]:GetMyJob() == "EMS") then
            exports["soe-utils"]:PlayProximitySound(3.0, "medical_call.ogg", 0.083)
        end
    elseif (call.data.type == "Robbery") then
        code = "10-90"
        msg = call.data.desc
    elseif (call.data.type == "Fire Alarm") then
        code = "10-70"
        msg = ("Civilians report a large fire at %s."):format(call.data.loc)
    end

    TriggerEvent("Chat:Client:Message", ("[CAD (%s)]"):format(call.time), ("^1[%s] ^7%s"):format(code, msg), "cad")
    if not dispatch.isMuted then
        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    end

    if (call.data.type == "Local 911") then
        local opacity = 95
        local blip = AddBlipForRadius(call.data.pos, 150.0)

        SetBlipColour(blip, 1)
        SetBlipAlpha(blip, opacity)
        SetBlipFlashes(blip, true)
        SetBlipFlashInterval(blip, 550)

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
end

-- WHEN NO PLAYERS ARE DETECTED, REVIVE LOCAL WITH "/revive"
local function ReviveLocal(ped)
    local deadLocal = {}
    local drawableClothes = {}
    local textureClothes = {}
    local drawableProp = {}
    local textureProp = {}

    -- GATHER CLOTHING AND TEXTURE
    for i = 0, 11 do
        drawableClothes[i] = GetPedDrawableVariation(ped, i)
        textureClothes[i] = GetPedTextureVariation(ped, i)
    end

    -- GATHER PROPS AND TEXTURE
    for i = 0, 3 do
        drawableProp[i] = GetPedPropIndex(ped, i)
        textureProp[i] = GetPedPropTextureIndex(ped, i)
    end

    -- FILL THE DATA UP WITH WHAT WE GOT ABOVE
    deadLocal = {
        Model = GetEntityModel(ped),
        Props = {Drawable = drawableProp, Texture = textureProp},
        Clothing = {Drawable = drawableClothes, Texture = textureClothes}
    }

    -- DELETE THE DEAD BODY
    TriggerServerEvent("Utils:Server:DeleteEntity", PedToNet(ped))

    -- RECREATE THE PED WITH THE DATA THAT WE GOT ABOVE
    local pos = GetEntityCoords(ped)
    exports["soe-utils"]:LoadModel(deadLocal.Model, 15)
    local newPed = CreatePed(4, deadLocal.Model, pos, 0.0, true, true)
    for i = 0, 11 do
        SetPedComponentVariation(newPed, i, deadLocal.Clothing.Drawable[i], deadLocal.Clothing.Texture[i], 1)
    end

    for i = 0, 3 do
        SetPedPropIndex(newPed, i, deadLocal.Props.Drawable[i], deadLocal.Props.Texture[i], 1)
    end

    -- HAVE THE PED GO ON THEIR WAY
    TaskWanderStandard(newPed, 10.0, 10)
end

-- MAIN DEATH FUNCTION
local function DiagnoseWithDeath()
    local loopIndex = 0
    local ped = PlayerPedId()
    local myDeadPed = PlayerPedId()
    isPlayerDead = true

    -- START RESPAWN TIMER
    TriggerServerEvent("Emergency:Server:StartRespawnTimer", {status = true})
    exports["soe-uchuu"]:UpdateGamestate("dead", false)
    Wait(1000)

    -- IF SOMEONE DIES IN A VEHICLE, CHECK WHAT SEAT THE PLAYER IS IN
    local seat
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if (veh ~= 0) then
        for i = -1, GetVehicleMaxNumberOfPassengers(veh) do
            if (GetPedInVehicleSeat(veh, i) == ped) then
                seat = i
            end
        end
    end

    -- REVIVE THE PLAYER BUT PUT THEM INTO RAGDOLL LATER
    local pos = GetEntityCoords(ped)
    local hdg = GetEntityHeading(ped)
    NetworkResurrectLocalPlayer(pos, hdg, true, true, false)

    -- DELETE DUPLICATE PED
    Wait(100)
    ped = PlayerPedId()
    if (myDeadPed ~= ped) then
        DeleteEntity(myDeadPed)
    end

    -- IF DIED IN A VEHICLE, PUT THEM BACK INTO THE SEAT
    if seat then
        SetPedIntoVehicle(ped, veh, seat)
    end

    -- RANDOMIZE DEATH ANIMATION AND PLAY IT
    local anim = RandomizeAnimation()
    exports["soe-utils"]:LoadAnimDict("dead", 15)
    exports["soe-utils"]:LoadAnimDict("veh@low@front_ps@idle_duck", 15)
    exports["soe-utils"]:LoadAnimDict("creatures@rottweiler@amb@sleep_in_kennel@", 15)
    if not IsPedSittingInAnyVehicle(ped) then
        if not exports["soe-utils"]:IsModelADog(ped) then
            TaskPlayAnim(ped, "dead", anim, 8.0, -8, -1, 1, 0, 0, 0, 0, 0)
        else
            TaskPlayAnim(ped, "creatures@rottweiler@amb@sleep_in_kennel@", "sleep_in_kennel", 8.0, -8, -1, 1, 0, 0, 0, 0, 0)
        end
    else
        if not exports["soe-utils"]:IsModelADog(ped) then
            TaskPlayAnim(ped, "veh@low@front_ps@idle_duck", "sit", 1.0, 1.0, -1, 32, 0, 0, 0, 0)
        end
    end

    local text = "Dial 911 and wait for SAFR!"
    if (GetCurrentEMS() == 0) then
        text = "Dial 911 or wait to do /respawn"
    end
    exports["soe-ui"]:DisplayText(text)
    TriggerEvent("Emergency:Client:DeathFromAbove")

    SetEntityInvincible(ped, true)
    while isPlayerDead do
        Wait(5)
        ped = PlayerPedId()
        DisableControlAction(0, 37, true)
        DisableControlAction(0, 24, true)
        DisableControlAction(0, 25, true)
        DisableControlAction(0, 257, true)
        DisableControlAction(2, 34, true)
        DisableControlAction(2, 35, true)
        for i = 59, 90 do
            DisableControlAction(2, i, true)
        end

        loopIndex = loopIndex + 1
        if (loopIndex % 30 == 0) then
            SetEntityHealth(ped, 200)
            SetEntityInvincible(ped, true)
        end

        if (loopIndex % 75 == 0) then
            loopIndex = 0
            if not IsPedSittingInAnyVehicle(ped) then
                if not exports["soe-utils"]:IsModelADog(ped) then
                    if not IsEntityPlayingAnim(ped, "dead", anim, 3) then
                        TaskPlayAnim(ped, "dead", anim, 8.0, -8, -1, 1, 0, 0, 0, 0)
                    end
                else
                    if not IsEntityPlayingAnim(ped, "creatures@rottweiler@amb@sleep_in_kennel@", "sleep_in_kennel", 3) then
                        TaskPlayAnim(ped, "creatures@rottweiler@amb@sleep_in_kennel@", "sleep_in_kennel", 8.0, -8, -1, 1, 0, 0, 0, 0, 0)
                    end
                end
            else
                -- IF BEING PULLED OUT, STOP THE ANIMATION TO ALLOW PULLOUT
                if not exports["soe-utils"]:IsModelADog(ped) then
                    -- IF NOT BEING PULLED OUT, DO VEHICLE DEATH ANIMATION
                    if not IsEntityPlayingAnim(ped, "veh@low@front_ps@idle_duck", "sit", 3) then
                        TaskPlayAnim(ped, "veh@low@front_ps@idle_duck", "sit", 1.0, 1.0, -1, 32, 0, 0, 0, 0)
                    end
                end
            end
        end
    end

    Wait(500)
    isPlayerDead = false
    ClearPedTasks(ped)
    SetEntityInvincible(ped, false)
    exports["soe-uchuu"]:UpdateGamestate("dead", true, false)
    exports["soe-ui"]:HideOnscreenText()
    exports["soe-emotes"]:RestoreSavedWalkstyle()
end

-- ***********************
--     Global Functions
-- ***********************
-- RETURNS IF PLAYER IS DEAD
function IsDead()
    return isPlayerDead
end

-- ***********************
--        Commands
-- ***********************
-- WHEN TRIGGERED, SEND EMS AN ALERT
RegisterCommand("local911", function(source, args)
    -- STOP IF THERE IS A COOLDOWN
    if (cooldown > GetGameTimer()) then
        exports["soe-ui"]:SendAlert("error", "Wait a bit before doing that again", 5000)
        return
    end

    -- 15 SECOND COOLDOWN
    cooldown = GetGameTimer() + 30000
    local pos = GetEntityCoords(PlayerPedId())
    local loc = exports["soe-utils"]:GetLocation(pos)

    -- CONSTRUCT CUSTOM MESSAGE
    local msg
    if #args > 1 then
        msg = args[1]
    end

    for i = 2, #args do
        msg = msg .. " " .. args[i]
    end

    TriggerServerEvent("Emergency:Server:EMSAlerts", {status = true, global = true, type = "Local 911", loc = loc, pos = pos, customMsg = msg})
end)

-- ***********************
--         Events
-- ***********************
-- WHEN TRIGGERED, START DEATH PROCESS
AddEventHandler("BaseEvents:Client:OnPlayerDied", DiagnoseWithDeath)

-- WHEN TRIGGERED, START DEATH PROCESS
AddEventHandler("BaseEvents:Client:OnPlayerMurder", DiagnoseWithDeath)

-- WHEN TRIGGERED, HANDLE EMS-RELATED CAD ALERTS
RegisterNetEvent("Emergency:Client:EMSAlerts")
AddEventHandler("Emergency:Client:EMSAlerts", HandleEMSAlerts)

-- CALLED FROM THE SERVER AFTER "/revive" AND ITS PRE-REQUISITE CLIENT EVENT "Emergency:Client:Revive" IS CALLED
RegisterNetEvent("Emergency:Client:RevivePlayer")
AddEventHandler("Emergency:Client:RevivePlayer", function()
    local ped = PlayerPedId()
    if isPlayerDead or IsEntityDead(ped) then
        isPlayerDead = false
        ClearPedBloodDamage(ped)
        SetEntityHealth(ped, 130)
        ClearPedTasksImmediately(ped)
        FreezeEntityPosition(ped, false)

        if not exports["soe-utils"]:IsModelADog(ped) then
            if not IsPedSittingInAnyVehicle(ped) then
                exports["soe-utils"]:LoadAnimDict("get_up@directional@movement@from_knees@injured", 15)
                TaskPlayAnim(ped, "get_up@directional@movement@from_knees@injured", "getup_l_0", 8.0, 1.0, 1250, 1, 0, 0, 0, 0)
            end
        end
    end
end)

-- CALLED FROM SERVER TO DETERMINE WHETHER TO REVIVE A LOCAL OR PLAYER
RegisterNetEvent("Emergency:Client:Revive", function(animalOnly)
    local authorized = true
    local ped = exports["soe-utils"]:GetPedInFrontOfPlayer(5.0)

    if (ped ~= nil and ped ~= 0) and IsEntityDead(ped) and not IsPedAPlayer(ped) then
        if animalOnly then
            if (GetPedType(ped) ~= 28) then
                authorized = false
                exports["soe-ui"]:SendAlert("error", "This must be an animal!", 5000)
            end
        end

        if authorized then
            ReviveLocal(ped)
        end
    else
        local player = exports["soe-utils"]:GetClosestPlayer(5)
        if (player ~= nil) then
            if animalOnly then
                if (GetPedType(GetPlayerPed(player)) ~= 28) then
                    authorized = false
                    exports["soe-ui"]:SendAlert("error", "This must be an animal!", 5000)
                end
            end

            if authorized then
                local char = exports["soe-uchuu"]:GetPlayer()
                TriggerServerEvent("Emergency:Server:RevivePlayer", GetPlayerServerId(player), char)
            end
        end
    end
end)

-- RESPAWNING CALLED FROM SERVER
RegisterNetEvent("Emergency:Client:DoRespawn")
AddEventHandler("Emergency:Client:DoRespawn", function()
    -- MAKE SURE PLAYER IS DEAD
    if not isPlayerDead then return end

    -- GET THE CLOSEST HOSPITAL AND TELEPORT TO THERE
    local ped = PlayerPedId()
    DoScreenFadeOut(500)
    DetachEntity(ped)
    Wait(1000)
    DoScreenFadeIn(500)

    local pos
    exports["soe-fidelis"]:AuthorizeTeleport()
    if not exports["soe-prison"]:IsImprisoned() then
        -- IF NOT IMPRISONED, SEND TO NEAREST HOSPITAL
        pos = GetClosestHospital()
        SetEntityCoords(ped, pos)
        SetEntityHeading(ped, pos.w)
    else
        -- TELEPORT PLAYER TO PRISON INFIRMARY IF JAILED
        pos = vector4(1777.65, 2560.14, 45.8, 272.5)
        SetEntityCoords(ped, pos)
        SetEntityHeading(ped, pos.w)
    end

    -- RESET PED PROPERTIES AND STATES
    ClearPedTasksImmediately(ped)
    ClearPedBloodDamage(ped)
    SetEntityHealth(ped, 175)

    isPlayerDead = false
    FreezeEntityPosition(ped, false)
    exports["soe-nutrition"]:SetLevels(250, 250)
    exports["soe-healthcare"]:HealInjuriesAndBleeding()
    exports["soe-emotes"]:RestoreSavedWalkstyle()
end)
