local enteredFrom
local containers = {}
local isRobbing, isInsideWarehouse = false, false
local warehousePos = vector4(1048.29, -3097.19, -39.0, 269.07)

-- FUNCTION FOR RAIDING A CRATE
local function RaidCrate()
    if not isInsideWarehouse then return end

    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local found, obj = false, GetClosestObjectOfType(pos, 1.0, GetHashKey("prop_mb_crate_01a"), 0, 0, 0)
    if DoesEntityExist(obj) then
        found = obj
    end

    if found then
        isRobbing = true
        -- ANIMATION
        exports["soe-utils"]:LoadAnimDict("mp_weapons_deal_sting", 15)
        TaskPlayAnim(ped, "mp_weapons_deal_sting", "crackhead_bag_loop", 8.0, 1.0, -1, 1, 0, 0, 0, 0)

        -- SKILLBAR
        if exports["soe-challenge"]:Skillbar(5500, math.random(5, 12)) then
            Wait(200)
            if exports["soe-challenge"]:Skillbar(5500, math.random(5, 12)) then
                Wait(200)
                if exports["soe-challenge"]:Skillbar(5500, math.random(5, 12)) then
                    TriggerServerEvent("Crime:Server:LootWarehouseCrate")
                    DeleteEntity(found)
                end
            end
        end
        Wait(150)
        isRobbing = false
        StopAnimTask(ped, "mp_weapons_deal_sting", "crackhead_bag_loop", 2.0)
    end
end

-- FUNCTION FOR LEAVING WAREHOUSE
local function LeaveWarehouse()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    if #(pos - vector3(warehousePos.x, warehousePos.y, warehousePos.z)) <= 3.0 then
        DoScreenFadeOut(500)
        Wait(500)

        exports["soe-fidelis"]:AuthorizeTeleport()
        SetEntityCoords(ped, enteredFrom)
        TriggerServerEvent("Instance:Server:SetPlayerInstance", -1)
        DoScreenFadeIn(500)

        enteredFrom = nil
        isInsideWarehouse = false
        for crate in pairs(containers) do
            DeleteEntity(containers[crate])
        end
        containers = {}
    end
end

-- MAIN WAREHOUSE ROBBERY FUNCTION
local function StartRobbingWarehouse(ped)
    -- SET SOME STATES AND TELEPORT PLAYER TO WAREHOUSE
    isInsideWarehouse = true
    enteredFrom = GetEntityCoords(ped)

    -- ALERT POLICE
    DoScreenFadeOut(500)
    local pos = GetEntityCoords(ped)
    local location = exports["soe-utils"]:GetLocation(pos)
    TriggerServerEvent("Crime:Server:MarkWarehouseAsBeingRobbed", location, pos)

    -- SPAWN CRATES
    exports["soe-utils"]:LoadModel(GetHashKey("prop_mb_crate_01a"), 15)
    for crateIndex, crateData in pairs(warehouseCrates) do
        containers[crateIndex] = CreateObject(GetHashKey("prop_mb_crate_01a"), crateData.pos, false, true, true)
        SetEntityHeading(containers[crateIndex], crateData.hdg)
        PlaceObjectOnGroundProperly(containers[crateIndex])
        PlaceObjectOnGroundProperly(containers[crateIndex])
        Wait(100)
    end
    Wait(500)

    -- TELEPORT/INSTANCE PLAYER 
    exports["soe-fidelis"]:AuthorizeTeleport()
    SetEntityCoords(ped, warehousePos)
    SetEntityHeading(ped, warehousePos.w)
    DoScreenFadeIn(500)
end

-- ATTEMPTS WAREHOUSE ROBBERY
local function AttemptWarehouseRobbery()
    -- GET CURRENT COP COUNT FOR WAREHOUSE ROBBERY ELIGIBILITY
    local copsOnline = exports["soe-emergency"]:GetCurrentCops()
    if (copsOnline < exports["soe-config"]:GetConfigValue("duty", "warehouses")) then
        exports["soe-ui"]:SendAlert("error", "This warehouse is in lockdown!", 5000)
        return
    end

    -- CHECK WAREHOUSE STATE
    local ped = PlayerPedId()
    local alreadyRaided, pos = false, GetEntityCoords(ped)
    for _, warehouse in pairs(warehouses) do
        if #(pos - warehouse.pos) <= 5.0 then
            if warehouse.raided then
                alreadyRaided = true
                exports["soe-ui"]:SendAlert("error", "This warehouse is in lockdown!", 5000)
                break
            end
        end
    end

    -- IF THE WAREHOUSE ISN'T ALREADY LOCKED DOWN
    if not alreadyRaided then
        -- START BREAKING INTO THE WAREHOUSE
        if IsNearWarehouse() and not IsPedSittingInAnyVehicle(ped) then
            if not exports["soe-inventory"]:HasInventoryItem("lockpick") then
                exports["soe-ui"]:SendAlert("error", "You do not have a lockpick", 5000)
                return
            end

            if exports["soe-challenge"]:StartLockpicking(true) then
                StartRobbingWarehouse(ped)
            end
        end
    end
end

-- RETURNS IF PLAYER IS NEAR A ROBBABLE WAREHOUSE
function IsNearWarehouse()
    local pos = GetEntityCoords(PlayerPedId())
    for _, warehouse in pairs(warehouses) do
        if #(pos - warehouse.pos) <= 5.0 then
            return true
        end
    end
    return false
end

-- RETURNS IF PLAYER IS NEAR A ROBBABLE WAREHOUSE CRATE
function IsNearWarehouseCrate()
    if not isInsideWarehouse then return false end

    local obj = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 1.0, GetHashKey("prop_mb_crate_01a"), 0, 0, 0)
    if DoesEntityExist(obj) then
        return true
    end
    return false
end

-- CALLED FROM RADIAL MENU TO RAID WAREHOUSE CRATE IF SELECTED
AddEventHandler("Crime:Client:RaidWarehouseCrate", RaidCrate)

-- CALLED FROM RADIAL MENU TO RAID WAREHOUSE CRATE IF SELECTED
AddEventHandler("Crime:Client:RaidWarehouse", AttemptWarehouseRobbery)

-- SYNCS WAREHOUSE STATE WITH ALL PLAYERS
RegisterNetEvent("Crime:Client:SetWarehouseState")
AddEventHandler("Crime:Client:SetWarehouseState", function(warehouse, state)
    warehouses[warehouse].raided = state
end)

-- INTERACTION KEY TO LEAVE WAREHOUSE IF ROBBING IT
AddEventHandler("Utils:Client:InteractionKey", function()
    --print("Is inside a warehouse: ", isInsideWarehouse)
    if isInsideWarehouse then
        LeaveWarehouse()
    end
end)

-- BREACHES WAREHOUSE WHEN REQUESTED BY LEO/EMS
RegisterNetEvent("Crime:Client:BreachWarehouse")
AddEventHandler("Crime:Client:BreachWarehouse", function(warehouse)
    exports["soe-utils"]:Progress(
        {
            name = "gainingWarehouseEntry",
            duration = 3500,
            label = "Gaining Entry",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = false
            },
            animation = {
                animDict = "mp_arresting",
                anim = "a_uncuff",
                flags = 49
            }
        },
        function(cancelled)
            if not cancelled then
                local ped = PlayerPedId()
                -- SET SOME STATES AND TELEPORT PLAYER TO WAREHOUSE
                isInsideWarehouse = true
                enteredFrom = GetEntityCoords(ped)

                DoScreenFadeOut(500)
                Wait(500)
            
                -- TELEPORT/INSTANCE PLAYER
                exports["soe-fidelis"]:AuthorizeTeleport()
                SetEntityCoords(ped, warehousePos)
                SetEntityHeading(ped, warehousePos.w)
                TriggerServerEvent("Instance:Server:SetPlayerInstance", warehouse.name)
                DoScreenFadeIn(500)
            end
        end
    )
end)

-- SYNCS HOUSE ROBBERY ALARM WITH LEOS
RegisterNetEvent("Crime:Client:SendWarehouseRobberyAlert")
AddEventHandler("Crime:Client:SendWarehouseRobberyAlert", function(location, pos)
    local desc = ("A security company is reporting an intruder alarm activation. The warehouse is reportedly in the area of %s."):format(location)
    --[[TriggerServerEvent("CADAlerts:Server:SendCAD", false, {
        ["cadType"] = "POLICE",
        ["coords"] = pos,
        ["title"] = "<b>10-35 - Warehouse Burglary</b><hr>",
        ["description"] = desc,
        ["blip"] = {
            ["sprite"] = 473,
            ["color"] = 1,
            ["scale"] = 0.92
        }
    })]]
    TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = false, type = "Warehouse Burglary", desc = desc, code = "10-35", coords = pos})
end)
