-- ***********************************
--  Local Tow / Coroner / Ambulance
-- ***********************************

-- THIS IS USED DURING CORONER/AMBULANCE FUNCTION, FINDS DEAD PEDS
local function FindDeadPeds(veh, p1, p2)
    DecorRegister("RecoveryTeamLock", 2)
    local handle, ped = FindFirstPed()
    local finished = false
    local state = 1
    TaskLeaveVehicle(p1, veh, 0)
    TaskLeaveVehicle(p2, veh, 0)
    PlayAmbientSpeech1(p1, "GENERIC_HI", "SPEECH_PARAMS_FORCE", 0)
    Wait(1500)
    PlayAmbientSpeech2(p2, "GENERIC_HI", "SPEECH_PARAMS_FORCE", 0)
    ClearRelationshipBetweenGroups(1, GetHashKey("MEDIC"), GetHashKey("PLAYER"))

    repeat
        if IsEntityDead(ped) and IsPedHuman(ped) and not IsPedAPlayer(ped) and DecorExistOn(ped, "RecoveryTeamLock") == false then
            SetEntityAsMissionEntity(ped, true, true)
            exports["soe-utils"]:GetEntityControl(ped)
            DecorSetBool(ped, "RecoveryTeamLock", true)

            TaskGoToEntity(p1, ped, -1, 1.0, 10.0, 1073741824.0, 0)
            TaskGoToEntity(p2, ped, -1, 1.0, 10.0, 1073741824.0, 0)
            Wait(5000)
            TaskLookAtEntity(p1, ped, 2000, 2048, 3)
            Wait(100)
            TaskLookAtEntity(p2, p1, 2000, 2048, 3)
            TaskTurnPedToFaceEntity(p1, ped)
            TaskTurnPedToFaceEntity(p2, p1)
            TaskGoToEntity(p1, ped, -1, 1.0, 10.0, 1073741824.0, 0)
            TaskGoToEntity(p2, ped, -1, 1.0, 10.0, 1073741824.0, 0)
            Wait(2000)
            TaskGoToEntity(p1, ped, -1, 0.5, 10.0, 1073741824.0, 0)
            TaskGoToEntity(p2, ped, -1, 0.5, 10.0, 1073741824.0, 0)
            TaskTurnPedToFaceEntity(p1, ped)
            TaskTurnPedToFaceEntity(p2, ped)

            TaskStartScenarioInPlace(p1, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
            TaskStartScenarioInPlace(p2, "CODE_HUMAN_MEDIC_TIME_OF_DEATH", 0, true)
            PlayAmbientSpeech1(p1, "CHAT_STATE", "SPEECH_PARAMS_FORCE", 0)
            Wait(1500)
            PlayAmbientSpeech2(p2, "CHAT_STATE", "SPEECH_PARAMS_FORCE", 0)
            Wait(9000)

            exports["soe-utils"]:GetEntityControl(ped)

            Wait(1000)
            if (IsPedInAnyVehicle(ped, false)) then
                local ppos = GetEntityCoords(ped)
                SetEntityCoords(ped, ppos, 0.1)
                ClearPedTasks(ped)
            end

            AttachEntityToEntity(ped, p1, 4215, 11816, 0.48, 0.00, 0.0, 0.0, 0.0, 0.0, 0, 0, 1, 1, 2, 1)
            TaskEnterVehicle(p1, veh, 14000, 2, 2.0, 1, 0)
            Wait(2000)
            TaskGoToEntity(p2, p1, -1, 2.0, 2.0, 1073741824, 0)
            TaskEnterVehicle(p2, veh, 14000, 2, 1.0, 1, 0)
            TaskGoToEntity(p2, p1, -1, 2.0, 2.0, 1073741824, 0)
            while (state == 1) do
                Wait(1000)
                if IsPedInVehicle(p1, veh, false) then
                    DetachEntity(ped, true, false)
                    DeleteEntity(ped)
                    SetEntityAsNoLongerNeeded(ped)
                    Wait(2000)
                    TaskLeaveVehicle(p1, veh, 0)
                    TaskLeaveVehicle(p2, veh, 0)
                    Wait(1000)
                    TaskGoToEntity(p1, p2, -1, 1.0, 10.0, 1073741824.0, 0)
                    state = 2
                end
            end
            Wait(1000)
            state = 1
        end
        finished, ped = FindNextPed(handle)
    until not finished
    EndFindPed(handle)
end

-- CALLED FROM "/coroner" OR "/ambulance"
local function SendBodyRecoveryTeam(isCoroner)
    local vModel
    local p1Model
    local p2Model
    local state = 1

    if isCoroner then
        vModel = GetHashKey("speedo")
        p1Model = GetHashKey("s_m_m_doctor_01")
        p2Model = GetHashKey("s_m_y_autopsy_01")
        exports["soe-ui"]:SendAlert("inform", "Local Coroner has been dispatched to your location", 5000)
    else
        vModel = GetHashKey("ambulance")
        p1Model = GetHashKey("s_m_m_paramedic_01")
        p2Model = GetHashKey("s_m_m_paramedic_01")
        exports["soe-ui"]:SendAlert("inform", "Local Ambulance has been dispatched to your location", 5000)
    end

    exports["soe-utils"]:LoadModel(vModel, 100)
    exports["soe-utils"]:LoadModel(p1Model, 100)
    exports["soe-utils"]:LoadModel(p2Model, 100)

    local pos = GetEntityCoords(PlayerPedId())
    local offset = GetOffsetFromEntityInWorldCoords(PlayerPedId(), math.random(50, 150) + 0.0, math.random(50, 150) + 0.0)
    local _, spawn = GetNthClosestVehicleNodeFavourDirection(offset.x, offset.y, offset.z, pos.x, pos.y, pos.z, 0, 1, 0x40400000, 0)

    local veh = CreateVehicle(vModel, spawn.x, spawn.y, spawn.z, heading, true, false)
    local p1 = CreatePedInsideVehicle(veh, 20, p1Model, -1, true, false)
    local p2 = CreatePedInsideVehicle(veh, 20, p2Model, 0, true, false)

    -- GAIN ENTITY CONTROL
    exports["soe-utils"]:GetEntityControl(veh)
    exports["soe-utils"]:GetEntityControl(p1)
    exports["soe-utils"]:GetEntityControl(p2)

    DisableVehicleImpactExplosionActivation(veh, true)
    TaskSetBlockingOfNonTemporaryEvents(p1, true)
    TaskSetBlockingOfNonTemporaryEvents(p2, true)
    SetPedCombatAttributes(p1, 46, false)
    SetPedCombatAttributes(p2, 46, false)
    SetPedKeepTask(p1, true)
    SetPedKeepTask(p2, true)

    -- Failsafe
    SetTimeout(600000, function()
        exports["soe-utils"]:GetEntityControl(veh)
        exports["soe-utils"]:GetEntityControl(p1)
        exports["soe-utils"]:GetEntityControl(p2)

        SetEntityAsMissionEntity(veh, true, true)
        SetEntityAsMissionEntity(p1, true, true)
        SetEntityAsMissionEntity(p2, true, true)
        DeleteEntity(veh)
        DeleteEntity(p1)
        DeleteEntity(p2)
    end)

    -- CREATE BLIP
    local blip = AddBlipForEntity(veh)
    SetBlipScale(blip, 0.82)
    if isCoroner then
        SetBlipColour(blip, 30)
    else
        SetBlipColour(blip, 1)
    end
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    if isCoroner then
        AddTextComponentString("Local Coroner")
    else
        AddTextComponentString("Local Ambulance")
    end
    EndTextCommandSetBlipName(blip)

    SetEntityInvincible(veh)
    SetEntityInvincible(p1)
    SetEntityInvincible(p2)
    SetEntityAsMissionEntity(veh, true, true)
    SetEntityAsMissionEntity(p1, true, true)
    SetEntityAsMissionEntity(p2, true, true)
    NetworkRequestControlOfNetworkId(NetworkGetNetworkIdFromEntity(veh))
    NetworkRequestControlOfNetworkId(NetworkGetNetworkIdFromEntity(p1))
    NetworkRequestControlOfNetworkId(NetworkGetNetworkIdFromEntity(p2))
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(veh), false)
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(p1), false)
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(p2), false)
    SetVehicleSiren(veh, true)

    -- DESTINATION SENDING
    TaskVehicleDriveToCoordLongrange(p1, veh, pos, 15.0, 828, 2.0)
    while (state == 1) do
        local vcoords = GetEntityCoords(veh)
        if GetDistanceBetweenCoords(pos, vcoords, false) <= 35.0 then
            TaskVehicleDriveToCoordLongrange(p1, veh, pos, 8.0, 828, 2.0)
            state = 2
        end
        Wait(100)
    end

    while (state == 2) do
        local vcoords = GetEntityCoords(veh)
        if GetDistanceBetweenCoords(pos, vcoords, false) <= 15.0 then
            TaskVehicleDriveToCoordLongrange(p1, veh, pos, 2.0, 828, 5.0)
            state = 3
        end
        Wait(100)
    end

    Wait(1000)
    while (state == 3) do
        FindDeadPeds(veh, p1, p2)
        state = 4
        Wait(500)
        state = 4
        Wait(1)
    end

    PlayAmbientSpeech1(p1, "GENERIC_BYE", "SPEECH_PARAMS_FORCE", 0)
    Wait(100)
    PlayAmbientSpeech2(p2, "GENERIC_BYE", "SPEECH_PARAMS_FORCE", 0)

    TaskEnterVehicle(p1, veh, 15000, -1, 2.0, 1, 0)
    TaskEnterVehicle(p2, veh, 15000, 0, 2.0, 1, 0)
    Wait(9000)

    while (state == 4) do
        if IsPedInAnyVehicle(p1, true) and IsPedInAnyVehicle(p2, true) then
            state = 5
            Wait(1000)
        else
            TaskEnterVehicle(p1, veh, 15000, -1, 1.0, 1, 0)
            TaskEnterVehicle(p2, veh, 15000, 0, 1.0, 1, 0)
            Wait(1000)
        end
        Wait(100)
    end

    TaskVehicleDriveWander(p1, veh, 15.0, 427)
    Wait(2000)
    SetVehicleSiren(veh, false)
    Wait(60000)
    SetEntityAsNoLongerNeeded(veh)
    SetEntityAsNoLongerNeeded(p1)
    SetEntityAsNoLongerNeeded(p2)
    DeleteEntity(veh)
    DeleteEntity(p1)
    DeleteEntity(p2)
end

-- CALLED FROM "/localtow"
local function SendLocalTow()
	local state = 1
	local towTruck = GetHashKey("flatbed")
	local worker = GetHashKey("s_m_m_dockwork_01")

    local target = exports["soe-utils"]:GetVehInFrontOfPlayer(5.0)
    if (target == nil or target == 0) then
		exports["soe-ui"]:SendAlert("error", "No vehicle found", 4500)
		return
    end
    
    -- ALT
    --TriggerEvent('persistent-vehicles/forget-vehicle', target)    

    exports["soe-utils"]:LoadModel(worker, 15)
    exports["soe-utils"]:LoadModel(towTruck, 15)
    exports["soe-utils"]:GetEntityControl(target)
    exports["soe-ui"]:SendAlert("inform", "Local Tow has been dispatched to your location", 5000)

    local ped = PlayerPedId()
    math.randomseed(GetGameTimer())
    local pos = GetEntityCoords(ped)
    local offset = GetOffsetFromEntityInWorldCoords(ped, math.random(50, 150) + 0.0, math.random(50, 150)+ 0.0, 0)
    local _, spawn = GetNthClosestVehicleNodeFavourDirection(offset.x, offset.y, offset.z, pos.x, pos.y, pos.z, 0, 1, 0x40400000, 0)

    local veh = CreateVehicle(towTruck, spawn.x, spawn.y, spawn.z, heading, true, false)
    local driver = CreatePedInsideVehicle(veh, 20, worker, -1, true, false)

    exports["soe-utils"]:GetEntityControl(driver)
    DisableVehicleImpactExplosionActivation(veh, true)
    TaskSetBlockingOfNonTemporaryEvents(driver, true)
    SetPedCombatAttributes(driver, 46, false)
    SetPedKeepTask(driver, true)

    -- FAILSAFE
    SetTimeout(600000, function()
        exports["soe-utils"]:GetEntityControl(veh)
        exports["soe-utils"]:GetEntityControl(driver)
        DeleteEntity(veh)
        DeleteEntity(driver)
    end)

    -- CREATE BLIP
    local blip = AddBlipForEntity(veh)
    SetBlipScale(blip, 0.82)
    SetBlipColour(blip, 25)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Local Tow")
    EndTextCommandSetBlipName(blip)

    -- PERSISTENCE AND INVINCIBILITY
    SetEntityInvincible(driver)
    SetEntityInvincible(veh)
    SetEntityAsMissionEntity(veh, true, true)
    SetEntityAsMissionEntity(driver, true, true)
    exports["soe-utils"]:GetEntityControl(veh)
    exports["soe-utils"]:GetEntityControl(driver)
    TaskVehicleDriveToCoordLongrange(driver, veh, pos, 15.0, 1074004284, 2.0)

    -- DESTINATING SENDING
    while (state == 1) do
        local vCoords = GetEntityCoords(veh)
        if GetDistanceBetweenCoords(pos, vCoords, false) <= 35.0 then
            TaskVehicleDriveToCoordLongrange(driver, veh, pos, 8.0, 1074004284, 2.0)
            state = 2
        end
        Wait(100)
    end

    while (state == 2) do
        local vCoords = GetEntityCoords(veh)
        if GetDistanceBetweenCoords(pos, vCoords, false) <= 10.0 then
            state = 3
            TaskVehicleDriveToCoordLongrange(driver, veh, pos, 2.0, 262587, 5.0)
        end
        Wait(100)
    end

    while (state == 3) do
        state = 4
        TaskLeaveVehicle(driver, veh, 0)
        TaskGoToEntity(driver, target, -1, 1.0, 10.0, 1073741824.0, 0)
        PlayAmbientSpeech1(driver, "GENERIC_HI", "SPEECH_PARAMS_FORCE", 0)
        Wait(1)
    end

    Wait(3000)
    while not IsPedStill(driver) do
        Wait(100)
    end
    
    TaskLookAtEntity(driver, target, 2000, 2048, 3)
    Wait(9000)

    exports["soe-utils"]:GetEntityControl(target)
    local bone = GetEntityBoneIndexByName(veh, "bodyshell")
    AttachEntityToEntity(target, veh, bone, 0.0, -2.0, 1.0, 0.0, 0.0, 0.0, 1, 1, 1, 0, 1, 1)
    
    -- LEAVE THE AREA AND GET BACK IN THE TOWTRUCK
    while (state == 4) do
        state = 5
        PlayAmbientSpeech1(driver, "GENERIC_BYE", "SPEECH_PARAMS_FORCE", 0)
        Wait(100)

        TaskEnterVehicle(driver, veh, 15000, -1, 2.0, 1, 0)
        Wait(9000)
        if IsPedInAnyVehicle(driver, true) then
            state = 5
            Wait(1000)
        else
            TaskEnterVehicle(driver, veh, 15000, -1, 1.0, 1, 0)
            Wait(3000)
        end
        Wait(100)
    end

    -- WANDER ABOUT AND THEN DESPAWN LATER
    TaskVehicleDriveWander(driver, veh, 15.0, 262587)
    Wait(62000)
    SetEntityAsNoLongerNeeded(veh)
    SetEntityAsNoLongerNeeded(driver)
    DeleteEntity(veh)
    DeleteEntity(driver)

    -- IF VEHICLE IS PERSONAL, PARK IT UP
    local vin = DecorGetInt(target, "vin")
    if (vin ~= 0) then
        TriggerServerEvent("Valet:Server:ParkVehicleByVIN", tonumber(vin), true)
    end
end

-- CALLED FROM SERVER AFTER "/localtow" IS EXECUTED
RegisterNetEvent("AI:Client:SendLocalTow")
AddEventHandler("AI:Client:SendLocalTow", SendLocalTow)

-- CALLED FROM SERVER AFTER "/coroner" OR "/ambulance" IS EXECUTED
RegisterNetEvent("AI:Client:BodyRecoveryTeam")
AddEventHandler("AI:Client:BodyRecoveryTeam", SendBodyRecoveryTeam)
