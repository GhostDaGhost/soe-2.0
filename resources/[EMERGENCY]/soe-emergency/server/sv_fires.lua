local possibleLocations = {
    { -- KIMBLE HILL DRIVE HOUSE 1
        {pos = vector3(-232.05, 588.25, 190.54)},
        {pos = vector3(-226.77, 589.36, 190.02)}
    },
    { -- UTOPIA GARDENS UNFINISHED HOUSE
        {pos = vector3(1346.13, -770.82, 67.67)},
        {pos = vector3(1342.91, -760.82, 67.67)}
    },
    { -- MAGELLAN HOUSE 1
        {pos = vector3(-1246.76, -1359.34, 7.82)},
        {pos = vector3(-1244.63, -1359.95, 5.47)}
    },
    { -- ALTA ST SCRAPYARD
        {pos = vector3(-560.99, -1695.8, 19.16)}
    },
    { -- GREENWICH PARKWAY
        {pos = vector3(-1005.79, -1936.44, 19.76)}
    },
    { -- SIGNAL ST / VOODOO PL
        {pos = vector3(313.07, -2914.55, 6.11)},
        {pos = vector3(313.06, -2906.7, 6.11)}
    },
    { -- EL BURRO BLVD
        {pos = vector3(1279.49, -2555.8, 43.52)},
    },
    { -- SEAVIEW ROAD
        {pos = vector3(2450.72, 4163.97, 36.81)}
    },
    { -- NORTH CALAFIA WAY
        {pos = vector3(362.9, 4412.58, 64.89)}
    }
}

activeFire = nil
activeFireEngines = 0

-- REMOVES CURRENTLY ACTIVE FIRE
function ExtinguishFire()
    activeFire = nil
    TriggerClientEvent("Emergency:Client:ExtinguishFire", -1)
end

-- CALLED FROM SERVER RUNTIME TO ASK CLIENT FOR FIRE ENGINE COUNT
function CheckForFireEngines()
    activeFireEngines = 0
    --print("CHECKING FOR FIRE ENGINES.")
    for src in pairs(exports["soe-uchuu"]:GetOnlinePlayerList()) do
        local veh = GetVehiclePedIsIn(GetPlayerPed(src), true)
        if (GetEntityModel(veh) == GetHashKey("firetruk") and exports["soe-jobs"]:GetJob(src) == "EMS") then
            activeFireEngines = activeFireEngines + 1
        end
    end
end

-- STARTS FIRE ONCE WE HAVE ENOUGH FIRE ENGINES
function StartFire()
    math.randomseed(GetGameTimer())
    math.random() math.random() math.random()
    local fire = math.random(1, #possibleLocations)
    activeFire = fire

    TriggerClientEvent("Emergency:Client:StartFire", -1, fire, possibleLocations)
    SetTimeout(math.random(2700000, 3600000), ExtinguishFire)
end

-- CALLED TO SYNC FIRE EXTINGUISHING
RegisterNetEvent("Emergency:Server:ExtinguishFire")
AddEventHandler("Emergency:Server:ExtinguishFire", ExtinguishFire)
