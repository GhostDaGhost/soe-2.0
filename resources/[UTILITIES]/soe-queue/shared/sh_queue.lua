if not IsDuplicityVersion() then
    CreateThread(function()
        while true do
            Wait(0)
            if NetworkIsSessionStarted() then
                TriggerServerEvent("Queue:playerActivated")
                return
            end
        end
    end)
    return
end

local Queue = {}
-- EDIT THESE IN SERVER.CFG + OTHER OPTIONS IN CONFIG.LUA
Queue.MaxPlayers = GetConvarInt("sv_maxclients", 64)
Queue.Debug = true

-- This is needed because msgpack will break when tables are too large
local _Queue = {}
_Queue.QueueList = {}
_Queue.PlayerList = {}
_Queue.PlayerCount = 0
_Queue.Priority = {}
_Queue.Connecting = {}
_Queue.JoinCbs = {}
_Queue.TempPriority = {}
_Queue.JoinDelay = GetGameTimer() + Config.JoinDelay and Config.JoinDelay or 0

local tostring = tostring
local tonumber = tonumber
local ipairs = ipairs
local pairs = pairs
local print = print
local string_len = string.len
local string_sub = string.sub
local string_format = string.format
local string_lower = string.lower
local math_abs = math.abs
local math_floor = math.floor
local math_random = math.random
local os_time = os.time
local table_insert = table.insert
local table_remove = table.remove

function Queue:DebugPrint(msg)
    if Queue.Debug then
        msg = "^3QUEUE: ^0" .. tostring(msg) .. "^7"
        print(msg)
    end
end

function Queue:HexIdToSteamId(hexId)
    local cid = math_floor(tonumber(string_sub(hexId, 7), 16))
	local steam64 = math_floor(tonumber(string_sub( cid, 2)))
	local a = steam64 % 2 == 0 and 0 or 1
	local b = math_floor(math_abs(6561197960265728 - steam64 - a) / 2)
	local sid = "steam_0:"..a..":"..(a == 1 and b -1 or b)
    return sid
end

function Queue:GetPlayerCount()
    return _Queue.PlayerCount
end

function Queue:GetSize()
    return #_Queue.QueueList
end

function Queue:ConnectingSize()
    return #_Queue.Connecting
end

function Queue:GetQueueList()
    return _Queue.QueueList
end

function Queue:GetPriorityList()
    return _Queue.Priority
end

function Queue:GetPlayerList()
    return _Queue.PlayerList
end

function Queue:GetTempPriorityList()
    return _Queue.TempPriority
end

function Queue:GetConnectingList()
    return _Queue.Connecting
end

function Queue:IsInQueue(ids, rtnTbl, bySource, connecting)
    local connList = Queue:GetConnectingList()
    local queueList = Queue:GetQueueList()

    for genericKey1, genericValue1 in ipairs(connecting and connList or queueList) do
        local inQueue = false
        if not bySource then
            for genericKey2, genericValue2 in ipairs(genericValue1.ids) do
                if inQueue then break end

                for genericKey3, genericValue3 in ipairs(ids) do
                    if genericValue3 == genericValue2 then inQueue = true break end
                end
            end
        else
            inQueue = ids == genericValue1.source
        end

        if inQueue then
            if rtnTbl then
                return genericKey1, connecting and connList[genericKey1] or queueList[genericKey1]
            end
            return true
        end
    end
    return false
end

function Queue:IsPriority(ids, fivemID)
    local prio = false
    local tempPower = Queue:HasTempPriority(ids)
    local prioList = Queue:GetPriorityList()

    if not fivemID then
        for _, id in ipairs(ids) do
            id = string_lower(id)
            if prioList[id] then
                prio = prioList[id]
                break
            end

            if (string_sub(id, 1, 5) == "steam") then
                local steamid = Queue:HexIdToSteamId(id)
                if prioList[steamid] then
                    prio = prioList[steamid]
                    break
                end
            end
        end
    else
        fivemID = string_lower(fivemID)
        if prioList[fivemID] then
            prio = prioList[fivemID]
        end
    end

    if tempPower or prio then
        if tempPower and prio then
            return tempPower > prio and tempPower or prio
        else
            return tempPower or prio
        end
    end
    return false
end

function Queue:HasTempPriority(ids)
    local tmpPrio = Queue:GetTempPriorityList()

    for _, id in pairs(ids) do
        id = string_lower(id)
        if tmpPrio[id] then
            return tmpPrio[id].power, tmpPrio[id].endTime, id
        end

        if string_sub(id, 1, 5) == "steam" then
            local steamid = Queue:HexIdToSteamId(id)
            if tmpPrio[steamid] then return tmpPrio[steamid].power, tmpPrio[steamid].endTime, id end
        end
    end
    return false
end

function Queue:AddToQueue(ids, connectTime, name, src, deferrals, fivemID)
    if Queue:IsInQueue(ids) then return end

    local tmp = {
        source = src,
        ids = ids,
        name = name,
        priority = Queue:IsPriority(ids, fivemID),
        timeout = 0,
        deferrals = deferrals,
        firstconnect = connectTime,
        queuetime = function()
            return (os_time() - connectTime)
        end
    }

    local _pos = false
    local queueCount = Queue:GetSize() + 1
    local queueList = Queue:GetQueueList()
    --[[print("TMP PRIORITY:", tmp.priority)
    print("IS PRIORITY?", Queue:IsPriority(ids, fivemID))
    print("PRIORITY LIST: ", json.encode(Queue:GetPriorityList()))]]

    for pos, data in ipairs(queueList) do
        --[[print(pos)
        print("TMP PRIORITY (2):", tmp.priority)]]
        if tmp.priority then
            --print("yes?")
            if not data.priority then
                _pos = pos
            else
                if (tmp.priority > data.priority) then
                    _pos = pos
                end
            end

            if _pos then
                Queue:DebugPrint(string_format("%s[%s] was prioritized and placed %d/%d in queue", tmp.name, ids[1], _pos, queueCount))
                exports["soe-logging"]:ServerLog("Queue", ("WAS PRIORITIZED AND PLACED %s/%s IN QUEUE"):format(_pos, queueCount), src)
                break
            end
        end
    end

    if not _pos then
        _pos = Queue:GetSize() + 1
        Queue:DebugPrint(string_format("%s[%s] was placed %d/%d in queue", tmp.name, ids[1], _pos, queueCount))
        exports["soe-logging"]:ServerLog("Queue", ("WAS PLACED %s/%s IN QUEUE"):format(_pos, queueCount), src)
    end
    table_insert(queueList, _pos, tmp)
end

function Queue:RemoveFromQueue(ids, bySource, byIndex)
    local queueList = Queue:GetQueueList()
    if byIndex then
        if queueList[byIndex] then
            table_remove(queueList, byIndex)
        end

        return
    end

    if Queue:IsInQueue(ids, false, bySource) then
        local pos, data = Queue:IsInQueue(ids, true, bySource)
        table_remove(queueList, pos)
    end
end

function Queue:TempSize()
    local count = 0

    for _pos, data in pairs(Queue:GetQueueList()) do
        if Queue:HasTempPriority(data.ids) then count = count +1 end
    end
    return count > 0 and count or false
end

function Queue:IsInConnecting(ids, bySource, refresh)
    local inConnecting, tbl = Queue:IsInQueue(ids, refresh and true or false, bySource and true or false, true)

    if not inConnecting then return false end
    if refresh and inConnecting and tbl then
        Queue:GetConnectingList()[inConnecting].timeout = 0
    end
    return true
end

function Queue:RemoveFromConnecting(ids, bySource, byIndex)
    local connList = Queue:GetConnectingList()
    if byIndex then
        if connList[byIndex] then
            table_remove(connList, byIndex)
        end
        return
    end

    for genericKey1, genericValue1 in ipairs(connList) do
        local inConnecting = false

        if not bySource then
            for genericKey2, genericValue2 in ipairs(genericValue1.ids) do
                if inConnecting then break end

                for genericKey3, genericValue3 in ipairs(ids) do
                    if genericValue3 == genericValue2 then inConnecting = true break end
                end
            end
        else
            inConnecting = ids == genericValue1.source
        end

        if inConnecting then
            table_remove(connList, genericKey1)
            return true
        end
    end
    return false
end

function Queue:AddToConnecting(ids, ignorePos, autoRemove, done)
    local function remove()
        if not autoRemove then return end

        done(Config.Language.connectingerr)
        Queue:RemoveFromConnecting(ids)
        Queue:RemoveFromQueue(ids)
        Queue:DebugPrint("Player could not be added to the connecting list")
    end

    local connList = Queue:GetConnectingList()
    if Queue:ConnectingSize() + Queue:GetPlayerCount() + 1 > Queue.MaxPlayers then
        remove() return false
    end

    if (ids[1] == "debug") then
        table_insert(connList, {source = ids[1], ids = ids, name = ids[1], firstconnect = ids[1], priority = ids[1], timeout = 0})
        return true
    end

    if Queue:IsInConnecting(ids) then
        Queue:RemoveFromConnecting(ids)
    end

    local pos, data = Queue:IsInQueue(ids, true)
    if not ignorePos and (not pos or pos > 1) then
        remove() return fals
    end

    table_insert(connList, data)
    Queue:RemoveFromQueue(ids)
    return true
end

function Queue:GetIds(src)
    local ids = GetPlayerIdentifiers(src)
    local ip = GetPlayerEndpoint(src)
    ids = (ids and ids[1]) and ids or (ip and {"ip:" .. ip} or false)
    ids = ids ~= nil and ids or false

    if ids and #ids > 1 then
        local fivemID = exports["soe-utils"]:GetIdentifiersFromSource(src)["fivem"]
        for k, id in ipairs(ids) do
            if string_sub(id, 1, 3) == "ip:" and not Queue:IsPriority({id}, fivemID) then
                table_remove(ids, k)
            end
        end
    end
    return ids
end

function Queue:AddPriority(id, power, temp)
    if not id then return false end
    if type(id) == "table" then
        for _id, power in pairs(id) do
            if _id and type(_id) == "string" and power and type(power) == "number" then
                Queue:GetPriorityList()[_id] = power
            else
                Queue:DebugPrint("Error adding a priority id, invalid data passed")
                return false
            end
        end

        return true
    end

    power = (power and type(power) == "number") and power or 10
    if temp then
        local tempPower, tempEnd, tempId = Queue:HasTempPriority({id})
        id = tempId or id

        Queue:GetTempPriorityList()[string_lower(id)] = {power = power, endTime = os_time() + temp} 
    else
        if not Queue:GetPriorityList()[string_lower(id)] then
            Queue:GetPriorityList()[string_lower(id)] = power
            --print("PRIORITY ADDED FOR:", id, power)
        end
    end
    
    return true
end

function Queue:RemovePriority(id)
    if not id then return false end
    id = string_lower(id)
    Queue:GetPriorityList()[id] = nil
    return true
end

function Queue:UpdatePosData(src, ids, deferrals)
    local pos, data = Queue:IsInQueue(ids, true)
    data.source = src
    data.ids = ids
    data.timeout = 0
    data.firstconnect = os_time()
    data.name = GetPlayerName(src)
    data.deferrals = deferrals
end

function Queue:NotFull(firstJoin)
    local canJoin = Queue:GetPlayerCount() + Queue:ConnectingSize() < Queue.MaxPlayers
    if firstJoin and canJoin then canJoin = Queue:GetSize() <= 1 end
    return canJoin
end

function Queue:SetPos(ids, newPos)
    if newPos <= 0 or newPos > Queue:GetSize() then return false end
    local pos, data = Queue:IsInQueue(ids, true)
    local queueList = Queue:GetQueueList()

    table_remove(queueList, pos)
    table_insert(queueList, newPos, data)
end

function Queue:CanJoin(src, cb)
    local allow = true
    for _, data in ipairs(_Queue.JoinCbs) do
        local await = true
        data.func(src, function(reason)
            if reason and type(reason) == "string" then
                allow = false
                cb(reason)
            end
            await = false
        end)

        while await do
            Wait(0)
        end

        if not allow then return end
    end

    if allow then cb(false) end
end

function Queue:OnJoin(cb, resource)
    if not cb then return end

    local tmp = {resource = resource, func = cb}
    table_insert(_Queue.JoinCbs, tmp)
end

exports("GetQueueExports", function()
    return Queue
end)

local function playerConnect(name, setKickReason, deferrals)
    local src = source
    local ids = Queue:GetIds(src)
    local name = GetPlayerName(src)
    local connectTime = os_time()
    local connecting = true

    deferrals.defer()
    CreateThread(function()
        while connecting do
            Wait(100)
            if not connecting then return end
            deferrals.update(Config.Language.connecting)
        end
    end)

    Wait(500)
    local fivemID = exports["soe-utils"]:GetIdentifiersFromSource(src)["fivem"]
    if fivemID then
        if not Queue:GetPriorityList()[string_lower(fivemID)] then
            local getPriority = exports["soe-nexus"]:PerformAPIRequest("/api/queue/getpriority", "fivemid=" .. fivemID, true)
            if getPriority.status then
                if (getPriority.data.PriorityType == "Staff") then
                    Queue:AddPriority(fivemID, 100, false)
                elseif (getPriority.data.PriorityType == "Emergency Services") then
                    Queue:AddPriority(fivemID, 70, false)
                end
            end
        end
    end

    local function done(msg, _deferrals)
        connecting = false
        local deferrals = _deferrals or deferrals
        if msg then
            deferrals.update(tostring(msg) or "")
        end

        Wait(500)
        if not msg then
            deferrals.done()
            if Config.EnableGrace then
                Queue:AddPriority(ids[1], Config.GracePower, Config.GraceTime)
            end
        else
            deferrals.done(tostring(msg) or "") CancelEvent()
        end
        return
    end

    local function update(msg, _deferrals)
        local deferrals = _deferrals or deferrals
        connecting = false
        deferrals.update(tostring(msg) or "")
    end

    if not ids then
        -- prevent joining
        done(Config.Language.iderr)
        CancelEvent()
        if name then
            Queue:DebugPrint("Dropped " .. name .. ", couldn't retrieve any of their identifiers.")
        else
            Queue:DebugPrint("Dropped a player, couldn't retrieve any of their identifiers.")
        end
        return
    end

    local allow
    Queue:CanJoin(src, function(reason)
        if reason == nil or allow ~= nil then return end
        if reason == false or #_Queue.JoinCbs <= 0 then allow = true return end

        if reason then
            -- prevent joining
            allow = false
            done(reason and tostring(reason) or "You were blocked from joining")
            Queue:RemoveFromQueue(ids)
            Queue:RemoveFromConnecting(ids)
            Queue:DebugPrint(string_format("%s[%s] was blocked from joining; Reason: %s", name, ids[1], reason))
            CancelEvent()
            return
        end
        allow = true
    end) 

    while allow == nil do
        Wait(0)
    end

    if not allow then
        return
    end

    local rejoined = false
    if Queue:IsInConnecting(ids, false, true) then
        Queue:RemoveFromConnecting(ids)

        if Queue:NotFull() then
            -- let them in the server
            if not Queue:IsInQueue(ids) then
                Queue:AddToQueue(ids, connectTime, name, src, deferrals, fivemID)
            end

            local added = Queue:AddToConnecting(ids, true, true, done)
            if not added then CancelEvent() return end
            done()

            return
        else
            rejoined = true
        end
    end

    if Queue:IsInQueue(ids) then
        rejoined = true
        Queue:UpdatePosData(src, ids, deferrals)
        Queue:DebugPrint(string_format("%s[%s] has rejoined queue after cancelling", name, ids[1]))
    else
        Queue:AddToQueue(ids, connectTime, name, src, deferrals, fivemID)

        if rejoined then
            Queue:SetPos(ids, 1)
            rejoined = false
        end
    end

    local pos, data = Queue:IsInQueue(ids, true)
    if not pos or not data then
        done(Config.Language.err .. " [1]")

        Queue:RemoveFromQueue(ids)
        Queue:RemoveFromConnecting(ids)

        CancelEvent()
        return
    end

    if Queue:NotFull(true) and _Queue.JoinDelay <= GetGameTimer() then
        -- let them in the server
        local added = Queue:AddToConnecting(ids, true, true, done)
        if not added then CancelEvent() return end

        done()
        local server = GetConvar("serverTag", "Undefined")
        Queue:DebugPrint(name .. "[" .. ids[1] .. "] is loading into the server")
        exports["soe-logging"]:ServerLog("Player Connecting", ("%s IS CONNECTING TO %s WITH IDENTIFIERS: %s"):format(name, server, json.encode(GetPlayerIdentifiers(src))))
        return
    end

    update(string_format(Config.Language.pos .. ((Queue:TempSize() and Config.ShowTemp) and " (" .. Queue:TempSize() .. " temp)" or "00:00:00"), pos, Queue:GetSize(), ""))
    if rejoined then return end

    while true do
        Wait(500)
        local pos, data = Queue:IsInQueue(ids, true)
        local function remove(msg)
            if data then
                if msg then
                    update(msg, data.deferrals)
                end

                Queue:RemoveFromQueue(data.source, true)
                Queue:RemoveFromConnecting(data.source, true)
            else
                Queue:RemoveFromQueue(ids)
                Queue:RemoveFromConnecting(ids)
            end
        end

        if not data or not data.deferrals or not data.source or not pos then
            remove("[Queue] Removed from queue, queue data invalid :(")
            Queue:DebugPrint(tostring(name .. "[" .. ids[1] .. "] was removed from the queue because they had invalid data"))
            return
        end

        local endPoint = GetPlayerEndpoint(data.source)
        if not endPoint then data.timeout = data.timeout + 0.5 else data.timeout = 0 end
        if data.timeout >= Config.QueueTimeOut and os_time() - connectTime > 5 then
            remove("[Queue] Removed due to timeout")
            Queue:DebugPrint(name .. "[" .. ids[1] .. "] was removed from the queue because they timed out")
            return
        end

        if pos <= 1 and Queue:NotFull() and _Queue.JoinDelay <= GetGameTimer() then
            -- let them in the server
            local added = Queue:AddToConnecting(ids)

            update(Config.Language.joining, data.deferrals)
            Wait(500)

            if not added then
                done(Config.Language.connectingerr)
                CancelEvent()
                return
            end

            done(nil, data.deferrals)
            if Config.EnableGrace then
                Queue:AddPriority(ids[1], Config.GracePower, Config.GraceTime)
            end

            Queue:RemoveFromQueue(ids)
            local server = GetConvar("serverTag", "Undefined")
            Queue:DebugPrint(name .. "[" .. ids[1] .. "] is loading into the server")
            exports["soe-logging"]:ServerLog("Player Connecting", ("%s IS CONNECTING TO %s WITH IDENTIFIERS: %s"):format(name, server, json.encode(GetPlayerIdentifiers(src))))
            return
        end

        local seconds = data.queuetime()
        local qTime = string_format("%02d", math_floor((seconds % 86400) / 3600)) .. ":" .. string_format("%02d", math_floor((seconds % 3600) / 60)) .. ":" .. string_format("%02d", math_floor(seconds % 60))

        local msg = string_format(Config.Language.pos .. ((Queue:TempSize() and Config.ShowTemp) and " (" .. Queue:TempSize() .. " temp)" or ""), pos, Queue:GetSize(), qTime)
        update(msg, data.deferrals)
    end
end

AddEventHandler("playerConnecting", playerConnect)

CreateThread(function()
    local function remove(data, pos, msg)
        if data and data.source then
            Queue:RemoveFromQueue(data.source, true)
            Queue:RemoveFromConnecting(data.source, true)
        elseif pos then
            table_remove(Queue:GetQueueList(), pos)
        end
    end

    while true do
        Wait(1000)

        local i = 1
        while i <= Queue:ConnectingSize() do
            local data = Queue:GetConnectingList()[i]
            local endPoint = GetPlayerEndpoint(data.source)
            data.timeout = data.timeout + 1

            if ((data.timeout >= 300 and not endPoint) or data.timeout >= Config.ConnectTimeOut) and data.source ~= "debug" and os_time() - data.firstconnect > 5 then
                remove(data)
                Queue:DebugPrint(data.name .. "[" .. data.ids[1] .. "] was removed from the connecting queue because they timed out")
            else
                i = i + 1
            end
        end

        for id, data in pairs(Queue:GetTempPriorityList()) do
            if os_time() >= data.endTime then
                Queue:GetTempPriorityList()[id] = nil
            end
        end
    
        Queue.MaxPlayers = GetConvarInt("sv_maxclients", 64)
        Queue.Debug = GetConvar("sv_debugqueue", "true") == "true" and true or false
        local qCount = Queue:GetSize()
    end
end)

RegisterNetEvent("Queue:playerActivated")
AddEventHandler("Queue:playerActivated", function()
    local src = source
    local ids = Queue:GetIds(src)

    if not Queue:GetPlayerList()[src] then
        _Queue.PlayerCount = Queue:GetPlayerCount() + 1
        Queue:GetPlayerList()[src] = true
        Queue:RemoveFromQueue(ids)
        Queue:RemoveFromConnecting(ids)
    end
end)

AddEventHandler("playerDropped", function()
    local src = source
    local ids = Queue:GetIds(src)

    if Queue:GetPlayerList()[src] then
        _Queue.PlayerCount = Queue:GetPlayerCount() - 1
        Queue:GetPlayerList()[src] = nil
        Queue:RemoveFromQueue(ids)
        Queue:RemoveFromConnecting(ids)
        if Config.EnableGrace then Queue:AddPriority(ids[1], Config.GracePower, Config.GraceTime) end
    end
end)

AddEventHandler("onResourceStop", function(resource)
    for k, data in ipairs(_Queue.JoinCbs) do
        if data.resource == resource then
            table_remove(_Queue.JoinCbs, k)
        end
    end
end)
