playersSearching = {}
local drugs = {
    ["Weed"] = {"weedbrick", "loosemarijuana", "weed_smallbag", "joint", "sotw_joint", "sotw_joint_goldensunrise", "sotw_joint_purplenurple", "sotw_joint_tealappeal"},
    ["Coke"] = {"cocainebrick", "cocainevial"},
    ["Crack"] = {"cracktray", "crack_smallbag"}
}

-- **********************
--       Commands
-- **********************
-- WHEN TRIGGERED, SEARCH THE CLOSEST VEHICLE
RegisterCommand("searchveh", function(source)
    local src = source
    TriggerClientEvent("Inventory:Client:DoSearchVehicle", src)
end)

-- WHEN TRIGGERED, FRISK THE NEAREST PLAYER
RegisterCommand("frisk", function(source)
    local src = source
    TriggerClientEvent("Inventory:Client:FindSearchablePlayer", src, "frisk")
end)

-- WHEN TRIGGERED, SEARCH THE NEAREST PLAYER
RegisterCommand("search", function(source)
    local src = source
    TriggerClientEvent("Inventory:Client:FindSearchablePlayer", src, "search")
end)

-- WHEN TRIGGERED, SNIFF THE NEAREST VEHICLE
RegisterCommand("sniffveh", function(source)
    local src = source
    TriggerClientEvent("Inventory:Client:DoSniffing", src, {status = true, type = "vehicle"})
end)

-- WHEN TRIGGERED, SNIFF THE NEAREST PLAYER
RegisterCommand("sniff", function(source)
    local src = source
    TriggerClientEvent("Inventory:Client:DoSniffing", src, {status = true, type = "proximity"})
end)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, SEARCH/FRISK THE CLOSEST PLAYER
RegisterNetEvent("Inventory:Server:SendSearchablePlayer")
AddEventHandler("Inventory:Server:SendSearchablePlayer", function(id, type)
    local src = source
    if not id then return end

    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[id].CharID
    if not charID then return end

    playersSearching[src] = true
    CreateThread(function()
        while playersSearching[src] do
            Wait(550)

            -- MAKE SURE DISTANCE AIN'T AN ISSUE HERE.
            if #(GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(id))) > 5.0 then
                playersSearching[src] = false
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "The subject you were searching pulled away!", length = 5000})
                TriggerClientEvent("Inventory:Client:CloseInventory", src)
            end
        end
        TriggerClientEvent("Inventory:Client:SyncInventory", id)
    end)

    SetTimeout(5500, function()
        if playersSearching[src] then
            TriggerClientEvent("Inventory:Client:ShowInventory", src, type, false, charID)
        end
    end)
    TriggerClientEvent("Inventory:Client:PlaySearchAnim", src)

    if (type == "search") then
        TriggerClientEvent("Notify:Client:SendAlert", id, {type = "warning", text = "You feel somebody going through your pockets!", length = 5000})
    else
        TriggerClientEvent("Notify:Client:SendAlert", id, {type = "warning", text = "You feel somebody patting you down!", length = 5000})
    end
end)

-- WHEN TRIGGERED, CHECK TARGET INVENTORIES FOR DRUGS
RegisterNetEvent("Inventory:Server:DoSniffing", function(sniffData)
    local src = source
    if not sniffData then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 9342-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not sniffData.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 9342-2 | Lua-Injecting Detected.", 0)
        return
    end

    local detected = false
    if (sniffData.type == "proximity") then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "You begin sniffing the individual", length = 9000})

        -- LETS CHECK FOR WEED FIRST
        for _, item in pairs(drugs["Weed"]) do
            if (GetItemAmt(sniffData.target, item, "left") >= 1) then
                detected = true
                local scent = "strong"
                if (item ~= "weedbrick") then
                    scent = "faint"
                end

                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "debug", text = "You smell a " .. scent .. " amount of marijuana coming from the individual!", length = 15000})
                break
            end
        end

        if exports["soe-utils"]:IsModelADog(GetPlayerPed(src)) then
            -- LETS CHECK FOR COCAINE NEXT
            for _, item in pairs(drugs["Coke"]) do
                if (GetItemAmt(sniffData.target, item, "left") >= 1) then
                    detected = true
                    local scent = "strong"
                    if (item ~= "cocainebrick") then
                        scent = "faint"
                    end

                    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "debug", text = "You smell a " .. scent .. " amount of cocaine coming from the individual!", length = 15000})
                    break
                end
            end

            -- LETS CHECK FOR CRACK NEXT
            for _, item in pairs(drugs["Crack"]) do
                if (GetItemAmt(sniffData.target, item, "left") >= 1) then
                    detected = true
                    local scent = "strong"
                    if (item ~= "cracktray") then
                        scent = "faint"
                    end

                    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "debug", text = "You smell a " .. scent .. " amount of crack coming from the individual!", length = 15000})
                    break
                end
            end

            -- LETS CHECK FOR METH NEXT
            if (GetItemAmt(sniffData.target, "gramofmeth", "left") >= 1) then
                detected = true
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "debug", text = "You smell some methamphetamine coming from the individual!", length = 15000})
            end
        end
    elseif (sniffData.type == "vehicle") then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "You begin sniffing the vehicle", length = 9000})

        -- LETS CHECK FOR WEED FIRST
        for _, item in pairs(drugs["Weed"]) do
            if (GetItemAmtInVehicle(src, item, {netID = sniffData.target, plate = sniffData.data.plate}) >= 1) then
                detected = true
                local scent = "strong"
                if (item ~= "weedbrick") then
                    scent = "faint"
                end

                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "debug", text = "You smell a " .. scent .. " amount of marijuana coming from the vehicle!", length = 15000})
                break
            end
        end

        if exports["soe-utils"]:IsModelADog(GetPlayerPed(src)) then
            -- LETS CHECK FOR COCAINE NEXT
            for _, item in pairs(drugs["Coke"]) do
                if (GetItemAmtInVehicle(src, item, {netID = sniffData.target, plate = sniffData.data.plate}) >= 1) then
                    detected = true
                    local scent = "strong"
                    if (item ~= "cocainebrick") then
                        scent = "faint"
                    end

                    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "debug", text = "You smell a " .. scent .. " amount of cocaine coming from the vehicle!", length = 15000})
                    break
                end
            end

            -- LETS CHECK FOR CRACK NEXT
            for _, item in pairs(drugs["Crack"]) do
                if (GetItemAmtInVehicle(src, item, {netID = sniffData.target, plate = sniffData.data.plate}) >= 1) then
                    detected = true
                    local scent = "strong"
                    if (item ~= "cracktray") then
                        scent = "faint"
                    end

                    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "debug", text = "You smell a " .. scent .. " amount of crack coming from the vehicle!", length = 15000})
                    break
                end
            end

            -- LETS CHECK FOR METH NEXT
            if (GetItemAmtInVehicle(src, "gramofmeth", {netID = sniffData.target, plate = sniffData.data.plate}) >= 1) then
                detected = true
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "debug", text = "You smell some methamphetamine coming from the vehicle!", length = 15000})
            end
        end
    end

    if not detected then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You did not smell anything", length = 12000})
    end
end)
