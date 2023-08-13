local action
local isLaundererMenuOpen = false
local laundererMenu = menuV:CreateMenu("Launderer", "Shhh.", "topright", 209, 168, 92, "size-125", "default", "menuv", "laundererMenu", "default")

-- OPENS MONEY LAUNDERING MENU
local function OpenMoneyLaundererMenu()
    if isLaundererMenuOpen then return end
    -- CLEAR MENU IF ALREADY EXISTS
    laundererMenu:ClearItems()

    if action then
        local moneyStored = exports["soe-nexus"]:TriggerServerCallback("Crime:Server:GetMoneyLaundered")
        local myStoredMoney, charID = nil, exports["soe-uchuu"]:GetPlayer().CharID

        for _, money in pairs(moneyStored) do
            if (money.charID == charID and money.launderer == action.name) then
                myStoredMoney = money
            end
        end

        laundererMenu:SetSubtitle(action.name or "Shhh.")
        if myStoredMoney then
            if myStoredMoney.ready then
                local laundererCommission = math.modf(myStoredMoney.amount * action.commission)
                local cleanMoneyPayout = myStoredMoney.amount - laundererCommission
                local buttonText = ("Collect Money <span style='float:right;color:lightgreen;'>$%s</span>"):format(cleanMoneyPayout)
                laundererMenu:AddButton({icon = "👐", label = buttonText, select = function()
                    menuV:CloseAll()
                    TriggerServerEvent("Crime:Server:PickupLaunderedMoney", action)
                end})
            else
                laundererMenu:AddButton({icon = "⏳", label = "COME BACK LATER"})
            end
        else
            laundererMenu:AddButton({icon = "", label = "Launder Money", select = function()
                local dirtyCashAmt = exports["soe-inventory"]:GetItemAmt("dirtycash", "left")
                exports["soe-input"]:OpenInputDialogue("number", ("Enter Amount To Launder (You have: %s):"):format(dirtyCashAmt), function(returnData)
                    if (returnData ~= nil) then
                        menuV:CloseAll()
                        if action then
                            TriggerServerEvent("Crime:Server:LaunderMoney", tonumber(returnData), action["name"])
                        else
                            exports["soe-ui"]:SendAlert("error", "You got too far away!", 5000)
                        end
                    end
                end)
            end})
        end

        laundererMenu:Open()
        isLaundererMenuOpen = true
    else
        print("MY CLOSEST LAUNDERER WAS NIL. TRY AGAIN.")
    end
end

-- ON MENU CLOSED
laundererMenu:On("close", function(menu)
    isLaundererMenuOpen = false
end)

AddEventHandler("Utils:Client:EnteredZone", function(name, zoneData)
    if name:match("launderer") then
        action = {status = true, name = zoneData.launderName, commission = zoneData.commission}
        exports["soe-ui"]:ShowTooltip("fas fa-funnel-dollar", "[E] Launder Money", "inform")
    end
end)

AddEventHandler("Utils:Client:ExitedZone", function(name)
    if name:match("launderer") then
        action = nil
        exports["soe-ui"]:HideTooltip()
        if isLaundererMenuOpen then
            menuV:CloseAll()
            isLaundererMenuOpen = false
        end
    end
end)

AddEventHandler("Utils:Client:InteractionKey", function()
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
        return
    end

    -- ZONE FUNCTIONS RELATED TO MONEY LAUNDERING
    if not action then return end
    if action.status then
        OpenMoneyLaundererMenu()
    end
end)
