local restocks = {}

-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, RESET RESTOCK LIMIT
function ResetHotdogSupplyRestock(src)
    --print("RESETTING STOCK FOR: ", src)
    restocks[src] = 0
    exports["soe-logging"]:ServerLog("Hotdog Supply Resetted", "HAS HAD THEIR HOTDOG SUPPLY AUTOMATICALLY RESET", src)
end

-- **********************
--        Events
-- **********************
-- SENT FROM CLIENT TO RESTOCK CLIENT'S HOTDOG SUPPLIES
RegisterNetEvent("Jobs:Server:RestockHotdogSupplies")
AddEventHandler("Jobs:Server:RestockHotdogSupplies", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 997 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 996 | Lua-Injecting Detected.", 0)
        return
    end

    if data.status then
        if not restocks[src] then
            restocks[src] = 0
        end

        -- RESTOCK LIMIT
        if (restocks[src] >= 2) then
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You cannot restock anymore", length = 5000})
            return
        end

        restocks[src] = restocks[src] + 1
        local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
        if exports["soe-inventory"]:AddItem(src, "char", charID, "hotdogbun", 40, "") then
            if exports["soe-inventory"]:AddItem(src, "char", charID, "hotdogweiner", 40, "") then
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "You have been restocked with hotdog buns and weiners", length = 5000})
                exports["soe-logging"]:ServerLog("Hotdog Supply Restocked", ("GOT THEIR HOTDOG SUPPLY RESTOCKED, THEY CURRENTLY HAVE %s RESTOCKS"):format(tostring(restocks[src])), src)
            end
        end
    end
end)

-- SENT FROM CLIENT TO GIVE SOURCE A HOTDOG
RegisterNetEvent("Jobs:Server:CookHotdog")
AddEventHandler("Jobs:Server:CookHotdog", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 999 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 998 | Lua-Injecting Detected.", 0)
        return
    end

    if data.status then
        if (exports["soe-inventory"]:GetItemAmt(src, "hotdogbun", "left") < 1) then
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You do not have a hotdog bun", length = 5000})
            return
        end

        if (exports["soe-inventory"]:GetItemAmt(src, "hotdogweiner", "left") < 1) then
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You do not have a weiner", length = 5000})
            return
        end

        local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
        if exports["soe-inventory"]:AddItem(src, "char", charID, "hotdog", 1, "") then
            exports["soe-inventory"]:RemoveItem(src, 1, "hotdogbun")
            exports["soe-inventory"]:RemoveItem(src, 1, "hotdogweiner")

            exports["soe-logging"]:ServerLog("Cooked Hotdog", "HAS COOKED A HOTDOG", src)
        end
    end
end)

-- SENT FROM CLIENT TO PERFORM A HOTDOG SALE
RegisterNetEvent("Jobs:Server:PerformHotdogSale")
AddEventHandler("Jobs:Server:PerformHotdogSale", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 995 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 994 | Lua-Injecting Detected.", 0)
        return
    end

    -- FOR SECURITY REASONS, MAKE SURE THEIR JOB MATCHES THE HOTDOG JOB
    if (GetJob(src) ~= "HOTDOG") then
        exports["soe-logging"]:ServerLog("Finished Hotdog Sale - Possible Injection (Fidelis)", "HAS TRIGGERED THE PAYMENT EVENT WITHOUT BEING ON HOTDOG DUTY", src)
        return
    end

    -- RANDOMIZE AMOUNT GIVEN
    local payment
    if exports["soe-config"]:GetConfigValue("economy", "hotdog_sale") then
        payment = exports["soe-config"]:GetConfigValue("economy", "hotdog_sale")
    end

    if payment then
        math.randomseed(os.time())
        math.random() math.random()
        local amount = math.random(payment["min"], payment["max"])

        local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
        if exports["soe-inventory"]:AddItem(src, "char", charID, "cash", amount, "") then
            exports["soe-inventory"]:RemoveItem(src, 1, "hotdog")
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "debug", text = "Customer: Thanks for the hotdog! Here's your money... $" .. amount, length = 8500})
            exports["soe-logging"]:ServerLog("Hotdog Sale", "HAS SOLD 1 HOTDOG FOR $" .. amount, src)
        end
    else
        error("Hotdog payment is 'nil'. This means that the config values have failed to be retrieved.")
    end
end)
