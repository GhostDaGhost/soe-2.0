local currentMachine, closestMachine
usingVendingMachine, showingVendingMachineHelpText = false, false

-- **********************
--    Local Functions
-- **********************
-- USES VENDING MACHINE
local function UseVendingMachine()
    if usingVendingMachine then return end

    local ped = PlayerPedId()
    if IsNearVendingMachine(ped) and not exports["soe-crime"]:IsPickingMachine() then
        local machineInfo = vendingMachines[currentMachine]
        local price = machineInfo.price
        local afford = false

        usingVendingMachine = true
        if not machineInfo.isGumball then
            local payment = exports["soe-shops"]:NewTransaction(price, "Vending Machine Usage")
            if payment then
                afford = true
            end
        else
            afford = exports["soe-nexus"]:TriggerServerCallback("Shops:Server:BuyFromGumballMachine", price)
        end

        if afford then
            if showingVendingMachineHelpText then
                showingVendingMachineHelpText = false
                exports["soe-ui"]:HideTooltip()
            end

            local animationDuration = -1
            local bypassAnimation = false
            if machineInfo.bypassAnim then
                bypassAnimation = true
                animationDuration = 1000
            end

            TaskTurnPedToFaceEntity(ped, closestMachine, -1)
            RequestAmbientAudioBank("VENDING_MACHINE")
            HintAmbientAudioBank("VENDING_MACHINE", 0, -1)

            SetPedCurrentWeaponVisible(ped, false, true, 1, 0)
            exports["soe-utils"]:LoadModel(GetHashKey(machineInfo.prop), 15)
            SetPedResetFlag(ped, 322, true)

            local position = GetOffsetFromEntityInWorldCoords(closestMachine, 0.0, -0.97, 0.05)
            if not IsEntityAtCoord(ped, position, 0.1, 0.1, 0.1, false, true, 0) then
                TaskGoStraightToCoord(ped, position, 1.0, 20000, GetEntityHeading(currentMachine), 0.1)
            end
            TaskTurnPedToFaceEntity(ped, closestMachine, -1)
            Wait(1000)

            exports["soe-utils"]:LoadAnimDict("mini@sprunk", 15)
            TaskPlayAnim(ped, "mini@sprunk", "plyr_buy_drink_pt1", 8.0, 5.0, animationDuration, 0, 0, 0, 0, 0)
            Wait(2500)

            local canModel = CreateObjectNoOffset(GetHashKey(machineInfo.prop), position, 1, 0, 0)
            SetEntityAsMissionEntity(canModel, true, true)
            SetEntityProofs(canModel, false, true, false, false, false, false, 0, false)
            AttachEntityToEntity(canModel, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
            Wait(1700)

            exports["soe-utils"]:LoadAnimDict("mp_common_miss")
            TaskPlayAnim(ped, "mp_common_miss", "put_away_coke", 8.0, 5.0, -1, 0, 0, 0, 0)
            Wait(1000)

            ClearPedTasks(ped)
            ReleaseAmbientAudioBank()
            if DoesEntityExist(canModel) then
                DetachEntity(canModel, true, true)
                DeleteEntity(canModel)
            end
            SetModelAsNoLongerNeeded(machineInfo.prop)

            local itemToGive
            if machineInfo.item == "gumball" then
                local gumballColors = {"blue", "green", "orange", "pink", "purple", "red", "yellow"}
                local randomNum = math.random(1, #gumballColors)
                itemToGive = string.format("gumball_%s", gumballColors[randomNum])
            else
                itemToGive = machineInfo.item 
            end

            -- TAKE MONEY AND GIVE ITEM HERE
            TriggerServerEvent("Shops:Server:BuyFromVendingMachine", {status = true, product = itemToGive})
        end
        usingVendingMachine = false
    end
end

-- **********************
--    Global Functions
-- **********************
-- HANDLES VENDING MACHINE RUNTIME
function HandleVendingMachineRuntime()
    local myMachine = vendingMachines[currentMachine]
    if not showingVendingMachineHelpText then
        showingVendingMachineHelpText = true
        exports["soe-ui"]:ShowTooltip("far fa-money-bill-alt", ("[E] Use Machine For %s ($%s)"):format(myMachine.name, myMachine.price), "inform")
    end
end

-- RETURNS IF PLAYER IS NEAR VENDING MACHINE
function IsNearVendingMachine(ped)
    local pos = GetEntityCoords(ped)
    for machine in pairs(vendingMachines) do
        closestMachine = GetClosestObjectOfType(pos, 0.65, GetHashKey(vendingMachines[machine].hash), 0, 0, 0)
        if DoesEntityExist(closestMachine) then
            currentMachine = machine
            return true
        end
    end
    return false
end

-- **********************
--        Events
-- **********************
-- INTERACTION KEYPRESS TO USE VENDING MACHINE
AddEventHandler("Utils:Client:InteractionKey", UseVendingMachine)
