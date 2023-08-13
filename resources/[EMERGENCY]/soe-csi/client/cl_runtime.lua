local bloodDropOpacity = 255
local loopIndex, sleep = 0, 650
local flashlightHash = `WEAPON_FLASHLIGHT`

CreateThread(function()
    Wait(5000)

    CreateZones()
    casings, bloodDrops, fingerprints, vehicleFragments = exports["soe-nexus"]:TriggerServerCallback("CSI:Server:SyncEvidence")

    local playerID = PlayerId()
    exports["soe-utils"]:LoadAnimDict("random@domestic", 15)

    while true do
        Wait(sleep)
        local ped = PlayerPedId()

        -- AIMING FLASHLIGHT OR PLAYING CAMERA EMOTE
        local usingFlashlight = (GetSelectedPedWeapon(ped) == flashlightHash) and IsPlayerFreeAiming(playerID)
        if usingFlashlight or IsEntityPlayingAnim(ped, "amb@world_human_paparazzi@male@base", "base", 3) then
            sleep = 5
            loopIndex = loopIndex + 1

            local pos = GetEntityCoords(ped)
            if (loopIndex % 55 == 0) then -- FIND OUR NEAREST CASINGS/BLOOD DROPS/VEHICLE FRAGMENTS
                nearbyCasings, nearbyBloodDrops, nearbyVehFragments = {}, {}, {}
                for casingID, casingData in pairs(casings) do
                    if #(pos - casingData["pos"]) <= 45.5 then
                        nearbyCasings[casingID] = casingData
                    end
                end

                for dropID, dropData in pairs(bloodDrops) do
                    if #(pos - dropData["pos"]) <= 45.5 then
                        nearbyBloodDrops[dropID] = dropData
                    end
                end

                for fragmentID, fragmentData in pairs(vehicleFragments) do
                    if #(pos - fragmentData["pos"]) <= 45.5 then
                        nearbyVehFragments[fragmentID] = fragmentData
                    end
                end

                -- IF IT IS RAINING, MAKE BLOOD HARDER TO SEE
                local weather = exports["soe-climate"]:GetWeather()
                if (weather["weatherType"] == "RAIN" or weather["weatherType"] == "THUNDER" or weather["weatherType"] == "CLEARING") then
                    bloodDropOpacity = 50
                else
                    bloodDropOpacity = 255
                end
                loopIndex = 0
            end

            -- DRAW CASINGS
            for _, casing in pairs(nearbyCasings) do
                if #(pos - casing["pos"]) <= 11.5 then
                    DrawMarker(27, casing["pos"]["x"], casing["pos"]["y"], casing["pos"]["z"] - 0.97, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.11, 0.11, 0.3, 52, 116, 235, 255, 0, 1, 0, 0, 0, 0, 0)
                end
            end

            -- DRAW BLOOD DROPS
            for _, drop in pairs(nearbyBloodDrops) do
                if #(pos - drop["pos"]) <= 11.5 then
                    DrawMarker(27, drop["pos"]["x"], drop["pos"]["y"], drop["pos"]["z"] - 0.97, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.11, 0.11, 0.3, 250, 0, 50, bloodDropOpacity, 0, 1, 0, 0, 0, 0, 0)
                end
            end

            -- DRAW VEHICLE FRAGMENTS
            for _, fragment in pairs(nearbyVehFragments) do
                if #(pos - fragment["pos"]) <= 11.5 then
                    DrawMarker(36, fragment["pos"]["x"], fragment["pos"]["y"], fragment["pos"]["z"], 0, 0, 0, 0, 0, 0, 0.26, 0.26, 0.26, 158, 50, 168, 255, 0, 1, 0, 0, 0, 0, 0)
                end
            end
        else
            sleep = 650
        end
    end
end)
