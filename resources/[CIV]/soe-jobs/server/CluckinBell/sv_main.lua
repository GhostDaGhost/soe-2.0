-- **********************
--        Events
-- **********************
-- REQUESTED FROM CLIENT TO GIVE WORK BONUS
RegisterNetEvent("Jobs:Server:CluckinBell:WorkBonus")
AddEventHandler("Jobs:Server:CluckinBell:WorkBonus", function(data)
    --[[print("WORK BONUS")
    print("data.roleID", data.roleID)]]

    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 931 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 932 | Lua-Injecting Detected.", 0)
        return
    end

    -- CALCULATE WORK BONUS
    math.randomseed(os.time())
    math.random() math.random() math.random()

    -- BASE REWARD AMOUNT
    local amount = 100

    -- PLUS RANDOM REWARD AMOUNT
    amount = amount + math.random(jobRoles[data.roleID].rewardMin, jobRoles[data.roleID].rewardMax)

    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    exports["soe-bank"]:PayPrimary(src, charID, amount, "Cluckin' Bell - Work Bonus")
    TriggerClientEvent("Chat:Client:Message", src, "[Cluckin' Bell]", string.format("Well done for completing your tasks, we have awarded you with $%s as a work bonus. Take a short break!", amount), "taxi")
end)

-- WHEN TRIGGERED, CALLBACK TO CLIENT WITH SERVER STOCK TAKING DATA
AddEventHandler("Jobs:Server:CluckinBell:GetStockTakingData", function(cb, src)
    cb(stockTakingSpots)
end)

-- WHEN TRIGGERED, CALLBACK TO CLIENT WITH SERVER PROCESSING DATA
AddEventHandler("Jobs:Server:CluckinBell:GetProcessingData", function(cb, src)
    cb(processingSpots)
end)

-- WHEN TRIGGERED, CALLBACK TO CLIENT WITH SERVER LOGISTICS DATA
AddEventHandler("Jobs:Server:CluckinBell:GetLogisticsData", function(cb, src)
    cb(packingSpots)
end)

-- WHEN TRIGGERED, CALLBACK TO CLIENT WITH SERVER INVENTORY DATA
AddEventHandler("Jobs:Server:CluckinBell:GetInventoryData", function(cb, src)
    cb(factoryInventory)
end)

RegisterNetEvent("Jobs:Server:CluckinBell:SetVariable")
AddEventHandler("Jobs:Server:CluckinBell:SetVariable", function(roleID, tableData, variable, bool)
    --[[print("-----")
    print("SetVariable", variable)
    print("roleName", jobRoles[roleID].roleName)]]

    for _, spotData in pairs(jobRoles[roleID].tableName) do
        if spotData.pos == tableData.pos then
            --[[print("FOUND")
            print("-----")
            print("CURRENT", spotData[variable])
            print("SET TO", bool)]]

            spotData[variable] = bool
            if spotData.nextAvailableTime ~= nil then
                print("os.time()", os.time())
                print("nextAvailable", os.time() + jobRoles[roleID].jobCooldown)
                spotData.nextAvailableTime = os.time() + jobRoles[roleID].jobCooldown
            end

            --[[print("-----")
            print("occupied", spotData.occupied)
            print("nextAvailableTime", spotData.nextAvailableTime)
            print("stockTaked", spotData.stockTaked)
            print("packaged", spotData.packaged)
            print("dropOff", spotData.dropOff)
            print("-----")]]
            break
        end
    end
end)
