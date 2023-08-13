local newPhoneReturn = nil
local returnedAccount = nil
local createAccountStatus = nil
local loginToAccountStatus = nil
local logoutOfAccountStatus = nil
local takeKeyboardControls = false
local debounceCheckPrimaryPhone = false

phoneVolume = 0.5
bleeterVolume = 0.5
isPhoneOpen = false
isPhoneFake = false
lastClimateCheck = 0
disableCamera = true
primaryPhoneUID = nil
primaryPhoneData = nil
primaryPhoneDataFromServer = nil

-- KEY MAPPINGS
RegisterKeyMapping("opengphone", "[gPhone] Open", "keyboard", "PAGEUP")
RegisterKeyMapping("+togglegphonecam", "[gPhone] Camera Movement", "keyboard", "LMENU")

-- CHECKS IF PRIMARY PHONE IS SET
local function IsPrimaryPhoneSet()
    local phone, myInv = false, exports["soe-inventory"]:RequestInventory()
    if myInv.leftInventory then
        for id, data in pairs(myInv.leftInventory) do
            if (data.ItemType == "cellphone") then
                if json.decode(data.ItemMeta).isPrimaryPhone then
                    phone = {exists = true, id = id, meta = data.ItemMeta}
                end
            end
        end
    end
    return phone
end

-- CHECKS IF PLAYER HAS A PRIMARY PHONE IN THEIR INVENTORY
local function CheckForPrimaryPhone()
    if not debounceCheckPrimaryPhone then
        debounceCheckPrimaryPhone = true
        -- Call server event to search for phones

        local callback = exports["soe-nexus"]:TriggerServerCallback("gPhone:Server:GetPhones")

        -- Check for phones in player inventory
        if callback then
            for UID, phoneData in pairs(callback) do
                if json.decode(phoneData.ItemMeta).isPrimaryPhone then
                    -- print("ItemID: ", UID)
                    -- print("phoneData: ", json.encode(phoneData))
                    setPrimaryPhoneData(UID, phoneData.ItemMeta)
                end
            end
        else
            -- print("No phones found in player inventory.")
        end

        debounceCheckPrimaryPhone = false
    else
        -- print("Caught by debounce (CheckForPrimaryPhone)")
    end
end

-- OPENS GPHONE
local function OnPhoneKeypress()
    if exports["soe-prison"]:IsImprisoned() or exports["soe-emergency"]:IsRestrained() or exports["soe-fuel"]:IsFueling() then
        --print("CANNOT SHOW PHONE BECAUSE EITHER IN PRISON OR FUELING OR HANDCUFFED.")
        return
    end

    CheckForPrimaryPhone()
    local myPhone = IsPrimaryPhoneSet()
    if not myPhone.exists then
        print("NO PRIMARY PHONE SET IN THE INVENTORY.")
        primaryPhoneUID = nil
        primaryPhoneData = nil
    end

    showPhone()
end

-- GETTER FOR PHONE VISIBILITY
function IsPhoneOpen()
    return isPhoneOpen
end

-- GETTER FOR TYPING ON PHONE
function IsTypingInPhone()
    return takeKeyboardControls
end

function SendFakeText(fromNumber, message)
    TriggerServerEvent("Phone:LogTextMessage", fromNumber, primaryPhoneData.phoneNumber, message)
end

-- GENERATE A NEW PHONE WITH RANDOM NUMBER
function generateNewPhone(type, style)
    local callback = exports["soe-nexus"]:TriggerServerCallback("Phones:GenerateNewPhone", style)

    local owner = (exports["soe-uchuu"]:GetPlayer().FirstGiven .. " " .. exports["soe-uchuu"]:GetPlayer().LastGiven) or "No Records"
    local newPhoneData = callback.data

    if callback.status and newPhoneData then
        return newPhoneData.number, newPhoneData.imei, newPhoneData.style, owner
    else
        return nil, nil, nil, nil
    end
end

-- REQUEST AND SEND TIME WEATHER DATA (TO BE CALLED EVERY 10 SECONDS)
function RecordTimeWeather()
    local weather = exports["soe-climate"]:GetWeather()

    -- CALCULATE OUR GAME TIME
    local hour = GetClockHours()
    local minute = GetClockMinutes()
    if (minute < 10) then
        minute = "0" .. minute
    end
    local time = hour .. ":" .. minute

    -- GENERATE A TEMPERATURE
    math.randomseed(hour)
    local min, max = tonumber(weather["temp"].min), tonumber(weather["temp"].max)
    local temp = math.random(min, max)

    SendNUIMessage({type = "updateTime", currentTime = time})
    SendNUIMessage({type = "updateWeather", currentTemp = temp, currentForecast = weather.forecastText, currentWeather = weather.weatherType})
end

-- SET THE PRIMARY PHONE DATA FOR THIS PLAYER
function setPrimaryPhoneData(uid, data)
    -- print(data)
    -- print("setPrimaryPhoneData")
    local decodedItemMeta = json.decode(data)
    if decodedItemMeta.isPrimaryPhone then
        TriggerServerEvent("gPhone:Server:SetNewPrimaryPhone", uid)
    else
        return
    end

    primaryPhoneUID = uid
    primaryPhoneData = json.decode(data)
    if primaryPhoneData.phoneVolume then
        phoneVolume = tonumber(primaryPhoneData.phoneVolume) / 10
    end

    -- Set owner data
    primaryPhoneData.phoneOwner = exports["soe-uchuu"]:GetPlayer().FirstGiven .. " " .. exports["soe-uchuu"]:GetPlayer().LastGiven
    if primaryPhoneData.bleeterVolume then
        bleeterVolume = tonumber(primaryPhoneData.bleeterVolume) / 10
    end

    TriggerServerEvent("Inventory:UpdateItemMeta", charID, uid, primaryPhoneData)
    SendNUIMessage({type = "syncPhone", IMEI = primaryPhoneData.phoneIMEI})
end

-- BRING UP THE PHONE UI OR FAKE PHONE UI
function showPhone()
    -- POSSIBLE FIX TO RANDOM SHOOTING WHILE OPENING PHONE WITH GUN (06/28/2020)
    SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
    
    local charID = exports["soe-uchuu"]:GetPlayer().CharID
    if not primaryPhoneData then
        SendNUIMessage({type = "showFakePhone"})
        isPhoneOpen = true
        isPhoneFake = true
        SetNuiFocusKeepInput(true)
        SetNuiFocus(true, true)
        Wait(100)
        SetNuiFocusKeepInput(true)
        SetNuiFocus(true, true)
        return
    end

    SendNUIMessage({
        type = "showPhone",
        IMEI = primaryPhoneData.phoneIMEI,
        CharID = charID,
        volume = phoneVolume,
        bleeterVolume = bleeterVolume
    })
    isPhoneOpen = true
    SetNuiFocusKeepInput(true)
    SetNuiFocus(true, true)
    Wait(100)
    SetNuiFocusKeepInput(true)
    SetNuiFocus(true, true)
end

-- KEYPRESS COMMANDS
RegisterCommand("opengphone", OnPhoneKeypress)
RegisterCommand("+togglegphonecam", function()
    if (primaryPhoneUID ~= nil) and isPhoneOpen then
        disableCamera = false
    end
end)

RegisterCommand("-togglegphonecam", function()
    if (primaryPhoneUID ~= nil) and isPhoneOpen then
        disableCamera = true
    end
end)

-- GET CURRENT ACCOUNT OF TYPE
RegisterNUICallback("returnAccount", function(data, cb)
    returnedAccount = data.accountInfo
    cb()
end)

-- NUI CALLBACK FOR KEYBOARD CONTROL
RegisterNUICallback("keyboardControl", function(data, cb)
    if isPhoneOpen then
        takeKeyboardControls = data.takeKeyboard
        SetNuiFocusKeepInput(not data.takeKeyboard)
    end
    cb()
end)

-- NUI CALLBACK FOR CLOSING PHONE UI
RegisterNUICallback("HandleUI", function(data, cb)
    -- print("HandleUI received")
    if data.close then
        -- print("close")
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
        Wait(250)
        isPhoneOpen = false
        local ped = PlayerPedId()
        -- ClearPedTasks(ped)
        -- Fix for animations cancelling when closing the phone (boba)
        StopAnimTask(ped, "cellphone@", "cellphone_call_listen_base", 2.5)
        StopAnimTask(ped, "cellphone@", "cellphone_text_in", 2.5)
        StopAnimTask(ped, "cellphone@in_car@ds", "cellphone_call_listen_base", 2.5)
        StopAnimTask(ped, "cellphone@in_car@ds", "cellphone_text_read_base", 2.5)
        --exports["soe-emotes"]:CancelEmote()
        exports["soe-emotes"]:EliminateAllProps()
        isPhoneFake = false
    end
    cb()
end)

-- PUSH EVENTS FROM THE PHONE UI
RegisterNUICallback(
    "pushEvent",
    function(data, cb)
        local IMEI = primaryPhoneData.phoneIMEI
        local charID = exports["soe-uchuu"]:GetPlayer().CharID

        -- print("event: ", data.eventType)
        if data.eventType == "bleet" then
            TriggerServerEvent("Phones:LogBleet", IMEI, data.bleetUsername, charID, data.bleetContent)
            SendNUIMessage({type = "syncPhone", IMEI = primaryPhoneData.phoneIMEI})
        elseif data.eventType == "text" then
            -- PLACE HOLDER FOR FAKE TEXT MESSAGES
            --[[if data.toNumber == "555-414-1414" then
                --
            end]]
            -- Send Text
            TriggerServerEvent("Phone:LogTextMessage", primaryPhoneData.phoneNumber, data.toNumber, data.content)
            SendNUIMessage({type = "syncPhone", IMEI = primaryPhoneData.phoneIMEI})
        elseif data.eventType == "advert" then
            TriggerServerEvent("Phones:LogAdvert", IMEI, data.advertPhone, data.advertEmail, data.advertContent, data.advertType)
            SendNUIMessage({type = "syncPhone", IMEI = primaryPhoneData.phoneIMEI})
        elseif data.eventType == "createNote" then
            TriggerServerEvent("Phones:CreateNote", IMEI, data.noteContent)
            SendNUIMessage({type = "syncPhone", IMEI = primaryPhoneData.phoneIMEI})
        elseif data.eventType == "modNote" then
            TriggerServerEvent("Phones:UpdateNote", IMEI, data.noteID, data.noteContent)
            SendNUIMessage({type = "syncPhone", IMEI = primaryPhoneData.phoneIMEI})
        elseif data.eventType == "removeNote" then
            TriggerServerEvent("Phones:RemoveNote", IMEI, data.noteID)
            SendNUIMessage({type = "syncPhone", IMEI = primaryPhoneData.phoneIMEI})
        elseif data.eventType == "email" then
            TriggerServerEvent("Phones:LogEmail", IMEI, data.emailFrom, data.emailTo, charID, data.emailContent)
            SendNUIMessage({type = "syncPhone", IMEI = primaryPhoneData.phoneIMEI})
        elseif data.eventType == "call" then
            StartPhoneCall(data.toNumber, primaryPhoneData)
        elseif data.eventType == "callEnd" then
            EndPhoneCall(false)
        elseif data.eventType == "callAnswer" then
            AnswerIncomingCall(false)
        elseif data.eventType == "modContact" then
            TriggerServerEvent("Phones:UpdateContact", data.contactID, data.contactName, data.contactNumber, data.contactEmail, data.contactNotes, data.imei)
        elseif data.eventType == "createContact" then
            TriggerServerEvent("Phones:CreateContact", IMEI, data.contactName, data.contactNumber, data.contactEmail, data.contactNotes)
            SendNUIMessage({type = "syncPhone", IMEI = primaryPhoneData.phoneIMEI})
        elseif data.eventType == "removeContact" then
            TriggerServerEvent("Phones:RemoveContact", data.contactID, data.imei)
            SendNUIMessage({type = "syncPhone", IMEI = primaryPhoneData.phoneIMEI})
        elseif data.eventType == "banktransfer" then
            TriggerServerEvent("Phone:BankTransfer", data.fromAccount, data.toAccount, tonumber(data.amount))
            exports["soe-ui"]:SendAlert("success", ("You transferred $%s to account #%s from account #%s"):format(data.amount, data.toAccount, data.fromAccount), 5000)
            SendNUIMessage({type = "syncPhone", IMEI = primaryPhoneData.phoneIMEI})
        elseif data.eventType == "paystatedebt" then
            TriggerServerEvent("Phones:PayStateDebt", data.amount, data.fromAccount)
            SendNUIMessage({type = "syncPhone", IMEI = primaryPhoneData.phoneIMEI})
        elseif data.eventType == "bankopenaccount" then
            exports["soe-ui"]:SendAlert("error", "You notice the create bank account feature is currently disabled by the Fleeca app developer!", 5000)
        elseif data.eventType == "createAccount" then
            -- print("createAccount")
            local callback = exports["soe-nexus"]:TriggerServerCallback("Phones:CreateNewAccount", charID, IMEI, data.accountType, data.accountUsername, data.accountDisplayname, data.accountPassword)
            SendNUIMessage({type = "syncPhone", IMEI = primaryPhoneData.phoneIMEI})
            cb(callback)
        elseif data.eventType == "loginToAccount" then
            local callback = exports["soe-nexus"]:TriggerServerCallback("Phones:LoginToAccount", IMEI, data.accountType, data.accountUsername, data.accountPassword)
            SendNUIMessage({type = "syncPhone", IMEI = primaryPhoneData.phoneIMEI})
            cb(callback)
        elseif data.eventType == "logoutOfAccount" then
            local callback = exports["soe-nexus"]:TriggerServerCallback("Phones:LogoutOfAccount", data.accountType, IMEI)
            SendNUIMessage({type = "syncPhone", IMEI = primaryPhoneData.phoneIMEI})
            cb(callback)
        elseif data.eventType == "modBackground" then
            TriggerServerEvent("Phones:UpdateBackground", IMEI, data.phoneBackground)
        elseif data.eventType == "modPIN" then
            TriggerServerEvent("Phones:UpdatePIN", IMEI, data.phonePIN)
        elseif data.eventType == "modVolume" then
            primaryPhoneData.phoneVolume = data.phoneVolume
            phoneVolume = tonumber(data.phoneVolume) / 10
            TriggerServerEvent("Phones:UpdateVolume", IMEI, data.phoneVolume)
        elseif data.eventType == "modBleeterVolume" then
            primaryPhoneData.bleeterVolume = data.bleeterVolume
            bleeterVolume = tonumber(data.bleeterVolume) / 10
            TriggerServerEvent("Phones:UpdateBleeterVolume", IMEI, data.bleeterVolume)
        end
        return
        cb()
    end
)

-- RECEIVES
RegisterNetEvent("Phones:ReceiveNewPhoneData")
AddEventHandler("Phones:ReceiveNewPhoneData", function(phoneData)
    newPhoneReturn = phoneData
end)

RegisterNetEvent("Phones:SendFakeText")
AddEventHandler("Phones:SendFakeText", function(fromNumber, message)
    SendFakeText(fromNumber, message)
end)

AddEventHandler("Hud:Client:ToggleHud", function()
    SendNUIMessage({type = "clearNotifications"})
end)

-- WHEN TRIGGERED, RESET ALL NUI INSTANCES
AddEventHandler("UI:Client:ResetNUI", function()
    SendNUIMessage({type = "Phone.HideUI"})
    SendNUIMessage({type = "clearNotifications"})
end)

RegisterNetEvent("gPhone:Client:MuteNotifications")
AddEventHandler("gPhone:Client:MuteNotifications", function(data)
    if not data.status then return end
    SendNUIMessage({type = "clearNotifications"})
end)

-- ON CLIENT RESOURCE START
AddEventHandler("onClientResourceStart", function(resource)
    if (GetCurrentResourceName() ~= resource) then return end

    -- Ensure CharID is loaded to ensure inventory check doesn't fail
    while not exports["soe-uchuu"]:GetPlayer().CharID do
        Wait(100)
    end
    CheckForPrimaryPhone()
end)

-- SYNC THE PHONE AND SEND NOTIFICATIONS IF NEEDED
RegisterNetEvent("Phone:UpdatePhoneElement")
AddEventHandler("Phone:UpdatePhoneElement", function(type, arg1, arg2)
    if exports["soe-prison"]:IsImprisoned() then
        return
    end

    if not primaryPhoneData then
        print("No primary phone data detected")
        return
    end

    local myPhone = IsPrimaryPhoneSet()
    if not myPhone then
        print("myPhone is nil.")
        return
    end

    if not myPhone.exists then
        print("NO PHONE FOUND")
        return
    end

    hasToPhone = false
    hasFromPhone = false
    if primaryPhoneData.phoneNumber == arg1 then
        hasToPhone = true
    elseif primaryPhoneData.phoneNumber == arg2 then
        hasFromPhone = true
    end

    local mutedPhone = json.decode(exports["soe-uchuu"]:GetPlayer().UserSettings)["mutedPhone"] or false
    if type == "contacts" or type == "note" then
        SendNUIMessage({type = "syncPhone", IMEI = primaryPhoneData.phoneIMEI})
    elseif type == "bleet" then
        SendNUIMessage({type = "syncPhone", IMEI = primaryPhoneData.phoneIMEI})
        -- print("bleeterVolume: ", bleeterVolume)
        --exports["soe-utils"]:PlayProximitySound(3.0, "bleeter-new-bleet.ogg", bleeterVolume)
        exports["soe-utils"]:PlaySound("bleeter-new-bleet.ogg", bleeterVolume, false)
        if not isPhoneOpen then
            if exports["soe-aviation"]:IsUsingHelicam() then return end
            if not exports["soe-ui"]:HudVisible() then return end

            if not mutedPhone then
                SendNUIMessage({type = "showNotification", notifyType = "bleeter", showNotify = true})
            end
        end
    elseif type == "text" then
        if hasToPhone then
            -- NOTIFICATION HERE
            SendNUIMessage({type = "syncPhone", IMEI = primaryPhoneData.phoneIMEI})
            --exports["soe-utils"]:PlayProximitySound(3.0, "text-new-message.ogg", phoneVolume)
            exports["soe-utils"]:PlaySound("text-new-message.ogg", phoneVolume, false)
            if not isPhoneOpen then
                if exports["soe-aviation"]:IsUsingHelicam() then return end
                if not exports["soe-ui"]:HudVisible() then return end
                
                if not mutedPhone then
                    SendNUIMessage({type = "showNotification", notifyType = "text", showNotify = true})
                end
            end
        elseif hasFromPhone then
            SendNUIMessage({type = "syncPhone", IMEI = primaryPhoneData.phoneIMEI})
        end
    elseif type == "call" then
        if hasToPhone then
            -- NOTIFICATION HERE
            SendNUIMessage({type = "syncPhone", IMEI = primaryPhoneData.phoneIMEI})
        elseif hasFromPhone then
            SendNUIMessage({type = "syncPhone", IMEI = primaryPhoneData.phoneIMEI})
        end
    elseif type == "email" then
        SendNUIMessage({type = "getAccount", accountType = "email"})
        while (returnedAccount == nil) do
            Wait(5)
        end

        if returnedAccount == arg1 or returnedAccount == arg2 then
            SendNUIMessage({type = "syncPhone", IMEI = primaryPhoneData.phoneIMEI})
            if returnedAccount == arg2 then
                --exports["soe-utils"]:PlayProximitySound(3.0, "email-new-message.ogg", phoneVolume)
                exports["soe-utils"]:PlaySound("email-sent-message.ogg", phoneVolume, false)
                if not isPhoneOpen then
                    if exports["soe-aviation"]:IsUsingHelicam() then return end
                    if not exports["soe-ui"]:HudVisible() then return end

                    if not mutedPhone then
                        SendNUIMessage({type = "showNotification", notifyType = "email", showNotify = true})
                    end
                end
            else
                --exports["soe-utils"]:PlayProximitySound(3.0, "email-sent-message.ogg", phoneVolume)
                exports["soe-utils"]:PlaySound("email-sent-message.ogg", phoneVolume, false)
            end
        end
        returnedAccount = nil
    elseif type == "advert" then
        SendNUIMessage({type = "syncPhone", IMEI = primaryPhoneData.phoneIMEI})
    end
end)
