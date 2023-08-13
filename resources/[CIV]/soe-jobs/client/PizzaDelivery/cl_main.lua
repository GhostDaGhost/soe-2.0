local pizza = {}
local action = nil

local function DoPizzaTasks()
    local ped = PlayerPedId()
    if not pizza.hasDeliveryBox and not IsPedSittingInAnyVehicle(ped) then
        -- GRABBING PIZZA BOX FROM MOPED
        if #(GetEntityCoords(ped) - GetEntityCoords(pizza.veh)) <= 1.5 then
            pizza.hasDeliveryBox = true
            exports["soe-ui"]:ToggleMinimap(true)
            exports["soe-emotes"]:StartEmote("pizzabox")
            return
        end
    elseif pizza.hasDeliveryBox and not IsPedSittingInAnyVehicle(ped) then
        -- DELIVERING
        if #(GetEntityCoords(ped) - pizza.destination.pos) <= 2.0 then
            pizza.destination = nil
            pizza.delivering = false
            pizza.needsRestocking = true
            pizza.hasDeliveryBox = false

            exports["soe-utils"]:LoadAnimDict("anim@heists@money_grab@briefcase", 15)
            TaskPlayAnim(ped, "anim@heists@money_grab@briefcase", "put_down_case", 8.0, -8.0, 1350, 0, 0, 0, 0, 0)

            RemoveBlip(pizza.blip)
            pizza.blip = nil

            exports["soe-emotes"]:CancelEmote()
            exports["soe-ui"]:ToggleMinimap(false)
            exports["soe-ui"]:PersistentAlert("end", "pizzaJob")
            TriggerServerEvent("Jobs:Server:FinishPizzaDelivery", {status = true})
            return
        end
    end
end

-- FUNCTION TO CHOOSE A RANDOM PIZZA DELIVERY DESTINATION
local function SetMyNextDestination()
    -- RANDOMIZE AND SELECT
    math.randomseed(GetGameTimer())
    math.random() math.random() math.random()
    pizza.destination = pizzaDeliveryDestinations[math.random(1, #pizzaDeliveryDestinations)]
    exports["soe-ui"]:PersistentAlert("start", "pizzaJob", "inform", pizza.destination.msg, 100)
    exports["soe-ui"]:SendAlert("warning", "Make sure to get the pizza box from your moped when you arrive!", 9500)

    -- SET BLIP TO DESTINATION
    RemoveBlip(pizza.blip)
    pizza.blip = AddBlipForCoord(pizza.destination.pos)
    SetBlipRoute(pizza.blip, true)
    SetBlipRouteColour(pizza.blip, 73)
    pizza.delivering = true
    pizza.hasDeliveryBox = false

    -- START A SMALL RUNTIME LOOP FOR MARKER AND EMOTE
    CreateThread(function()
        local sleep = 250
        while pizza.delivering do
            Wait(sleep)
            if pizza.hasDeliveryBox then
                if not IsEntityPlayingAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 3) then
                    pizza.hasDeliveryBox = false
                    exports["soe-ui"]:ToggleMinimap(false)
                end
            end

            if pizza.destination then
                if pizza.destination.pos then
                    if #(GetEntityCoords(PlayerPedId()) - pizza.destination.pos) <= 10.5 then
                        sleep = 5
                        DrawMarker(21, pizza.destination.pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 224, 142, 0, 155, 0, 1, 2, 0, 0, 0, 0)
                    else
                        sleep = 250
                    end
                end
            end
        end
    end)
end

-- FUNCTION TO SPAWN DELIVERY VEHICLE
local function ManageDeliveryVehicle(pos, needsSpawning)
    if needsSpawning then
        -- SPAWN DELIVERY VEHICLE AND GIVE PLAYER THE KEYS
        pizza.veh = exports["soe-utils"]:SpawnVehicle("pizzamoped", pos)
        local plate = exports["soe-utils"]:GenerateRandomPlate()
        SetVehicleNumberPlateText(pizza.veh, plate)
        Wait(500)

        exports["soe-valet"]:UpdateKeys(pizza.veh)

        -- SET IT AS A RENTAL
        exports["soe-utils"]:SetRentalStatus(pizza.veh)
        SetEntityAsMissionEntity(pizza.veh, true, true)
        DecorSetBool(pizza.veh, "noInventoryLoot", true)
    else
        -- IF MOPED IS IN PROXIMITY, DESPAWN IT
        if #(GetEntityCoords(pizza.veh) - vector3(pos.x, pos.y, pos.z)) <= 10.5 then
            --exports["soe-valet"]:RemoveKey(pizza.veh)
            TriggerServerEvent("Utils:Server:DeleteEntity", VehToNet(pizza.veh))
        else
            local plate = GetVehicleNumberPlateText(pizza.veh)
            TriggerServerEvent("Emergency:Server:MarkStolen", plate, true, true)
            exports["soe-ui"]:SendAlert("error", "The pizzeria manager does not see the moped anywhere. They reported it stolen.")
        end

        pizza.veh = nil
    end
end

-- TOGGLES PIZZA DELIVERING DUTY
local function ToggleDuty(state)
    if state then
        SetMyNextDestination()
        ManageDeliveryVehicle(action.spawnLoc, true)
        TriggerServerEvent("Jobs:Server:ToggleDuty", {status = true, dutyStatus = true, job = "PIZZA"})
    else
        RemoveBlip(pizza.blip)
        exports["soe-emotes"]:CancelEmote()
        exports["soe-ui"]:ToggleMinimap(false)

        ManageDeliveryVehicle(action.spawnLoc, false)
        exports["soe-ui"]:PersistentAlert("end", "pizzaJob")
        TriggerServerEvent("Jobs:Server:ToggleDuty", {status = true, dutyStatus = false, job = "PIZZA"})
        pizza = {}
    end
end

AddEventHandler("Utils:Client:EnteredZone", function(name, zoneData)
    if name:match("pizzeria") then
        action = {status = true, spawnLoc = zoneData.spawn}
        if (GetMyJob() == "PIZZA") then
            if pizza.needsRestocking then
                exports["soe-ui"]:ShowTooltip("fas fa-pizza-slice", "[E] Restock Pizza", "inform")
            else
                exports["soe-ui"]:ShowTooltip("fas fa-pizza-slice", "[E] Quit Job", "inform")
            end
        else
            exports["soe-ui"]:ShowTooltip("fas fa-pizza-slice", "[E] Start Job", "inform")
        end
    end
end)

AddEventHandler("Utils:Client:ExitedZone", function(name)
    if name:match("pizzeria") then
        action = nil
        exports["soe-ui"]:HideTooltip()
    end
end)

AddEventHandler("Utils:Client:InteractionKey", function()
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
        return
    end

    -- DESTINATION / MOPED INTERACTION HERE
    if pizza.delivering then
        DoPizzaTasks()
    end

    -- ZONE FUNCTIONS RELATED TO PIZZA DUTY TOGGLE
    if not action then return end
    if action.status then
        if (GetMyJob() == "PIZZA") then
            if pizza.needsRestocking then
                pizza.needsRestocking = false
                SetMyNextDestination()
                return
            end
            ToggleDuty(false)
        else
            ToggleDuty(true)
        end
    end
end)
