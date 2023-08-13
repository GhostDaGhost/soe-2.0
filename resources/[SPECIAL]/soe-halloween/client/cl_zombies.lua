hasSpawned = false

-- **********************
--    Local Functions
-- **********************
local function SetZombieTraits(ped)
    exports["soe-utils"]:GetEntityControl(ped)

    math.randomseed(GetGameTimer())
    local walkStyle = zombieWalkstyles[math.random(1, #zombieWalkstyles)]
    exports["soe-utils"]:LoadAnimSet(walkStyle, 15)
    SetPedMovementClipset(ped, walkStyle, 1.0)

    SetPedCombatAttributes(ped, 2, true)
    SetPedCombatAttributes(ped, 20, true)
    SetPedCombatAttributes(ped, 46, true)
    TaskCombatPed(ped, PlayerPedId(), 0, 16)
    SetPedKeepTask(ped, true)

    DisablePedPainAudio(ped, true)
    SetEntityHealth(ped, zombieHealth)
    SetPedArmour(ped, 150)
    SetPedDiesInWater(ped, false)
    SetPedDiesWhenInjured(ped, false)
    SetPedSuffersCriticalHits(ped, false)

    SetPedIsDrunk(ped, true)
    ApplyPedDamagePack(ped, "BigHitByVehicle", 0.0, 9.0)
    ApplyPedDamagePack(ped, "SCR_Dumpster", 0.0, 9.0)
    ApplyPedDamagePack(ped, "SCR_Torture", 0.0, 9.0)
    StopPedSpeaking(ped, true)
    SetPedDropsWeaponsWhenDead(ped, false)
end

-- WHEN TRIGGERED, CREATE A ZOMBIE NEAR PLAYER
local function CreateZombie()
    local pos = GetEntityCoords(PlayerPedId())
    print(GetInteriorAtCoords(pos))
    if IsPedSittingInAnyVehicle(PlayerPedId()) or (GetInteriorAtCoords(pos) ~= 0) then
        return
    end

    math.randomseed(GetGameTimer())
    local maxAmt = math.random(3, 6)

    for amt = 1, maxAmt do
        exports["soe-utils"]:LoadModel(zombieModel, 15)
        local zombie = CreatePed(4, zombieModel, GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -75.5, 0.0), 60.0, true, false)
        SetZombieTraits(zombie)
    end
end

-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, ALERT THE PLAYER OF THE CURRENT SITUATION
function AnnounceApocalypse()
    TriggerEvent("Chat:Client:Message", "[Statewide Advisory]", zombieAlertMsg, "standard")
end

-- WHEN TRIGGERED, BLACKOUT THE CITY
function BeginBlackout()
    SetArtificialLightsState(true)
    SetArtificialLightsStateAffectsVehicles(false)
end

-- WHEN TRIGGERED, DO ZOMBIE APOCALYPSE THINGS FROM RUNTIME
function DoZombieEvent()
    ForceLightningFlash()
    FlickerLights()

    TriggerEvent("Halloween:Client:CreateZombie")
end

-- WHEN TRIGGERED, FLICKER THE CITY'S ELECTRICITY
function FlickerLights()
    SetArtificialLightsState(false)
    Wait(75)
    BeginBlackout()
    Wait(75)
    SetArtificialLightsState(false)
    Wait(75)
    BeginBlackout()
    Wait(300)
    SetArtificialLightsState(false)
    Wait(300)
    BeginBlackout()
end

RegisterCommand("reee", DoZombieEvent)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, CREATE A ZOMBIE NEAR PLAYER
AddEventHandler("Halloween:Client:CreateZombie", CreateZombie)

-- WHEN TRIGGERED, START HALLOWEEN RUNTIME
AddEventHandler("Uchuu:Client:PlayerSpawned", function()
    hasSpawned = true
end)
