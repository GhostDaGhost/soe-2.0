local awaitingDropResponse, awaitingPickupResponse
droppedItems = {}

-- KEY TO PICKUP ITEM
RegisterKeyMapping("pickupitem", "[Inventory] Pickup Item", "KEYBOARD", "G")

-- DROP ITEM FUNCTION
local function DropItem(itemData)
    local charID = exports["soe-uchuu"]:GetPlayer().CharID
    local pos = GetEntityCoords(PlayerPedId())

    -- LET SERVER HANDLE ITEM DROPS
    HandleItemTransfer("drop", "hand", itemData["item"], itemData["uid"], tonumber(itemData["amt"]))
    TriggerServerEvent("Inventory:Server:DropItem", charID, pos, itemData)

    -- WAIT FOR RESPONSE
    while awaitingDropResponse == nil do
        Wait(10)
    end

    -- RETURN IF IT DIDN'T WORK
    if not awaitingDropResponse then
        return
    end

    -- ANIMATION
    if not exports["soe-utils"]:IsModelADog(ped) then
        exports["soe-utils"]:LoadAnimDict("random@domestic", 15)
        TaskPlayAnim(PlayerPedId(), "random@domestic", "pickup_low", 8.0, 5.0, 1500, 49, 0, 0, 0, 0)
    end
    RequestInventory()
end

-- PICKUP THE CLOSEST ITEM IF IT EXISTS
local function PickupItem()
    -- CHECK IF THERE'S AN ITEM CLOSE ENOUGH
    local closestItem = GetClosestDroppedItem(droppedItems)

    -- IF NO ITEM FOUND
    if not closestItem then
        return
    end

    -- ADD ITEM NOTIFICATION
    local amt = tonumber(closestItem["amt"])
    if (amt > 1) then
        TriggerEvent("Inventory:Client:ItemNotify", "add", closestItem["item"], amt, itemdefs[closestItem["item"]]["multiple"])
    else
        TriggerEvent("Inventory:Client:ItemNotify", "add", closestItem["item"], amt, itemdefs[closestItem["item"]]["singular"])
    end

    -- CHECK WITH SERVER TO MAKE SURE IT EXISTS STILL
    local charID = exports["soe-uchuu"]:GetPlayer().CharID
    TriggerServerEvent("Inventory:Server:PickupItem", closestItem, charID)

    -- WAITING FOR RESPONSE
    awaitingPickupResponse = nil
    while awaitingPickupResponse == nil do
        Wait(10)
    end

    -- IF NO LONGER EXISTS
    if not awaitingPickupResponse then
        return
    end

    -- ANIMATION
    if not exports["soe-utils"]:IsModelADog(ped) then
        exports["soe-utils"]:LoadAnimDict("random@domestic", 15)
        TaskPlayAnim(PlayerPedId(), "random@domestic", "pickup_low", 8.0, 5.0, 1500, 49, 0, 0, 0, 0)
    end
    RequestInventory()
end

-- GET CLOSEST ITEM DROPPED AND IF IN RANGE
function GetClosestDroppedItem(items)
    local currDist = 10000000
    local currItem = nil
    local pedCoords = GetEntityCoords(PlayerPedId())

    -- ITERATE
    for _, item in pairs(items) do
        local distance = #(item.pos - pedCoords)
        if distance < currDist then
            currDist = distance
            currItem = item
        end
    end

    -- IF CLOSE ENOUGH
    if currDist <= 1.5 then
        return currItem
    end

    -- NO ITEM FOUND IN RANGE
    return nil
end

RegisterCommand("pickupitem", PickupItem)

-- DROP ITEM BUTTON ON NUI
RegisterNUICallback("dropItem", function(data)
    DropItem(data)
end)

-- GET DROPPED ITEM LIST FROM SERVER
RegisterNetEvent("Inventory:Client:SendDroppedItems")
AddEventHandler("Inventory:Client:SendDroppedItems", function(items)
    droppedItems = items
end)

-- GET PICKUP RESPONSE
RegisterNetEvent("Inventory:Client:SendPickupResponse")
AddEventHandler("Inventory:Client:SendPickupResponse", function(response)
    awaitingPickupResponse = response
end)

-- GET DROP RESPONSE
RegisterNetEvent("Inventory:Client:SendDropResponse")
AddEventHandler("Inventory:Client:SendDropResponse", function(response)
    awaitingDropResponse = response
end)
