RegisterNetEvent("gPhone:Server:GetPhones")
AddEventHandler("gPhone:Server:GetPhones", function(cb, src)
    local getPhones = exports["soe-inventory"]:GetItemData(src, "cellphone", "left")
    --print(getPhones)
    cb(getPhones)
end)

RegisterNetEvent("gPhone:Server:SetNewPrimaryPhone")
AddEventHandler("gPhone:Server:SetNewPrimaryPhone", function(uid)
    --print("SetNewPrimaryPhone", uid)
    local src = source
    local phoneFound = false

    -- Get phones in player inventory
    local getPhones = exports["soe-inventory"]:GetItemData(src, "cellphone", "left")

    -- Search through phones returned
    for phoneID, phoneData in pairs (getPhones) do
        -- Check phone specified exists in player inventory
        --print(phoneID, uid)
        if tonumber(phoneID) == tonumber(uid) then
            phoneFound = phoneData
        else
            -- Remove primary setting from all phones currently in inventory
            local ItemMeta = json.decode(phoneData.ItemMeta)
            ItemMeta.isPrimaryPhone = nil

            -- print("Setting meta")
            exports["soe-inventory"]:ModifyItemMeta(phoneID, json.encode(ItemMeta))
        end
    end

    if phoneFound then
        -- print("found")
        local newItemMeta = json.decode(phoneFound.ItemMeta)
        newItemMeta.isPrimaryPhone = true
        newItemMeta = json.encode(newItemMeta)

        local APICallback = exports["soe-inventory"]:ModifyItemMeta(uid, newItemMeta)

        TriggerClientEvent("gPhone:Client:HandleServerCallback", src, "SetNewPrimaryPhone", APICallback)
    else
        -- print("not found")
        TriggerClientEvent("gPhone:Client:HandleServerCallback", src, "SetNewPrimaryPhone", json.encode({status = false, message = "Phone does not exist in player inventory."}))
    end
end)

RegisterNetEvent("gPhone:Server:SyncDevice")
AddEventHandler("gPhone:Server:SyncDevice", function(cb, src, phoneIMEI)
    local charid = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    local APIRequest = exports["soe-nexus"]:PerformAPIRequest("/api/phone/syncdevice", ("imei=%s&charid=%s"):format(phoneIMEI, charid), true)
    cb(APIRequest)
end)