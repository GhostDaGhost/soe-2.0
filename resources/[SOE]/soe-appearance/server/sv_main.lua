-- ***********************
--         Events
-- ***********************
-- WHEN TRIGGERED, REQUEST OUTFITS FOR SOURCE AND SEND IT BACK
AddEventHandler("Appearance:Server:RequestOutfits", function(cb, src)
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    if not charID then cb({}) return end

    local getOutfits = exports["soe-nexus"]:PerformAPIRequest("/api/character/getoutfits", ("charid=%s"):format(charID), true)
    if not getOutfits or not getOutfits.status then
        cb({})
        return
    end
    cb(getOutfits.data)
end)

-- WHEN TRIGGERED, REQUEST APPEARANCE FOR SOURCE AND SEND IT BACK
AddEventHandler("Appearance:Server:RequestAppearance", function(cb, src)
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    if not charID then cb({}) return end

    local getAppearance = exports["soe-nexus"]:PerformAPIRequest("/api/character/getappearance", ("charid=%s"):format(charID), true)
    if not getAppearance or not getAppearance.status then
        cb({})
        return
    end
    cb(json.decode(getAppearance.data))
end)

-- WHEN TRIGGERED, DELETE OUTFIT FOR SOURCE AND SEND BACK A CONFIRMATION
AddEventHandler("Appearance:Server:DeleteOutfit", function(cb, src, outfitID)
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    if not charID then cb(false) return end

    local deletedOutfit = exports["soe-nexus"]:PerformAPIRequest("/api/character/deleteoutfit", ("charid=%s&outfitid=%s"):format(charID, outfitID), true)
    if not deletedOutfit or not deletedOutfit.status then
        cb(false)
        return
    end
    cb(true)
end)

-- WHEN TRIGGERED, SAVE OUTFIT FOR SOURCE AND SEND BACK A CONFIRMATION
AddEventHandler("Appearance:Server:SaveOutfit", function(cb, src, outfit, name)
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    if not charID then cb(false) return end

    local dataString = ("charid=%s&outfit=%s&name=%s"):format(charID, json.encode(outfit), name)
    local savedOutfit = exports["soe-nexus"]:PerformAPIRequest("/api/character/saveoutfit", dataString, true)
    if not savedOutfit or not savedOutfit.status then
        cb(false)
        return
    end
    cb(true)
end)

-- WHEN TRIGGERED, MODIFY A SENT OUTFIT AND SEND BACK A CONFIRMATION
AddEventHandler("Appearance:Server:ModifyOutfit", function(cb, src, outfitID, modification, data)
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    if not charID then cb(false) return end

    local dataString = ""
    if (modification == "name") then
        dataString = ("charid=%s&outfitid=%s&name=%s"):format(charID, outfitID, data)
    elseif (modification == "outfit") then
        dataString = ("charid=%s&outfitid=%s&outfit=%s"):format(charID, outfitID, json.encode(data))
    end

    local saveOutfit = exports["soe-nexus"]:PerformAPIRequest("/api/character/saveoutfit", dataString, true)
    if not saveOutfit or not saveOutfit.status then
        cb(false)
        return
    end
    cb(true)
end)

-- WHEN TRIGGERED, SAVE THE CHARACTER'S APPEARANCE
RegisterNetEvent("Appearance:Server:SaveAppearance")
AddEventHandler("Appearance:Server:SaveAppearance", function(charID, appearanceData)
    local src = source
    if not charID or not appearanceData then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Unable to save your appearance!", length = 5000})
        return
    end

    -- GET APPEARANCE FIRST
    local getAppearance = exports["soe-nexus"]:PerformAPIRequest("/api/character/getappearance", ("charid=%s"):format(charID), true)
    if getAppearance.status then
        local appearance = json.decode(getAppearance.data)
        local previousTattoos = appearance["tattoos"]
        appearance = appearanceData
        appearance["tattoos"] = previousTattoos
        exports["soe-nexus"]:PerformAPIRequest("/api/character/setappearance", ("charid=%s&appearance=%s"):format(charID, json.encode(appearance)), true)
    else
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Unable to save your appearance!", length = 5000})
        return
    end
    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "Appearance successfully saved!", length = 5000})
end)
