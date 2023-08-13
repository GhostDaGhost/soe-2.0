local fishingSpotBlips = {}
local fishingRod, isFishing = nil, false

-- MAIN FISHING FUNCTION
local function DoFishing()
    -- DON'T ALLOW FISHING IF ALREADY DOING THAT
    if isFishing then return end
    -- DON'T ALLOW FISHING IF IN VEHICLE
    local ped = PlayerPedId()
    if IsPedSittingInAnyVehicle(ped) then return end

    -- CHECK IF NEAR A FISHING SPOT
    local mySpot, pos = false, GetEntityCoords(ped)
    for _, spot in pairs(fishingSpots) do
        if (spot.zone ~= nil) then
            if IsEntityInZone(ped, spot.zone) and IsEntityInWater(ped) then
                mySpot = spot
                --print("In zone.")
                break
            end
        elseif (spot.pos ~= nil) then
            if #(pos - spot.pos) <= spot.range then
                mySpot = spot
                --print("In range.")
                break
            end
        end
    end

    if mySpot then
        math.randomseed(GetGameTimer())
        exports["soe-ui"]:SendAlert("warning", "You start fishing...", 10500)
        exports["soe-utils"]:LoadAnimDict("amb@world_human_stand_fishing@idle_a", 15)
        TaskPlayAnim(ped, "amb@world_human_stand_fishing@idle_a", "idle_c", 3.0, 3.0, -1, 1, 0, 0, 0, 0)

        isFishing = true
		fishingRod = exports["soe-utils"]:SpawnObject(GetHashKey("prop_fishing_rod_01"))
        AttachEntityToEntity(fishingRod, ped, GetPedBoneIndex(ped, 60309), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1)
        Wait(math.random(11500, 15500))

        -- PLAY SOUND AND MAKE SKILLBAR APPEAR
        exports["soe-utils"]:PlayProximitySound(3.0, "fish_reel.ogg", 0.11)
        exports["soe-ui"]:PersistentAlert("start", "hasHookedOn", "inform", "You have hooked on to something!", 500)
        if exports["soe-challenge"]:Skillbar(8500, math.random(5, 10)) then
            TriggerServerEvent("Jobs:Server:FishingReward", mySpot)
        else
            exports["soe-ui"]:SendAlert("error", "You failed to reel it in!", 5000)
        end

        -- HAVE A CHANCE TO REPORT THE POLICE IF SPOT IS ILLEGAL
        if (mySpot.rarity == "River (Illegal)") then
            if (math.random(1, 100) <= 45) then
                local loc = exports["soe-utils"]:GetLocation(pos)
                TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = true, type = "Illegal Fishing", loc = loc, coords = pos})
            end
        end

        -- DELETE FISHING ROD PROP AND END ANIMATION
        DeleteEntity(fishingRod)
        exports["soe-ui"]:PersistentAlert("end", "hasHookedOn")
        StopAnimTask(ped, "amb@world_human_stand_fishing@idle_a", "idle_c", 2.0)
        isFishing, fishingRod = false, nil
    end
end

-- EXPORTED TO ALLOW FISHING MAP ITEM BE USED
function UseFishingMap()
    if #fishingSpotBlips > 0 then
        exports["soe-ui"]:SendAlert("inform", "Removing fishing spot blips...", 2500)
		for _, blip in pairs(fishingSpotBlips) do
			RemoveBlip(blip)
		end
		fishingSpotBlips = {}
    else
        exports["soe-ui"]:SendAlert("inform", "Check your map for fishing spot blips!", 5000)
        for _, spot in pairs(fishingSpots) do
            if (spot.pos ~= nil) then
                local blip = AddBlipForRadius(spot.pos, spot.range)
                SetBlipAlpha(blip, 100)
                table.insert(fishingSpotBlips, blip)
            end
		end
    end
end

-- REQUESTED FROM SERVER AFTER "/fish" IS EXECUTED
RegisterNetEvent("Jobs:Client:DoFishing")
AddEventHandler("Jobs:Client:DoFishing", DoFishing)
