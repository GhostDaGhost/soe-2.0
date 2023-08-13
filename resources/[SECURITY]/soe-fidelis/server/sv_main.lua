-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, GATHER A LIST OF ACTIVE RESOURCES AND COMPARE WITH SENT CLIENT
local function InspectCurrentResources()
    local resources = {}
    for i = 0, GetNumResources() - 1 do
        resources[GetResourceByFindIndex(i)] = true
    end
    return resources
end

-- CALLED WHEN PLAYER IS CONNECTING, CHECKS IF PLAYER IS BANNED
local function CheckUserValidality(plyName, setKickReason, deferrals)
    deferrals.defer()
    local src = source

    -- SEND IDENTIFIERS AND CHECK IF A BAN IS ACTIVE WITH THEM
    local banIdentifiers = exports["soe-utils"]:GetIdentifiersFromSource(src)
    local myIdentifiers = json.encode(banIdentifiers)
    deferrals.update("⏳ Checking Identifiers...")

    -- IF A BAN IS FOUND, CANCEL CONNECTING AND SHOW BAN MESSAGE
    local checkBan = exports["soe-nexus"]:PerformAPIRequest("/api/ban/get", ("identifiers=%s"):format(myIdentifiers), true)
    if checkBan.status then
        local banData = checkBan.data
        if banData then
            deferrals.done(
                string.format(
                    "\nYou have been banned from the SoE servers!\nBan ID: %s\nBanned By: %s\nBan Expires: %s UTC\nBan Reason: %s\n\nYou can appeal this ban at soe.gg/banappeal",
                    banData.BanID,
                    banData.BannedBy,
                    banData.BanExpiry,
                    banData.BanReason
                )
            )
            CancelEvent()
            return
        end
    end

    -- IF GIVEN THE "ALL CLEAR", LOAD THE PLAYER IN
    Wait(200)
    deferrals.update("✅ All verification processes done! Loading you in now. :)")
    Wait(200)
    deferrals.done()
end

-- INPUT BAN INTO DB
local function InputNewBan(bannedBy, banReason, banExpires, banIdentifiers, src)
    local dataString = ("bannedby=%s&reason=%s&expiry=%s&identifiers=%s"):format(bannedBy, banReason, banExpires, json.encode(banIdentifiers))
    local inputBan = exports["soe-nexus"]:PerformAPIRequest("/api/ban/input", dataString, true)

    if inputBan and inputBan.status then
        TriggerClientEvent("Fidelis:Client:LightningStrike", -1, {status = true})
        DropPlayer(src,
            string.format(
                "\nYou have been banned from the SoE servers!\nBan ID: %s\nBanned By: %s\nBan Expires: %s UTC\nBan Reason: %s\n\nYou can appeal this ban at soe.gg/banappeal",
                inputBan.data.BanID,
                bannedBy,
                banExpires,
                banReason
            )
        )
    end
end

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, CHECK IF A PLAYER HAS AN ACTIVE BAN PRIOR TO CONNECTING
AddEventHandler("playerConnecting", CheckUserValidality)

-- WHEN TRIGGERED, INTERCEPT AN EXPLOSION EVENT AND LOG IT
RegisterNetEvent("explosionEvent")
AddEventHandler("explosionEvent", function(sender, ev)
    --print(GetPlayerName(sender), json.encode(ev))
    for _, v in ipairs(blockedExplosions) do
        if ev.explosionType == v then
            CancelEvent()
            TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 410 | Suspicious Explosion Detected.", 0)
            local msg = ("HAS TRIGGERED AN EXPLOSION | TYPE: %s | COORDS: %s"):format(ev.explosionType, GetEntityCoords(GetPlayerPed(sender)))
            exports["soe-logging"]:ServerLog("Suspicious Explosion(Fidelis)", msg, tonumber(sender))
        end
    end
end)

-- WHEN TRIGGERED, CHECK IF A FORBIDDEN OBJECT IS BEING CREATED AND LOG IT OR REMOVE IT
AddEventHandler("entityCreating", function(entity)
    local src = tonumber(NetworkGetEntityOwner(entity)) or 0
    local model, type = GetEntityModel(entity), GetEntityType(entity)

    -- ITERATE THROUGH AND CHECK IF THIS OBJECT IS FLAGGED AS FORBIDDEN
    if (type == 1) then return end
    for objectHash, objectData in pairs(restrictedObjects) do
        if (GetHashKey(objectHash) == model) then
            exports["soe-logging"]:ScreenshotScreen(src, "Forbidden Object Spawned - Possible Modding")
            if objectData.ban then
                TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: ENTITY-404 | Modding Detected!", 0)
            end

            if objectData.delete then
                CancelEvent()
            end

            local msg = ("HAS SPAWNED A SUSPICIOUS ENTITY | MODEL: %s | HASH: %s | COORDS: %s"):format(model, objectHash, GetEntityCoords(GetPlayerPed(src)))
            exports["soe-logging"]:ServerLog("Forbidden Object Spawned - Possible Modding (Fidelis)", msg, src)
            break
        end
    end
end)

-- AFK KICK THE SOURCE WHEN TRIGGERED
RegisterNetEvent("Fidelis:Server:AFKKick", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 699-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 699-2 | Lua-Injecting Detected.", 0)
        return
    end

    if exports["soe-uchuu"]:IsDevServer() or exports["soe-uchuu"]:IsTrainingServer() then
        return
    end

    exports["soe-logging"]:ServerLog("AFK Kicked", "WAS KICKED FOR BEING IDLE AT LEAST 30 MINUTES", src)
    DropPlayer(src, "You were kicked for being AFK for 30 minutes.")
end)

-- BAN THE PLAYER THAT SENT THIS REQUEST
RegisterNetEvent("Fidelis:Server:HandleSelfBan")
AddEventHandler("Fidelis:Server:HandleSelfBan", function(bannedBy, banReason, banTime)
    local src = source
    local banExpires = os.time() + banTime
    banExpires = os.date("%Y-%m-%d %H:%M:%S", banExpires)

    if (banTime == 0) then -- PERMANENT
        banExpires = "2099-01-01 00:00:00" -- JANUARY 1, 2099
    end

    local username
    local banIdentifiers = exports["soe-utils"]:GetIdentifiersFromSource(src)
    if not exports["soe-uchuu"]:GetOnlinePlayerList()[src].Username then
        username = GetPlayerName(src)
    else
        username = exports["soe-uchuu"]:GetOnlinePlayerList()[src].Username
    end

    banIdentifiers["username"] = username
    InputNewBan(bannedBy, banReason, banExpires, banIdentifiers, src)
end)

-- BAN THE PLAYER THAT SENT THIS REQUEST
RegisterNetEvent("Fidelis:Server:HandleBan")
AddEventHandler("Fidelis:Server:HandleBan", function(src, bannedBy, banReason, banTime)
    local banExpires = os.time() + banTime
    banExpires = os.date("%Y-%m-%d %H:%M:%S", banExpires)

    if (banTime == 0) then -- PERMANENT
        banExpires = "2099-01-01 00:00:00" -- JANUARY 1, 2099
    end

    local username
    local banIdentifiers = exports["soe-utils"]:GetIdentifiersFromSource(src)
    if not exports["soe-uchuu"]:GetOnlinePlayerList()[src].Username then
        username = GetPlayerName(src)
    else
        username = exports["soe-uchuu"]:GetOnlinePlayerList()[src].Username
    end

    banIdentifiers["username"] = username
    InputNewBan(bannedBy, banReason, banExpires, banIdentifiers, src)
end)

-- WHEN TRIGGERED, HANDLE SOME FIDELIS SERVER-SIDED CHECKS
RegisterNetEvent("Fidelis:Server:HandleChecks", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 4054-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 4054-2 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.type then return end
    if (data.type == "Resource Check") then
        -- PERFORM A SWEEP OF CLIENT'S RESOURCES AND COMPARE TO SERVER
        if not data.resources then return end

        -- IF THE SERVER'S RESOURCES ARE VERY DIFFERENT TO CLIENT... BAN THEM FOR HACK-MAKING A NEW RESOURCE
        local resources = InspectCurrentResources()
        for _, resource in ipairs(data.resources) do
            if not resources[resource] then
                exports["soe-logging"]:ServerLog("Fidelis Alert", "HAS BEEN AUTO-BANNED FOR HAVING MORE RESOURCES THAN THE SERVER ACTIVE | CAUGHT: " .. resource, src)
                TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: R01 | Lua-Injecting Detected.", 0)
                break
            end
        end
    end
end)
