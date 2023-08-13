local patrolVeh = nil
local patrolVehInfo = nil
local isOnDuty = false
local currentBlip = nil
local currentSite = nil
local checkpointTime = nil
local checkpointExpiry = 9999999999
local currentCheckpoint = 1
local cooldown = 0

-- REMOVE ANY SECURITY BLIPS
local function RemoveSecurityBlip()
    if DoesBlipExist(currentBlip) then
        RemoveBlip(currentBlip)
    end

    currentBlip = nil
end

-- DRAW NEW SECURITY BLIP FOR COORDS
local function DrawSecurityBlip(coords)
    RemoveSecurityBlip()

    currentBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(currentBlip, 56)
    SetBlipScale(currentBlip, 0.6)
    SetBlipAsShortRange(currentBlip, false)
    SetBlipColour(currentBlip, 38)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Next Security Checkpoint")
    EndTextCommandSetBlipName(currentBlip)
    SetBlipRoute(currentBlip, true)
    SetBlipRouteColour(currentBlip, 38)
end

-- GENERATE A NEW SECURITY JOB
local function GenerateSecurityJob(alreadyStarted)
    -- CHOOSE NEW SITE
    local lastSite = currentSite or securitySites[1]
    currentCheckpoint = 1
    currentSite = securitySites[math.random(1, #securitySites)]

    -- WHILE SITE IS THE SAME AS OLD ONE, CHOOSE AGAIN. IF SITE DOESN'T MATCH VEHICLE TYPE, CHOOSE AGAIN
    while currentSite.name == lastSite.name or currentSite.vehType ~= patrolVehInfo.vehType do
        math.randomseed(GetGameTimer())
        currentSite = securitySites[math.random(1, #securitySites)]
        Wait(10)
    end

    -- DRAW THE BLIP FOR THE FIRST CHECKPOINT
    DrawSecurityBlip(currentSite.checkpoints[currentCheckpoint].pos)

    -- SEND DISPATCH MESSAGE
    if alreadyStarted then
        local text = string.format("You've completed your patrol of this site. Your next site is %s. %s", currentSite.name, currentSite.description)
        TriggerEvent("Chat:Client:Message", "[Security Dispatch]", text, "taxi")
    else
        local text = string.format("No time to waste. Looks like you've got your vehicle checked out. Your first site is %s. %s", currentSite.name, currentSite.description)
        TriggerEvent("Chat:Client:Message", "[Security Dispatch]", text, "taxi")
    end
    checkpointExpiry = GetGameTimer() + 900000
end

-- SPAWN SECURITY VEHICLE
local function SpawnPatrolVehicle(coords)
	if patrolVeh == nil then
        if patrolVeh == nil and isOnDuty then
            patrolVehInfo = securityVehicles[math.random(1, #securityVehicles)]

            -- SPAWN AND GIVE KEYS
            TriggerServerEvent("Utils:Server:ClearVehiclesInRadius", coords.x, coords.y, coords.z, 3.0)
            exports["soe-ui"]:SendAlert("warning", "Getting your vehicle out now...", 4000)
            Wait(3500)
            patrolVeh = exports["soe-utils"]:SpawnVehicle(patrolVehInfo.model, coords)
            local plate = exports["soe-utils"]:GenerateRandomPlate()
            SetVehicleNumberPlateText(patrolVeh, plate)
            Wait(500)

            exports["soe-valet"]:UpdateKeys(patrolVeh)
            DecorSetBool(patrolVeh, "noInventoryLoot", true)

            -- SET IT AS A RENTAL
            exports["soe-utils"]:SetRentalStatus(patrolVeh)
            SetEntityAsMissionEntity(patrolVeh, true, true)
            GenerateSecurityJob(false)
        end
	else
        exports["soe-ui"]:SendAlert("error", "You've already been issued a patrol vehicle!", 5000)
	end
end

-- START SECURITY JOB
local function StartJob()
    if cooldown < GetGameTimer() then
	    cooldown = GetGameTimer() + 180000
        isOnDuty = true
		TriggerServerEvent("Jobs:Server:ToggleDuty", {status = true, dutyStatus = true, job = "SECURITY"})
	else 
        exports["soe-ui"]:SendAlert("success", "Take a break, come back later.", 5000)
	end
end

-- GET NEXT CHECKPOINT FOR PATROL
local function GetNextCheckpoint()
    if currentSite.checkpoints[currentCheckpoint + 1] then
        currentCheckpoint = currentCheckpoint + 1
        DrawSecurityBlip(currentSite.checkpoints[currentCheckpoint].pos)
        exports["soe-ui"]:SendAlert("success", "You may now move on to the next checkpoint!", 5000)
    else
        GenerateSecurityJob(true)
        exports["soe-ui"]:SendAlert("success", "Site patrol completed. Dispatch will assign a new site.", 5000)
    end
end

-- UPDATE CHECKPOINT STATUS TO KEEP TRACK OF PATROL
function UpdateCheckpointStatus()
    -- IF NOT ON PATROL YET, RETURN
    if not currentSite then
        return
    end


    local ped = PlayerPedId()
    local myPos = GetEntityCoords(ped)

    -- IF AT THE CHECKPOINT ALREADY
    if checkpointTime then
        -- LEFT EARLY
        if #(myPos - currentSite.checkpoints[currentCheckpoint].pos) > 5.0 then
            exports["soe-ui"]:SendAlert("error", "You prematurely left this checkpoint", 5000)
            checkpointTime = nil
            return
        else
            -- CHECKPOINT COMPLETED
            if checkpointTime < GetGameTimer() then
                checkpointTime = nil
                GetNextCheckpoint()
                checkpointExpiry = GetGameTimer() + 900000
            end
        end
    -- IF JUST ARRIVING AT THE CHECKPOINT
    else
        -- IF CLOSE ENOUGH
        if #(myPos - currentSite.checkpoints[currentCheckpoint].pos) < 5.0 then
            -- DON'T ALLOW FOOT CHECKPOINTS TO BE COMPLETED IN A VEHICLE
            if IsPedInAnyVehicle(ped, false) and currentSite.checkpoints[currentCheckpoint].type == "foot" then
                exports["soe-ui"]:SendAlert("error", "You must complete this checkpoint on foot", 5000)
                return
            end

            -- NOTIFY THEY MUST REMAIN
            checkpointTime = GetGameTimer() + 15000
            exports["soe-ui"]:SendAlert("inform", "Remain at this checkpoint for at least 15 seconds before proceeding!", 5000)
        end
    end

end

-- IS PLAYER CLOSE TO A SECURITY OFFICE
function IsCloseToSecurityOffice()
    local myPos = GetEntityCoords(PlayerPedId())
    for _, office in pairs(securityOffices) do
        if #(myPos - office.pos) < 3.0 then
            return true
        end
    end
    return false
end

-- CHECK IF PLAYER HAS CHECKED OUT A VEHICLE ALREADY
function HasCheckedOutSecurityVehicle()
    if patrolVeh then
        return true
    end
    return false
end

-- START SECURITY DUTY
RegisterNetEvent("Jobs:Client:StartSecurityDuty")
AddEventHandler("Jobs:Client:StartSecurityDuty", function()
    StartJob()
end)

-- SPAWN SECURITY VEHICLE
RegisterNetEvent("Jobs:Client:SpawnPatrolCar")
AddEventHandler("Jobs:Client:SpawnPatrolCar", function()
    local myPos = GetEntityCoords(PlayerPedId())
    for _, office in pairs(securityOffices) do
        if #(myPos - office.pos) < 3.0 then
            SpawnPatrolVehicle(office.vehSpawn)
            return
        end
    end
end)

-- END SECURITY DUTY
RegisterNetEvent("Jobs:Client:EndSecurityDuty")
AddEventHandler("Jobs:Client:EndSecurityDuty", function()
    local myPos = GetEntityCoords(PlayerPedId())
    local vehPos = GetEntityCoords(patrolVeh)

    -- IF VEHICLE FOUND
    if #(myPos - vehPos) < 30.0 or not patrolVeh then
        -- DELETE VEHICLE
        --exports["soe-valet"]:RemoveKey(patrolVeh)
        TriggerServerEvent("Utils:Server:DeleteEntity", VehToNet(patrolVeh))
        if patrolVeh then
            exports["soe-ui"]:SendAlert("success", "Vehicle successfully returned!", 5000)
        end
        patrolVeh, patrolVehInfo = nil, nil

        -- SET OFF DUTY
        isOnDuty, currentCheckpoint, currentSite = false, nil, nil
        RemoveSecurityBlip()
		TriggerServerEvent("Jobs:Server:ToggleDuty", {status = true, dutyStatus = false, job = "SECURITY"})
    -- VEHICLE NOT FOUND
    else
        exports["soe-ui"]:SendAlert("error", "We were unable to find your patrol vehicle. Make sure you brought it back!", 5000)
    end
end)

-- MARK PATROL CAR AS STOLEN AND FIRE
RegisterNetEvent("Jobs:Client:StolenPatrolCar")
AddEventHandler("Jobs:Client:StolenPatrolCar", function()
    -- REPORT STOLEN
    local plate = GetVehicleNumberPlateText(patrolVeh)
    TriggerServerEvent("Emergency:Server:MarkStolen", plate, true, true)
    patrolVeh, patrolVehInfo = nil, nil

    -- FIRE
    cooldown = GetGameTimer() + 1800000
    TriggerEvent("Chat:Client:Message", "[Security Dispatch]", "We're already on a tight budget and now you lose a patrol car? You're fired!", "taxi")
    isOnDuty, currentCheckpoint = false, nil
    RemoveSecurityBlip()
    TriggerServerEvent("Jobs:Server:ToggleDuty", {status = true, dutyStatus = false, job = "SECURITY"})
end)
