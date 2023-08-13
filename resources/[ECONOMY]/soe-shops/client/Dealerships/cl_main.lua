local isBuying, isTestDriving = false, false
local isInPreviewMode, vehiclePreviewed, myPreviewVehicle, myTestDriveVehicle, testDriveReturn = false, false, nil, nil, nil
local dealershipMenu = menuV:CreateMenu("Dealership", "This bad boy can go over 100 quick!", "topright", 73, 140, 38, "size-125", "default", "menuv", "dealershipMenu", "default")
local myDealership, dealershipSelected = nil, true

isDealershipMenuOpen = false

DecorRegister("isDealershipVehicle", 2)

-- SORTING BY ALPHABET TOOL
local function SortByAlphabet(input, output)
    local a = {}
    for n in pairs(input) do
        a[#a + 1] = n
    end
    table.sort(a, output)

    local i = 0
    local iter = function()
        i = i + 1
        if (a[i] == nil) then
            return nil
        else
            return a[i], input[a[i]]
        end
    end
    return iter
end

-- SHOWS A PREVIEW OF THE VEHICLE SELECTED
local function ShowPreviewVehicle(hash, previewPos)
    -- DELETES OLD PREVIEW VEHICLE
    EliminatePreviewVehicle()

    -- WAIT A BIT BEFORE SPAWNING... POSSIBLE DUPE FIX?? - GHOST 2/18/21
    Wait(250)

    -- SPAWN PREVIEW VEHICLE
    hash = GetHashKey(hash)
    exports["soe-utils"]:LoadModel(hash, 15)
    --myPreviewVehicle = exports["soe-utils"]:SpawnVehicle(hash, previewPos) | WE DO NOT NEED TO SLOW IT DOWN BY LOADING IT FROM THE SERVER
    myPreviewVehicle = CreateVehicle(hash, previewPos["x"], previewPos["y"], previewPos["z"], previewPos["w"], true, false)

    SetVehicleOnGroundProperly(myPreviewVehicle)
    SetEntityAsMissionEntity(myPreviewVehicle, true)
    while not DoesEntityExist(myPreviewVehicle) do
        Wait(15)
    end

    -- SET VEHICLE PROPERTIES
    SetEntityInvincible(myPreviewVehicle, true)
    FreezeEntityPosition(myPreviewVehicle, true)
    SetEntityCollision(myPreviewVehicle, false, false)
    DecorSetBool(myPreviewVehicle, "noInventoryLoot", true)
    DecorSetBool(myPreviewVehicle, "isDealershipVehicle", true)
    vehiclePreviewed = true
end

-- RETURNS TEST DRIVEN VEHICLE TO DEALERSHIP
local function ReturnTestDrivenVehicle()
    if not isTestDriving then return end

    -- IF CLOSE TO RETURN
    if #(GetEntityCoords(myTestDriveVehicle) - vector3(testDriveReturn.x, testDriveReturn.y, testDriveReturn.z)) <= 3.0 then
        isTestDriving = false
        exports["soe-ui"]:PersistentAlert("end", "testDriving")

        -- MAKE THE PED LEAVE THE VEHICLE BEFORE DESPAWNING
        TaskLeaveVehicle(PlayerPedId(), myTestDriveVehicle, 0)
        Wait(2500)

        -- ALT
        --TriggerEvent('persistent-vehicles/forget-vehicle', myTestDriveVehicle)

        -- DELETE THE VEHICLE ENTITY
        --exports["soe-valet"]:RemoveKey(myTestDriveVehicle)
        if DoesEntityExist(myTestDriveVehicle) then
            DeleteEntity(myTestDriveVehicle)
        end
        myTestDriveVehicle, testDriveReturn = nil, nil
        exports["soe-ui"]:SendAlert("success", "Thank you for returning the vehicle!", 8000)
    end
end

-- STARTS TEST DRIVING FEATURE FOR VEHICLE
local function StartTestDrivingVehicle(hash, previewPos, dealershipName)
    menuV:CloseAll()
    isDealershipMenuOpen = false

    hash = GetHashKey(hash)
    testDriveReturn = previewPos

    local model = GetLabelText(GetDisplayNameFromVehicleModel(hash))
    exports["soe-ui"]:SendAlert("warning", "You have begun to test drive the " .. model, 9500)
    DoScreenFadeOut(500)
    Wait(500)

    exports["soe-utils"]:LoadModel(hash, 15)
    myTestDriveVehicle = exports["soe-utils"]:SpawnVehicle(hash, testDriveReturn)
    local plate = exports["soe-utils"]:GenerateRandomPlate()
    SetVehicleNumberPlateText(myTestDriveVehicle, plate)
    Wait(500)

    SetPedIntoVehicle(PlayerPedId(), myTestDriveVehicle, -1)
    exports["soe-valet"]:UpdateKeys(myTestDriveVehicle)
    exports["soe-utils"]:SetRentalStatus(myTestDriveVehicle, dealershipName)
    DecorSetBool(myTestDriveVehicle, "noInventoryLoot", true)
    DoScreenFadeIn(500)

    exports["soe-ui"]:PersistentAlert("start", "testDriving", "inform", ("You are currently test driving the %s. Do not go too far from the dealership or we'll have no choice but to kill the engine."):format(model), 500)
    CreateThread(function()
        local loopIndex, warnings, lastWarning = 0, 0, 0
        while isTestDriving do
            Wait(5)
            DrawMarker(21, testDriveReturn.x, testDriveReturn.y, testDriveReturn.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 73, 140, 38, 195, 0, 1, 2, 0, 0, 0, 0)

            loopIndex = loopIndex + 1
            if (loopIndex % 200 == 0) then
                loopIndex = 0
                -- CHECK IF VEHICLE GOT LOCAL TOWED
                if not DoesEntityExist(myTestDriveVehicle) then
                    if not isTestDriving then return end
                    isTestDriving = false
                    myTestDriveVehicle, testDriveReturn = nil, nil
                    exports["soe-ui"]:PersistentAlert("end", "testDriving")
                    exports["soe-ui"]:SendAlert("error", "We lost track of the vehicle... cancelling your test drive.", 9500)
                end

                -- CHECK IF VEHICLE GOT BLOWN UP OR SOMETHING
                if IsEntityDead(myTestDriveVehicle) then
                    if not isTestDriving then return end
                    isTestDriving = false
                    myTestDriveVehicle, testDriveReturn = nil, nil
                    exports["soe-ui"]:PersistentAlert("end", "testDriving")
                    exports["soe-ui"]:SendAlert("error", "We lost track of the vehicle... cancelling your test drive.", 9500)
                end

                -- DISTANCE CHECK
                if #(GetEntityCoords(myTestDriveVehicle) - vector3(testDriveReturn.x, testDriveReturn.y, testDriveReturn.z)) >= 950.0 then
                    if (GetGameTimer() - lastWarning > 30000) then
                        lastWarning = GetGameTimer()
                        if (warnings ~= 3) then
                            warnings = warnings + 1
                        end
                        exports["soe-ui"]:SendAlert("error", ("You are going too far from the dealership! You have %s/3 warnings and 30 seconds to correct yourself."):format(warnings), 15500)
                    end

                    if (warnings == 3) then
                        if not isTestDriving then return end
                        isTestDriving = false
                        local plate = GetVehicleNumberPlateText(myTestDriveVehicle)
                        TriggerServerEvent("Emergency:Server:MarkStolen", plate, true, true)

                        SetVehicleEngineHealth(myTestDriveVehicle, 0)
                        SetVehicleEngineOn(myTestDriveVehicle, false, false, false)
                        myTestDriveVehicle, testDriveReturn = nil, nil

                        exports["soe-ui"]:PersistentAlert("end", "testDriving")
                        exports["soe-ui"]:SendAlert("error", "We've given you plenty of warnings and time to return back to a good distance from the dealership. Vehicle has been killed and reported stolen.", 10500)
                    end
                end
            end
        end
    end)
end

-- BUILDS DEALERSHIP MENU
local function OpenMyDealershipMenu()
    if isDealershipMenuOpen then return end
    -- CLEAR MENU IF ALREADY EXISTS
    dealershipMenu:ClearItems()

    -- FIND CLOSEST DEALERSHIP
    myDealership, dealershipSelected = nil, true
    for _, dealership in pairs(dealerships) do
        if #(GetEntityCoords(PlayerPedId()) - dealership.pos) <= dealership.range then
            myDealership = dealership
            break
        end
    end

    if myDealership then
        -- CHECK IF STORE REQUIRES SPECIAL PERMS TO USE
        if myDealership.perms then
            local authorized = false
            -- PLAYER MUST HAVE ALL PERMS IN LIST
            for _, perm in pairs(myDealership.perms) do
                if exports["soe-factions"]:CheckPermission(perm) then
                    authorized = true
                else
                    authorized = false
                end
            end

            -- SHOW ERROR MESSAGE IF PLAYER IS NOT AUTHORIZED
            if not authorized then
                exports["soe-ui"]:SendAlert("error", "You do not have the right permissions to use this dealership!", 5000)
                return
            end
        end

        -- CHECK TO SEE IF THE DEALERSHIP IS AN IMPORT DEALERSHIP
        if myDealership.isImport then
            -- SET VARIBALE AND MENU TEXT
            dealershipSelected = false
            dealershipMenu:SetTitle(myDealership.name or "Dealershipe")
            dealershipMenu:SetSubtitle("Select Dealership")

            -- ITERATE THROUGH ALL DEALERSHIPS AND DISPLAY THEM IN MENU
            for _, dealership in pairs(dealerships) do
                if not dealership.isImport and dealership.forImports ~= false then
                    dealershipMenu:AddButton({icon = dealership.icon, label = ("%s"):format(dealership.name), select = function()
                        dealershipMenu:SetSubtitle("Select Vehicle To Import")

                        -- OVERRIDE DEALERSHIP DATA AND OPEN MENU
                        myDealership.vehicles = dealership.vehicles

                        -- CLEAR OLD ITEMS
                        dealershipMenu:ClearItems()
                        dealershipSelected = true
                    end})
                end
            end

            -- OPEN THE MENU
            dealershipMenu:Open()
            isDealershipMenuOpen = true

            -- WAIT FOR DEALERSHIP TO BE SELECTED
            while not dealershipSelected do
                Wait(5)
            end
        end

        -- ADD LIST OF VEHICLES FOR SALE AT LOCATION TO MENU
        dealershipMenu:SetTitle(myDealership.name or "Dealership")
        for _, v in SortByAlphabet(myDealership.vehicles) do
            local price = 666666
            if exports["soe-config"]:GetConfigValue("economy", v.hash) then
                price = exports["soe-config"]:GetConfigValue("economy", v.hash).buy
            end

            local discountedPrice = false
            if myDealership.isImport then
                -- IMPORTERS GET 35% DISCOUNT OR $10,000 WHICH EVER COMES FIRST
                local originalPrice = price
                local newPrice = math.floor(exports["soe-config"]:GetConfigValue("economy", v.hash).buy * dealershipsdiscountPerc)
                local priceDifference = originalPrice - newPrice

                if priceDifference > maxDiscountPrice then
                    price = price - maxDiscountPrice
                else
                    price = priceDifference
                end

                discountedPrice = true
            end

            local name = GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(v.hash)))
            local buttonText = ("%s <span style='float:right;color:lightgreen;'>$%s</span>"):format(name, price)

            if discountedPrice then
                buttonText = ("%s <span style='float:right;color:lightgreen;'>$%s (Discounted)</span>"):format(name, price)
            end

            local thisVehicle = menuV:InheritMenu(dealershipMenu, {["title"] = false, ["subtitle"] = name})
            dealershipMenu:AddButton({icon = "", label = buttonText, value = thisVehicle})

            local purchasebutton = thisVehicle:AddButton({icon = "💲", label = "Purchase Vehicle", select = function()
                isBuying = true
                local payment = exports["soe-shops"]:NewTransaction(price, "Vehicle Purchase")
                if payment then
                    -- STOP PREVIEWING IF PREVIEWING
                    if isInPreviewMode then
                        isInPreviewMode = false
                        EliminatePreviewVehicle()
                    end

                    -- DISPLAY VEHICLE PLAYER IS GOING TO PURCHASE
                    ShowPreviewVehicle(v.hash, myDealership.preview)

                    -- WAIT FOR THE VEHICLE TO BE DISPLAYED
                    while not vehiclePreviewed do
                        print("WAITING FOR VEHICLE PREVIEW")
                        Wait(5)
                    end

                    local mods = GetModDataFromVehicle(myPreviewVehicle, false)
                    local model = GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(v.hash)))
                    TriggerServerEvent("Shops:Server:PurchaseMyVehicle", v.hash, model, price, mods, myDealership.defaultGarage)
                else
                    EliminatePreviewVehicle()
                    return
                end
            end})

            local previewButton = thisVehicle:AddButton({icon = "📸", label = "Preview Vehicle", select = function()
                if not isInPreviewMode then
                    isInPreviewMode = true
                    ShowPreviewVehicle(v.hash, myDealership.preview)
                else
                    isInPreviewMode = false
                    EliminatePreviewVehicle()
                end
            end})

            local testDriveButton = thisVehicle:AddButton({icon = "🏁", label = "Test Drive Vehicle", select = function()
                if not isTestDriving then
                    isTestDriving = true
                    EliminatePreviewVehicle()
                    StartTestDrivingVehicle(v.hash, myDealership.preview, myDealership.name)
                end
            end})
            Wait(15)
        end

        dealershipMenu:Open()
        isDealershipMenuOpen = true
    end
end

-- ON MENU CLOSED, REMOVE PREVIEW VEHICLE IF IT EXISTS
dealershipMenu:On("close", function(menu)
    isDealershipMenuOpen = false
    if not isBuying then
        EliminatePreviewVehicle()
    end
end)

-- RETURNS IF PLAYER IS NEAR A DEALERSHIP
function IsNearDealership(ped)
    for _, dealership in pairs(dealerships) do
        if #(GetEntityCoords(ped) - dealership.pos) <= dealership.range then
            return true
        end
    end
    return false
end

-- ENSURES DELETION OF PREVIEW VEHICLE
function EliminatePreviewVehicle()
    if (myPreviewVehicle ~= nil) then
        DeleteEntity(myPreviewVehicle)
        if DoesEntityExist(myPreviewVehicle) then
            DeleteVehicle(myPreviewVehicle)
        end
        myPreviewVehicle = nil
        vehiclePreviewed = false
    end
end

-- OPENS DEALERSHIP MENU
AddEventHandler("Shops:Client:BrowseDealership", OpenMyDealershipMenu)

-- INTERACTION KEY TO RETURN TEST DRIVEN VEHICLE
AddEventHandler("Utils:Client:InteractionKey", ReturnTestDrivenVehicle)

-- CALLED FROM SERVER TO SPAWN VEHICLE AFTER PURCHASE
RegisterNetEvent("Shops:Client:PurchaseMyVehicle")
AddEventHandler("Shops:Client:PurchaseMyVehicle", function(hash, plate, vin, data)
    -- CLOSE MENU
    menuV:CloseAll()
    isDealershipMenuOpen = false
    Wait(350)

    -- RESET VEHICLE PROPERTIES
    SetEntityInvincible(myPreviewVehicle, false)
    FreezeEntityPosition(myPreviewVehicle, false)
    SetEntityCollision(myPreviewVehicle, true, true)

    -- SET LICENSE PLATE AND GIVE PLAYER KEYS
    SetVehicleNumberPlateText(myPreviewVehicle, plate)
    Wait(200)
    exports["soe-valet"]:UpdateKeys(myPreviewVehicle)

    -- SET VIN AND FUEL
    DecorSetBool(myPreviewVehicle, "playerOwned", true)
    DecorSetInt(myPreviewVehicle, "vin", tonumber(vin))
    exports["soe-fuel"]:SetFuel(myPreviewVehicle, 100)
    DecorSetBool(myPreviewVehicle, "isDealershipVehicle", false)

    -- LOCK THE VEHICLE BY DEFAULT
    SetVehicleDoorsLocked(myPreviewVehicle, 2)
    DecorSetBool(myPreviewVehicle, "unlocked", false)

    -- SET IT AS A VALET VEHICLE
    Wait(1500)
    exports["soe-utils"]:GetEntityControl(myPreviewVehicle)
    local netID = NetworkGetNetworkIdFromEntity(myPreviewVehicle)
    SetNetworkIdExistsOnAllMachines(netID, true)
    TriggerServerEvent("Valet:Server:RegisterVehicleSpawned", data, netID)
    myPreviewVehicle = nil
    isBuying = false
end)
