local bankCooldown = 1800000 -- ESTIMATED: 30 MINUTES

-- **********************
--        Events
-- **********************
-- EXECUTED THROUGH CALLBACK TO SYNC BANK DATA WITH PLAYER
AddEventHandler("Crime:Server:SyncBanks", function(cb, src)
    cb(banks)
end)

-- EXECUTED WHEN A BANK VAULT IS OPENED
RegisterNetEvent("Crime:Server:UpdateBankVaultState", function(data)
    if not data then return end
    banks[data.bank].vaultOpen = data.state
    TriggerClientEvent("Crime:Client:SyncBankStates", -1, banks)
end)

-- EXECUTED WHEN AN LEO SECURES THE BANK VAULT
RegisterNetEvent("Crime:Server:SecureBankVault", function(data)
    if not data then return end
    banks[data.bank].vaultOpen = false
    TriggerClientEvent("Crime:Client:SecureBankVault", -1, data.bank)
end)

-- EXECUTED WHEN A BANK VAULT HAS BEEN OPENED, IT TAKES CARD/KEY
RegisterNetEvent("Crime:Server:TakeBankCardsAndKey", function(data)
    if not data then return end

    local src = source
    exports["soe-inventory"]:RemoveItem(src, 1, data["card"])
    exports["soe-inventory"]:RemoveItem(src, 1, "bankvaultkey")
end)

-- EXECUTED WHEN A BANK ROBBERY OF ANY KIND HAPPENS
RegisterNetEvent("Crime:Server:InitBankRobbery", function(data)
    if not data then return end
    local src = source

    if not banks[data.bank].cooldown then
        if (data.response == "Panic") then
            banks[data.bank].cooldown = true
            TriggerEvent("Crime:Server:SendRobberyAlert", data.location, data.pos, data.bank .. " Bank")
            exports["soe-logging"]:ServerLog("Bank Robbery Started", ("HAS STARTED ROBBING THE %s AT %s"):format(data.type, data.bank), src)

            -- AFTER A CERTAIN AMOUNT OF TIME, RESET THIS BANK
            SetTimeout(bankCooldown, function()
                banks[data.bank].cooldown = false
                for _, depositBox in pairs(banks[data.bank].depositBoxes) do
                    depositBox.robbed = false
                end
                TriggerClientEvent("Crime:Client:SyncBankStates", -1, banks)
                exports["soe-logging"]:ServerLog("Bank Cooldown Resetted", data.bank .. "WAS RESET FROM A COOLDOWN")
            end)
        end
    end
end)

-- EXECUTED THROUGH CALLBACK TO SEE IF BANK ROBBERY CAN BE DONE
AddEventHandler("Crime:Server:BankRequirementCheck", function(cb, src, type, bank, depositBox)
    -- INVALID PARAMETERS CHECK
    if not bank then return end
    if not banks[bank] then return end

    -- DEPOSIT BOX CHECK
    if (type == "Deposit Box") then
        if depositBox then
            if banks[bank]["depositBoxes"][depositBox]["robbed"] then
                cb(false)
            else
                cb(true)
            end
        end
        return
    end

    -- BANK COOLDOWN CHECK
    if not banks[bank]["cooldown"] then
        if (exports["soe-jobs"]:GetDutyCount("POLICE") >= exports["soe-config"]:GetConfigValue("duty", "banks")) then
            cb(true)
        else
            if (type == "Teller") then
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "You notice that the window is too secured to rob the teller", length = 10000})
            elseif (type == "Vault") then
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "You notice that the bank vault is secured tightly", length = 10000})
            end
            cb(false)
        end
    else
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "You notice that the bank security is quite tight", length = 10000})
        cb(false)
    end
end)

-- EXECUTED WHEN THE SOURCE SUCCEEDS IN A BANK ROBBERY HIT
RegisterNetEvent("Crime:Server:FinishBankRobbery", function(data)
    if not data then return end
    local src = source

    local reward
    if (data["type"] == "Teller") then
        reward = exports["soe-config"]:GetConfigValue("economy", "bank_teller") or {["min"] = 450, ["max"] = 800}
    elseif (data["type"] == "Deposit Box") then
        reward = exports["soe-config"]:GetConfigValue("economy", "bank_depositbox_" .. banks[data["bank"]]["type"]:lower()) or {["min"] = 1500, ["max"] = 2500}
    end

    math.randomseed(os.time())
    math.random() math.random()
    local amount = math.random(reward["min"], reward["max"])
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID

    -- CHANCE OF GETTING ANOTHER BANK KEYCARD
    math.randomseed(os.time())
    local luck = math.random(1, 100)
    local bankType = banks[data["bank"]]["type"]
    if (data["type"] == "Deposit Box" and luck <= 52) then
        if (bankType == "Fleeca") then
            if exports["soe-inventory"]:AddItem(src, "char", charID, "vaultcard_red", 1, "{}") then
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "You notice you got a red keycard", length = 8500})
            end
            exports["soe-logging"]:ServerLog("Bank Robbery Reward - Key Card", "GOT A RED BANK CARD FROM " .. bankType, src)
        elseif (bankType == "Banham") then
            if exports["soe-inventory"]:AddItem(src, "char", charID, "vaultcard_blue", 1, "{}") then
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "You notice you got a blue keycard", length = 8500})
            end
            exports["soe-logging"]:ServerLog("Bank Robbery Reward - Key Card", "GOT A BLUE BANK CARD FROM " .. bankType, src)
        elseif (bankType == "Paleto") then
            if exports["soe-inventory"]:AddItem(src, "char", charID, "vaultcard_black", 1, "{}") then
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "You notice you got a black keycard", length = 8500})
            end
            exports["soe-logging"]:ServerLog("Bank Robbery Reward - Key Card", "GOT A BLACK BANK CARD FROM " .. bankType, src)

            math.randomseed(os.time())
            luck = math.random(1, 100)
            if (luck <= 35) then
                if exports["soe-inventory"]:AddItem(src, "char", charID, "usb2", 1, "{}") then
                    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "You notice you got a USB stick", length = 8500})
                end
                exports["soe-logging"]:ServerLog("Bank Robbery Reward - USB Stick", "GOT A RED USB STICK FROM " .. bankType, src)
            end
        end
    end

    if exports["soe-inventory"]:AddItem(src, "char", charID, "dirtycash", amount, "{}") then
        local msg = "You robbed the bank and earned $" .. amount
        if (data["type"] == "Teller") then
            msg = "You robbed the bank teller and earned $" .. amount
        elseif (data["type"] == "Deposit Box") then
            msg = "You drilled and robbed the deposit box and earned $" .. amount
        end

        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = msg, length = 12500})
        exports["soe-logging"]:ServerLog("Bank Robbery Reward", ("HAS EARNED $%s FROM ROBBING THE %s THROUGH %s"):format(amount, data["bank"], data["type"]), src)

        if data["depositBox"] then
            banks[data["bank"]]["depositBoxes"][data["depositBox"]]["robbed"] = true
        end
        TriggerClientEvent("Crime:Client:SyncBankStates", -1, banks)
    end
end)
