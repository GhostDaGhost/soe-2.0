-- ************************
--    Basketball | Start
-- ************************
local basketball = {}
local prop = GetHashKey("prop_bskball_01")

-- KEY MAPPINGS
RegisterKeyMapping("pickupbasketball", "[Sports] Pickup Basketball", "KEYBOARD", "E")
RegisterKeyMapping("rollbasketball", "[Sports] Roll Basketball", "KEYBOARD", "PERIOD")
RegisterKeyMapping("+shootbasketball", "[Sports] Shoot Basketball", "KEYBOARD", "LMENU")
RegisterKeyMapping("dropbasketball", "[Sports] Drop Basketball", "KEYBOARD", "X")
RegisterKeyMapping("dribblebasketball", "[Sports] Dribble Basketball", "KEYBOARD", "RMENU")

-- DROPS BASKETBALL
local function DropBasketball()
    if basketball.prop then
        DetachEntity(basketball.prop)
        basketball.prop = nil
        basketball = {}
    end
end

-- TRIES TO SHOOT BASKETBALL
local function TryToShootBasketball()
    if basketball.prop then
        basketball.tryingToShoot = true
        exports["soe-ui"]:SendAlert("warning", "I'm shooting...", 5000)
        while basketball.tryingToShoot do
            Wait(20)
            if not basketball.normalShootForce then basketball.normalShootForce = 0.1 end
            if (basketball.normalShootForce < 2) then
                basketball.normalShootForce = basketball.normalShootForce + 0.05
            end
        end
    end
end

-- PICKS UP BASKETBALL
local function PickupBasketball()
    if not basketball.prop then
        local ped = PlayerPedId()
        local entity, dist = GetClosestObjectOfType(GetEntityCoords(ped), 1.5, prop, 0, 0, 0)
        local dist = #(GetEntityCoords(ped) - GetEntityCoords(entity))
        if GetEntityModel(entity) == prop and dist <= 1.5 then
            exports["soe-utils"]:GetEntityControl(entity)
            exports["soe-utils"]:LoadAnimDict("anim@mp_snowball", 15)
            TaskPlayAnim(ped, "anim@mp_snowball", "pickup_snowball", 8.0, 8.0, -1, 32, 0, 0, 0, 0)
            Wait(150)
            AttachEntityToEntity(entity, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 1, 0, 0.0, 1)
            basketball.prop = entity
            SetEntityAsMissionEntity(entity, true, true)
            Wait(1500)
            ClearPedTasksImmediately(ped)

            while (basketball.prop ~= nil) do
                Wait(5)
                DisableControlAction(0, 263, true)
                DisableControlAction(0, 264, true)
                DisableControlAction(0, 257, true)
                DisableControlAction(0, 140, true)
            end
        end
    end
end

-- DRIBBLES BASKETBALL
local function DribbleBasketball()
    if basketball.prop and not basketball.isDribbling then
        local ped = PlayerPedId()
        exports["soe-utils"]:LoadAnimDict("anim@move_m@trash", 15)
        TaskPlayAnim(ped, "anim@move_m@trash", "walk", 8.0, 8.0, -1, 51, 0, 0, 0, 0)
        basketball.isDribbling = true

        while basketball.isDribbling do
            if IsPedWalking(ped) or IsPedRunning(ped) then
                DetachEntity(basketball.prop)
                local forwardX, forwardY = GetEntityForwardX(ped), GetEntityForwardY(ped)
                SetEntityVelocity(basketball.prop, forwardX * 2, forwardY * 2, -3.8)
                Wait(300)
                forwardX, forwardY = GetEntityForwardX(ped), GetEntityForwardY(ped)
                SetEntityVelocity(basketball.prop, forwardX * 1.9, forwardY * 1.9, 4.0)
                Wait(450)
                AttachEntityToEntity(basketball.prop, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 1, 0, 0.0, 1)
            elseif IsPedSprinting(ped) then
                DetachEntity(basketball.prop)
                local forwardX, forwardY = GetEntityForwardX(ped), GetEntityForwardY(ped)
                SetEntityVelocity(basketball.prop, forwardX * 9, forwardY * 9, -10.0)
                Wait(200)
                forwardX, forwardY = GetEntityForwardX(ped), GetEntityForwardY(ped)
                SetEntityVelocity(basketball.prop, forwardX * 8, forwardY * 8, 3.0)
                Wait(300)
                AttachEntityToEntity(basketball.prop, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 1, 0, 0.0, 1)
            else 
                DetachEntity(basketball.prop)
                SetEntityVelocity(basketball.prop, 0.0, 0.0, -3.8)
                Wait(250)
                SetEntityVelocity(basketball.prop, 0, 0, 4.0)
                Wait(450)
                AttachEntityToEntity(basketball.prop, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 1, 0, 0.0, 1)
            end
            Wait(5)
        end
    elseif basketball.prop and basketball.isDribbling then
        basketball.isDribbling = false
        StopAnimTask(PlayerPedId(), "anim@move_m@trash", "walk", 51)
        ClearPedTasksImmediately(PlayerPedId())
    end
end

-- ROLLS BASKETBALL
local function RollBasketball()
    if basketball.prop then
        if not basketball.isRolling then
            basketball.isRolling = true
            exports["soe-utils"]:LoadAnimDict("amb@world_human_mobile_film_shocking@male@base", 15)
            TaskPlayAnim(PlayerPedId(), "amb@world_human_mobile_film_shocking@male@base", "base", 8.0, 8.0, -1, 51, 0, 0, 0, 0)

            local rot = 0.0
            while basketball.isRolling do
                if (rot > 360) then
                    rot = 0.0
                    AttachEntityToEntity(basketball.prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 1, 0, 0.0, 0)
                else
                    rot = rot + 60
                    AttachEntityToEntity(basketball.prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, rot, 1, 1, 1, 0, 0.0, 0)
                end
                Wait(30)
            end
        else
            ClearPedTasks(PlayerPedId())
            basketball.isRolling = false
        end
    end
end

-- SHOOTS BASKETBALL
local function ShootBasketball()
    if basketball.prop then
        if not basketball.isShooting then
            basketball.isShooting = true
            basketball.tryingToShoot = false
            exports["soe-utils"]:LoadAnimDict("amb@prop_human_movie_bulb@exit", 15)

            local ped = PlayerPedId()
            ClearPedTasksImmediately(ped)
            local forwardX, forwardY = GetEntityForwardX(ped), GetEntityForwardY(ped)

            DetachEntity(basketball.prop)
            SetEntityVelocity(basketball.prop, forwardX * (basketball.normalShootForce * 10), forwardY * (basketball.normalShootForce * 10), basketball.normalShootForce * 10)
            basketball.prop = nil
            TaskPlayAnim(ped, "amb@prop_human_movie_bulb@exit", "exit", 8.0, 8.0, -1, 48, 0, 0, 0, 0)

            Wait(1000)
            ClearPedTasks(ped)
            basketball.isShooting = false
            basketball.normalShootForce = 0.1
            basketball.isDribbling = false
        end
    end
end

-- KEYPRESS COMMANDS
RegisterCommand("rollbasketball", RollBasketball)
RegisterCommand("pickupbasketball", PickupBasketball)
RegisterCommand("+shootbasketball", TryToShootBasketball)
RegisterCommand("-shootbasketball", ShootBasketball)
RegisterCommand("dropbasketball", DropBasketball)
RegisterCommand("dribblebasketball", DribbleBasketball)

-- WHEN RESOURCE STOPS OR RESTARTS
AddEventHandler("onResourceStop", function(resource)
    if (GetCurrentResourceName() ~= resource) then return end
    DropBasketball()
end)

-- BASKETBALLS WERE REPORTED TO CAUSE A SHITSHOW SO DO THIS
AddEventHandler("BaseEvents:Client:EnteringVehicle", function()
    DropBasketball()
end)

-- ************************
--    Basketball | End
-- ************************
