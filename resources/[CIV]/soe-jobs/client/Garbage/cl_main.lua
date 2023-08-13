-- LOCAL VARIABLES
SOEMenu = assert(MenuV)
local sanitationMenuMain = SOEMenu:CreateMenu(false, "Select an option below", 'topright', 255, 255, 255, 'size-100', 'default', 'menuv', 'sanitationMenuMain', 'native')
sanitationMenuRadius = 1.25
isSanitationMenuOpen = false

local jobBlips = {
    ["GARBAGE"] = {}
}

sanitationJobStart = false

local myVeh = nil
local hasVehicle = false
hasRubbish = false
roleID = 0
doingAction = false
isOnSanitationDuty = false
currentRole = sanitationJobRoles[0].roleName

-- **********************
--       Functions
-- **********************

-- THIS WILL SET THE PLAYER ON/OFF CLUCKIN BELL JOB
function ClockinSanitation(bool)
    isOnSanitationDuty = bool
    TriggerServerEvent("Jobs:Server:ToggleDuty", {status = true, dutyStatus = isOnSanitationDuty, job = "GARBAGE"})
    --print("GARBAGE CLOCKIN", isOnSanitationDuty)
end

local function closeMenus()
    sanitationMenuMain:ClearItems()
    SOEMenu:CloseAll()
    isSanitationMenuOpen = false
end

-- CHECKS IF PLAYER IS CLOSE TO A RUBBISH BAG
local function IsCloseToRubbish()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local isCloseToRubbish = false
    for index = 1, #rubbishBags do
        rubbishBag = GetClosestObjectOfType(playerCoords, 1.0, GetHashKey(rubbishBags[index]), 0, 0, 0)
        if DoesEntityExist(rubbishBag) and not IsEntityAttached(rubbishBag) then
            isCloseToRubbish = true
        end
    end

    --print("IsCloseToRubbish", isCloseToRubbish)
    return isCloseToRubbish
end

-- PICKUP RUBBISH NEAR PLAYER
local function PickupRubbishBag()
    if not doingAction and not hasRubbish then
        --print("GIVING RUBBISH BAG")
        doingAction = true
        hasRubbish = true

        -- DELETE NEAREST RUBBISH PROP
        local playerCoords = GetEntityCoords(PlayerPedId())

        for index = 1, #rubbishBags do
            rubbishBag = GetClosestObjectOfType(playerCoords, 1.0, GetHashKey(rubbishBags[index]), 0, 0, 0)
            if DoesEntityExist(rubbishBag) then
                TriggerServerEvent("Utils:Server:DeletePropAtXYZ", rubbishBags[index], playerCoords)
                break
            end
        end

        exports["soe-ui"]:SendAlert("success", sanitationJobRoles[roleID].rolePickedup, 2500)
        doingAction = false

        -- REMOVE INTERACTION UI IF IT'S SHOWING
        if sanitationJobRoles[roleID].interactionShowing then
            exports["soe-ui"]:HideTooltip()
            sanitationJobRoles[roleID].interactionShowing = false
        end
    else
        --print("REMOVING RUBBISH BAG")
        hasRubbish = false
        ClearPedTasks(PlayerPedId())
        exports["soe-emotes"]:EliminateAllProps()
    end
end

-- CHECKS IF PLAYER IS CLOSE TO THEIR GARBAGE TRUCK
local function IsCloseToGarbageTruck()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local vehicle = nil
    local isCloseToGarbageTruck = false

    -- CHECK WHETHER THE PLAYERS LAST VEHICLE IS A GARBAGE TRUCK
    local lastVehicle = GetPlayersLastVehicle()
    local lastVehModel = GetEntityModel(lastVehicle)

    if lastVehModel == sanitationJobRoles[roleID].vehicleModelHash then
        vehicle = lastVehicle
    end

    -- GET THE DISTANCE THE PLAYER IS FROM THE REAR DOORS OF THE GARBAGE TRUCK
    local rearOfTrashTruck = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "boot"))
    local truckTrunkdistance = #(playerCoords - rearOfTrashTruck)

    --print("truckTrunkdistance", truckTrunkdistance)
    if truckTrunkdistance <= 2.75 then
        isCloseToGarbageTruck = true
    end

    --print("IsCloseToGarbageTruck", isCloseToGarbageTruck)
    return isCloseToGarbageTruck
end

local function ThrowRubbishInTruck()
    if not doingAction and hasRubbish then
        doingAction = true
        local pos = GetEntityCoords(PlayerPedId())
        local vehicle = nil

        -- CHECK WHETHER THE PLAYERS LAST VEHICLE IS A GARBAGE TRUCK
        local lastVehicle = GetPlayersLastVehicle()
        local lastVehModel = GetEntityModel(lastVehicle)

        if lastVehModel == sanitationJobRoles[roleID].vehicleModelHash then
            vehicle = lastVehicle
        end

        sanitationJobRoles[roleID].quantity = nil
        local vehiclePlate = GetVehicleNumberPlateText(vehicle)
        TriggerServerEvent("Jobs:Server:Garbage:GetTruckRubbishCount", {status = true, vehiclePlate = vehiclePlate})

        while sanitationJobRoles[roleID].quantity == nil do
            Wait(100)
        end

        -- ADD RUBBISH TO TRUCK IF NOT FULL
        if sanitationJobRoles[roleID].quantity < sanitationJobRoles[roleID].maxQuantity then
            TriggerServerEvent("Jobs:Server:Garbage:UpdateTruckRubbish", {status = true, vehiclePlate = vehiclePlate, amount = 1, roleID = roleID})
        elseif sanitationJobRoles[roleID].quantity >= sanitationJobRoles[roleID].maxQuantity then
            exports["soe-ui"]:SendAlert("success", sanitationJobRoles[roleID].roleTruckForce, 5000)
        end

        -- REMOVE THE RUBBISH
        hasRubbish = false
        ClearPedTasks(PlayerPedId())
        exports["soe-emotes"]:EliminateAllProps()
        doingAction = false

        -- REMOVE INTERACTION UI IF IT'S SHOWING
        if sanitationJobRoles[roleID].interactionShowing then
            exports["soe-ui"]:HideTooltip()
            sanitationJobRoles[roleID].interactionShowing = false
        end
    end

end

-- CHECKS IF PLAYER IS CLOSE TO A GARBAGE DEPOT
local function IsCloseToRubbishDropOff()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local isCloseToRubbishDropOff = false
    for _, data in pairs(sanitationStartCoords) do
        local distance = #(playerCoords - data.dropOff)
        if distance < 5.0 then
            isCloseToRubbishDropOff = true
        end
    end
    --print("IsCloseToRubbishDropOff", isCloseToRubbishDropOff)
    return isCloseToRubbishDropOff
end

local function EmptyGarbageTruck()
    if not doingAction then
        doingAction = true
        local pos = GetEntityCoords(PlayerPedId())
        local vehicle = nil

        -- CHECK WHETHER THE PLAYERS LAST VEHICLE IS A GARBAGE TRUCK
        local lastVehicle = GetPlayersLastVehicle()
        local lastVehModel = GetEntityModel(lastVehicle)

        if lastVehModel == sanitationJobRoles[roleID].vehicleModelHash then
            vehicle = lastVehicle
        end

        local charID = exports["soe-uchuu"]:GetPlayer().CharID
        local vehiclePlate = GetVehicleNumberPlateText(vehicle)
        TriggerServerEvent("Jobs:Server:Garbage:EmptyTruck", {status = true, charID = charID, vehiclePlate = vehiclePlate, roleID = roleID})
        Wait(1000)
        doingAction = false

        -- REMOVE INTERACTION UI IF IT'S SHOWING
        if sanitationJobRoles[roleID].interactionShowing then
            exports["soe-ui"]:HideTooltip()
            sanitationJobRoles[roleID].interactionShowing = false
        end
    end
end

-- JOB INTERACTION MENU
local function JobInteractionMenu(menuIndex)
    jobRoles[0].menuIndex = menuIndex
    sanitationMenuMain:ClearItems()
    sanitationMenuMain:SetTitle(jobTitle)
    local inspectButton = sanitationMenuMain:AddButton({ icon = '🔍', label = 'Job Info', select = function()
        --print("JOB INFO")
        TriggerEvent("Chat:Client:SendMessage", "center", jobTitle)
        TriggerEvent("Chat:Client:SendMessage", "linebreak")
        for index = 1, #sanitationJobRoles do
            TriggerEvent("Chat:Client:Message", sanitationJobRoles[index].roleIcon .." ".. sanitationJobRoles[index].roleName, sanitationJobRoles[index].roleDescription)
        end
        TriggerEvent("Chat:Client:SendMessage", "linebreak")
    end})

    local currentRoleButton = sanitationMenuMain:AddButton({ icon = '💼', label = 'Current Job', select = function()
        local jobString = string.format("You don't work here!", currentRole)
        if currentRole ~= sanitationJobRoles[0].roleName then
            jobString = string.format("Your current job is a %s.", string.lower(currentRole))
        end
        TriggerEvent("Chat:Client:Message", jobTitle, jobString, "taxi")
    end})

    local shopButton = sanitationMenuMain:AddButton({ icon = '🛒', label = 'Browse Shop', select = function()
        TriggerEvent("Shops:Client:BrowseStore")
        closeMenus()
    end})

    -- ADD AVAILABLE JOB BUTTONS
    if roleID == 0 then
        local garbageCollectorButton = sanitationMenuMain:AddButton({ icon = '🗑️', label = 'Garbage Collector', select = function()
            sanitationJobStart = false
            roleID = 1
            currentRole = sanitationJobRoles[1].roleName
            TriggerEvent("Chat:Client:Message", jobTitle, sanitationJobRoles[roleID].roleStartText, "taxi")
            ClockinSanitation(true)
            closeMenus()
        end})
    else
        local charID = exports["soe-uchuu"]:GetPlayer().CharID
        garbagePayTable = exports["soe-nexus"]:TriggerServerCallback("Jobs:Server:Garbage:GetPayTable")

        if garbagePayTable[charID] ~= nil and garbagePayTable[charID] > 0 then
            local collectPayButton = sanitationMenuMain:AddButton({ icon = '💰', label = 'Collect Pay', select = function()
                if not doingAction then
                    doingAction = true
                    TriggerServerEvent("Jobs:Server:Garbage:CollectPay", {status = true})
                    closeMenus()
                    Wait(1000)
                    doingAction = false
                end
            end})
        end

        if not hasVehicle then
            local getVehicleButton = sanitationMenuMain:AddButton({ icon = '⛟', label = 'Checkout Trashmaster', select = function()
                hasVehicle = true
                myVeh = nil
                local playerCoords = GetEntityCoords(PlayerPedId())
                -- DISTANCE CHECK
                distance = #(playerCoords - sanitationStartCoords[jobRoles[0].menuIndex].pos)
                if distance <= sanitationMenuRadius then
                    -- SPAWN JOB VEHICLE AND GIVE PLAYER THE KEYS
                    myVeh = exports["soe-utils"]:SpawnVehicle(sanitationJobRoles[roleID].vehicleModelHash, sanitationStartCoords[jobRoles[0].menuIndex].spawn)
                    local plate = exports["soe-utils"]:GenerateRandomPlate()
                    SetVehicleNumberPlateText(myVeh, plate)
                    Wait(500)

                    exports["soe-valet"]:UpdateKeys(myVeh)

                    -- SET IT AS A RENTAL
                    exports["soe-utils"]:SetRentalStatus(myVeh)
                    SetEntityAsMissionEntity(myVeh, true, true)
                    DecorSetBool(myVeh, "noInventoryLoot", true)
                end
                TriggerEvent("Chat:Client:Message", jobTitle, sanitationJobRoles[roleID].roleCheckoutVehicle, "taxi")

                closeMenus()
            end})
        else
            local returnVehicleButton = sanitationMenuMain:AddButton({ icon = '⛟', label = 'Return Trashmaster', select = function()
                local workVeh = nil

                -- CHECK WHETHER THE PLAYERS LAST VEHICLE IS A GARBAGE TRUCK
                local lastVehicle = GetPlayersLastVehicle()
                local lastVehModel = GetEntityModel(lastVehicle)

                if lastVehModel == sanitationJobRoles[roleID].vehicleModelHash then
                    if lastVehicle == myVeh then
                        workVeh = myVeh
                    else
                        workVeh = lastVehicle
                    end

                    local playerCoords = GetEntityCoords(PlayerPedId())
                    local workVehCoords = GetEntityCoords(workVeh)

                    -- DISTANCE CHECK
                    local distance = #(playerCoords - workVehCoords)
                    if distance <= 500.0 then
                        -- RESET VARIABLES IF PLAYER IS RETURNING A GARBAGE TRUCK THEY RENTED
                        local returnMessage = sanitationJobRoles[roleID].roleReturnAVehicle
                        if workVeh == myVeh then
                            hasVehicle, myVeh = false, nil
                            returnMessage = sanitationJobRoles[roleID].roleReturnWorkVehicle
                        end

                        -- SHOW RETURN MESSAGE
                        TriggerEvent("Chat:Client:Message", jobTitle, returnMessage, "taxi")

                        -- DELETE THE VEHICLE
                        TriggerServerEvent("Utils:Server:DeleteEntity", VehToNet(workVeh))
                    else
                        TriggerEvent("Chat:Client:Message", jobTitle, sanitationJobRoles[roleID].roleVehicleTooFar, "taxi")
                    end
                else
                    TriggerEvent("Chat:Client:Message", jobTitle, sanitationJobRoles[roleID].roleVehicleNotFound, "taxi")
                end
                closeMenus()
            end})
        end

        local quitButton = sanitationMenuMain:AddButton({ icon = '❌', label = 'Quit', select = function()
            -- END ROLE NOTIFICATION MESSAGES
            TriggerEvent("Chat:Client:Message", jobTitle, "One less worker to pay!", "taxi")

            -- RESET VARIABLES
            roleID = 0
            hasRubbish = false
            sanitationJobStart = false
            currentRole = sanitationJobRoles[0].roleName

            -- END JOB
            ClockinSanitation(false)
            closeMenus()
        end})
    end

    -- OPEN MENU AND FREEZE PLAYER/CONTROLS
    sanitationMenuMain:Open()
    isSanitationMenuOpen = true
    while isSanitationMenuOpen do
        Wait(5)
        DisableControlAction(0, 23)
        DisableControlAction(0, 75)
    end
end

-- JOB START
function SanitationJobStart()
    sanitationJobStart = true

    for index, data in pairs(sanitationStartCoords) do
        if jobBlips["GARBAGE"][index] == nil then
            jobBlips["GARBAGE"][index] = AddBlipForCoord(data.dropOff)
            SetBlipSprite(jobBlips["GARBAGE"][index], 318)
            SetBlipColour(jobBlips["GARBAGE"][index], 71)
            SetBlipScale(jobBlips["GARBAGE"][index], 0.6)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(string.format("Rubbish drop off"))
            EndTextCommandSetBlipName(jobBlips["GARBAGE"][index])
        end
    end

    -- CREATE MARKERS FOR JOB ROLE
    CreateThread(function()
        while isOnSanitationDuty and sanitationJobStart do
            Wait(20)
            if not hasRubbish and IsCloseToRubbish() then
                if not sanitationJobRoles[roleID].interactionShowing then
                    --print("CLOSE TO RUBBISH")
                    exports["soe-ui"]:ShowTooltip("fas fa-truck-loading", "[E] " .. sanitationJobRoles[roleID].roleCollectRubbish, "inform")
                    sanitationJobRoles[roleID].interactionShowing = true
                end
            elseif hasRubbish and IsCloseToGarbageTruck() then
                if not sanitationJobRoles[roleID].interactionShowing then
                    --print("CLOSE TO RUBBISH TRUCK")
                    exports["soe-ui"]:ShowTooltip("fas fa-truck-loading", "[E] " .. sanitationJobRoles[roleID].roleThrowInTruck, "inform")
                    sanitationJobRoles[roleID].interactionShowing = true
                end
            elseif IsCloseToRubbishDropOff() and IsCloseToGarbageTruck() then
                if not sanitationJobRoles[roleID].interactionShowing then
                    --print("CLOSE TO RUBBISH DROPOFF")
                    exports["soe-ui"]:ShowTooltip("fas fa-truck-loading", "[E] " .. sanitationJobRoles[roleID].roleDropOff, "inform")
                    sanitationJobRoles[roleID].interactionShowing = true
                end
            else
                -- REMOVE INTERACTION UI IF IT'S SHOWING
                if sanitationJobRoles[roleID].interactionShowing then
                    exports["soe-ui"]:HideTooltip()
                    sanitationJobRoles[roleID].interactionShowing = false
                end
            end
        end

        -- REMOVE BLIPS ON THREAD END
        for index in pairs(sanitationStartCoords) do
            if jobBlips["GARBAGE"][index] ~= nil then
                RemoveBlip(jobBlips["GARBAGE"][index])
                jobBlips["GARBAGE"][index] = nil
            end
        end
    end)
end

-- ON MENU CLOSED, UNFREEZE AND RESET VEHICLE MODS TO WHAT THEY WERE BEFORE
sanitationMenuMain:On('close', function(menu)
    closeMenus()
end)

-- SENT FROM SEVER TO GET RUBBISH IN TRUCK
RegisterNetEvent("Jobs:Client:GetRubbishCountInTruck")
AddEventHandler("Jobs:Client:GetRubbishCountInTruck", function(serverGarbageCount)
    sanitationJobRoles[roleID].quantity = serverGarbageCount
end)

-- SENT FROM CLIENT TO GIVE PAY DATA
RegisterNetEvent("Jobs:Client:GetGarbagePayDataForCharID")
AddEventHandler("Jobs:Client:GetGarbagePayDataForCharID", function(payFromServer)
    local charID = exports["soe-uchuu"]:GetPlayer().CharID
    if payFromServer ~= nil then
        garbagePayTable[charID] = payFromServer
    else
        garbagePayTable[charID] = 0
    end
end)

-- INTERACTION KEYPRESS
AddEventHandler("Utils:Client:InteractionKey", function()
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
        return
    end

    -- CHECK IF NEAR A GARBAGE START LOCATION
    local playerCoords, distance = GetEntityCoords(PlayerPedId()), nil
    for index, data in pairs(sanitationStartCoords) do
        distance = #(playerCoords - data.pos)
        if distance <= sanitationMenuRadius then
            JobInteractionMenu(index)
            break
        end
    end

    if sanitationJobStart then
        if IsCloseToRubbish() and not hasRubbish then
            PickupRubbishBag()
            --print("PICKUP RUBBISH")
        elseif IsCloseToGarbageTruck() and hasRubbish then
            ThrowRubbishInTruck()
            --print("THROW RUBBISH IN TRUCK")
        elseif IsCloseToRubbishDropOff() and IsCloseToGarbageTruck() then
            EmptyGarbageTruck()
            --print("EMPTY TRUCK")
        end
    end
end)

-- DEBUG
--[[RegisterCommand("san", function()
    JobInteractionMenu()
    isSanitationMenuOpen = false
end)

RegisterCommand("rubbish", function()
    hasRubbish = true
end)]]
