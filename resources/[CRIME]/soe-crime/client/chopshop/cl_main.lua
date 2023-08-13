local isCutting = false
local chopShopList, removedParts = {}, {}
local startChopping, vehicleToBeChopped = false, nil
local chopShopCarBlacklist = {"HAKUCHOU", "BATI", "SANCHEZ", "SANCHEZ2", "FAGGIO", "FAGGIO2", "DUNE"}

-- DISPLAYS CURRENT CHOP SHOP LIST
local function DisplayChopList()
    local list = ""
    for _, vehicle in pairs(chopShopList) do
        local name = GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(vehicle)))
        list = list .. name .. ", "
    end
    TriggerEvent("Chat:Client:Message", "[Chop Shop]", ("We are looking for the following: %s"):format(list), "standard")
    TriggerEvent("Chat:Client:Message", "[Chop Shop]", "We refresh our list every 30 minutes.", "standard")
end

-- TURNS IN VEHICLE IF VALID INTO THE CHOP SHOP
local function TurnInVehicle()
    local ped = PlayerPedId()
    local found, myVeh = false, GetVehiclePedIsIn(ped, false)
    local myVehName = GetDisplayNameFromVehicleModel(GetEntityModel(myVeh))
    for _, vehicle in pairs(chopShopList) do
        if (GetLabelText(myVehName) == GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(vehicle)))) then
            found = vehicle
            break
        end
    end

    if found then
        -- CHECKS VEHICLE'S HEALTH IF ITS ACCEPTABLE
        if (GetEntityHealth(myVeh) >= GetEntityMaxHealth(myVeh) - 250 and GetVehicleEngineHealth(myVeh) >= 750) then
            TaskLeaveVehicle(ped, myVeh, 0)
            -- CHECK IF VEHICLE CAN'T BE WELDED
            local completed, blacklisted = false, false
            for _, vehicle in pairs(chopShopCarBlacklist) do
                if (GetLabelText(myVehName) == GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(vehicle)))) then
                    blacklisted = true
                    break
                end
            end

            if not blacklisted then
                SetVehicleUndriveable(myVeh, true)
                startChopping, vehicleToBeChopped = true, myVeh
                exports["soe-ui"]:PersistentAlert("start", "chopVehicle", "inform", "[E] Cut Door", 500)
                TriggerEvent("Chat:Client:Message", "[Chop Shop]", "Thats one of them! Do us a favor and cut out the doors please.", "bank")
                while startChopping do
                    Wait(250)
                    -- EXIT CHOP MODE IF PLAYER DIES OR ENTITY IS DELETED
                    if exports["soe-emergency"]:IsDead() or not DoesEntityExist(myVeh) then
                        startChopping = false
                        return
                    end
                end

                vehicleToBeChopped = nil
                exports["soe-ui"]:PersistentAlert("end", "chopVehicle")
                TriggerServerEvent("Crime:Server:ChopVehicle", {status = true, veh = found, class = GetVehicleClass(myVeh)})
                Wait(2500)
                -- ALT
                --TriggerEvent('persistent-vehicles/forget-vehicle', myVeh)

                TriggerServerEvent("Utils:Server:DeleteEntity", VehToNet(myVeh))
            else
                TriggerServerEvent("Crime:Server:ChopVehicle", {status = true, veh = found, class = GetVehicleClass(myVeh)})
                Wait(2500)
                
                -- ALT
                --TriggerEvent('persistent-vehicles/forget-vehicle', myVeh)
                
                TriggerServerEvent("Utils:Server:DeleteEntity", VehToNet(myVeh))
            end
        else
            TriggerEvent("Chat:Client:Message", "[Chop Shop]", "We cannot accept the vehicle in this condition!", "system")
        end
    else
        TriggerEvent("Chat:Client:Message", "[Chop Shop]", "Thats not the vehicle we are looking for.", "system")
    end
end

-- RETURNS TRUE IF NEAR A CHOP SHOP DROPOFF
function IsNearChopShopDropOff()
    for _, shop in pairs(chopShops) do
        if #(GetEntityCoords(PlayerPedId()) - shop.dropOff) <= 3.5 then
            return true
        end
    end
    return false
end

-- RETURNS TRUE IF NEAR A CHOP SHOP
function IsNearChopShop()
    for _, shop in pairs(chopShops) do
        if #(GetEntityCoords(PlayerPedId()) - shop.list) <= 3.5 then
            return true
        end
    end
    return false
end

-- REQUESTED FROM RADIAL MENU TO TURN IN CURRENT VEHICLE
AddEventHandler("Crime:Client:TurnInChopShopVehicle", TurnInVehicle)

-- REQUESTED FROM RADIAL MENU TO DISPLAY THE CURRENT CHOP LIST
AddEventHandler("Crime:Client:DisplayChopShopList", DisplayChopList)

-- SYNCS THIS LIST WITH SERVER'S LIST
RegisterNetEvent("Crime:Client:RequestChopShopList")
AddEventHandler("Crime:Client:RequestChopShopList", function(_chopShopList)
    chopShopList = _chopShopList
end)

-- UPON RESOURCE START, REQUEST OUR 'SHOPPING' LIST
AddEventHandler("onClientResourceStart", function(resource)
    if (GetCurrentResourceName() ~= resource) then return end
    Wait(3500)

    TriggerServerEvent("Crime:Server:RequestChopShopList")
end)

-- INTERACTION KEY TO REMOVE VEHICLE DOORS DURING CHOPPING
AddEventHandler("Utils:Client:InteractionKey", function()
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
        return
    end

    if startChopping then
        if isCutting then return end

        local veh = exports["soe-utils"]:GetVehInFrontOfPlayer(5.0)
        if (veh ~= nil) and (veh == vehicleToBeChopped) then
            -- GAIN ENTITY CONTROL
            exports["soe-utils"]:GetEntityControl(veh)
    
            -- GRAB OUR CLOSEST DOOR
            local closestDoor = exports["soe-utils"]:GetClosestVehicleDoor(veh)
            if (closestDoor.pos == nil) then return end

            local ped = PlayerPedId()
            if #(GetEntityCoords(ped) - closestDoor.pos) <= 3.0 then
                if IsPedSittingInAnyVehicle(ped) then return end

                isCutting = true
                ClearPedTasks(ped)
                TaskTurnPedToFaceEntity(ped, veh, -1)
                Wait(100)
                TaskStartScenarioInPlace(ped, "WORLD_HUMAN_WELDING", 1, 1)

                math.randomseed(GetGameTimer())
                Wait(math.random(10000, 14000))
                ClearPedTasks(ped)
                SetVehicleDoorBroken(veh, closestDoor.id, false)
                removedParts[#removedParts + 1] = true
                print(#removedParts)
                print(GetNumberOfVehicleDoors(veh))

                if #removedParts == GetNumberOfVehicleDoors(veh) then
                    startChopping = false
                    removedParts = {}
                end
                isCutting = false
            end
        end
    end
end)
