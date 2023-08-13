-- SENT FROM CLIENT TO GIVE SOURCE A TIP
RegisterNetEvent("Jobs:Server:FinishPizzaDelivery")
AddEventHandler("Jobs:Server:FinishPizzaDelivery", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 48314-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 48314-2 | Lua-Injecting Detected.", 0)
        return
    end

    -- FOR SECURITY REASONS, MAKE SURE THEIR JOB MATCHES THE PIZZA DELIVERY
    if (GetJob(src) ~= "PIZZA") then
        exports["soe-logging"]:ServerLog("Finished Pizza Delivery - Possible Injection (Fidelis)", "HAS TRIGGERED THE PAYMENT EVENT WITHOUT BEING ON PIZZA DUTY", src)
        return
    end

    -- GENERATE TIP
    math.randomseed(os.time())
    math.random() math.random()
    local tip = math.random(15, 35)

    -- GIVE THE PLAYER MONEY
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    if exports["soe-inventory"]:AddItem(src, "char", charID, "cash", tip, "") then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = ("You received a tip of $%s by the customer!"):format(tip), length = 7500})
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "You delivered a pizza! Now go back to a pizzeria to collect another!", length = 15500})
    end
end)
