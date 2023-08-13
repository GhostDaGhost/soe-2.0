local action
local towing = {}
local cooldown = 0
local height = 0.25
local currentlyTowing = {}
local alreadyLowering = false

-- DECORATORS
DecorRegister("isRaised", 2)

-- KEY MAPPINGS
RegisterKeyMapping("tow_spawntruck", "[Jobs] Spawn Tow Truck", "KEYBOARD", "G")
RegisterKeyMapping("finalizetow", "[Tow] Finalize Position", "KEYBOARD", "RETURN")

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, REMOVE AI TOW CALL BLIP WHEN IT HAS BEEN TAKEN
local function RemoveAITowCallBlips(data)
    if not data.status then return end
    if not data.callID then return end

    -- REMOVE BLIPS IF ANY AND UPDATE LOCAL CALL TABLE
    towing.calls = data.callList
    if (towing.blips[data.callID] ~= nil) then
        RemoveBlip(towing.blips[data.callID])
        towing.blips[data.callID] = nil
    end
end

-- WHEN TRIGGERED, REMOVE ALL BLIPS ON REQUEST
local function ClearTowCalls(data)
    if not data.status then return end

    -- REMOVE ALL TOW CALL BLIPS
    if (towing.blips ~= nil) then
        for _, blip in pairs(towing.blips) do
            RemoveBlip(blip)
        end
        towing.blips = {}
    end
end

-- WHEN TRIGGERED, REQUEST A TOW TRUCK AND PROVIDE INFORMATION
local function RequestTowTrucks(data)
    if not data.status then return end

    -- CHECK FOR THE EXISTENCE OF TARGET VEHICLE
    local veh = exports["soe-utils"]:GetVehInFrontOfPlayer(3.0)
    if not veh then
        exports["soe-ui"]:SendAlert("error", "No vehicle found", 5000)
        return
    end

    -- GET BASIC VEHICLE INFORMATION
    local pos = GetEntityCoords(veh)
    local zone = tostring(GetNameOfZone(pos.x, pos.y, pos.z))
    local name = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh)))
    --TriggerEvent("persistent-vehicles/register-vehicle", veh)

    -- FINALLY SEND THE SERVER THE DATA WE GATHERED HERE TODAY
    TriggerServerEvent("Jobs:Server:RequestTowTruck", {status = true, pos = pos, zone = zone, veh = VehToNet(veh), name = name,
        loc = exports["soe-utils"]:GetLocation(pos)
    })
end

-- WHEN TRIGGERED, CREATE A NEW TOW CALL BASED OFF RECEIVED DATA
local function NewTowCall(data)
    if not data.status then return end
    if not data.call then return end

    -- DO SOME SAFETY CHECKS AND DO A SOUND
    exports["soe-utils"]:PlaySound("radio_chatter.ogg", exports["soe-utils"]:GetSoundLevel(), true)
    if not towing.blips then
        towing.blips = {}
    end

    -- START CREATING BLIPS FOR THE TOW CALL
    towing.blips[data.call.jobID] = AddBlipForCoord(data.call.pos)
    SetBlipSprite(towing.blips[data.call.jobID], 68)
    if data.call.isLocal then
        SetBlipColour(towing.blips[data.call.jobID], 47)
    else
        SetBlipColour(towing.blips[data.call.jobID], 11)
    end
    SetBlipScale(towing.blips[data.call.jobID], 0.95)
    SetBlipFlashes(towing.blips[data.call.jobID], true)
    SetBlipFlashInterval(towing.blips[data.call.jobID], 550)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Tow Call #" .. data.call.jobID)
    EndTextCommandSetBlipName(towing.blips[data.call.jobID])

    -- FORCE A CALL GRABBER JUST IN CASE
    towing.calls = exports["soe-nexus"]:TriggerServerCallback("Jobs:Server:GetTowCalls")
end

-- WHEN TRIGGERED, CATCH THE PLAYER UP ON THE PREVIOUS CALLS
local function CatchupCalls()
    if (towing.calls ~= nil) then
        for _, callData in pairs(towing.calls) do
            local msg = ("Pending impound job. Call Tag ^2%s^7 in ^3%s^7. The vehicle will be a ^5%s^7, reference map for more details."):format(callData.jobID, callData.loc, callData.name)
            TriggerEvent("Chat:Client:Message", "[Tow Dispatch]", msg, "cad")
            if not towing.blips then
                towing.blips = {}
            end

            towing.blips[callData.jobID] = AddBlipForCoord(callData.pos)
            SetBlipSprite(towing.blips[callData.jobID], 68)
            if callData.isLocal then
                SetBlipColour(towing.blips[callData.jobID], 47)
            else
                SetBlipColour(towing.blips[callData.jobID], 11)
            end
            SetBlipScale(towing.blips[callData.jobID], 0.95)
            SetBlipFlashes(towing.blips[callData.jobID], true)
            SetBlipFlashInterval(towing.blips[callData.jobID], 550)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Tow Call #" .. callData.jobID)
            EndTextCommandSetBlipName(towing.blips[callData.jobID])
        end
    end
end

-- WHEN TRIGGERED, SPAWN THE CAR IN NEED OF TOW FROM AI CALLING
local function CreateVehicleNeedingTow(callData)
    -- LOAD VEHICLE MODEL UP FIRST
    exports["soe-utils"]:LoadModel(callData.hash, 15)

    -- CHECK IF VEHICLE SPAWNED ALREADY OR NOT
    local hasSpawnedAlready = exports["soe-nexus"]:TriggerServerCallback("Jobs:Server:GetTowCallVehicleStatus", callData.jobID)
    if hasSpawnedAlready then return end

    TriggerServerEvent("Jobs:Server:UpdateTowCallVehicleStatus", {status = true, jobID = callData.jobID})
    TriggerServerEvent("Utils:Server:ClearVehiclesInRadius", callData.pos.x, callData.pos.y, callData.pos.z, 3.0)
    Wait(1250)

    local veh = CreateVehicle(callData.hash, callData.pos.x, callData.pos.y, callData.pos.z, callData.pos.w, true, true)
    while not DoesEntityExist(veh) do
        Wait(250)
    end

    local netID = NetworkGetNetworkIdFromEntity(veh)
    NetworkSetNetworkIdDynamic(netID, false)
    SetNetworkIdCanMigrate(netID, true)
    SetNetworkIdExistsOnAllMachines(netID, true)

    SetModelAsNoLongerNeeded(callData.hash)
    exports["soe-utils"]:GetEntityControl(veh)

    local randColor = GetRandomIntInRange(1, 156)
    SetVehicleColours(veh, randColor, randColor)

    SetEntityAsMissionEntity(veh, true)
    local plate = GetVehicleNumberPlateText(veh)
    local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh)))
    TriggerServerEvent("Emergency:Server:ImpoundVehicle", model, plate, true, true)

    SetVehicleEngineHealth(veh, 100)
    SetVehicleUndriveable(veh, true)
    SetVehicleDoorsLocked(veh, 1)
    DecorSetBool(veh, "unlocked", false)
    TriggerServerEvent("Jobs:Server:UpdateTowCallVehicleStatus", {status = true, jobID = callData.jobID, netID = netID})
end

-- FUNCTION TO SPAWN TOW TRUCK
local function ManageTowtruck(pos, needsSpawning)
    if needsSpawning then
        if (cooldown > GetGameTimer()) then
            exports["soe-ui"]:SendAlert("error", "Wait a bit before doing that again", 5000)
            return
        end

        -- SPAWN FLATBED AND GIVE PLAYER THE KEYS
        cooldown = GetGameTimer() + 5000
        TriggerServerEvent("Utils:Server:ClearVehiclesInRadius", pos.x, pos.y, pos.z, 3.0)
        exports["soe-ui"]:SendAlert("warning", "Getting your truck out now...", 4000)
        Wait(3500)
        towing.veh = exports["soe-utils"]:SpawnVehicle("flatbed", pos)
        local plate = exports["soe-utils"]:GenerateRandomPlate()
        SetVehicleNumberPlateText(towing.veh, plate)
        Wait(500)

        -- SET IT AS A RENTAL
        exports["soe-utils"]:SetRentalStatus(towing.veh)
        SetEntityAsMissionEntity(towing.veh, true, true)
        Wait(250)
        exports["soe-valet"]:UpdateKeys(towing.veh)
        DecorSetBool(towing.veh, "noInventoryLoot", true)
    else
        -- IF FLATBED IS IN PROXIMITY, DESPAWN IT
        if #(GetEntityCoords(towing.veh) - vector3(pos.x, pos.y, pos.z)) <= 26.5 then
            --exports["soe-valet"]:RemoveKey(towing.veh)
            TriggerServerEvent("Utils:Server:DeleteEntity", VehToNet(towing.veh))
        else
            if towing.veh then
                local plate = GetVehicleNumberPlateText(towing.veh)
                TriggerServerEvent("Emergency:Server:MarkStolen", plate, true, true)
                exports["soe-ui"]:SendAlert("error", "The tow master does not see the flatbed anywhere. They reported it stolen.")
            end
        end
        towing.veh = nil
    end
end

-- WHEN TRIGGERED, START A LOOP TO DETECT IF NEAR A VEHICLE TO MARK IT
local function StartSpawningCalledVehicles()
    local loopIndex = 0
    while isOnDuty do
        Wait(1550)
        loopIndex = loopIndex + 1
        if (loopIndex % 5 == 0) then
            loopIndex = 0
            towing.calls = exports["soe-nexus"]:TriggerServerCallback("Jobs:Server:GetTowCalls")
        end

        if (towing.calls ~= nil) then
            local pos = GetEntityCoords(PlayerPedId())
            local myZone = GetNameOfZone(pos.x, pos.y, pos.z)

            for _, data in pairs(towing.calls) do
                if (data.zone == myZone) then
                    local spawnVehicle = false
                    local dist = #(pos - vector3(data.pos.x, data.pos.y, data.pos.z))
                    if not data.spawned and dist <= 150.0 then
                        spawnVehicle = true
                        if not towing.spawnedVehicles then
                            towing.spawnedVehicles = {}
                        end
                    elseif data.veh ~= 0 and data.isLocal then
                        local veh = NetToVeh(data.veh)
                        if not DoesEntityExist(veh) then
                            TriggerServerEvent("Jobs:Server:UpdateTowCallVehicleStatus", {status = true, jobID = data.jobID})
                        end
                    end

                    if data.spawned then
                        if (dist <= 50.0) then
                            TriggerServerEvent("Jobs:Server:RemoveTowCallFromList", {status = true, callID = data.jobID})
                            TriggerServerEvent("Jobs:Server:TowCallTakenAlert", {status = true, callID = data.jobID})
                        end
                    end

                    -- ADD TO LOCAL SPAWNED LIST TO HOPEFULLY PREVENT MULTI SPAWNING
                    if spawnVehicle and not towing.spawnedVehicles[data.jobID] then
                        towing.spawnedVehicles[data.jobID] = true
                        CreateVehicleNeedingTow(data)
                    end
                end
            end
        else
            towing.calls = exports["soe-nexus"]:TriggerServerCallback("Jobs:Server:GetTowCalls")
        end
    end
end

-- TOGGLES TOWING DUTY
local function ToggleDuty(state)
    if state then
        if (cooldown > GetGameTimer()) then
            exports["soe-ui"]:SendAlert("error", "Wait a bit before doing that again", 5000)
            return
        end

        if action then
            exports["soe-ui"]:ShowTooltip("fas fa-truck-loading", "[E] Quit Job | [G] Spawn Truck", "inform")
        end

        TriggerServerEvent("Jobs:Server:ToggleDuty", {status = true, dutyStatus = true, job = "TOW"})
        exports["soe-ui"]:SendAlert("inform", "Make sure to grab a radio while you're at it! Channel 5!", 10000)
        towing.calls = exports["soe-nexus"]:TriggerServerCallback("Jobs:Server:GetTowCalls")

        -- CATCH THE PERSON UP ON THE CALLS
        CatchupCalls()

        -- START GENERAL RUNTIME FOR TOWING
        StartSpawningCalledVehicles()
    else
        cooldown = GetGameTimer() + 5000
        if action then
            exports["soe-ui"]:ShowTooltip("fas fa-truck-loading", "[E] Start Job", "inform")
        end

        ManageTowtruck(action.spawnLoc, false)
        TriggerServerEvent("Jobs:Server:ToggleDuty", {status = true, dutyStatus = false, job = "TOW"})

        -- REMOVE ALL TOW CALL BLIPS
        if (towing.blips ~= nil) then
            for _, blip in pairs(towing.blips) do
                RemoveBlip(blip)
            end
            towing.blips = {}
        end
    end
end

-- WHEN TRIGGERED, CHECK IF VEHICLE IS NEAR IMPOUND CIRCLE AND DO IT
local function AttemptToImpoundVehicle(veh)
    local found
    local pos = GetEntityCoords(veh)
    for _, dropoff in pairs(towingDropoffs) do
        if #(pos - dropoff) <= 6.5 then
            found = dropoff
            break
        end
    end

    if found then
        local hasImpoundSticker = exports["soe-nexus"]:TriggerServerCallback("Emergency:Server:IsVehicleMarkedForImpound", GetVehicleNumberPlateText(veh))
        if hasImpoundSticker then
            PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
            exports["soe-ui"]:SendAlert("inform", "Impounding vehicle...", 3500)
            Wait(4000)
            -- IF VEHICLE IS PERSONAL, PARK IT UP
            if (DecorGetInt(veh, "vin") ~= 0) then
                exports["soe-nexus"]:TriggerServerCallback("Valet:Server:ParkVehicle", NetworkGetNetworkIdFromEntity(veh), veh, "Davis Impound Lot", GetVehicleNumberPlateText(veh))
            end

            -- ALT
            ----TriggerEvent('persistent-vehicles/forget-vehicle', veh)

            -- DELETE THE VEHICLE
            TriggerServerEvent("Utils:Server:DeleteEntity", VehToNet(veh))
            TriggerServerEvent("Jobs:Server:PayTowTruckDriver", {status = true})
        else
            exports["soe-ui"]:SendAlert("warning", "You notice that there is no impound sticker on that vehicle", 7500)
        end
    end
end

-- WHEN TRIGGERED, RAISE VEHICLE AND DO VARIOUS TASKS
local function RaiseVehicle()
    -- FIND THE CLOSEST VEHICLE AND NIL CHECK IT
    local veh = exports["soe-utils"]:GetVehInFrontOfPlayer(3.0)
    if not veh then
        exports["soe-ui"]:SendAlert("error", "Vehicle not found!", 5000)
        return
    end

    -- CHECK IF THIS VEHICLE WAS ALREADY RAISED
    if not DecorGetBool(veh, "isRaised") then
        local ped = PlayerPedId()
        local model = GetEntityModel(veh)
        if IsVehicleStopped(veh) and IsVehicleSeatFree(veh, -1) and IsThisModelACar(model) and not IsPedSittingInAnyVehicle(ped) then
            exports["soe-ui"]:SendAlert("warning", "Raising...", 5000)
            TriggerServerEvent("Jobs:Server:SyncCarlifting", {status = true, type = "Raise", veh = VehToNet(veh)})
        end
    else
        exports["soe-ui"]:SendAlert("error", "This vehicle was already raised!")
    end
end

-- WHEN TRIGGERED, SYNC CARLIFTING OR LOWERING
local function SyncCarlifting(data)
    if not data.status then return end
    if not data.type then return end

    local ped = PlayerPedId()
    local veh = NetToVeh(data.veh)
    local pos = GetEntityCoords(veh)

    if (data.type == "Raise") then
        -- SET DECORATOR AND FREEZE VEHICLE INTO POSITION
        DecorSetBool(veh, "isRaised", true)
        FreezeEntityPosition(veh, true)

        local addZ = 0
        while (addZ < height) do
            Wait(75)
            addZ = addZ + 0.003
            SetEntityCoordsNoOffset(veh, pos.x, pos.y, pos.z + addZ, true, true, true)
        end
    elseif (data.type == "Lower") then
        exports["soe-utils"]:GetEntityControl(veh)
        local removeZ = 0
        while (removeZ < height) do
            Wait(75)
            removeZ = removeZ + 0.003
            SetEntityCoordsNoOffset(veh, pos.x, pos.y, pos.z - removeZ, true, true, true)
        end

        FreezeEntityPosition(veh, false)
        DecorSetBool(veh, "isRaised", false)
    end
end

-- MAIN TOWING/UN-TOWING FUNCTION
local function TowVehicle(spot)
    local ped = PlayerPedId()
    if IsPedSittingInAnyVehicle(ped) then return end

    local veh = exports["soe-utils"]:GetVehInFrontOfPlayer(5.0)
    if (veh ~= 0) then
        local aNum = 1
        if spot then
            aNum = spot
            if (aNum > 6) then
                aNum = 6
            end
        end

        local towVeh = GetVehiclePedIsIn(ped, true)
        local aVeh = towVeh

        local towVehBack = GetModelDimensions(GetEntityModel(towVeh))
        local vehBack, vehFront = GetModelDimensions(GetEntityModel(veh))
        local hasTrailer, trailer = GetVehicleTrailerVehicle(towVeh)
        if hasTrailer then
            towVeh, offset = trailer, -20.0
            if not towingData[GetEntityModel(towVeh)] then return end
        end

        if (towingData[GetEntityModel(towVeh)] == nil) then return end
        local offset = (towingData[GetEntityModel(towVeh)].offset or -16.5)
        local attached = currentlyTowing[VehToNet(towVeh)]
        if (GetEntityModel(towVeh) == GetHashKey("tr2")) then
            if not currentlyTowing[VehToNet(towVeh)] then
                currentlyTowing[VehToNet(towVeh)] = {}
            end
            attached = currentlyTowing[VehToNet(towVeh)][aNum]
        end

        local bone = (towingData[GetEntityModel(towVeh)].bone or GetEntityBoneIndexByName(towVeh, "bodyshell"))
        if (attached == nil) then
            if (veh ~= towVeh) then
                if (veh == aVeh) then return end
                if (veh ~= 0) then
                    exports["soe-utils"]:GetEntityControl(veh)
                    exports["soe-utils"]:GetEntityControl(towVeh)

                    local model = GetEntityModel(towVeh)
                    if towingData[model] ~= nil then
                        local class = GetVehicleClass(veh)
                        if towingData[model]["whitelist"] then
                            if towingData[model]["whitelist"][class] == nil then
                                exports["soe-ui"]:SendAlert("error", "This vehicle cannot be towed by this vehicle", 5000)
                                return
                            end
                        end

                        exports["soe-ui"]:SendAlert("inform", "Press [ ↑ ] to Raise Vehicle", 9500)
                        exports["soe-ui"]:SendAlert("inform", "Press [ ↓ ] to Lower Vehicle", 9500)

                        -- ONLY SHOW THIS MESSAGE IF NOT 6 CAR TRAILER
                        if model ~= GetHashKey("tr2") then
                            exports["soe-ui"]:SendAlert("inform", "Press [ → ] to Move Vehicle Forwards", 9500)
                            exports["soe-ui"]:SendAlert("inform", "Press [ ← ] to Move Vehicle Backwards", 9500)

                            -- SHOW MESSAGE DIFFERENT MESSAGE IF MODEL IS A SLAMTRUCK
                            if model ~= GetHashKey("slamtruck") then
                                exports["soe-ui"]:SendAlert("inform", "Press [Q] to Rotate Vehicle Left", 9500)
                                exports["soe-ui"]:SendAlert("inform", "Press [E] to Rotate Vehicle Right", 9500)
                            else
                                exports["soe-ui"]:SendAlert("inform", "Press [Q] to Tilt Vehicle Forwards", 9500)
                                exports["soe-ui"]:SendAlert("inform", "Press [E] to Tilt Vehicle Backwards", 9500)
                            end
                        end

                        exports["soe-ui"]:SendAlert("inform", "Press [Enter] to Finalize Position", 9500)

                        if model ~= GetHashKey("tr2") then
                            if vehFront.y - vehBack.y <= towingData[model].maxLength then
                                if towingData[model].class[class] == nil then
                                    offset = towingData[model].default
                                end
                                local nOffset = offset.z
                                AttachEntityToEntity(veh, towVeh, bone, offset.x, offset.y, nOffset, 0.0, 0.0, 0.0, 1, 1, 1, 0, 1, 1)
                                local addedY = 0.0
                                local addedZ = 0.0
                                local addedRot = 0.0

                                towing.inLoop = true
                                towing.finalized = false
                                while towing.inLoop do
                                    Wait(5)
                                    DisableControlAction(0, 172) -- Arrow Up
                                    DisableControlAction(0, 173) -- Arrow Down
                                    DisableControlAction(0, 174) -- Arrow Left
                                    DisableControlAction(0, 175) -- Arrow Right
                                    DisableControlAction(0, 44) -- Q
                                    DisableControlAction(0, 51) -- E

                                    -- ADJUST HEIGHT
                                    if IsDisabledControlPressed(0, 172) then
                                        addedZ = addedZ + 0.01
                                        if addedZ > 0.4 then
                                            addedZ = 0.4
                                        end
                                    elseif IsDisabledControlPressed(0, 173) then
                                        addedZ = addedZ - 0.01
                                        if addedZ < -0.4 then
                                            addedZ = -0.4
                                        end
                                    end

                                    -- ADJUST FORWARD/BACKWARDS, ROTATION OR TILT IF NOT 6 CAR TRAILER
                                    if model ~= GetHashKey("tr2") then
                                        if IsDisabledControlPressed(0, 174) then
                                            addedY = addedY - 0.01
                                            if addedY < -0.4 then
                                                addedY = -0.4
                                            end
                                        elseif IsDisabledControlPressed(0, 175) then
                                            addedY = addedY + 0.01
                                            if addedY > 0.4 then
                                                addedY = 0.4
                                            end
                                        elseif IsDisabledControlPressed(0, 44) then
                                            addedRot = addedRot + 0.25
                                        elseif IsDisabledControlPressed(0, 51) then
                                            addedRot = addedRot - 0.25
                                        end
                                    end

                                    -- FINISHED SETTING POSITION AND EXIT LOOP
                                    if towing.finalized then
                                        towing.inLoop = false
                                        break
                                    end

                                    -- IF NOT SLAM TRUCK MODIFY ROTATION ELSE MODIFY TILT
                                    if model ~= GetHashKey("slamtruck") then
                                        AttachEntityToEntity(veh, towVeh, bone, offset.x, offset.y + addedY, nOffset + addedZ, 0.0, 0.0, 0.0 + addedRot, 1, 1, 1, 0, 1, 1)
                                    else
                                        AttachEntityToEntity(veh, towVeh, bone, offset.x, offset.y + addedY, nOffset + addedZ, 0.0 + addedRot, 0.0, 0.0, 1, 1, 1, 0, 1, 1)
                                    end
                                end
                                towing.finalized = false

                                Wait(100)
                                exports["soe-utils"]:GetEntityControl(veh)
                                exports["soe-utils"]:GetEntityControl(towVeh)

                                -- IF NOT SLAM TRUCK MODIFY ROTATION ELSE MODIFY TILT
                                if model ~= GetHashKey("slamtruck") then
                                    AttachEntityToEntity(veh, towVeh, bone, offset.x, offset.y + addedY, nOffset + addedZ, 0.0, 0.0, 0.0 + addedRot, 1, 1, 1, 0, 1, 1)
                                else
                                    AttachEntityToEntity(veh, towVeh, bone, offset.x, offset.y + addedY, nOffset + addedZ, 0.0 + addedRot, 0.0, 0.0, 1, 1, 1, 0, 1, 1)
                                end

                                TriggerServerEvent("Jobs:Server:UpdateTowData", VehToNet(towVeh), VehToNet(veh))
                            end
                        else
                            if not towingData[model][aNum] then return end
                            AttachEntityToEntity(veh, towVeh, bone, towingData[model][aNum].pos, towingData[model][aNum].rot, 0.0, 0.0, 1, 1, 1, 0, 1, 1)
                            local nOffset = towingData[model][aNum].pos.z
                            local addedZ = 0.0

                            towing.inLoop = true
                            towing.finalized = false
                            while towing.inLoop do
                                Wait(5)
                                DisableControlAction(0, 44)
                                DisableControlAction(0, 51)
                                if IsDisabledControlPressed(0, 44) then
                                    addedZ = addedZ - 0.01
                                    if addedZ < -0.4 then
                                        addedZ = -0.4
                                    end
                                elseif IsDisabledControlPressed(0, 51) then
                                    addedZ = addedZ + 0.01
                                    if addedZ > 0.4 then
                                        addedZ = 0.4
                                    end
                                elseif towing.finalized then
                                    towing.inLoop = false
                                    break
                                end
                                AttachEntityToEntity(veh, towVeh, bone, towingData[model][aNum].pos.x, towingData[model][aNum].pos.y, nOffset + addedZ, towingData[model][aNum].rot, 0.0, 0.0, 1, 1, 1, 0, 1, 1)
                            end
                            towing.finalized = false

                            Wait(100)
                            exports["soe-utils"]:GetEntityControl(veh)
                            exports["soe-utils"]:GetEntityControl(towVeh)
                            AttachEntityToEntity(veh, towVeh, bone, towingData[model][aNum].pos.x, towingData[model][aNum].pos.y, nOffset + addedZ, towingData[model][aNum].rot, 0.0, 0.0, 1, 1, 1, 0, 1, 1)
                            TriggerServerEvent("Jobs:Server:UpdateTowData", VehToNet(towVeh), VehToNet(veh), true, aNum)
                        end
                    end
                end
            end
        else
            attached = NetToVeh(attached)
            exports["soe-utils"]:GetEntityControl(attached)

            DetachEntity(attached, 1, 0)
            local towVehBack = GetModelDimensions(GetEntityModel(towVeh))
            local nVehBack = GetModelDimensions(GetEntityModel(attached))
            SetEntityCoords(attached, GetOffsetFromEntityInWorldCoords(towVeh, 0.0, towVehBack.y + nVehBack.y + -3.0, 0.0), 1, 0, 0, 1)
            SetVehicleOnGroundProperly(attached)

            local bool = GetEntityModel(towVeh) == GetHashKey("tr2")
            TriggerServerEvent("Jobs:Server:UpdateTowData", VehToNet(towVeh), nil, bool, aNum)
            AttemptToImpoundVehicle(attached)
        end
    end
end

-- WHEN TRIGGERED, DETACH FROM THE HOOK TOW TRUCK
local function DetachFromHookTowTruck(data)
    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 9291-4 | Lua-Injecting Detected.", 0)
        return
    end
    local playerVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    DetachVehicleFromAnyTowTruck(playerVehicle)
end

-- **********************
--    Global Functions
-- **********************
-- RAG ITEM USAGE
function UseRag()
    local veh = exports["soe-utils"]:GetVehInFrontOfPlayer(5.0)
    if not veh then
        exports["soe-ui"]:SendAlert("error", "No vehicle found", 5000)
        return
    end

    exports["soe-emotes"]:StartEmote("clean")
    exports["soe-utils"]:Progress(
        {
            name = "usingRag",
            duration = 10000,
            label = "Cleaning",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = false,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = false
            }
        },
        function(cancelled)
            exports["soe-emotes"]:CancelEmote()
            if not cancelled then
                if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(veh)) <= 6.5 then
                    SetVehicleDirtLevel(veh, 0.0)
                    TriggerServerEvent("Jobs:Server:UseRag", {status = true})
                    TriggerServerEvent("CSI:Server:CleanPrintsFromVeh", GetVehicleNumberPlateText(veh))
                else
                    exports["soe-ui"]:SendAlert("error", "Too far from the vehicle!", 5000)
                end
            end
        end
    )
end

-- **********************
--       Commands
-- **********************
-- WHEN TRIGGERED, SPAWN TOW TRUCK WHEN STARTING JOB
RegisterCommand("tow_spawntruck", function()
    if not action then return end
    ManageTowtruck(action.spawnLoc, true)
end)

-- WHEN TRIGGERED, FINALIZE OFFSET POSITION WHEN TOWING
RegisterCommand("finalizetow", function()
    if towing.inLoop then
        if not towing.finalized then
            towing.finalized = true
            exports["soe-ui"]:SendAlert("success", "Finalized position!", 5000)
        end
    end
end)

-- **********************
--        Events
-- **********************
--WHEN TRIGGERED, RAISE VEHICLE (CONVERT TO ITEM USAGE WHEN READY)
AddEventHandler("Inventory:Client:UseJackstand", RaiseVehicle)

-- CALLED FROM SERVER AFTER "/tow" IS EXECUTED
RegisterNetEvent("Jobs:Client:TowVehicle")
AddEventHandler("Jobs:Client:TowVehicle", TowVehicle)

-- WHEN TRIGGERED, CREATE A NEW TOW CALL BASED OFF DATA RECEIVED
RegisterNetEvent("Jobs:Client:NewTowCall")
AddEventHandler("Jobs:Client:NewTowCall", NewTowCall)

-- WHEN TRIGGERED, SYNC CARLIFTING FROM THE SOURCE VEHICLE
RegisterNetEvent("Jobs:Client:SyncCarlifting")
AddEventHandler("Jobs:Client:SyncCarlifting", SyncCarlifting)

-- WHEN TRIGGERED, CLEAR TOW CALLS
RegisterNetEvent("Jobs:Client:ClearTowCalls")
AddEventHandler("Jobs:Client:ClearTowCalls", ClearTowCalls)

-- WHEN TRIGGERED, REQUEST A TOW TRUCK
RegisterNetEvent("Jobs:Client:RequestTowTruck")
AddEventHandler("Jobs:Client:RequestTowTruck", RequestTowTrucks)

-- WHEN TRIGGERED, DELETE A CALL BLIP WHEN IT HAS BEEN TAKEN
RegisterNetEvent("Jobs:Client:TowCallTakenAlert")
AddEventHandler("Jobs:Client:TowCallTakenAlert", RemoveAITowCallBlips)

-- WHEN TRIGGERED, SYNC TOWING USAGE FROM A TRUCK
RegisterNetEvent("Jobs:Client:UpdateTowData")
AddEventHandler("Jobs:Client:UpdateTowData", function(_currentlyTowing)
    currentlyTowing = _currentlyTowing
end)

-- WHEN TRIGGERED, ATTEMPT TO IMPOUND TOWED VEH
RegisterNetEvent("Jobs:Client:TowAttemptImpound")
AddEventHandler("Jobs:Client:TowAttemptImpound", AttemptToImpoundVehicle)

-- WHEN TRIGGERED, DETACH FROM HOOK TOW TRUCK
RegisterNetEvent("Jobs:Client:DetachHookedVeh")
AddEventHandler("Jobs:Client:DetachHookedVeh", DetachFromHookTowTruck)

-- ON ZONE EXIT
AddEventHandler("Utils:Client:ExitedZone", function(name)
    if name:match("towing") then
        action = nil
        exports["soe-ui"]:HideTooltip()
    end
end)

-- WHEN TRIGGERED, RECORD LOCATION DATA OF COORDS WE WERE SENT
RegisterNetEvent("Jobs:Client:GetTowCallLocation")
AddEventHandler("Jobs:Client:GetTowCallLocation", function(data)
    if not data.status then return end

    local zone = GetNameOfZone(data.pos.x, data.pos.y, data.pos.z)
    local model = GetLabelText(GetDisplayNameFromVehicleModel(data.model))
    local loc = exports["soe-utils"]:GetLocation(vector3(data.pos.x, data.pos.y, data.pos.z))
    TriggerServerEvent("Jobs:Server:GetTowCallLocation", {status = true, locationData = {street = loc, zone = zone, model = model}})
end)

-- ON ZONE ENTRANCE
AddEventHandler("Utils:Client:EnteredZone", function(name, zoneData)
    if name:match("towing") then
        action = {status = true, spawnLoc = zoneData.spawn}
        if (GetMyJob() == "TOW") then
            exports["soe-ui"]:ShowTooltip("fas fa-truck-loading", "[E] Quit Job | [G] Spawn Truck", "inform")
        else
            exports["soe-ui"]:ShowTooltip("fas fa-truck-loading", "[E] Start Job", "inform")
        end
    end
end)

-- ON INTERACTION KEYPRESS
AddEventHandler("Utils:Client:InteractionKey", function()
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
        return
    end

    local veh = exports["soe-utils"]:GetVehInFrontOfPlayer(3.0)
    if DecorGetBool(veh, "isRaised") and not alreadyLowering then
        alreadyLowering = true
        exports["soe-ui"]:SendAlert("warning", "Lowering...", 5000)

        TriggerServerEvent("Jobs:Server:SyncCarlifting", {status = true, type = "Lower", veh = VehToNet(veh)})
        SetTimeout(8000, function()
            alreadyLowering = false
        end)
    end

    -- ZONE FUNCTIONS RELATED TO TOWING DUTY TOGGLE
    if not action then return end
    if action.status then
        if (GetMyJob() == "TOW") then
            ToggleDuty(false)
        else
            ToggleDuty(true)
        end
    end
end)
