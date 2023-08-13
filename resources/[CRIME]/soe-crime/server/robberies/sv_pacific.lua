local bankCooldown = 3600000 -- ESTIMATED: 60 MINUTES

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, REMOVE THE ITEMS USED IN THE SETUP
RegisterNetEvent("Crime:Server:RemovePacificItem", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 637219-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data["status"] then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 637219-2 | Lua-Injecting Detected.", 0)
        return
    end
    exports["soe-inventory"]:RemoveItem(src, 1, data["item"])
end)

-- WHEN TRIGGERED, SYNC THERMAL CHARGE EFFECTS
RegisterNetEvent("Crime:Server:SyncThermalChargeEffects", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 637211-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data["status"] then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 637211-2 | Lua-Injecting Detected.", 0)
        return
    end
    TriggerClientEvent("Crime:Client:SyncThermalChargeEffects", -1, data["pos"])
end)

-- WHEN TRIGGERED, SYNC THERMAL CHARGE EFFECTS
RegisterNetEvent("Crime:Server:SyncPacificSafe", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 637216-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data["status"] then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 637216-2 | Lua-Injecting Detected.", 0)
        return
    end

    if not data["opening"] then
        banks["Pacific Standard"]["vaultOpen"] = false
    end
    TriggerClientEvent("Crime:Client:SyncBankStates", -1, banks)
    TriggerClientEvent("Crime:Client:SyncPacificSafe", -1, data["opening"] or false)
end)

-- WHEN TRIGGERED, CHECK REQUIREMENTS FOR PACIFIC STANDARD
AddEventHandler("Crime:Server:PacificRequirementCheck", function(cb, src)
    --return cb(true) -- DEBUG

    if not banks["Pacific Standard"]["cooldown"] then -- BANK COOLDOWN CHECK
        if (exports["soe-jobs"]:GetDutyCount("POLICE") >= exports["soe-config"]:GetConfigValue("duty", "banks_pacificstandard")) then
            cb(true)
        else
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "You notice that the bank security is quite tight", length = 10000})
            cb(false)
        end
    else
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "You notice that the bank security is quite tight", length = 10000})
        cb(false)
    end
end)

-- WHEN TRIGGERED, GIVE REWARD FOR SUCCESSFUL TROLLEY CLEARING
RegisterNetEvent("Crime:Server:PacificBankLoot", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 637251-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data["status"] then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 637251-2 | Lua-Injecting Detected.", 0)
        return
    end

    math.randomseed(os.time())
    math.random() math.random()
    local reward = exports["soe-config"]:GetConfigValue("economy", "bank_pacificstandard") or {["min"] = 7500, ["max"] = 9750}
    local amount = math.random(reward["min"], reward["max"])

    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    if exports["soe-inventory"]:AddItem(src, "char", charID, "dirtycash", amount, "{}") then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "You cleared this trolley and got $" .. amount, length = 12500})
        exports["soe-logging"]:ServerLog("Bank Robbery Reward", ("HAS EARNED $%s FROM ROBBING A PACIFIC STANDARD TROLLEY"):format(amount), src)
    end
end)

-- WHEN TRIGGERED, START THE PACIFIC STANDARD ROBBERY
RegisterNetEvent("Crime:Server:InitPacificStandardRobbery", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 63721-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data["status"] then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 63721-2 | Lua-Injecting Detected.", 0)
        return
    end

    if not banks["Pacific Standard"]["cooldown"] then
        banks["Pacific Standard"]["cooldown"] = true
        banks["Pacific Standard"]["vaultOpen"] = true
        TriggerClientEvent("Crime:Client:SyncBankStates", -1, banks)

        TriggerClientEvent("Crime:Client:SyncPacificSafe", -1, true)
        TriggerEvent("Crime:Server:SendRobberyAlert", data["loc"], data["pos"], "Pacific Standard Bank")
        exports["soe-logging"]:ServerLog("Bank Robbery Started", "HAS STARTED ROBBING THE PACIFIC STANDARD BANK'S VAULT", src)

        -- AFTER A CERTAIN AMOUNT OF TIME, RESET THIS BANK
        SetTimeout(bankCooldown, function()
            banks["Pacific Standard"]["cooldown"] = false
            TriggerClientEvent("Crime:Client:SyncBankStates", -1, banks)
            exports["soe-logging"]:ServerLog("Bank Cooldown Resetted", "PACIFIC STANDARD BANK WAS RESET FROM A COOLDOWN")
        end)
    end
end)
