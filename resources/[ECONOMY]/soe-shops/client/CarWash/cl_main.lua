--local abortedWash = false
local usingCarWash = false

-- STOPS ALL PARTICLES
local function StopAllParticles(myWash)
    for i = 1, #myWash.particlesStart do
        local particle = myWash.particlesStart[i].createdParticle

        StopParticleFxLooped(particle, 0)
        RemoveParticleFx(particle, 0)
        myWash.particlesStart[i].createdParticle = nil
    end
end

-- ABORTS CAR WASH IF RUNNING
--[[local function AbortWash()
    if usingCarWash then
        abortedWash = true
        usingCarWash = false
        local ped = PlayerPedId()
        local myWash = GetClosestCarWash()

        ClearPedTasks(ped)
        SetPlayerControl(ped, true)
        SetEveryoneIgnorePlayer(ped, false)
        StopAllParticles(carWashes[myWash])
    end
end]]

-- GETS CLOSEST CAR WASH
local function GetClosestCarWash()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    for i = 1, #carWashes do
        local dist = #(pos - carWashes[i].startPos)
        if (dist < 15.5) then
            return i
        end
    end
end

-- STARTS PARTICLE LOADING
local function StartParticles(myWash)
    local asset = "scr_carwash"
    local particle = "ent_amb_car_wash_jet"
    for i = 1, #myWash.particlesStart do
        local currentParticle = myWash.particlesStart[i]

        UseParticleFxAssetNextCall(asset)
        exports["soe-utils"]:LoadPTFXAsset(asset, 100)
        myWash.particlesStart[i].createdParticle = StartParticleFxLoopedAtCoord(particle, currentParticle.pos, currentParticle.xRot, 0.0, 0.0, 1.0, 0, 0, 0)
    end
end

-- MAIN CAR WASHING FUNCTION
local function DoWash()
    local ped = PlayerPedId()
    local myWash = GetClosestCarWash()
    local veh = GetVehiclePedIsIn(ped, false)
    if DoesEntityExist(veh) then
        if carWashes[myWash].canUseAnimation then
            usingCarWash = true
            SetEntityHeading(veh, carWashes[myWash].hdg)
            SetEntityCoords(veh, carWashes[myWash].startPos)

            SetPlayerControl(ped, false)
            StartParticles(carWashes[myWash])
            SetEveryoneIgnorePlayer(ped, true)
            TaskVehicleDriveToCoord(ped, veh, carWashes[myWash].endPos, 5.0, 0.0, GetEntityModel(veh), 262144, 1.0, 1000.0)
            Wait(250)

            SetPlayerControl(ped, true)
            SetEveryoneIgnorePlayer(ped, false)

            Wait(9000)
            usingCarWash = false
            StopAllParticles(carWashes[myWash])

            if not abortedWash then
                SetVehicleDirtLevel(veh, 0.0)
                TriggerServerEvent("CSI:Server:CleanPrintsFromVeh", GetVehicleNumberPlateText(veh))
                abortedWash = false
            end
        else
            exports["soe-utils"]:Progress(
                {
                    name = "carWash",
                    duration = 9000,
                    label = "Washing Car",
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                        disableMovement = false,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = false
                    }
                },
                function(cancelled)
                    if not cancelled then
                        SetVehicleDirtLevel(veh, 0.0)
                        TriggerServerEvent("CSI:Server:CleanPrintsFromVeh", GetVehicleNumberPlateText(veh))
                    end
                end
            )
        end
    end
end

-- RETURNS IF PLAYER IS USING THE CAR WASH
function IsUsingCarWash()
    return usingCarWash
end

-- RETURNS IF PLAYER IS CLOSE TO A CAR WASH
function IsNearCarWash()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    for i = 1, #carWashes do
        local dist = #(pos - carWashes[i].startPos)
        if (dist < 4.5) then
            return true
        end
    end
    return false
end

-- STARTS A CAR WASH
AddEventHandler("Shops:Client:UseCarWash", DoWash)

-- ABORTS THE CURRENT CAR WASH PROCESS
--AddEventHandler("Shops:Client:AbortCarWash", AbortWash)
