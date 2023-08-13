-- ***********************
--     Local Functions
-- ***********************
-- DOOR TELEPORTATIONS ON KEYPRESS
local function DoTeleport()
    local ped = PlayerPedId()
    local pos, inVeh = GetEntityCoords(ped), IsPedSittingInAnyVehicle(ped)

    for loc in pairs(teleports) do
        for k, v in pairs(teleports[loc]) do
            if #(pos - vector3(v.pos.x, v.pos.y, v.pos.z)) <= (v.range or 1) and not v.blocked then
                -- VEHICLE CHECK
                if not teleports[loc][1].allowVehicles or not teleports[loc][2].allowVehicles then
                    if inVeh then
                        exports["soe-ui"]:SendAlert("error", "Can't do this!", 5000)
                        break
                    end
                end

                DoScreenFadeOut(500)
                Wait(500)

                exports["soe-fidelis"]:AuthorizeTeleport()
                if (k == 1) then
                    if teleports[loc][2].allowVehicles then
                        SetPedCoordsKeepVehicle(ped, teleports[loc][2].pos)
                    else
                        SetEntityCoords(ped, teleports[loc][2].pos)
                    end
                    SetEntityHeading(ped, teleports[loc][2].pos.w)
                elseif (k == 2) then
                    if teleports[loc][1].allowVehicles then
                        SetPedCoordsKeepVehicle(ped, teleports[loc][1].pos)
                    else
                        SetEntityCoords(ped, teleports[loc][1].pos)
                    end
                    SetEntityHeading(ped, teleports[loc][1].pos.w)
                end

                Wait(500)
                DoScreenFadeIn(500)
                SetGameplayCamRelativeHeading(0.0)
                break
            end
        end
    end
end

-- ***********************
--         Events
-- ***********************
-- INTERACTION KEY TO USE TELEPORTING POINT
AddEventHandler("Utils:Client:InteractionKey", function()
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() or exports["soe-prison"]:IsImprisoned() then
        return
    end
    DoTeleport()
end)
