local keys = {}
local spawnedVehicles = {}

-- ***********************
--     Local Functions
-- ***********************
-- WHEN TRIGGERED, FIND THE CLOSEST GARAGE AND SEARCH IT BY CHARID
local function SearchGarage(src, charID)
    local pos = GetEntityCoords(GetPlayerPed(src))
    for _, garage in pairs(garages) do
        if #(pos - garage.pos) <= 3.0 then
            TriggerClientEvent("Valet:Client:SearchGarage", src, {status = true, name = garage.name, charID = charID})
            break
        end
    end
end

-- ***********************
--    Global Functions
-- ***********************
-- RETURNS IF A VEHICLE IS SPAWNED
function IsVehicleSpawned(networkID)
    return spawnedVehicles[networkID]
end

-- RETURNS VIN OF VEHICLE THROUGH NETWORK ID
function GetVehicleVIN(networkID)
    if spawnedVehicles[networkID] then
        return spawnedVehicles[networkID].VehicleID
    end
    return false
end

-- ***********************
--       Commands
-- ***********************
RegisterCommand("givekeys", function(source)
    local src = source
    TriggerClientEvent("Valet:Client:GiveKeyOptions", src)
end)

RegisterCommand("searchgarage", function(source, args)
    local src = source
    if (exports["soe-jobs"]:GetJob(src) == "POLICE") then
        SearchGarage(src, tonumber(args[1]))
    end
end)

-- ***********************
--        Events
-- ***********************
-- WHEN TRIGGERED, CALLBACK TO CLIENT WITH SAVED KEYS
AddEventHandler("Valet:Server:RequestKeys", function(cb, src)
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    if (keys[charID] ~= nil) then
        cb(keys[charID])
    end
end)

-- WHEN TRIGGERED, CALLBACK TO CLIENT WITH SAVED GARAGE ACCESSES
AddEventHandler("Valet:Server:GetGarageAccess", function(cb, src, charID, propertyID)
    local access = exports["soe-properties"]:GetPlayerPropertyAccess(charID, propertyID)
    if (access == "OWNER" or access == "TENANT") then
        cb(true)
    else
        cb(false)
    end
end)

-- WHEN TRIGGERED, CALLBACK TO CLIENT WITH INFORMATION OF THE VEHICLE
AddEventHandler("Valet:Server:GetVehicleInfo", function(cb, src, plate)
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    local requestVehInfo = exports["soe-nexus"]:PerformAPIRequest("/api/valet/requestplate", ("plate=%s"):format(plate), true)
    if requestVehInfo.status then
        if (tonumber(charID) == requestVehInfo.data.OwnerID) then
            print(json.encode(requestVehInfo.data))
            cb(requestVehInfo.data)
        end
    else
        cb(nil)
    end
end)

-- REGISTERS VEHICLE AS SPAWNED FOR INVENTORY ACCESS
RegisterNetEvent("Valet:Server:RegisterVehicleSpawned")
AddEventHandler("Valet:Server:RegisterVehicleSpawned", function(vehicleData, networkID)
    local src = source
    print("Vehicle saved in spawned vehicles table", vehicleData.VehicleID)
    spawnedVehicles[networkID] = vehicleData
end)

-- TRIGGERED WHEN UPDATING A VEHICLE'S CONDITION
RegisterNetEvent("Valet:Server:UpdateVehicleConditions", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 687-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data["status"] then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 687-2 | Lua-Injecting Detected.", 0)
        return
    end

    local dataString = ("vin=%s&fuel=%s&engine=%s&body=%s"):format(data["vin"], data["fuel"], data["engineCondition"], data["bodyCondition"])
    exports["soe-nexus"]:PerformAPIRequest("/api/valet/updatecondition", dataString, true)
end)

-- WHEN TRIGGERED, SYNC VEHICLE DOOR LOCKS THROUGH ALL CLIENTS
RegisterNetEvent("Valet:Server:EnsureLocks", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 634-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data["status"] then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 634-2 | Lua-Injecting Detected.", 0)
        return
    end

    local ped = GetPlayerPed(src)
    if (GetVehiclePedIsIn(ped, false) == 0) then
        TaskPlayAnim(ped, "anim@mp_player_intmenu@key_fob@", "fob_click_fp", 3.0, 3.0, 900, 49, 0, 0, 0, 0)
    end
    TriggerClientEvent("Valet:Client:EnsureLocks", -1, data["vehID"], data["lock"])

    --[[local veh = NetworkGetEntityFromNetworkId(data["vehID"]) -- EVENTUALLY WE SHALL TEST RPC NATIVES OF 'SetVehicleDoorLocked'
    print(veh, DoesEntityExist(veh), GetVehicleDoorLockStatus(veh))]]

    -- SEND NOTIFICATIONS AND PLAY PROXIMITY SOUND TO SOURCE
    if data["lock"] then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Vehicle Locked", length = 800})
        exports["soe-utils"]:PlayProximitySound(src, 5.5, "veh-lock.ogg", 0.42)
    else
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Vehicle Unlocked", length = 800})
        exports["soe-utils"]:PlayProximitySound(src, 5.5, "veh-unlock.ogg", 0.42)
    end
end)

-- PARKS VEHICLE BY VIN NUMBER
RegisterNetEvent("Valet:Server:ParkVehicleByVIN")
AddEventHandler("Valet:Server:ParkVehicleByVIN", function(vin, silent)
    local src = source
    local parkVehicle = exports["soe-nexus"]:PerformAPIRequest("/api/valet/parkvehicle", ("vin=%s&parked=%s"):format(vin, 0), true)
    if parkVehicle.status then
        if silent then return end
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "Parked VIN: " .. vin, length = 5000})
        exports["soe-logging"]:ServerLog("VIN Reparked", "HAS REPARKED VIN #" .. vin, src)
    else
        if silent then return end
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Could not park VIN: " .. vin, length = 5000})
        exports["soe-logging"]:ServerLog("VIN Reparked - Failed", "HAS FAILED TO REPARK VIN #" .. vin, src)
    end
end)

-- WHEN TRIGGERED, GIVE THE TARGET ID KEYS TO THE VEHICLE
RegisterNetEvent("Valet:Server:GiveKeys")
AddEventHandler("Valet:Server:GiveKeys", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 633-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 633-2 | Lua-Injecting Detected.", 0)
        return
    end

    -- NOTIFY BOTH PARTIES
    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "You give a spare set of keys to the " .. data.model, length = 5500})
    TriggerClientEvent("Notify:Client:SendAlert", data.serverID, {type = "warning", text = "You received keys for a " .. data.model, length = 5500})

    -- GIVE THE TARGET KEYS
    TriggerClientEvent("Valet:Client:GiveKeys", data.serverID, data.veh)
end)

-- UPDATES SERVER-SIDED KEY TABLE FOR A CHARACTER
RegisterNetEvent("Valet:Server:UpdateKeys", function(plate, veh)
    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    if (charID == nil) then
        return
    end

    if (keys[charID] == nil) then
        keys[charID] = {}
    end

    -- CHECK IF THE CHARACTER ID DOES NOT ALREADY HAVE A KEY
    local myVehicle
    for _, key in pairs(keys[charID]) do
        if (key["plate"] == plate) then
            myVehicle = true
            break
        end
    end

    -- IF DOES NOT HAVE KEY, GIVE THEM ONE
    if not myVehicle then
        keys[charID][#keys[charID] + 1] = {plate = plate, entity = veh}
        exports["soe-logging"]:ServerLog("Keys Given (Successful)", ("HAS BEEN GIVEN KEYS TO PLATE %s AND NET ID OF %s"):format(plate, veh), src)
    else
        exports["soe-logging"]:ServerLog("Keys Given (Failed - Already Exists)", ("HAS NOT BEEN GIVEN KEYS TO PLATE %s AND NET ID OF %s"):format(plate, veh), src)
    end
end)

-- PARKS VEHICLE
AddEventHandler("Valet:Server:ParkVehicle", function(cb, src, networkID, vehicleEntity, garageName, plate, requiredPermission)
    -- UNMARK VEHICLE FOR IMPOUND ONCE IT IS PARKED
    exports["soe-emergency"]:UnmarkForImpound(plate)

    -- DENY PARKING IF ITS THE IMPOUND LOT
    if (garageName == "Davis Impound Lot") then
        cb(false)
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Access Denied! | This is an impound lot! Not a public garage!", length = 5000})
        return
    end

    -- CHECK IF ITS A VALID VEHICLE TO PARK
    if spawnedVehicles[networkID] and spawnedVehicles[networkID]["VehicleID"] then
        if requiredPermission ~= nil then -- CHECK IF THE GARAGE REQUIRES BUSINESS PERMS
            if not exports["soe-factions"]:CheckPermission(src, requiredPermission) then
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Access Denied! | You do not have permission to park here!", length = 5000})
                return cb(false)
            end
        end

        local dataString = ("vin=%s&parked=%s&garage=%s"):format(spawnedVehicles[networkID]["VehicleID"], 0, garageName)
        local parkVehicle = exports["soe-nexus"]:PerformAPIRequest("/api/valet/parkvehicle", dataString, true)
        if parkVehicle.status then
            cb(true)
            if networkID and garageName and (spawnedVehicles[networkID] ~= nil and spawnedVehicles[networkID]["VehicleID"] ~= nil) then
                exports["soe-logging"]:ServerLog("Vehicle Parked", ("HAS PARKED VIN #%s AT %s"):format(spawnedVehicles[networkID]["VehicleID"], garageName), src)
            end

            spawnedVehicles[networkID] = nil -- REMOVE VEHICLE FROM SPAWNED VEHICLES TABLE
        else
            cb(false)
        end
    else
        cb(false)
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "This vehicle could not be parked", length = 5000})
    end
end)

-- PARKS VEHICLE
AddEventHandler("Valet:Server:ParkVehicleAtProperty", function(cb, src, networkID, vehicleEntity, property, plate)
    -- UNMARK VEHICLE FOR IMPOUND ONCE IT IS PARKED
    exports["soe-emergency"]:UnmarkForImpound(plate)

    local vehiclesInGarage = exports["soe-nexus"]:PerformAPIRequest('/api/valet/requestdata', ("location=%s"):format("property-" .. property.id), true)
    if vehiclesInGarage.status == true and exports["soe-utils"]:GetTableSize(vehiclesInGarage.data) >= property.garage.capacity then
        local alreadyHere = false
        for _, vehicle in pairs(vehiclesInGarage.data) do
            if networkID and (spawnedVehicles[networkID] ~= nil and spawnedVehicles[networkID].VehicleID ~= nil) then
                if (vehicle.VehicleID == spawnedVehicles[networkID].VehicleID) then
                    alreadyHere = true
                    print("GARAGE IS FULL - BUT THIS VEHICLE ALREADY OCCUPIES A SPACE HERE")
                end
            end
        end    

        if not alreadyHere then
            cb(false)
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "There's no more space in this garage!", length = 5000})
            return
        end
    end

    -- CHECK IF ITS A VALID VEHICLE TO PARK
    if spawnedVehicles[networkID] then
        local dataString = ("vin=%s&parked=%s&garage=%s"):format(spawnedVehicles[networkID].VehicleID, 0, "property-" .. property.id)
        local parkVehicle = exports["soe-nexus"]:PerformAPIRequest("/api/valet/parkvehicle", dataString, true)
        if parkVehicle.status then
            cb(true)
            if spawnedVehicles[networkID] and spawnedVehicles[networkID].VehicleID and property.id then
                exports["soe-logging"]:ServerLog("Vehicle Parked", ("HAS PARKED VIN #%s AT Property ID: %s"):format(spawnedVehicles[networkID].VehicleID, property.id), src)
            end

            -- REMOVE VEHICLE FROM SPAWNED VEHICLES TABLE
            spawnedVehicles[networkID] = nil
        else
            cb(false)
            print("A fatal error occurred while performing the vehicle parking API call.")
        end
    else
        cb(false)
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "This vehicle could not be parked", length = 5000})
    end
end)

-- SERVER CALLBACKS
AddEventHandler("Valet:Server:GetGarageData", function(cb, src, garageName, charID, isBusinessGarage)
    local APICallback
    if string.find(garageName, "property") or isBusinessGarage then
        APICallback = exports["soe-nexus"]:PerformAPIRequest('/api/valet/requestdata', ("location=%s"):format(garageName), true)
    else
        APICallback = exports["soe-nexus"]:PerformAPIRequest('/api/valet/requestdata', ("ownerid=%s&location=%s"):format(charID, garageName), true)
    end
    if APICallback.status then
        cb(APICallback)
    else
        cb(false)
    end
end)

AddEventHandler("Valet:Server:SpawnVehicleFromGarage", function(cb, src, vin)
    local vin = tonumber(vin)
    local charid = exports["soe-uchuu"]:GetOnlinePlayerList()[tonumber(src)].CharID
    local GetVehicleByVIN = exports["soe-nexus"]:PerformAPIRequest('/api/valet/getlocationbyvin', ("vin=%s"):format(vin), true)
    if GetVehicleByVIN.status then
        local vehicleData = GetVehicleByVIN.data
        if tonumber(charid) == tonumber(vehicleData.OwnerID) or string.find(vehicleData.Location, "property") or string.find(vehicleData.Location, "- Land") or string.find(vehicleData.Location, "- Air") or string.find(vehicleData.Location, "- Sea") then
            -- Character owns vehicle
            if (vehicleData.IsOut == 0) then
                -- Vehicle is not checked out
                local APIRequest = exports["soe-nexus"]:PerformAPIRequest('/api/valet/parkvehicle', ("vin=%s&parked=%s"):format(vehicleData.VehicleID, 1), true)
                if APIRequest.status then
                    exports["soe-logging"]:ServerLog("Vehicle Spawned From Garage", ("HAS SPAWNED VIN #%s FROM %s"):format(vin, vehicleData.Location), src)
                    cb(vehicleData)
                else
                    cb({})
                end
            else
                -- Vehicle is checked out
                cb({IsOut = vehicleData.IsOut})
            end
        else
            -- Character does not own vehicle they are attempting to spawn
            cb({})
        end
    else
        cb(false)
    end
end)

-- REPARKS VEHICLES UPON STARTUP
CreateThread(function()
    Wait(2000)
    -- DO MASS-REPARKING
    print("MASS-REPARKING VEHICLES...")

    -- MOVE THESE BOTH SOMEWHERE ELSE IN THE FUTURE
    exports["soe-nexus"]:PerformAPIRequest("/api/valet/parkallvehicles", "", true)
    exports["soe-nexus"]:PerformAPIRequest("/api/bills/process", "", true)
end)
