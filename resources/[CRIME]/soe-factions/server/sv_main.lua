-- ***********************
--    Global Functions
-- ***********************
-- WHEN TRIGGERED, GET NAME OF A GANG THE PLAYER IS IN
function GetGangName(src)
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    if not charID then return false end

    local getFactions = exports["soe-nexus"]:PerformAPIRequest("/api/factions/get", ("charid=%s"):format(charID), true)
    if not getFactions.status then return false end

    -- GANG RULES STATE ONLY ONE GANG PER CHARACTER, THIS'LL DO FINE FOR NOW
    -- ITERATE THROUGH AND GET THE NAME OF THE CHARACTER'S GANG
    local name
    for _, faction in pairs(getFactions.data) do
        if (faction.FactionData.FactionSubtype == "gang") then
            name = tostring(faction.FactionData.FactionName)
            break
        end
    end
    return name
end

-- WHEN TRIGGERED, CHECK FACTION PERMISSIONS OF PLAYER
function CheckPermission(src, checkPerm)
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    if not charID then return false end

    local getFactions = exports["soe-nexus"]:PerformAPIRequest("/api/factions/get", ("charid=%s"):format(charID), true)
    if not getFactions.status then return false end

    for _, faction in pairs(getFactions.data) do
        -- IF PERSON HAS THE PERMISSION IN THEIR PERMISSION LIST
        if faction.MyData.Permissions then
            for _, permission in pairs(json.decode(faction.MyData.Permissions)) do
                if (permission == checkPerm) then
                    return true
                end
            end
        end

        -- IF PERSON IS AN OWNER OF THE RELEVANT FACTION SUBTYPE
        if (roles[faction.MyData.Role] <= 1) then
            for category, categoryPerms in pairs(perms) do
                for categoryPerm in pairs(categoryPerms) do
                    if (categoryPerm == checkPerm and category == faction.FactionData.FactionSubtype) then
                        return true
                    end
                end
            end
        end
    end

    -- NO PERMS
    return false
end

function GetMaxRate()
    return maxClockinRate
end

-- ***********************
--        Commands
-- ***********************
-- WHEN TRIGGERED, OPENS THE FACTION MENU
RegisterCommand("factions", function(src)
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID or 0
    local factions = exports["soe-nexus"]:PerformAPIRequest("/api/factions/get", ("charid=%s"):format(charID), true)

    if not factions or factions.status == false then
        factions = {}
    end
    TriggerClientEvent("Factions:Client:OpenMenu", src, factions.data)
end)

-- WHEN TRIGGERED, CLOCK THE PLAYER IN
RegisterCommand("clockin", function(src, args)
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID or 0
    local factions = exports["soe-nexus"]:PerformAPIRequest("/api/factions/get", ("charid=%s"):format(charID), true)

    if not factions or factions.status == false then
        factions = {}
    end
    TriggerClientEvent("Factions:Client:Clockin", src, factions.data, args)
end)

-- ***********************
--         Events
-- ***********************
AddEventHandler("Factions:Server:GetMyFactions", function(cb, src, charID)
    local factions = exports["soe-nexus"]:PerformAPIRequest("/api/factions/get", ("charid=%s"):format(charID), true)
    if factions and factions.status then
        cb(factions.data)
    else
        cb({})
    end
end)

AddEventHandler("Factions:Server:ModifyFactionRoster", function(cb, src, entryID, toChange, newValue)
    -- VALIDATE RATE SERVER SIDE TO ENSURE IT'S NOT ABOVE MAX
    if toChange == "Rate" and newValue > maxClockinRate then
        exports["soe-logging"]:ServerLog("Set Clockin Rate", ("Attempt to set rate (%s) > max rate (%s)"):format(newValue, maxClockinRate), src)
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 7283-1 | Lua-Injecting Detected.", 0)
        return
    end

    local dataString = ("entryid=%s&modify=%s&newvalue=%s"):format(entryID, toChange, newValue)
    local updateRoster = exports["soe-nexus"]:PerformAPIRequest("/api/factions/modifyroster", dataString, true)

    if updateRoster and updateRoster.status then
        cb(true)
    else
        cb(false)
    end
end)

AddEventHandler("Factions:Server:ModifyPerms", function(cb, src, entryID, perm, action)
    local dataString = ("entryid=%s&perm=%s&action=%s"):format(entryID, perm, action)
    local updatePerms = exports["soe-nexus"]:PerformAPIRequest("/api/factions/modifyperms", dataString, true)

    if updatePerms and updatePerms.status then
        cb(true)
    else
        cb(false)
    end
end)

AddEventHandler("Factions:Server:RemoveFactionRoster", function(cb, src, entryID)
    local deleteRoster = exports["soe-nexus"]:PerformAPIRequest("/api/factions/removeroster", ("entryid=%s"):format(entryID), true)
    if deleteRoster and deleteRoster.status then
        cb(true)
    else
        cb(false)
    end
end)

AddEventHandler("Factions:Server:AddFactionRoster", function(cb, src, charID, factionID)
    local dataString = ("factionid=%s&charid=%s"):format(factionID, charID)
    local addRoster = exports["soe-nexus"]:PerformAPIRequest("/api/factions/insertroster", dataString, true)

    if addRoster and addRoster.status then
        cb(true)
    else
        cb(false)
    end
end)
