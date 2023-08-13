local keys = {}
local lastVehicle = 0
local isSpawning = false

-- DECORATORS
DecorRegister("vin", 3)
DecorRegister("unlocked", 2)
DecorRegister("playerOwned", 2)

-- KEY MAPPINGS
RegisterKeyMapping("lockvehicle", "[Veh] Lock Vehicle", "KEYBOARD", "L")

-- ***********************
--    Local Functions
-- ***********************
-- WHEN TRIGGERED, PARK VEHICLE UP
local function ParkMyVehicle(ped, veh)
    TaskLeaveVehicle(ped, veh, 0)
    Wait(2500)

    -- DELETE THE VEHICLE ENTITY
    TriggerServerEvent("Utils:Server:DeleteEntity", VehToNet(veh))
end

-- WHEN TRIGGERED, CHECK IF A PLAYER CAN ACCESS A GARAGE
local function CanAccessGarage(garage)
    if garage["authorized"] ~= nil then
        local civType = exports["soe-uchuu"]:GetPlayer().CivType
        for _, job in pairs(garage["authorized"]) do
            if (civType == job) then
                return true
            end
        end
    elseif garage["perm"] ~= nil then
        if exports["soe-factions"]:CheckPermission(garage["perm"]) then
            return true
        end
    else
        return true
    end
    return false
end

-- GIVING KEYS FUNCTION
local function GiveKeysToNearestPlayer()
    -- CHECK IF THE PLATE BELONGS TO THE PLAYER
    local myVehicle = HasKey(lastVehicle)

    -- IF THIS IS NOT MY VEHICLE, DON'T CONTINUE
    if not myVehicle then
        exports["soe-ui"]:SendAlert("error", "You do not have a key to this vehicle", 2500)
        return
    end

    -- IF WE MADE IT HERE, HAVE TWO WAYS OF GIVING KEYS
    local ped = PlayerPedId()
    if IsPedSittingInAnyVehicle(ped) then
        -- THIS OPTION ALLOWS YOU TO GIVE KEYS TO THE FRONT PASSENGER
        local veh = GetVehiclePedIsIn(ped, false)
        if (veh == lastVehicle) then
            local passenger = GetPedInVehicleSeat(veh, 0)
            if (passenger ~= 0) and IsPedAPlayer(passenger) then
                local serverID = GetPlayerServerId(NetworkGetPlayerIndexFromPed(passenger))
                local name = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh)))
                TriggerServerEvent("Valet:Server:GiveKeys", {status = true, veh = VehToNet(veh), serverID = serverID, model = name})

                -- PLAY A LITTLE ANIMATION
                exports["soe-utils"]:LoadAnimDict("mp_common", 15)
                TaskPlayAnim(ped, "mp_common", "givetake1_b", 1.0, 1.0, 1500, 49, 0, 0, 0, 0)
            end
        end
    else
        -- THIS OPTION ALLOWS YOU TO GIVE KEYS TO THE NEAREST PLAYER
        local player = exports["soe-utils"]:GetClosestPlayer(5)
        if (player ~= nil) then
            local serverID = GetPlayerServerId(player)
            local name = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(lastVehicle)))
            TriggerServerEvent("Valet:Server:GiveKeys", {status = true, veh = VehToNet(lastVehicle), serverID = serverID, model = name})

            -- PLAY A LITTLE ANIMATION
            exports["soe-utils"]:LoadAnimDict("mp_common", 15)
            TaskPlayAnim(ped, "mp_common", "givetake1_b", 1.0, 1.0, 1500, 49, 0, 0, 0, 0)
        end
    end
end

-- FULLY LOCK THE VEHICLE
local function LockVehicle(veh, lockNow)
    -- IF NORMAL LOCKING, LOCK OR UNLOCK
    if DoesEntityExist(veh) and not lockNow then
        local locks = GetVehicleDoorLockStatus(veh)
        if (locks ~= 2) then -- SEND TO SERVER TO ENSURE THE VEHICLE IS LOCKED/PLAY SOUND/SEND NOTIFICATION
            TriggerServerEvent("Valet:Server:EnsureLocks", {status = true, vehID = VehToNet(veh), lock = true})
        elseif (locks == 2) then -- SEND TO SERVER TO ENSURE THE VEHICLE IS UNLOCKED/PLAY SOUND/SEND NOTIFICATION
            TriggerServerEvent("Valet:Server:EnsureLocks", {status = true, vehID = VehToNet(veh), lock = false})
        end
    elseif DoesEntityExist(veh) and lockNow then -- SEND TO SERVER TO ENSURE THE VEHICLE IS INSTANTLY LOCKED (ALT + L)
        TriggerServerEvent("Valet:Server:EnsureLocks", {status = true, vehID = VehToNet(veh), lock = true})
    end

    -- PLAY A HORN AND FLASH VEHICLE LIGHTS
    local ped = PlayerPedId()
    if not IsPedSittingInAnyVehicle(ped) then
        if (GetVehicleClass(veh) ~= 18) then
            StartVehicleHorn(veh, 100, 0, 0)
        end
        SetVehicleLights(veh, 2)
        Wait(500)
        SetVehicleLights(veh, 0)
    end
end

-- AFTER SPAWNING, SET CAR DAMAGE IF HAVE TO
local function SetVehicleDamage(veh, bh, eh)
    local body = bh + 0.0
    local engine = eh + 0.0
    local smash, damageOutside = false, false

    if engine < 200.0 then
        engine = 200.0
    end

    if body < 900.0 then
        body = 900.0
    end

    if body < 950.0 then
        smash = true
    end

    if body < 920.0 then
        damageOutside = true
    end

    SetVehicleEngineHealth(veh, engine)
    if smash then
        SmashVehicleWindow(veh, 0)
        SmashVehicleWindow(veh, 1)
        SmashVehicleWindow(veh, 2)
        SmashVehicleWindow(veh, 4)
    end

    if damageOutside then
        SetVehicleDoorBroken(veh, 1, true)
        SetVehicleDoorBroken(veh, 6, true)
        SetVehicleDoorBroken(veh, 4, true)
    end
    SetVehicleBodyHealth(veh, body)
end

-- ***********************
--    Global Functions
-- ***********************
-- REMOVE A CERTAIN VEHICLE FROM THE KEY TABLES
--[[function RemoveKey(veh)
    local plate = GetVehicleNumberPlateText(veh)
    TriggerServerEvent("Valet:Server:RemoveKey", plate)
end]]

-- A FUNCTION CHECK IF THE PLAYER HAS A KEY TO THE VEHICLE
function HasKey(veh)
    local plate = GetVehicleNumberPlateText(veh)
    for _, key in pairs(keys) do
        if (key["plate"] == plate) then
            return true
        end
    end
    return false
end

-- UPDATE THE KEYS TABLES
function UpdateKeys(veh, notify)
    -- ADD THE PLATE TO THE KEYS TABLE
    local plate = GetVehicleNumberPlateText(veh)
    keys[#keys + 1] = {plate = plate}

    -- SEND THE PLATE TO SERVER TO UPDATE THE KEYS TABLE THERE
    TriggerServerEvent("Valet:Server:UpdateKeys", plate, VehToNet(veh))

    -- NOTIFY IF OPTION IS GIVEN
    if notify then
        exports["soe-ui"]:SendAlert("warning", "You were given keys to your vehicle", 5000)
    end
end

-- A FUNCTION TO MAKE THE VALET MENU APPEAR
function ShowValet(garageName, charID, isBusinessGarage)
    -- GET VEHICLES FROM SERVER
    local vehicles = exports["soe-nexus"]:TriggerServerCallback("Valet:Server:GetGarageData", garageName, charID, isBusinessGarage)
    if not vehicles then -- RETURN IF NO VEHICLES FOUND TO PREVENT ERROR
        exports["soe-ui"]:SendAlert("error", "You have no vehicles here", 5000)
        return
    end

    -- SEND NUI MESSAGE
    SetNuiFocus(true, true)
    SendNUIMessage({type = "Valet.ShowUI", garageName = garageName, garageData = vehicles["data"], charid = charID})
end

-- SENT FROM KEYPRESS, THIS FUNCTION SEARCHES FOR A VEHICLE TO LOCK
function LookForVehicleToLock(lockNow)
    local veh = 0
    local ped = PlayerPedId()
    if not IsPedSittingInAnyVehicle(ped) then
        local nearbyVehicles = {} -- ITERATE THROUGH THE NEAREST VEHICLES AND PUT THEM IN A NEARBY TABLE
        for vehicle in exports["soe-utils"]:EnumerateVehicles() do
            if #(GetEntityCoords(ped) - GetEntityCoords(vehicle)) <= 13.0 then
                nearbyVehicles[#nearbyVehicles + 1] = vehicle
            end
        end

        -- CHECK IF OUR NEAREST VEHICLE IS OWNED/BORROWED BY US
        for _, nearbyVeh in pairs(nearbyVehicles) do
            if HasKey(nearbyVeh) then
                veh = nearbyVeh
                break
            end
        end

        -- IF WE FOUND OUR VEHICLE
        if (veh ~= 0) then
            LockVehicle(veh, lockNow)
        end
    else
        veh = GetVehiclePedIsIn(ped, false)
        local isDriver = (GetPedInVehicleSeat(veh, -1) == ped)
        local isPassenger = (GetPedInVehicleSeat(veh, 0) == ped)
        if (veh ~= 0) and (isDriver or isPassenger) then
            LockVehicle(veh, lockNow)
        end
    end
end

-- ***********************
--        Commands
-- ***********************
-- WHEN TRIGGERED, LOCK/UNLOCK VEHICLE
RegisterCommand("lockvehicle", function()
    LookForVehicleToLock(IsControlPressed(1, 19))
end)

-- ***********************
--      NUI Callbacks
-- ***********************
-- WHEN TRIGGERED, CLOSE UI
RegisterNUICallback("Valet.CloseUI", function()
    SetNuiFocus(false, false)
end)

-- WHEN TRIGGERED, SPAWN VEHICLE
RegisterNUICallback("Valet.SelectVeh", function(data)
    if isSpawning then return end
    isSpawning = true

    -- REQUEST VEHICLE DATA FROM THE SERVER
    local vehStatus = exports["soe-nexus"]:TriggerServerCallback("Valet:Server:SpawnVehicleFromGarage", data["vin"])
    if (vehStatus["IsOut"] ~= 0) then
        exports["soe-ui"]:SendAlert("error", "This vehicle is already checked out!", 6500)
        return
    end

    -- VEHICLE IS NOT CHECKED OUT | FIND GARAGE FOR CURRENT LOCATION
    for _, garage in pairs(garages) do
        if (garage["name"] == vehStatus["Location"]) then
            if vehStatus["Location"]:match("Impound") then -- IF THE GARAGE IS IMPOUND, DO EXTRA TASKS
                local hasDebt = exports["soe-nexus"]:TriggerServerCallback("Bank:Server:DebtCheck")
                if hasDebt then
                    exports["soe-ui"]:SendAlert("error", "You have outstanding state debt! You must clear this before retrieving a vehicle", 8500)
                    TriggerServerEvent("Valet:Server:ParkVehicleByVIN", tonumber(vehStatus["VehicleID"]), true)
                    isSpawning = false
                    return
                end

                local amount = exports["soe-config"]:GetConfigValue("economy", "impound_retrieval") or 150
                TriggerServerEvent("Bank:Server:IncreaseStateDebt", amount, "the State of San Andreas", "Impounded Vehicle Retrieval", false)
            end

            -- CHECK FOR EMPTY SPAWN POSITION
            local hasSpawned = false
            for _, pos in pairs(garage["spawnPositions"]) do
                if not IsAnyVehicleNearPoint(pos["x"], pos["y"], pos["z"], 3.5) then
                    hasSpawned = true
                    local hash = GetHashKey(vehStatus["VehHash"])

                    exports["soe-utils"]:LoadModel(hash, 15)
                    local veh = exports["soe-utils"]:SpawnVehicle(hash, pos)

                    -- SET VEHICLE DECORS AND LOCK THE VEHICLE
                    DecorSetBool(veh, "unlocked", false)
                    DecorSetBool(veh, "playerOwned", true)
                    SetVehicleDoorsLocked(veh, 2)

                    local netID = NetworkGetNetworkIdFromEntity(veh)
                    SetNetworkIdExistsOnAllMachines(netID, true)

                    TriggerServerEvent("Valet:Server:RegisterVehicleSpawned", vehStatus, netID)
                    SetVehicleDamage(veh, vehStatus["BodyCondition"], vehStatus["EngineCondition"])
    
                    -- PLACE A MARKER OVER THE VEHICLE
                    TriggerEvent("Valet:Client:MarkMyVehicle", pos)
                    exports["soe-ui"]:SendAlert("success", "You pulled your vehicle out of your garage!", 5000)
                    Wait(1000)

                    SetVehicleNumberPlateText(veh, vehStatus["VehRegistration"])
                    DecorSetInt(veh, "vin", tonumber(vehStatus["VehicleID"]))
                    exports["soe-shops"]:LoadVehicleMods(veh, vehStatus["VehCustomization"])
                    exports["soe-fuel"]:SetFuel(veh, vehStatus["Fuel"] or 100)

                    Wait(500)
                    UpdateKeys(veh, true)

                    -- GIVE THE VEHICLE A SERVICE VEHICLE BLIP IF IS ONE
                    if vehStatus["VehHash"]:match("bcso") or vehStatus["VehHash"]:match("lspd") or vehStatus["VehHash"]:match("sasp") then
                        exports["soe-nexus"]:TriggerServerCallback("Emergency:Server:SyncESBlips", VehToNet(veh), GetVehicleClass(veh))
                    end
                    break
                end
            end

            -- IN CASE THERE ARE NO AVAILABLE SPOTS
            if not hasSpawned then
                exports["soe-ui"]:SendAlert("error", "It appears that there are no spots for the vehicle to be placed on.", 8500)
                TriggerServerEvent("Valet:Server:ParkVehicleByVIN", tonumber(vehStatus["VehicleID"]), true)
            end
        end
    end

    if string.find(vehStatus["Location"], "property") then
        local propertyID = string.gsub(vehStatus["Location"], "property%-", "")
        local property = exports["soe-properties"]:GetProperty(tonumber(propertyID))
        local spawnPos = vector4(property["garage"].x, property["garage"].y, property["garage"].z, property["garage"].h)
        local hash = GetHashKey(vehStatus["VehHash"])

        -- LOAD AND SPAWN MODEL
        hasSpawned = true
        exports["soe-utils"]:LoadModel(hash, 15)
        local veh = exports["soe-utils"]:SpawnVehicle(hash, spawnPos)

        -- SET VEHICLE DECORS AND LOCK THE VEHICLE
        DecorSetBool(veh, "unlocked", false)
        DecorSetBool(veh, "playerOwned", true)
        SetVehicleDoorsLocked(veh, 2)

        -- GIVE KEYS AND SET FUEL AND SET DAMAGE
        local netID = NetworkGetNetworkIdFromEntity(veh)
        SetNetworkIdExistsOnAllMachines(netID, true)

        TriggerServerEvent("Valet:Server:RegisterVehicleSpawned", vehStatus, netID)
        SetVehicleDamage(veh, vehStatus["BodyCondition"], vehStatus["EngineCondition"])

        -- PLACE A MARKER OVER THE VEHICLE
        TriggerEvent("Valet:Client:MarkMyVehicle", spawnPos)
        exports["soe-ui"]:SendAlert("success", "You pulled your vehicle out of your garage!", 5000)
        Wait(1000)

        SetVehicleNumberPlateText(veh, vehStatus["VehRegistration"])
        DecorSetInt(veh, "vin", tonumber(vehStatus["VehicleID"]))
        exports["soe-shops"]:LoadVehicleMods(veh, vehStatus["VehCustomization"])
        exports["soe-fuel"]:SetFuel(veh, vehStatus["Fuel"] or 100)

        Wait(500)
        UpdateKeys(veh, true)

        -- GIVE THE VEHICLE A SERVICE VEHICLE BLIP IF IS ONE
        if vehStatus["VehHash"]:match("bcso") or vehStatus["VehHash"]:match("lspd") or vehStatus["VehHash"]:match("sasp") then
            exports["soe-nexus"]:TriggerServerCallback("Emergency:Server:SyncESBlips", VehToNet(veh), GetVehicleClass(veh))
        end
    end
    isSpawning = false
end)

-- ***********************
--         Events
-- ***********************
-- CALLED FROM SERVER AFTER "/givekeys" IS EXECUTED
RegisterNetEvent("Valet:Client:GiveKeyOptions", GiveKeysToNearestPlayer)

-- WHEN TRIGGERED, RESET ALL NUI INSTANCES
AddEventHandler("UI:Client:ResetNUI", function()
    SendNUIMessage({type = "Valet.ResetUI"})
end)

-- WHEN TRIGGERED, RECORD THE LAST VEHICLE PLAYER ENTERED
AddEventHandler("BaseEvents:Client:EnteredVehicle", function(veh)
    lastVehicle = veh
end)

-- RETURN CHARACTER KEYS IF THEY HAD SOME
AddEventHandler("Uchuu:Client:CharacterSelected", function()
    Wait(3500)
    keys = exports["soe-nexus"]:TriggerServerCallback("Valet:Server:RequestKeys")
end)

-- CALLED FROM SERVER AFTER "/searchgarage" IS EXECUTED
RegisterNetEvent("Valet:Client:SearchGarage", function(data)
    if not data.status then return end
    ShowValet(data.name, data.charID)
end)

-- MAKE MARKERS ON RESOURCE STARTUP
AddEventHandler("onClientResourceStart", function(resource)
    if (GetCurrentResourceName() ~= resource) then return end
    Wait(3500)

    exports["soe-utils"]:LoadAnimDict("anim@mp_player_intmenu@key_fob@", 15)
    for _, garage in pairs(garages) do
        exports["soe-utils"]:AddMarker(garage["name"], {21, garage.pos.x, garage.pos.y, garage.pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 117, 176, 155, 0, 1, 2, 0, 0, 0, 0, 18.5})
    end
end)

-- CALLED FROM CLIENT TO PLACE A MARKER OVER THE VEHICLE
AddEventHandler("Valet:Client:MarkMyVehicle", function(pos)
    local markMyVeh = true
    SetTimeout(6500, function()
        markMyVeh = false
    end)

    while markMyVeh do
        Wait(5)
        DrawMarker(20, pos.x, pos.y, pos.z + 1.5, 0.0, 0.0, 0.0, 180.0, 0.0, 180.0, 0.75, 0.75, 0.75, 110, 0, 0, 195, 1, 1, 2, 0, 0, 0, 0)
    end
end)

-- CALLED FROM SERVER, UPDATES THE RECIPIENT'S TABLE AND NOTIFIES
RegisterNetEvent("Valet:Client:GiveKeys", function(_veh)
    local veh = NetToVeh(_veh)
    UpdateKeys(veh)

    -- PLAY A LITTLE ANIMATION
    exports["soe-utils"]:LoadAnimDict("mp_common", 15)
    TaskPlayAnim(PlayerPedId(), "mp_common", "givetake1_b", 1.0, 1.0, 1500, 49, 0, 0, 0, 0)
end)

-- RECORD FUEL/ENGINE/BODY CONDITIONS OF VEHICLE TO DB
AddEventHandler("BaseEvents:Client:LeftVehicle", function(veh)
    -- IF THE VEHICLE HAS NO VIN, NO NEED TO SAVE
    if (DecorGetInt(veh, "vin") == 0) then
        return
    end

    -- GATHER VEHICLE CONDITIONS DATA
    local vin, fuel = DecorGetInt(veh, "vin"), exports["soe-fuel"]:GetFuel(veh)
    local body, engine = GetVehicleBodyHealth(veh), GetVehicleEngineHealth(veh)

    -- SEND TO SERVER
    TriggerServerEvent("Valet:Server:UpdateVehicleConditions", {status = true, vin = vin, fuel = math.ceil(fuel), bodyCondition = math.ceil(body), engineCondition = math.ceil(engine)})
end)

-- INTERACTION KEY TO USE VALET
AddEventHandler("Utils:Client:InteractionKey", function()
    local char = exports["soe-uchuu"]:GetPlayer()
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
        return
    end

    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    -- CHANGE DISTANCE IF INSIDE A VEHICLE OR ON FOOT
    local defaultDist, dist, pos, inVehicle = 1.8, 1.8, GetEntityCoords(ped), false, nil

    if IsPedSittingInAnyVehicle(ped) then
        inVehicle = true
        pos = GetEntityCoords(veh)
    end

    -- CHECK IF WE ARE NEARBY A GARAGE
    for _, garage in pairs(garages) do
        if inVehicle and (string.match(garage.name, "Mariner") or string.match(garage.name, "Dock")) then
            dist = 7.5
        elseif inVehicle then
            dist = 4.5
        else
            dist = defaultDist
        end

        if #(pos - garage.pos) <= dist then
            local authorized = CanAccessGarage(garage)

            if authorized then
                if not IsPedSittingInAnyVehicle(ped) and not garage.businessGarage and #(pos - garage.pos) <= defaultDist then
                    ShowValet(garage.name, exports["soe-uchuu"]:GetPlayer().CharID)
                elseif GetPedInVehicleSeat(veh, -1) == ped then
                    local canPark = exports["soe-nexus"]:TriggerServerCallback("Valet:Server:ParkVehicle", NetworkGetNetworkIdFromEntity(veh), veh, garage.name, GetVehicleNumberPlateText(veh), garage.perm)
                    if canPark then
                        ParkMyVehicle(ped, veh)
                    end
                elseif garage.businessGarage then
                    exports["soe-ui"]:SendAlert("error", "This garage is accessed elsewhere", 5000)
                end
            elseif not authorized and garage.perm ~= nil then
                exports["soe-ui"]:SendAlert("error", "You do not have the right permissions to use this garage!", 5000)
            else
                exports["soe-ui"]:SendAlert("error", "You cannot access this garage", 5000)
            end
        end
    end

    -- IF GARAGE FAILED THEN CHECK IF WE ARE NEARBY A PROPERTY
    for _, property in pairs(exports["soe-properties"]:GetProperties()) do
        if #(pos - vector3(property.garage.x, property.garage.y, property.garage.z)) <= dist then
            local access = exports["soe-nexus"]:TriggerServerCallback("Valet:Server:GetGarageAccess", char.CharID, property.id)
            if access then
                local canPark = exports["soe-nexus"]:TriggerServerCallback("Valet:Server:ParkVehicleAtProperty", NetworkGetNetworkIdFromEntity(veh), veh, property, GetVehicleNumberPlateText(veh))
                if canPark then
                    ParkMyVehicle(ped, veh)
                end
            end
        end
    end
end)

-- CALLED FROM SERVER, ENSURES VEHICLE LOCKING
RegisterNetEvent("Valet:Client:EnsureLocks")
AddEventHandler("Valet:Client:EnsureLocks", function(vehID, doLock)
    if NetworkDoesNetworkIdExist(vehID) then
        local veh = NetToVeh(vehID)
        if NetworkHasControlOfEntity(veh) and DoesEntityExist(veh) then
            if doLock then
                SetVehicleDoorsLocked(veh, 2)
                DecorSetBool(veh, "unlocked", false)
                if (GetVehicleClass(veh) ~= 18) then
                    SetVehicleAlarm(veh, true)
                end
            elseif not doLock then
                SetVehicleDoorsLocked(veh, 0)
                DecorSetBool(veh, "unlocked", true)
                SetVehicleDoorsLockedForAllPlayers(veh, false)
                if (GetVehicleClass(veh) ~= 18) then
                    SetVehicleAlarm(veh, false)
                end
            end
        end
    end
end)

-- WHEN TRIGGERED, DO SOME STOLEN REPORTS IF NEEDED
AddEventHandler("BaseEvents:Client:EnteringVehicle", function(veh)
    -- DO SOME CHECKS BEFORE DOING ANYTHING
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then return end
    if HasKey(veh) then return end

    -- CHECK VEHICLE'S STOLEN/RENTED STATUS
    local plate = GetVehicleNumberPlateText(veh)
    local isStolen = exports["soe-nexus"]:TriggerServerCallback("Emergency:Server:GetVehicleStatus", plate, "stolen")
    if isStolen then return end
    local isRented = exports["soe-nexus"]:TriggerServerCallback("Emergency:Server:GetVehicleStatus", plate, "rented")
    if isRented then return end
    local isOwned = exports["soe-nexus"]:TriggerServerCallback("Emergency:Server:GetVehicleStatus", plate, "owned", NetworkGetNetworkIdFromEntity(veh))
    if isOwned then return end

    -- CHECK LOCK STATUS
    local isUnlocked = DecorGetBool(veh, "unlocked")
    if isUnlocked then return end

    -- POLICE ROLE CHECK
    --if (exports["soe-jobs"]:GetMyJob() == "POLICE") then return end

    -- CHECK SOME EXCEPTIONS TO THE VEHICLE
    local isMotorcycleWithRider = ((GetVehicleClass(veh) == 8 and GetPedInVehicleSeat(veh, -1) ~= 0))
    local windowsAreBroken = (not (IsVehicleWindowIntact(veh, 0) == 1 and IsVehicleWindowIntact(veh, 1) == 1))
    local doorsAreClosed = ((GetVehicleDoorAngleRatio(veh, 0) <= 0.0) and (GetVehicleDoorAngleRatio(veh, 1) <= 0.0))

    local roll = math.random(1, 100)
    if not doorsAreClosed or windowsAreBroken or isMotorcycleWithRider then
        roll = 0
        SetVehicleDoorsLockedForAllPlayers(veh, false)
        SetVehicleDoorsLocked(veh, 1)
    end

    -- SET SOME VARIABLES
    local primary = GetVehicleColours(veh)
    local loc = exports["soe-utils"]:GetLocation(GetEntityCoords(PlayerPedId()))
    local pedCoords = GetEntityCoords(PlayerPedId())
    local myJob = exports["soe-jobs"]:GetMyJob()
    if (roll <= 15) then
        local shouldReport = false
        local driver = GetPedInVehicleSeat(veh, -1)
        SetVehicleDoorsLockedForAllPlayers(veh, false)
        SetVehicleDoorsLocked(veh, 1)

        -- NO CADS IF PLAYER IS POLICE AND ON DUTY
        if myJob == "POLICE" then return end

        -- CHECK DRIVER AND MAKE THEM A SNITCH
        if (driver == nil or driver == 0) then
            shouldReport = exports["soe-emergency"]:ShouldReportInThisArea()
        else
            shouldReport = (true and not IsPedDeadOrDying(driver))
        end

        if shouldReport then
            if (driver ~= nil and driver ~= 0) then
                if IsPedArmed(PlayerPedId(), 7) then
                    -- ARMED CARJACKING
                    TriggerServerEvent("Emergency:Server:MarkStolen", plate, true, true)
                    --TriggerServerEvent("Emergency:Server:CADAlerts", "Armed Carjacking", location, {model = GetEntityModel(veh), color = primary, plate = plate}, pos)
                    TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = true, type = "Armed Carjacking",
                        loc = loc, model = GetEntityModel(veh), color = primary, plate = plate, coords = pedCoords
                    })
                else
                    -- CARJACKING
                    TriggerServerEvent("Emergency:Server:MarkStolen", plate, true, true)
                    --TriggerServerEvent("Emergency:Server:CADAlerts", "Carjacking", location, {model = GetEntityModel(veh), color = primary, plate = plate}, pos)
                    TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = true, type = "Carjacking",
                        loc = loc, model = GetEntityModel(veh), color = primary, plate = plate, coords = pedCoords
                    })
                end
            else
                if GetIsVehicleEngineRunning(veh) then
                    -- GRAND THEFT AUTO
                    TriggerServerEvent("Emergency:Server:MarkStolen", plate, true, true)
                    --TriggerServerEvent("Emergency:Server:CADAlerts", "Grand Theft Auto", location, {model = GetEntityModel(veh), color = primary, plate = plate}, pos)
                    TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = true, type = "Grand Theft Auto",
                        loc = loc, model = GetEntityModel(veh), color = primary, plate = plate, coords = pedCoords
                    })
                else
                    -- VEHICLE BREAK-IN
                    TriggerServerEvent("Emergency:Server:MarkStolen", plate, true, true)
                    --TriggerServerEvent("Emergency:Server:CADAlerts", "Vehicle Break-In", location, {model = GetEntityModel(veh), color = primary, plate = plate}, pos)
                    TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = true, type = "Vehicle Break-In",
                        loc = loc, model = GetEntityModel(veh), color = primary, plate = plate, coords = pedCoords
                    })
                end
            end
        end
    else
        SetVehicleDoorsLocked(veh, 2)

        local shouldReport = true
        if ((driver == nil or driver == false) and math.random(1, 10) > 5) then
            if shouldReport then

                -- NO CADS IF PLAYER IS POLICE AND ON DUTY
                if myJob == "POLICE" then return end

                -- ATTEMPTED VEHICLE BREAK-IN
                --TriggerServerEvent("Emergency:Server:CADAlerts", "Attempted Vehicle Break-In", location, {model = GetEntityModel(veh), color = primary, plate = plate}, pos)
                TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = true, type = "Attempted Vehicle Break-In", loc = loc, coords = pedCoords})
            end
        else
            shouldReport = exports["soe-emergency"]:ShouldReportInThisArea()
            local occupied = (((driver ~= nil and driver ~= 0) and not IsPedDeadOrDying(driver)))
            -- IF LEO, DON'T REPORT IT STOLEN
            shouldReport = (shouldReport or occupied)

            -- NO CADS IF PLAYER IS POLICE AND ON DUTY
            if myJob == "POLICE" then return end

            if shouldReport then
                if occupied then
                    if IsPedArmed(PlayerPedId(), 7) then
                        -- ATTEMPTED ARMED CARJACKING
                        --TriggerServerEvent("Emergency:Server:CADAlerts", "Attempted Armed Carjacking", location, {model = GetEntityModel(veh), color = primary, plate = plate}, pos)
                        TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = true, type = "Attempted Armed Carjacking",
                            loc = loc, model = GetEntityModel(veh), color = primary, plate = plate, coords = pedCoords
                        })
                    else
                        -- ATTEMPTED CARJACKING
                        --TriggerServerEvent("Emergency:Server:CADAlerts", "Attempted Carjacking", location, {model = GetEntityModel(veh), color = primary, plate = plate}, pos)
                        TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = true, type = "Attempted Carjacking",
                            loc = loc, model = GetEntityModel(veh), color = primary, plate = plate, coords = pedCoords
                        })
                    end
                else
                    -- ATTEMPTED VEHICLE BREAK-IN
                    --TriggerServerEvent("Emergency:Server:CADAlerts", "Attempted Vehicle Break-In", location, {model = GetEntityModel(veh), color = primary, plate = plate}, pos)
                    TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = true, type = "Attempted Vehicle Break-In", loc = loc, coords = pedCoords})
                end
            end
        end
    end
end)
