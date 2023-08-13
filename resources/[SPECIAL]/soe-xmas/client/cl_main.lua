-- KEY MAPPINGS
RegisterKeyMapping("pickupsnowball", "[Xmas] Pickup Snowball", "keyboard", "F1")

-- TRIGGERED BY A KEYBIND TO PICKUP SNOWBALLS
local function PickupSnowball()
    local ped = PlayerPedId()
    local isCuffed = IsPedCuffed(ped)
    local isAiming = IsPlayerFreeAiming(PlayerId())

    -- START ANIMATION AND ADD TO INVENTORY
    local snowball = GetHashKey("WEAPON_SNOWBALL")
    exports["soe-utils"]:LoadAnimDict("anim@mp_snowball", 15)
    if not IsPedInAnyVehicle(ped, false) or not isCuffed or not isAiming then
        TaskPlayAnim(ped, "anim@mp_snowball", "pickup_snowball", 8.0, -1, 2000, 0, 1, 0, 0, 0)
        Wait(2000)
        GiveWeaponToPed(ped, snowball, 1, false, true)
    end
end

RegisterCommand("pickupsnowball", PickupSnowball)
