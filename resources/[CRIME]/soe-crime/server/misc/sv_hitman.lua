-- **********************
--        Events
-- **********************
-- EXECUTED THROUGH CALLBACK TO SEE IF HITMAN CONTRACT CAN BE MADE
AddEventHandler("Crime:Server:HitmanContractRequirementCheck", function(cb, src)
    if (exports["soe-jobs"]:GetDutyCount("POLICE") >= exports["soe-config"]:GetConfigValue("duty", "hitman_contracts")) then
        cb(true)
    else
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "I got nothing for you at the moment", length = 10000})
        cb(false)
    end
end)

-- WHEN TRIGGERED, PAY THE PLAYER FOR COMPLETING THE CONTRACT
RegisterNetEvent("Crime:Server:HitmanContractPay")
AddEventHandler("Crime:Server:HitmanContractPay", function(data)
    local src = source
    -- SECURITY MEASURE 1
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 599-1 | Lua-Injecting Detected.", 0)
    end

    -- SECURITY MEASURE 2
    if not data.canPay then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 599-2 | Lua-Injecting Detected.", 0)
    end

    local reward
    if exports["soe-config"]:GetConfigValue("economy", "hitman_contract") then
        reward = exports["soe-config"]:GetConfigValue("economy", "hitman_contract")
    end

    if reward then
        math.randomseed(os.time())
        math.random() math.random()
        local amount = math.random(reward["min"], reward["max"])

        local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
        if exports["soe-inventory"]:AddItem(src, "char", charID, "cash", amount, "{}") then
            exports["soe-logging"]:ServerLog("Hitman Contract Reward", ("HAS BEEN REWARDED $%s FOR COMPLETING HITMAN JOB"):format(amount), src)
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "You earned $" .. amount .. " for completing this contract", length = 12500})
        end
    else
        error("Hitman contract reward is 'nil'. This means that the config values have failed to be retrieved.")
    end
end)
