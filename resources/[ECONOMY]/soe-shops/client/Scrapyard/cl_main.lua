local action

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, CONFIRM OR DENY SCRAPPING OF THIS VEHICLE
local function ConfirmScrap()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    local vin = DecorGetInt(veh, "vin")
    if (vin == 0) then
        exports["soe-ui"]:SendAlert("error", "This vehicle ain't yours", 5000)
        return
    end

    -- DRIVER SEAT CHECK
    if (GetPedInVehicleSeat(veh, -1) ~= ped) then
        exports["soe-ui"]:SendAlert("error", "You are not the driver", 5000)
        return
    end

    local plate = GetVehicleNumberPlateText(veh)
    local hash = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
    --print("VEH ID: " .. veh .. " | HASH: " .. hash)

    -- GET PRICE FROM THE SERVER AND PERFORM A CONFIRMATION
    local price = exports["soe-nexus"]:TriggerServerCallback("Shops:Server:GetScrapPrice", hash)
    exports["soe-input"]:OpenConfirmDialogue("Are you sure you want to scrap this vehicle? You will get $" .. tostring(price), "Yes", "No", function(returnData)
        if returnData then
            TriggerServerEvent("Shops:Server:ConfirmVehicleScrap", {response = returnData, vin = vin, hash = hash, plate = plate})
        else
            exports["soe-ui"]:SendAlert("error", "You chose not to scrap this vehicle", 5000)
        end
    end)
end

-- **********************
--        Events
-- **********************
-- ON ZONE ENTRANCE
AddEventHandler("Utils:Client:EnteredZone", function(name)
    if name:match("scrapyard") then
        if IsPedSittingInAnyVehicle(PlayerPedId()) then
            action = {status = true}
            exports["soe-ui"]:ShowTooltip("fas fa-car-crash", "[E] Scrap Vehicle", "inform")
        end
    end
end)

-- ON ZONE EXIT
AddEventHandler("Utils:Client:ExitedZone", function(name)
    if name:match("scrapyard") then
        action = nil
        exports["soe-ui"]:HideTooltip()
    end
end)

-- ON INTERACTION KEYPRESS
AddEventHandler("Utils:Client:InteractionKey", function()
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
        return
    end

    if not action then return end
    if action.status and IsPedSittingInAnyVehicle(PlayerPedId()) then
        ConfirmScrap()
    end
end)

-- ON SCRAP SUCCESSFUL
RegisterNetEvent("Shops:Client:ScrapVehicle")
AddEventHandler("Shops:Client:ScrapVehicle", function(data)
    if not data.response then return end

    -- MAKE THE PED LEAVE THE VEHICLE BEFORE DESPAWNING
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    TaskLeaveVehicle(ped, veh, 0)
    Wait(2500)

    -- DELETE THE VEHICLE ENTITY
    --exports["soe-valet"]:RemoveKey(veh)
    TriggerServerEvent("Utils:Server:DeleteEntity", VehToNet(veh))
end)
