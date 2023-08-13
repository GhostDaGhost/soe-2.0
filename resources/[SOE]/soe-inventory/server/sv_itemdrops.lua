local droppedItems = {}

-- **********************
--    Local Functions
-- **********************
-- ADD DROPPED ITEM TO LIST AND INFORM ALL CLIENTS
local function AddDroppedItem(itemData, itemPos)
    droppedItems[#droppedItems + 1] = {
        ["uid"] = itemData.uid,
        ["item"] = itemData.item,
        ["amt"] = tonumber(itemData.amt),
        ["pos"] = vector3(itemPos.x, itemPos.y, itemPos.z - 0.8)
    }
    TriggerClientEvent("Inventory:Client:SendDroppedItems", -1, droppedItems)
end

-- **********************
--        Events
-- **********************
-- SEND DROPPED ITEMS LIST
RegisterNetEvent("Inventory:Server:RequestDroppedItems")
AddEventHandler("Inventory:Client:RequestDroppedItems", function()
    local src = source
    TriggerClientEvent("Inventory:Client:SendDroppedItems", src, droppedItems)
end)

-- PLAYER WANTS TO DROP ITEM
RegisterNetEvent("Inventory:Server:DropItem", function(charID, pos, itemData)
    local src = source
    local dataString = ("uid=%s&amt=%s"):format(itemData.uid, itemData.amt)
    local returnData = exports["soe-nexus"]:PerformAPIRequest("/api/inventory/dropitem", dataString, true)

    if returnData.status then
        itemData.uid = returnData.data
        AddDroppedItem(itemData, pos)
        TriggerClientEvent("Inventory:Client:SendDropResponse", src, true)
    else
        TriggerClientEvent("Inventory:Client:SendDropResponse", src, false)
    end
end)

-- PLAYER WANTS TO PICKUP ITEM
RegisterNetEvent("Inventory:Server:PickupItem", function(itemToPickup, charID)
    local src = source
    local dataString = ("uid=%s&charid=%s"):format(itemToPickup.uid, charID)
    local returnData = exports["soe-nexus"]:PerformAPIRequest("/api/inventory/pickupitem", dataString, true)

    -- IF IT WORKED, SEND DATA BACK
    if returnData.status then
        for i, item in pairs(droppedItems) do
            if (item.uid == returnData.data) then
                droppedItems[i] = nil
                TriggerClientEvent("Inventory:Client:SendDroppedItems", -1, droppedItems)

                TriggerClientEvent("Inventory:Client:SendPickupResponse", src, true)
                return
            end
        end
    else
        TriggerClientEvent("Inventory:Client:SendPickupResponse", src, false)
    end
end)
