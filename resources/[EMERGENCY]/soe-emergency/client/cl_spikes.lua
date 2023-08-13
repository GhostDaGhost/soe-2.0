local closestSpikes -- CLOSEST SPIKES TO THE PLAYER'S VEHICLE
local spikeStrips = {} -- STORAGE OF ALL SPIKES PLACED BY OTHERS AND 
local spikesHitNPC = false -- ALLOW NPC VEHICLES TO BE HIT WITH SPIKES TOO
local spikedCooldown, pickupCooldown = 0, 0 -- COOLDOWNS FOR PICKING UP SPIKES AND GETTING SPIKED
local spikeStripsModel = GetHashKey("p_ld_stinger_s") -- LOAD UP THE SPIKE STRIP MODEL ONCE UPON INIT
local tireLayouts = {{0}, {0, 4}, {0, 4, 5}, {0, 1, 4, 5}, {0, 1, 2, 4, 5}, {0, 1, 2, 3, 4, 5}, {0, 1, 2, 3, 4, 5, 6}, {0, 1, 2, 3, 4, 5, 6, 7}} -- VEHICLE TIRE LAYOUTS

-- DECORATORS
DecorRegister("spikestripWasUsed", 3)

-- ***********************
--     Local Functions
-- ***********************
-- WHEN TRIGGERED, SYNC SPIKE STRIPS FROM SERVER
local function SyncSpikeStrips(type, stripData)
    --print("SyncSpikeStrips", type, json.encode(stripData))
    if (type == "Place") then
        spikeStrips[#spikeStrips + 1] = stripData
    elseif (type == "Remove") then
        local spikeObj = spikeStrips[stripData.idx]["obj"] or 0
        TriggerServerEvent("Utils:Server:DeleteEntity", ObjToNet(spikeObj))
        DeleteEntity(spikeObj)
        DeleteObject(spikeObj)
        spikeStrips[stripData.idx] = nil
    end
end

-- WHEN TRIGGERED, SYNC TIRE POPPING FROM SPIKE STRIPS
local function SyncSpikesHit(veh, tires)
    if not NetworkDoesNetworkIdExist(veh) then
        return
    end

    veh = NetToVeh(veh)
    local maxTires = GetVehicleNumberOfWheels(veh)
    local layout = tireLayouts[maxTires]
    for tire = 1, tires do
        SetVehicleTyreBurst(veh, layout[tire], false, 10.0)
    end
end

-- WHEN TRIGGERED, PICKUP SPIKE STRIPS AND PLACE INTO INVENTORY
local function PickupSpikeStrips()
    if (closestSpikes == nil) then return end
    pickupCooldown = GetGameTimer() + 2500

    exports["soe-utils"]:LoadAnimDict("anim@heists@money_grab@briefcase", 15)
    TaskPlayAnim(PlayerPedId(), "anim@heists@money_grab@briefcase", "put_down_case", 3.0, 3.0, 1000, 0, 0, 0, 0, 0)
    Wait(1000)

    local obj = spikeStrips[closestSpikes]["obj"] or 0
    exports["soe-utils"]:RegisterEntityAsNetworked(obj)
    exports["soe-utils"]:GetEntityControl(obj)

    SetEntityAsMissionEntity(obj)
    exports["soe-nexus"]:TriggerServerCallback("Emergency:Server:SyncSpikeStrips", "Remove", {idx = closestSpikes, used = DecorGetBool(obj, "spikestripWasUsed")})
    closestSpikes = nil
end

-- WHEN TRIGGERED, USE SPIKE STRIPS FROM INVENTORY
local function UseSpikeStrips()
    local ped = PlayerPedId()
    if IsPedSittingInAnyVehicle(ped) or not exports["soe-inventory"]:HasInventoryItem("spikestrips") then
        return
    end

    -- PRE-LOAD ANIMATION DICTIONARIES AND MODEL
    exports["soe-utils"]:LoadModel(spikeStripsModel, 15)
    exports["soe-utils"]:LoadAnimDict("mp_weapons_deal_sting", 15)
    exports["soe-utils"]:LoadAnimDict("anim@heists@money_grab@briefcase", 15)

    local spikeCoords, hdg = GetOffsetFromEntityInWorldCoords(ped, 0.0, 3.0, -0.7), GetEntityHeading(ped)

    -- ANIMATION CONTROL
    TaskPlayAnim(ped, "anim@heists@money_grab@briefcase", "put_down_case", 3.0, 3.0, 1150, 0, 0, 0, 0, 0)
    Wait(1150)
    TaskPlayAnim(ped, "mp_weapons_deal_sting", "crackhead_bag_loop", 2.4, 2.4, 550, 0, 0, 0, 0, 0)
    Wait(550)
    exports["soe-utils"]:PlayProximitySound(5.5, "deploy_spikes.ogg", 0.55)
    Wait(550)

    -- CREATE OUR SPIKES
    local spikeStrip = CreateObject(spikeStripsModel, spikeCoords, true, true, true)

    -- SET THE HEADING AND MAKE SURE THEY ARE ON THE GROUND PROPERLY
    SetEntityHeading(spikeStrip, hdg)
    PlaceObjectOnGroundProperly(spikeStrip)

    local netID = NetworkGetNetworkIdFromEntity(spikeStrip)
    SetNetworkIdExistsOnAllMachines(netID, true)
    SetNetworkIdCanMigrate(netID, false)
    exports["soe-nexus"]:TriggerServerCallback("Emergency:Server:SyncSpikeStrips", "Place", {obj = spikeStrip, pos = GetEntityCoords(spikeStrip)})

    -- START A LOOP TO ALLOW NPC VEHICLES TO BE HIT WITH SPIKES AS WELL
    if not spikesHitNPC then return end
    while DoesEntityExist(spikeStrip) do
        Wait(850)
        if not DoesEntityExist(spikeStrip) then
            return
        end

        for vehicle in exports["soe-utils"]:EnumerateVehicles() do
            local driverIsNPC = not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1))

            if driverIsNPC and #(GetEntityCoords(vehicle) - GetEntityCoords(spikeStrip)) <= 3.7 and not IsVehicleTyreBurst(vehicle, 0) then
                local maxTires = GetVehicleNumberOfWheels(vehicle)
                math.randomseed(GetGameTimer())
        
                local tires = math.random(1, maxTires)
                exports["soe-nexus"]:TriggerServerCallback("Emergency:Server:SyncSpikesHit", VehToNet(vehicle), tires, true)
                Wait(1000)
            end
        end
    end
end

-- ***********************
--    Global Functions
-- ***********************
-- WHEN TRIGGERED, GET THE CLOSEST SPIKE STRIPS TO PLAYER
function GetClosestSpikes()
    local pos = GetEntityCoords(PlayerPedId())
    local found

    for strip = 1, #spikeStrips do
        if spikeStrips[strip] and #(pos - spikeStrips[strip]["pos"]) <= 6.5 and not found then
            found = strip
        end
    end
    closestSpikes = found
end

-- WHEN TRIGGERED, IF PLAYER VEHICLE IS TOO CLOSE TO SPIKE STRIPS, POP TIRES
function DoSpikeStripAction()
    -- MAKE SURE WE DO HAVE NEARBY SPIKE STRIPS AND CHECK COOLDOWN TO PREVENT SPAM
    if (closestSpikes == nil or spikeStrips[closestSpikes] == nil or (spikedCooldown > GetGameTimer())) or IsPedOnFoot(PlayerPedId()) then
        return
    end

    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if (veh ~= 0) and #(GetEntityCoords(veh) - spikeStrips[closestSpikes]["pos"]) <= 3.7 and not IsVehicleTyreBurst(veh, 0) then
        local maxTires = GetVehicleNumberOfWheels(veh)
        math.randomseed(GetGameTimer())

        spikedCooldown = GetGameTimer() + 3500
        local tires = math.random(1, maxTires)
        DecorSetBool(spikeStrips[closestSpikes]["obj"], "spikestripWasUsed", true)
        exports["soe-nexus"]:TriggerServerCallback("Emergency:Server:SyncSpikesHit", VehToNet(veh), tires, false)
    end
end

-- ***********************
--        Events
-- ***********************
-- WHEN TRIGGERED, SYNC TIRE POPPING FROM SPIKE STRIPS
RegisterNetEvent("Emergency:Client:SyncSpikesHit", SyncSpikesHit)

-- WHEN TRIGGERED, USE SPIKE STRIPS FROM INVENTORY
AddEventHandler("Inventory:Client:UseSpikeStrips", UseSpikeStrips)

-- WHEN TRIGGERED, SYNC SPIKE STRIPS FROM SERVER
RegisterNetEvent("Emergency:Client:SyncSpikeStrips", SyncSpikeStrips)

-- WHEN TRIGGERED, DO INTERACTION KEYPRESS
AddEventHandler("Utils:Client:InteractionKey", function()
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() or IsPedSittingInAnyVehicle(PlayerPedId()) or (pickupCooldown > GetGameTimer()) then
        return
    end
    PickupSpikeStrips()
end)

-- WHEN TRIGGERED, RESET EVERYTHING
AddEventHandler("onResourceStop", function(resource)
    if (GetCurrentResourceName() ~= resource) then return end

    -- DELETE LEFTOVER STRIPS
    for _, spikeData in pairs(spikeStrips) do
        DeleteEntity(spikeData["obj"])
        DeleteObject(spikeData["obj"])
    end
end)
