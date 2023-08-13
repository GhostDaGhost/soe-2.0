local rentalBlips = {}
local myRentedBikes = {}
local lastBikeRental = 0

-- **********************
--    Local Functions
-- **********************
-- SPAWNS BIKE RACKS ANYWHERE A BIKE CAN BE RENTED
local function SpawnBikeRacks()
    exports["soe-utils"]:LoadModel(GetHashKey("prop_bikerack_2"), 15)
    for rackID, rack in pairs(bikeRentals) do
        local obj = CreateObject(GetHashKey("prop_bikerack_2"), rack.pos.x, rack.pos.y, rack.pos.z - 1.0, 0, 1, 0)
        SetEntityRotation(obj, 0.0, 0.0, rack.yaw, 1, true)
        SetEntityCollision(obj, false, false)

        -- CREATE MARKERS FOR BIKE RENTAL SPOT
        exports["soe-utils"]:AddMarker("BikeRental-" .. rackID, {27, rack.pos.x, rack.pos.y, rack.pos.z - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 102, 161, 0, 155, 0, 0, 2, 0, 0, 0, 0, 18.0})
    end
end

-- TOGGLE BIKE RENTAL BLIPS
local function ToggleRentalBlips()
    if #rentalBlips <= 0 then
        exports["soe-ui"]:SendAlert("debug", "Bike Rental Blips: On", 3500)
        for _, rental in pairs(bikeRentals) do
            local blip = AddBlipForCoord(rental.pos)
            SetBlipSprite(blip, 226)
            SetBlipColour(blip, 66)
            SetBlipScale(blip, 0.65)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Bicycle Rental")
            EndTextCommandSetBlipName(blip)
            table.insert(rentalBlips, blip)
        end
    else
        exports["soe-ui"]:SendAlert("debug", "Bike Rental Blips: Off", 3500)
        for _, blip in pairs(rentalBlips) do
            RemoveBlip(blip)
        end
        rentalBlips = {}
    end
end

-- RETURNS BICYCLE BACK INTO RENTAL
local function ReturnMyBicycle()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    local plate = GetVehicleNumberPlateText(veh)

    local found
    for bikeID, bikeData in pairs(myRentedBikes) do
        if (bikeData.plate == plate) then
            found = bikeID
        end
    end

    if found then
        TaskLeaveVehicle(ped, veh, 1)
        table.remove(myRentedBikes, found)

        -- ALT
        --TriggerEvent('persistent-vehicles/forget-vehicle', veh)

        Wait(2000)
        --exports["soe-valet"]:RemoveKey(veh)
        TriggerServerEvent("Utils:Server:DeleteEntity", VehToNet(veh))
        exports["soe-ui"]:SendAlert("inform", "You returned the bicycle", 5000)
    end
end

-- RENTS BICYCLE FROM NEAREST RACK
local function RentMyBicycle()
    local myRack
    local pos = GetEntityCoords(PlayerPedId())
    for _, rack in pairs(bikeRentals) do
        if #(pos - rack.pos) <= 3.0 then
            myRack = rack
            break
        end
    end

    -- IF WE ARE IN A COOLDOWN, DENY RENTAL
    if myRack then
        if (lastBikeRental ~= 0) and (GetGameTimer() - lastBikeRental) <= 120000 then
            exports["soe-ui"]:SendAlert("error", "You can only rent one bike every 2 minutes", 6500)
            return
        end

        -- SPAWN BIKE AFTER WE FOUND OUR CLOSEST RACK
        lastBikeRental = GetGameTimer()
        exports["soe-utils"]:LoadModel(GetHashKey(myRack.model), 15)
        local bike = exports["soe-utils"]:SpawnVehicle(GetHashKey(myRack.model), vector4(myRack.pos.x, myRack.pos.y, myRack.pos.z, 0.0))

        -- GIVE KEYS AND SET RENTAL STATUS OF BIKE
        exports["soe-valet"]:UpdateKeys(bike)
        exports["soe-utils"]:SetRentalStatus(bike)

        -- ADD THE BIKE TO OUR PERSONAL LIST
        DecorSetBool(bike, "noInventoryLoot", true)
        exports["soe-ui"]:SendAlert("success", "You rented a bike", 6500)
        table.insert(myRentedBikes, {plate = GetVehicleNumberPlateText(bike)})
    end
end

-- **********************
--    Global Functions
-- **********************
-- RETURNS IF PLAYER IS NEAR A STORE
function IsNearBikeRental()
    local pos = GetEntityCoords(PlayerPedId())
    for _, rack in pairs(bikeRentals) do
        if #(pos - rack.pos) <= 3.0 then
            return true
        end
    end
    return false
end

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, TOGGLE BIKE RENTAL BLIPS
RegisterCommand("bikerentals", ToggleRentalBlips)

-- RENTS BICYCLE
AddEventHandler("Shops:Client:RentBike", RentMyBicycle)

-- RETURNS RENTED BICYCLE
AddEventHandler("Shops:Client:ReturnRentedBike", ReturnMyBicycle)

-- SPAWNS BIKE RACKS
AddEventHandler("onClientResourceStart", function(resource)
    if (GetCurrentResourceName() ~= resource) then return end
    Wait(3500)

    SpawnBikeRacks()
end)
