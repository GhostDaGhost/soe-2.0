-- CURRENT CALL INFORMATION
local emergencyCallPhoneData, emergencyCallLocationData
local incomingEmergencyCallNumber, incomingEmergencyCallNumberWanted
local currentCallChannel, potentialCallChannel, potentialEmergencyChannel

ringLoops = 0
isOnCall = false
hasAnswered = false

myNumberOnCall = nil
theirNumberOnCall = nil

incomingCallNumber = nil
incomingCallNumberWanted = nil

-- NORMALIZES PHONE NUMBER
local function NormalizeNumber(phoneNumber)
    phoneNumber = phoneNumber:gsub("-", "")
    return phoneNumber
end

function StartPhoneCall(toNumber, phoneData)
    isOnCall = true
    exports["soe-ui"]:PlaySound("phone_ringing", "phone_ringing.ogg", phoneVolume, true)

    hasAnswered = false
    theirNumberOnCall = toNumber
    myNumberOnCall = phoneData.phoneNumber

    currentCallChannel = tonumber(NormalizeNumber(phoneData.phoneNumber) .. NormalizeNumber(toNumber))
    SendNUIMessage({type = "showNotification", notifyType = "phone", showNotify = true})
    exports["soe-voice"]:AddPlayerToCall(currentCallChannel)

    local pos = GetEntityCoords(PlayerPedId())
    local location = exports["soe-utils"]:GetLocation(pos)
    TriggerServerEvent("Phones:SendIncomingPhoneCall", toNumber, phoneData, pos, location)
    TriggerServerEvent("Phones:LogPhoneCall", toNumber, phoneData)
end

function AnswerIncomingCall(isEmergency)
    -- Fix: myNumberOnCall was resetting when call answered due to how events are triggered by NUI - this prevents that
    if isOnCall or not primaryPhoneData then
        return
    end

    isOnCall = true
    hasAnswered = true
    if isEmergency then
        myNumberOnCall = incomingEmergencyCallNumberWanted
        theirNumberOnCall = incomingEmergencyCallNumber

        if (myNumberOnCall == "911") then
            TriggerEvent("Chat:Client:Message", "[Dispatch ANI]", ("Contract holder for %s: %s"):format(incomingEmergencyCallNumber, emergencyCallPhoneData.phoneOwner), "phone")
            TriggerEvent("Chat:Client:Message", "[Dispatch ALI]", ("Location ping on call: %s"):format(emergencyCallLocationData), "phone")
        end
    else
        myNumberOnCall = incomingCallNumberWanted
        theirNumberOnCall = incomingCallNumber

        local inventory = exports["soe-inventory"]:RequestInventory()
        if inventory and inventory.leftInventory then
            for itemID, itemData in pairs (inventory.leftInventory) do
                if itemData.ItemType == "cellphone" then
                    if json.decode(itemData.ItemMeta).phoneNumber == incomingCallNumberWanted then
                        break
                    end
                end
            end
        end
    end

    if myNumberOnCall:find('^800') then
        TriggerServerEvent("Phones:SendBusinessAnsweredEvent", PlayerId())
    end

    currentCallChannel = tonumber(NormalizeNumber(theirNumberOnCall) .. NormalizeNumber(myNumberOnCall))
    SendNUIMessage({type = "showNotification", notifyType = "phone", showNotify = true})
    exports["soe-voice"]:AddPlayerToCall(currentCallChannel)

    exports["soe-ui"]:EndSound("phone_ringtone")
    exports["soe-ui"]:EndSound("phone_ringing")
    TriggerServerEvent("Phones:SendAnsweredEvent", myNumberOnCall, theirNumberOnCall)

    incomingCallNumberWanted = nil
    incomingCallNumber = nil
    incomingEmergencyCallNumberWanted = nil
    incomingEmergencyCallNumber = nil
end

function EndPhoneCall(fromEvent)
    if not isOnCall or not primaryPhoneData and incomingCallNumber == nil and incomingEmergencyCallNumber == nil then
        return
    end
    exports["soe-voice"]:RemovePlayerFromCall()
    SendNUIMessage({type = "showNotification", notifyType = "phone", showNotify = false})

    if not fromEvent and not myNumberOnCall:find('^800') then
        if not currentCallChannel then
            TriggerServerEvent("Phones:SendHangupEvent", potentialCallChannel)
        else
            TriggerServerEvent("Phones:SendHangupEvent", currentCallChannel)
        end
    end

    if myNumberOnCall == "911" or myNumberOnCall == "311" then
        exports["soe-ui"]:SendAlert("error", "Call ended", 5500)
    end

    exports["soe-ui"]:EndSound("phone_ringing")
    exports["soe-ui"]:EndSound("phone_ringtone")
    if not hasAnswered and incomingCallNumber ~= nil then
        SendNUIMessage({type = "endCall", fromLUA = true, wasAnswered = false})
    else
        SendNUIMessage({type = "endCall", fromLUA = true})
    end

    isOnCall = false
    hasAnswered = false
    myNumberOnCall = nil
    theirNumberOnCall = nil
    incomingCallNumber = nil
    incomingCallNumberWanted = nil
    incomingEmergencyCallNumber = nil
    incomingEmergencyCallNumberWanted = nil
    currentCallChannel = nil
    potentialCallChannel = nil
end

RegisterCommand("hangup", function()
    if myNumberOnCall == "311" or myNumberOnCall == "911" then
        EndPhoneCall(false)
    end
end)

RegisterCommand("answer", function()
    if incomingEmergencyCallNumber ~= nil and (incomingEmergencyCallNumberWanted == "911" or incomingEmergencyCallNumberWanted == "311") then
        AnswerIncomingCall(true)
    else
        exports["soe-ui"]:SendAlert("error", "No pending emergency service calls", 5000)
    end
end)

RegisterNUICallback("Phone.EndRingtone", function()
    exports["soe-ui"]:EndSound("phone_ringing")
    exports["soe-ui"]:EndSound("phone_ringtone")
end)

RegisterNetEvent("Phones:ReceiveHangupEvent")
AddEventHandler("Phones:ReceiveHangupEvent", function(callChannel)
    if currentCallChannel ~= callChannel and potentialCallChannel ~= callChannel and potentialEmergencyChannel ~= callChannel then
        return
    end
    exports["soe-ui"]:EndSound("phone_ringing")
    exports["soe-ui"]:EndSound("phone_ringtone")
    EndPhoneCall(true)
end)

RegisterNetEvent("Phones:ReceiveAnsweredEvent")
AddEventHandler("Phones:ReceiveAnsweredEvent", function(toNumber, fromNumber)
    local myJob = exports["soe-jobs"]:GetMyJob()
    if (toNumber == "911" or toNumber == "311") and (myJob == "EMS" or myJob == "POLICE" or myJob == "DISPATCH") then
        TriggerEvent("Chat:Client:Message", "[Dispatch]", ("Emergency service call from %s has been answered."):format(fromNumber), "phone")
    end

    if myNumberOnCall ~= fromNumber or theirNumberOnCall ~= toNumber then
        return
    end

    hasAnswered = true
    SendNUIMessage({type = "callAnswered"})
    exports["soe-ui"]:EndSound("phone_ringing")
end)

RegisterNetEvent("Phones:ReceiveIncomingPhoneCall")
AddEventHandler("Phones:ReceiveIncomingPhoneCall", function(toNumber, phoneData, locationPos, locationData)
    if exports["soe-prison"]:IsImprisoned() or not primaryPhoneData then
        return
    end

    local hasPhone = false
    local inventory = exports["soe-inventory"]:RequestInventory()
    if inventory and inventory.leftInventory then
        for _, itemData in pairs(inventory.leftInventory) do
            if itemData.ItemType == "cellphone" then
                if json.decode(itemData.ItemMeta).phoneNumber == toNumber then
                    hasPhone = true
                    break
                end
            end
        end
    end

    if (not hasPhone or isOnCall) and toNumber ~= "911" and toNumber ~= "311" then
        return
    end

    if toNumber == "911" or toNumber == "311" then
        local myJob = exports["soe-jobs"]:GetMyJob()
        if (myJob == "EMS" or myJob == "POLICE" or myJob == "DISPATCH") then
            incomingEmergencyCallNumber = phoneData.phoneNumber
            incomingEmergencyCallNumberWanted = toNumber
            PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
            TriggerEvent("Chat:Client:Message", "[Dispatch]", ("Incoming emergency services call from %s to %s. Use /answer to answer."):format(incomingEmergencyCallNumber, incomingEmergencyCallNumberWanted), "phone")

            emergencyCallPhoneData = phoneData
            emergencyCallLocationData = locationData
            potentialEmergencyChannel = tonumber(NormalizeNumber(incomingEmergencyCallNumber) .. NormalizeNumber(incomingEmergencyCallNumberWanted))
        end
        return
    end

    incomingCallNumber = phoneData.phoneNumber
    incomingCallNumberWanted = toNumber
    myNumberOnCall = toNumber
    potentialCallChannel = tonumber(NormalizeNumber(incomingCallNumber) .. NormalizeNumber(incomingCallNumberWanted))

    SendNUIMessage({type = "incomingCall", fromNumber = incomingCallNumber})
    exports["soe-ui"]:PlaySound("phone_ringtone", "phone_ringtone.ogg", phoneVolume, true)
end)

RegisterNetEvent("Phones:ReceiveBusinessCallAnsweredEvent")
AddEventHandler("Phones:ReceiveBusinessCallAnsweredEvent", function(answeredSrc)
    if myNumberOnCall == incomingCallNumberWanted then
        if answeredSrc == PlayerId() then
            return
        else
            -- print("Stop ringing, call answered by another phone.")
            EndPhoneCall(true)
        end
    end
end)
