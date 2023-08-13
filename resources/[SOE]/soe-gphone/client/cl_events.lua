local SyncDeviceDebounce = false
callback = {}

-- INVENTORY INTERACTION
function InventoryUse(itemID)
    TriggerServerEvent("gPhone:Server:SetNewPrimaryPhone", itemID)
end

RegisterNetEvent("gPhone:Client:HandleServerCallback")
AddEventHandler("gPhone:Client:HandleServerCallback", function(event, data)
    callback[event] = data
end)

-- NUI Callbacks
RegisterNUICallback("SyncDevice", function(data, cb)
    if not SyncDeviceDebounce then
        SyncDeviceDebounce = true
        local callback = exports["soe-nexus"]:TriggerServerCallback("gPhone:Server:SyncDevice", primaryPhoneData.phoneIMEI)
        if callback and callback.data then
            data = callback.data
            primaryPhoneDataFromServer = data
            phoneVolume = tonumber(primaryPhoneDataFromServer.Volume) / 10
            bleeterVolume = tonumber(primaryPhoneDataFromServer.BleeterVolume) / 10
        end

        -- Send callback
        cb({response = json.encode(callback)})
        SyncDeviceDebounce = false
    else
        cb()

        -- TRY TO FIX STUCK DEBOUNCE
        SetTimeout(35000, function()
            SyncDeviceDebounce = false
        end)
    end
end)
