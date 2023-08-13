local action
local hitman = {}
local cooldown = 0

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, THIS WILL PAY THE PLAYER WHEN CONTRACT IS FULFILLED
local function CollectPay(isAtSpot)
    if not hitman.targetEliminated then
        exports["soe-ui"]:SendAlert("error", "Our spies report that the target is still alive", 5000)
        return
    end

    hitman.isDoingJob = false
    exports["soe-ui"]:HideTooltip()
    exports["soe-ui"]:PersistentAlert("end", "pickupHitmanPay")
    TriggerServerEvent("Crime:Server:HitmanContractPay", {canPay = isAtSpot})
end

-- WHEN TRIGGERED, THIS WILL BACK OUT OF THE JOB
local function DropAssignment()
    TaskWanderStandard(hitman.target, 10.0, 10)
    SetPedAsNoLongerNeeded(hitman.target)
    hitman.isDoingJob = false
    hitman.target = nil

    for _, blip in pairs(hitman.blips) do
        RemoveBlip(blip)
    end
    hitman.blips = {}
    exports["soe-ui"]:PersistentAlert("end", "pickupHitmanPay")
    exports["soe-ui"]:PersistentAlert("end", "hitmanAssignment")
    exports["soe-ui"]:SendAlert("error", "Backing out huh? Get the fuck outta here.", 5000)
end

-- WHEN TRIGGERED, THIS WILL GIVE THE TARGET A BLIP FOR LOCATION SPOTTING
local function CreateTargetBlips()
    hitman.blips = {}
    for _, loc in pairs(hitman.myAssignment.locations) do
        local blip = AddBlipForRadius(loc.x, loc.y, loc.z, 85.0)
        SetBlipColour(blip, 1)
        SetBlipAlpha(blip, 100)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Possible Target Location")
        EndTextCommandSetBlipName(blip)
        table.insert(hitman.blips, blip)
    end
end

-- WHEN TRIGGERED, THIS WILL FINISH THE JOB UP
local function TargetEliminated()
    hitman.target = nil
    hitman.targetEliminated = true

    for _, blip in pairs(hitman.blips) do
        RemoveBlip(blip)
    end
    hitman.blips = {}
    exports["soe-ui"]:PersistentAlert("end", "hitmanAssignment")
    exports["soe-ui"]:SendAlert("success", "You successfully assassinated the target", 9000)
    exports["soe-ui"]:PersistentAlert("start", "pickupHitmanPay", "inform", "Come back to the starting point to collect your payment!", 100)

    local loc = exports["soe-utils"]:GetLocation(GetEntityCoords(PlayerPedId()))
    local description = ("A caller reports of a potential murder in the area of %s"):format(location)
    TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = true, type = "Homicide", loc = loc, coords = GetEntityCoords(PlayerPedId())})
end

-- WHEN TRIGGERED, THIS WILL GIVE THE PLAYER A TARGET ASSIGNMENT
local function GiveAssignment()
    if IsPedSittingInAnyVehicle(PlayerPedId()) then return end

    -- COOLDOWN CHECK
    if (cooldown > GetGameTimer()) then
        exports["soe-ui"]:SendAlert("error", "You are laying low after the last contract. You must wait a while.", 5000)
        return
    end

    local allowed = exports["soe-nexus"]:TriggerServerCallback("Crime:Server:HitmanContractRequirementCheck")
    if not allowed then return end

    hitman.isDoingJob = true
    cooldown = GetGameTimer() + 3600000

    -- RANDOMIZE CONTRACT
    math.randomseed(GetGameTimer())
    math.random() math.random() math.random()
    hitman.myAssignment = hitmanAssignments[math.random(1, #hitmanAssignments)]
    local spot = math.random(1, #hitman.myAssignment.locations)
    spot = hitman.myAssignment.locations[spot]

    CreateThread(function()
        local ran = false
        while not hitman.targetEliminated do
            Wait(250)
            if not ran then
                if ran then return end
                if #(GetEntityCoords(PlayerPedId()) - vector3(spot.x, spot.y, spot.z)) <= 55.0 then
                    ran = true
                    if hitman.targetEliminated then return end

                    exports["soe-utils"]:LoadModel(GetHashKey(hitman.myAssignment.npc), 15)
                    hitman.target = CreatePed(4, GetHashKey(hitman.myAssignment.npc), spot.x, spot.y, spot.z, spot.w, true, false)
                    --SetBlockingOfNonTemporaryEvents(hitman.target, true)

                    -- HAVE THE TARGET ATTACK
                    math.randomseed(GetGameTimer())
                    if (math.random(1, 100) <= 95) then
                        if #(GetEntityCoords(PlayerPedId()) - vector3(spot.x, spot.y, spot.z)) <= 40.0 then
                            ClearPedTasksImmediately(hitman.target)
                            -- SET COMBAT ATTRIBUTES
                            SetPedCombatAttributes(hitman.target, 2, true)
                            SetPedCombatAttributes(hitman.target, 20, true)
                            SetPedCombatAttributes(hitman.target, 46, true)

                            -- GIVE A WEAPON TO THE PED AND COMMAND TO ATTACK PLAYER
                            GiveWeaponToPed(hitman.target, GetHashKey("WEAPON_COMBATPISTOL"), 90, 0, 1)
                            TaskCombatPed(hitman.target, PlayerPedId(), 0, 16)
                            SetPedDropsWeaponsWhenDead(hitman.target, false)
                        end
                    end
                end
            else
                if hitman.targetEliminated then return end
                if IsEntityDead(hitman.target) or IsPedDeadOrDying(hitman.target) then
                    TargetEliminated()
                end
            end
        end
    end)

    CreateTargetBlips()
    exports["soe-ui"]:HideTooltip()
    exports["soe-ui"]:PersistentAlert("start", "hitmanAssignment", "inform", hitman.myAssignment.msg, 100)

    Wait(7500)
    local loc = exports["soe-utils"]:GetLocation(vector3(spot.x, spot.y, spot.z))
    local desc = ("A caller reports that they are in danger and feel unsafe in the area of %s. They say they have a hit planned on them. Caller's description is %s"):format(loc, hitman.myAssignment.desc)
    TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = true, type = "Unknown Disturbance", desc = desc, code = "10-78", coords = vector3(spot.x, spot.y, spot.z)})
end

-- **********************
--        Events
-- **********************
-- IF WE LEFT A ZONE
AddEventHandler("Utils:Client:ExitedZone", function(name)
    if name:match("hitman_point") then
        action = nil
        exports["soe-ui"]:HideTooltip()
    end
end)

-- IF WE ENTERED A ZONE
AddEventHandler("Utils:Client:EnteredZone", function(name)
    if name:match("hitman_point") then
        action = {status = true}
        if not hitman.isDoingJob then
            exports["soe-ui"]:ShowTooltip("fas fa-skull", "[E] Take Hitman Contract", "inform")
        else
            if hitman.targetEliminated then
                exports["soe-ui"]:ShowTooltip("fas fa-skull", "[E] Collect Contract Payment", "inform")
            else
                exports["soe-ui"]:ShowTooltip("fas fa-skull", "[E] Abandon Contract", "inform")
            end
        end
    end
end)

-- INTERACTION KEYPRESS
AddEventHandler("Utils:Client:InteractionKey", function()
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
        return
    end

    if not action then return end
    if action.status then
        if not hitman.isDoingJob then
            GiveAssignment()
        else
            if hitman.targetEliminated then
                CollectPay(true)
            else
                DropAssignment()
            end
        end
    end
end)
