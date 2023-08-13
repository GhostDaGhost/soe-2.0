local moneyStored = {}
local launderTime = 1800000 -- APPROX 30 MINS

function HandleMoneyLaundering()
    for _, money in pairs(moneyStored) do
        local finishLaunderTime = money.time + launderTime
        if (GetGameTimer() >= finishLaunderTime and not money.ready) then
            money.ready = true
        end
    end
end

-- REQUESTED FROM CLIENT TO GET STORED LAUNDERED MONEY
AddEventHandler("Crime:Server:GetMoneyLaundered", function(cb, src)
    cb(moneyStored)
end)

-- REQUESTED FROM CLIENT TO STORE LAUNDERED MONEY
RegisterNetEvent("Crime:Server:LaunderMoney")
AddEventHandler("Crime:Server:LaunderMoney", function(amt, launderer)
    local src = source
    if (exports["soe-inventory"]:GetItemAmt(src, "dirtycash", "left") >= amt) then
        -- NOTIFY SOURCE THAT THEY SUCCESSFULLY DEPOSITED MONEY
        exports["soe-inventory"]:RemoveItem(src, amt, "dirtycash")
        TriggerClientEvent("Chat:Client:Message", src, "[Launderer]", ("You have put in $%s to be laundered, come back later to collect."):format(amt), "standard")

        -- SAVE DEPOSITED MONEY AND ADD TO THE TABLE | LOG DEPOSIT AS WELL
        local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
        table.insert(moneyStored, {charID = charID, amount = amt, launderer = launderer, time = GetGameTimer(), ready = false})
        exports["soe-logging"]:ServerLog("Money Launder Deposit", ("HAS DEPOSITED $%s INTO LAUNDERER %s"):format(amt, launderer), src)
    else
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You don't have enough dirty cash!", length = 5000})
    end
end)

-- REQUESTED FROM CLIENT TO PICKUP LAUNDERED MONEY
RegisterNetEvent("Crime:Server:PickupLaunderedMoney")
AddEventHandler("Crime:Server:PickupLaunderedMoney", function(launderer)
    local src = source
    local found, charID = nil, exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    -- FIND OUR TABLE
    for index, money in pairs(moneyStored) do
        if (money.launderer == launderer.name and money.charID == charID) then
            found = index
        end
    end

    -- IF THE PAYOUT IS VALID, DO THE FOLLOWING
    if found then
        local laundererCommission = math.modf(moneyStored[found].amount * launderer.commission)
        local cleanMoneyPayout = moneyStored[found].amount - laundererCommission
        if exports["soe-inventory"]:AddItem(src, "char", charID, "cash", tonumber(cleanMoneyPayout), "{}") then
            table.remove(moneyStored, found)
            exports["soe-logging"]:ServerLog("Money Launder Collected", ("HAS COLLECTED $%s FROM %s"):format(cleanMoneyPayout, launderer.name), src)
        end
    else
        print("Fatal error occurred with requesting laundered money.")
    end
end)
