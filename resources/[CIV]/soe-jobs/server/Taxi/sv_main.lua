-- FUNCTION TO GENERATE OUR TIP
local function GenerateTip(amount)
    math.randomseed(os.time())
    local percentage = math.random(10, 20)
    local tip = math.ceil(amount / percentage)
    return tip
end

-- CALLED FROM CLIENT TO HANDLE PAYMENT
RegisterNetEvent("Jobs:Server:HandleTaxiPayment")
AddEventHandler("Jobs:Server:HandleTaxiPayment", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 48317-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 48317-2 | Lua-Injecting Detected.", 0)
        return
    end

    -- FOR SECURITY REASONS, MAKE SURE THEIR JOB MATCHES THE TAXI SERVICE
    if (GetJob(src) ~= "TAXI") then
        exports["soe-logging"]:ServerLog("Finished Taxi Ride - Possible Injection (Fidelis)", "HAS TRIGGERED THE PAYMENT EVENT WITHOUT BEING ON TAXI DUTY", src)
        return
    end

    -- PRINT A "RECEIPT" OUT
    local amount = #(data.startCoords - data.endCoords) * 0.05
    local tip = GenerateTip(amount)
    local total = (math.floor(amount) + math.floor(tip))

    -- ADD CASH
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    if exports["soe-inventory"]:AddItem(src, "char", charID, "cash", math.floor(total), "{}") then
        TriggerClientEvent("Chat:Client:SendMessage", src, "center", "Downtown Cab Co. Receipt")
        TriggerClientEvent("Chat:Client:SendMessage", src, "linebreak")
    
        TriggerClientEvent("Chat:Client:Message", src, "", "^0Fare: ^2$" .. math.floor(amount), "blank")
        TriggerClientEvent("Chat:Client:Message", src, "", "^0Tip: ^2$" .. math.floor(tip), "blank")
        TriggerClientEvent("Chat:Client:Message", src, "", "^0Total: ^2$" .. math.floor(total), "blank")
    
        TriggerClientEvent("Chat:Client:SendMessage", src, "linebreak")
    end
end)
