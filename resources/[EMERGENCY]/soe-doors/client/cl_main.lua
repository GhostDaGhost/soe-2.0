local doors = {}
local gates = {
    [2130672747] = true,
    [-190780785] = true,
    [-1603817716] = true,
    [-105439435] = true,
    [-1635161509] = true,
    [-1868050792] = true,
    [-820650556] = true,
    [-1635161509] = true,
    [-1868050792] = true,
    [741314661] = true,
    [1107349801] = true,
    [-742460265] = true,
    [569833973] = true,
    [-655468553] = true,
    [-930593859] = true,
    [-197537718] = true,
    [1287245314] = true,
    [1559414575] = true,
    [1095700456] = true,
}

-- KEY MAPPINGS
RegisterKeyMapping("doors_togglestate", "[Doors] Toggle Lock", "keyboard", "E")

-- ***********************
--     Local Functions
-- ***********************
-- CHECKS IF THE CHARACTER HAS THE AUTHORIZED JOB
local function IsAuthorized(doorID)
    if doors[doorID].authorizedJobs ~= nil then
        local civType = exports["soe-uchuu"]:GetPlayer().CivType
        for _, job in pairs(doors[doorID].authorizedJobs) do
            if (civType == job) then
                return true
            end
        end
    elseif doors[doorID].perms ~= nil then
        local authorized = false
        -- PLAYER MUST HAVE ALL PERMS IN LIST
        for _, perm in pairs(doors[doorID].perms) do
            if exports["soe-factions"]:CheckPermission(perm) then
                authorized = true
            else
                authorized = false
            end
        end
        return authorized
    end
    return false
end

-- GETS CLOSEST DOOR
local function GetMyClosestDoor()
    local closestDoorsDist, closestDoorID = 9999.9, -1
    local linkedDoor = nil
    --print("-----")
    for doorID, doorData in pairs(doors) do
        local currentDoorDist = #(GetEntityCoords(PlayerPedId()) - doorData.pos)
        if doorData and (currentDoorDist <= closestDoorsDist) then
            closestDoorsDist, closestDoorID = currentDoorDist, doorID
            --print("doorData.linked", doorData.linked)
            if doorData.linked then
                --print("doorData.linkedDoor", doorData.linkedDoor)
                linkedDoor = doorData.linkedDoor
            else
                linkedDoor = nil
            end
            --print("currentDoorDist", currentDoorDist, "doorID", doorID)
        end
    end
    return closestDoorID, linkedDoor
end

-- INITIATES RESOURCE WITH DOORS REQUESTED FROM SERVER
local function InitiateResource()
    doors = exports["soe-nexus"]:TriggerServerCallback("Doors:Server:InitiateResource")

    print("Door Locks Initiated. :)")
    -- ITERATE AND SET DEFAULT/SYNCED LOCKED STATE OF DOORS
    for doorID, doorData in ipairs(doors) do
        if doorData and not IsDoorRegisteredWithSystem(doorID) then
            AddDoorToSystem(doorID, doorData.hash, doorData.pos, 0, 0, 0)
            if doorData.automatic then
                DoorSystemSetAutomaticRate(doorID, doorData.automaticRate or 1.0, 0, 1)
            end
            DoorSystemSetDoorState(doorID, doorData.locked, 0, 1)
        end
    end
end

-- LOCKPICKS NEAREST DOOR
local function LockpickDoor(isAdvanced)
    -- FIND OUR CLOSEST DOOR
    local doorID = GetMyClosestDoor()
    if (doorID ~= -1) then
        if #(doors[doorID].pos - GetEntityCoords(PlayerPedId())) <= doors[doorID].dist then
            -- CHECK IF DOOR IS EVEN ABLE TO BE LOCKPICKED
            if not doors[doorID].pickable then
                exports["soe-ui"]:SendAlert("error", "You realize that the door can't be lockpicked", 5500)
                return
            end

            -- CHECK IF DOOR IS ALREADY UNLOCKED
            if not doors[doorID].locked then
                exports["soe-ui"]:SendAlert("error", "Door is already unlocked", 5000)
                return
            end

            -- LOCKPICK MINIGAME
            if exports["soe-challenge"]:StartLockpicking(true) then
                doors[doorID].locked = false
                DoorSystemSetDoorState(doorID, false, false, true)
                TriggerServerEvent("Doors:Server:SyncStateChange", {status = true, doorID = doorID, state = false, usingThermite = false})
            end
        end
    end
end

-- LOCKS DOORS
local function LockDoor()
    -- FIND OUR CLOSEST DOOR
    local doorID, linkedDoor = GetMyClosestDoor()
    --[[print("doorID", doorID)
    print("linkedDoor", linkedDoor)]]

    if (doorID ~= -1) then
        local ped = PlayerPedId()
        if #(GetEntityCoords(ped) - doors[doorID].pos) > doors[doorID].dist then
            return
        end

        if doors[doorID].unlockable == false then
            return
        end

        -- CHECK IF CHARACTER IS AUTHORIZED TO TOGGLE THIS LOCK
        if not IsAuthorized(doorID) then
            exports["soe-ui"]:SendAlert("error", "You do not have a key to this door", 5000)
            return
        end

        -- ANIMATION CONTROLLER
        exports["soe-utils"]:LoadAnimDict("anim@heists@keycard@", 15)
        TaskPlayAnim(ped, "anim@heists@keycard@", "exit", -8.0, 3.0, 800, 49, 0, 0, 0, 0)

        local isGate = gates[tonumber(doors[doorID].hash)]
        local isBuzzer = doors[doorID].buzzer
        if isGate or isBuzzer then
            if doors[doorID].locked then
                PlaySoundFromEntity(-1, "Keycard_Success", ped, "DLC_HEISTS_BIOLAB_FINALE_SOUNDS", 1, 5.0)
            else
                PlaySoundFromEntity(-1, "Keycard_Fail", ped, "DLC_HEISTS_BIOLAB_FINALE_SOUNDS", 1, 5.0)
            end
        else
            Wait(650)
        end

        print(doorID)
        -- TOGGLES AND SYNCS LOCKS FOR OUR DOOR
        doors[doorID].locked = not doors[doorID].locked
        DoorSystemSetDoorState(doorID, doors[doorID].locked, false, true)
        TriggerServerEvent("Doors:Server:SyncStateChange", {status = true, doorID = doorID, state = doors[doorID].locked, usingThermite = false, isGate = isGate, isBuzzer = isBuzzer, isLinked = linkedDoor})
        if linkedDoor then
            local linkedDoorID = doorID + linkedDoor
            doors[linkedDoorID].locked = not doors[linkedDoorID].locked
            DoorSystemSetDoorState(linkedDoorID, doors[linkedDoorID].locked, false, true)
            TriggerServerEvent("Doors:Server:SyncStateChange", {status = true, doorID = linkedDoorID, state = doors[linkedDoorID].locked, usingThermite = false, isGate = isGate, isBuzzer = isBuzzer, secondaryDoor = true})
        end
    end
end

-- ***********************
--        Commands
-- ***********************
-- TRIGGERED BY KEYPRESS
RegisterCommand("doors_togglestate", LockDoor)

-- ***********************
--         Events
-- ***********************
-- CALLED WHEN PLAYER USES A LOCKPICK FROM THEIR INVENTORY
AddEventHandler("Inventory:Client:UseLockpick", LockpickDoor)

-- UPON RESOURCE START, SYNC DOORLOCKS FROM SERVER
AddEventHandler("onClientResourceStart", function(resource)
    if (GetCurrentResourceName() ~= resource) then return end

    Wait(3500)
    InitiateResource()
end)

-- CALLED FROM SERVER TO SYNC DOORLOCKS AFTER A STATE CHANGE
RegisterNetEvent("Doors:Client:SyncStateChange")
AddEventHandler("Doors:Client:SyncStateChange", function(data)
    if not data.status then return end
    if (data.doorID == nil) then print("This door ID is non-existent.") return end

    -- MAKE SURE WE HAVE OUR LIST OF DOORS AND DOOR EXISTS
    if doors and doors[data.doorID] then
        -- SET LOCK STATE
        doors[data.doorID].locked = data.state
        DoorSystemSetDoorState(data.doorID, data.state, 0, 1)

        -- AUTOMATICALLY SHUTS THE DOOR ONCE LOCKED
        if doors[data.doorID].automatic then
            if doors[data.doorID].locked then
                DoorSystemSetAutomaticRate(data.doorID, doors[data.doorID].automaticRate or 1.5, 0, 0)
            end
        end
    end
end)
