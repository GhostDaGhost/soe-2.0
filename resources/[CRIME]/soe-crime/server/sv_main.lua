-- BREACHES INTO A HOUSE OR WAREHOUSE
local function DoBreachingTasks(src)
    local pos = GetEntityCoords(GetPlayerPed(src))
    -- IF NEAR A WAREHOUSE
    for _, warehouse in pairs(warehouses) do
        if #(pos - warehouse.pos) <= 5.0 then
            TriggerClientEvent("Crime:Client:BreachWarehouse", src, warehouse)
            return
        end
    end

    -- IF NEAR A HOUSE
    for _, house in pairs(houses) do
        if #(pos - house.pos) <= 5.0 then
            TriggerClientEvent("Crime:Client:BreakIntoHouse", src, true)
            return
        end
    end
end

-- KILLS ANY BANK/JEWELRY ALARMS ACTIVE
local function KillSecurityAlarm(src, args)
    -- IF NO ARGUMENTS, RETURN A LIST
    if (args == nil) then
        TriggerClientEvent("Chat:Client:SendMessage", src, "center", "Security Alarms List")
        TriggerClientEvent("Chat:Client:SendMessage", src, "linebreak")

        TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[1]: ^rVangelico Jewelry Store", "blank")
        TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[2]: ^rPaleto Bank", "blank")
        TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[3]: ^rBollingbroke Prison", "blank")

        TriggerClientEvent("Chat:Client:SendMessage", src, "linebreak")
        TriggerClientEvent("Chat:Client:Message", src, "[Security]", "Do: /killalarm [Number]", "bank")
        return
    end

    if (args == "1") then
        -- KILL JEWELRY STORE ALARM
        TriggerClientEvent("Crime:Client:KillMasterAlarm", -1, "JEWEL_STORE_HEIST_ALARMS")
    elseif (args == "2") then
        -- KILL PALETO BANK ALARM
        TriggerClientEvent("Crime:Client:KillMasterAlarm", -1, "PALETO_BAY_SCORE_ALARM")
    elseif (args == "3") then
        -- KILL PRISON ALARM
        TriggerClientEvent("Prison:Client:JailBreakAlarm", -1, false)
    end
end

RegisterCommand("breach", function(source)
    local src = source
    local myJob = exports["soe-jobs"]:GetJob(src)
    if (myJob == "POLICE" or myJob == "EMS") then
        DoBreachingTasks(src)
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for Emergency Services.")
    end
end)

RegisterCommand("killalarm", function(source, args)
    local src = source
    local myJob = exports["soe-jobs"]:GetJob(src)
    if (myJob == "POLICE") then
        KillSecurityAlarm(src, args[1])
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for LEO.")
    end
end)

-- SYNCING EVENT FOR ROBBERY ALARMS
RegisterNetEvent("Crime:Server:SendRobberyAlert")
AddEventHandler("Crime:Server:SendRobberyAlert", function(location, pos, name)
    TriggerClientEvent("Crime:Client:SendRobberyAlert", -1, location, pos, name)
    for src in pairs(exports["soe-uchuu"]:GetOnlinePlayerList()) do
        if (exports["soe-jobs"]:GetJob(src) == "NEWS") then
            TriggerClientEvent("Jobs:Client:SendNewsReport", src, location, pos, name)
        end
    end
end)

-- HANDLES INVENTORY ITEM REWARDS
RegisterNetEvent("Crime:Server:HandleRewards", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 98531-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 98531-2 | Lua-Injecting Detected.", 0)
        return
    end

    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    exports["soe-inventory"]:AddItem(src, "char", charID, data.name, data.amt, "{}")
end)
