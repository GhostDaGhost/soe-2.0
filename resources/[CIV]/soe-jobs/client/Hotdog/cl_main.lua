local action
local hotdog = {}
local cooldown = 0
local previousCustomers = {}
local stand = GetHashKey("prop_hotdogstand_01")

-- KEY MAPPINGS
RegisterKeyMapping("hotdog_restock", "[Jobs] Restock Hotdog Supplies", "KEYBOARD", "G")
RegisterKeyMapping("hotdog_togglesale", "[Jobs] Toggle Hotdog Sale Status", "KEYBOARD", "G")

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, RESTOCK HOTDOG SUPPIES
local function RestockHotdogSupplies()
    if not action then return end
    if action.status then
        TriggerServerEvent("Jobs:Server:RestockHotdogSupplies", {status = true})
    end
end

-- WHEN TRIGGERED, RELEASE HOTDOG STAND
local function ReleaseHotdogStand()
    hotdog.isPushing = false
    DetachEntity(hotdog.stand)
    SetEntityCollision(hotdog.stand, true, true)

    Wait(250)
    ClearPedTasks(PlayerPedId())
end

-- WHEN TRIGGERED, BRAINWASH THE CUSTOMER INTO BUYING A HOTDOG
local function SellHotdog(customer)
    hotdog.customerInterested = true
    -- CHECK IF WE HAD THIS CUSTOMER BEFORE
    for i = 1, #previousCustomers, 1 do
        if (previousCustomers[i] == customer) then
            hotdog.customerInterested = false
            hotdog.selling = false
            --print("WE HAD THIS DUDE BEFORE")
            ToggleSaleStatus()
            return
        end
    end
    --print("COME HERE YOU LITTLE BITCH | PED ID: ", customer)

    -- START CONTROLLING LOCAL
    hotdog.customer = customer
    ClearPedTasks(hotdog.customer)
    local standPos = GetOffsetFromEntityInWorldCoords(hotdog.stand, 0.0, -0.8, 1.0)
    TaskGoStraightToCoord(hotdog.customer, standPos, 1.2, -1, 0.0, 0.0)

    -- DISTANCE CHECKS
    local pos = GetEntityCoords(hotdog.customer)
    local dist = #(standPos - pos)
    while #(standPos - pos) > 1.5 do
        --print("Too far...")
        standPos = GetOffsetFromEntityInWorldCoords(hotdog.stand, 0.0, -0.8, 1.0)
        pos = GetEntityCoords(hotdog.customer)

        TaskGoStraightToCoord(hotdog.customer, standPos, 1.2, -1, 0.0, 0.0)
        dist = #(standPos - pos)
        Wait(150)
    end

    local myPed = PlayerPedId()
    local hdg = (GetEntityHeading(myPed) + 180)

    TaskTurnPedToFaceEntity(hotdog.customer, myPed, 5500)
    TaskLookAtEntity(hotdog.customer, myPed, 5500.0, 2048, 3)
    SetEntityHeading(hotdog.customer, hdg)
    FreezeEntityPosition(hotdog.customer, true)

    table.insert(previousCustomers, hotdog.customer)
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    TaskStartScenarioInPlace(hotdog.customer, "WORLD_HUMAN_STAND_IMPATIENT", 1, 0)
    exports["soe-ui"]:PersistentAlert("start", "hotdogSale", "warning", "[E] Accept | [G] Deny", 10)

    -- KEYPRESS LISTENER
    hotdog.offering = true
    while hotdog.offering do
        Wait(5)
        if not hotdog.offering then return end

        -- IF CUSTOMER GETS TOO FAR
        if #(standPos - GetEntityCoords(hotdog.customer)) > 1.7 then
            hotdog.offering = false
            hotdog.customerInterested = false
            exports["soe-ui"]:SendAlert("error", "Customer went too far from the stand!", 5000)
        end

        -- IF PLAYER GETS TOO FAR
        if #(standPos - GetEntityCoords(myPed)) > 2.5 then
            hotdog.offering = false
            hotdog.selling = false
            hotdog.customerInterested = false
            exports["soe-ui"]:SendAlert("error", "You went too far from the stand!", 5000)
        end

        if IsControlJustPressed(0, 38) then
            local hasEnough = true
            if not exports["soe-inventory"]:HasInventoryItem("hotdog") then
                exports["soe-ui"]:SendAlert("error", "You ran out of hotdogs!", 5000)
                hasEnough = false
            end

            if hasEnough then
                if not hotdog.obj then
                    hotdog.obj = CreateObject(GetHashKey("prop_cs_hotdog_01"), 0, 0, 0, 1, 1, 1)
                end
                AttachEntityToEntity(hotdog.obj, myPed, GetPedBoneIndex(myPed, 57005), 0.12, 0.0, -0.05, 220.0, 120.0, 0.0, 1, 1, 0, 1, 1, 1)

                -- ANIMATION CONTROLLER
                exports["soe-utils"]:LoadAnimDict("mp_common", 15)
                TaskPlayAnim(hotdog.customer, "mp_common", "givetake1_b", 8.0, 8.0, 1250, 49, 0, 0, 0, 0)
                TaskPlayAnim(myPed, "mp_common", "givetake1_b", 8.0, 8.0, 1250, 49, 0, 0, 0, 0)

                Wait(1350)
                hotdog.offering = false
                TriggerServerEvent("Jobs:Server:PerformHotdogSale", {status = true})

                if hotdog.obj then
                    DetachEntity(hotdog.obj, 1, 1)
                    DeleteEntity(hotdog.obj)
                    hotdog.obj = nil
                end
            end
        elseif IsControlJustPressed(0, 58) then
            hotdog.offering = false
            exports["soe-ui"]:SendAlert("error", "You denied this sale", 5000)
            exports["soe-ui"]:SendAlert("debug", "Customer: Whatever... I'll just leave a bad review", 8500)
        end
    end

    ClearPedTasksImmediately(hotdog.customer)
    FreezeEntityPosition(hotdog.customer, false)
    TaskWanderStandard(hotdog.customer, 10.0, 10)
    hotdog.customer = nil
    hotdog.customerInterested = false
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    exports["soe-ui"]:PersistentAlert("end", "hotdogSale")
end

-- WHEN TRIGGERED, TOGGLE SALE STATUS
local function ToggleSaleStatus()
    if not hotdog.canCook then return end
    if not hotdog.selling then
        hotdog.selling = true
        hotdog.customerInterested = false
        while not hotdog.customerInterested do
            Wait(3500)
            --print("I AM LOOKING")

            if not hotdog.selling then return end
            local customer = exports["soe-utils"]:GetClosestPed(45.0, true)
            if DoesEntityExist(customer) and IsPedHuman(customer) and not IsEntityDead(customer) then
                --print("I FOUND A CUSTOMER")
                if hotdog.customerInterested then return end
                hotdog.customerInterested = true
                SellHotdog(customer)
            end
        end
    else
        hotdog.selling = false
    end
end

-- WHEN TRIGGERED, DO MINIGAME TO COOK HOTDOGS
local function CookHotdogs()
    if hotdog.customer then return end
    if not exports["soe-inventory"]:HasInventoryItem("hotdogbun") then
        exports["soe-ui"]:SendAlert("error", "You do not have a hotdog bun", 5000)
        return
    end

    if not exports["soe-inventory"]:HasInventoryItem("hotdogweiner") then
        exports["soe-ui"]:SendAlert("error", "You do not have a weiner", 5000)
        return
    end

    -- MINIGAME
    exports["soe-emotes"]:StartEmote("bbq")
    if exports["soe-challenge"]:Skillbar(5500, math.random(5, 10)) then
        Wait(200)
        if exports["soe-challenge"]:Skillbar(5500, math.random(5, 10)) then
            Wait(200)
            if exports["soe-challenge"]:Skillbar(5500, math.random(5, 10)) then
                TriggerServerEvent("Jobs:Server:CookHotdog", {status = true})
            else
                exports["soe-ui"]:SendAlert("error", "You burnt this hotdog", 5000)
            end
        else
            exports["soe-ui"]:SendAlert("error", "You undercooked this hotdog", 5000)
        end
    else
        exports["soe-ui"]:SendAlert("error", "You undercooked this hotdog", 5000)
    end
    exports["soe-emotes"]:CancelEmote()
end

-- FUNCTION TO SPAWN HOTDOG STAND
local function ManageHotdogStand(pos, needsSpawning)
    if needsSpawning then
        TriggerServerEvent("Utils:Server:DeletePropAtXYZ", "prop_hotdogstand_01", vector3(pos.x, pos.y, pos.z))
        Wait(1500)

        exports["soe-utils"]:LoadModel(stand, 15)
        hotdog.stand = CreateObject(stand, vector3(pos.x, pos.y, pos.z), true, true, true)

        SetEntityHeading(hotdog.stand, pos.w)
        PlaceObjectOnGroundProperly(hotdog.stand)
        FreezeEntityPosition(hotdog.stand, true)
    else
        -- IF STAND IS IN PROXIMITY, DESPAWN IT
        if #(GetEntityCoords(hotdog.stand) - vector3(pos.x, pos.y, pos.z)) <= 12.0 then
            TriggerServerEvent("Utils:Server:DeleteEntity", ObjToNet(hotdog.stand))
        else
            -- IF THE STAND IS MISSING, FIRE THIS PLAYER AND BAN THEM FOR A CERTAIN AMOUNT OF TIME
            cooldown = GetGameTimer() + 600000
            exports["soe-ui"]:SendAlert("error", "The manager does not see the stand anywhere", 5000)
        end
        hotdog.stand = nil
    end
end

-- WHEN TRIGGERED, MOVE HOTDOG CART AROUND
local function MoveHotdogCart()
    hotdog.isPushing = true
    local loopIndex = 0
    local ped = PlayerPedId()

    exports["soe-utils"]:GetEntityControl(hotdog.stand)
    exports["soe-utils"]:LoadAnimDict("missfinale_c2ig_11", 15)
    TaskPlayAnim(ped, "missfinale_c2ig_11", "pushcar_offcliff_f", 8.0, 8.0, -1, 49, 0, 0, 0, 0)
    Wait(150)
    AttachEntityToEntity(hotdog.stand, ped, GetPedBoneIndex(ped, 28422), -0.45, -1.2, -0.82, 180.0, 180.0, 270.0, 0, 0, 0, 0, 1, 1)

    -- DISABLE SPRINTING/JUMPING/ATTACK AND PERSIST ANIMATION
    FreezeEntityPosition(hotdog.stand, false)
    CreateThread(function()
        while hotdog.isPushing do
            Wait(5)
            DisableControlAction(0, 21, true)
            DisableControlAction(0, 22, true)
            DisableControlAction(0, 23, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)

            loopIndex = loopIndex + 1
            if (loopIndex % 100 == 0) then
                if not IsEntityPlayingAnim(ped, "missfinale_c2ig_11", "pushcar_offcliff_f", 3) then
                    TaskPlayAnim(ped, "missfinale_c2ig_11", "pushcar_offcliff_f", 8.0, 8.0, -1, 49, 0, 0, 0, 0)
                end
            end
        end
    end)
end

-- WHEN TRIGGERED, START THE HOTDOG JOB RUNTIME
local function StartRuntime()
    local ped = PlayerPedId()
    while hotdog.isDoingJob do
        Wait(5)

        if hotdog.stand then
            local pos = GetEntityCoords(ped)
            local obj = GetClosestObjectOfType(pos, 3.0, stand, 0, 0, 0)
            if (obj ~= nil and obj == hotdog.stand) then
                local moveOffset = GetOffsetFromEntityInWorldCoords(obj, 1.0, 0.0, 1.0)
                local cookOffset = GetOffsetFromEntityInWorldCoords(obj, 0.0, 0.0, 1.0)

                if #(pos - moveOffset) <= 0.75 then
                    hotdog.canMove = true
                    if not hotdog.isPushing then
                        exports["soe-utils"]:DrawText3D(moveOffset.x, moveOffset.y, moveOffset.z, "[E] Move Cart", true)
                    else
                        exports["soe-utils"]:DrawText3D(moveOffset.x, moveOffset.y, moveOffset.z, "[E] Release Cart", true)
                    end
                else
                    if hotdog.canMove then
                        hotdog.canMove = false
                    end
                end

                if #(pos - cookOffset) <= 0.85 and not hotdog.customerInterested then
                    hotdog.canCook = true
                    if not hotdog.selling then
                        exports["soe-utils"]:DrawText3D(cookOffset.x, cookOffset.y, cookOffset.z, "[E] Cook Hotdogs - [G] Start Selling", true)
                    else
                        exports["soe-utils"]:DrawText3D(cookOffset.x, cookOffset.y, cookOffset.z, "[E] Cook Hotdogs - [G] Stop Selling", true)
                    end
                else
                    if hotdog.canCook then
                        hotdog.canCook = false
                    end
                end
            end
        end
    end
end

-- TOGGLES HOTDOG SELLING DUTY
local function ToggleDuty(state)
    if state then
        -- CHECK COOLDOWN PRIOR TO JOB START
        if (cooldown > GetGameTimer()) then
            exports["soe-ui"]:SendAlert("error", "You cannot do this yet", 5000)
            return
        end

        -- SECURITY DEPOSIT
        local depositAmt = 110
        if exports["soe-config"]:GetConfigValue("economy", "hotdog_securitydeposit") then
            depositAmt = exports["soe-config"]:GetConfigValue("economy", "hotdog_securitydeposit")
        end

        local securityDeposit = exports["soe-shops"]:NewTransaction(depositAmt, "Hotdog Job Security Deposit")
        if securityDeposit then
            hotdog.isDoingJob = true
            exports["soe-ui"]:HideTooltip()

            if not action then return end
            TriggerServerEvent("Jobs:Server:ToggleDuty", {status = true, dutyStatus = true, job = "HOTDOG"})
            ManageHotdogStand(action.spawnLoc, true)
            StartRuntime()
        end
    else
        -- SET A COOLDOWN FOR A SHORT TIME AND DESPAWN STAND
        cooldown = GetGameTimer() + 5000

        exports["soe-ui"]:HideTooltip()
        ManageHotdogStand(action.spawnLoc, false)
        TriggerServerEvent("Jobs:Server:ToggleDuty", {status = true, dutyStatus = false, job = "HOTDOG"})

        hotdog.isDoingJob = false
        previousCustomers = {}
        hotdog = {}
    end
end

-- **********************
--       Commands
-- **********************
-- WHEN TRIGGERED, RESTOCK HOTDOG SUPPLIES
RegisterCommand("hotdog_restock", RestockHotdogSupplies)
-- WHEN TRIGGERED, TOGGLE HOTDOG SALE STATUS
RegisterCommand("hotdog_togglesale", ToggleSaleStatus)

-- **********************
--        Events
-- **********************
-- IF WE LEFT A ZONE
AddEventHandler("Utils:Client:ExitedZone", function(name)
    if name:match("hotdog_shop") then
        action = nil
        exports["soe-ui"]:HideTooltip()
    end
end)

-- IF RESOURCE STOPS
AddEventHandler("onResourceStop", function(resource)
    if (GetCurrentResourceName() ~= resource) then return end

    if hotdog.stand then
        DeleteObject(hotdog.stand)
        exports["soe-ui"]:PersistentAlert("end", "hotdogSale")
    end
end)

-- IF WE ENTERED A ZONE
AddEventHandler("Utils:Client:EnteredZone", function(name, zoneData)
    if name:match("hotdog_shop") then
        action = {status = true, spawnLoc = zoneData.spawn}
        if (GetMyJob() == "HOTDOG") then
            exports["soe-ui"]:ShowTooltip("fas fa-hotdog", "[E] Quit Job | [G] Restock", "inform")
        else
            exports["soe-ui"]:ShowTooltip("fas fa-hotdog", "[E] Start Job", "inform")
        end
    end
end)

-- INTERACTION KEYPRESS
AddEventHandler("Utils:Client:InteractionKey", function()
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
        return
    end

    -- WHILST IN HOTDOG JOB, ADD THE COOK AND MOVE FUNCTIONS HERE
    if (GetMyJob() == "HOTDOG") then
        if not hotdog.stand then return end
        if hotdog.canMove then
            if not hotdog.isPushing then
                MoveHotdogCart()
            else
                ReleaseHotdogStand()
            end
        elseif hotdog.canCook then
            CookHotdogs()
        end
    end

    -- ZONE FUNCTIONS RELATED TO HOTDOG SELLING DUTY TOGGLE
    if not action then return end
    if action.status then
        if (GetMyJob() == "HOTDOG") then
            ToggleDuty(false)
        else
            ToggleDuty(true)
        end
    end
end)
