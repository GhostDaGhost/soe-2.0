local action
local supplier = {}
local supplierMenu = menuV:CreateMenu("Gang Supplier", "We got the best stuff", "topright", 209, 168, 92, "size-100", "default", "menuv", "supplierMenu", "native")

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, DELIVER THE SUPPLY WHEN AT THE DESTINATION
local function DeliverSupply()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if (GetVehicleNumberPlateText(veh) == supplier.plate) then
        if supplier.deliveredVan then return end
        supplier.deliveredVan = true
        
        exports["soe-ui"]:SendAlert("debug", "You turn in the van and the local gang begin to extract the crate", 9000)
        SetVehicleHandbrake(veh, true)

        exports["soe-utils"]:Progress(
            {
                name = "extractingCrate",
                duration = math.random(12500, 15500),
                label = "Extracting Crate",
                useWhileDead = false,
                canCancel = false,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = false
                }
            },
            function(cancelled)
                if not cancelled then
                    local givenCrate = exports["soe-nexus"]:TriggerServerCallback("Crime:Server:GiveSupplyCrate", supplier.stock, supplier.spot)
                    if givenCrate then
                        TaskLeaveVehicle(PlayerPedId(), veh, 1)
                        Wait(2500)
                        TriggerServerEvent("Utils:Server:DeleteEntity", VehToNet(veh))
                        RemoveBlip(supplier.blip)

                        supplier.npcs = {}
                        supplier.transporting = false
                        supplier.currentMission = nil
                        supplier.blip, supplier.van, supplier.plate = nil, nil, nil
                    end
                end
            end
        )
    end
end

-- WHEN TRIGGERED, SPAWN ANY ENTITIES RELATED TO THE SUPPLY MISSION
local function SpawnMissionEntities(mission)
    --print("CLOSE ENOUGH! LETS SPAWN THE STUFFS.")
    if not supplier.npcs then
        supplier.npcs = {}
    end

    local ped = PlayerPedId()
    SetPedRelationshipGroupHash(ped, GetHashKey("PLAYER"))
    AddRelationshipGroup("supplyMissionGoons")

    -- SPAWN ANY NPCs
    exports["soe-utils"]:LoadModel(mission.ped, 15)
    for _, npc in pairs(mission.npcs) do
        local ped = CreatePed(4, mission.ped, npc.pos.x, npc.pos.y, npc.pos.z, npc.pos.w, true, false)
        local weapon = npc.weapons[math.random(1, #npc.weapons)]

        GiveWeaponToPed(ped, GetHashKey(weapon), 10000, false, true)
        SetPedDropsWeaponsWhenDead(ped, false)
        SetPedFleeAttributes(ped, 0, false)
        SetPedArmour(ped, math.random(80, 95))
        SetPedAccuracy(ped, math.random(50, 75))
        SetPedAlertness(ped, 3)
        SetPedSeeingRange(ped, 250.0)

        SetEntityAsMissionEntity(ped, true, true)
        SetPedRelationshipGroupHash(ped, GetHashKey("supplyMissionGoons"))	
        TaskGuardCurrentPosition(ped, 5.0, 5.0, 1)

        -- A BUNCH OF RELATIONSHIP SORTING :(
        SetRelationshipBetweenGroups(0, GetHashKey("supplyMissionGoons"), GetHashKey("COP"))
        SetRelationshipBetweenGroups(0, GetHashKey("COP"), GetHashKey("supplyMissionGoons"))
        SetRelationshipBetweenGroups(0, GetHashKey("supplyMissionGoons"), GetHashKey("SECURITY_GUARD"))
        SetRelationshipBetweenGroups(0, GetHashKey("SECURITY_GUARD"), GetHashKey("supplyMissionGoons"))
        SetRelationshipBetweenGroups(0, GetHashKey("supplyMissionGoons"), GetHashKey("PRIVATE_SECURITY"))
        SetRelationshipBetweenGroups(0, GetHashKey("PRIVATE_SECURITY"), GetHashKey("supplyMissionGoons"))
        SetRelationshipBetweenGroups(0, GetHashKey("supplyMissionGoons"), GetHashKey("supplyMissionGoons"))
        SetRelationshipBetweenGroups(5, GetHashKey("supplyMissionGoons"), GetHashKey("PLAYER"))
        SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("supplyMissionGoons"))
        table.insert(supplier.npcs, ped)
    end

    -- RANDOMIZE VEHICLE MODEL THAT WILL SPAWN
    local randomVehicle = mission.vehicles[math.random(1, #mission.vehicles)]
    randomVehicle = GetHashKey(randomVehicle)

    -- SPAWN THE VEHICLE
    TriggerServerEvent("Utils:Server:ClearVehiclesInRadius", mission.vehiclePos.x, mission.vehiclePos.y, mission.vehiclePos.z, 3.0)
    Wait(3500)

    exports["soe-utils"]:LoadModel(randomVehicle, 15)
    supplier.van = CreateVehicle(randomVehicle, mission.vehiclePos.x, mission.vehiclePos.y, mission.vehiclePos.z, mission.vehiclePos.w, true, false)
    supplier.plate = GetVehicleNumberPlateText(supplier.van)

    -- SET VEHICLE PROPERTIES
    TriggerEvent("persistent-vehicles/register-vehicle", supplier.van)

    SetVehicleDoorsLocked(supplier.van, 2)
    DecorSetBool(supplier.van, "unlocked", false)
    exports["soe-fuel"]:SetFuel(supplier.van, math.random(80, 100))
end

-- WHEN TRIGGERED, START A SUPPLY MISSION
local function StartSupplyRun()
    local myMission = supplier.currentMission
    --print(json.encode(myMission))

    -- SET A BLIP FOR THE DELIVERY VEHICLE
    supplier.blip = AddBlipForCoord(myMission.vehiclePos)
    SetBlipSprite(supplier.blip, 641)
    SetBlipColour(supplier.blip, 54)
    SetBlipScale(supplier.blip, 1.05)
    SetBlipFlashes(supplier.blip, true)
    SetBlipFlashInterval(supplier.blip, 550)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Supply Vehicle")
    EndTextCommandSetBlipName(supplier.blip)

    -- START A RUNTIME LOOP FOR THE MISSION
    while not supplier.isAtDestination do
        Wait(1500)
        local pos = GetEntityCoords(PlayerPedId())
        local dist = #(pos - vector3(myMission.vehiclePos.x, myMission.vehiclePos.y, myMission.vehiclePos.z))

        if (dist <= 450.0) then
            if supplier.isAtDestination then return end

            supplier.isAtDestination = true
            SpawnMissionEntities(myMission)
        end
    end
end

-- WHEN TRIGGERED, OPEN SUPPLIER MENU IF ALL CHECKS PASS
local function OpenSupplierMenu(supplyType)
    local canAccessMenu = exports["soe-nexus"]:TriggerServerCallback("Crime:Server:SupplierMenuChecks", supplyType)
    if canAccessMenu then
        if supplier.isMenuOpen then return end
        supplierMenu:ClearItems()

        if (supplyType == "Weapons") then
            supplierMenu:SetSubtitle("We got all the weapons you need. Each crate contains 5 of the item")
        elseif (supplyType == "Drugs") then
            supplierMenu:SetSubtitle("We got all the drugs you need")
        end

        for _, stock in pairs(supplyStock[tostring(supplyType)]) do
            local price = 150000
            if exports["soe-config"]:GetConfigValue("economy", stock.hash) then
                price = exports["soe-config"]:GetConfigValue("economy", stock.hash).buy
            end

            local buttonText = ("%s <span style='float:right;color:lightgreen;'>$%s</span>"):format(stock.name, price)
            local button = supplierMenu:AddButton({icon = stock.icon, label = buttonText, select = function()
                menuV:CloseAll()
                local startedMission = exports["soe-nexus"]:TriggerServerCallback("Crime:Server:StartSupplierMission", supplyType, stock.hash, price)
                if startedMission.status then
                    supplier.stock = stock
                    supplier.type = supplyType
                    supplier.currentMission = startedMission.data
                    supplier.spot = startedMission.spot
                    StartSupplyRun()
                end
            end})
        end

        supplierMenu:Open()
        supplier.isMenuOpen = true
    end
end

-- ON MENU CLOSED
supplierMenu:On("close", function(menu)
    supplier.isMenuOpen = false
end)

-- **********************
--        Events
-- **********************
-- IF WE ENTERED A ZONE
AddEventHandler("Utils:Client:EnteredZone", function(name, zoneData)
    if not name:match("crimesupplier") then return end

    action = {status = true, type = zoneData.type}
    exports["soe-ui"]:ShowTooltip("fas fa-users", ("[E] Gang %s Supplier"):format(zoneData.type), "inform")
end)

-- IF WE LEFT A ZONE
AddEventHandler("Utils:Client:ExitedZone", function(name)
    if not name:match("crimesupplier") then return end

    action = nil
    exports["soe-ui"]:HideTooltip()
    if supplier.isMenuOpen then
        menuV:CloseAll()
        supplier.isMenuOpen = false
    end
end)

-- INTERACTION KEYPRESS
AddEventHandler("Utils:Client:InteractionKey", function()
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
        return
    end

    if supplier.collectedVan and #(GetEntityCoords(PlayerPedId()) - supplier.destination) <= 5.0 and not supplier.deliveredVan then
        DeliverSupply()
        return
    end

    if not action then return end
    if action.status then
        OpenSupplierMenu(action.type)
    end
end)

-- WHEN TRIGGERED, CHECK IF PLAYER GOT INTO THE SUPPLY VAN
AddEventHandler("BaseEvents:Client:EnteredVehicle", function(veh, seat)
    if (seat ~= -1) then return end

    if supplier.currentMission then
        local plate = GetVehicleNumberPlateText(veh)
        if (supplier.plate == plate) then
            if supplier.collectedVan then
                return
            end
            supplier.collectedVan = true
            TriggerServerEvent("Emergency:Server:MarkStolen", plate, true, true)

            RemoveBlip(supplier.blip)
            math.randomseed(GetGameTimer() + 100)
            supplier.destination = supplyLocations["Destinations"][math.random(1, #supplyLocations["Destinations"])]
            exports["soe-ui"]:SendAlert("debug", "Take this van to the destination! Check your GPS!", 25000)

            supplier.blip = AddBlipForCoord(supplier.destination)
            SetBlipSprite(supplier.blip, 587)
            SetBlipColour(supplier.blip, 19)
            SetBlipScale(supplier.blip, 1.05)
            SetBlipFlashes(supplier.blip, true)
            SetBlipFlashInterval(supplier.blip, 550)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Supply Rendezvous")
            EndTextCommandSetBlipName(supplier.blip)

            local sleep = 1500
            supplier.transporting = true
            while supplier.transporting do
                Wait(sleep)
                -- MINI-MARKER MANAGER FOR SUPPLY DESTINATION
                if #(GetEntityCoords(PlayerPedId()) - supplier.destination) <= 15.0 then
                    sleep = 5
                    DrawMarker(27, supplier.destination.x, supplier.destination.y, supplier.destination.z - 0.92, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.2, 3.2, 3.2, 19, 40, 110, 105, 0, 0, 2, 0, 0, 0, 0)
                else
                    sleep = 1500
                end

                -- SUPPLY VEHICLE EXISTENCE CHECK
                if not supplier.transporting then return end
                if IsEntityDead(supplier.van) or not DoesEntityExist(supplier.van) then
                    supplier.transporting = false
                    exports["soe-ui"]:SendAlert("error", "The van was lost!", 5000)
                    RemoveBlip(supplier.blip)

                    supplier.npcs = {}
                    supplier.currentMission = nil
                    supplier.blip, supplier.van, supplier.plate = nil, nil, nil
                end
            end
        end
    end
end)
