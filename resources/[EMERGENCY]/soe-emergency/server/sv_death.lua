local death = {}
local isDead = {}

-- TASKS TO DO WHEN PLAYER RESPAWNS
local function RespawnTasks(src)
    local amount = 350
    if exports["soe-config"]:GetConfigValue("economy", "medevac") then
        amount = exports["soe-config"]:GetConfigValue("economy", "medevac")
    end

    if exports["soe-bank"]:IncreaseStateDebt(src, amount, "San Andreas Fire & Rescue", "Hospital Bills", true) then
        TriggerClientEvent("Chat:Client:SendMessage", src, "safr", ("You called the local MedEvac team and they have transported you to the nearest hospital. The transport and treatment added $%s to your state debt."):format(amount))
    end

    -- NOTIFY EMERGENCY SERVICES OF THE RESPAWN
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    TriggerEvent("Chat:Server:SendToJointES", "[SAFR]", ("%s %s was recovered by a local MedEvac team."):format(char.FirstGiven, char.LastGiven), "safr")

    -- LOG THE RESPAWN
    exports["soe-healthcare"]:LogThisRespawn(char)
    exports["soe-logging"]:ServerLog("Respawn", "HAS RESPAWNED AND IS NO LONGER DOWNED", src)
end

-- TRIGGERED BY "/respawn"
local function DoRespawn(src)
    -- CHECK IF EMS IS ON DUTY TO BLOCK IT IF NEEDED
    if (exports["soe-jobs"]:GetDutyCount("EMS") >= 1) then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "There are active medics on duty. Please call 911 or do /local911", length = 7500})
        return
    end

    local time = os.time()
    if (death[src] ~= nil and death[src] < time) then
        isDead[src] = false
        TriggerClientEvent("Emergency:Client:DoRespawn", src)
        RespawnTasks(src)
    else
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = ("You have %s seconds left before you can respawn"):format((death[src] - time)), length = 4500})
    end
end

-- RETURNS IF SOURCE IS DEAD
function IsDead(src)
    return isDead[src]
end

-- SETS DEATH STATUS
function SetDeathState(src, bool)
    isDead[src] = bool
end

RegisterCommand("respawn", function(source)
    local src = source
    if isDead[src] then
        DoRespawn(src)
    end
end)

RegisterCommand("ems", function(source, args)
    local src = source
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    if (char.CivType == "EMS") then
        local target = tonumber(args[1])
        if (target ~= nil) then
            TriggerClientEvent("Chat:Client:SendMessage", target, "safr", "A medical unit is enroute to you. Please be patient and do not take any local services.")
        end
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for SAFR.")
    end
end)

RegisterCommand("evac", function(source, args)
    local src = source
    local medic = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    if (medic.CivType == "EMS") then
        local target = tonumber(args[1])
        if not target then return end

        local char = exports["soe-uchuu"]:GetOnlinePlayerList()[target]
        TriggerClientEvent("Emergency:Client:DoRespawn", target)

        TriggerClientEvent("Chat:Client:SendMessage", target, "safr", "You've been rescued by the local MedEvac team and have been transported to the nearest hospital.")
        TriggerEvent("Chat:Server:SendToEMS", "[SAFR]", ("%s %s has requested a local MedEvac rescue team for %s %s."):format(medic.JobTitle, medic.LastGiven, char.FirstGiven, char.LastGiven), "safr")

        -- LOG THE EVAC
        exports["soe-logging"]:ServerLog("MedEvac", ("HAS MED-EVAC RESCUED %s (%s / %s) AND IS NO LONGER DOWNED"):format(char.Username, char.FirstGiven, char.LastGiven), src)
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for SAFR.")
    end
end)

-- CALLED FROM CLIENT TO REVIVE TARGET
RegisterNetEvent("Emergency:Server:RevivePlayer")
AddEventHandler("Emergency:Server:RevivePlayer", function(serverID, char)
    local src = source
    SetDeathState(serverID, false)
    TriggerClientEvent("Emergency:Client:RevivePlayer", serverID)

    -- PROXIMITY ACTION MESSAGE FOR REVIVING
    if (char ~= nil) then
        char = exports["soe-chat"]:GetDisplayName(src)
        local patient = exports["soe-chat"]:GetDisplayName(serverID)
        exports["soe-chat"]:DoProximityMessage(src, 10.0, "me", "", char, ("helps %s up to their feet."):format(patient))
    end
end)

RegisterNetEvent("BaseEvents:Server:OnPlayerDied")
AddEventHandler("BaseEvents:Server:OnPlayerDied", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 19283-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 19283-2 | Lua-Injecting Detected.", 0)
        return
    end

    -- MAKE A SERVER LOG
    local msg = "HAS DIED | COORDS: " .. GetEntityCoords(GetPlayerPed(src))
    exports["soe-logging"]:ServerLog("Death (Non-PVP)", msg, src)
end)

RegisterNetEvent("BaseEvents:Server:OnPlayerMurder")
AddEventHandler("BaseEvents:Server:OnPlayerMurder", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 19284-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 19284-2 | Lua-Injecting Detected.", 0)
        return
    end

    -- MAKE A SERVER LOG
    local pos = GetEntityCoords(GetPlayerPed(src))
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[tonumber(data.killerID)] or {}
    local murderWeapon = exports["soe-utils"]:GetWeaponNameFromHashKey(data.murderWeapon) or "WEAPON_UNDEFINED"

    local msg = ("HAS DIED BY ANOTHER PLAYER | COORDS: %s | KILLER: [%s] %s (%s / %s) | WEAPON: %s"):format(pos, data.killerID, char.Username, char.FirstGiven, char.LastGiven, murderWeapon)
    if data.killerInVeh then
        local model, seat = data.killerVehModel, data.killerVehSeat
        msg = ("HAS DIED BY ANOTHER PLAYER | COORDS: %s | KILLER: [%s] %s (%s / %s) | WEAPON: %s | KILLER VEHICLE MODEL: %s | KILLER SEAT: %s"):format(pos, data.killerID, char.Username, char.FirstGiven, char.LastGiven, murderWeapon, model, seat)
    end
    exports["soe-logging"]:ServerLog("Death (PVP)", msg, src)
end)

RegisterNetEvent("Emergency:Server:StartRespawnTimer")
AddEventHandler("Emergency:Server:StartRespawnTimer", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 655 | Lua-Injecting Detected.", 0)
        return
    end

    isDead[src] = true
    local time = os.time()
    if (exports["soe-jobs"]:GetDutyCount("POLICE") <= 0) then
        death[src] = time + 120
    else
        death[src] = time + 300
    end
end)

-- WHEN TRIGGERED, SEND A ALERT BASED OFF TYPE TO EMS
RegisterNetEvent("Emergency:Server:EMSAlerts")
AddEventHandler("Emergency:Server:EMSAlerts", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 5835-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 5835-2 | Lua-Injecting Detected.", 0)
        return
    end

    local time = os.date("%H:%M", os.time())
    if (data.type == "Local 911") then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Emergency services has been notified", length = 7500})
        for playerID in pairs(exports["soe-uchuu"]:GetOnlinePlayerList()) do
            local myJob = exports["soe-jobs"]:GetJob(playerID)
            if (myJob == "EMS" or myJob == "POLICE" or myJob == "DISPATCH") then
                TriggerClientEvent("Emergency:Client:EMSAlerts", playerID, {status = true, data = data, src = src, time = time})
            end
        end
    else
        if data.global then
            for playerID in pairs(exports["soe-uchuu"]:GetOnlinePlayerList()) do
                local myJob = exports["soe-jobs"]:GetJob(playerID)
                if (myJob == "EMS" or myJob == "DISPATCH") then
                    TriggerClientEvent("Emergency:Client:EMSAlerts", playerID, {status = true, data = data, time = time})
                end
            end
        else
            TriggerClientEvent("Emergency:Client:EMSAlerts", src, {status = true, data = data, time = time})
        end
    end
end)
