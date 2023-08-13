local threadTime = 350
local currentSeat, currentVehicle, isInVehicle, isEnteringVehicle = 0, 0, false, false
local currentBodyHealth, previousBodyHealth, currentSpeed, previousSpeed, currentVelocity, previousVelocity

function GetPedVehicleSeat(ped)
    local veh = GetVehiclePedIsIn(ped, false)
    for i = -2, GetVehicleMaxNumberOfPassengers(veh) do
        if (GetPedInVehicleSeat(veh, i) == ped) then
            return i
        end
    end
    return -2
end

CreateThread(function()
    Wait(3500)
    while true do
        Wait(threadTime)

        local ped = PlayerPedId()
        if not isInVehicle and not IsPlayerDead(PlayerId()) then
            threadTime = 400
            -- TRYING TO ENTER A VEHICLE
            if DoesEntityExist(GetVehiclePedIsTryingToEnter(ped)) and not isEnteringVehicle then
                threadTime = 135
                local veh = GetVehiclePedIsTryingToEnter(ped)
                local seat = GetSeatPedIsTryingToEnter(ped)
                local netId = VehToNet(veh)
                isEnteringVehicle = true
                TriggerServerEvent("BaseEvents:Server:EnteringVehicle", veh, seat, GetDisplayNameFromVehicleModel(GetEntityModel(veh)), netId)
                TriggerEvent("BaseEvents:Client:EnteringVehicle", veh, seat, GetDisplayNameFromVehicleModel(GetEntityModel(veh)), netId)
            -- ABORTED FROM TRYING TO ENTER A VEHICLE
            elseif not DoesEntityExist(GetVehiclePedIsTryingToEnter(ped)) and not IsPedInAnyVehicle(ped, true) and isEnteringVehicle then
                threadTime = 250
                TriggerServerEvent("BaseEvents:Server:EnteringAborted")
                isEnteringVehicle = false
            -- ENTERED A VEHICLE
            elseif IsPedInAnyVehicle(ped, false) then
                isEnteringVehicle = false
                isInVehicle = true
                currentVehicle = GetVehiclePedIsUsing(ped)
                currentSeat = GetPedVehicleSeat(ped)
                local model = GetEntityModel(currentVehicle)
                local name = GetDisplayNameFromVehicleModel()
                local netId = VehToNet(currentVehicle)
                TriggerServerEvent("BaseEvents:Server:EnteredVehicle", currentVehicle, currentSeat, GetDisplayNameFromVehicleModel(GetEntityModel(currentVehicle)), netId)
                TriggerEvent("BaseEvents:Client:EnteredVehicle", currentVehicle, currentSeat, GetDisplayNameFromVehicleModel(GetEntityModel(currentVehicle)), netId)
            end
        -- LEAVING VEHICLE
        elseif isInVehicle then
            threadTime = 400
            if not IsPedInAnyVehicle(ped, false) or IsPlayerDead(PlayerId()) then
                threadTime = 135
                local model = GetEntityModel(currentVehicle)
                local name = GetDisplayNameFromVehicleModel()
                local netId = VehToNet(currentVehicle)
                TriggerServerEvent("BaseEvents:Server:LeftVehicle", currentVehicle, currentSeat, GetDisplayNameFromVehicleModel(GetEntityModel(currentVehicle)), netId)
                TriggerEvent("BaseEvents:Client:LeftVehicle", currentVehicle, currentSeat, GetDisplayNameFromVehicleModel(GetEntityModel(currentVehicle)), netId)
                isInVehicle = false
                currentVehicle = 0
                currentSeat = 0
            end

            -- CRASHED VEHICLE
            if (currentVehicle and currentVehicle ~= 0) then
                previousSpeed, previousVelocity, previousBodyHealth = currentSpeed, currentVelocity, currentBodyHealth
                currentSpeed, currentVelocity, currentBodyHealth = (GetEntitySpeed(currentVehicle) * 2.236936), GetEntityVelocity(currentVehicle), GetVehicleBodyHealth(currentVehicle)
    
                local healthChange = previousBodyHealth ~= nil and (previousBodyHealth - currentBodyHealth) or 0.0
                if (healthChange >= 15 and previousSpeed > 30.0 and currentSpeed < (previousSpeed * 0.75)) or healthChange >= 4 and HasEntityCollidedWithAnything(currentVehicle) then
                    print("My vehicle has crashed. (Report if too many of these)", currentSpeed, previousSpeed, previousVelocity)
                    TriggerEvent("BaseEvents:Client:VehicleCrashed", currentVehicle, currentSeat, currentSpeed, previousSpeed, previousVelocity)
                end
                threadTime = 135
            end
        end
    end
end)
