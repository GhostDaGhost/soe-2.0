local metaBlips = {}
local lastSpectateCoords, spectateTarget

local menuV = assert(MenuV)
local deletingEntity = false
local confirmation, currentNoclipSpeed, lastHit = 0, 1, 0
local noclip, map, frozen, spectating, meta, deletingEntity = false, false, false, false, false, false
local staffMenu = menuV:CreateMenu("Staff", "I call hacks.", "topright", 122, 6, 0, "size-125", "default", "menuv", "test6", "default")

-- KEY MAPPINGS
RegisterKeyMapping("noclip_speed", "[Dev] Change Noclip Speed", "KEYBOARD", "LSHIFT")

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, BEGIN ADDING BLIPS FOR ALL PLAYERS IN SESSION
local function CreateMetaBlips(refresh)
    local players = exports["soe-nexus"]:TriggerServerCallback("Fidelis:Server:GetMetaPlayers")
    if not refresh then
        for _, blip in pairs(metaBlips) do
            RemoveBlip(blip)
        end
        metaBlips = {}

        for playerID, playerData in pairs(players) do
            local blip = AddBlipForCoord(playerData.pos)
            SetBlipScale(blip, 0.8)
            SetBlipColour(blip, 0)
            SetBlipCategory(blip, 7)

            SetBlipRotation(blip, playerData.hdg)
            ShowHeadingIndicatorOnBlip(blip, true)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(playerData.name)
            EndTextCommandSetBlipName(blip)
            metaBlips[playerID] = blip
        end
    else
        for playerID, playerData in pairs(players) do
            local blip = metaBlips[playerID]
            SetBlipCoords(blip, playerData.pos)
            SetBlipRotation(blip, playerData.hdg)
        end
    end
end

-- WHEN TRIGGERED, TOGGLE META TOOL
local function MetaTool()
    meta = not meta

    local loopIndex = 0
    CreateMetaBlips(false)
    while meta do
        Wait(5)

        -- ALWAYS HAVE IDs SHOWN OVERHEAD AND DISPLAY IF THEY ARE TALKING
        local pos = GetEntityCoords(PlayerPedId())
        for _, v in pairs(GetActivePlayers()) do
            if #(pos - GetEntityCoords(GetPlayerPed(v))) <= 45.0 then
                pos = GetPedBoneCoords(GetPlayerPed(v), 0x796e)

                if NetworkIsPlayerTalking(v) then
                    exports["soe-utils"]:DrawText3D(pos.x, pos.y, pos.z + 0.5, ("~o~[%s]"):format(GetPlayerServerId(v)), true)
                else
                    exports["soe-utils"]:DrawText3D(pos.x, pos.y, pos.z + 0.5, ("[%s]"):format(GetPlayerServerId(v)), true)
                end
            end
        end

        -- BEGIN ADDING BLIPS FOR ALL PLAYERS IN SESSION
        loopIndex = loopIndex + 1
        if (loopIndex % 135 == 0) then
            loopIndex = 0
            CreateMetaBlips(true)
        end
    end

    -- REMOVE ALL BLIPS WHEN FINISHED WITH META
    for _, blip in pairs(metaBlips) do
        RemoveBlip(blip)
    end
    metaBlips = {}
end

-- LOOKS FOR AN ENTITY TO DELETE AND REMOVES IT WHEN FOUND
local function DeleteAnEntity()
    deletingEntity = not deletingEntity
    exports["soe-ui"]:PersistentAlert("start", "deletingObj", "debug", "Look at an object and press [Enter] when ready to delete", 100)
    while deletingEntity do
        Wait(5)
        -- IF 'ESCAPE' IS PRESSED, CANCEL DELETION
        if IsControlJustPressed(0, 200) then
            deletingEntity = false
        end

        local ent = exports["soe-utils"]:Raycast(100).HitEntity
        if (GetEntityType(ent) == 0) then
            ent = lastHit
        else
            lastHit = ent
        end

        local pos = GetEntityCoords(ent)
        local found = GetScreenCoordFromWorldCoord(pos.x, pos.y, pos.z)
        if found then
            DrawMarker(20, pos.x, pos.y, pos.z + 1.5, 0.0, 0.0, 0.0, 180.0, 0.0, 180.0, 0.55, 0.55, 0.55, 110, 0, 0, 170, 1, 1, 2, 0, 0, 0, 0)

            -- IF 'ENTER' IS PRESSED, DELETE SELECTED ENTITY
            if IsControlJustPressed(0, 201) then
                if not deletingEntity then return end
                deletingEntity = false
                exports["soe-utils"]:GetEntityControl(ent)
                SetEntityAsMissionEntity(ent, true, true)
                TriggerServerEvent("Utils:Server:DeleteEntity", ObjToNet(ent))
                DeleteObject(ent)
                DeleteEntity(ent)
                exports["soe-ui"]:SendAlert("success", "Object deleted!", 5000)
            end
        end
    end
    exports["soe-ui"]:PersistentAlert("end", "deletingObj")
end

-- STARTS A TEST DRAG RACE
local function DragRaceVehicleTest()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if (confirmation == 0) then
        confirmation = confirmation + 1
        TriggerEvent("Chat:Client:SendMessage", "dev", "WARNING: You will be teleported to the Los Santos International Airport runway. Type this command again if you want to do this.")
        return
    end

    if (confirmation == 1) then
        confirmation = 0

        -- TELEPORT TO THE AIRPORT RUNWAY
        SetEntityHeading(veh, 239.98)
        AuthorizeTeleport()
        SetEntityCoordsNoOffset(veh, -1635.7, -2971.4, 13.54, false, false, false)

        -- SET VEHICLE UP
        PlaceObjectOnGroundProperly(veh)
        Wait(1000)
        TaskVehicleTempAction(ped, veh, 32, 15000)

        for second = 1, 15 do
            Wait(1000)
            TriggerEvent("Chat:Client:SendMessage", "dev", ("%s Second: %s MPH"):format(second, math.ceil(GetEntitySpeed(veh) * 2.236936)))
        end
        TaskVehicleTempAction(ped, veh, 27, 15000)
    end
end

-- WHEN TRIGGERED, SPECTATE PLAYER
local function DoSpectate(target)
    if (GetConvarInt("usingOneSyncInfinity", 0) == 1) then
        local myPed = PlayerPedId()
        if IsPedSittingInAnyVehicle(myPed) then
            exports["soe-ui"]:SendAlert("error", "You cannot spectate others inside a vehicle! #SafeThanSorry", 5000)
            return
        end

        if not spectating then
            spectating = true
            local targetCoords = exports["soe-utils"]:FetchEntityCoords(target)
            lastSpectateCoords = GetEntityCoords(myPed)

            SetEntityVisible(myPed, false)
            SetEntityCollision(myPed, false, false)
            SetEntityInvincible(myPed, true)
            NetworkSetEntityInvisibleToNetwork(myPed, true)
            FreezeEntityPosition(myPed, true)

            Wait(200)
            SetEntityCoords(myPed, targetCoords.x, targetCoords.y, targetCoords.z - 10.0)
            Wait(500)

            spectateTarget = GetPlayerPed(GetPlayerFromServerId(target))
            RequestCollisionAtCoord(targetCoords)
            NetworkSetInSpectatorMode(true, spectateTarget)

            while spectating do
                Wait(1200)
                myPed = PlayerPedId()
                targetCoords = GetEntityCoords(spectateTarget)

                if spectating and targetCoords and (targetCoords.x ~= 0) then
                    SetEntityCoords(myPed, targetCoords.x, targetCoords.y, targetCoords.z - 10.0)
                end
            end
        else
            spectating = false
            if lastSpectateCoords then
                RequestCollisionAtCoord(lastSpectateCoords)
                Wait(500)
                SetEntityCoords(myPed, lastSpectateCoords)
                lastSpectateCoords = nil
            end

            NetworkSetInSpectatorMode(false, spectateTarget)
            Wait(200)
            spectateTarget = nil

            UncuffPed(myPed)
            SetEntityVisible(myPed, true)
            SetEntityInvincible(myPed, false)
            SetEntityCollision(myPed, true, true)
            NetworkSetEntityInvisibleToNetwork(myPed, false)
            FreezeEntityPosition(myPed, false)
        end
    else
        local ped = GetPlayerPed(GetPlayerFromServerId(target))
        if not spectating then
            RequestCollisionAtCoord(GetEntityCoords(ped))
            NetworkSetInSpectatorMode(true, ped)
            spectating = true
        else
            NetworkSetInSpectatorMode(false, ped)
            spectating = false
        end
    end
end

-- GET THE CLIENT'S INFO AND SEND BACK TO SOURCE
local function GetPlayerInfo(targetID)
    local info = ""
    local char = exports["soe-uchuu"]:GetPlayer()

    -- GRAB THE TARGET'S CHARACTER NAME
    if (char.FirstGiven == nil or char.LastGiven == nil) then
        info = "(Character Not Selected) | "
    else
        info = ("%s %s | "):format(char.FirstGiven, char.LastGiven)
    end

    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local location = exports["soe-utils"]:GetLocation(pos)

    -- GRAB THE TARGET'S SPEED
    local speed = 0.0
    local veh = GetVehiclePedIsIn(ped, false)
    if IsPedInAnyVehicle(ped, true) then
        speed = GetEntitySpeed(veh)
    else
        speed = GetEntitySpeed(ped)
    end

    local mph = math.floor(speed * 2.23694 + 0.5)
    local knots = math.floor(speed * 1.94384 + 0.5)
    local mySpeed = ("%s MPH | %s KNOTS"):format(mph, knots)

    -- GRAB THE TARGET'S DIRECTION
    local hdg = GetEntityHeading(ped)
    local direction = exports["soe-utils"]:GetDirection(hdg)

    -- GRAB THE TARGET'S VEHICLE INFO (IF ANY)
    if IsPedInAnyVehicle(ped, true) then
        local plate = GetVehicleNumberPlateText(veh)
        local primary, secondary = GetVehicleColours(veh)
        local color = exports["soe-utils"]:GrabVehicleColors()[tostring(primary)]

        local seat
        local seats = GetVehicleMaxNumberOfPassengers(veh)
        for i = -1, seats do
            if (GetPedInVehicleSeat(veh, i) == ped) then
                seat = i
            end
        end

        local name = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh)))
        info = ("%s In Vehicle (Seat: %s): %s %s | Plate: %s |"):format(info, seat, color, name, plate)
    else
        info = info .. " On Foot | "
    end

    -- GATHER ALL DATA
    info = ("%s Loc: %s"):format(info, location)
    info = ("%s | Heading: %s"):format(info, direction)
    info = ("%s at %s"):format(info, mySpeed)
    info = ("%s | Health: %s/200"):format(info, GetEntityHealth(ped))
    if exports["soe-healthcare"]:IsBleeding() then
        info = info .. " | Is Bleeding: Yes"
    end

    -- SEND DATA
    TriggerServerEvent("Fidelis:Server:SendPlayerInfo", targetID, info)
end

-- TOGGLES NOCLIP
local function ToggleNoclip()
    local ped = PlayerPedId()
    if not noclip then
        noclip = true
        FreezeEntityPosition(ped, true)

        while noclip do
            Wait(5)
            local h = GetEntityHeading(ped) + GetGameplayCamRelativeHeading()
            if h > 360 then
                h = 0 + (h - 360)
            elseif h < 0 then
                h = 360 - (h + 360)
            end

            SetEntityHeading(ped, h)
            if IsControlPressed(0, 32) then
                local vec = exports["soe-utils"]:CameraForwardVec()
                SetEntityCoords(ped, GetEntityCoords(ped) + (vec * noclipSpeeds[currentNoclipSpeed]) - vector3(0.0, 0.0, 0.9))
            end

            if IsControlPressed(0, 33) then
                local vec = exports["soe-utils"]:CameraForwardVec()
                SetEntityCoords(ped, GetEntityCoords(ped) - (vec * noclipSpeeds[currentNoclipSpeed]) - vector3(0.0, 0.0, 0.9))
            end

            if IsControlPressed(0, 34) then
                SetEntityCoords(ped, GetOffsetFromEntityInWorldCoords(ped, -1.0 * noclipSpeeds[currentNoclipSpeed], 0.0, -1.0))
            end

            if IsControlPressed(0, 35) then
                SetEntityCoords(ped, GetOffsetFromEntityInWorldCoords(ped, 1.0 * noclipSpeeds[currentNoclipSpeed], 0.0, -1.0))
            end

            if IsControlPressed(0, 38) then
                SetEntityCoords(ped, GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, 1.0 * noclipSpeeds[currentNoclipSpeed]))
            end

            if IsControlPressed(0, 85) then
                SetEntityCoords(ped, GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, -1.0 * noclipSpeeds[currentNoclipSpeed]))
            end
        end
    else
        noclip = false
        FreezeEntityPosition(ped, false)
	end
end

-- OPENS STAFF MENU
local function OpenMenu(playerList)
    -- CLEAR MENU IF ALREADY EXISTS
    staffMenu:ClearItems()

    -- SUBMENU DEFINITIONS
    local playerManagement = menuV:InheritMenu(staffMenu, {["title"] = false, ["subtitle"] = "Choose a player"})
    staffMenu:AddButton({icon = "🧍", label = "Player Management", value = playerManagement})
    for _, v in pairs(playerList) do
        local buttonText = ("%s <span style='float:right;'> [ID: %s]</span>"):format(v.name, v.id)
        local thisPlayer = menuV:InheritMenu(staffMenu, {["title"] = false, ["subtitle"] = v.name})
        playerManagement:AddButton({icon = "🧍", label = buttonText, value = thisPlayer})

        local healButton = thisPlayer:AddButton({icon = "❤️", label = "Heal", select = function()
            TriggerServerEvent("Fidelis:Server:MenuInteraction", v.id, {type = "Heal"})
        end})

        local reviveButton = thisPlayer:AddButton({icon = "💚", label = "Revive", select = function()
            TriggerServerEvent("Fidelis:Server:MenuInteraction", v.id, {type = "RevivePlayer"})
        end})

        local killButton = thisPlayer:AddButton({icon = "💀", label = "Kill", select = function()
            exports["soe-input"]:OpenConfirmDialogue("Are you sure you want to kill this player?", "Yes", "No", function(returnData)
                if returnData then
                    TriggerServerEvent("Fidelis:Server:MenuInteraction", v.id, {type = "KillPlayer"})
                end
            end)
        end})

        local freezeButton = thisPlayer:AddButton({icon = "🧊", label = "Freeze", select = function()
            TriggerServerEvent("Fidelis:Server:MenuInteraction", v.id, {type = "FreezePlayer"})
        end})

        local nourishButton = thisPlayer:AddButton({icon = "🥩", label = "Nourish", select = function()
            TriggerServerEvent("Fidelis:Server:MenuInteraction", v.id, {type = "Nourish"})
        end})

        local explodeButton = thisPlayer:AddButton({icon = "💣", label = "Explode", select = function()
            exports["soe-input"]:OpenConfirmDialogue("Are you sure you want to blow up " .. v.name, "Yes", "No", function(returnData)
                if returnData then
                    TriggerServerEvent("Fidelis:Server:MenuInteraction", v.id, {type = "Explode"})
                end
            end)
        end})

        local summonButton = thisPlayer:AddButton({icon = "👯", label = "Summon", select = function()
            TriggerServerEvent("Fidelis:Server:MenuInteraction", v.id, {type = "SummonToMe"})
        end})

        local teleportButton = thisPlayer:AddButton({icon = "👯", label = "Teleport To This Player", select = function()
            TriggerServerEvent("Fidelis:Server:MenuInteraction", v.id, {type = "TeleportToPlayer"})
        end})

        local setInstanceButton = thisPlayer:AddButton({icon = "🌐", label = "Set This Player's Instance", select = function()
            exports["soe-input"]:OpenInputDialogue("name", "Enter an instance ID (Default: global):", function(returnData)
                if (returnData ~= nil) then
                    TriggerServerEvent("Fidelis:Server:MenuInteraction", v.id, {type = "Set Instance", instanceID = returnData})
                end
            end)
        end})

        local takeScreenieButton = thisPlayer:AddButton({icon = "🎥", label = "Screenshot Player's Screen", select = function()
            TriggerServerEvent("Fidelis:Server:MenuInteraction", v.id, {type = "Screenshot"})
        end})

        local spectateButton = thisPlayer:AddButton({icon = "📷", label = "Spectate", select = function()
            DoSpectate(v.id)
        end})
        Wait(15)
    end

    local modTools = menuV:InheritMenu(staffMenu, {["title"] = false, ["subtitle"] = "Choose a mod tool"})
    staffMenu:AddButton({icon = "⚔️", label = "General Management", value = modTools})

    local jobToggles = menuV:InheritMenu(staffMenu, {["title"] = false, ["subtitle"] = "Choose a job to toggle"})
    modTools:AddButton({icon = "💼", label = "Toggle Job Duties", value = jobToggles})

    local validJobs = exports["soe-jobs"]:GetValidJobs()
    for job in pairs(validJobs) do
        local isOnDuty = (exports["soe-jobs"]:GetMyJob() == job)
        local dutyToggle = jobToggles:AddCheckbox({icon = "", label = job, description = "", value = isOnDuty, disabled = false});
        dutyToggle:On("check", function()
            TriggerServerEvent("Jobs:Server:ToggleDuty", {status = true, dutyStatus = true, job = job})
        end)
    
        dutyToggle:On("uncheck", function()
            TriggerServerEvent("Jobs:Server:ToggleDuty", {status = true, dutyStatus = false, job = job})
        end)
    end

    modTools:AddButton({icon = "❌", label = "Clear Chat Globally", select = function()
        exports["soe-input"]:OpenConfirmDialogue("Are you sure you want to globally clear the chat?", "Yes", "No", function(returnData)
            if returnData then
                ExecuteCommand("mod clearchat")
            end
        end)
    end})

    modTools:AddButton({icon = "🎩", label = "Open Appearance Menu", select = function()
        menuV:CloseAll()
        exports["soe-appearance"]:OpenAppearanceMenu("spawn", "Character Creation", "Create your character to your liking!", true, true)
    end})

    local modshopButton = modTools:AddButton({icon = "🧰", label = "Open Modshop Menu", select = function()
        menuV:CloseAll()
        exports["soe-shops"]:OpenModshopMenu(IsPedInAnyVehicle(PlayerPedId(), false), true, {staff = true, name = "Los Santos Customs"})
    end})

    local revivePlayersInDistance = modTools:AddButton({icon = "💞", label = "Revive Players Within Distance", select = function()
        menuV:CloseAll()
        TriggerServerEvent("Fidelis:Server:MenuInteraction", -1, {type = "Revive Players In Distance"})
    end})

    local explodeYourself = modTools:AddButton({icon = "💣", label = "Explode Yourself", select = function()
        exports["soe-input"]:OpenConfirmDialogue("Are you sure you want to blow yourself up?", "Yes", "No", function(returnData)
            if returnData then
                AddExplosion(GetEntityCoords(PlayerPedId()), 2, 100.0, true, false, 1.0)
            end
        end)
    end})

    local devTools = menuV:InheritMenu(staffMenu, {["title"] = false, ["subtitle"] = "Choose a dev tool"})
    staffMenu:AddButton({icon = "🛠️", label = "Development", value = devTools})

    devTools:AddButton({icon = "🚗", label = "Spawn Vehicle By Hash", select = function()
        exports["soe-input"]:OpenInputDialogue("name", "Enter Vehicle Hash:", function(returnData)
            if (returnData ~= nil) then
                ExecuteCommand("dev veh " .. returnData)
            end
        end)
    end})

    local spawnObjButton = devTools:AddButton({icon = "🚽", label = "Spawn Object By Hash", select = function()
        exports["soe-input"]:OpenInputDialogue("name", "Enter Object Hash:", function(returnData)
            if (returnData ~= nil) then
                local model = GetHashKey(returnData)
                if IsModelValid(model) then
                    exports["soe-utils"]:LoadModel(model, 15)
                    local obj = CreateObject(model, GetEntityCoords(PlayerPedId()), true, true, true)
                    SetModelAsNoLongerNeeded(model)
                else
                    exports["soe-ui"]:SendAlert("error", "Invalid Model", 4500)
                end
            end
        end)
    end})

    devTools:AddButton({icon = "🧍", label = "Spawn Ped By Hash", select = function()
        exports["soe-input"]:OpenInputDialogue("name", "Enter Ped Hash:", function(returnData)
            if (returnData ~= nil) then
                ExecuteCommand("dev spawn " .. returnData)
            end
        end)
    end})

    devTools:AddButton({icon = "🧑‍🤝‍🧑", label = "Clear Peds In A Radius", select = function()
        ExecuteCommand("dev clearpeds")
    end})

    devTools:AddButton({icon = "🌀", label = "Change Your Ped By Hash", select = function()
        exports["soe-input"]:OpenInputDialogue("name", "Enter Ped Hash:", function(returnData)
            if (returnData ~= nil) then
                ExecuteCommand("dev skin " .. returnData)
            end
        end)
    end})

    devTools:AddButton({icon = "🔐", label = "Park Vehicle by VIN", select = function()
        exports["soe-input"]:OpenInputDialogue("number", "Enter a valid VIN:", function(returnData)
            if (returnData ~= nil) then
                TriggerServerEvent("Valet:Server:ParkVehicleByVIN", tonumber(returnData), false)
            end
        end)
    end})

    local spawnByVinButton = devTools:AddButton({icon = "🚗", label = "Spawn Vehicle by VIN", select = function()
        exports["soe-input"]:OpenInputDialogue("number", "Enter a valid VIN:", function(returnData)
            if (returnData ~= nil) then
                ExecuteCommand("dev vin " .. returnData)
            end
        end)
    end})

    devTools:AddButton({icon = "🌐", label = "Set My Instance", select = function()
        exports["soe-input"]:OpenInputDialogue("name", "Enter an instance ID (Default: global):", function(returnData)
            if (returnData ~= nil) then
                TriggerServerEvent("Instance:Server:SetPlayerInstance", returnData)
            end
        end)
    end})

    local deleteObjButton = devTools:AddButton({icon = "🧱", label = "Delete Entity", select = function()
        menuV:CloseAll()
        DeleteAnEntity()
    end})

    local getZoneButton = devTools:AddButton({icon = "🗺️", label = "Get Current Zone", select = function()
        menuV:CloseAll()
        local zone = GetNameOfZone(GetEntityCoords(PlayerPedId()))
        exports["soe-ui"]:SendAlert("debug", "Zone: " .. tostring(zone), 6500)
    end})

    local vehTools = menuV:InheritMenu(staffMenu, {["title"] = false, ["subtitle"] = "Choose a vehicle tool"})
    staffMenu:AddButton({icon = "🚘", label = "Vehicle Management", value = vehTools})

    vehTools:AddButton({icon = "🔑", label = "Get Keys of Current Vehicle", select = function()
        menuV:CloseAll()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if (veh == 0) then
            menuV:CloseAll()
            exports["soe-ui"]:SendAlert("error", "Make sure you are inside a vehicle", 5000)
            return
        end

        exports["soe-valet"]:UpdateKeys(veh)
        exports["soe-ui"]:SendAlert("success", "Keys given!", 5000)
    end})

    vehTools:AddButton({icon = "⛽", label = "Set Vehicle Fuel Level", select = function()
        exports["soe-input"]:OpenInputDialogue("name", "Enter fuel level:", function(returnData)
            if (returnData ~= nil) then
                ExecuteCommand("mod fuel " .. tonumber(returnData))
            end
        end)
    end})

    local getMaxVehSpeedButton = vehTools:AddButton({icon = "🏎️", label = "Get Vehicle's Estimate Max Speed", select = function()
        menuV:CloseAll()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local maxSpeed = GetVehicleEstimatedMaxSpeed(veh)

        exports["soe-ui"]:SendAlert("debug", "GTA Speed: " .. maxSpeed, 12500)
        exports["soe-ui"]:SendAlert("debug", "MPH: " .. maxSpeed * 2.23694, 12500)
        exports["soe-ui"]:SendAlert("debug", "KMH: " .. maxSpeed * 3.6, 12500)
    end})

    local getBasicVehDataButton = vehTools:AddButton({icon = "🚙", label = "Get Vehicle Basic Data", select = function()
        menuV:CloseAll()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local hash = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
        local class = GetVehicleClass(veh)

        exports["soe-ui"]:SendAlert("debug", "Hash: " .. hash, 12500)
        exports["soe-ui"]:SendAlert("debug", "Class: " .. class, 12500)
    end})

    vehTools:AddButton({icon = "📡", label = "Register Vehicle As Networked", select = function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if (veh == 0) then
            menuV:CloseAll()
            exports["soe-ui"]:SendAlert("error", "Make sure you are inside a vehicle", 5000)
            return
        end
    
        print(("Is Vehicle Networked? [Veh ID: %s] [Is Networked: %s]"):format(veh, NetworkGetEntityIsNetworked(veh)))
        for i = 1, 2 do
            exports["soe-utils"]:RegisterEntityAsNetworked(veh)
            Wait(100)
        end

        for i = 1, 2 do
            exports["soe-utils"]:GetEntityControl(veh)
            Wait(100)
        end
        print(("Obtained NetID for [Veh ID: %s] [Plate: %s] [VIN: %s]"):format(veh, GetVehicleNumberPlateText(veh), DecorGetInt(veh, "vin")))
        print(("Is Vehicle Networked? [Veh ID: %s] [Is Networked: %s]"):format(veh, NetworkGetEntityIsNetworked(veh)))
        print("Owner's Server ID is:", tostring(NetworkGetEntityOwner(veh)))
    end})

    staffMenu:Open()
end

-- ON MENU CLOSED
staffMenu:On("close", function(menu)
    collectgarbage("collect")
end)

-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, RESETS IDLE TIMER
function ResetIdleTimer()
    idleMinutes = 30
end

-- **********************
--       Commands
-- **********************
RegisterCommand("noclip_speed", function()
    if noclip then
        currentNoclipSpeed = currentNoclipSpeed + 1
        if (noclipSpeeds[currentNoclipSpeed] == nil) then
            currentNoclipSpeed = 1
        end
        exports["soe-ui"]:SendAlert("warning", "Noclip Speed: " .. noclipSpeedNames[currentNoclipSpeed], 250)
    end
end)

-- **********************
--        Events
-- **********************
-- CALLED WHEN MENU COMMAND IS EXECUTED
RegisterNetEvent("Fidelis:Client:OpenMenu", OpenMenu)

-- CALLED FROM SERVER AFTER "/warppoi" IS EXECUTED
RegisterNetEvent("Fidelis:Client:WarpPOI", function(x, y, z)
    AuthorizeTeleport()
    SetPedCoordsKeepVehicle(PlayerPedId(), x, y, z)
end)

-- MENU INTERACTION EVENT
RegisterNetEvent("Fidelis:Client:MenuInteraction", function(data)
    if not data.status then return end

    local ped = PlayerPedId()
    if (data.type == "KillPlayer") then
        SetEntityHealth(ped, 0)
    elseif (data.type == "Explode") then
        AddExplosion(data.pos, 2, 100.0, true, false, 1.0)
    end
end)

-- CALLED FROM SERVER AFTER "/warpwp" IS EXECUTED
RegisterNetEvent("Fidelis:Client:WarpWP", function()
    local blip = GetFirstBlipInfoId(8)
    if (blip ~= 0) then
        local ped = PlayerPedId()
        local pos = GetBlipInfoIdCoord(blip)
        AuthorizeTeleport()
        SetPedCoordsKeepVehicle(ped, pos.x, pos.y, 100.0)

        Wait(50)
        local found, newZ = GetGroundZFor_3dCoord(pos.x, pos.y, 5000.0, false)
        while not found do
            Wait(3)
            found, newZ = GetGroundZFor_3dCoord(pos.x, pos.y, 5000.0, found, false)
        end
        AuthorizeTeleport()
        SetPedCoordsKeepVehicle(ped, pos.x, pos.y, newZ)
    end
end)

-- CALLED BY THE SERVER TO USE DEV TOOLS
RegisterNetEvent("Fidelis:Client:DevTools", function(tool)
    -- IF NO TOOL WAS PROVIDED
    if not tool then return end

    -- SPAWNING VEHICLES
    if (tool.type == "SpawnVeh") then
        if IsModelValid(GetHashKey(tool.veh)) then
            -- CREATE VEHICLE AND PUT PED IN THE DRIVER SEAT
            local veh = exports["soe-utils"]:SpawnVehicle(tool.veh, vector4(tool.pos.x, tool.pos.y, tool.pos.z, tool.hdg))
            local plate = exports["soe-utils"]:GenerateRandomPlate()
            SetVehicleNumberPlateText(veh, plate)

            SetPedIntoVehicle(GetPlayerPed(GetPlayerFromServerId(tool.ped)), veh, -1)
            Wait(500)

            -- GIVE KEYS AND SET RENTAL STATUS
            exports["soe-valet"]:UpdateKeys(veh)
            exports["soe-utils"]:SetRentalStatus(veh)
        else
            exports["soe-ui"]:SendAlert("error", "Invalid Model", 5000)
        end
    -- TOGGLE DEBUG TOOL
    elseif (tool.type == "ToggleDebug") then
        exports["soe-utils"]:EntityDebugger()
    -- TOGGLE MINIMAP
    elseif (tool.type == "ToggleMinimap") then
        map = not map
        exports["soe-ui"]:ToggleMinimap(map)
    -- PERFORM DRAG RACE TO TEST VEHICLE SPEED
    elseif (tool.type == "DragRace") then
        DragRaceVehicleTest()
    -- TOGGLE NOCLIP
    elseif (tool.type == "Noclip") then
        ToggleNoclip()
    -- ENTER DICTIONARY AND NAME TO TEST AN ANIMATION
    elseif (tool.type == "PlayAnimation") then
        local flag
        if not tool.flag then
            flag = 1
        else
            flag = tool.flag
        end
        exports["soe-utils"]:LoadAnimDict(tool.dict, 15)
        TaskPlayAnim(PlayerPedId(), tool.dict, tool.anim, 8.0, 8.0, -1, tonumber(flag), 0, 0, 0, 0)
    -- IMMEDIATELY CANCEL ANY ANIMATION
    elseif (tool.type == "CancelAnimation") then
        ClearPedTasksImmediately(PlayerPedId())
    -- CHANGES YOUR SKIN
    elseif (tool.type == "ChangeSkin") then
        local model = GetHashKey(tool.ped)
        if IsModelValid(model) then
            exports["soe-utils"]:LoadModel(model, 15)
            SetPlayerModel(PlayerId(), model)
            if (model ~= "mp_f_freemode_01" and model ~= "mp_m_freemode_01") then
                SetPedRandomComponentVariation(PlayerPedId(), true)
            end
            SetModelAsNoLongerNeeded(model)
        else
            exports["soe-ui"]:SendAlert("error", "Invalid Model", 4500)
        end
    -- CLEARS PEDS IN A RADIUS
    elseif (tool.type == "ClearPeds") then
        local done = false
        local handle, ped = FindFirstPed()
        repeat
            done, ped = FindNextPed(handle)
            if not IsPedAPlayer(ped) then
                TriggerServerEvent("Utils:Server:DeleteEntity", PedToNet(ped))
            end
        until not done
        EndFindPed(handle)
    -- SPAWNS AN NPC PED
    elseif (tool.type == "SpawnPed") then
        local model = GetHashKey(tool.ped)
        if IsModelValid(model) then
            exports["soe-utils"]:LoadModel(model)
            local myPed = CreatePed(28, model, GetEntityCoords(PlayerPedId()), 0.0, true, false)
            TaskWanderStandard(myPed, 10.0, 10)
        else
            exports["soe-ui"]:SendAlert("error", "Invalid Model", 4500)
        end
    -- SPAWNS VEHICLE BY VIN
    elseif (tool.type == "Spawn Vehicle By VIN") then
        -- LOAD AND SPAWN THE MODEL
        exports["soe-utils"]:LoadModel(GetHashKey(tool.vehData.VehHash), 15)
        local veh = exports["soe-utils"]:SpawnVehicle(tool.vehData.VehHash, vector4(tool.pos.x, tool.pos.y, tool.pos.z, tool.hdg))

        exports["soe-shops"]:LoadVehicleMods(veh, tool.vehData.VehCustomization)
        SetPedIntoVehicle(PlayerPedId(), veh, -1)

        -- SET VEHICLE DECORS
        DecorSetBool(veh, "unlocked", false)
        DecorSetBool(veh, "playerOwned", true)
        DecorSetInt(veh, "vin", tonumber(tool.vehData.VehicleID))

        -- LOCK THE VEHICLE BY DEFAULT AND SET PLATE
        SetVehicleDoorsLocked(veh, 2)
        SetVehicleNumberPlateText(veh, tool.vehData.VehRegistration)

        -- GIVE KEYS AND SET FUEL AND SET DAMAGE
        exports["soe-fuel"]:SetFuel(veh, tool.vehData.Fuel)
        local netID = NetworkGetNetworkIdFromEntity(veh)
        SetNetworkIdExistsOnAllMachines(netID, true)

        exports["soe-valet"]:UpdateKeys(veh)
        TriggerServerEvent("Valet:Server:RegisterVehicleSpawned", tool.vehData, netID)
    end
end)

-- CALLED BY THE SERVER TO USE STAFF TOOLS
RegisterNetEvent("Fidelis:Client:StaffTools", function(tool)
    -- IF NO TOOL WAS PROVIDED
    if not tool then return end

    -- HEALS YOURSELF
    if (tool.type == "Heal") then
        SetEntityHealth(PlayerPedId(), 200)
        exports["soe-healthcare"]:HealInjuriesAndBleeding()
    -- TOGGLE PLAYER BLIPS AND SHOW IDs
    elseif (tool.type == "ToggleMeta") then
        MetaTool()
    -- TELEPORTS TO SPECIFIED PLAYER
    elseif (tool.type == "TeleportToPlayer") then
        local ped = GetPlayerPed(GetPlayerFromServerId(tool.ped))
        AuthorizeTeleport()
        SetEntityCoords(ped, tool.pos)
    -- TELEPORTS SPECIFIED PLAYER TO YOU
    elseif (tool.type == "SummonToMe") then
        AuthorizeTeleport()
        SetEntityCoords(PlayerPedId(), tool.pos)
    -- REPAIRS CURRENT VEHICLE
    elseif (tool.type == "Fix") then
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        TriggerServerEvent("Utils:Server:SyncVehicleRepair", {status = true, entity = VehToNet(veh)})
        --exports["soe-utils"]:RepairVehicle(veh)
    -- GET INFORMATION FROM SPECIFIED PLAYER
    elseif (tool.type == "GatherInfo") then
        GetPlayerInfo(tool.src)
    -- FREEZE SPECIFIED PLAYER
    elseif (tool.type == "FreezePlayer") then
        local ped = PlayerPedId()
        frozen = not frozen
        if frozen then
            SetEnableHandcuffs(ped, false)
            FreezeEntityPosition(ped, false)
            if IsPedInAnyVehicle(ped, false) then
                local veh = GetVehiclePedIsIn(ped, false)
                FreezeEntityPosition(veh, false)
            end 
        else
            SetEnableHandcuffs(ped, true)
            FreezeEntityPosition(ped, true)
            if IsPedInAnyVehicle(ped, false) then
                local veh = GetVehiclePedIsIn(ped, false)
                FreezeEntityPosition(veh, true)
            end 
        end
    -- SPECTATE SPECIFIED PLAYER
    elseif (tool.type == "SpectatePlayer") then
        DoSpectate(tool.target)
    -- SETS FUEL OF CURRENT VEHICLE
    elseif (tool.type == "SetFuel") then
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        exports["soe-fuel"]:SetFuel(veh, tool.fuel)
    -- TOGGLES INVISIBILITY
    elseif (tool.type == "ToggleInvis") then
        local ped = PlayerPedId()
        local toggle = IsEntityVisible(ped)
        SetEntityInvincible(ped, toggle)
        SetEntityVisible(ped, not toggle, 0)
        NetworkSetEntityInvisibleToNetwork(ped, toggle)
    -- FILLS HUNGER/THIRST UP
    elseif (tool.type == "Nourish") then
        exports["soe-nutrition"]:SetLevels(250, 250)
    end
end)
