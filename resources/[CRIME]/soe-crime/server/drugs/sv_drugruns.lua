local doingDrugRuns = {}
local reputationReward = 15
local reputationStartCost = 10
local reputationArrestedCost = 25
local reputationLostVehicleCost = 15

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, COMPLETE DRUG RUN STOP FOR THE SOURCE
local function CompleteDrugRunStop(src, data)
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 420-420-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 420-420-2 | Lua-Injecting Detected.", 0)
        return
    end
    exports["soe-inventory"]:RemoveItemFromVehicle(src, 5, drugrunProducts[data.product].item, {netID = data.netID, plate = data.plate, vin = data.vin})

    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    exports["soe-logging"]:ServerLog("Completed Drug Run Stop", ("HAS FINISHED DRUG RUN STOP OF %s WITH PLATE, %s, WITH VIN, %s"):format(data.product, data.place, data.vin), src)
end

-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, IF SOMEONE IS DOING A DRUG RUN AND THEY DISCONNECT FOR ANY REASON... RESTORE THEIR REPUTATION
function RestoreDrugRunReputation(src)
    if doingDrugRuns[src] then
        doingDrugRuns[src] = false

        local reputation = json.decode(exports["soe-uchuu"]:GetOnlinePlayerList()[src].Gamestate)["drugrun_rep"]
        if (reputation ~= nil) then
            reputation = tonumber(reputation)
            exports["soe-uchuu"]:UpdateGamestate(src, "drugrun_rep", false, (math.ceil(reputation) + reputationStartCost))
        end
    end
end

-- WHEN TRIGGERED, MODIFY THE SOURCE'S REPUTATION
function ModifyDrugRunReputation(src, type)
    if not doingDrugRuns[src] then return end

    local reputation = json.decode(exports["soe-uchuu"]:GetOnlinePlayerList()[src].Gamestate)["drugrun_rep"]
    if (reputation ~= nil) then
        reputation = tonumber(reputation)
        if (type == "Lost Vehicle") then
            exports["soe-uchuu"]:UpdateGamestate(src, "drugrun_rep", false, (math.ceil(reputation) - reputationLostVehicleCost))
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Drug Run Reputation: Decreased", length = 8500})
        elseif (type == "Arrested") then
            exports["soe-uchuu"]:UpdateGamestate(src, "drugrun_rep", false, (math.ceil(reputation) - reputationArrestedCost))
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Drug Run Reputation: Mass-Decreased", length = 8500})
        elseif (type == "Completed Run") then
            exports["soe-uchuu"]:UpdateGamestate(src, "drugrun_rep", false, (math.ceil(reputation) + reputationReward))
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "Drug Run Reputation: Increased", length = 8500})
        end
    end
end

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, REDUCE THE AMOUNT OF DRUGS LEFT IN THE VEHICLE UPON A STOP
RegisterNetEvent("Crime:Server:CompleteDrugRunStop")
AddEventHandler("Crime:Server:CompleteDrugRunStop", function(data)
    local src = source
    CompleteDrugRunStop(src, data)
end)

-- WHEN TRIGGERED, GET AMOUNT OF SPECIFIED DRUGS FROM VEHICLE
AddEventHandler("Crime:Server:GetDrugAmtInVehicle", function(cb, src, netID, plate, product)
    if not netID then cb(false) return end
    if not plate then cb(false) return end

    local amt = exports["soe-inventory"]:GetItemAmtInVehicle(src, drugrunProducts[product].item, {netID = netID, plate = plate})
    if (amt == false) then
        amt = 0
    end
    cb(amt)
end)

-- WHEN TRIGGERED, MODIFY A CHARACTER'S REPUTATION
RegisterNetEvent("Crime:Server:ModifyDrugRunReputation")
AddEventHandler("Crime:Server:ModifyDrugRunReputation", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 421-421-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 421-421-2 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.type then return end
    ModifyDrugRunReputation(src, data.type)
end)

-- WHEN TRIGGERED, REMOVE SPECIFIED DRUG FROM THE VEHICLE AND END DRUG RUN
AddEventHandler("Crime:Server:EndDrugRun", function(cb, src, netID, plate, vin, completed, product, payout)
    if not netID then cb(false) return end
    if not plate then cb(false) return end

    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    if not completed then
        local amt = exports["soe-inventory"]:GetItemAmtInVehicle(src, drugrunProducts[product].item, {netID = netID, plate = plate})
        exports["soe-inventory"]:RemoveItemFromVehicle(src, amt, drugrunProducts[product].item, {netID = netID, plate = plate, vin = vin})
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "We knew you weren't suitable for this job...", length = 10000})
    else
        -- INCREASE REPUTATION OF THE SOURCE CHARACTER
        ModifyDrugRunReputation(src, "Completed Run")

        -- PAY THE SOURCE CHARACTER
        payout = math.ceil(payout)
        if exports["soe-inventory"]:AddItem(src, "char", charID, "cash", payout, "{}") then
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "debug", text = ("You received $%s for doing a %s run"):format(payout, product), length = 20000})
            exports["soe-logging"]:ServerLog("Drug Run Payout", ("HAS BEEN PAID $%s FOR COMPLETING A %s RUN"):format(payout, product), src)
        end
    end
    cb(true)

    doingDrugRuns[src] = false
    exports["soe-logging"]:ServerLog("Ended Drug Run", ("HAS COMPLETED A %s RUN WITH PLATE, %s, WITH VIN, %s"):format(product, plate, vin). src)
end)

-- WHEN TRIGGERED, FILL THE VEHICLE UP WITH DRUGS AND CALLBACK WHEN SUCCESSFUL
AddEventHandler("Crime:Server:StartDrugRun", function(cb, src, class, plate, vin, product, runners)
    if not class then cb(false) return end
    if not plate then cb(false) return end

    -- MAKE SURE TO WIPE THE VEHICLE OF ANY BRICKS/TRAYS
    local item = drugrunProducts[product].item
    local amt = exports["soe-inventory"]:GetItemAmtInVehicle(src, item, {netID = netID, plate = plate})
    exports["soe-inventory"]:RemoveItemFromVehicle(src, amt, item, {netID = netID, plate = plate, vin = vin})

    -- ASSEMBLE THE MESSAGE WITH THE AMOUNT OF RUNNERS INSIDE THE CAR
    local string = "You have started running %s with %s runner."
    if (runners > 1) then
        string = "You have started running %s with %s runners."
    end

    -- MANAGE THE REPUTATION OF THE SOURCE
    local amountOfDrugs = 20
    local reputation = json.decode(exports["soe-uchuu"]:GetOnlinePlayerList()[src].Gamestate)["drugrun_rep"]
    if (reputation == nil) then
        exports["soe-uchuu"]:UpdateGamestate(src, "drugrun_rep", false, 0)
        print("SRC'S REPUTATION (1):", json.decode(exports["soe-uchuu"]:GetOnlinePlayerList()[src].Gamestate)["drugrun_rep"])

        local str = "You realize this is your first time doing this... the gang supplied you less than usual in order to make sure you're legit."
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "debug", text = str, length = 20000})
        amountOfDrugs = amountOfDrugs - 5
    else
        reputation = tonumber(reputation)
        if (reputation <= 10) then
            exports["soe-uchuu"]:UpdateGamestate(src, "drugrun_rep", false, (math.ceil(reputation) - reputationStartCost))
        end
        print("SRC'S REPUTATION (2):", json.decode(exports["soe-uchuu"]:GetOnlinePlayerList()[src].Gamestate)["drugrun_rep"])

        local str = "The gang recognizes you and they supply your vehicle with a average amount of " .. product
        if (reputation >= 30) then
            str = "The gang recognizes you because of your extremely positive reputation and thus, they supply your vehicle with a good amount of " .. product
            amountOfDrugs = amountOfDrugs + 10
        elseif (reputation >= 20) then
            str = "The gang recognizes you because of your positive reputation and thus, they supply your vehicle with a decent amount of " .. product
            amountOfDrugs = amountOfDrugs + 5
        elseif (reputation <= 10) then
            str = "The gang recognizes you because of your poor reputation and thus, they supply your vehicle with a less than average amount of " .. product
            amountOfDrugs = amountOfDrugs - 5
        end
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "debug", text = str, length = 20000})
    end

    -- INVENTORY TYPES DETERMINED IF THE VIN EVEN EXISTS
    if (vin ~= 0) then
        exports["soe-inventory"]:AddItem(src, "veh", vin, item, amountOfDrugs, "{}")
    else
        exports["soe-inventory"]:AddItem(src, "tempveh", plate, item, amountOfDrugs, "{}") 
    end
    cb(true)

    -- NOTIFY BEGINNING OF RUN AND LOG THE START
    doingDrugRuns[src] = true
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = (string):format(string.lower(product), runners), length = 10000})
    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "debug", text = "You are to not touch the product inside the car or else your reputation will decrease.", length = 10000})
    exports["soe-logging"]:ServerLog("Started Drug Run", ("HAS STARTED A %s RUN WITH VEHICLE CLASS %s, WITH PLATE %s, WITH VIN %s"):format(product, class, plate, vin), src)
end)
