-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, GET FURNITURE BY PROPERTY ID FOR PROPERTY
AddEventHandler("Properties:Server:GetFurniture", function(cb, src, propertyID)
    if not propertyID then cb({status = false}) return end

    -- REQUEST FURNITURE FROM THE DB
    local getFurniture = exports["soe-nexus"]:PerformAPIRequest("/api/properties/getfurniture", ("propertyid=%s"):format(propertyID), true)
    if getFurniture.status then
        cb({status = true, data = getFurniture.data})
    else
        cb({status = false})
    end
end)

-- WHEN TRIGGERED, REMVOE A FURNITURE PROP FROM A PROPERTY
AddEventHandler("Properties:Server:RemoveFurniture", function(cb, src, furnitureID)
    if not furnitureID then cb({status = false}) return end

    local removeFurniture = exports["soe-nexus"]:PerformAPIRequest("/api/properties/removefurniture", ("furnitureid=%s"):format(furnitureID), true)
    if removeFurniture.status then
        cb({status = true})
        local data = removeFurniture.data

        -- CRAFT AN ACTION MESSAGE
        local propName = "furniture"
        if furnitureProps[data.ObjHash] then
            propName = furnitureProps[data.ObjHash].name
            local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
            exports["soe-inventory"]:AddItem(src, "char", charID, furnitureProps[data.ObjHash].itemHash, 1, "{}")
        end

        -- ADD FURNITURE ITEM TO INVENTORY AND MAKE AN ACTION MESSAGE IN CHAT
        local name = exports["soe-chat"]:GetDisplayName(src)
        exports["soe-chat"]:DoProximityMessage(src, 10.0, "me-2", "", name, "removes ".. propName ..".")

        -- SYNC THE REMOVAL OF AN UN-NETWORKED OBJECT TO EVERYONE ELSE INSIDE THE PROPERTY
        local pos = json.decode(data.ObjPosition)
        for playerID in pairs(exports["soe-uchuu"]:GetOnlinePlayerList()) do
            if (src ~= playerID) then
                TriggerClientEvent("Properties:Client:SyncFurnitureAction", playerID, {status = true,
                    type = "Removal", propertyID = data.PropertyID, x = tonumber(pos.x), y = tonumber(pos.y),
                    z = tonumber(pos.z), hash = data.ObjHash
                })
            end
        end
    else
        cb({status = false})
    end
end)

-- WHEN TRIGGERED, PLACE A FURNITURE PROP IN A PROPERTY
AddEventHandler("Properties:Server:PlaceFurniture", function(cb, src, propertyID, model, pos, hdg)
    if not propertyID then cb({status = false}) return end
    if not model then cb({status = false}) return end
    if not pos then cb({status = false}) return end

    pos = {x = pos.x, y = pos.y, z = pos.z, h = hdg}
    local dataString = ("propertyid=%s&prophash=%s&propcoords=%s"):format(propertyID, model, json.encode(pos))
    local addFurniture = exports["soe-nexus"]:PerformAPIRequest("/api/properties/addfurniture", dataString, true)

    if addFurniture.status then
        cb({status = true})

        -- CRAFT AN ACTION MESSAGE
        local propName = "furniture"
        if furnitureProps[model] then
            propName = furnitureProps[model].name
            exports["soe-inventory"]:RemoveItem(src, 1, furnitureProps[model].itemHash)
        end

        -- REMOVE FURNITURE ITEM FROM INVENTORY AND MAKE AN ACTION MESSAGE IN CHAT
        local name = exports["soe-chat"]:GetDisplayName(src)
        exports["soe-chat"]:DoProximityMessage(src, 10.0, "me-2", "", name, "places down ".. propName ..".")

        -- SYNC THE UN-NETWORKED OBJECT TO EVERYONE ELSE INSIDE THE PROPERTY... YES YOU HEARD ME
        TriggerClientEvent("Properties:Client:SyncFurnitureAction", -1, {status = true, type = "Placing", hash = model,
            x = tonumber(pos.x), y = tonumber(pos.y), z = tonumber(pos.z), h = tonumber(hdg), propertyID = propertyID, furnitureID = addFurniture.data.FurnitureID
        })
    else
        cb({status = false})
    end
end)
