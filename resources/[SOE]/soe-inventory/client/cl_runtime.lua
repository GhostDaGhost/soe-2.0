local loopIndex = 0
local nearbyItems = {}
local hasSpawned, notificationShown = false, false

-- WHEN TRIGGERED, START INVENTORY RUNTIME
AddEventHandler("Uchuu:Client:PlayerSpawned", function()
    hasSpawned = true
end)

CreateThread(function()
    -- WAIT UNTIL CHARACTER SELECTED
    while not hasSpawned do
        if (exports["soe-uchuu"]:GetPlayer().CharID ~= nil) then
            hasSpawned = true
        end
        Wait(150)
    end

    -- WAIT FOR DROPPED ITEMS LIST
    TriggerServerEvent("Inventory:Server:RequestDroppedItems")
    while not droppedItems do 
        Wait(10)
    end

    -- MAIN RUNTIME LOOP
    RequestInventory()
    while true do
        Wait(5)
        -- DRAW DROPPED ITEM MARKERS
        local pos = GetEntityCoords(PlayerPedId())
        for _, item in pairs(nearbyItems) do
            if #(pos - item["pos"]) <= 6.0 then
                DrawMarker(2, item["pos"], 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.15, 0.15, 0.15, 255, 255, 255, 100, 1, 1, 2, 0, 0, 0, 0)
            end
        end

        EnforceInventoryWeight()
        loopIndex = loopIndex + 1

        -- EVERY 50 ITERATIONS
        if (loopIndex % 50 == 0) then
            -- GET CLOSEST ITEM TO DISPLAY HELP TEXT
            local closestItem = GetClosestDroppedItem(droppedItems)
            if closestItem and not IsPedSittingInAnyVehicle(PlayerPedId()) then
                local notifyText
                if (closestItem["amt"] > 1) then
                    notifyText = ("Pick Up: %s %s"):format(closestItem["amt"], itemdefs[closestItem.item]["multiple"])
                else
                    notifyText = ("Pick Up: %s %s"):format(closestItem["amt"], itemdefs[closestItem.item]["singular"])
                end

                exports["soe-ui"]:ShowTooltip("far fa-hand-paper", "[G] " .. notifyText, "inform")
                notificationShown = true
            else
                if notificationShown then
                    exports["soe-ui"]:HideTooltip()
                    notificationShown = false
                end
            end
        end

        -- EVERY 55 ITERATIONS - FIND OUR NEAREST DROPPED ITEMS
        if (loopIndex % 55 == 0) then
            nearbyItems = {}
            for itemID, itemData in pairs(droppedItems) do
                if #(pos - itemData["pos"]) <= 7.5 then
                    nearbyItems[itemID] = itemData
                end
            end
        end

        -- EVERY 435 ITERATIONS - UPDATE CURRENT BODY ARMOR
        if (loopIndex % 435 == 0) then
            loopIndex = 0
            local armor = GetPedArmour(PlayerPedId())
            if wearingArmor and myArmorData and (armor < tonumber(myArmorData["percent"])) then
                myArmorData["percent"] = armor
                TriggerServerEvent("Inventory:Server:UpdateArmorWelfare", myArmorData["itemID"], myArmorData["type"], armor)
            end
        end
    end
end)
