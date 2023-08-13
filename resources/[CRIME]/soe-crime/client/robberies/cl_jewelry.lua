local smashingCase = false

-- SMASH INTO JEWELRY CASE
local function SmashCase(case)
    -- ANTI-EXPLOIT CHECK
    if smashingCase then return end

    -- CHECK IF THERE ARE ENOUGH COPS ONLINE
    local copsOnline = exports["soe-emergency"]:GetCurrentCops()
    if (copsOnline < exports["soe-config"]:GetConfigValue("duty", "jewelry")) then
        exports["soe-ui"]:SendAlert("error", "Glass seems to be extra protected", 5000)
        return
    end

    -- GET OUR CLOSEST CASE
    local myCase, pos = false, GetEntityCoords(PlayerPedId())
    for caseIndex, caseData in pairs(jewelryCases) do
        if #(pos - caseData.pos) <= 0.8 then
            myCase = caseIndex
            break
        end
    end

    if myCase then
        -- DON'T ALLOW TO DO THIS IF SOMEONE IS TOO CLOSE
        if (exports["soe-utils"]:GetClosestPlayer(2) ~= nil) then return end

        -- CHECK IF SHOWCASE IS ALREADY BROKEN
        if jewelryCases[myCase].broken then
            exports["soe-ui"]:SendAlert("error", "This showcase is already broken!", 5000)
            return
        end

        local ped = PlayerPedId()
        if (GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_CROWBAR") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_BAT")) then
            -- YES, WE ARE SMASHING A CASE
            smashingCase = true

            -- ANIMATION CONTROL
            exports["soe-utils"]:LoadAnimDict("melee@small_wpn@streamed_core", 15)
            TaskPlayAnim(ped, "melee@small_wpn@streamed_core", "car_down_attack", 2.5, 2.5, 1000, 1, 0, 0, 0, 0)
            Wait(870)
            exports["soe-utils"]:PlayProximitySound(5.0, "robbery-breakglass.ogg", 0.28)

            -- PARTICLE CONTROL
            exports["soe-utils"]:LoadPTFXAsset("scr_jewelheist", 15)
            SetPtfxAssetNextCall("scr_jewelheist")
            local offset = GetOffsetFromEntityInWorldCoords(ped, 0, 0.6, 0)
            StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", offset, 0.0, 0.0, 0.0, 1.0, 0, 0, 0, 0)

            exports["soe-utils"]:LoadAnimDict("oddjobs@shop_robbery@rob_till", 15)
            TaskPlayAnim(ped, "oddjobs@shop_robbery@rob_till", "loop", 2.5, 2.5, 1500, 1, 0, 0, 0, 0)
            Wait(1500)

            -- SET CASE STATUS
            smashingCase = false
            local location = exports["soe-utils"]:GetLocation(pos)
            TriggerServerEvent("Crime:Server:StartJewelryCooldown")
            TriggerServerEvent("Crime:Server:SetShowcaseState", myCase, location, pos, true)
        else
            exports["soe-ui"]:SendAlert("error", "Make sure to have a crowbar or baseball bat on hand", 5000)
        end
    end
end

-- RETURNS IF PLAYER IS NEAR A JEWELRY CASE
function IsNearJewelryShowcase()
    local pos = GetEntityCoords(PlayerPedId())
    for _, case in pairs(jewelryCases) do
        if #(pos - case.pos) <= 0.8 then
            return true
        end
    end
    return false
end

-- REQUESTED FROM RADIAL MENU TO BREAK INTO JEWELRY SHOWCASE
AddEventHandler("Crime:Client:RobJewelryShowcase", SmashCase)

-- REQUESTED FROM SERVER TO SYNC JEWELRY SHOWCASES
RegisterNetEvent("Crime:Client:SetShowcaseState")
AddEventHandler("Crime:Client:SetShowcaseState", function(case, state)
    jewelryCases[case].broken = state
end)
