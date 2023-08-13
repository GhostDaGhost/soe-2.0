furniture = {}

-- DECORATORS
DecorRegister("furnitureID", 3)

-- KEY MAPPINGS
RegisterKeyMapping("property_removemode", "[Housing] Furniture Remove Mode", "KEYBOARD", "END")

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, SYNC FURNITURE PLACEMENT/REMOVAL
local function SyncFurnitureAction(data)
    if not data.status then return end
    if not data.type then return end

    -- CHECK IF THE CLIENT IS INSIDE THE SAME HOUSE AS SOURCE
    local currentProperty = GetCurrentProperty()
    if not currentProperty then return end

    if (tonumber(currentProperty.id) ~= tonumber(data.propertyID)) then
        return
    end

    -- START SYNCING REMOVAL OR PLACING OF OBJECTS
    if (data.type == "Removal") then
        local obj = GetClosestObjectOfType(data.x, data.y, data.z, 1.0, GetHashKey(data.hash), 0, 0, 0)
        if DoesEntityExist(obj) then
            exports["soe-utils"]:GetEntityControl(obj)

            SetEntityAsMissionEntity(obj, true, true)
            TriggerServerEvent("Utils:Server:DeleteEntity", ObjToNet(obj))
            DeleteObject(obj)
            DeleteEntity(obj)
        end
    elseif (data.type == "Placing") then
        exports["soe-utils"]:LoadModel(GetHashKey(data.hash), 15)
        local obj = CreateObject(GetHashKey(data.hash), data.x, data.y, data.z, false, true, false)
        SetEntityAsMissionEntity(obj, true, true)
        SetEntityCoords(obj, data.x, data.y, data.z)
        SetEntityHeading(obj, data.h)
        NetworkSetEntityInvisibleToNetwork(obj, true)

        --[[SetTimeout(3500, function()
            FreezeEntityPosition(obj, true)
        end)]]
        FreezeEntityPosition(obj, true)
        DecorSetInt(obj, "furnitureID", data.furnitureID)
        if not furniture.spawnedProps then
            furniture.spawnedProps = {}
        end
        furniture.spawnedProps[#furniture.spawnedProps + 1] = obj
    end
end

-- WHEN TRIGGERED, TOGGLE FURNITURE REMOVE MODE
local function ToggleFurnitureRemoveMode()
    local currentProperty = GetCurrentProperty()
    if not currentProperty then return end

    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    if not furniture.removing then
        furniture.removing = true
        exports["soe-ui"]:SendAlert("debug", "Remove Mode: On", 2500)

        exports["soe-ui"]:PersistentAlert("start", "deletingFurniture", "debug", "[Enter] | Delete Furniture Prop", 5)
        exports["soe-ui"]:PersistentAlert("start", "deletingFurniture2", "debug", "[Escape] | Disable Remove Mode", 5)
        while furniture.removing do
            Wait(5)
            -- IF 'ESCAPE' IS PRESSED, CANCEL DELETION
            if IsControlJustPressed(0, 200) then
                furniture.removing = false
                exports["soe-ui"]:SendAlert("debug", "Remove Mode: Off", 2500)
            end

            local ent = exports["soe-utils"]:Raycast(100).HitEntity
            if (GetEntityType(ent) == 0) then
                ent = furniture.lastHit
            else
                furniture.lastHit = ent
            end

            local pos = GetEntityCoords(ent)
            local found = GetScreenCoordFromWorldCoord(pos.x, pos.y, pos.z)
            if found then
                DrawMarker(20, pos.x, pos.y, pos.z + 1.5, 0.0, 0.0, 0.0, 180.0, 0.0, 180.0, 0.47, 0.47, 0.47, 168, 107, 50, 170, 1, 1, 2, 0, 0, 0, 0)

                -- IF 'ENTER' IS PRESSED, DELETE SELECTED ENTITY
                if IsControlJustPressed(0, 201) then
                    local currentProperty = GetCurrentProperty()
                    if not currentProperty then
                        furniture.removing = false
                        exports["soe-ui"]:SendAlert("error", "You are not inside a property", 5000)
                    end

                    local furID = DecorGetInt(ent, "furnitureID")
                    if not furID then return end
                    --print("FURNITURE ID:", furID)

                    local pickedUpFurniture = exports["soe-nexus"]:TriggerServerCallback("Properties:Server:RemoveFurniture", furID)
                    if pickedUpFurniture.status then
                        exports["soe-ui"]:SendAlert("success", "You removed this piece of furniture", 5000)
                        exports["soe-utils"]:RegisterEntityAsNetworked(ent)
                        exports["soe-utils"]:GetEntityControl(ent)

                        SetEntityAsMissionEntity(ent, true, true)
                        TriggerServerEvent("Utils:Server:DeleteEntity", ObjToNet(ent))
                        DeleteObject(ent)
                        DeleteEntity(ent)
                    else
                        exports["soe-ui"]:SendAlert("error", "Something went wrong removing this piece of furniture!", 5000)
                    end
                end
            end
        end
        exports["soe-ui"]:PersistentAlert("end", "deletingFurniture")
        exports["soe-ui"]:PersistentAlert("end", "deletingFurniture2")
    else
        furniture.removing = false
        exports["soe-ui"]:SendAlert("debug", "Remove Mode: Off", 2500)
    end
end

-- WHEN TRIGGERED, REMOVE THE TOY PLAYER IS NEXT TO
local function RemoveToy()
    local currentProperty = GetCurrentProperty()
    if not currentProperty then return end

    -- GET ALL THE TOYS IN THE PROPERTY
    local found, toys = false, {}
    local propertyFurniture = exports["soe-nexus"]:TriggerServerCallback("Properties:Server:GetFurniture", currentProperty.id)
    for _, prop in pairs(propertyFurniture.data) do
        if string.match(prop.ObjHash,"vw_prop_vw") then
            toys[#toys + 1] = {id = prop.FurnitureID, pos = prop.ObjPosition, hash = prop.ObjHash}
        end
    end

    -- FIND THE CLOSEST TOY
    for _, data in pairs(toys) do
        local closestToy = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 1.25, GetHashKey(data.hash), false)
        if DoesEntityExist(closestToy) then
            local furID = DecorGetInt(closestToy, "furnitureID")
            if not furID then return end

            local pickedUpFurniture = exports["soe-nexus"]:TriggerServerCallback("Properties:Server:RemoveFurniture", furID)
            if pickedUpFurniture.status then
                exports["soe-ui"]:SendAlert("success", "You removed the toy", 5000)
                exports["soe-utils"]:RegisterEntityAsNetworked(closestToy)
                exports["soe-utils"]:GetEntityControl(closestToy)

                SetEntityAsMissionEntity(closestToy, true, true)
                TriggerServerEvent("Utils:Server:DeleteEntity", ObjToNet(closestToy))
                DeleteObject(closestToy)
                DeleteEntity(closestToy)
            else
                exports["soe-ui"]:SendAlert("error", "Something went wrong removing the toy!", 5000)
            end

            found = true
            break
        end
    end

    if not found then
        exports["soe-ui"]:SendAlert("error", "You must be near a toy!", 5000)
    end
end

-- WHEN TRIGGERED, PREPARE PLACEMENT OF FURNITURE
local function PrepFurniturePlacement(model, offset)
    local currentProperty = GetCurrentProperty()
    if not currentProperty then
        exports["soe-ui"]:SendAlert("error", "You are not inside a property", 5000)
        return
    end

    if not furniture.placingObj then
        local hash = GetHashKey(model)
        exports["soe-utils"]:LoadModel(hash, 15)

        local obj = CreateObject(hash, GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 5.0, 0.0), 0, 0, 1)
        local hdg = GetEntityHeading(obj)

        furniture.removing = false
        furniture.placingObj = true
        SetEntityCollision(obj, false, false)

        exports["soe-ui"]:SendAlert("inform", "[Left Shift] | Hold For Fine Tune", 9500)
        exports["soe-ui"]:SendAlert("inform", "[E] | Rotate Counter-Clockwise", 9500)
        exports["soe-ui"]:SendAlert("inform", "[Q] | Rotate Clockwise", 9500)
        exports["soe-ui"]:SendAlert("inform", "[X] | Increment Height", 9500)
        exports["soe-ui"]:SendAlert("inform", "[Left Alt] | Decrement Height", 9500)
        exports["soe-ui"]:SendAlert("inform", "[Enter] | Finalize Position", 9500)
        while furniture.placingObj do
            Wait(5)
            local ray = exports["soe-utils"]:Raycast(100)
            DisableControlAction(0, 311, true)
            DisableControlAction(0, 44, true)
            DisableControlAction(0, 51, true)
            DisableControlAction(0, 201, true)

            SetEntityCoords(obj, ray.HitPosition.x, ray.HitPosition.y, ray.HitPosition.z + (offset or 0.0))
            SetEntityHeading(obj, hdg)

            -- FINE TUNING FOR HEADING/POSITION OF FURNITURE
            if IsControlPressed(0, 21) then
                if IsDisabledControlPressed(0, 44) then
                    hdg = hdg - 0.1
                elseif IsDisabledControlPressed(0, 51) then
                    hdg = hdg + 0.1
                end

                if IsControlJustReleased(0, 19) then
                    offset = offset - 0.1
                elseif IsControlJustReleased(0, 73) then
                    offset = offset + 0.1
                end
            else
                if IsDisabledControlPressed(0, 44) then
                    hdg = hdg - 1.0
                elseif IsDisabledControlPressed(0, 51) then
                    hdg = hdg + 1.0
                end

                if IsControlJustReleased(0, 19) then
                    offset = offset - 1.0
                elseif IsControlJustReleased(0, 73) then
                    offset = offset + 1.0
                end
            end

            if IsControlJustPressed(0, 177) then
                DeleteEntity(obj)
                furniture.placingObj = false
            end

            if IsDisabledControlPressed(0, 201) then
                local currentProperty = GetCurrentProperty()
                if not currentProperty then
                    exports["soe-ui"]:SendAlert("error", "You are not inside a property", 5000)
                    return
                end

                DeleteEntity(obj)
                furniture.placingObj = false
                local furniturePos = vector3(ray.HitPosition.x, ray.HitPosition.y, ray.HitPosition.z + (offset or 0.0))
                local placedObj = exports["soe-nexus"]:TriggerServerCallback("Properties:Server:PlaceFurniture", currentProperty.id, model, furniturePos, hdg)
                if placedObj.status then
                    exports["soe-ui"]:SendAlert("success", "You placed down this piece of furniture!", 5000)
                else
                    exports["soe-ui"]:SendAlert("error", "Something went wrong placing this down!", 5000)
                end
            end
        end
        SetModelAsNoLongerNeeded(hash)
    else
        exports["soe-ui"]:SendAlert("error", "Already placing furniture down!", 5000)
    end
end

-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, RETURN FURNITURE PROPS DATA
function GetFurniture()
    return furnitureProps
end

-- WHEN TRIGGERED, RETURN IF PLAYER IS IN FURNITURE REMOVING MODE
function IsInFurnitureRemovingMode()
    return furniture.removing
end

-- WHEN TRIGGERED, RETURN IF PLAYER IS IN FURNITURE PLACING MODE
function IsInFurniturePlacingMode()
    return furniture.placingObj
end

-- **********************
--       Commands
-- **********************
-- WHEN TRIGGERED, TOGGLE PROPERTY REMOVE MODE
RegisterCommand("property_removemode", ToggleFurnitureRemoveMode)

-- WHEN TRIGGERED, REMOVE THE TOY PLAYER IS NEXT TO
RegisterCommand("property_removetoy", RemoveToy)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, START PLACEMENT OF A FURNITURE PROP
AddEventHandler("Properties:Client:PrepFurniturePlacement", PrepFurniturePlacement)

-- WHEN TRIGGERED, SYNC FURNITURE PLACEMENT/REMOVAL
RegisterNetEvent("Properties:Client:SyncFurnitureAction")
AddEventHandler("Properties:Client:SyncFurnitureAction", SyncFurnitureAction)
