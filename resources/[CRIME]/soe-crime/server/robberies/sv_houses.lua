local cooldown = {}

-- REQUESTED FROM CLIENT TO GIVE REWARDS
RegisterNetEvent("Crime:Server:DoHouseLootTasks")
AddEventHandler("Crime:Server:DoHouseLootTasks", function()
    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID

    -- RANDOMIZE LOOT
    math.randomseed(os.time())
    if (math.random(1, 100) <= 85) then
        local reward = houseLoot[math.random(1, #houseLoot)]
        if exports["soe-inventory"]:AddItem(src, "char", charID, reward.hash, reward.quantity, "{}") then
            exports["soe-logging"]:ServerLog("House Burglary Loot", ("HAS EARNED %s %s THROUGH A HOUSE ROBBERY"):format(reward.quantity, reward.hash), src)
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = ("You found %sx %s!"):format(reward.quantity, reward.name), length = 5500})
        end
    else
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You found nothing interesting!", length = 5500})
    end

    if not cooldown[src] then
        cooldown[src] = true
        -- AFTER 15 MINUTES, RESET SOURCE'S COOLDOWN
        SetTimeout(900000, function()
            cooldown[src] = false
            TriggerClientEvent("Crime:Client:ResetHomeCooldown", src)
        end)
    end
end)

-- SYNCING EVENT FOR HOME ALARMS
RegisterNetEvent("Crime:Server:StartHouseRobbery")
AddEventHandler("Crime:Server:StartHouseRobbery", function(location, pos, house)
    local src = source
    local securityAlarm = false
    math.randomseed(os.time())
    -- SEND CAD ALERT BASED OFF HOUSE CLASS
    if (house.data.class == "low") then
        if (math.random(1, 100) <= 50) then
            securityAlarm = true
        end
    elseif (house.data.class == "med") then
        if (math.random(1, 100) <= 75) then
            securityAlarm = true
        end
    elseif (house.data.class == "high") then
        if (math.random(1, 100) <= 90) then
            securityAlarm = true
        end
    end

    -- LOG BURGLARY
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    exports["soe-logging"]:ServerLog("House Burglary", "HAS STARTED ROBBING HOUSE" .. house.data.address, src)

    -- SET HOUSE STATE
    houses[house.index].invaded = true
    TriggerClientEvent("Crime:Client:SetHouseState", -1, house.index, true)
    if securityAlarm then
        -- NOTIFY SOURCE THAT THEY TRIPPED THE ALARM
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "The house security alarm has been tripped!", length = 9500})

        -- SEND CAD ALERT TO POLICE/DISPATCH
        for _, v in pairs(GetPlayers()) do
            local myJob = exports["soe-jobs"]:GetJob(tonumber(v))
            if (myJob == "POLICE" or myJob == "DISPATCH") then
                TriggerClientEvent("Crime:Client:SendHouseRobberyAlert", tonumber(v), location, pos, house.data.address)
            end
        end
    end

    -- AFTER 15 MINUTES, RESET HOUSE STATE
    SetTimeout(900000, function()
        houses[house.index].invaded = false
        TriggerClientEvent("Crime:Client:SetHouseState", -1, house.index, false)
    end)
end)
