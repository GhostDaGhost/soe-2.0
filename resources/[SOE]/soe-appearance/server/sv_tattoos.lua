-- ***********************
--     Local Functions
-- ***********************
-- WHEN TRIGGERED, PERFORM CHECKS TO THE TATTOO ARTIST
local function DoTattooArtistChecks(src, target)
    -- CHECK SOURCE'S FACTION PERMISSION
    if not exports["soe-factions"]:CheckPermission(src, "CANTATTOO") then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You are not a tattoo artist!", length = 5000})
        return
    end

    -- CHECK IF THE TARGET PED EVEN EXISTS
    if not DoesEntityExist(GetPlayerPed(target)) then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "The target does not exist!", length = 5000})
        return
    end

    -- CHECK IF THE TARGET IS CLOSE TO THE SOURCE PED
    if #(GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(target))) > 6.0 then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "The target is not close enough!", length = 5000})
        return
    end

    -- TARGET CHARACTER ID VALIDATION CHECK
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[target].CharID
    if not charID then return end

    -- GET TATTOOS OF THE TARGET
    local getAppearance = exports["soe-nexus"]:PerformAPIRequest("/api/character/getappearance", ("charid=%s"):format(charID), true)
    if getAppearance.status then
        local gender = GetGender(GetPlayerPed(target))
        local tattoos = json.decode(getAppearance.data).tattoos
        if not tattoos then
            tattoos = "None"
        end

        TriggerClientEvent("Appearance:Client:DoTattoosOnPlayer", src, {status = true, target = target, charID = charID, tattoos = tattoos, gender = gender})
    end
end

-- ***********************
--        Commands
-- ***********************
-- WHEN TRIGGERED, ALLOW A TATTOO ARTIST TO PUT TATTOOS ON A TARGETED PLAYER
RegisterCommand("tattoo", function(source, args)
    local src = source
    local target = tonumber(args[1])
    if (target ~= nil) then
        DoTattooArtistChecks(src, target)
    else
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Enter a target ID! (TTID)", length = 5000})
    end
end)

-- ***********************
--         Events
-- ***********************
-- WHEN TRIGGERED, SAVE TATTOOS FOR SOURCE AND SEND BACK A CONFIRMATION
AddEventHandler("Appearance:Server:SaveTattoos", function(cb, src, tattoos)
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    if not charID then cb(false) return end

    -- GET APPEARANCE FIRST
    local getAppearance = exports["soe-nexus"]:PerformAPIRequest("/api/character/getappearance", ("charid=%s"):format(charID), true)
    if getAppearance.status then
        local appearance = json.decode(getAppearance.data)
        appearance["tattoos"] = tattoos
        exports["soe-nexus"]:PerformAPIRequest("/api/character/setappearance", ("charid=%s&appearance=%s"):format(charID, json.encode(appearance)), true)
    end
    cb(true)
end)

-- WHEN TRIGGERED, SYNC THE TARGET'S TATTOO PROCESS
RegisterNetEvent("Appearance:Server:SyncTattoo")
AddEventHandler("Appearance:Server:SyncTattoo", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 3829-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 3829-2 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.serverID then return end
    TriggerClientEvent("Appearance:Client:SyncTattoo", data.serverID, data)
end)

-- WHEN TRIGGERED, RELOAD THE TARGET'S APPEARANCE AFTER SOURCE CLOSED MENU
RegisterNetEvent("Appearance:Server:CloseTattooMenu")
AddEventHandler("Appearance:Server:CloseTattooMenu", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 3828-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 3828-2 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.serverID then return end
    if data.purchased then
        local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[data.serverID].CharID
        if not charID then return end

        -- GET APPEARANCE FIRST
        local getAppearance = exports["soe-nexus"]:PerformAPIRequest("/api/character/getappearance", ("charid=%s"):format(charID), true)
        if getAppearance.status then
            local appearance = json.decode(getAppearance.data)
            appearance["tattoos"] = data.tattoos
            exports["soe-nexus"]:PerformAPIRequest("/api/character/setappearance", ("charid=%s&appearance=%s"):format(charID, json.encode(appearance)), true)

            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "You successfully tattoo'd this person", length = 5000})
        else
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Something went wrong!", length = 5000})
        end
    end

    Wait(1500)
    TriggerClientEvent("Appearance:Client:RefreshTattooTarget", data.serverID, {status = true})
end)
