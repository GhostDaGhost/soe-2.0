local kidnapping = {}

-- CERTAIN VEHICLES NEED OFFSET TWEAKED FOR TRUNKS
kidnapping.offsets = {
    ["taxi"] = {y = 0.0, z = -0.5},
    ["buccaneer"] = {y = 0.5, z = 0.0},
    ["peyote"] = {y = 0.35, z = -0.15},
    ["regina"] = {y = 0.2, z = -0.35},
    ["pigalle"] = {y = 0.2, z = -0.15},
    ["glendale"] = {y = 0.0, z = -0.35}
}

-- LIST OF VEHICLES THAT CANNOT SUPPORT PEOPLE INSIDE TRUNKS
kidnapping.noTrunks = {
    ["penetrator"] = true,
    ["vacca"] = true,
    ["monroe"] = true,
    ["turismor"] = true,
    ["osiris"] = true,
    ["comet"] = true,
    ["ardent"] = true,
    ["jester"] = true,
    ["nero"] = true,
    ["nero2"] = true,
    ["vagner"] = true,
    ["infernus"] = true,
    ["zentorno"] = true,
    ["comet2"] = true,
    ["comet3"] = true,
    ["comet4"] = true,
    ["bullet"] = true
}

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, MAKE A CAMERA WHEN INSIDE A TRUNK
local function HandleTrunkCamera()
    if not DoesCamExist(kidnapping.cam) then
        kidnapping.cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        SetCamCoord(kidnapping.cam, GetEntityCoords(PlayerPedId()))
        SetCamRot(kidnapping.cam, 0.0, 0.0, 0.0)
        SetCamActive(kidnapping.cam,  true)
        RenderScriptCams(true,  false,  0,  true,  true)
        SetCamCoord(kidnapping.cam, GetEntityCoords(PlayerPedId()))
    end

    AttachCamToEntity(kidnapping.cam, PlayerPedId(), 0.0, -2.5, 1.0, true)
    SetCamRot(kidnapping.cam, -30.0, 0.0, GetEntityHeading(PlayerPedId()))
end

-- WHEN TRIGGERED, PUTS RESTRAINED PLAYER INSIDE TRUNK OF NEAREST VEHICLE
local function PutInsideTrunk(data)
    if not data.status then return end
    if kidnapping.isInsideTrunk then return end

    -- MAKE SURE PLAYER ISN'T RESTRIANED THEMSELVES
    if exports["soe-civ"]:IsRestrained() then
        return
    end

    -- EXTRA CHECKS BECAUSE PEOPLE WILL BE PEOPLE
    if IsPedSittingInAnyVehicle(PlayerPedId()) or exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
        return
    end

    -- GET CLOSEST VEHICLE
    local veh = exports["soe-utils"]:GetVehInFrontOfPlayer(3.5)
    if not veh then
        exports["soe-ui"]:SendAlert("error", "No vehicle close enough", 5000)
        return
    end

    -- RESET RESTRIANT STATUS
    local holding = exports["soe-civ"]:IsHolding()
    local carrying = exports["soe-civ"]:IsCarrying()
    local escorting = exports["soe-civ"]:IsEscorting()
    if (escorting ~= nil) then
        TriggerServerEvent("Civ:Server:EscortPlayer", escorting, false)
        TriggerServerEvent("Crime:Server:PutInsideTrunk", {status = true, serverID = escorting, veh = VehToNet(veh)})
        exports["soe-civ"]:SetEscortingState(nil)
        ClearPedTasks(PlayerPedId())
    elseif (carrying ~= nil) then
        TriggerServerEvent("Civ:Server:CarryPlayer", carrying, false)
        TriggerServerEvent("Crime:Server:PutInsideTrunk", {status = true, serverID = carrying, veh = VehToNet(veh)})
        exports["soe-civ"]:SetCarryingState(nil)
        ClearPedTasks(PlayerPedId())
    elseif (holding ~= nil) then
        TriggerServerEvent("Civ:Server:HoldPlayer", holding, false)
        TriggerServerEvent("Crime:Server:PutInsideTrunk", {status = true, serverID = holding, veh = VehToNet(veh)})
        exports["soe-civ"]:SetHoldingState(nil)
        ClearPedTasks(PlayerPedId())
    end
end

-- WHEN TRIGGERED, GET IN THE TRUNK OF THE NEAREST VEHICLE
local function GetInsideTrunk(data)
    if not data.status then return end
    if kidnapping.isInsideTrunk then return end

    if exports["soe-civ"]:IsRestrained() or IsPedSittingInAnyVehicle(PlayerPedId()) then
        return
    end

    -- GET CLOSEST VEHICLE
    local veh = exports["soe-utils"]:GetVehInFrontOfPlayer(3.5)
    if data.veh then
        veh = NetToVeh(data.veh)
    end

    if not veh then
        exports["soe-ui"]:SendAlert("error", "No vehicle close enough", 5000)
        return
    end

    local model = GetEntityModel(veh)
    local hash = GetDisplayNameFromVehicleModel(model):lower()
    if kidnapping.noTrunks[hash] then
        exports["soe-ui"]:SendAlert("error", "This vehicle has no trunk or it isn't suitable!", 5000)
        return
    end

    if DoesVehicleHaveDoor(veh, 5) and IsThisModelACar(model) then
        if not (GetVehicleDoorAngleRatio(veh, 5) ~= 0) then
            exports["soe-ui"]:SendAlert("error", "The trunk must be open to get in!", 5000)
            return
        end

        local D1, D2 = GetModelDimensions(model)
        local trunkZ = D2["z"]
        if (trunkZ > 1.4) then
            trunkZ = 1.4 - (D2.z - 1.4)
        end
        local offset = kidnapping.offsets[hash] or {y = 0.0, z = 0.0}

        local ped = PlayerPedId()
        exports["soe-utils"]:LoadAnimDict("mp_common_miss", 15)
        TaskPlayAnim(ped, "mp_common_miss", "dead_ped_idle", 8.0, 8.0, -1, 2, 0, 0, 0, 0)
        AttachEntityToEntity(ped, veh, 0, -0.1, (D1["y"] + 0.85) + offset.y, (trunkZ - 0.87) + offset.z, 0, 0, 40.0, 1, 1, 1, 1, 1, 1)

        kidnapping.currentVehicle = veh
        kidnapping.isInsideTrunk = true
        SetVehicleDoorShut(veh, 5, false)
        exports["soe-ui"]:PersistentAlert("start", "trunkPrompt", "debug", "[E] Exit Trunk", 50)

        local loopIndex = 0
        while kidnapping.isInsideTrunk do
            Wait(5)
            -- CREATE A CAMERA
            HandleTrunkCamera()

            loopIndex = loopIndex + 1
            if (loopIndex % 50 == 0) then
                loopIndex = 0
                ped = PlayerPedId()

                -- ENSURE THE ANIMATION STICKS
                if not IsEntityPlayingAnim(ped, "mp_common_miss", "dead_ped_idle", 3) then
                    TaskPlayAnim(ped, "mp_common_miss", "dead_ped_idle", 8.0, 8.0, -1, 2, 0, 0, 0, 0)
                end

                -- ENSURE PLAYER IS UN-TRUNKED IF VEHICLE SUDDENLY WAS GONE
                if IsEntityDead(veh) or not DoesEntityExist(veh) then
                    kidnapping.isInsideTrunk = false
                end
            end
        end

        DetachEntity(ped)
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(kidnapping.cam, false)
        kidnapping.cam = nil

        StopAnimTask(ped, "mp_common_miss", "dead_ped_idle", -2.0)
        exports["soe-ui"]:PersistentAlert("end", "trunkPrompt")
        if DoesEntityExist(veh) then
	        SetEntityCoords(ped, GetOffsetFromEntityInWorldCoords(veh, 0.0, (D1["y"] - 0.5), 0.0))
	    end
        kidnapping.currentVehicle = 0
    end
end

-- WHEN TRIGGERED, REMOVE SELF BAG OR GET THE NEAREST PLAYER
local function DoHeadbagging(data)
    if not data.status then return end
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() or exports["soe-civ"]:IsRestrained() then
        return
    end

    -- IF YOU HAVE A BAG ALREADY ON YOUR HEAD
    if kidnapping.bagged then
        kidnapping.bagged = false
        exports["soe-utils"]:LoadAnimDict("missheist_agency2ahelmet", 15)
        TaskPlayAnim(PlayerPedId(), "missheist_agency2ahelmet", "take_off_helmet_stand", 3.0, 3.0, 1200, 51, 0, 0, 0, 0)
        Wait(1200)

        -- DELETE BAG OBJECT FROM HEAD
        DeleteEntity(kidnapping.bag)
        SetEntityAsNoLongerNeeded(kidnapping.bag)
        kidnapping.bag = nil

        -- DISABLE PERSPECTIVE OF BEING BAGGED
        SendNUIMessage({type = "DoHeadbag", show = false})
        TriggerEvent("Chat:Client:SendMessage", "me", "You removed the bag over your head.")
        return
    end

    -- HEABAG/REMOVE BAG OFF THE NEAREST PLAYER
    local player = exports["soe-utils"]:GetClosestPlayer(5)
    if (player ~= nil) then
        if not exports["soe-inventory"]:HasInventoryItem("bag") then
            exports["soe-ui"]:SendAlert("error", "You do not have a bag", 5000)
            return
        end

        exports["soe-utils"]:LoadAnimDict("anim@heists@money_grab@duffel", 15)
        TaskPlayAnim(PlayerPedId(), "anim@heists@money_grab@duffel", "enter", 1.0, 1.0, 850, 49, 0, 0, 0, 0)
        TriggerServerEvent("Crime:Server:Headbag", {status = true, serverID = GetPlayerServerId(player)})
    else
        exports["soe-ui"]:SendAlert("error", "Nobody close enough", 2500)
    end
end

-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, RETURN IF PLAYER IS INSIDE A TRUNK
function IsInsideTrunk()
    return kidnapping.isInsideTrunk
end

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, SYNC HEADBAGGING WITH THIS PLAYER
RegisterNetEvent("Crime:Client:DoHeadbagging")
AddEventHandler("Crime:Client:DoHeadbagging", DoHeadbagging)

-- WHEN TRIGGERED, PUTS RESTRAINED PLAYER INSIDE TRUNK OF NEAREST VEHICLE
RegisterNetEvent("Crime:Client:PutInsideTrunk")
AddEventHandler("Crime:Client:PutInsideTrunk", PutInsideTrunk)

-- WHEN TRIGGERED, GET IN THE TRUNK OF THE NEAREST VEHICLE
RegisterNetEvent("Crime:Client:GetInsideTrunk")
AddEventHandler("Crime:Client:GetInsideTrunk", GetInsideTrunk)

-- WHEN TRIGGERED, GET OUT OF THE TRUNK WHEN PLAYER DIED
AddEventHandler("Emergency:Client:DeathFromAbove", function()
    kidnapping.isInsideTrunk = false
    kidnapping.currentVehicle = 0
end)

-- WHEN TRIGGERED, RESET PLAYER IF THEY WERE IN A TRUNK
AddEventHandler("onResourceStop", function(resource)
    if (GetCurrentResourceName() ~= resource) then return end
    if not kidnapping.isInsideTrunk then return end

    DetachEntity(PlayerPedId())
    ClearPedTasksImmediately(PlayerPedId())
    exports["soe-ui"]:PersistentAlert("end", "trunkPrompt")
end)

-- WHEN TRIGGERED, GET OUT OF THE TRUNK WHEN KEY IS PRESSED
AddEventHandler("Utils:Client:InteractionKey", function()
    if not kidnapping.isInsideTrunk then return end
    if not kidnapping.currentVehicle then return end

    if not (GetVehicleDoorAngleRatio(kidnapping.currentVehicle, 5) ~= 0) then
        exports["soe-ui"]:SendAlert("error", "The trunk must be open to get out!", 5000)
        return
    end
    kidnapping.isInsideTrunk = false
end)

-- WHEN TRIGGERED, SYNC HEADBAGGING WITH THIS PLAYER
RegisterNetEvent("Crime:Client:Headbag")
AddEventHandler("Crime:Client:Headbag", function()
    if not kidnapping.bagged then
        kidnapping.bagged = true
        kidnapping.bag = CreateObject(GetHashKey("prop_money_bag_01"), 0, 0, 0, 1, 1, 1)

        local ped = PlayerPedId()
        AttachEntityToEntity(kidnapping.bag, ped, GetPedBoneIndex(ped, 12844), 0.2, 0.04, 0, 0, 270.0, 60.0, 1, 1, 0, 1, 1, 1)

        -- SHOW PERSPECTIVE OF BEING BAGGED
        SendNUIMessage({type = "DoHeadbag", show = true})
        TriggerEvent("Chat:Client:SendMessage", "me", "Someone placed a bag over your head.")
    else
        kidnapping.bagged = false

        -- DELETE BAG OBJECT FROM HEAD
        DeleteEntity(kidnapping.bag)
        SetEntityAsNoLongerNeeded(kidnapping.bag)
        kidnapping.bag = nil

        -- DISABLE PERSPECTIVE OF BEING BAGGED
        SendNUIMessage({type = "DoHeadbag", show = false})
        TriggerEvent("Chat:Client:SendMessage", "me", "Someone removed the bag over your head.")
    end
end)
