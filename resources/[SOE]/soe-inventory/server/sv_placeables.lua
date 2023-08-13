-- **********************
--    Local Functions
-- **********************
-- ADDS PICKED UP OBJECT ITEM TO THE SOURCE'S INVENTORY AND SYNCS PROP DELETION
local function PickupPlaceable(src, itemType, obj)
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    if AddItem(src, "char", charID, tostring(itemType), 1, "{}") then
        TriggerClientEvent("Utils:Client:DeleteEntity", -1, obj)
    end
end

-- **********************
--        Events
-- **********************
RegisterNetEvent("Inventory:Server:PickupPlaceable")
AddEventHandler("Inventory:Server:PickupPlaceable", function(itemType, obj)
    local src = source
    PickupPlaceable(src, itemType, obj)
end)

RegisterNetEvent("Inventory:Server:PlacePlaceable")
AddEventHandler("Inventory:Server:PlacePlaceable", function(itemType)
    local src = source
    RemoveItem(src, 1, tostring(itemType))
end)
