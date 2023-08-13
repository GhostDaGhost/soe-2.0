local confirmations = {}

-- **********************
--    Local Functions
-- **********************
-- MAIN FUNCTION TO BEGIN TRANSFERSHIP
local function ConfirmTransfership(src, accepted)
    if confirmations[src] then
        if accepted then
            if (confirmations[src].time >= os.time()) then
                local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
                local transferVehicleAPI = exports["soe-nexus"]:PerformAPIRequest("/api/valet/transfervehicle", ("charid=%s&vin=%s"):format(charID, confirmations[src].vin), true)
                if transferVehicleAPI.status then
                    exports["soe-logging"]:ServerLog("DMV - Transfer Accepted", "HAS ACCEPTED A VEHICLE TRANSFER | VIN: " .. confirmations[src].vin, src)
                    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "Congratulations! You now own this vehicle!", length = 5500})
                    TriggerClientEvent("Notify:Client:SendAlert", confirmations[src].src, {type = "success", text = "Vehicle transfer accepted! Bye bye to your vehicle!", length = 5500})
                    confirmations[src] = nil
                end
            else
                exports["soe-logging"]:ServerLog("DMV - Transfer Failure", "WAS TOO LATE TO ACCEPT A VEHICLE TRANSFER | VIN: " .. confirmations[src].vin, src)
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Too late on that buddy!", length = 5500})
                confirmations[src] = nil
            end
        else
            local fee = 35
            if exports["soe-config"]:GetConfigValue("economy", "dmv_fee") then
                fee = exports["soe-config"]:GetConfigValue("economy", "dmv_fee")
            end

            local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[confirmations[src].src].CharID
            exports["soe-bank"]:PayPrimary(confirmations[src].src, charID, fee, "DMV Transfer Refund")
            TriggerClientEvent("Notify:Client:SendAlert", confirmations[src].src, {type = "error", text = "The individual denied your transfer!", length = 5500})

            exports["soe-logging"]:ServerLog("DMV - Transfer Denied", "HAS DENIED A VEHICLE TRANSFER | VIN: " .. confirmations[src].vin, src)
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You denied a vehicle transfer", length = 5500})
            confirmations[src] = nil
        end
    end
end

-- **********************
--        Events
-- **********************
-- EVENT EXECUTED WHEN GIVING A VEHICLE TO ANOTHER PLAYER
RegisterNetEvent("Shops:Server:ConfirmVehicleTransfer")
AddEventHandler("Shops:Server:ConfirmVehicleTransfer", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 556 | Lua-Injecting Detected.", 0)
        return
    end

    ConfirmTransfership(src, data.response)
end)

-- EVENT EXECUTED WHEN PLAYERS GETS A CUSTOM PLATE
RegisterNetEvent("Shops:Server:GetCustomPlate")
AddEventHandler("Shops:Server:GetCustomPlate", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 1403-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 1403-2 | Lua-Injecting Detected.", 0)
        return
    end

    -- OWNERSHIP OF VEHICLE CHECK
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    local ownershipCheck = exports["soe-nexus"]:PerformAPIRequest("/api/valet/requestplate", ("plate=%s"):format(data.plate), true)
    if ownershipCheck.status then
        local fee = 4500
        if exports["soe-config"]:GetConfigValue("economy", "dmv_fee_customplate") then
            fee = exports["soe-config"]:GetConfigValue("economy", "dmv_fee_customplate")
        end

        -- IF THIS VEHICLE DOESN'T BELONG TO THE SOURCE
        local plate = (data.newPlate):upper()
        if (tonumber(charID) ~= ownershipCheck.data.OwnerID) then
            exports["soe-bank"]:PayPrimary(src, charID, fee, "DMV - Custom Plate Refund")
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "This vehicle is not yours!", length = 5500})

            local msg = ("HAS FAILED TO CHANGE THEIR VEHICLE PLATE | VIN: %s | MODEL: %s | ORIGINAL PLATE: %s | NEW PLATE: %s | REASON: DOES NOT OWN THIS VEHICLE."):format(data.vin, data.model, data.plate, plate)
            exports["soe-logging"]:ServerLog("DMV - Custom Plate Failed", msg, src)
            return
        end

        -- CHECK IF THE PLATE EXISTS ALREADY IN THE DB
        local existingPlateCheck = exports["soe-nexus"]:PerformAPIRequest("/api/valet/requestplate", ("plate=%s"):format(plate), true)
        if existingPlateCheck.status then
            exports["soe-bank"]:PayPrimary(src, charID, fee, "DMV - Custom Plate Refund")
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = ("Plate %s is already taken! You have been refunded"):format(plate), length = 10000})

            local msg = ("HAS FAILED TO CHANGE THEIR VEHICLE PLATE | VIN: %s | MODEL: %s | ORIGINAL PLATE: %s | NEW PLATE: %s | REASON: PLATE ALREADY EXISTS."):format(data.vin, data.model, data.plate, plate)
            exports["soe-logging"]:ServerLog("DMV - Custom Plate Failed", msg, src)
            return
        end

        -- CHANGE THE PLATE THROUGH THE API REQUEST
        local changePlate = exports["soe-nexus"]:PerformAPIRequest("/api/valet/updatemods", ("vin=%s&newplate=%s"):format(data.vin, plate), true)
        if changePlate.status then
            TriggerClientEvent("Shops:Client:ConfirmCustomPlate", src, {status = changePlate.status, veh = data.veh, plate = tostring(plate)})
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = ("A DMV worker comes out and changes the vehicle plate. The plate of the %s has been changed to: %s"):format(data.model, plate), length = 15000})

            local msg = ("HAS CHANGED THEIR VEHICLE PLATE | VIN: %s | MODEL: %s | ORIGINAL PLATE: %s | NEW PLATE: %s"):format(data.vin, data.model, data.plate, plate)
            exports["soe-logging"]:ServerLog("DMV - Custom Plate Changed", msg, src)
        end
    end
end)

-- EVENT EXECUTED WHEN GIVING A VEHICLE TO ANOTHER PLAYER
RegisterNetEvent("Shops:Server:SellVehicleAtDMV")
AddEventHandler("Shops:Server:SellVehicleAtDMV", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 555 | Lua-Injecting Detected.", 0)
        return
    end

    -- OWNERSHIP OF VEHICLE CHECK
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    local ownershipCheck = exports["soe-nexus"]:PerformAPIRequest("/api/valet/requestplate", ("plate=%s"):format(data.plate), true)
    if ownershipCheck.status then
        local fee = 35
        if exports["soe-config"]:GetConfigValue("economy", "dmv_fee") then
            fee = exports["soe-config"]:GetConfigValue("economy", "dmv_fee")
        end

        -- IF THIS VEHICLE DOESN'T BELONG TO THE SOURCE
        if (tonumber(charID) ~= ownershipCheck.data.OwnerID) then
            exports["soe-bank"]:PayPrimary(src, charID, fee, "DMV Transfer Refund")
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "This vehicle is not yours!", length = 5500})
            return
        end

        -- CHECK IF THE SSN BELONGS TO SOMEONE ONLINE
        if not data.target then return end
        local serverID = exports["soe-uchuu"]:GetSourceByCharacterID(data.target)
        if serverID then
            -- DISTANCE CHECK FOR SECURITY REASONS
            if #(GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(serverID))) > 10.5 then
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You are too far from the other individual!", length = 5500})
                return
            end

            -- LOG FOR SECURITY REASONS
            confirmations[serverID] = {vin = data.vin, time = os.time() + 120, src = src}
            local msg = ("HAS REQUESTED A VEHICLE TRANSFER | VIN: %s | MODEL: %s | PLATE: %s | TARGET CHARID: %s"):format(data.vin, data.model, data.plate, data.target)
            exports["soe-logging"]:ServerLog("DMV - Transfer Request", msg, src)

            -- NOTIFICATIONS
            TriggerClientEvent("Shops:Client:ConfirmVehicleTransfer", serverID)
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "You pass some paperwork to the other individual to confirm the transfer", length = 5500})
            TriggerClientEvent("Chat:Client:Message", serverID, "[DMV]", ("You have two minutes to validate the vehicle transfer of a %s (Plate: %s | VIN: %s) to your possession."):format(data.model, data.plate, data.vin), "standard")
        else
            exports["soe-bank"]:PayPrimary(src, charID, fee, "DMV Transfer Refund")
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "The individual does not exist! Refunding you now", length = 5500})
        end
    end
end)
