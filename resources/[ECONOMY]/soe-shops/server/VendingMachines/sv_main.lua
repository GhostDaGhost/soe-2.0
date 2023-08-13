-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, CHECK IF A PLAYER CAN AFFORD AND CHARGE USING CASH
AddEventHandler("Shops:Server:BuyFromGumballMachine", function(cb, src, price)
    if (price == nil) then cb(false) return end

    price = tonumber(price)
    if (exports["soe-inventory"]:GetItemAmt(src, "cash", "left") < price) then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You do not have enough cash", length = 5000})
        cb(false)
        return
    end

    cb(true)
    exports["soe-inventory"]:RemoveItem(src, price, "cash")
end)

-- CALLED FROM CLIENT AFTER A VENDING MACHINE USE
RegisterNetEvent("Shops:Server:BuyFromVendingMachine")
AddEventHandler("Shops:Server:BuyFromVendingMachine", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 557-2 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 557-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.product then return end
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    exports["soe-inventory"]:AddItem(src, "char", charID, data.product, 1, "")
end)
