-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, GATHER A PLAYER LIST OF CURRENT PLAYERS ACTIVE
local function GetCurrentPlayers(includeID)
    local playerList = {}
    for id, data in pairs(exports["soe-uchuu"]:GetOnlinePlayerList()) do
        local username = "(NOT YET LOGGED IN)"
        if data and data.Username then
            username = data.Username
        end

        if includeID then
            username = "[" .. id .. "] " .. username
        end
        playerList[#playerList + 1] = {name = tostring(username), id = tonumber(id)}
    end
    return playerList or {}
end

-- TRIGGERED WHEN JUST "/dev" IS EXECUTED // MAKE SURE TO ALWAYS UPDATE THIS WHEN ADDING A NEW DEV TOOL!! GHOST WILL KILL YOU IF YOU DON'T!
local function DevCommandsUsageMsg(src)
    TriggerClientEvent("Chat:Client:SendMessage", src, "center", "Dev Commands")
    TriggerClientEvent("Chat:Client:SendMessage", src, "linebreak")

    TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[1]: ^r/dev veh (model) | Spawns the requested vehicle model.", "blank")
    TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[2]: ^r/dev debug | Toggles a debug tool for object coordinates/rotations etc.", "blank")
    TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[3]: ^r/dev radar | Toggles the minimap.", "blank")
    TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[4]: ^r/dev race | Starts a 15 second drag race to test vehicle speed.", "blank")
    TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[5]: ^r/dev noclip | Toggles noclip to allow flight and clipping through objects.", "blank")
    TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[6]: ^r/dev playanim (dict) (anim) (flag) | Plays a requested animation.", "blank")
    TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[7]: ^r/dev ec | Cancels any playing animation that the ped is performing.", "blank")
    TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[8]: ^r/dev skin (model) | Changes your ped to the requested model.", "blank")
    TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[9]: ^r/dev clearpeds | Clears peds in a radius.", "blank")
    TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[10]: ^r/dev giveitem (item) (amount) | Gives you the requested inventory item.", "blank")
    TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[11]: ^r/dev stopfire | Stops any active fire.", "blank")
    TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[12]: ^r/dev trash | Opens a trash inventory to discard items.", "blank")
    TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[13]: ^r/dev vin (VIN number) | Spawns a player-owned vehicle with the VIN attached to it.", "blank")
    TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[14]: ^r/dev parkvin (VIN number) | Parks a player-owned vehicle matching the VIN to its previous garage.", "blank")

    TriggerClientEvent("Chat:Client:SendMessage", src, "linebreak")
end

-- TRIGGERED WHEN JUST "/mod" IS EXECUTED // MAKE SURE TO ALWAYS UPDATE THIS WHEN ADDING A NEW MOD TOOL!! GHOST WILL KILL YOU IF YOU DON'T!
local function ModCommandsUsageMsg(src)
    TriggerClientEvent("Chat:Client:SendMessage", src, "center", "Moderation Commands")
    TriggerClientEvent("Chat:Client:SendMessage", src, "linebreak")

    TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[1]: ^r/mod ban (player ID) (duration) (reason) | Bans the requested player.", "blank")
    TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[2]: ^r/mod kick (player ID) (reason) | Kicks the requested player.", "blank")
    TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[3]: ^r/mod heal (player ID) | Fully heals the requested player and stops bleeding/injuries.", "blank")
    TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[4]: ^r/mod meta | Toggles a tool to see player blips and IDs.", "blank")
    TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[5]: ^r/mod tp (player ID) | Teleports you to the requested player.", "blank")
    TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[6]: ^r/mod summon (player ID) | Teleports the requested player to you.", "blank")
    TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[7]: ^r/mod fix | Fully fixes the vehicle you are in.", "blank")
    TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[8]: ^r/mod info (player ID) | Requests information of the targeted player.", "blank")
    TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[9]: ^r/mod revive (player ID) | Revives the targeted player.", "blank")
    TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[10]: ^r/mod freeze (player ID) | Freezes the targeted player.", "blank")
    TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[11]: ^r/mod spectate (player ID) | Spectates the targeted player.", "blank")
    TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[12]: ^r/mod invis | Toggles invisibility.", "blank")
    TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[13]: ^r/mod fuel (amount) | Fuels the vehicle you are in with the requested amount.", "blank")
    TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[14]: ^r/mod clearchat | Clears chat of all players.", "blank")
    TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[15]: ^r/mod nourish (player ID) | Fills Hunger/Thirst of requested player.", "blank")
    TriggerClientEvent("Chat:Client:Message", src, "", "^0^*[16]: ^r/mod menu | Opens staff menu.", "blank")

    TriggerClientEvent("Chat:Client:SendMessage", src, "linebreak")
end

-- **********************
--       Commands
-- **********************
RegisterCommand("warpwp", function(source)
    local src = source
    if exports["soe-uchuu"]:IsStaff(src) then
        TriggerClientEvent("Fidelis:Client:WarpWP", src)
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "You try this command but realize you don't have staff access.")
    end
end)

RegisterCommand("warppoi", function(source, args)
    local src = source
    if exports["soe-uchuu"]:IsStaff(src) then
        -- REMOVE COMMAS IF A LAZY SET OF COORDINATES WAS INPUTTED
        if args[1]:match(",") then args[1] = string.gsub(args[1], ",", "") end
        if args[2]:match(",") then args[2] = string.gsub(args[2], ",", "") end
        if args[3]:match(",") then args[3] = string.gsub(args[3], ",", "") end

        local x, y, z = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
        TriggerClientEvent("Fidelis:Client:WarpPOI", src, x, y, z)
        exports["soe-logging"]:ServerLog("Staff Tool", ("HAS TELEPORTED TO COORDS | COORDS: %s %s %s"):format(x, y, z), src)
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "You try this command but realize you don't have staff access.")
    end
end)

RegisterCommand("say", function(source, args, rawCommand)
    local src = source
    local allowed = false
    if (src == 0) then
        allowed = "Console"
    else
        if exports["soe-uchuu"]:IsStaff(src) then
            if exports["soe-uchuu"]:GetOnlinePlayerList()[src].Username then
                allowed = exports["soe-uchuu"]:GetOnlinePlayerList()[src].Username
            else
                allowed = "Staff"
            end
        end
    end

    if allowed then
        TriggerClientEvent("Chat:Client:Message", -1, ("[%s]"):format(allowed), rawCommand:sub(5), "system")
    end
end)

RegisterCommand("dev", function(source, args)
    local src = source
    if not exports["soe-uchuu"]:IsStaff(src) then
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "You try this command but realize you don't have staff access.")
        return
    end

    -- IF CONFUSED, SEND USAGE MESSAGE
    if (args[1] == nil) then
        DevCommandsUsageMsg(src)
    end

    -- SPAWNING VEHICLES
    local username = exports["soe-uchuu"]:GetOnlinePlayerList()[src].Username
    if (args[1] == "veh") then
        TriggerClientEvent("Fidelis:Client:DevTools", src, {type = "SpawnVeh", veh = args[2], ped = src, pos = GetEntityCoords(GetPlayerPed(src)), hdg = GetEntityHeading(GetPlayerPed(src))})

        exports["soe-logging"]:ServerLog("Dev Tool", ("HAS SPAWNED A VEHICLE | COORDS: %s | HASH: %s"):format(GetEntityCoords(GetPlayerPed(src)), args[2]), src)
    -- TOGGLE DEBUG TOOL
    elseif (args[1] == "debug") then
        TriggerClientEvent("Fidelis:Client:DevTools", src, {type = "ToggleDebug"})
        exports["soe-logging"]:ServerLog("Dev Tool", "HAS TOGGLED DEBUG", src)
    -- TOGGLE MINIMAP
    elseif (args[1] == "radar") then
        TriggerClientEvent("Fidelis:Client:DevTools", src, {type = "ToggleMinimap"})
        exports["soe-logging"]:ServerLog("Dev Tool", "HAS TOGGLED MINIMAP", src)
    -- PERFORM DRAG RACE TO TEST VEHICLE SPEED
    elseif (args[1] == "race") then
        TriggerClientEvent("Fidelis:Client:DevTools", src, {type = "DragRace"})
        exports["soe-logging"]:ServerLog("Dev Tool", "HAS STARTED A TEST DRAG RACE", src)
    -- TOGGLE NOCLIP
    elseif (args[1] == "noclip") then
        TriggerClientEvent("Fidelis:Client:DevTools", src, {type = "Noclip"})
        exports["soe-logging"]:ServerLog("Dev Tool", "HAS TOGGLED NOCLIP", src)
    -- ENTER DICTIONARY AND NAME TO TEST AN ANIMATION
    elseif (args[1] == "playanim") then
        TriggerClientEvent("Fidelis:Client:DevTools", src, {type = "PlayAnimation", dict = args[2], anim = args[3], flag = tonumber(args[4])})
    -- IMMEDIATELY CANCEL ANY ANIMATION
    elseif (args[1] == "ec") then
        TriggerClientEvent("Fidelis:Client:DevTools", src, {type = "CancelAnimation"})
        exports["soe-logging"]:ServerLog("Dev Tool", "HAS CANCELED THEIR ANIMATION", src)
    -- CHANGES YOUR SKIN
    elseif (args[1] == "skin") then
        TriggerClientEvent("Fidelis:Client:DevTools", src, {type = "ChangeSkin", ped = args[2]})
        exports["soe-logging"]:ServerLog("Dev Tool", "HAS CHANGED THEIR PED | HASH: " .. args[2], src)
    -- CLEARS PEDS IN A RADIUS
    elseif (args[1] == "clearpeds") then
        TriggerClientEvent("Fidelis:Client:DevTools", src, {type = "ClearPeds"})
        exports["soe-logging"]:ServerLog("Dev Tool", "HAS CLEARED PEDS IN A RADIUS", src)
    -- SPAWNS SPECIFIED PED AT YOUR LOCATION
    elseif (args[1] == "spawn") then
        TriggerClientEvent("Fidelis:Client:DevTools", src, {type = "SpawnPed", ped = args[2]})
        exports["soe-logging"]:ServerLog("Dev Tool", "HAS SPAWNED A PED | HASH: " .. args[2], src)
    -- GIVES YOU A SPECIFIED INVENTORY ITEM
    elseif (args[1] == "giveitem") then
        local item = tostring(args[2])
        local amount = tonumber(args[3]) or 1
        local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
        if exports["soe-inventory"]:AddItem(src, "char", charID, item, amount, "{}") then
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = ("You gave yourself %sx %s"):format(amount, item), length = 5000})
            exports["soe-logging"]:ServerLog("Dev Tool", ("HAS GIVEN THEMSELVES AN INVENTORY ITEM | ITEM: %s | AMOUNT: %s"):format(item, amount), src)
        end
    -- STOPS ANY ACTIVE FIRE AS EMERGENCY
    elseif (args[1] == "stopfire") then
        exports["soe-emergency"]:ExtinguishFire()
        exports["soe-logging"]:ServerLog("Dev Tool", "HAS STOPPED A FIRE", src)
    -- OPENS A TRASH INVENTORY FOR DISCARDING ITEMS
    elseif (args[1] == "trash") then
        TriggerClientEvent("Inventory:Client:ShowInventory", src, "trash", false, 1)
    -- SPAWNS A VEHICLE BY ITS VIN NUMBER
    elseif (args[1] == "vin") then
        local pos = GetEntityCoords(GetPlayerPed(src))
        local hdg = GetEntityHeading(GetPlayerPed(src))

        local vehData = exports["soe-nexus"]:PerformAPIRequest("/api/valet/getvehbyvin", "vin=" .. args[2], true)
        if vehData.status then
            TriggerClientEvent("Fidelis:Client:DevTools", src, {type = "Spawn Vehicle By VIN", vehData = vehData.data, pos = pos, hdg = hdg})
            exports["soe-logging"]:ServerLog("Dev Tool", ("HAS SPAWNED A VEHICLE BY VIN | COORDS: %s | VIN: %s"):format(pos, args[2]), src)
        else
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Invalid VIN", length = 5000})
        end
    elseif (args[1] == "parkvin") then
        local vin = tonumber(args[2])
        local parkVehicle = exports["soe-nexus"]:PerformAPIRequest("/api/valet/parkvehicle", ("vin=%s&parked=%s"):format(vin, 0), true)
        if parkVehicle.status then
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "Parked VIN: " .. vin, length = 5000})
            exports["soe-logging"]:ServerLog("VIN Reparked", "HAS REPARKED VIN #" .. vin, src)
        else
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Could not park VIN: " .. vin, length = 5000})
            exports["soe-logging"]:ServerLog("VIN Reparked - Failed", "HAS FAILED TO REPARK VIN #" .. vin, src)
        end
    end
end)

RegisterCommand("mod", function(source, args, rawCommand)
    local src = source
    local isStaff = exports["soe-uchuu"]:IsStaff(src)
    if not isStaff and (src ~= 0) then
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "You try this command but realize you don't have staff access.")
        return
    end

    -- IF CONFUSED, SEND USAGE MESSAGE
    if (args[1] == nil) then
        ModCommandsUsageMsg(src)
    end

    local username = exports["soe-uchuu"]:GetOnlinePlayerList()[src].Username
    -- BANS SPECIFIED PLAYER WITH A REASON
    if (args[1] == "ban") then
        local target = tonumber(args[2])
        if (target ~= nil) then
            -- GET PLAYER WHO BANNED THIS ID
            local bannedBy
            if (src == 0) then
                bannedBy = "Server Console"
            else
                if username then
                    bannedBy = username
                else
                    bannedBy = "Staff"
                end
            end

            local banLength = 0
            local banReason = ""
            if #string.gsub(args[3], "[0-9]+[smhdwMy]", "") == 0 then
                banLength = GetBanLength(args[3])
                banReason = rawCommand:sub(string.len("/mod " .. args[1] .. " " .. args[2] .. " " .. args[3] .. " "))
            else
                banReason = rawCommand:sub(string.len("/mod " .. args[1] .. " " .. args[2] .. " "))
            end

            -- GET THE BAN REASON
            local targetUsername = exports["soe-uchuu"]:GetOnlinePlayerList()[target].Username
            if not targetUsername then
                targetUsername = GetPlayerName(target)
            end
            TriggerEvent("Fidelis:Server:HandleBan", target, bannedBy, banReason, banLength)
            exports["soe-logging"]:ServerLog("Staff Tool", ("HAS BANNED A PLAYER | TARGET: %s | REASON: %s"):format(targetUsername, banReason), src)
        end
    -- KICKS SPECIFIED PLAYER WITH A REASON
    elseif (args[1] == "kick") then
        local target = tonumber(args[2])
        if (target ~= nil) then
            local reason = rawCommand:sub(string.len("/mod " .. args[1] .. " " .. args[2] .. " "))
            local targetUsername = exports["soe-uchuu"]:GetOnlinePlayerList()[target].Username
            if not targetUsername then
                targetUsername = GetPlayerName(target)
            end

            exports["soe-logging"]:ServerLog("Staff Tool", ("HAS KICKED A PLAYER | TARGET: %s | REASON: %s"):format(targetUsername, reason), src)
            DropPlayer(target, ("\nYou have been kicked from the SoE servers!\nKicked By: %s\nKick Reason: %s"):format(username or "Server Console", reason or "None Given."))
        end
    -- HEALS YOURSELF
    elseif (args[1] == "heal") then
        local target = tonumber(args[2])
        if (target ~= nil) then
            TriggerClientEvent("Fidelis:Client:StaffTools", target, {type = "Heal"})
            if (target ~= -1) then
                local targetUsername = exports["soe-uchuu"]:GetOnlinePlayerList()[target].Username
                if not targetUsername then
                    targetUsername = GetPlayerName(target)
                end
                exports["soe-logging"]:ServerLog("Staff Tool", "HAS HEALED A PLAYER | TARGET: " .. targetUsername, src)
            else
                exports["soe-logging"]:ServerLog("Staff Tool", "HAS HEALED ALL PLAYERS IN SESSION", src)
            end
        end
    -- TOGGLE PLAYER BLIPS AND SHOW IDs
    elseif (args[1] == "meta") then
        TriggerClientEvent("Fidelis:Client:StaffTools", src, {type = "ToggleMeta"})
        exports["soe-logging"]:ServerLog("Staff Tool", "HAS TOGGLED THE META TOOL", src)
    -- TELEPORTS TO SPECIFIED PLAYER
    elseif (args[1] == "tp") then
        local target = tonumber(args[2])
        if (target ~= nil) then
            if not DoesEntityExist(GetPlayerPed(target)) then
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Could not teleport to this player", length = 5000})
                return
            end
            TriggerClientEvent("Fidelis:Client:StaffTools", src, {type = "TeleportToPlayer", ped = src, pos = GetEntityCoords(GetPlayerPed(target))})

            local targetUsername = exports["soe-uchuu"]:GetOnlinePlayerList()[target].Username
            if not targetUsername then
                targetUsername = GetPlayerName(target)
            end
            exports["soe-logging"]:ServerLog("Staff Tool", "HAS TELEPORTED TO A PLAYER | TARGET: " .. targetUsername, src)
        end
    -- TELEPORTS SPECIFIED PLAYER TO YOU
    elseif (args[1] == "summon") then
        local target = tonumber(args[2])
        if (target ~= nil) then
            TriggerClientEvent("Fidelis:Client:StaffTools", target, {type = "SummonToMe", pos = GetEntityCoords(GetPlayerPed(src))})

            if (target ~= -1) then
                local targetUsername = exports["soe-uchuu"]:GetOnlinePlayerList()[target].Username
                if not targetUsername then
                    targetUsername = GetPlayerName(target)
                end
                exports["soe-logging"]:ServerLog("Staff Tool", "HAS TELEPORTED A PLAYER TO THEM | TARGET: " .. targetUsername, src)
            else
                exports["soe-logging"]:ServerLog("Staff Tool", "HAS TELEPORTED ALL PLAYERS IN SESSION TO THEM", src)
            end
        end
    -- REPAIRS CURRENT VEHICLE
    elseif (args[1] == "fix") then
        TriggerClientEvent("Fidelis:Client:StaffTools", src, {type = "Fix"})
        exports["soe-logging"]:ServerLog("Staff Tool", "HAS FIXED THEIR VEHICLE", src)
    -- GET INFORMATION FROM SPECIFIED PLAYER
    elseif (args[1] == "info") then
        local target = tonumber(args[2])
        if (target ~= nil) then
            TriggerClientEvent("Fidelis:Client:StaffTools", target, {type = "GatherInfo", src = src})

            if (target ~= -1) then
                local targetUsername = exports["soe-uchuu"]:GetOnlinePlayerList()[target].Username
                if not targetUsername then
                    targetUsername = GetPlayerName(target)
                end
                exports["soe-logging"]:ServerLog("Staff Tool", "HAS REQUESTED A PLAYER'S INFORMATION | TARGET: " .. targetUsername, src)
            else
                exports["soe-logging"]:ServerLog("Staff Tool", "HAS REQUESTED ALL PLAYERS IN SESSION'S INFORMATION", src)
            end
        end
    -- REVIVE SPECIFIED PLAYER
    elseif (args[1] == "revive") then
        local target = tonumber(args[2])
        if (target ~= nil) then
            TriggerEvent("Emergency:Server:RevivePlayer", target, nil)
            TriggerClientEvent("Chat:Client:SendMessage", target, "system", "You've been revived by a staff member.")

            if (target ~= -1) then
                local targetUsername = exports["soe-uchuu"]:GetOnlinePlayerList()[target].Username
                if not targetUsername then
                    targetUsername = GetPlayerName(target)
                end
                exports["soe-logging"]:ServerLog("Staff Tool", "HAS REVIVED A PLAYER | TARGET: " .. targetUsername, src)
            else
                exports["soe-logging"]:ServerLog("Staff Tool", "HAS REVIVED ALL PLAYERS IN SESSION", src)
            end
        end
    -- FREEZE SPECIFIED PLAYER
    elseif (args[1] == "freeze") then
        local target = tonumber(args[2])
        if (target ~= nil) then
            TriggerClientEvent("Fidelis:Client:StaffTools", target, {type = "FreezePlayer"})

            local targetUsername = exports["soe-uchuu"]:GetOnlinePlayerList()[target].Username
            if not targetUsername then
                targetUsername = GetPlayerName(target)
            end
            TriggerClientEvent("Chat:Client:SendMessage", src, "system", "You froze/unfroze: " .. targetUsername)
            exports["soe-logging"]:ServerLog("Staff Tool", "HAS FROZE/UNFROZE A PLAYER | TARGET: " .. targetUsername, src)
        end
    -- SPECTATE SPECIFIED PLAYER
    elseif (args[1] == "spectate") then
        local target = tonumber(args[2])
        if (target ~= nil) then
            TriggerClientEvent("Fidelis:Client:StaffTools", src, {type = "SpectatePlayer", target = target})

            local targetUsername = exports["soe-uchuu"]:GetOnlinePlayerList()[target].Username
            if not targetUsername then
                targetUsername = GetPlayerName(target)
            end
            TriggerClientEvent("Chat:Client:SendMessage", src, "system", "You spectate/unspectate: " .. targetUsername)
            exports["soe-logging"]:ServerLog("Staff Tool", "HAS SPECTATED/UNSPECTATED A PLAYER | TARGET: " .. targetUsername, src)
        end
    -- SETS FUEL OF CURRENT VEHICLE
    elseif (args[1] == "fuel") then
        TriggerClientEvent("Fidelis:Client:StaffTools", src, {type = "SetFuel", fuel = tonumber(args[2])})
        exports["soe-logging"]:ServerLog("Staff Tool", "HAS FUELED THEIR VEHICLE | AMOUNT: " .. tonumber(args[2]), src)
    -- TOGGLES INVISIBILITY
    elseif (args[1] == "invis") then
        TriggerClientEvent("Fidelis:Client:StaffTools", src, {type = "ToggleInvis"})
        exports["soe-logging"]:ServerLog("Staff Tool", "HAS TOGGLED INVISIBILITY", src)
    -- CLEARS CHAT GLOBALLY
    elseif (args[1] == "clearchat") then
        TriggerClientEvent("Chat:Client:ClearChat", -1)
        exports["soe-logging"]:ServerLog("Staff Tool", "HAS GLOBALLY CLEARED CHAT", src)
    -- FILLS HUNGER/THIRST
    elseif (args[1] == "nourish") then
        local target = tonumber(args[2])
        if (target ~= nil) then
            TriggerClientEvent("Fidelis:Client:StaffTools", target, {type = "Nourish"})
            if (target ~= -1) then
                local targetUsername = exports["soe-uchuu"]:GetOnlinePlayerList()[target].Username
                if not targetUsername then
                    targetUsername = GetPlayerName(target)
                end
                exports["soe-logging"]:ServerLog("Staff Tool", "HAS NOURISHED A PLAYER | TARGET: " .. targetUsername, src)
            else
                exports["soe-logging"]:ServerLog("Staff Tool", "HAS NOURISHED ALL PLAYERS IN SESSION", src)
            end
        end
    -- OPENS STAFF MENU
    elseif (args[1] == "menu") then
        local playerList = GetCurrentPlayers(false) or {}
        TriggerClientEvent("Fidelis:Client:OpenMenu", src, playerList)
        exports["soe-logging"]:ServerLog("Staff Tool", "HAS ACCESSED THE STAFF MENU", src)
    end
end)

-- **********************
--        Events
-- **********************
-- GRABS PLAYER INFO OF SOURCE
RegisterNetEvent("Fidelis:Server:SendPlayerInfo", function(target, info)
    local src = source
    local username = exports["soe-uchuu"]:GetOnlinePlayerList()[src].Username
    TriggerClientEvent("Chat:Client:Message", target, ("[Information for %s (#%s)]"):format(username, src), info, "standard")
end)

-- WHEN TRIGGERED, GET PLAYERS FOR META SYSTEM
AddEventHandler("Fidelis:Server:GetMetaPlayers", function(cb, src)
    local playerList = {}
    for id, data in pairs(exports["soe-uchuu"]:GetOnlinePlayerList()) do
        local username = "(NOT YET LOGGED IN)"
        if data and data.Username then
            username = data.Username
        end

        username = "[" .. id .. "] " .. username
        playerList[id] = {name = tostring(username), pos = GetEntityCoords(GetPlayerPed(id)), hdg = math.ceil(GetEntityHeading(GetPlayerPed(id)))}
    end
    cb(playerList or {})
end)

-- MENU INTERACTION EVENT
RegisterNetEvent("Fidelis:Server:MenuInteraction", function(target, tool)
    local src = source
	if not tool then
        return
    end

    if not exports["soe-uchuu"]:IsStaff(src) then
        exports["soe-logging"]:ServerLog("Staff Menu Interaction - Possible Injection (Fidelis)", "TRIED TO TRIGGER A STAFF MENU BUTTON BUT IS NOT STAFF", src)
        return
    end

    if (tool.type == "RevivePlayer") then
        TriggerEvent("Emergency:Server:RevivePlayer", target, nil)
        TriggerClientEvent("Chat:Client:SendMessage", target, "system", "You've been revived by a staff member.")
        return
    elseif (tool.type == "KillPlayer") then
        TriggerClientEvent("Fidelis:Client:MenuInteraction", target, {status = true, type = "KillPlayer"})
        return
    elseif (tool.type == "SummonToMe") then
        local pos = GetEntityCoords(GetPlayerPed(src))
        TriggerClientEvent("Fidelis:Client:StaffTools", target, {type = "SummonToMe", pos = pos})
        return
    elseif (tool.type == "Explode") then
        local pos = GetEntityCoords(GetPlayerPed(target))
        TriggerClientEvent("Fidelis:Client:MenuInteraction", target, {status = true, type = "Explode", pos = pos})
        return
    elseif (tool.type == "TeleportToPlayer") then
        local pos = GetEntityCoords(GetPlayerPed(target))
        TriggerClientEvent("Fidelis:Client:StaffTools", src, {type = "TeleportToPlayer", ped = src, pos = pos})
        return
    elseif (tool.type == "Set Instance") then
        exports["soe-instance"]:SetPlayerInstance(tool.instanceID, target)
        return
    elseif (tool.type == "Screenshot") then
        local username = exports["soe-uchuu"]:GetOnlinePlayerList()[src].Username
        exports["soe-logging"]:ScreenshotScreen(target, "Requested Screenshot by " .. username)
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "Uploaded to: #fidelis-logs", length = 3500})
        return
    elseif (tool.type == "Revive Players In Distance") then
        local pos = GetEntityCoords(GetPlayerPed(src))
        for serverID in pairs(exports["soe-uchuu"]:GetOnlinePlayerList()) do
            if #(GetEntityCoords(GetPlayerPed(serverID)) - pos) <= 40.0 then
                TriggerEvent("Emergency:Server:RevivePlayer", serverID, nil)
                TriggerClientEvent("Chat:Client:SendMessage", serverID, "system", "You've been revived by a staff member.")
            end
        end

        exports["soe-logging"]:ServerLog("Staff Tool", "HAS REVIVED PLAYERS WITHIN A DISTANCE | COORDS: " .. pos, src)
        return
    end

    TriggerClientEvent("Fidelis:Client:StaffTools", target, tool)
end)
