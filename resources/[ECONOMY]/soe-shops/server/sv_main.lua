local seedCooldowns = {}
local waitingForSaleTracker = {}

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, BUY WEED SEEDS FROM GRANDMA
RegisterNetEvent("Shops:Server:BuyWeedSeeds")
AddEventHandler("Shops:Server:BuyWeedSeeds", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 3843-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 3843-2 | Lua-Injecting Detected.", 0)
        return
    end

    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    if seedCooldowns[charID] then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "I only have a limited supply! You aren't getting any right now", length = 5000})
        return
    end

    if exports["soe-inventory"]:AddItem(src, "char", charID, data.item, 5, "{}") then
        if not seedCooldowns[charID] then
            seedCooldowns[charID] = true
            SetTimeout(3600000, function()
                seedCooldowns[charID] = false
                exports["soe-logging"]:ServerLog("Seed Purchase Cooldown Over", "WEED SEED PURCHASE COOLDOWN IS OVER FOR SSN: " .. charID)
            end)
        end

        exports["soe-inventory"]:RemoveItem(src, data.price, "cash")
        local msg = ("HAS BOUGHT A WEED SEED | NAME: %s | PRICE: %s | COORDS: %s"):format(data.item, data.price, GetEntityCoords(GetPlayerPed(src)))
        exports["soe-logging"]:ServerLog("Weed Seed Bought", msg, src)
    end
end)

-- CALLED FROM CLIENT FOR ITEM SOLD TO A SHOP
RegisterNetEvent("Shops:Server:SellItem")
AddEventHandler("Shops:Server:SellItem", function(item, amount, price)
    local src = source
    print(json.encode(item))
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    if (exports["soe-inventory"]:GetItemAmt(src, item.hash, "left") >= tonumber(amount)) then
        -- REMOVE ITEM SOLD AND ADD CASH
        exports["soe-inventory"]:RemoveItem(src, tonumber(amount), item.hash)
        if exports["soe-inventory"]:AddItem(src, "char", charID, "cash", price, "{}") then
            -- NOTIFY SOURCE & LOG SALE
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = ("You sold %sx %s"):format(amount, item.name), length = 2500})

            local msg = ("HAS SOLD AN ITEM | NAME: %s | PRICE: %s | AMOUNT: %s | COORDS: %s"):format(item.name, price, amount, GetEntityCoords(GetPlayerPed(src)))
            exports["soe-logging"]:ServerLog("Item Sold", msg, src)
        end
    else
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = ("You do not have enough %s"):format(item.name), length = 2500})
    end
end)

-- PROCESS A TRANSACTION FROM THE TRANSACTION UI
-- RegisterNetEvent("Shops:Server:ProcessTransaction")
AddEventHandler("Shops:Server:ProcessTransaction", function(cb, src, transactionData, totalPrice, statementText, item, storeType)
    local status = nil
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID

    -- Process taxes
    local tax = ProcessTaxes(transactionData, totalPrice, item, storeType)

    -- If tax rates can't be found, force quit transaction
    if not tax then cb({["status"] = false, ["message"] = "Critical error - failed to get tax for this transaction."}) return false end

    -- CASH
    if transactionData.type == "cash" then
        if totalPrice == 0 then
            status = true
            cb({["status"] = true, ["message"] = "Success"})
            exports["soe-logging"]:ServerLog("Cash Transaction - Success", ("HAS PROCESSED A TRANSACTION | PRICE: %s | DATA: %s"):format(totalPrice, json.encode(transactionData)), src)
        else
            local cashValue = exports["soe-inventory"]:GetItemAmt(src, "cash", "left")

            -- INSUFFICIENT FUNDS
            if cashValue < totalPrice then
                status = false
                cb({["status"] = false, ["message"] = "Insufficient Funds."})
                exports["soe-logging"]:ServerLog("Cash Transaction - Insufficent Funds", ("HAS FAILED TO PROCESS A TRANSACTION | PRICE: %s | DATA: %s"):format(totalPrice, json.encode(transactionData)), src)
            elseif exports["soe-inventory"]:RemoveItem(src, totalPrice, "cash") then
                status = true
                cb({["status"] = true, ["message"] = "Success"})
                exports["soe-logging"]:ServerLog("Cash Transaction - Success", ("HAS PROCESSED A TRANSACTION | PRICE: %s | DATA: %s"):format(totalPrice, json.encode(transactionData)), src)

                PayTaxForCashTransaction(totalPrice, tax)
            else
                status = false
                cb({["status"] = false, ["message"] = "Insufficient Funds."})
            end
        end

    -- DEBIT
    elseif transactionData.type == "debit" then

        local dataString

        if tax.type == "percent" then
            dataString = string.format("cardnumber=%s&pin=%s&type=%s&amount=%s&charid=%s&merchant=%s&title=%s&taxpercent=%s", transactionData.cardnumber, transactionData.pin, "purchase", totalPrice, charID, 0, statementText, tax.rate)
        elseif tax.type == "fixed" then
            dataString = string.format("cardnumber=%s&pin=%s&type=%s&amount=%s&charid=%s&merchant=%s&title=%s&taxamount=%s", transactionData.cardnumber, transactionData.pin, "purchase", totalPrice, charID, 0, statementText, tax.rate)
        end
        
        local transactionAPI = exports["soe-nexus"]:PerformAPIRequest("/api/bank/processtransaction", dataString, true)

        -- PROCESSED
        if transactionAPI.status == true then
            status = true
            cb({["status"] = true, ["message"] = "Success"})
            exports["soe-logging"]:ServerLog("Debit Transaction - Success", ("HAS PROCESSED A TRANSACTION | PRICE: %s | DATA: %s"):format(totalPrice, transactionData), src)

        -- PIN MATCH FAILED
        elseif transactionAPI.status == false and string.find(transactionAPI.message, "pin match failed") then
            status = false
            cb({["status"] = false, ["message"] = "Card/Pin Match Failed."})
            exports["soe-logging"]:ServerLog("Debit Transaction - Pin Match Failed", ("HAS FAILED TO PROCESS A TRANSACTION | PRICE: %s | DATA: %s"):format(totalPrice, transactionData), src)

        -- INSUFFICIENT FUNDS
        elseif transactionAPI.status == false and string.find(transactionAPI.message, "insufficient") then
            status = false
            cb({["status"] = false, ["message"] = "Insufficient Funds."})
            exports["soe-logging"]:ServerLog("Debit Transaction - Insufficient Funds", ("HAS FAILED TO PROCESS A TRANSACTION | PRICE: %s | DATA: %s"):format(totalPrice, transactionData), src)

        -- UNKNOWN ERROR
        else
            status = false
            cb({["status"] = false, ["message"] = "Unexpected error."})
            exports["soe-logging"]:ServerLog("Cash Transaction - Unknown Error", ("HAS FAILED TO PROCESS A TRANSACTION | PRICE: %s | DATA: %s"):format(totalPrice, transactionData), src)
        end
    end

    -- GIVE AN ITEM IF INCLUDED
    if status == true and item ~= nil then
        if not item.item or not item.amt then
            return
        end

        -- PHONES
        if item.item == "cellphone" and item.phoneStyle then
            local dataString = ("func=%s&model=%s&style=%s&charid=%s"):format("create", "gPhone", item.phoneStyle, charID)
            local newPhone = exports["soe-nexus"]:PerformAPIRequest("/api/phone/modify", dataString, true)

            if newPhone.status then
                exports["soe-logging"]:ServerLog("Purchase - Phone", ("HAS PURCHASED A PHONE | PRICE: $%s | STYLE: %s"):format(totalPrice, item.phoneStyle), src)
            end
        -- NON PHONES
        else
            if exports["soe-inventory"]:AddItem(src, "char", charID, item.item, item.amt, item.meta or "") then
                exports["soe-logging"]:ServerLog("Purchase - Item", ("HAS PURCHASED AN ITEM | PRICE: $%s | ITEM NAME: %s"):format(totalPrice, item.item), src)
            end
        end
    end
end)

-- CALLED FROM CLIENT TO RETURN QUANTITY PURCHASED BY CHAR
RegisterNetEvent("Shops:Server:GetQuantityPurchased")
AddEventHandler("Shops:Server:GetQuantityPurchased", function(cb, src, businessName)
    local quantityPurchased = 0

    -- NILL CHECK AND INIT
    if quantityPurchasedByBusinesss[businessName] == nil then
        quantityPurchasedByBusinesss[businessName] = 0
    end

    -- UPDATE VALUE
    if quantityPurchasedByBusinesss[businessName] ~= nil then
        quantityPurchased = quantityPurchasedByBusinesss[businessName]
    end

    -- RETURN DATA
    cb({["status"] = true, ["quantityPurchased"] = quantityPurchased})
end)

-- CALLED FROM CLIENT TO SET QUANTITY PURCHASED BY CHAR
RegisterNetEvent("Shops:Server:SetQuantityPurchased")
AddEventHandler("Shops:Server:SetQuantityPurchased", function(cb, src, quantity, businessName)
    -- NILL CHECK AND INIT
    if quantityPurchasedByBusinesss[businessName] == nil then
        quantityPurchasedByBusinesss[businessName] = 0
    end

    -- UPDATE VALUE
    if quantityPurchasedByBusinesss[businessName] ~= nil then
        quantityPurchasedByBusinesss[businessName] = quantityPurchasedByBusinesss[businessName] + quantity
    end

    -- RETURN DATA
    cb({["status"] = true, ["quantityPurchased"] = quantityPurchasedByBusinesss[businessName]})
end)

-- **********************
--       Commands
-- **********************
-- WHEN TRIGGERED, DEBUG BUY LIMIT
RegisterCommand("setbuylimit", function(source, args)
    local src = source
    if not exports["soe-uchuu"]:IsStaff(src) then return end
    if not tonumber(args[2]) then return end
    TriggerClientEvent("Jobs:Client:ModifyBuyLimit", src, {status = true, limitName = args[1], amount = tonumber(args[2])})
end)