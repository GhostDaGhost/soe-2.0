local bac = {}

RegisterCommand("hold", function(source)
    local src = source
    TriggerClientEvent("Civ:Client:HoldOptions", src)
end)

RegisterCommand("drag", function(source)
    local src = source
    TriggerClientEvent("Civ:Client:DragOptions", src)
end)

RegisterCommand("escort", function(source)
    local src = source
    TriggerClientEvent("Civ:Client:EscortOptions", src)
end)

RegisterCommand("carry", function(source)
    local src = source
    TriggerClientEvent("Civ:Client:CarryOptions", src)
end)

RegisterCommand("piggyback", function(source)
    local src = source
    TriggerClientEvent("Civ:Client:PiggybackOptions", src)
end)

RegisterCommand("dob", function(source)
    local src = source
    local charDOB = exports["soe-uchuu"]:GetOnlinePlayerList()[src].DOB
    TriggerClientEvent("Chat:Client:Message", src, "[DOB]", charDOB, "standard")
end)

RegisterCommand("ssn", function(source)
    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    TriggerClientEvent("Chat:Client:Message", src, "[SSN]", charID, "standard")
end)

RegisterCommand("roll", function(source, args)
    local src = source
    if (args[1] == "" or args[1] == nil) then return end
    if (exports["soe-inventory"]:GetItemAmt(src, "dice", "left") < 1) then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You do not have a dice", length = 5000})
        return
    end

    local str = args[1]
    local amount, found, num = str:sub(0, 1), str:sub(2, 2), str:sub(3)
    if (found ~= "d") then return end
    if (num == nil) then return end

    local roll = {}
    math.random() math.random() math.random()
    for i = 1, tonumber(amount) do
        roll[#roll + 1] = math.random(num)
    end

    local ped = GetPlayerPed(src)
    TaskPlayAnim(ped, "mp_player_int_upperwank", "mp_player_int_wank_01", 1.0, 1.0, 1000, 49, 0, 0, 0, 0)
    Wait(1000)
    TaskPlayAnim(ped, "mp_player_int_upperwank", "mp_player_int_wank_01_exit", 8.0, 1.0, 230, 49, 0, 0, 0, 0)

    local calc = 0
    for _, v in pairs(roll) do
        calc = calc + v
    end

    local name = exports["soe-chat"]:GetDisplayName(src)
    exports["soe-utils"]:PlayProximitySound(src, 4.5, "dice.ogg", 0.54)
    exports["soe-chat"]:DoProximityMessage(src, 10.0, "me", "", name, ("has rolled a %s. %s/%s, Outcomes: %s"):format(str, calc, math.floor(num * tonumber(amount)), table.concat(roll, ", ")))
end)

RegisterNetEvent("Civ:Server:UpdateBAC")
AddEventHandler("Civ:Server:UpdateBAC", function(level)
    local src = source
    bac[src] = level
end)

RegisterNetEvent("Civ:Server:HoldPlayer")
AddEventHandler("Civ:Server:HoldPlayer", function(serverID, holding)
    local src = source
    TriggerClientEvent("Civ:Client:HoldPlayer", serverID, holding, src)

    -- LOG THIS ACTION
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[serverID] or {}
    local msg = ("TOGGLED /hold ON A PLAYER | SERVER ID: %s | NAME: %s (%s / %s)"):format(serverID or 0, char.Username or "Unknown", char.FirstGiven or "Unknown", char.LastGiven or "Unknown")
    exports["soe-logging"]:ServerLog("Holding Player", msg, src)
end)

RegisterNetEvent("Civ:Server:DragPlayer")
AddEventHandler("Civ:Server:DragPlayer", function(serverID, dragging)
    local src = source
    TriggerClientEvent("Civ:Client:DragPlayer", serverID, dragging, src)

    -- LOG THIS ACTION
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[serverID] or {}
    local msg = ("TOGGLED /drag ON A PLAYER | SERVER ID: %s | NAME: %s (%s / %s)"):format(serverID or 0, char.Username or "Unknown", char.FirstGiven or "Unknown", char.LastGiven or "Unknown")
    exports["soe-logging"]:ServerLog("Dragging Player", msg, src)
end)

RegisterNetEvent("Civ:Server:EscortPlayer")
AddEventHandler("Civ:Server:EscortPlayer", function(serverID, escorting)
    local src = source
    TriggerClientEvent("Civ:Client:EscortPlayer", serverID, escorting, src)

    -- LOG THIS ACTION
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[serverID] or {}
    local msg = ("TOGGLED /escort ON A PLAYER | SERVER ID: %s | NAME: %s (%s / %s)"):format(serverID or 0, char.Username or "Unknown", char.FirstGiven or "Unknown", char.LastGiven or "Unknown")
    exports["soe-logging"]:ServerLog("Escorting Player", msg, src)
end)

RegisterNetEvent("Civ:Server:CarryPlayer")
AddEventHandler("Civ:Server:CarryPlayer", function(serverID, carrying)
    local src = source
    TriggerClientEvent("Civ:Client:CarryPlayer", serverID, carrying, src)

    -- LOG THIS ACTION
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[serverID] or {}
    local msg = ("TOGGLED /carry ON A PLAYER | SERVER ID: %s | NAME: %s (%s / %s)"):format(serverID or 0, char.Username or "Unknown", char.FirstGiven or "Unknown", char.LastGiven or "Unknown")
    exports["soe-logging"]:ServerLog("Carrying Player", msg, src)
end)

RegisterNetEvent("Civ:Server:PiggybackPlayer")
AddEventHandler("Civ:Server:PiggybackPlayer", function(serverID, piggybacking)
    local src = source
    TriggerClientEvent("Civ:Client:PiggybackPlayer", serverID, piggybacking, src)

    -- LOG THIS ACTION
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[serverID] or {}
    local msg = ("TOGGLED /piggyback ON A PLAYER | SERVER ID: %s | NAME: %s (%s / %s)"):format(serverID or 0, char.Username or "Unknown", char.FirstGiven or "Unknown", char.LastGiven or "Unknown")
    exports["soe-logging"]:ServerLog("Piggybacking Player", msg, src)
end)

RegisterNetEvent("Civ:Server:KittyLitter", function()
    local src = source
    local pos = GetEntityCoords(GetPlayerPed(src))
    TriggerClientEvent("Civ:Client:KittyLitter", -1, pos)

    local name = exports["soe-chat"]:GetDisplayName(src)
    exports["soe-chat"]:DoProximityMessage(src, 10.0, "me", "", name, "spills some kitty litter around.")
    exports["soe-logging"]:ServerLog("Used Kitty Litter", "USED KITTY LITTER AT: " .. pos, src)
end)

RegisterNetEvent("Civ:Server:Breathalyze")
AddEventHandler("Civ:Server:Breathalyze", function(target)
    local src = source
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[target]

    -- DEFINE OUR BREATHALYZER RESULT
    local result
    if (bac[target] == nil) then
        result = 0.0
    else
        result = (bac[target] * 0.004)
    end

    -- RETURN THE RESULT TO SOURCE AND NOTIFY TARGET
    TriggerClientEvent("Chat:Client:Message", target, "[Breathalyzer]", "You were breathalyzed.", "standard")
    TriggerClientEvent("Chat:Client:Message", src, "[Breathalyzer]", ("%s %s | %s"):format(char.FirstGiven, char.LastGiven, result), "standard")

    -- LOG THIS ACTION
    local msg = ("USED A BREATHALYZER | SERVER ID: %s | TARGET: %s (%s / %s)"):format(target, char.Username, char.FirstGiven, char.LastGiven)
    exports["soe-logging"]:ServerLog("Used Breathalyzer", msg, src)
end)

-- WHEN TRIGGERED, CHECK FOR NEARBY PLAYERS AND TACKLE THEM
RegisterNetEvent("Civ:Server:TacklePlayers", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 5933-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data["status"] then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 5933-2 | Lua-Injecting Detected.", 0)
        return
    end

    local ped = GetPlayerPed(src)
    for playerID in pairs(exports["soe-uchuu"]:GetOnlinePlayerList()) do
        if (src ~= playerID) then
            local targetPed = GetPlayerPed(playerID)
            if #(GetEntityCoords(ped) - GetEntityCoords(targetPed)) <= 3.3 then
                SetPedToRagdoll(targetPed, 1000, 1000, 0, 1, 1, 0) -- RPC TEST | REPLACE WITH EVENT IF BROKEN!
                --TriggerClientEvent("Civ:Client:TacklePlayers", playerID, {status = true})
            end
        end
    end
end)

RegisterNetEvent("Civ:Server:OpenContainer")
AddEventHandler("Civ:Server:OpenContainer", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 995 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 994 | Lua-Injecting Detected.", 0)
        return
    end

    -- ENSURE PLAYER HAS A CONTAINER FIRST
    if (exports["soe-inventory"]:GetItemAmt(src, data.containerItem, "left") < 1) then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You don't seem to have this item!", length = 5000})
        return
    end

    local name = exports["soe-chat"]:GetDisplayName(src)
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID    

    -- ADDS THE ITEMS FROM CONTAINER TO PLAYER INVENTORY
    if exports["soe-inventory"]:AddItem(src, "char", charID, data.item, data.quantity, "{}") then
        exports["soe-logging"]:ServerLog("Open Container", ("OPENED %s IN QUANTITIES OF %s"):format(data.item, data.quantity), src)
    end

    -- TRIGGERED WHEN PLAYER FAILS THE MINI GAME
    if data.damagedQuantity > 0 then
        local damagedVariant = ("broken%s"):format(data.item)
        print("damagedVariant", damagedVariant)
        if exports["soe-inventory"]:AddItem(src, "char", charID, damagedVariant, data.damagedQuantity, "{}") then
            exports["soe-logging"]:ServerLog("Open Container", ("OPENED %s IN QUANTITIES OF %s"):format(damagedVariant, data.damagedQuantity), src)
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = ("%s %s(s) was damaged during the opening process!"):format(data.damagedQuantity, data.item), length = 5000})
        end
    end

    exports["soe-chat"]:DoProximityMessage(src, 10.0, "me", "", name, ("opens %s."):format(data.containerName))
    
    -- REMOVE CONTAINER FROM PLAYER INVENTORY
    exports["soe-inventory"]:RemoveItem(src, 1, data.containerItem)
end)
