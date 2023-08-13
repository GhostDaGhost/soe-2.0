RegisterNetEvent("Crime:Server:LootWarehouseCrate")
AddEventHandler("Crime:Server:LootWarehouseCrate", function()
    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "You unlocked this crate!", length = 5500})

    -- GENERATE LOOT
    math.randomseed(os.time())
    if (math.random(1, 100) <= 85) then
        local reward = warehouseLoot[math.random(1, #warehouseLoot)]
        if exports["soe-inventory"]:AddItem(src, "char", charID, reward.hash, reward.quantity, "{}") then
            exports["soe-logging"]:ServerLog("Warehouse Burglary Loot", ("GOT %s %s FROM A WAREHOUSE CRATE"):format(reward.quantity, reward.hash), src)
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = ("You found %sx %s!"):format(reward.quantity, reward.name), length = 5500})
        end
    else
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You found nothing interesting in this crate!", length = 5500})
    end
end)

RegisterNetEvent("Crime:Server:MarkWarehouseAsBeingRobbed")
AddEventHandler("Crime:Server:MarkWarehouseAsBeingRobbed", function(location, pos)
    local src = source
    -- GET CLOSEST WAREHOUSE DATA
    local myWarehouse, pos = false, GetEntityCoords(GetPlayerPed(src))
    for index, warehouse in pairs(warehouses) do
        if #(pos - warehouse.pos) <= 5.0 then
            myWarehouse = index
            break
        end
    end

    if myWarehouse then
        -- SET INSTANCE
        exports["soe-instance"]:SetPlayerInstance(warehouses[myWarehouse].name, src)

        -- LOG BURGLARY
        local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
        exports["soe-logging"]:ServerLog("Warehouse Burglary", "HAS BEGUN ROBBING WAREHOUSE " .. warehouses[myWarehouse].name, src)

        math.randomseed(os.time())
        if (math.random(0, 100) <= 85) then
            -- SEND CAD ALERT TO POLICE/DISPATCH
            for _, v in pairs(GetPlayers()) do
                local myJob = exports["soe-jobs"]:GetJob(tonumber(v))
                if (myJob == "POLICE" or myJob == "DISPATCH") then
                    TriggerClientEvent("Crime:Client:SendWarehouseRobberyAlert", tonumber(v), location, pos)
                end
            end

            -- NOTIFY SOURCE THAT THEY TRIPPED THE ALARM
            --TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "The warehouse alarm has been tripped!", length = 9500})
        end

        -- SET WAREHOUSE STATE AND MAKE COOLDOWN FOR 15 MINUTES
        warehouses[myWarehouse].raided = true
        TriggerClientEvent("Crime:Client:SetWarehouseState", -1, myWarehouse, true)
        SetTimeout(900000, function()
            warehouses[myWarehouse].raided = false
            TriggerClientEvent("Crime:Client:SetWarehouseState", -1, myWarehouse, false)
        end)
    end
end)
