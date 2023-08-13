local myVeh = nil
local cooldown = 0
local isOnDuty = false
local jobBlips = {}
local hasPackage = false
local serverPackagesDelivered = nil
local serverPayRate = nil
local serverMaxPay = nil
local minimap = false

-- GOPOSTAL LOCATIONS TO START/END JOB AND SPAWN DELIVERY VEHICLE
local goPostalDepots = {
    [1] = {pos = vector3(69.05, 127.35, 78.21), spawn = vector4(61.92, 125.04, 78.2, 156.22)},
    --[2] = {pos = vector3(-286.58, -1061.77, 27.21), spawn = vector4(-273.42, -1064.16, 24.92, 154.88)}	-- DEBUG (ALTA BANNER)
}

-- CHECKS IF PLAYER IS CLOSE TO A GOPOSTAL DEPOT
function IsCloseToGoPostalDepot()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    for _, data in pairs(goPostalDepots) do
        local distance = Vdist2(pos, data.pos)
        if (distance < 8.5) then
            return true
        end
    end
    return false
end

-- CHECKS IF PLAYER IS CLOSE TO THEIR GOPOSTAL TRUCK
function IsCloseToGoPostalTruck()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local vehicle = nil

    -- CHECK WHETHER THE PLAYERS LAST VEHICLE IS A GOPOSTAL TRUCK
    local lastVehicle = GetPlayersLastVehicle()
    local lastVehModel = GetEntityModel(lastVehicle)
    local modelHashKey = GetHashKey("boxville2")

    --[[print("lastVehModel: " .. tostring(lastVehModel))
    print("modelHashKey: " .. tostring(modelHashKey))]]

    if lastVehModel == modelHashKey then
        --print("MATCH")
        vehicle = lastVehicle
    end

    -- GET THE DISTANCE THE PLAYER IS FROM THE REAR DOORS OF THE GOPOSTAL TRUCK
    local goPostalRearLeftdistance = Vdist2(pos, GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "door_dside_r")))
    local goPostalRearRightdistance = Vdist2(pos, GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "door_pside_r")))

    --[[print("goPostalRearLeftdistance: " ..tostring(goPostalRearLeftdistance))
    print("goPostalRearRightdistance: " ..tostring(goPostalRearRightdistance))]]

    if goPostalRearLeftdistance <= 2.0 or goPostalRearRightdistance <= 2.0 then
        return true
    end

    return false
end

-- CHECKS IF PLAYER IS CLOSE TO A PACKAGE DESTINATION
function IsCloseToGoPostalPackageDestination()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    for _, data in pairs(goPostalPackageDestinations) do
        local distance = Vdist2(pos, data.pos)
        if (distance < 4.0) then
            return true
        end
    end
    return false
end

function GetHasGoPostalPackage()
    return hasPackage
end

function GetHasGoPostalPayToCollect()
    local charID = exports["soe-uchuu"]:GetPlayer().CharID
    return goPostalPayTable[charID]
end

function GetMyGoPostalTruck()
    return myVeh
end

-- FUNCTION TO SPAWN DELIVERY VEHICLE
local function SpawnDeliveryVehicle()
    if myVeh == nil then
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        for _, data in pairs(goPostalDepots) do
            -- DISTANCE CHECK
            local distance = Vdist2(pos, data.pos)
            if (distance < 8.5) then
                if myVeh == nil and isOnDuty then
                    -- SPAWN DELIVERY VEHICLE AND GIVE PLAYER THE KEYS
                    myVeh = exports["soe-utils"]:SpawnVehicle("boxville2", data.spawn)
                    local plate = exports["soe-utils"]:GenerateRandomPlate()
                    SetVehicleNumberPlateText(myVeh, plate)
                    Wait(500)

                    exports["soe-valet"]:UpdateKeys(myVeh)

                    -- SET IT AS A RENTAL
                    exports["soe-utils"]:SetRentalStatus(myVeh)
                    SetEntityAsMissionEntity(myVeh, true, true)
                    DecorSetBool(myVeh, "noInventoryLoot", true)
                end
            end
        end
    else
        TriggerEvent("Chat:Client:Message", "[Go Postal]", "You already have a truck!", "taxi")
    end
end

local function ReturnDeliveryVehicle()
    local vehicle = nil

    -- CHECK WHETHER THE PLAYERS LAST VEHICLE IS A GOPOSTAL TRUCK
    local lastVehicle = GetPlayersLastVehicle()
    local lastVehModel = GetEntityModel(lastVehicle)
    local modelHashKey = GetHashKey("boxville2")

    if lastVehModel == modelHashKey then
        if lastVehicle == myVeh then
            vehicle = myVeh
        else
            vehicle = lastVehicle
        end

        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local goPostalPos = GetEntityCoords(vehicle)
        local goPostaldistance = Vdist2(pos, goPostalPos)

        if (goPostaldistance <= 250.0) then
            -- CLEAR MYVEH VARIABLE IS PLAYER IS RETURNING A GOPOSTAL TRUCK THEY RENTED
            local returnMessage = "Thank you for returning a truck! Have a nice day!"
            if vehicle == myVeh then
                --exports["soe-valet"]:RemoveKey(vehicle)
                myVeh = nil
                returnMessage = "Thank you for bringing your truck back! Have a nice day!", "taxi"
            end
            TriggerEvent("Chat:Client:Message", "[Go Postal]", returnMessage, "taxi")
            TriggerServerEvent("Utils:Server:DeleteEntity", VehToNet(vehicle))
        else
            TriggerEvent("Chat:Client:Message", "[Go Postal]", "Be sure to grab all the paperwork from the truck before returning it.", "taxi")
        end
    else
        TriggerEvent("Chat:Client:Message", "[Go Postal]", "Be sure to grab all the paperwork from the truck before returning it.", "taxi")
    end
end

-- GET OR RETURN A PACKAGE FROM THE GOPOSTAL TRUCK
local function GetOrReturnGoPostalPackage()
    -- GIVE PLAYER PACKAGE IF THEY DON'T ALREADY HAVE ONE
    if not hasPackage then
        --print("GIVING GO POSTAL PACKAGE")
        hasPackage = true
        minimap = exports["soe-ui"]:GetMinimap()
        if not minimap then
            exports["soe-ui"]:ToggleMinimap(true)
        end

        exports["soe-emotes"]:StartEmote("box")
        exports["soe-ui"]:SendAlert("success", "You grabbed a package from the truck", 2500)
    else
        --print("REMOVING GO POSTAL PACKAGE")
        hasPackage = false
        ClearPedTasks(PlayerPedId())
        minimap = exports["soe-ui"]:GetMinimap()
        if not minimap then
            exports["soe-ui"]:ToggleMinimap(false)
        end

        exports["soe-emotes"]:EliminateAllProps()
        exports["soe-ui"]:SendAlert("success", "You returned a package to the truck", 2500)
    end
end

local function UpdateJobBlip(stopID, availability)
    --[[print("-----")
    print("UPDATE GO POSTAL BLIP")]]
    -- CLEARS OLD JOB BLIP
    if jobBlips[stopID].blip ~= nil then
        RemoveBlip(jobBlips[stopID].blip)
        jobBlips[stopID].blip = nil
    end

    -- UPDATE LOCAL PACKAGE DESTINATION AVAILABILITY BOOL
    goPostalDestinationStatus[stopID].availability = availability
    jobBlips[stopID].availability = availability

    jobBlips[stopID].blip = AddBlipForCoord(jobBlips[stopID].pos)
    SetBlipAsShortRange(jobBlips[stopID].blip, true)
    SetBlipSprite(jobBlips[stopID].blip, 478)

    -- SET BLIP COLOR TO RED IF PACKAGE DESTINATION IS NOT READY FOR A DROP
    if availability then
        SetBlipColour(jobBlips[stopID].blip, 50)
    else
        SetBlipColour(jobBlips[stopID].blip, 1)
        SetBlipDisplay(jobBlips[stopID].blip, 8)
    end

    SetBlipScale(jobBlips[stopID].blip, 0.75)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(string.format("Package Destination"))
    EndTextCommandSetBlipName(jobBlips[stopID].blip)

end

function UpdateGoPostalDestinationStatus()
    --[[print("-----")
    print("UPDATE GO POSTAL goPostalDestinationStatus")]]
    -- UPDATE LOCAL JOB BLIP TABLE
    for _, data in pairs(goPostalDestinationStatus) do
        jobBlips[data.stopID].availability = data.availability
        UpdateJobBlip(data.stopID, data.availability)
    end

end

-- UPDATE LOCAL PACKAGE DESTINATION STATUS LIST WITH SERVER LIST
local function GoPostalDeliveryBlips()
    goPostalDestinationStatus = nil
    local playerServerId = GetPlayerServerId(PlayerId())
    TriggerServerEvent("Jobs:Server:GoPostalGetDestinationStatus", playerServerId)

    while goPostalDestinationStatus == nil do
        --print("IN LOOP")
        Wait(100)
    end

    -- INITIALIZE LOCAL JOB BLIP TABLE
    jobBlips = {}
    for _, data in pairs(goPostalDestinationStatus) do
        jobBlips[data.stopID] = {stopID = data.stopID, pos = data.pos, availability = data.availability, blip = nil}

        --[[print("stopID: " .. tostring(data.stopID))
        print("pos: " .. tostring(data.pos))
        print("Ready for drop: " .. tostring(data.availability))
        print("-----")]]

        UpdateJobBlip(data.stopID, data.availability)
    end
end

local function StartJob()
    -- COOLDOWN CHECK (IF NOT IN A COOLDOWN)
    if (cooldown < GetGameTimer()) then
        cooldown = GetGameTimer() + 180000
        isOnDuty = true
        TriggerServerEvent("Jobs:Server:ToggleDuty", {status = true, dutyStatus = true, job = "GOPOSTAL"})
        GoPostalDeliveryBlips()
    else
        exports["soe-ui"]:SendAlert("inform", "Take a break, come back later.", 5000)
    end
end

-- STOP GOPOSTAL JOB AND REMOVE FROM DUTY
local function StopJob()
    -- CHECK IF ON DUTY
    if isOnDuty then
        isOnDuty = false
        -- REMOVE ALL PACKAGE DESTINATION BLIPS
        --print("REMOVING BLIPS")
        for _, data in pairs(jobBlips) do
            --[[print("stopID: " .. tostring(data.stopID))
            print("pos: " .. tostring(data.pos))
            print("Ready for drop: " .. tostring(data.availability))
            print("blip: " .. tostring(data.blip))
            print("-----")]]
            if data.blip ~= nil then
                RemoveBlip(data.blip)
                data.blip = nil
            end
        end
        -- CHECK IF PLAYER HAS A DELIVERY VEHICLE
        if myVeh ~= nil then
            TriggerEvent("Chat:Client:Message", "[Go Postal]", "Please don't forget to grab all the paperwork from the truck then return it.", "taxi")
        end
        -- RESETS PACKAGE VARIABLE WHEN GOING OFF DUTY
        hasPackage = false
        ClearPedTasks(PlayerPedId())
        exports["soe-emotes"]:EliminateAllProps()
        TriggerServerEvent("Jobs:Server:ToggleDuty", {status = true, dutyStatus = false, job = "GOPOSTAL"})
    end
end

-- START GOPOSTAL JOB AND ADD TO DUTY
local function StartOrStopJob()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    for _, data in pairs(goPostalDepots) do
        -- DISTANCE CHECK
        local distance = Vdist2(pos, data.pos)
        if (distance < 8.5) then
            if not isOnDuty then
                StartJob()
            else
                StopJob()
            end
        end
    end
end

-- DELIEVER THE PACKAGE AT DESTINATION
local function DeliverGoPostalPackageAtDestination()
    --[[print("-----")
    print("DELIVER GO POSTAL PACKAGE")]]
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local stopID = nil
    for _, data in pairs(goPostalDestinationStatus) do
        local distance = Vdist2(pos, data.pos)
        if (distance < 2.0) then
            if data.availability then
                stopID = data.stopID
                local playerServerId = GetPlayerServerId(PlayerId())
                local charID = exports["soe-uchuu"]:GetPlayer().CharID
                -- UPDATE SERVER PACKAGE DESTINATION AVAILABILITY BOOL TO FALSE
                TriggerServerEvent("Jobs:Server:UpdateDestinationAvailability", playerServerId, stopID)

                -- UPDATE SERVER AND LOCAL TABLE TRACKING PACKAGES PLAYER HAS DELIVERED
                TriggerServerEvent("Jobs:Server:UpdateGoPostalPackageDeliveredByPlayer", playerServerId, charID, 1)
                --print(string.format("UPDATING LOCAL LIST - ADD %s TO PACKAGES DELVIERED BY %s", 1, charID))
                if goPostalPayTable[charID] == nil then
                    goPostalPayTable[charID] = 1
                else
                    goPostalPayTable[charID] = goPostalPayTable[charID] + 1
                end

                -- UPDATES JOB BLIP
                UpdateJobBlip(stopID, false)

                -- REMOVE PACKAGE FROM PLAYER
                hasPackage = false
                ClearPedTasks(PlayerPedId())
                if not minimap then
                    exports["soe-ui"]:ToggleMinimap(false)
                end

                exports["soe-emotes"]:EliminateAllProps()
                exports["soe-ui"]:SendAlert("success", "You delivered the package to its destination!", 2500)
                break
            else
                exports["soe-ui"]:SendAlert("error", "Package is not addressed for here, deliver it to the correct address.", 2500)
            end
        end
    end
end

local function CollectGoPostalPay()
    --[[print("-----")
    print("COLLECT GO POSTAL PAY")]]
    serverPackagesDelivered = nil
    local playerServerId = GetPlayerServerId(PlayerId())
    local charID = exports["soe-uchuu"]:GetPlayer().CharID
    TriggerServerEvent("Jobs:Server:GetPayDataForCharID", playerServerId, charID)

    while serverPackagesDelivered == nil do
        --print("IN LOOP")
        Wait(100)
    end

    local localServerPackagesDelivered = goPostalPayTable[charID]
    local serverPackagesDelviered = serverPackagesDelivered

    local maxPay = goPostalPayTable[charID] * goPostalPayRate

    --[[print("LOCAL PACKAGES DELVIERED: " .. tostring(goPostalPayTable[charID]))
    print("SERVER PACKAGES DELVIERED: " .. tostring(serverPackagesDelivered))

    print("LOCAL PAYRATE: " .. tostring(goPostalPayRate))
    print("SERVER PAYRATE: " .. tostring(serverPayRate))

    print("LOCAL MAXPAY: " .. tostring(maxPay))
    print("SERVER MAXPAY: " .. tostring(serverMaxPay))]]

    if localServerPackagesDelivered > serverPackagesDelviered or goPostalPayRate > serverPayRate or maxPay > serverMaxPay then
        --print("HACKING IS BAD MMM KAY")
        return
    end

    -- TRIGGER SERVER EVENT TO PAY PLAYER
    --print(string.format("PAY PLAYER %s FOR DELIEVERING %s PACKAGES AT %s EACH", serverMaxPay, serverPackagesDelviered, serverPayRate))
    TriggerServerEvent("Jobs:Server:CollectGoPostalPay", playerServerId)

    -- UPDATE SERVER AND LOCAL TABLE TRACKING PACKAGES PLAYER HAS DELIVERED
    Wait(250)
    TriggerServerEvent("Jobs:Server:UpdateGoPostalPackageDeliveredByPlayer", playerServerId, charID, -goPostalPayTable[charID])
    --print(string.format("UPDATING LOCAL LIST - REMOVING %s FROM PACKAGES DELVIERED BY %s", goPostalPayTable[charID], charID))
    goPostalPayTable[charID] = 0
end

-- SENT FROM CLIENT TO GIVE SOURCE PACKAGES
RegisterNetEvent("Jobs:Client:GoPostalGetDestinationStatus")
AddEventHandler(
    "Jobs:Client:GoPostalGetDestinationStatus",
    function(destinationStatusTable)
        --print("GOT DESTINATION DATA FROM SERVER")
        goPostalDestinationStatus = destinationStatusTable
    end
)

-- SENT FROM CLIENT TO GIVE PAY DATA
RegisterNetEvent("Jobs:Client:GetPayDataForCharID")
AddEventHandler(
    "Jobs:Client:GetPayDataForCharID",
    function(payDataFromServer)
        --print("GOT PAY DATA FROM SERVER")
        serverPackagesDelivered = payDataFromServer.payAmount
        serverMaxPay = payDataFromServer.maxPay
        serverPayRate = payDataFromServer.goPostalPayRate
    end
)

-- SPAWN GOPOSTAL TRUCK AND STARTS JOB
AddEventHandler("Jobs:Client:StartOrStopGoPostalJob", StartOrStopJob)

-- GET OR RETURN GOPOSTAL PACKAGE
AddEventHandler("Jobs:Client:GetReturnGoPostalPackage", GetOrReturnGoPostalPackage)

-- DELIVER GOPOSTAL PACKAGE
AddEventHandler("Jobs:Client:DeliverGoPostalPackage", DeliverGoPostalPackageAtDestination)

-- COLLECT GOPOSTAL PAY
AddEventHandler("Jobs:Client:CollectGoPostalPay", CollectGoPostalPay)

-- SPAWN GOPOSTAL TRUCK
AddEventHandler("Jobs:Client:SpawnGoPostalTruck", SpawnDeliveryVehicle)

-- RETURN GOPOSTAL TRUCK
AddEventHandler("Jobs:Client:ReturnGoPostalTruck", ReturnDeliveryVehicle)

-- DEBUG
--[[RegisterCommand(
    "gopostal",
    function()
        local toggle = "START"
        if not isOnDuty then
            StartGoPostalDuty()
        else
            StopGoPostalDuty()
            toggle = "STOP"
        end
        TriggerEvent("Notify:Client:SendAlert", {type = "success", text = string.format("GOPOSTAL DEBUG %s", toggle), length = 2500})
    end
)

RegisterCommand(
    "package",
    function()
        GetOrReturnGoPostalPackage()
        TriggerEvent("Notify:Client:SendAlert", {type = "success", text = "GOPOSTAL DEBUG PACKAGE", length = 2500})
    end
)

Citizen.CreateThread(
    function()
        Wait(1000)
        while true do
            Wait(2500)
            print("LOCAL - DESTINATION STATUS TABLE")
            for _, data in pairs(goPostalDestinationStatus) do
                print("stopID: " .. tostring(data.stopID))
                print("Ready for drop: " .. tostring(data.availability))
                print("---")
            end
        end
    end
)]]
