local isAlreadyCutting = false

-- GRABS "GRID" OF THE TREE
local function TreeLoc(vec)
    local x, y = math.floor(vec.x), math.floor(vec.y)
    return (x << 16) or (y and 0xFFFF)
end

local function Woodcutting()
    local ped = PlayerPedId()
    if isAlreadyCutting then return end
    if (GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_HATCHET")) then
        local rayHandle = StartShapeTestRay(GetGameplayCamCoord(), GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.0, 0.0), -1, ped, 7)
        local _, _, _, _, e = GetShapeTestResultEx(rayHandle)
        if (e == -1915425863) then
            isAlreadyCutting = true
            --[[math.randomseed(GetGameTimer())
            -- 5% CHANCE OF THE PLAYER CUTTING THEMSELVES
            if (math.random(1, 100) <= 5) then
                exports["soe-healthcare"]:StartBleeding(1)
                exports["soe-ui"]:SendAlert("error", "You accidentally cut yourself")
            end]]

            exports["soe-utils"]:LoadAnimDict("melee@small_wpn@streamed_core", 15)
            TaskPlayAnim(ped, "melee@small_wpn@streamed_core", "car_down_attack", 2.5, 2.5, 1000, 1, 0, 0, 0, 0)

            Wait(1000)
            isAlreadyCutting = false
            TriggerServerEvent("Jobs:Server:HarvestWood", TreeLoc(GetEntityCoords(ped)))
        end
    end
end

-- INTERACTION KEY TO CUT WOOD
AddEventHandler("Utils:Client:InteractionKey", function()
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
        return
    end
    Woodcutting()
end)
