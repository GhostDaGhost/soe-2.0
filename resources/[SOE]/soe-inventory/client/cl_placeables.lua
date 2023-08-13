local cooldown = 0
local placingObject = false

-- KEY MAPPINGS
RegisterKeyMapping("pickupobject", "[Inventory] Pickup Object", "KEYBOARD", "G")

-- PICKUPS NEAREST OBJECT
local function PickupObject()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)

    for pickupHash, pickupItem in pairs(pickups) do     
        pickupHash = GetHashKey(pickupHash)   
        local obj = GetClosestObjectOfType(pos, 3.0, pickupHash, 0, 1, 1)
        if (obj ~= 0 and not IsEntityAttached(obj)) then
            if (NetworkGetEntityIsNetworked(GetClosestObjectOfType(pos, 1.0, pickupHash, 0, 1, 1))) then
                if (cooldown > GetGameTimer()) then
                    exports["soe-ui"]:SendAlert("error", "Wait a bit before doing that again", 5000)
                    return
                end

                cooldown = GetGameTimer() + 3500
                exports["soe-utils"]:LoadAnimDict("random@domestic", 15)
                TaskPlayAnim(ped, "random@domestic", "pickup_low", 8.0, 5.0, 1500, 49, 0, 0, 0, 0)
                Wait(500)

                TriggerServerEvent("Inventory:Server:PickupPlaceable", pickupItem, ObjToNet(GetClosestObjectOfType(pos, 10.0, pickupHash, 0, 1, 1)))
                break
            end
        end
    end
end

-- PLACES OBJECT
function PlaceObject(model, offset)
    if not placingObject then
        local hash = GetHashKey(model)
        exports["soe-utils"]:LoadModel(hash, 15)
        local obj = CreateObject(hash, GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 5.0, 0.0), 0, 0, 1)
        local hdg = GetEntityHeading(obj)

        placingObject = true
        SetEntityCollision(obj, false, false)
        while placingObject do
            Wait(5)
            local ray = exports["soe-utils"]:Raycast(100)
            DisableControlAction(0, 311, true)
            DisableControlAction(0, 44, true)
            DisableControlAction(0, 51, true)
            DisableControlAction(0, 201, true)

            SetEntityCoords(obj, ray.HitPosition.x, ray.HitPosition.y, ray.HitPosition.z + (offset or 0.0))
            SetEntityHeading(obj, hdg)

            if IsDisabledControlPressed(0, 44) then
                hdg = hdg - 1.0
            elseif IsDisabledControlPressed(0, 51) then
                hdg = hdg + 1.0
            end

            if IsControlJustPressed(0, 177) then
                DeleteEntity(obj)
                placingObject = false
            end

            if IsDisabledControlPressed(0, 201) then
                DeleteEntity(obj)
                obj = exports["soe-utils"]:SpawnObject(hash)
                SetEntityCoords(obj, ray.HitPosition.x, ray.HitPosition.y, ray.HitPosition.z + (offset or 0.0))
                SetEntityHeading(obj, hdg)
                placingObject = false
                TriggerServerEvent("Inventory:Server:PlacePlaceable", pickups[model])
            end
        end
        SetModelAsNoLongerNeeded(hash)
    end
end

-- KEYPRESS COMMAND
RegisterCommand("pickupobject", PickupObject)
