local isActive = false
local myProduct = "weed"
local previousCustomers = {}
local isCornerSelling = false
local isCustomerInterested = false
local cooldown = 0

DecorRegister("noSellingDrugs", 3)

-- ALERTS POLICE OF THE SALE
local function AlertTheFuzz(pos)
    local loc = exports["soe-utils"]:GetLocation(pos)
    --TriggerServerEvent("Emergency:Server:CADAlerts", "Attempted Drug Sale", location, '', pos)
    TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = true, type = "Attempted Drug Sale", loc = loc, coords = pos})
    TriggerEvent("Chat:Client:Message", "[Customer]", "Oh no thanks... I was just wondering what you had in those bags.", "system")
end

-- DOES DRUG SALE WHEN OFFER ACCEPTED
local function PerformSale(ped, amount, price)
    local myPed = PlayerPedId()

    -- PLAY A LITTLE ANIMATION
    exports["soe-utils"]:LoadAnimDict("mp_common", 15)
    TaskPlayAnim(ped, "mp_common", "givetake1_b", 1.0, 1.0, 1500, 49, 0, 0, 0, 0)
    TaskPlayAnim(myPed, "mp_common", "givetake1_b", 1.0, 1.0, 1500, 49, 0, 0, 0, 0)

    -- DO DRUG SALE IN THE SERVER SIDE
    TriggerServerEvent("Crime:Server:DoCornerDrugSale", myProduct, amount, price)
end

-- CUSTOMER ACTIONS AND SELLING
local function StartSelling(ped, amount)
    isCustomerInterested = true
    -- CHECK IF WE HAD THIS CUSTOMER BEFORE
    for i = 1, #previousCustomers, 1 do
        if (previousCustomers[i] == ped) then
            --print("We had this dude before.")
            isCustomerInterested = false
            LookForCustomers()
            return
        end
    end

    -- SET OUR RANDOM CHANCES OF THE OUTCOME
    math.randomseed(GetGameTimer())
    local successChance = math.random(1, 20)
    local bagAmount = math.random(1, amount)
    if (bagAmount > 15) then
        bagAmount = math.random(9, 15)
    end

    local config = exports["soe-config"]:GetConfigValue("economy", myProduct)
    local price = (math.random(config["min"], config["max"]) * bagAmount)

    SetEntityAsNoLongerNeeded(ped)
    ClearPedTasks(ped)

    local myPed = PlayerPedId()
    local myPos = GetEntityCoords(myPed)
    TaskGoStraightToCoord(ped, myPos, 1.2, -1, 0.0, 0.0)

    -- DISTANCE CHECKS
    local pos = GetEntityCoords(ped)
    local dist = #(myPos - pos)
    while #(myPos - pos) > 1.5 do
        --print("Too far...")
        myPos = GetEntityCoords(myPed)
        pos = GetEntityCoords(ped)

        TaskGoStraightToCoord(ped, myPos, 1.2, -1, 0.0, 0.0)
        dist = #(myPos - pos)
        Wait(150)
    end

    TaskTurnPedToFaceEntity(ped, myPed, 5500)
    TaskLookAtEntity(ped, myPed, 5500.0, 2048, 3)

    table.insert(previousCustomers, ped)
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    exports["soe-ui"]:PersistentAlert("start", "cornerSell", "warning", ("[E] Accept | [G] Deny (%s %s for $%s)"):format(bagAmount, drugsPrices[myProduct].name, price), 500)

    -- KEYPRESS LISTENER (UNFORTUNATELY THIS WAY SINCE I'M A BIT LAZY)
    isActive = true
    while isActive do
        Wait(5)
        if IsControlJustPressed(0, 38) then
            isActive = false
            if (successChance >= 16) then
                AlertTheFuzz(pos)
            else
                PerformSale(ped, bagAmount, price)
                Wait(1650)
            end 
        elseif IsControlJustPressed(0, 58) then
            isActive = false
            exports["soe-ui"]:SendAlert("error", "You denied this offer", 5000)
        end
    end

    SetPedKeepTask(ped, false)
    SetEntityAsNoLongerNeeded(ped)

    -- START LOOKING FOR CUSTOMERS AGAIN
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    exports["soe-ui"]:PersistentAlert("end", "cornerSell")

    Wait(200)
    ClearPedTasksImmediately(ped)

    Wait(3500)
    LookForCustomers()
end

-- TOGGLES "LOOKING FOR CUSTOMERS" MODE
local function ToggleCornerSelling(_myProduct)
    -- IN CASE SOMEONE WANTS TO TOGGLE OFF BUT HAS NO MORE PRODUCT FROM SERVERSIDE
    if (_myProduct == "none") then
        isCornerSelling = false
        exports["soe-ui"]:SendAlert("inform", "Corner Selling: Off", 5000)
        return
    end

    -- STOP IF THERE IS A COOLDOWN
    if (cooldown > GetGameTimer()) then
        exports["soe-ui"]:SendAlert("error", "Wait a while before doing that again", 5000)
        return
    end

    -- 30 SECOND COOLDOWN
    myProduct = _myProduct
    cooldown = GetGameTimer() + 30000
    if not isCornerSelling then
        isCornerSelling = true
        exports["soe-ui"]:SendAlert("inform", "Corner Selling: On", 5000)
        LookForCustomers()
    else
        isCornerSelling = false
        exports["soe-ui"]:SendAlert("inform", "Corner Selling: Off", 5000)
    end
end

-- STARTS LOOKING FOR INTERESTED CUSTOMERS
function LookForCustomers()
    if not isCornerSelling then isCornerSelling = true end

    -- DOUBLE CHECK THE AMOUNT OF PRODUCT
    local amount, hasEnough = 0, false
    if (myProduct == "meth") then
        amount = exports["soe-inventory"]:HasInventoryItemByAmt("gramofmeth")
        if (amount >= 1) then hasEnough = true end
    elseif (myProduct == "weed") then
        amount = exports["soe-inventory"]:HasInventoryItemByAmt("weed_smallbag")
        if (amount >= 1) then hasEnough = true end
    elseif (myProduct == "coke") then
        amount = exports["soe-inventory"]:HasInventoryItemByAmt("cocainevial")
        if (amount >= 1) then hasEnough = true end
    elseif (myProduct == "shrooms") then
        amount = exports["soe-inventory"]:HasInventoryItemByAmt("shrooms")
        if (amount >= 1) then hasEnough = true end
    elseif (myProduct == "crack") then
        amount = exports["soe-inventory"]:HasInventoryItemByAmt("crack_smallbag")
        if (amount >= 1) then hasEnough = true end
    end

    -- IF WE HAVE ENOUGH, START LOOKING FOR MORE CUSTOMERS
    if hasEnough then
        while isCornerSelling do
            if IsPedInAnyVehicle(PlayerPedId(), true) then 
                isCornerSelling = false
               	exports["soe-ui"]:SendAlert("inform", "Corner Selling: Off, In Vehicle", 5000)
                break
            end

            Wait(4500)
            --print('lookey.')
            local customer = exports["soe-utils"]:GetClosestPed(65.0, true)
            if DoesEntityExist(customer) and IsPedHuman(customer) and not IsEntityDead(customer) then
                -- MAKE SURE THIS LOCAL ISN'T A COP
                if (GetPedType(customer) == 6) then return end
                -- MAKE SURE THIS LOCAL ISN'T BLOCKED FROM GETTING DRUGS
                if DecorExistOn(customer, "noSellingDrugs") then return end

                isCornerSelling = false
                StartSelling(customer, amount)
            end
        end
    else
        isActive, isCornerSelling, isCustomerInterested = false, false, false
        exports["soe-ui"]:SendAlert("error", "You ran out of this product!", 5000)
    end
end

-- CALLED FROM SERVER AFTER "/cornersell" IS EXECUTED
RegisterNetEvent("Crime:Client:ToggleCornerSell")
AddEventHandler("Crime:Client:ToggleCornerSell", ToggleCornerSelling)
