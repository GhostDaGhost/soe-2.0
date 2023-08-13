local boombox = {}
local cooldown = 0
local activeBoomboxes = {}
local domainError = "The boombox cannot play because you need to cut out the domain part. (Example: https://www.youtube.com/watch?v=VJ9VKkT6Xrc | You only need: VJ9VKkT6Xrc)"

-- SET DEFAULT VALUES FOR THE BOOMBOX TABLE
for i = 1, 10 do
    table.insert(activeBoomboxes, false)
end

-- DECORATORS
DecorRegister("boomboxUID", 3)
DecorRegister("isBoomboxPaused", 2)

-- ***********************
--    Local Functions
-- ***********************
local function PlayBoombox(data)
    -- IF THE BOOMBOX IS TOO DAMAGED
    if (GetEntityHealth(boombox.nearestBox) <= 50) then
        exports["soe-ui"]:SendAlert("error", "This boombox is too damaged!", 5000)
        return
    end

    local UID = 0
    for i = 1, 10 do
        if not activeBoomboxes[i] then
            UID = i
            break
        end
    end

    -- WE HAVE A GLOBAL BOOMBOX LIMIT, LETS ENFORCE THAT
    if (UID <= 0) then
        exports["soe-ui"]:SendAlert("error", "Too many boomboxes active!", 9500)
        return
    end

    -- JAVASCRIPT URL DETECTING HATES THE DOMAIN PART
    local musicURL = data.musicURL
    if musicURL:match("youtube") then
        exports["soe-ui"]:SendAlert("error", domainError, 9500)
        return
    end

    -- NETWORK STUFFS
    local netID = NetworkGetNetworkIdFromEntity(boombox.nearestBox)
    NetworkSetNetworkIdDynamic(netID, false)
    SetNetworkIdCanMigrate(netID, true)
    SetNetworkIdExistsOnAllMachines(netID, true)

    -- LET THE SERVER SYNC THIS BOOMBOX
    DecorSetBool(boombox.nearestBox, "isBoomboxPaused", false)
    TriggerServerEvent("UX:Server:SyncBoombox", {status = true, netID = netID, uid = UID, musicURL = musicURL})
end

-- ***********************
--     NUI Callbacks
-- ***********************
-- WHEN TRIGGERED, LET PLAYER KNOW THERE WAS AN ERROR
RegisterNUICallback("Boombox.SendErrorCode", function()
    exports["soe-ui"]:SendAlert("error", "See F8 Console for error with boombox", 5000)
end)

-- WHEN TRIGGERED, DO ORDINARY UI CLOSURE TASKS
RegisterNUICallback("Boombox.CloseUI", function()
    boombox.isUIOpen = false
    SetNuiFocus(false, false)
end)

-- WHEN TRIGGERED, DO A BOOMBOX TASK DEPENDING ON THE SENT TYPE
RegisterNUICallback("Boombox.SoundManagement", function(data, cb)
    -- SET A COOLDOWN BECAUSE OF POTENTIAL SPAM
    if (cooldown > GetGameTimer()) then
        exports["soe-ui"]:SendAlert("error", "You cannot do this yet", 5000)
        return
    end

    -- IF NOT IN A COOLDOWN
    cooldown = GetGameTimer() + 3500
    if (data.type == "Play Music") then
        PlayBoombox(data)
    elseif (data.type == "Pause Music") then
        local paused = DecorGetBool(boombox.nearestBox, "isBoomboxPaused")
        if paused then
            DecorSetBool(boombox.nearestBox, "isBoomboxPaused", false)
        else
            DecorSetBool(boombox.nearestBox, "isBoomboxPaused", true)
        end

        local src = DecorGetInt(boombox.nearestBox, "boomboxUID")
        paused = DecorGetBool(boombox.nearestBox, "isBoomboxPaused")
        TriggerServerEvent("UX:Server:PauseBoombox", {status = true, uid = src, paused = not paused})
        --cb({status = true, src = src})
    end
end)

-- ***********************
--         Events
-- ***********************
-- WHEN TRIGGERED, SYNC PAUSING OF BOOMBOX MUSIC
RegisterNetEvent("UX:Client:PauseBoombox")
AddEventHandler("UX:Client:PauseBoombox", function(data)
    if not activeBoomboxes[data.uid] then return end
    if data.paused then
        SendNUIMessage({type = "ResumeBoomboxSound", uid = data.uid})
    else
        SendNUIMessage({type = "PauseBoomboxSound", uid = data.uid})
    end
end)

-- INTERACTION KEYPRESS
AddEventHandler("Utils:Client:InteractionKey", function()
    local box = nil
    for index in pairs(boomBoxes) do

        -- SET DEFAULT DETECTION RADIUS
        local radius = 1.0

        -- DETECTION RADIUS OVERRIDE
        if boomBoxes[index].radius then
            radius = boomBoxes[index].radius
        end

        -- FIND CLOSEST BOOMBOX
        box = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), radius, GetHashKey(boomBoxes[index].hash), 0, 1, 1)

        if DoesEntityExist(box) then
            -- PLACE A DUMMY IF NOT DEFAULT BOOMBOX
            if not string.match(boomBoxes[index].name, "boombox") and not exports["soe-properties"]:IsInFurniturePlacingMode() then
                -- OFFSET DUMMY BOOMBOX
                local boxCoords = GetEntityCoords(box)
                if not boomBoxes[index].offSet then
                    box = CreateObject(GetHashKey("prop_poolball_cue"), boxCoords, 1, false, false)
                else
                    box = CreateObject(GetHashKey("prop_poolball_cue"), boxCoords.x + boomBoxes[index].xOffSet, boxCoords.y + boomBoxes[index].yOffSet, boxCoords.z + boomBoxes[index].zOffSet, 1, false, false)
                end

                -- FREEZE DUMMY BOOMBOX XYZ
                FreezeEntityPosition(box, true)
            end

            -- NETWORK STUFFS
            netID = NetworkGetNetworkIdFromEntity(box)
            NetworkSetNetworkIdDynamic(netID, false)
            SetNetworkIdCanMigrate(netID, true)
            SetNetworkIdExistsOnAllMachines(netID, true)
            break
        end
    end

    if DoesEntityExist(box) then
        boombox.nearestBox = box

        -- MAKE SURE THE BOOMBOX IS NOT A GHOST FURNITURE AND NETWORKED
        if exports["soe-properties"]:IsInFurniturePlacingMode() then
            return
        elseif not NetworkGetEntityIsNetworked(boombox.nearestBox) then
            exports["soe-ui"]:SendAlert("error", "You cannot use this boombox", 5000)
            return
        end

        if not boombox.isUIOpen then
            boombox.isUIOpen = true
            SetNuiFocus(true, true)
            SendNUIMessage({type = "ShowBoomboxUI"})
        end
    else
        if boombox.nearestBox then
            boombox.nearestBox = nil
        end
    end
end)

-- WHEN TRIGGERED, START A VOLUME CONTROL LOOP
RegisterNetEvent("UX:Client:SyncBoombox")
AddEventHandler("UX:Client:SyncBoombox", function(data)
    if activeBoomboxes[data.uid] then return end
    activeBoomboxes[data.uid] = true

    local sleep = 100
    local boombox = NetworkGetEntityFromNetworkId(data.netID)
    SendNUIMessage({type = "StartBoomboxSound", url = data.musicURL, uid = data.uid})

    SetEntityHealth(boombox, 100)
    DecorSetInt(boombox, "boomboxUID", data.uid)
    DecorSetBool(boombox, "isBoomboxPaused", false)
    while (boombox > 0) do
        Wait(sleep)
        local dist = #(GetEntityCoords(boombox) - GetEntityCoords(PlayerPedId()))
        if (dist > 50.0) then
            sleep = 5000
        end

        -- IF THE BOOMBOX GETS TOO DAMAGED
        if (GetEntityHealth(boombox) <= 50) then
            break
        end

        -- VOLUME CONTROL BASED OFF DISTANCE
        local factor = 1.0
        if (dist < (15.0 * factor)) then
            Wait(100)
            sleep = 100
            SendNUIMessage({type = "ModifyBoomboxSound", volume = 100 / (dist * factor), uid = data.uid})
        else
            Wait(100)
            sleep = 100
            SendNUIMessage({type = "ModifyBoomboxSound", volume = 0.0001, uid = data.uid})
        end

        -- CHECK IF THE PLAYER DECIDED TO MUTE ALL BOOMBOXES
        local mutedBoombox = json.decode(exports["soe-uchuu"]:GetPlayer().UserSettings)["mutedBoomboxes"]
        if mutedBoombox then
            sleep = 5000
            SendNUIMessage({type = "ModifyBoomboxSound", volume = 0.0001, uid = data.uid})
        end
    end

    SendNUIMessage({type = "StopBoomboxSound", uid = data.uid})
    activeBoomboxes[data.uid] = false
end)
