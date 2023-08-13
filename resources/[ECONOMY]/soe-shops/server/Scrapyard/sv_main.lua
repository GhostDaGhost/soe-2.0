-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, GRAB SCRAP VALUE OF THE VEHICLE
local function GetScrapValue(hash)
    -- GET ECONOMY VALUE FROM THE VEHICLE
    local amount = 0
    --print(hash)
    if exports["soe-config"]:GetConfigValue("economy", hash) then
        amount = exports["soe-config"]:GetConfigValue("economy", hash).buy
    end

    -- PERFORM SOME MATH AND THEN CALLBACK
    --print("PRICE BEFORE: ", amount)
    amount = math.floor(amount * 0.2)
    --print("PRICE AFTER: ", amount)
    return amount
end

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, CALLBACK TO CLIENT OF THE VEHICLE SCRAP PRICE
AddEventHandler("Shops:Server:GetScrapPrice", function(cb, src, hash)
    hash = string.lower(hash)
    local amount = GetScrapValue(hash)
    cb(amount)
end)

-- WHEN TRIGGERED, SCRAP VEHICLE AND DELETE IT FROM THE DATABASE
RegisterNetEvent("Shops:Server:ConfirmVehicleScrap")
AddEventHandler("Shops:Server:ConfirmVehicleScrap", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 1002 | Lua-Injecting Detected.", 0)
        return
    end

    -- SECURITY CHECK #2
    if not data.response then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 1003 | Lua-Injecting Detected.", 0)
        return
    end

    -- ERROR CHECKS
    if not data.plate then error("Plate for scrapping was nil.") return end
    if not data.vin then error("VIN for scrapping was nil.") return end

    -- OWNERSHIP OF VEHICLE CHECK
    local ownershipCheck = exports["soe-nexus"]:PerformAPIRequest("/api/valet/requestplate", ("plate=%s"):format(data.plate), true)
    if ownershipCheck.status then
        -- IF THIS VEHICLE DOESN'T BELONG TO THE SOURCE
        local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
        if (tonumber(charID) ~= ownershipCheck.data.OwnerID) then
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "This vehicle is not yours!", length = 5500})
            exports["soe-logging"]:ServerLog("Vehicle Scrapped (Failure)", "COULD NOT SCRAP A VEHICLE | REASON: DOES NOT OWN THIS. | VIN: " .. data.vin, src)
            return
        end

        if not data.hash then error("Hash for scrapping was nil.") return end
        local scrapVehicle = exports["soe-nexus"]:PerformAPIRequest("/api/valet/removevehicle", ("vin=%s"):format(data.vin), true)
        if scrapVehicle.status then
            TriggerClientEvent("Shops:Client:ScrapVehicle", src, {response = scrapVehicle.status})

            local hash = string.lower(data.hash)
            local amount = GetScrapValue(hash)
            if exports["soe-inventory"]:AddItem(src, "char", charID, "cash", amount, "{}") then
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "You scrapped your vehicle for $" .. tostring(amount), length = 5500})
            end

            exports["soe-logging"]:ServerLog("Vehicle Scrapped", ("SCRAPPED A VEHICLE | VIN: %s | AMOUNT: $%s"):format(data.vin, amount), src)
        end
    else
        exports["soe-logging"]:ServerLog("Vehicle Scrapped (Failure)", "COULD NOT SCRAP A VEHICLE | REASON: API FAILURE. | VIN: " .. data.vin, src)
    end
end)
