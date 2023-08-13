local myTaxi = nil
local cooldown = 0
local taxiStage = 0
local endCoords = nil
local isOnDuty = false
local startCoords = nil

local customerData = {
    ped = nil,
    blip = nil,
    destination = nil,
    feelsUnsafe = false,
    patienceLevel = 695,
    searchRadius = 55.0,
    beingTracked = false
}

-- TAXI DEPOTS TO RETURN/GET TAXI AND START JOB
local taxiDepots = {
    [1] = {door = vector3(906.42, -163.94, 74.11), spawn = vector4(909.18, -176.79, 74.21, 234.04), name = "Tangerine St / Mirror Park Blvd"},
    [2] = {door = vector3(1737.77, 3709.67, 34.14), spawn = vector4(1729.34, 3713.27, 33.8, 20.47), name = "Algonquin Blvd / Mountain View Dr"},
    [3] = {door = vector3(-60.31, 6450.64, 31.49), spawn = vector4(-65.34, 6447.51, 31.51, 228.98), name = "Paleto Blvd"}
}

-- FUNCTION TO SPAWN TAXI
local function SpawnTaxi(pos)
    -- SPAWN TAXI AND GIVE PLAYER THE KEYS
    myTaxi = exports["soe-utils"]:SpawnVehicle("taxi", pos)
    local plate = exports["soe-utils"]:GenerateRandomPlate()
    SetVehicleNumberPlateText(myTaxi, plate)
    Wait(500)

    exports["soe-valet"]:UpdateKeys(myTaxi)
    DecorSetBool(myTaxi, "noInventoryLoot", true)

    -- SET IT AS A RENTAL
    exports["soe-utils"]:SetRentalStatus(myTaxi)
end

-- FUNCTION TO STOP JOB AND REPORT TAXI STOLEN
local function StopJobAndReportTaxiStolen()
    for _, depot in pairs(taxiDepots) do
        if #(GetEntityCoords(PlayerPedId()) - depot.door) <= 2.5 then
            if (myTaxi ~= nil) then
                local plate = GetVehicleNumberPlateText(myTaxi)
                TriggerServerEvent("Emergency:Server:MarkStolen", plate, true, true)

                TriggerEvent("Chat:Client:Message", "[Taxi Depot]", "You lost the taxi!?!? How could you do such a thing. Just in case, I will report the taxi stolen to the police.", "taxi")
                StopTaxiDuty()
                myTaxi = nil
            end
        end
    end
end

-- FUNCTION TO RENT A TAXI AND START JOB
local function StartRentAndJob()
    local pos = GetEntityCoords(PlayerPedId())
    for _, depot in pairs(taxiDepots) do
        if #(pos - depot.door) <= 2.5 then
            if (myTaxi == nil) then
                -- COOLDOWN CHECK (IF NOT IN A COOLDOWN)
                if (cooldown < GetGameTimer()) then
                    cooldown = GetGameTimer() + 10000
                    TriggerEvent("Chat:Client:Message", "[Taxi Depot]", "Here are your keys and everything you need. Your taxi should be ready out there.", "taxi")
                    SpawnTaxi(depot.spawn)
                    StartTaxiDuty()
                else
                    exports["soe-ui"]:SendAlert("error", "Take a break for a bit...", 5000)
                end
            else
                if (Vdist2(pos, GetEntityCoords(myTaxi)) < 155.0) then
                    --exports["soe-valet"]:RemoveKey(myTaxi)
                    TriggerServerEvent("Utils:Server:DeleteEntity", VehToNet(myTaxi))
                    TriggerEvent("Chat:Client:Message", "[Taxi Depot]", "Ah. Come here to return the taxi and clock off? No worries! Come back when you are ready again!", "taxi")

                    StopTaxiDuty()
                    myTaxi = nil
                else
                    TriggerEvent("Chat:Client:Message", "[Taxi Depot]", "Uh. I do not see any taxi outside.", "taxi")
                end
            end
        end
    end
end

-- FUNCTION TO WORK WHEN DRIVER ARRIVES AT DESTINATION
local function DestinationArrival()
    local scammed = false
    -- THANK THE DRIVER
    TriggerEvent("Chat:Client:Message", "[Customer]", "Thanks for the ride! How much do I owe ya?", "taxi")

    -- RECORD END COORDINATES
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    endCoords = pos

    Wait(1500)
    -- RESET OUR PED AND HAVE IT LEAVE THE VEHICLE
    SetPedAsNoLongerNeeded(customerData.ped)
    TaskLeaveAnyVehicle(customerData.ped, 0, 0)

    Wait(1500)
    ClearPedTasks(customerData.ped)

    -- 2% CHANCE TO GET SCAMMED
    math.randomseed(GetGameTimer())
    if (math.random(0, 100) < 2) then
        scammed = true
        TriggerEvent("Chat:Client:Message", "[Customer]", "SIKE! I ain't paying shit!", "taxi")
        TriggerEvent("Chat:Client:SendMessage", "me", "The passenger has left the vehicle without paying!")
        TaskSmartFleePed(customerData.ped, ped, 5000.0, -1, true, true)
    end

    -- RESET CUSTOMER DATA
    taxiStage = 0
    customerData.ped = nil
    RemoveBlip(destinationBlip)
    customerData.destination = nil
    customerData.patienceLevel = 8000
    customerData.feelsUnsafe = false
    customerData.beingTracked = false

    -- IF WE GOT SCAMMED, RETURN AND HALT THE FUNCTION
    if scammed then return end
    Wait(2000)

    TriggerServerEvent("Jobs:Server:HandleTaxiPayment", {status = true, startCoords = startCoords, endCoords = endCoords})
end

-- THIS JUDGES THE CUSTOMER'S FEELINGS AND SAFETY
local function StartTrackingCustomer()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    customerData.beingTracked = true

    -- START TRACKING CUSTOMER
    taxiStage = 2
    while customerData.beingTracked do
        Wait(150)
        customerData.patienceLevel = customerData.patienceLevel - 1
        --print(string.format("PATIENCE LEVEL: %s", customerData.patienceLevel))

        -- IF CUSTOMER GOT IMPATIENT, CANCEL RIDE
        if (customerData.patienceLevel == 0) then
            TriggerEvent("Chat:Client:Message", "[Customer]", "You're taking too long. Let me off here.", "taxi")
            StopTaxiDuty()
        end

        -- IF CUSTOMER GOT KILLED, CANCEL RIDE
        if IsEntityDead(customerData.ped) then
            exports["soe-ui"]:SendAlert("error", "The customer has died", 4500)
            StopTaxiDuty()
        end

        -- IF DRIVER IS EXCESSIVELY SPEEDING, CANCEL RIDE
        local speed = GetEntitySpeed(veh)
        local mph = math.floor(speed * 2.23694 + 0.5)
        if (mph > 90) then
            customerData.feelsUnsafe = true
            SetPedCanCowerInCover(customerData.ped, true)
            TaskReactAndFleePed(customerData.ped, ped)
            TriggerEvent("Chat:Client:Message", "[Customer]", "You're going way too fast! Get me out of this death trap!", "taxi")
            StopTaxiDuty()
        end

        -- WE MADE IT TO OUR DESTINATION
        local pos = GetEntityCoords(ped)
        local dist = Vdist2(pos, taxiCalls[customerData.destination].x, taxiCalls[customerData.destination].y, taxiCalls[customerData.destination].z)
        if (dist <= 350) then
            Wait(3000)
            DestinationArrival()
        end
    end
end

-- RANDOMLY CHOOSE A DESTINATION FOR THE CUSTOMER
local function SetDestinationAndGreet()
    -- REMOVE THE CUSTOMER'S BLIP
    RemoveBlip(customerData.blip)
    customerData.blip = nil

    -- RANDOMIZE DESTINATION
    math.randomseed(GetGameTimer())
    customerData.destination = math.random(1, #taxiCalls)

    -- CREATE CHAT MESSAGE AS THE CUSTOMER
    TriggerEvent("Chat:Client:Message", "[Customer]", taxiCalls[customerData.destination].msg, "taxi")

    -- SET PATIENCE LEVEL TO 20 MINUTES
    customerData.patienceLevel = 8000

    -- SET BLIP TO DESTINATION
    destinationBlip = AddBlipForCoord(taxiCalls[customerData.destination].x, taxiCalls[customerData.destination].y, taxiCalls[customerData.destination].z)
    SetBlipRoute(destinationBlip)

    -- START TRACKING THE CUSTOMER'S WELL-BEING
    StartTrackingCustomer()
end

-- THIS STARTS THE CUSTOMER HUNT
local function BeginLookingForCustomers()
    -- CHECK IF THE PLAYER IS IN A TAXI AND ON DUTY
    local ped = PlayerPedId()
    if not IsPedInAnyTaxi(ped) then
        exports["soe-ui"]:SendAlert("error", "You must be in a taxi to continue", 3500)
        return
    end
    Wait(3500)

    -- TAXI STAGE 1 MEANS YOU GOT A CUSTOMER
    if (taxiStage == 1) then
        exports["soe-ui"]:SendAlert("error", "You already are looking for a customer!", 3500)
        return
    end

    -- SET TAXI JOB STAGE AND WAIT FOR A CUSTOMER
    taxiStage = 1
    TriggerEvent("Chat:Client:Message", "[Taxi Dispatch]", "Give me a moment, I'll search for any customers wanting a taxi and I'll set your GPS to them.", "taxi")
    Wait(math.random(3500, 9500))

    print("SEARCHING.")
    -- SEARCH FOR A RANDOM PEDESTRIAN NEARBY
    local pos = GetEntityCoords(ped)
    local randomPed = GetRandomPedAtCoord(pos.x, pos.y, pos.z, customerData.searchRadius, customerData.searchRadius, customerData.searchRadius, 6, -1)

    -- IF WE COULDN'T FIND ANYONE, RETURN
    if not DoesEntityExist(randomPed) then
        taxiStage = 0
        TriggerEvent("Chat:Client:Message", "[Taxi Dispatch]", "I don't have anyone right now currently looking for a taxi. Try again here soon.", "taxi")
        return
    end

    -- 25% CHANCE OF A RIDER CANCELLING IN LAST SECOND
    math.randomseed(GetGameTimer())
    if (math.random(0, 100) < 25) then
        taxiStage = 0
        TriggerEvent("Chat:Client:Message", "[Taxi Dispatch]", "Dang. That rider just cancelled on us at the last second.", "taxi")
        BeginLookingForCustomers()
        return
    end

    if IsPedHuman(randomPed) then
        print("DEBUG 1")

        -- LOAD THE HAILING ANIMATION AND SET DATA
        customerData.ped = randomPed
        exports["soe-utils"]:LoadAnimDict("taxi_hail", 15)

        -- SET PED SETTINGS
        SetEntityAsMissionEntity(customerData.ped, true, true)
        SetBlockingOfNonTemporaryEvents(customerData.ped, true)
        TaskTurnPedToFaceEntity(customerData.ped, ped, 2000)

        -- CREATE A BLIP FOR THE PED
        customerData.blip = AddBlipForEntity(customerData.ped)
        SetBlipSprite(customerData.blip, 280)
        SetBlipColour(customerData.blip, 73)
        SetBlipFlashes(customerData.blip, true)
        SetBlipRoute(customerData.blip, true)
        SetBlipRouteColour(customerData.blip, 73)

        Wait(1500)

        print("DEBUG 2")
        -- LET TAXI DRIVER KNOW BY ANIMATION AND CHAT MESSAGE
        ClearPedTasksImmediately(customerData.ped)
        TriggerEvent("Chat:Client:Message", "[Taxi Dispatch]", "Just flagged an awaiting customer on your GPS.", "taxi")

        local whistled = false
        if not whistled then
            TaskPlayAnim(customerData.ped, "taxi_hail", "hail_taxi", 1.0, -1.0, -1, 1, 1, 1, 1, 1)
            Wait(5000)
            whistled = true
        end

        if whistled then
            TaskTurnPedToFaceEntity(customerData.ped, ped, -1)
        end

        -- HAVE THE CUSTOMER ENTER THE VEHICLE
        local veh = GetVehiclePedIsIn(ped, false)
        while isOnDuty do
            local pos = GetEntityCoords(ped)
            local customerPos = GetEntityCoords(customerData.ped)
            if Vdist2(pos, customerPos) <= 150 then
                TaskEnterVehicle(customerData.ped, veh, -1, 2, 1.5, 1, 0)
                SetBlockingOfNonTemporaryEvents(customerData.ped, true)
                Wait(1000)
                break
            else
                SetBlockingOfNonTemporaryEvents(customerData.ped, true)
                Wait(1000)
            end
            Wait(1000)
        end
    
        while not IsPedInAnyTaxi(customerData.ped) do
            TaskEnterVehicle(customerData.ped, veh, -1, 2, 1.5, 1, 0)
            Wait(1000)
        end

        -- CALL THE DESTINATION AND GREET GENERATOR
        if IsPedInAnyTaxi(customerData.ped) then
            startCoords = GetEntityCoords(ped)
            SetDestinationAndGreet()
        end
    end
end

-- CHECKS IF PLAYER IS CLOSE TO A TAXI DEPOT
function IsCloseToTaxiDepot()
    for _, depot in pairs(taxiDepots) do
        if #(GetEntityCoords(PlayerPedId()) - depot.door) <= 2.5 then
            return true
        end
    end
    return false
end

-- THIS WILL SET THE PLAYER OFF OF TAXI DUTY
function StopTaxiDuty()
    -- CHECK IF ON DUTY
    if isOnDuty then
        taxiStage = 0
        isOnDuty = false
        customerData.ped = nil
        customerData.blip = nil
        RemoveBlip(destinationBlip)
        customerData.feelsUnsafe = false
        customerData.beingTracked = false
        TriggerServerEvent("Jobs:Server:ToggleDuty", {status = true, dutyStatus = false, job = "TAXI"})
    end
end

-- THIS WILL SET THE PLAYER ON TAXI DUTY
function StartTaxiDuty()
    -- CHECK IF NOT ON DUTY
    if not isOnDuty then
        -- SET SOME VARIABLES UP
        isOnDuty = true
        TriggerServerEvent("Jobs:Server:ToggleDuty", {status = true, dutyStatus = true, job = "TAXI"})
    end
end

-- SPAWN TAXI AND START JOB
AddEventHandler("Jobs:Client:RentTaxiAndStartJob", StartRentAndJob)
-- REPORTS TAXI LOST AND ENDS JOB
AddEventHandler("Jobs:Client:ReportTaxiLost", StopJobAndReportTaxiStolen)
-- STARTS SEARCHING FOR CUSTOMERS
AddEventHandler("Jobs:Client:LookForTaxiCustomers", BeginLookingForCustomers)
