-- GENERATES A LICENSE PLATE AFTER PURCHASE
function GeneratePlate()
    local plate = ""
    local digits = {}
    local letters = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L",
    "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}

    -- BEGIN GENERATING PLATE
    math.randomseed(os.time())
    digits[1] = math.random(0, 9)
    digits[2] = math.random(0, 9)
    digits[3] = letters[math.random(1, 26)]
    digits[4] = letters[math.random(1, 26)]
    digits[5] = letters[math.random(1, 26)]
    digits[6] = math.random(0, 9)
    digits[7] = math.random(0, 9)
    digits[8] = math.random(0, 9)

    Wait(350)
    for i = 1, #digits do
        plate = plate .. digits[i]
    end
    Wait(250)

    -- CHECK IF PLATE DOESN'T ALREADY EXIST
    local checkPlate = exports["soe-nexus"]:PerformAPIRequest("/api/valet/requestplate", string.format("plate=%s", plate), true)
    if checkPlate.status then
        -- IF THE PLATE ALREADY COMES BACK TO A OWNED VEHICLE
        print("REROLL!")
        GeneratePlate()
    else
        -- IF THE PLATE DOES NOT RETURN TO A OWNED VEHICLE ALREADY
        print("SUCCESS FOR THE PLATE!")
        return plate
    end

    return nil
end

-- CALLED FROM SERVER TO HANDLE PURCHASE OF A VEHICLE
RegisterNetEvent("Shops:Server:PurchaseMyVehicle")
AddEventHandler("Shops:Server:PurchaseMyVehicle", function(hash, model, price, mods, defaultGarage)
    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID

    local plate = GeneratePlate()
    if (plate ~= nil) then
        local dataString = string.format("ownerid=%s&model=%s&hash=%s&reg=%s&custom=%s&location=%s&out=%s", charID, model, hash, plate, mods, defaultGarage, 1)
        local addVehicle = exports["soe-nexus"]:PerformAPIRequest("/api/valet/add", dataString, true)
        if addVehicle.status then
            -- CONFIRM PURCHASE
            --print(hash, model, plate)
            local data = {VehicleID = addVehicle.data.VehicleID, OwnerID = charID}
            TriggerClientEvent("Shops:Client:PurchaseMyVehicle", src, hash, plate, addVehicle.data.VehicleID, data)
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "Congratulations on the purchase of your vehicle!", length = 5000})

            -- LOG PURCHASE
            local msg = ("HAS PURCHASED A VEHICLE | PRICE: $%s | HASH: %s | COORDS: %s"):format(price, hash, GetEntityCoords(GetPlayerPed(src)))
            exports["soe-logging"]:ServerLog("Vehicle Purchase", msg, src)
        end
    else
        -- FAILED TO PURCHASE
        print("DID NOT GENERATE PLATE CORRECTLY")
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "There was an error generating the license plate of your vehicle", length = 5000})

        local msg = ("HAS FAILED TO PURCHASED A VEHICLE | PRICE: $%s | HASH: %s | COORDS: %s | REASON: FAILED TO GENERATE PLATE"):format(price, hash, GetEntityCoords(GetPlayerPed(src)))
        exports["soe-logging"]:ServerLog("Vehicle Purchase (Failed)", msg, src)
    end
end)
