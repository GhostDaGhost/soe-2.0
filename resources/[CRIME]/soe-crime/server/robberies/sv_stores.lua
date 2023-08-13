-- CALLED UPON CLIENT STARTUP TO SYNC REGISTER/SAFE STATUS
RegisterNetEvent("Crime:Server:SyncStoreRobbables")
AddEventHandler("Crime:Server:SyncStoreRobbables", function()
    local src = source
    TriggerClientEvent("Crime:Client:SyncStoreRobbables", src, storeRegisters, storeSafes)
end)

-- CALLED FROM CLIENT TO GLOBAL SEND A STORE ROBBERY ALERT
RegisterNetEvent("Crime:Server:SendStoreRobberyAlert")
AddEventHandler("Crime:Server:SendStoreRobberyAlert", function(location, pos, type, storeName)
    local src = source
    TriggerClientEvent("Crime:Client:SendStoreRobberyAlert", -1, location, pos, type, storeName)
    exports["soe-logging"]:ServerLog("Store Robbery", ("IS ROBBING A %s THE %s ON %s"):format(type, storeName, location), src)
end)

-- SET A CERTAIN STORE REGISTER AS ROBBED OR NOT
RegisterNetEvent("Crime:Server:SetRegisterStatus")
AddEventHandler("Crime:Server:SetRegisterStatus", function(register)
    storeRegisters[register].robbed = true
    TriggerClientEvent("Crime:Client:SetRegisterStatus", -1, register, true)
end)

-- SET A CERTAIN SAFE AS ROBBED OR NOT
RegisterNetEvent("Crime:Server:SetSafeStatus")
AddEventHandler("Crime:Server:SetSafeStatus", function(safe)
    storeSafes[safe].robbed = true
    TriggerClientEvent("Crime:Client:SetSafeStatus", -1, safe, true)
end)
