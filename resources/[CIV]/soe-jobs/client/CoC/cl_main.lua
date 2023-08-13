-- LOCAL VARIABLES
SOEMenu = assert(MenuV)
currentBusiness = nil
local cocMenuMain = SOEMenu:CreateMenu(false, "Select an item", 'topright', 255, 255, 255, 'size-100', 'default', 'menuv', 'cocMenuMain', 'native')
cocMenuRadius = 1.25
isCoCMenuOpen = false

-- CREATE RECIPE VARIABLE
local isCreatingRecipe = false

-- **********************
--    Local Functions
-- **********************

local function CreateRecipe(recipeData)
    -- EXIT IF PLAYER IS ALREADY CREATING A RECIPE
    if isCreatingRecipe then
        exports["soe-ui"]:SendAlert("error", "You are already making something!", 4000)
        return
    end

    -- SET HOW LONG IT TAKES TO CREATE THE RECIPE IF NOT DEFINED
    if recipeData.duration == nil then
        duration = 25000
    else
        duration = recipeData.duration
    end

    -- DO CREATING RECIPE STUFF HERE
    isCreatingRecipe = true
    exports["soe-utils"]:Progress(
        {
            name = "creatingRecipe",
            duration = duration,
            label = ("Making %s"):format(recipeData.itemDisplayName),
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
            },
            animation = {
                animDict = "mp_arresting",
                anim = "a_uncuff",
                flags = 49
            }
        },
        function(cancelled)
            if not cancelled then
                -- OPEN CONTAINER SERVER SIDE TO GIVE ITEMS
                --print(recipeData.item, recipeData.itemDisplayName, recipeData.amount, recipeData.containerItem, recipeData.containerName, duration)
                TriggerServerEvent("Jobs:Server:CreateRecipe", {status = true, item = recipeData.item, amount = recipeData.amount, containerItem = recipeData.containerItem, recipeIngredients = recipeData.recipeIngredients, craft = recipeData.craft})
            end
            -- ALLOW PLAYER TO CREATE ANOTER RECIPE
            isCreatingRecipe = false
        end
    )

end

local function closeMenus()
    cocMenuMain:ClearItems()
    SOEMenu:CloseAll()
    isCoCMenuOpen = false
end

-- JOB INTERACTION MENU
local function JobInteractionMenu()
    cocMenuMain:ClearItems()
    cocMenuMain:SetTitle(currentBusiness.name)

    -- GET PERMS FOR SELECTED BUSINESS
    local suppliesPerm, garagePerm = nil, nil
    if currentBusiness.perms then
        for _, perm in pairs(currentBusiness.perms) do
            if string.match(perm, "SUPPLIES") then
                suppliesPerm = perm
            elseif string.match(perm, "GARAGECLIENT") then
                garageClientPerm = perm
            elseif string.match(perm, "GARAGE") then
                garagePerm = perm
            elseif string.match(perm, "SEA") then
                boatPerm = perm
            elseif string.match(perm, "AIR") then
                airPerm = perm
            elseif string.match(perm, "SMELTER") then
                smelterPerm = perm
            end
        end
    end

    local hasSuppliesPerm = exports["soe-factions"]:CheckPermission(suppliesPerm)
    local hasAirPerm = exports["soe-factions"]:CheckPermission(airPerm)
    local hasGarageClientPerm = exports["soe-factions"]:CheckPermission(garageClientPerm)
    local hasGaragePerm = exports["soe-factions"]:CheckPermission(garagePerm)
    local hasBoatPerm = exports["soe-factions"]:CheckPermission(boatPerm)
    local hasSmelterPerm = exports["soe-factions"]:CheckPermission(smelterPerm)

    -- CREATE BUTTON FOR AIRCRAFT STORAGE AT BUSINESS LOCATION IF PLAYER IS AUTHORIZED FOR AIRCRAFT STORAGE
    if hasAirPerm then
        local buttonIndex = cocMenuMain:AddButton({ icon = "🚁", label = "Access Hangar", select = function()
            exports["soe-valet"]:ShowValet(("%s - %s"):format(currentBusiness.name,"Air"), exports["soe-uchuu"]:GetPlayer().CharID, true)
            closeMenus()
        end})
    end

    -- CREATE BUTTON FOR GARAGE AT BUSINESS LOCATION IF PLAYER IS AUTHORIZED FOR GARAGE
    if hasGaragePerm then
        local buttonIndex = cocMenuMain:AddButton({ icon = "🚗", label = "Access Garage", select = function()
            exports["soe-valet"]:ShowValet(("%s - %s"):format(currentBusiness.name,"Land"), exports["soe-uchuu"]:GetPlayer().CharID, true)
            closeMenus()
        end})
    end

    -- CREATE BUTTON FOR GARAGES AT BUSINESS LOCATION IF PLAYER IS AUTHORIZED FOR CLIENT GARAGES
    if currentBusiness and currentBusiness["garages"] and hasGarageClientPerm then
        local garageAccess = 0
        for garageNumber = 1, currentBusiness.garages do
            hasGarageXPerm = exports["soe-factions"]:CheckPermission(("%s%s"):format(garagePerm, garageNumber))
            if hasGarageXPerm then
                garageAccess = garageAccess + 1
                local buttonIndex = cocMenuMain:AddButton({ icon = "🚗", label = ("Access Garage %s"):format(garageNumber), select = function()
                    exports["soe-valet"]:ShowValet(("%s %s - %s"):format(currentBusiness.name, garageNumber ,"Land"), exports["soe-uchuu"]:GetPlayer().CharID, true)
                    closeMenus()
                end})
            end
        end
        if garageAccess == 0 then
            local buttonIndex = cocMenuMain:AddButton({ icon = "", label = "You have no access to any garages", select = function()
                closeMenus()
            end})
        end
    end

    -- CREATE BUTTON FOR BOAT STORAGE AT BUSINESS LOCATION IF PLAYER IS AUTHORIZED FOR BOAT STORAGE
    if boatPerm then
        local buttonIndex = cocMenuMain:AddButton({ icon = "🛥️", label = "Access Boat Storage", select = function()
            exports["soe-valet"]:ShowValet(("%s - %s"):format(currentBusiness.name,"Sea"), exports["soe-uchuu"]:GetPlayer().CharID, true)
            closeMenus()
        end})
    end

    -- CREATE DIVIDER IF HAVE BOTH PERMS
    if hasGaragePerm and hasSuppliesPerm then
        local buttonIndex = cocMenuMain:AddButton({ icon = "", label = "-------------------------------------"})
    end

    -- CREATE BUTTONS FOR RECIPES AT BUSINESS LOCATION IF PLAYER IS AUTHORIZED FOR SUPPLIES
    if hasSuppliesPerm then
        for buttonIndex, recipe in pairs(currentBusiness.recipes) do
            local buttonIndex = cocMenuMain:AddButton({ icon = recipe.itemIcon, label = recipe.name, select = function()
                if exports["soe-inventory"]:HasInventoryItem(currentBusiness.supplies[recipe.supply].requiredItem) then
                    local recipeData = {
                        item = recipe.itemName,
                        itemDisplayName = recipe.itemDisplayName,
                        amount = recipe.amount,
                        containerItem = currentBusiness.supplies[recipe.supply].requiredItem,
                        containerName = currentBusiness.supplies[recipe.supply].requiredItemName,
                        duration = 5000
                    }
                    CreateRecipe(recipeData)
                else
                    exports["soe-ui"]:SendAlert("inform", string.format("You need 1 %s to make this!", currentBusiness.supplies[recipe.supply].requiredItemName), 9000)
                end
                closeMenus()
            end})
        end
    end

    if currentBusiness.craft then
        for buttonIndex, recipe in pairs(currentBusiness.recipes) do
            local buttonIndex = cocMenuMain:AddButton({ icon = recipe.itemIcon, label = recipe.name, select = function()
                -- CHECK FOR MISSING ITEMS
                local missingItems, recipeIngredients = {}, recipe.ingredients
                for _, data in pairs(recipe.ingredients) do
                    local haveAmount = exports["soe-inventory"]:HasInventoryItemByAmt(data.itemName)
                    if haveAmount < data.requiredAmount then
                        missingItems[#missingItems + 1] = {name = data.itemDisplayName, amount = data.requiredAmount - haveAmount}
                    end
                end

                -- CONTINUE TO CRAFT IF NO MISSING ITEMS ELSE DISPLAY WHAT ITEMS ARE MISSING AND AMOUNT
                if #missingItems == 0 then
                    local recipeData = {
                        item = recipe.itemName,
                        itemDisplayName = recipe.itemDisplayName,
                        amount = recipe.amount,
                        duration = recipe.craftTime,
                        recipeIngredients = recipeIngredients,
                        craft = true,
                    }
                    CreateRecipe(recipeData)
                elseif #missingItems > 1 then
                    exports["soe-ui"]:SendAlert("error", "You are missing some items to make this", 9000)
                    local missingString = ("%s x%s"):format(missingItems[1].name, missingItems[1].amount)
                    for index = 2, #missingItems do
                        missingString = ("%s, %s x%s"):format(missingString, missingItems[index].name, missingItems[index].amount)
                    end
                    TriggerEvent("Chat:Client:Message", ("[%s]"):format(currentBusiness.name), ("Missing: %s"):format(missingString), "taxi")
                elseif #missingItems == 1 then
                    exports["soe-ui"]:SendAlert("error", "You are missing an item to make this", 9000)
                    local missingString = ("%s x%s"):format(missingItems[1].name, missingItems[1].amount)
                    TriggerEvent("Chat:Client:Message", ("[%s]"):format(currentBusiness.name), ("Missing: %s"):format(missingString), "taxi")
                end

                -- CLOSE THE MENU
                closeMenus()
            end})
        end
    end

    -- OPEN MENU AND FREEZE PLAYER/CONTROLS
    cocMenuMain:Open()
    isCoCMenuOpen = true
    while isCoCMenuOpen do
        Wait(5)
        DisableControlAction(0, 23)
        DisableControlAction(0, 75)
    end
end

-- ON MENU CLOSED
cocMenuMain:On('close', function(menu)
    closeMenus()
end)

-- INTERACTION KEYPRESS
AddEventHandler("Utils:Client:InteractionKey", function()
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
        return
    end

    -- CHECK IF NEAR A BUSINESS LOCATION
    currentBusiness = nil
    local playerCoords, distance = GetEntityCoords(PlayerPedId()), nil
    for business, data in pairs(suppliesSpot) do
        for _, posData in pairs(data.pos) do
            distance = #(playerCoords - posData)
            if distance <= cocMenuRadius then
                currentBusiness = data
                currentBusiness.coords = posData
                break
            end
        end
    end

    -- IF A BUSINESS IS FOUND NEAR PLAYER
    if currentBusiness ~= nil then
        local authorized = false
        if currentBusiness.perms then
            -- PLAYER MUST HAVE AT LEAST ONE PERM IN LIST
            for _, perm in pairs(currentBusiness.perms) do
                if exports["soe-factions"]:CheckPermission(perm) then
                    authorized = true
                    break
                end
            end
        else
            authorized = true
        end

        -- SHOW ERROR MESSAGE IF PLAYER IS NOT AUTHORIZED
        if not authorized then
            exports["soe-ui"]:SendUniqueAlert("noperms", "error", "You do not have the right permissions to use this store!", 2500)
            return
        else
            JobInteractionMenu()
        end
    else
        -- CHECK IF PLAYER IS NEAR A BUSINESS COUNTER IF NOT NEAR A BUSINESS
        for _, data in pairs(counterSpot) do
            distance = #(playerCoords - data.pos)
            if distance <= data.range then
                TriggerEvent("Inventory:Client:ShowInventory", "counter", false, data.name)
                break
            end
        end
    end
end)