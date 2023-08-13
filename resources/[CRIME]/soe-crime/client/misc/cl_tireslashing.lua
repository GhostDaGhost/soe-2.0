local allowedBlades = {"WEAPON_KNIFE", "WEAPON_BOTTLE", "WEAPON_DAGGER", "WEAPON_HATCHET", "WEAPON_MACHETE", "WEAPON_SWITCHBLADE"}

-- KEY MAPPINGS
RegisterKeyMapping("slashtire", "[Crime] Slash Tires", "keyboard", "E")

-- CHECKS WEAPON IF IT CAN SLASH TIRES
local function WeaponCanSlashTire()
    local weapon = GetSelectedPedWeapon(PlayerPedId())
    for _, blade in pairs(allowedBlades) do
        if (GetHashKey(blade) == weapon) then
            return true
        end
    end
    return false
end

-- MAIN TIRE SLASHING FUNCTION
local function SlashTire()
    local veh = exports["soe-utils"]:GetVehInFrontOfPlayer(5.0)
    if (veh ~= 0 and WeaponCanSlashTire()) then
        local closestTire = exports["soe-utils"]:GetClosestVehicleTire(veh)
        if (closestTire == nil) then return end

        exports["soe-utils"]:GetEntityControl(veh)
        if not IsVehicleTyreBurst(veh, closestTire.tireIndex, 0) then
            local pedCoords = GetEntityCoords(PlayerPedId())
            exports["soe-utils"]:LoadAnimDict("melee@knife@streamed_core_fps", 15)
            TaskPlayAnim(PlayerPedId(), "melee@knife@streamed_core_fps", "ground_attack_on_spot", 8.0, -8.0, 1750, 15, 0, 0, 0, 0)
            Wait(1000)
            SetVehicleTyreBurst(veh, closestTire.tireIndex, 0, 100.0)
            Wait(1000)

            local loc = exports["soe-utils"]:GetLocation(pedCoords)
            if exports["soe-emergency"]:ShouldReportInThisArea() then
                Wait(2500)
                TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = true, type = "Tire Slashing", loc = loc, coords = pedCoords})
            end
        end
    end
end

RegisterCommand("slashtire", SlashTire)
