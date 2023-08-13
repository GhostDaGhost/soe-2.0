local drugrun = {}
local cooldown = 0
local drugrunMenu = menuV:CreateMenu("Grandma", "Choose a product to run", "topright", 107, 33, 30, "size-125", "default", "menuv", "drugrunMenu", "default")

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, CHECK IF VEHICLE CAN BE USED FOR DRUG RUNS
local function CheckVehicleClass(veh)
    if DoesEntityExist(veh) then
        local class = GetVehicleClass(veh)
        if (class == 13 or class == 14 or class == 15 or class == 16 or class == 18 or class == 19 or class == 21) then
            return false
        end
        return true
    end
    return false
end

-- WHEN TRIGGERED, CHECKS IF PLAYER IS CLOSE TO THEIR VEHICLE TRUNK
local function IsCloseToTrunk(ped, veh)
    local dist = #(GetEntityCoords(ped) - GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "boot")))
    --print("TRUNK DIST:", dist)
    if (dist <= 1.26) then
        if not (GetVehicleDoorAngleRatio(veh, 5) ~= 0) then
            exports["soe-ui"]:SendAlert("error", "Your trunk must be open to grab the product!", 5000)
            return false
        end
		return true
    end
    return false
end

-- WHEN TRIGGERED, MODIFY PAYOUT BASED OFF DISTANCE AND RUNNER AMOUNT
local function ModifyPayout()
    local mult = 0.45
    local passengers = GetVehicleNumberOfPassengers(drugrun.veh) + 1
    if (passengers > drugrun.runners) then
        passengers = drugrun.runners
    end

    if (passengers == 2) then
        mult = 0.6
    elseif (passengers == 3) then
        mult = 1.0
    elseif (passengers >= 4) then
        mult = 1.2
    end

    print("TotalPayout: Distance Calculations:", drugrun.lastStopDist)
    print("TotalPayout: (BEFORE CALC) Payout:", math.ceil(drugrun.totalPayout))

    print("AMOUNT OF RUNNERS:", drugrun.runners)
    print("RUNNER MULTIPLIER:", mult)
    drugrun.totalPayout = drugrun.totalPayout + (math.floor(drugrun.lastStopDist / 5.4) * mult)
    print("TotalPayout: (AFTER CALC) Payout:", math.ceil(drugrun.totalPayout))
end

-- WHEN TRIGGERED, SET DESTINATION BLIP
local function SetDestinationBlip(pos, final)
    RemoveBlip(drugrun.blip)
    drugrun.blip = AddBlipForCoord(pos)

    local name = "Drug Drop #" .. (drugrun.stops + 1)
    if not final then
        SetBlipSprite(drugrun.blip, tonumber(drugrunProducts[drugrun.product].blip))
    else
        name = "Collect Drug Run Money"
        SetBlipSprite(drugrun.blip, 500)
    end

    SetBlipScale(drugrun.blip, 1.10)
    SetBlipColour(drugrun.blip, 2)
    SetBlipRoute(drugrun.blip, true)
    SetBlipRouteColour(drugrun.blip, 2)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(drugrun.blip)
end

-- WHEN TRIGGERED, START DRUG RUN
local function GenerateDropoff(beginning)
    if not beginning then
        -- INCREASE THE TOTAL AMOUNT OF STOPS WE HAD FOR THIS RUN
        drugrun.stops = drugrun.stops + 1
        ModifyPayout()
    end

    math.randomseed(GetGameTimer() + 1)
    drugrun.destination = drugrunDropSpots[math.random(1, #drugrunDropSpots)]
    drugrun.enroute = true
    SetDestinationBlip(drugrun.destination.pos, false)
    exports["soe-ui"]:SendAlert("debug", drugrun.destination.msg, 25000)
    drugrun.lastStopDist = #(GetEntityCoords(drugrun.veh) - drugrun.destination.pos)

    CreateThread(function()
        local sleep = 850
        while drugrun.enroute do
            Wait(sleep)
            local ped = PlayerPedId()
            -- MINI-MARKER MANAGER FOR DRUG RUN DESTINATION
            if #(GetEntityCoords(ped) - drugrun.destination.pos) <= 15.0 then
                sleep = 5
                DrawMarker(27, drugrun.destination.pos.x, drugrun.destination.pos.y, drugrun.destination.pos.z - 0.92, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.5, 3.5, 3.5, 0, 255, 0, 105, 0, 0, 2, 0, 0, 0, 0)
            end

            -- ENSURE ANIMATION IS STILL BEING PLAYED FOR DRUG CARRYING
            if drugrun.carryingDrug then
                if not IsEntityPlayingAnim(ped, "anim@heists@box_carry@", "idle", 3) then
                    exports["soe-emotes"]:StartEmote("box")
                end
            end
        end
    end)
end

-- WHEN TRIGGERED, START THE NEXT STOP FOR THE RUN
local function StartNextStop()
    Wait(500)
    local plate, netID = GetVehicleNumberPlateText(drugrun.veh), NetworkGetNetworkIdFromEntity(drugrun.veh)
    local getDrugAmt = exports["soe-nexus"]:TriggerServerCallback("Crime:Server:GetDrugAmtInVehicle", netID, plate, drugrun.product)
    print("AMOUNT OF DRUGS INSIDE VEHICLE:", getDrugAmt)
    if (getDrugAmt <= 0) then
        -- PICKUP MONEY
        math.randomseed(GetGameTimer() + 1)
        drugrun.destination = drugrunMoneySpots[math.random(1, #drugrunMoneySpots)]
        SetDestinationBlip(drugrun.destination.pos, true)
        drugrun.collectingMoney = true
        drugrun.enroute = true

        ModifyPayout()
        exports["soe-ui"]:SendAlert("debug", drugrun.destination.msg, 25000)
        local sleep = 850
        while drugrun.enroute do
            Wait(sleep)
            if #(GetEntityCoords(PlayerPedId()) - drugrun.destination.pos) <= 15.0 then
                sleep = 5
                DrawMarker(21, drugrun.destination.pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.45, 0.45, 0.45, 32, 145, 17, 155, 0, 1, 2, 0, 0, 0, 0)
            else
                sleep = 850
            end
        end
    else
        -- GO FOR ANOTHER STOP
        print("WE HAVE ANOTHER DROPOFF DESTINATION.")
        GenerateDropoff(false)
    end
end

-- WHEN TRIGGERED, DO SOME DROPOFF TASKS AND CHECKS
local function DoDropoffTasks(ped)
    local plate, vin, netID = GetVehicleNumberPlateText(drugrun.veh), DecorGetInt(drugrun.veh, "vin"), NetworkGetNetworkIdFromEntity(drugrun.veh)
    if drugrun.collectingMoney and not IsPedSittingInAnyVehicle(ped) then
        if #(GetEntityCoords(ped) - drugrun.destination.pos) > 2.0 then return end

        drugrun.enroute = false
        drugrun.collectingMoney = false
        cooldown = GetGameTimer() + 950000
        local hasEndedDrugRun = exports["soe-nexus"]:TriggerServerCallback("Crime:Server:EndDrugRun", netID, plate, vin, true, drugrun.product, drugrun.totalPayout)
        if hasEndedDrugRun then
            drugrun.totalPayout = 0
            drugrun.isRunning = false
            drugrun.deliveryTimes = 0
            RemoveBlip(drugrun.blip)
            drugrun.blip = nil
        end
        return
    end

    if not drugrun.carryingDrug and not IsPedSittingInAnyVehicle(ped) then
        -- GRABBING DRUG FROM VEHICLE
        if IsCloseToTrunk(ped, drugrun.veh) then
            local getDrugAmt = exports["soe-nexus"]:TriggerServerCallback("Crime:Server:GetDrugAmtInVehicle", netID, plate, drugrun.product)
            if (getDrugAmt <= 0) then
                exports["soe-ui"]:SendAlert("error", "You don't have any product left in the vehicle!", 5000)
                return
            end

            drugrun.carryingDrug = true
            exports["soe-ui"]:ToggleMinimap(true)
            exports["soe-emotes"]:StartEmote("box")
            return
        end
    elseif drugrun.carryingDrug and not IsPedSittingInAnyVehicle(ped) then
        -- PUT DRUG BACK INTO VEHICLE
        if IsCloseToTrunk(ped, drugrun.veh) then
            drugrun.carryingDrug = false
            exports["soe-ui"]:ToggleMinimap(false)
            exports["soe-emotes"]:CancelEmote()
            return
        end

        -- DELIVERING
        if #(GetEntityCoords(ped) - drugrun.destination.pos) <= 2.0 then
            drugrun.carryingDrug = false
            exports["soe-ui"]:ToggleMinimap(false)
            exports["soe-emotes"]:CancelEmote()

            drugrun.deliveryTimes = drugrun.deliveryTimes + 1
            if (drugrun.deliveryTimes == 1) then
                local pos = GetEntityCoords(ped)
                local loc = exports["soe-utils"]:GetLocation(pos)
                TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = true, type = "Suspicious Transaction",
                    loc = loc, model = GetEntityModel(drugrun.veh), color = GetVehicleColours(drugrun.veh),
                    plate = GetVehicleNumberPlateText(drugrun.veh), coords = pos
                })
            end

            if (drugrun.deliveryTimes >= 5) then
                drugrun.enroute = false
                drugrun.deliveryTimes = 0
                exports["soe-ui"]:SendAlert("success", "You delivered all 5 boxes to this dropoff!", 7500)

                TriggerServerEvent("Crime:Server:CompleteDrugRunStop", {status = true, netID = netID, vin = vin, plate = plate, product = drugrun.product})
                StartNextStop()
            else
                exports["soe-ui"]:SendAlert("warning", ("Get another box of %s from the vehicle! (%s/5)"):format(string.lower(drugrun.product), drugrun.deliveryTimes), 7500)
            end
            return
        end
    end
end

-- WHEN TRIGGERED, ATTEMPT TO START/END A DRUG RUN
local function AttemptToStartDrugRun(ped, veh, startingPoint, product)
    -- ENSURE THAT THE STARTING PED IS THE DRIVER OF VEHICLE
    if (GetPedInVehicleSeat(veh, -1) ~= ped) then
        exports["soe-ui"]:SendAlert("error", "You must be the driver", 5000)
        return
    end

    if not drugrun.isRunning then
        -- CHECK COOLDOWN AND BLOCK IF STILL IN IT
        if (cooldown > GetGameTimer()) then
            exports["soe-ui"]:SendAlert("error", "You just did this recently!", 8000)
            return
        end

        -- CHECK THE VEHICLE CLASS
        if not CheckVehicleClass(veh) then
            exports["soe-ui"]:SendAlert("error", "You cannot use this vehicle", 5000)
            return
        end

        drugrun.veh = veh
        drugrun.stops = 0
        drugrun.totalPayout = 0
        drugrun.isRunning = true
        drugrun.deliveryTimes = 0
        cooldown = GetGameTimer() + 900000

        drugrun.supplying = true
        drugrun.product = product
        exports["soe-ui"]:SendAlert("debug", startingPoint.msg, 23500)
        SetVehicleDoorOpen(drugrun.veh, 5, false, false)
        SetVehicleHandbrake(drugrun.veh, true)
        Wait(25000)

        drugrun.runners = GetVehicleNumberOfPassengers(drugrun.veh) + 1
        exports["soe-utils"]:GetEntityControl(drugrun.veh)
        SetVehicleHandbrake(drugrun.veh, false)
        SetVehicleDoorShut(drugrun.veh, 5, false)
        drugrun.supplying = false

        local class = GetVehicleClass(drugrun.veh)
        local plate, vin = GetVehicleNumberPlateText(drugrun.veh), DecorGetInt(drugrun.veh, "vin")
        local hasFilledVehicle = exports["soe-nexus"]:TriggerServerCallback("Crime:Server:StartDrugRun", class, plate, vin, product, drugrun.runners)
        if hasFilledVehicle then
            GenerateDropoff(true)
        else
            drugrun.isRunning = false
            drugrun.deliveryTimes = 0
            exports["soe-ui"]:SendAlert("error", "Something went wrong while supplying your vehicle", 5000)
        end
    else
        -- CHECK THE VEHICLE AND SEE IF ITS THE SAME ONE WE STARTED IN
        if (drugrun.veh ~= veh) then
            cooldown = GetGameTimer() + 1800000
            exports["soe-ui"]:SendAlert("error", "Where the fuck is the vehicle with our shit? Just for that, we better not see your ass around.", 5000)
            TriggerServerEvent("Crime:Server:ModifyDrugRunReputation", {status = true, type == "Lost Vehicle"})
        end

        local plate, vin, netID = GetVehicleNumberPlateText(drugrun.veh), DecorGetInt(drugrun.veh, "vin"), NetworkGetNetworkIdFromEntity(drugrun.veh)
        local hasEndedDrugRun = exports["soe-nexus"]:TriggerServerCallback("Crime:Server:EndDrugRun", netID, plate, vin, false, drugrun.product)
        if hasEndedDrugRun then
            drugrun.totalPayout = 0
            drugrun.isRunning = false
            drugrun.deliveryTimes = 0
            RemoveBlip(drugrun.blip)
            drugrun.blip = nil
        end
    end
end

-- WHEN TRIGGERED, OPEN A DRUG RUNNING MENU TO CHOOSE PRODUCT TO RUN
local function OpenDrugRunningMenu(ped, veh, startingPoint)
    if drugrun.isMenuOpen then return end

    -- CLEAR MENU IF ALREADY EXISTS
    drugrunMenu:ClearItems()

    -- POPULATE MENU
    if not drugrun.isRunning then
        if DoesVehicleHaveDoor(veh, 5) and IsThisModelACar(GetEntityModel(veh)) then
            for drug in pairs(drugrunProducts) do
                local button = drugrunMenu:AddButton({icon = "", label = drug, select = function()
                    menuV:CloseAll()
                    if #(GetEntityCoords(veh) - startingPoint.pos) > 3.0 or not IsPedSittingInAnyVehicle(ped) then
                        exports["soe-ui"]:SendAlert("error", "You went too far or are not in a vehicle!", 5000)
                        return
                    end
                    AttemptToStartDrugRun(ped, veh, startingPoint, drug)
                end})
            end
        else
            exports["soe-ui"]:SendAlert("error", "Can't traffick in this vehicle", 5000)
        end
    else
        local button = drugrunMenu:AddButton({icon = "❌", label = "Cancel Run", select = function()
            menuV:CloseAll()
            AttemptToStartDrugRun(ped, veh, startingPoint)
        end})
    end

    drugrunMenu:Open()
    drugrun.isMenuOpen = true
end

-- ON MENU CLOSED
drugrunMenu:On("close", function(menu)
    drugrun.isMenuOpen = false
end)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, CANCEL DRUG RUN BECAUSE PLAYER WAS ARRESTED
RegisterNetEvent("Prison:Client:ArrestPlayer")
AddEventHandler("Prison:Client:ArrestPlayer", function()
    local plate, vin, netID = GetVehicleNumberPlateText(drugrun.veh), DecorGetInt(drugrun.veh, "vin"), NetworkGetNetworkIdFromEntity(drugrun.veh)
    local hasEndedDrugRun = exports["soe-nexus"]:TriggerServerCallback("Crime:Server:EndDrugRun", netID, plate, vin, false, drugrun.product)
    if hasEndedDrugRun then
        drugrun.enroute = false
        drugrun.totalPayout = 0
        drugrun.isRunning = false
        drugrun.deliveryTimes = 0
        RemoveBlip(drugrun.blip)
        drugrun.blip = nil
    end
end)

-- WHEN TRIGGERED, DO INTERACTION KEYPRESS
AddEventHandler("Utils:Client:InteractionKey", function()
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
        return
    end
    local ped = PlayerPedId()

    -- IF WE ARE AT THE DROPOFF POINT
    if drugrun.enroute then
        DoDropoffTasks(ped)
    end

    local veh = GetVehiclePedIsIn(ped, false)
    for _, point in pairs(drugrunStartingPoints) do
        -- IF WE ARE CLOSE ENOUGH AND INSIDE A VEHICLE
        if not drugrun.supplying then
            if #(GetEntityCoords(veh) - point.pos) <= 3.0 then
                OpenDrugRunningMenu(ped, veh, point)
            end
        end
    end
end)
