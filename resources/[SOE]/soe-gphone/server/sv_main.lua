-- ***********************
--        Commands
-- ***********************
-- WHEN TRIGGERED, MUTE PHONE NOTIFICATIONS OR UNMUTE THEM
RegisterCommand("mutephone", function(source)
    local src = source
    local userSettings = json.decode(exports["soe-uchuu"]:GetOnlinePlayerList()[src].UserSettings)
    if not userSettings["mutedPhone"] then
        exports["soe-uchuu"]:UpdateUserSettings(src, "mutedPhone", false, true)
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Phone Notifications: Off", length = 5000})
        TriggerClientEvent("gPhone:Client:MuteNotifications", src, {status = true})
    else
        exports["soe-uchuu"]:UpdateUserSettings(src, "mutedPhone", true)
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Phone Notifications: On", length = 5000})
    end
end)

-- ***********************
--         Events
-- ***********************
RegisterNetEvent("Phone:BankTransfer")
AddEventHandler("Phone:BankTransfer", function(fromAccount, toAccount, amount)
    -- print("Phone:BankTransfer")
    local src = source

    local transferParameters = {
        type = 'transfer',
        amount = amount,
        senderaccount = fromAccount,
        recipientaccount = toAccount
    }
    
    local dummyEvent = function() return end

    local event = TriggerEvent("Bank:Server:ProcessBankTransaction", dummyEvent, src, transferParameters, false, src)
    print("returned event: ", event)
end)

RegisterNetEvent("Phone:LogTextMessage")
AddEventHandler("Phone:LogTextMessage", function(fromNumber, toNumber, content)
    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[tonumber(src)].CharID

    APIRequest = exports["soe-nexus"]:PerformAPIRequest("/api/phone/text", string.format("func=%s&tonumber=%s&fromnumber=%s&content=%s&charid=%s", 'send', toNumber, fromNumber, content, charID), true)
    TriggerClientEvent("Phone:UpdatePhoneElement", -1, "text", toNumber, fromNumber)
end)

RegisterNetEvent("Phones:GenerateNewPhone")
AddEventHandler("Phones:GenerateNewPhone", function(cb, src, style)
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[tonumber(src)].CharID
    APIRequest = exports["soe-nexus"]:PerformAPIRequest("/api/phone/modify", string.format("func=%s&model=%s&style=%s&charid=%s", 'create', 'gPhone1', style, charID), true)
    
    if APIRequest.status then
        cb(APIRequest.data)
    else
        print("Fatal error occurred: GenerateNewPhone API.")
        cb(false)
    end
end)

RegisterNetEvent("Phones:LogBleet")
AddEventHandler("Phones:LogBleet", function(IMEI, bleeterName, charID, bleetContent)
    print("Phones:LogBleet")
    local src = source

    print(string.format("accountid=%s&charid=%s&content=%s", bleeterName, charID, bleetContent))
    APIRequest = exports["soe-nexus"]:PerformAPIRequest("/api/bleeter/log", string.format("accountid=%s&charid=%s&content=%s", bleeterName, charID, bleetContent), true)
    
    if APIRequest.status then
        TriggerClientEvent("Phone:UpdatePhoneElement", -1, "bleet", bleeterName, bleetContent)
    else
        print("Fatal error occurred: LogBleet API.")
    end
end)

RegisterNetEvent("Phones:LogEmail")
AddEventHandler("Phones:LogEmail", function(IMEI, emailFrom, emailTo, charID, emailContent)
    -- print("Phones:LogEmail")
    local src = source

    APIRequest = exports["soe-nexus"]:PerformAPIRequest("/api/email/log", string.format("to=%s&from=%s&content=%s&charid=%s", emailTo, emailFrom, emailContent, charID), true)
    
    if APIRequest.status then
        TriggerClientEvent("Phone:UpdatePhoneElement", -1, "email", emailFrom, emailTo, emailContent)
    else
        print("Fatal error occurred: LogEmail API.")
    end
end)

RegisterNetEvent("Phones:LogAdvert")
AddEventHandler("Phones:LogAdvert", function(IMEI, advertPhone, advertEmail, advertContent, advertType)
    -- print("Phones:LogAdvert")
    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID

    APIRequest = exports["soe-nexus"]:PerformAPIRequest("/api/phone/newadvert", string.format("imei=%s&category=%s&content=%s&email=%s&phone=%s&charid=%s", IMEI, advertType, advertContent, advertEmail, advertPhone, charID), true)
    
    if APIRequest.status then
        TriggerClientEvent("Phone:UpdatePhoneElement", -1, "advert", advertAccount, advertContent)
    else
        print("Fatal error occurred: LogPhoneCall API.")
    end
end)

RegisterNetEvent("Phones:LogPhoneCall")
AddEventHandler("Phones:LogPhoneCall", function(toNumber, fromPhoneData)
    -- print("Phones:LogPhoneCall")
    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID

    APIRequest = exports["soe-nexus"]:PerformAPIRequest("/api/phone/call", string.format("charid=%s&to=%s&from=%s", charID, toNumber, fromPhoneData.phoneNumber), true)
    
    if APIRequest.status then
        TriggerClientEvent("Phone:UpdatePhoneElement", -1, "call", toNumber, fromPhoneData.phoneNumber)
    else
        print("Fatal error occurred: LogPhoneCall API.")
    end
end)

AddEventHandler("Phones:CreateNewAccount", function(cb, src, charID, IMEI, accountType, accountUsername, accountDisplayname, accountPassword)
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    local dataString

    -- CHANGE PARAMETERS BASED ON ACCOUNT TYPE
    if (accountType == "bleeter") then
        dataString = ("accounttype=%s&displayname=%s&username=%s&password=%s&charid=%s"):format(accountType, accountDisplayname, accountUsername, accountPassword, charID)
    elseif (accountType == "yellowpages") then
        dataString = ("accounttype=%s&displayname=%s&username=%s&password=%s&charid=%s"):format(accountType, accountDisplayname, accountUsername, accountPassword, charID)
    elseif (accountType == "email") then
        dataString = ("accounttype=%s&email=%s&password=%s&charid=%s"):format(accountType, accountUsername, accountPassword, charID)
    end

    -- SEND API REQUEST
    local createAccountAPI = exports["soe-nexus"]:PerformAPIRequest("/api/phone/createaccount", dataString, true)
    if createAccountAPI.status then
        -- LOGIN AND CHANGE PARAMETERS BASED ON ACCOUNT TYPE
        if (accountType == "bleeter") then
            dataString = ("accounttype=%s&username=%s&password=%s&charid=%s&imei=%s"):format(accountType, accountUsername, accountPassword, charID, IMEI)
        elseif (accountType == "yellowpages") then
            dataString = ("accounttype=%s&username=%s&password=%s&charid=%s&imei=%s"):format(accountType, accountUsername, accountPassword, charID, IMEI)
        elseif (accountType == "email") then
            dataString = ("accounttype=%s&email=%s&password=%s&charid=%s&imei=%s"):format(accountType, accountUsername, accountPassword, charID, IMEI)
        end

        -- SEND THE LOGIN API REQUEST
        local loginToAccountAPI = exports["soe-nexus"]:PerformAPIRequest("/api/phone/loginaccount", dataString, true)
        cb({["status"] = true, ["message"] = loginToAccountAPI.message})
    else
        print("Fatal error occurred: CreateNewAccount API.")
        cb({["status"] = false, ["message"] = createAccountAPI.message})
    end
end)

AddEventHandler("Phones:LoginToAccount", function(cb, src, IMEI, accountType, accountUsername, accountPassword)
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    local dataString

    -- CHANGE PARAMETERS BASED OFF ACCOUNT TYPE
    if (accountType == "bleeter") then
        dataString = ("accounttype=%s&username=%s&password=%s&charid=%s&imei=%s"):format(accountType, accountUsername, accountPassword, charID, IMEI)
    elseif (accountType == "yellowpages") then
        dataString = ("accounttype=%s&username=%s&password=%s&charid=%s&imei=%s"):format(accountType, accountUsername, accountPassword, charID, IMEI)
    elseif (accountType == "email") then
        dataString = ("accounttype=%s&email=%s&password=%s&charid=%s&imei=%s"):format(accountType, accountUsername, accountPassword, charID, IMEI)
    end

    -- SEND API REQUEST
    local loginToAccount = exports["soe-nexus"]:PerformAPIRequest("/api/phone/loginaccount", dataString, true)
    if loginToAccount.status then
        cb({["status"] = true, ["message"] = loginToAccount.message})
    else
        print("Fatal error occurred: LoginToAccount API: ", loginToAccount.message)
        cb({["status"] = false, ["message"] = loginToAccount.message})
    end
end)

AddEventHandler("Phones:LogoutOfAccount", function(cb, src, accountType, IMEI)
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    local logoutOfAccount = exports["soe-nexus"]:PerformAPIRequest("/api/phone/logoutaccount", ("charid=%s&imei=%s&accounttype=%s"):format(charID, IMEI, accountType), true)
    if logoutOfAccount.status then
        cb({["status"] = true, ["message"] = logoutOfAccount.message})
    else
        print("Fatal error occurred: LogoutOfAccount API.")
        cb({["status"] = false, ["message"] = logoutOfAccount.message})
    end
end)

RegisterNetEvent("Phones:UpdateContact")
AddEventHandler("Phones:UpdateContact", function(contactID, contactName, contactNumber, contactEmail, contactNotes, IMEI)
    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID

    APIRequest = exports["soe-nexus"]:PerformAPIRequest("/api/phone/modifycontact", string.format("imei=%s&charid=%s&name=%s&number=%s&email=%s&notes=%s&uid=%s", IMEI, charID, contactName, contactNumber, contactEmail, contactNotes, contactID), true)
    if APIRequest.status then
        return
    else
        print("Fatal error occurred: UpdateContact API.")
    end
end)

RegisterNetEvent("Phones:CreateContact")
AddEventHandler("Phones:CreateContact", function(IMEI, contactName, contactNumber, contactEmail, contactNotes)
    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID

    -- print(string.format("imei=%s&charid=%s&name=%s&number=%s&email=%s&notes=%s", IMEI, charID, contactName, contactNumber, contactEmail, contactNotes))
    APIRequest = exports["soe-nexus"]:PerformAPIRequest("/api/phone/modifycontact", string.format("imei=%s&charid=%s&name=%s&number=%s&email=%s&notes=%s", IMEI, charID, contactName, contactNumber, contactEmail, contactNotes), true)
    
    if APIRequest.status then
        return
    else
        print("Fatal error occurred: CreateContact API.")
    end
end)

RegisterNetEvent("Phones:RemoveContact")
AddEventHandler("Phones:RemoveContact", function(contactID, IMEI)
    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID

    APIRequest = exports["soe-nexus"]:PerformAPIRequest("/api/phone/modifycontact", string.format("imei=%s&charid=%s&uid=%s&delete=%s", IMEI, charID, contactID, true), true)
    
    if APIRequest.status then
        return
    else
        print("Fatal error occurred: RemoveContact API.")
    end
end)

RegisterNetEvent("Phones:UpdateNote")
AddEventHandler("Phones:UpdateNote", function(IMEI, noteID, noteContent)
    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID

    APIRequest = exports["soe-nexus"]:PerformAPIRequest("/api/phone/modifynote", string.format("charid=%s&imei=%s&uid=%s&content=%s", charID, IMEI, noteID, noteContent), true)
    
    if APIRequest.status then
        return
    else
        print("Fatal error occurred: UpdateNote API.")
    end
end)

RegisterNetEvent("Phones:CreateNote")
AddEventHandler("Phones:CreateNote", function(IMEI, noteContent)
    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID

    APIRequest = exports["soe-nexus"]:PerformAPIRequest("/api/phone/modifynote", string.format("charid=%s&imei=%s&content=%s", charID, IMEI, noteContent), true)
    
    if APIRequest.status then
        return
    else
        print("Fatal error occurred: CreateNote API.")
    end
end)

RegisterNetEvent("Phones:RemoveNote")
AddEventHandler("Phones:RemoveNote", function(IMEI, noteID)
    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID

    APIRequest = exports["soe-nexus"]:PerformAPIRequest("/api/phone/modifynote", string.format("charid=%s&imei=%s&uid=%s&delete=%s", charID, IMEI, noteID, true), true)
    
    if APIRequest.status then
        return
    else
        print("Fatal error occurred: RemoveNote API.")
    end
end)

RegisterNetEvent("Phones:UpdateBackground")
AddEventHandler("Phones:UpdateBackground", function(IMEI, phoneBackground)
    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID

    APIRequest = exports["soe-nexus"]:PerformAPIRequest("/api/phone/updatesettings", string.format("charid=%s&imei=%s&devicebackground=%s", charID, IMEI, phoneBackground), true)
    
    if APIRequest.status then
        return
    else
        print("Fatal error occurred: UpdateBackground API.")
    end
end)

RegisterNetEvent("Phones:UpdatePIN")
AddEventHandler("Phones:UpdatePIN", function(IMEI, phonePIN)
    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID

    APIRequest = exports["soe-nexus"]:PerformAPIRequest("/api/phone/updatesettings", string.format("charid=%s&imei=%s&devicepin=%s", charID, IMEI, phonePIN), true)
    
    if APIRequest.status then
        return
    else
        print("Fatal error occurred: UpdatePIN API.")
    end
end)

RegisterNetEvent("Phones:UpdateVolume")
AddEventHandler("Phones:UpdateVolume", function(IMEI, phoneVolume)
    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID

    APIRequest = exports["soe-nexus"]:PerformAPIRequest("/api/phone/updatesettings", string.format("charid=%s&imei=%s&devicevolume=%s", charID, IMEI, phoneVolume), true)
    
    if APIRequest.status then
        return
    else
        print("Fatal error occurred: UpdateVolume API.")
    end
end)

RegisterNetEvent("Phones:UpdateBleeterVolume")
AddEventHandler("Phones:UpdateBleeterVolume", function(IMEI, phoneVolume)
    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID

    APIRequest = exports["soe-nexus"]:PerformAPIRequest("/api/phone/updatesettings", string.format("charid=%s&imei=%s&bleetervolume=%s", charID, IMEI, phoneVolume), true)
    
    if APIRequest.status then
        return
    else
        print("Fatal error occurred: UpdateVolume API.")
    end
end)

RegisterNetEvent("Phones:PayStateDebt")
AddEventHandler("Phones:PayStateDebt", function(amt, fromAccount)
    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID

    APIRequest = exports["soe-nexus"]:PerformAPIRequest("/api/bank/paystate", string.format("charid=%s&type=%s&accountnumber=%s&amount=%s", charID, 'statedebt', fromAccount, amt), true)
    
    if APIRequest.status then
        local msg = ("HAS PAID THEIR STATE DEBT | AMOUNT: %s | FROM ACCOUNT: %s"):format(amt, fromAccount)
        exports["soe-logging"]:ServerLog("State Debt Payment Success", msg, src)

        return
    else
        local msg = ("HAS PAID THEIR STATE DEBT | AMOUNT: %s | FROM ACCOUNT: %s | ERROR MSG: %s"):format(amt, fromAccount, APIRequest.message)
        exports["soe-logging"]:ServerLog("State Debt Payment Failed", msg, src)

        print("Fatal error occurred: PayState API.")
    end
end)
