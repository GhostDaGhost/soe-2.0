local restrained, resistance = {}, {}
local releaseTools = {
    ["Zip-Tie"] = {"scissors", "WEAPON_KNIFE", "WEAPON_SWITCHBLADE", "WEAPON_DAGGER"},
    ["Cuff"] = {"cuffkey"}
}

-- ***********************
--     Global Functions
-- ***********************
-- WHEN TRIGGERED, RETURN IF SOURCE IS COMPLETELY RESTRAINED EITHER BY CUFFS OR ZIP-TIES
function IsRestrained(src)
    if restrained[src] then
        return true
    end
    return false
end

-- WHEN TRIGGERED, RETURN IF SOURCE IS HANDCUFFED
function IsHandcuffed(src)
    if restrained[src] and (restrained[src].type == "Cuff") then
        return true
    end
    return false
end

-- WHEN TRIGGERED, RETURN IF SOURCE IS ZIP-TIED
function IsZipTied(src)
    if restrained[src] and (restrained[src].type == "Zip-Tie") then
        return true
    end
    return false
end

-- ***********************
--        Commands
-- ***********************
-- WHEN TRIGGERED, TELL SOURCE TO CUFF THE NEAREST PLAYER
RegisterCommand("cuff", function(source, args)
    local src = source
    if restrained[src] then return end

    if (args[1] ~= nil) then
        TriggerClientEvent("Emergency:Client:RestrainPlayer", src, "Cuff", true)
    else
        TriggerClientEvent("Emergency:Client:RestrainPlayer", src, "Cuff", false)
    end
end)

-- WHEN TRIGGERED, TELL SOURCE TO ZIP-TIE THE NEAREST PLAYER
RegisterCommand("ziptie", function(source, args)
    local src = source
    if restrained[src] then return end

    if (args[1] ~= nil) then
        TriggerClientEvent("Emergency:Client:RestrainPlayer", src, "Zip-Tie", true)
    else
        TriggerClientEvent("Emergency:Client:RestrainPlayer", src, "Zip-Tie", false)
    end
end)

-- ***********************
--        Events
-- ***********************
-- WHEN TRIGGERED, GIVE PLAYER AN OPPORTUNITY TO RESIST RESTRAINT
RegisterNetEvent("Emergency:Server:RestraintResistance", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 14822-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 14822-2 | Lua-Injecting Detected.", 0)
        return
    end

    if resistance[src] then
        resistance[src].success = data.success
        resistance[src].active = false
    end
end)

-- WHEN TRIGGERED, RESTRAIN INDIVIDUAL AS THEY LOG IN IF THEY WERE RESTRAINED BEFORE
RegisterNetEvent("Emergency:Server:RestraintGamestate", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 14823-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 14823-2 | Lua-Injecting Detected.", 0)
        return
    end

    Wait(3500)
    if restrained[src] then return end
    restrained[src] = {type = data.type, soft = false}

    -- CONSTRUCT MESSAGE
    local msg = "cuffed"
    if (data.type == "Zip-Tie") then
        msg = "zip-tied"
    end
    TriggerClientEvent("Emergency:Client:GetRestrained", src, nil, data.type, false, false)
    TriggerClientEvent("Chat:Client:SendMessage", src, "system", ("You were %s before disconnecting, so you are %s now."):format(msg, msg))
end)

-- WHEN TRIGGERED, PERFORM INITIAL RESTRAINT TASKS
AddEventHandler("Emergency:Server:RestrainPlayer", function(cb, src, serverID, type, soft)
    if restrained[serverID] then
        -- IF THE COMMANDS ENTERED ARE MIXED, THIS BUGS OUT... THIS FAILSAFES
        if (restrained[serverID].type ~= type) then
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Make sure to enter the right command!", length = 5000})
            return
        end

        -- CHECK IF PLAYER HAS A RELEASE TOOL IN THEIR INVENTORY
        local hasReleaseTool
        for _, tool in pairs(releaseTools[restrained[serverID].type]) do
            if (exports["soe-inventory"]:GetItemAmt(src, tool, "left") >= 1) then
                hasReleaseTool = true
                break
            end
        end

        -- PERFORM RESTRAINT/RELEASE TASKS
        if hasReleaseTool then
            cb({status = true, releasing = true})
            TriggerClientEvent("Chat:Client:SendMessage", serverID, "me", "You are being released.")
            TriggerClientEvent("Emergency:Client:GetRestrained", serverID, src, type, soft, true)

            -- GIVE HANDCUFFS BACK IF PERSON WAS CUFFED
            if (restrained[serverID].type == "Cuff") then
                local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
                exports["soe-inventory"]:AddItem(src, "char", charID, "handcuffs", 1, "{}")
            end

            local char = exports["soe-uchuu"]:GetOnlinePlayerList()[serverID]
            local msg = ("HAS UN-RESTRAINED A PLAYER | TYPE: %s | TARGET: %s (%s / %s)"):format(restrained[serverID].type, char.Username, char.FirstGiven, char.LastGiven)
            exports["soe-logging"]:ServerLog("Unrestrained Player", msg, src)
            restrained[serverID] = nil
        else
            cb({status = false})

            -- CONTRUCT CHAT MESSAGE TO NOTIFY PLAYER
            local msg = "You need a handcuff key to release this individual."
            if (restrained[serverID].type == "Zip-Tie") then
                msg = "You need either scissors or a knife to release this zip-tied individual."
            end
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = msg, length = 5000})
        end
    else
        local hasItem, item = false, "handcuffs"
        if (type == "Cuff") then
            hasItem = (exports["soe-inventory"]:GetItemAmt(src, "handcuffs", "left") >= 1)
        elseif (type == "Zip-Tie") then
            hasItem, item = (exports["soe-inventory"]:GetItemAmt(src, "zipties", "left") >= 1), "zipties"
        end

        if hasItem then
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "You attempt to restrain the target", length = 1000})

            resistance[serverID] = {active = true, success = false}
            TriggerClientEvent("Emergency:Client:RestraintResistance", serverID, soft)
            while resistance[serverID].active do
                Wait(3)
            end

            if not resistance[serverID].success then
                restrained[serverID] = {type = type, soft = soft}
                exports["soe-inventory"]:RemoveItem(src, 1, item)
        
                -- CONTRUCT CHAT MESSAGE TO NOTIFY PLAYER
                local msg = "You are being handcuffed."
                if (type == "Zip-Tie") then
                    msg = "You are being zip-tied."
                end
        
                cb({status = true, releasing = false})
                TriggerClientEvent("Chat:Client:SendMessage", serverID, "me", msg)
                TriggerClientEvent("Emergency:Client:GetRestrained", serverID, src, type, soft, false)

                local char = exports["soe-uchuu"]:GetOnlinePlayerList()[serverID]
                local msg = ("HAS RESTRAINED A PLAYER | TYPE: %s | SOFT?: %s | TARGET: %s (%s / %s)"):format(type, soft, char.Username, char.FirstGiven, char.LastGiven)
                exports["soe-logging"]:ServerLog("Restrained Player", msg, src)
            else
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Target resisted restraint!", length = 5000})
                TriggerClientEvent("Notify:Client:SendAlert", serverID, {type = "inform", text = "Restraint resisted!", length = 3000})
            end
            resistance[src] = nil
        else
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You do not have " .. item, length = 5000})
            cb({status = false, releasing = false})
        end
    end
end)
