local tireBones = {"wheel_lf", "wheel_rf", "wheel_lm1", "wheel_rm1", "wheel_lm2", "wheel_rm2", "wheel_lm3", "wheel_rm3", "wheel_lr", "wheel_rr"}
local tireIndex = {["wheel_lf"] = 0, ["wheel_rf"] = 1, ["wheel_lm1"] = 2, ["wheel_rm1"] = 3, ["wheel_lm2"] = 45, ["wheel_rm2"] = 47, ["wheel_lm3"] = 46, ["wheel_rm3"] = 48, ["wheel_lr"] = 4, ["wheel_rr"] = 5}
local letters = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, CHECK IF A PLATE IS ALREADY IN USE
local function IsPlateUsed(plate)
    local result = exports["soe-nexus"]:TriggerServerCallback("Utils:Server:IsPlateUsed", plate)
    return result
end

-- **********************
--    Global Functions
-- **********************
-- SETS RENTAL STATUS OF A VEHICLE
function SetRentalStatus(veh, owner)
    local plate = GetVehicleNumberPlateText(veh)
    local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh)))
    TriggerServerEvent("Emergency:Server:SetRented", model, plate, owner)
end
exports("SetRentalStatus", SetRentalStatus)

-- REPAIRS VEHICLE
function RepairVehicle(veh)
    local fuel = exports["soe-fuel"]:GetFuel(veh)
    SetVehicleFixed(veh)
    if IsVehicleAttachedToTrailer(veh) then
        local _, trailer = GetVehicleTrailerVehicle(veh, trailer)
        SetVehicleFixed(trailer)
    end
    exports["soe-fuel"]:SetFuel(veh, fuel)
end
exports("RepairVehicle", RepairVehicle)

-- CLEANS VEHICLE
function CleanVehicle(veh)
    SetVehicleDirtLevel(veh, 0.0)
    TriggerServerEvent("CSI:Server:CleanPrintsFromVeh", GetVehicleNumberPlateText(veh))
    if IsVehicleAttachedToTrailer(veh) then
        local _, trailer = GetVehicleTrailerVehicle(veh, trailer)
        SetVehicleDirtLevel(trailer, 0.0)
    end
end
exports("CleanVehicle", CleanVehicle)

-- WHEN TRIGGERED, SPAWNS VEHICLE AT A SPECIFIC POSITION
function SpawnVehicle(model, pos, randomizeFuel)
    if (type(model) == "string") then
        model = GetHashKey(model)
    end
    local modelName = GetLabelText(GetDisplayNameFromVehicleModel(model))

    LoadModel(model, 15)
    local veh = exports["soe-nexus"]:TriggerServerCallback("Utils:Server:CreateNewVehicle", model, pos, modelName)
    if not veh["succeeded"] then
        exports["soe-ui"]:SendAlert("error", "Something went wrong spawning the vehicle!", 5000)
        return 0
    end

    while not NetworkDoesNetworkIdExist(veh["netID"]) do
        Wait(100)
    end
    veh["ent"] = NetworkGetEntityFromNetworkId(veh["netID"])
    GetEntityControl(veh["ent"])

    -- NETWORKING
    --NetworkUseHighPrecisionBlending(veh["netID"], false)
    SetNetworkIdExistsOnAllMachines(veh["netID"], true)
    SetNetworkIdCanMigrate(veh["netID"], true)

    -- BASIC PROPERTIES
    SetVehicleOnGroundProperly(veh["ent"])
    SetVehicleHasBeenOwnedByPlayer(veh["ent"], true)
    SetVehRadioStation(veh["ent"], "OFF")
    if not randomizeFuel then
        exports["soe-fuel"]:SetFuel(veh["ent"], 100)
    end

    -- PERSIST AND FREE FROM MEMORY
    SetEntityAsMissionEntity(veh["ent"], true)
    SetModelAsNoLongerNeeded(model)
    return veh["ent"]
end
exports("SpawnVehicle", SpawnVehicle)

-- GETS CLOSEST VEHICLE DOOR
function GetClosestVehicleDoor(veh)
    local doors = {}
    local vehBack, vehFront = GetModelDimensions(GetEntityModel(veh))
    for i = 0, 5 do
        if DoesVehicleHaveDoor(veh, i) then
            if (i == 4) then
                doors[i] = GetOffsetFromEntityInWorldCoords(veh, 0.0, vehFront.y, 0.0)
            elseif (i == 5) then
                doors[i] = GetOffsetFromEntityInWorldCoords(veh, 0.0, vehBack.y, 0.0)
            else
                doors[i] = GetEntryPositionOfDoor(veh, i)
            end
        end
    end

    local closestDoor = {dist = 99, id = 99}
    local pos = GetEntityCoords(PlayerPedId())
    for doorID, door in pairs(doors) do
        if #(pos - door) <= closestDoor.dist and not IsVehicleDoorDamaged(veh, doorID) then
            closestDoor = {dist = #(pos - door), id = doorID, pos = door}
        end
    end
    return closestDoor
end
exports("GetClosestVehicleDoor", GetClosestVehicleDoor)

-- RETURNS VEHICLE IN FRONT OR BEHIND PLAYER
function GetVehInFrontOfPlayer(distance, rear)
    -- FLIPS DISTANCE IF REAR BOOL IS TRUE
    if rear then
        distance = -distance
    end

    -- START LOOKING FOR OUR VEHICLE
    local veh = nil
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    for i = -2.0, 2.0, 0.1 do
        -- USE RAYCAST TO FIND THE VEHICLE IN FRONT OF THE PLAYER
        local offset = GetOffsetFromEntityInWorldCoords(ped, 0.0, distance, 0.0)
        local result = StartShapeTestCapsule(pos.x, pos.y, pos.z + i, offset.x, offset.y, offset.z, 1.0, 10, ped, 0)

        -- IF WE FOUND OUR VEHICLE, RETURN IT
        local _, _, _, _, veh = GetShapeTestResult(result)
        if (veh ~= nil and veh ~= 0) and IsEntityAVehicle(veh) then
            return veh
        end
    end
    -- IF WE FAILED, RETURN NIL
    return veh
end
exports("GetVehInFrontOfPlayer", GetVehInFrontOfPlayer)

function GetClosestVehicleTire(veh)
    local minDistance = 1.0
    local closestTire = nil

    local pos = GetEntityCoords(PlayerPedId())
    for i = 1, #tireBones do
        local bonePos = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, tireBones[i]))
        local distance = Vdist(pos, bonePos.x, bonePos.y, bonePos.z)

        if (closestTire == nil) then
            if (distance <= minDistance) then
                closestTire = {bone = tireBones[i], boneDist = distance, bonePos = bonePos, tireIndex = tireIndex[tireBones[i]]}
            end
        else
            if (distance < closestTire.boneDist) then
                closestTire = {bone = tireBones[i], boneDist = distance, bonePos = bonePos, tireIndex = tireIndex[tireBones[i]]}
            end
        end
    end
    return closestTire
end
exports("GetClosestVehicleTire", GetClosestVehicleTire)

function GetClosestVehicle(maxDist)
    local vehList = {}
    local handle, veh = FindFirstVehicle()
    local done = false
    repeat
        done, veh = FindNextVehicle(handle)
        vehList[#vehList + 1] = veh
    until not done
    EndFindVehicle(handle)

    local closest
    local dist = 1000
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    for _, v in pairs(vehList) do
        local vPos = GetEntityCoords(v)
        if Vdist2(pos, vPos) < dist then
            closest = v
            dist = Vdist2(pos, vPos)
        end
    end

    if (dist <= (maxDist or 5.0)) then
        return closest
    end
    return 0
end
exports("GetClosestVehicle", GetClosestVehicle)

-- WHEN TRIGGERED, GENERATE A UN-USED RANDOM LICENSE PLATE
function GenerateRandomPlate()
    local licensePlate = ""
    local licensePlateDigits = {}

    while IsPlateUsed(licensePlate) do
        licensePlate = ""
        local rng = mwc(GetGameTimer() * GetInstanceId())
        licensePlateDigits[1] = rng:random(0, 9)
        licensePlateDigits[2] = rng:random(0, 9)
        licensePlateDigits[3] = letters[rng:random(1, 26)]
        licensePlateDigits[4] = letters[rng:random(1, 26)]
        licensePlateDigits[5] = letters[rng:random(1, 26)]
        licensePlateDigits[6] = rng:random(0, 9)
        licensePlateDigits[7] = rng:random(0, 9)
        licensePlateDigits[8] = rng:random(0, 9)

        for i = 1, #licensePlateDigits do
            licensePlate = licensePlate .. licensePlateDigits[i]
        end
    end

    exports["soe-nexus"]:TriggerServerCallback("Utils:Server:ReservePlate", licensePlate)
    return licensePlate
end
exports("GenerateRandomPlate", GenerateRandomPlate)

-- **********************
--        Events
-- **********************
-- SENT FROM SERVER TO CLEAR VEHICLES IN A RADIUS
RegisterNetEvent("Utils:Client:ClearVehiclesInRadius")
AddEventHandler("Utils:Client:ClearVehiclesInRadius", function(x, y, z, radius)
    -- DEFAULT RADIUS SIZE IF NOT SPECIFIED
    if (radius == nil) then
        radius = 25.0
    end

    -- SEARCH THROUGH FOR VEHICLES
    for veh in EnumerateVehicles() do
        -- IF VEHICLE NEARBY, DELETE IT
        if #(vector3(x, y, z) - GetEntityCoords(veh)) <= radius then
            TriggerServerEvent("Utils:Server:DeleteEntity", VehToNet(veh))
            Wait(750)
            if DoesEntityExist(veh) then
                DeleteEntity(veh)
            end
        end
    end
end)
