-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, FIND THE CLOSEST PLAYER
RegisterNetEvent("Inventory:Client:FindSearchablePlayer")
AddEventHandler("Inventory:Client:FindSearchablePlayer", function(type)
    -- DEATH/HANDCUFF CHECK
    if exports["soe-emergency"]:IsRestrained() or exports["soe-emergency"]:IsDead() then
        return
    end

    -- GET CLOSEST PLAYER
    local nearPlayer = exports["soe-utils"]:GetPedInFrontOfPlayer(5)
    if IsPedAPlayer(nearPlayer) then
        local id = GetPlayerServerId(NetworkGetPlayerIndexFromPed(nearPlayer))
        TriggerServerEvent("Inventory:Server:SendSearchablePlayer", id, type)
    else
        exports["soe-ui"]:SendAlert("error", "Nobody close enough", 5000)
    end
end)

-- WHEN TRIGGERED, FIND THE CLOSEST THING TO SNIFF
RegisterNetEvent("Inventory:Client:DoSniffing")
AddEventHandler("Inventory:Client:DoSniffing", function(data)
    if not data.status then return end
    if exports["soe-emergency"]:IsRestrained() or exports["soe-emergency"]:IsDead() then
        return
    end

    -- CHECK THE TYPE OF SNIFFING
    if (data.type == "proximity") then
        local closestPlayer = exports["soe-utils"]:GetClosestPlayer(5)
        if closestPlayer then
            TriggerServerEvent("Inventory:Server:DoSniffing", {status = true, target = GetPlayerServerId(closestPlayer), type = "proximity"})
        else
            exports["soe-ui"]:SendAlert("error", "Nobody close enough", 5000)
        end
    elseif (data.type == "vehicle") then
        local veh = exports["soe-utils"]:GetVehInFrontOfPlayer(3.0)
        if veh then
            local plate, vehicleNetworkID = GetVehicleNumberPlateText(veh), NetworkGetNetworkIdFromEntity(veh)
            TriggerServerEvent("Inventory:Server:DoSniffing", {status = true, target = vehicleNetworkID, type = "vehicle", data = {plate = plate}})
        else
            exports["soe-ui"]:SendAlert("error", "No vehicle close enough", 5000)
        end
    end
end)

-- WHEN TRIGGERED, PERFORM SEARCH/FRISK ANIMATION
RegisterNetEvent("Inventory:Client:PlaySearchAnim")
AddEventHandler("Inventory:Client:PlaySearchAnim", function()
    local ped = PlayerPedId()

    -- FRISK ANIMATION CONTROLLER
    exports["soe-utils"]:LoadAnimDict("mini@yoga", 15)
    exports["soe-utils"]:LoadAnimDict("missfam5_yoga", 15)
    exports["soe-utils"]:LoadAnimDict("anim@heists@load_box", 15)
    exports["soe-utils"]:LoadAnimDict("anim@heists@box_carry@", 15)
    exports["soe-utils"]:LoadAnimDict("missbigscore2aig_7@driver", 15)

    TaskPlayAnimAdvanced(ped, "anim@heists@load_box", "idle", GetEntityCoords(ped), 0, 0, GetEntityHeading(ped), 1.0, 1.0, 850, 1, 0.0, 0, 0)
    Wait(730)
    TaskPlayAnimAdvanced(ped, "anim@heists@box_carry@", "idle", GetEntityCoords(ped), 0, 0, GetEntityHeading(ped), 1.0, 1.0, 600, 1, 0.0, 0, 0)
    Wait(730)
    TaskPlayAnimAdvanced(ped, "missfam5_yoga", "start_pose", GetEntityCoords(ped), 0, 0, GetEntityHeading(ped), 1.0, 1.0, 750, 1, 0.0, 0, 0)
    Wait(730)
    TaskPlayAnimAdvanced(ped, "missbigscore2aig_7@driver", "boot_r_loop", GetEntityCoords(ped), 0, 0, (GetEntityHeading(ped) - 20), 1.0, 1.0, 1000, 1, 0.0, 0, 0)
    Wait(850)
    TaskPlayAnimAdvanced(ped, "mini@yoga", "outro_2", GetEntityCoords(ped), 0, 0, GetEntityHeading(ped), 1.0, 1.0, 1500, 1, 0.0, 0, 0)
    Wait(820)
    TaskPlayAnimAdvanced(ped, "missfam5_yoga", "start_pose", GetEntityCoords(ped), 0, 0, GetEntityHeading(ped), 1.0, 1.0, 750, 1, 0.0, 0, 0)
    Wait(750)
    TaskPlayAnimAdvanced(ped, "missbigscore2aig_7@driver", "boot_l_loop", GetEntityCoords(ped), 0, 0, (GetEntityHeading(ped) + 40), 1.0, 1.0, 1000, 1, 0.0, 0, 0)
    Wait(700)
    TaskPlayAnimAdvanced(ped, "mini@yoga", "outro_2", GetEntityCoords(ped), 0, 0, GetEntityHeading(ped), 1.0, 1.0, 1500, 1, 0.0, 0, 0)
end)

-- WHEN TRIGGERED, LOOK FOR THE CLOSEST VEHICLE TO SEARCH
RegisterNetEvent("Inventory:Client:DoSearchVehicle")
AddEventHandler("Inventory:Client:DoSearchVehicle", function()
    -- CANT DO THIS WHILE DEAD OR CUFFED OR IN A VEHICLE
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() or IsPedInAnyVehicle(PlayerPedId(), false) then
        return
    end

    -- CHECK IF PLAYER IS LOOKING AT A VEHICLE
    local veh = exports["soe-utils"]:GetVehInFrontOfPlayer(3.0)
    if not veh then 
        exports["soe-ui"]:SendAlert("warning", "You are not looking at a vehicle!", 3500)
        return
    end

    -- CHECK IF VEHICLE WAS TOUCHED BY A PLAYER BEFORE... THIS STOPS INSTANT ACCESS REGARDLESS OF LOCK STATE
    if not IsVehiclePreviouslyOwnedByPlayer(veh) then
        exports["soe-ui"]:SendAlert("error", "This vehicle is locked!", 5000)
        return
    end

    -- CHECK IF VEHICLE IS LOCKED
    if (GetVehicleDoorLockStatus(veh) == 2) then
        exports["soe-ui"]:SendAlert("warning", "This vehicle is locked!", 3500)
        return
    end

    exports["soe-utils"]:Progress(
        {
            name = "searchVehicle",
            duration = 5000,
            label = "Searching Vehicle",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
            },
            animation = {
                animDict = "amb@prop_human_bum_bin@idle_b",
                anim = "idle_d",
                flags = 49
            }
        },
        function(cancelled)
            if not cancelled then
                -- GET RELEVANT VEHICLE DATA FOR SERVER AND TRIGGER INVENTORY
                local vehicleNetworkId = NetworkGetNetworkIdFromEntity(veh)
                local licPlate, class = GetVehicleNumberPlateText(veh), GetVehicleClass(veh)
                TriggerEvent("Inventory:Client:ShowInventory", "veh", false, {
                    vehicleNetworkId = vehicleNetworkId, licPlate = licPlate, class = class, canLoot = DecorGetBool(veh, "noInventoryLoot")
                })
            end
        end
    )
end)
