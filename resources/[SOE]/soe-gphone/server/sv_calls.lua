RegisterNetEvent("Phones:SendIncomingPhoneCall")
AddEventHandler("Phones:SendIncomingPhoneCall", function(toNumber, phoneData, locationPos, locationData)
    TriggerClientEvent("Phones:ReceiveIncomingPhoneCall", -1, toNumber, phoneData, locationData, locationData)
end)

RegisterNetEvent("Phones:SendAnsweredEvent")
AddEventHandler("Phones:SendAnsweredEvent", function(toNumber, fromNumber)
    TriggerClientEvent("Phones:ReceiveAnsweredEvent", -1, toNumber, fromNumber)
end)

RegisterNetEvent("Phones:SendHangupEvent")
AddEventHandler("Phones:SendHangupEvent", function(callChannel)
    TriggerClientEvent("Phones:ReceiveHangupEvent", -1, callChannel)
end)

RegisterNetEvent("Phones:SendBusinessAnsweredEvent")
AddEventHandler("Phones:SendBusinessAnsweredEvent", function(answeredSrc)
    TriggerClientEvent("Phones:ReceiveBusinessCallAnsweredEvent", -1, answeredSrc)
end)
