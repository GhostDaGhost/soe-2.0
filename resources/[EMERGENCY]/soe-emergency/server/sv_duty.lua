local blips, trackers = {}, {}

-- ***********************
--    Global Functions
-- ***********************
-- WHEN TRIGGERED, REFRESH EMERGENCY SERVICE BLIPS
function RefreshEmergencyBlips()
    for trackerIdx, tracker in pairs(trackers) do
        if DoesEntityExist(tracker.veh) and (GetEntityModel(tracker.veh) == tracker.model) then
            local pos, hdg = GetEntityCoords(tracker.veh), GetEntityHeading(tracker.veh)
            blips[tracker.plate] = {delete = false, name = tracker.name, color = tracker.color, sprite = tracker.sprite, pos = pos, hdg = math.ceil(hdg)}
        else
            blips[tracker.plate] = {delete = true}
            table.remove(trackers, trackerIdx)
        end
    end

    for src in pairs(exports["soe-uchuu"]:GetOnlinePlayerList()) do
        local myJob = exports["soe-jobs"]:GetJob(src)
        if (myJob == "POLICE" or myJob == "EMS" or myJob == "DISPATCH" or myJob == "CRIMELAB") then
            TriggerClientEvent("Emergency:Client:SyncESBlips", src, blips)
        end
    end
end

-- ***********************
--        Commands
-- ***********************
-- OPENS THE DUTY MENU
RegisterCommand("duty", function(source)
    local src = source
    local civType = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CivType
    if (civType == "POLICE" or civType == "EMS" or civType == "DISPATCH" or civType == "DOJ" or civType == "GOV" or civType == "CRIMELAB") then
        TriggerClientEvent("Emergency:Client:DutyMenu", src)
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for Emergency Services.")
    end
end)

-- OPENS THE SV MENU
RegisterCommand("sv", function(source)
    local src = source
    local myJob = exports["soe-jobs"]:GetJob(src)
    if (myJob == "POLICE" or myJob == "EMS" or myJob == "CRIMELAB") then
        TriggerClientEvent("Emergency:Client:SVMenu", src)
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for Emergency Services.")
    end
end)

-- ***********************
--         Events
-- ***********************
-- CALLED FROM CLIENT TO REQUEST THEIR SV PRESETS
AddEventHandler("Emergency:Server:RequestSVPresets", function(cb, src, hash)
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    local getPresets = exports["soe-nexus"]:PerformAPIRequest("/api/sv/getpresets", ("charid=%s&vehhash=%s"):format(charID, hash), true)

    if not getPresets or not getPresets.status then
        cb({})
        return
    end
    cb(getPresets.data)
end)

-- CALLED FROM CLIENT TO DELETE SV PRESET
RegisterNetEvent("Emergency:Server:DeleteSVPreset", function(presetID)
    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    local deletePreset = exports["soe-nexus"]:PerformAPIRequest("/api/sv/deletepreset", ("charid=%s&presetid=%s"):format(charID, presetID), true)

    if not deletePreset or not deletePreset.status then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Unable to delete your preset!", length = 5000})
        return
    end
    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "Preset deleted!", length = 5000})
end)

-- CALLED FROM CLIENT TO SAVE SV PRESET
RegisterNetEvent("Emergency:Server:SaveSVPreset", function(hash, name, mods)
    local src = source
    if not hash or not name or not mods then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Unable to set your new preset!", length = 5000})
        return
    end

    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    local dataString = ("charid=%s&vehhash=%s&presetname=%s&mods=%s"):format(charID, hash, name, mods)
    local savePreset = exports["soe-nexus"]:PerformAPIRequest("/api/sv/savepreset", dataString, true)
    if not savePreset or not savePreset.status then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Unable to set your new preset!", length = 5000})
        return
    end
    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "New preset saved!", length = 5000})
end)

-- CALLED FROM CLIENT TO RENAME/OVERWRITE SV PRESET
RegisterNetEvent("Emergency:Server:UpdateSVPreset", function(presetID, data, modification)
    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID

    local dataString
    if (modification == "Rename") then
        dataString = ("charid=%s&presetid=%s&presetname=%s"):format(charID, presetID, data)
    elseif (modification == "Overwrite") then
        dataString = ("charid=%s&presetid=%s&mods=%s"):format(charID, presetID, data)
    end

    local updatePreset = exports["soe-nexus"]:PerformAPIRequest("/api/sv/updatepreset", dataString, true)
    if not updatePreset or not updatePreset.status then
        local error
        if (modification == "Rename") then
            error = "Unable to rename your preset"
        elseif (modification == "Overwrite") then
            error = "Unable to override your preset"
        end
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = error, length = 5000})
        return
    end

    local notif
    if (modification == "Rename") then
        notif = "Preset renamed to: " .. data
    elseif (modification == "Overwrite") then
        notif = "Preset overwritten!"
    end
    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = notif, length = 5000})
end)

-- WHEN TRIGGERED, ADD A NEW BLIP TO THE TRACKER LIST
AddEventHandler("Emergency:Server:SyncESBlips", function(cb, src, veh, class)
    cb(true)
    -- WAIT UNTIL ENTITY EXISTS
    while not DoesEntityExist(NetworkGetEntityFromNetworkId(veh)) do
        Wait(100)
    end

    -- SET NAME BELONGING TO VEHICLE
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    local type = char.Employer
    local name = ("~c~%s ~s~| %s. %s"):format(type, (char.FirstGiven):sub(0, 1), char.LastGiven)

    local color = 1
    if (type == "LSPD") then
        color = 3
    elseif (type == "BCSO") then
        color = 56
    elseif (type == "SASP") then
        color = 38
    elseif (type == "SAES") then
        color = 30
    elseif (type == "SACL") then
        color = 44
    end

    local entity = NetworkGetEntityFromNetworkId(veh)
    local model = GetEntityModel(entity)

    local sprite = 1
    if (class == 15) then
        sprite = 422
        name = name .. " | AIR"
    elseif (class == 14) then
        sprite = 427
        name = name .. " | BOAT"
    elseif (GetHashKey("pbus") == model) then
        sprite = 513
        name = name .. " | BUS"
    end

    -- GET ENTITY AND MODEL
    local plate = GetVehicleNumberPlateText(entity)
    trackers[#trackers + 1] = {color = color, sprite = sprite, plate = tostring(plate), veh = entity, type = type, name = name, model = model}
end)
