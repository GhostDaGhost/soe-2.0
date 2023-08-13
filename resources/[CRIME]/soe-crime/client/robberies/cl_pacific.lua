local pacificRobbery = {}
local action

local cooldown = 0
local cashPileModel, trolleyHash = `hei_prop_heist_cash_pile`, `ch_prop_ch_cash_trolly_01c`

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, SYNC THERMAL CHARGE EFFECTS
local function SyncThermalChargeEffects(pos)
    exports["soe-utils"]:LoadPTFXAsset("scr_ornate_heist", 15)

    SetPtfxAssetNextCall("scr_ornate_heist")
    local effect = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", pos, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
    Wait(13000)
    StopParticleFxLooped(effect, 0)
end

-- WHEN TRIGGERED, SYNC PACIFIC STANDARD SAFE OPENING/CLOSING
local function ManageSafe(opening, reset)
    local thisBank = banks["Pacific Standard"]
    local obj = GetClosestObjectOfType(thisBank["vaultPos"]["x"], thisBank["vaultPos"]["y"], thisBank["vaultPos"]["z"], 2.5, thisBank["vault"], false, false, false)

    local count = 0
    FreezeEntityPosition(obj, false)
    if opening then
        if reset then
            SetEntityHeading(obj, 58.0)
        else
            repeat
                local rotation = GetEntityHeading(obj) - 0.05

                SetEntityHeading(obj, rotation)
                count = count + 1
                Wait(5)
            until count == 1550
        end
    else
        SetEntityHeading(obj, 160.0)
    end
    FreezeEntityPosition(obj, true)
end

-- WHEN TRIGGERED, SECURE THE PACIFIC STANDARD BANK VAULT
local function SecureTheVault()
    exports["soe-emotes"]:StartEmote("cashier")
    exports["soe-utils"]:Progress(
        {
            name = "securingVault",
            duration = math.random(8500, 9500),
            label = "Securing Vault",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = false
            }
        },
        function(cancelled)
            exports["soe-emotes"]:CancelEmote()
            if not cancelled then
                if action then
                    exports["soe-ui"]:HideTooltip()
                    TriggerServerEvent("Crime:Server:SyncPacificSafe", {["status"] = true, ["opening"] = false})
                else
                    exports["soe-ui"]:SendAlert("error", "Not close enough! Try again!", 5000)
                end
            end
        end
    )
end

-- WHEN TRIGGERED, DO THERMAL CHARGE TASKS
local function DoThermalChargeTasks()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)

    local thermalSpot
    for _, thermalData in pairs(banks["Pacific Standard"]["thermalNeededLocations"]) do
        if #(pos - vector3(thermalData["pos"]["x"], thermalData["pos"]["y"], thermalData["pos"]["z"])) <= 2.0 then
            thermalSpot = thermalData
            break
        end
    end

    local canRobPacificStandard = exports["soe-nexus"]:TriggerServerCallback("Crime:Server:PacificRequirementCheck")
    if (thermalSpot ~= nil) and canRobPacificStandard then
        -- CHECK IF ANOTHER PLAYER IS TOO CLOSE
        if (exports["soe-utils"]:GetClosestPlayer(1.5) ~= nil) then
            exports["soe-ui"]:SendAlert("error", "Someone else is too close!", 5000)
            return
        end

        exports["soe-utils"]:LoadModel(`hei_prop_heist_thermite`, 15)
        SetEntityHeading(ped, thermalSpot["pos"]["w"])
        Wait(100)

        local rot = GetEntityRotation(ped)
        local scene = NetworkCreateSynchronisedScene(thermalSpot["pos"]["x"], thermalSpot["pos"]["y"], thermalSpot["pos"]["z"], rot["x"], rot["y"], rot["z"], 2, false, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, scene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.5, -4.0, 1, 16, 1148846080, 0)
        NetworkStartSynchronisedScene(scene)

        local charge = CreateObject(`hei_prop_heist_thermite`, pos["x"], pos["y"], pos["z"] + 0.2, true, true, false)
        SetEntityCollision(charge, false, true)
        AttachEntityToEntity(charge, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
        Wait(4000)

        DetachEntity(charge, 1, 1)
        FreezeEntityPosition(charge, true)
        TriggerServerEvent("Crime:Server:SyncThermalChargeEffects", {["status"] = true, ["pos"] = thermalSpot["fxPos"]})
        NetworkStopSynchronisedScene(scene)

        TriggerServerEvent("Crime:Server:RemovePacificItem", {["status"] = true, ["item"] = "thermalcharge"})
        TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, 0, 0, 0)
        TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 3000, 49, 1, 0, 0, 0)
        Wait(2000)

        ClearPedTasks(ped)
        local loc = exports["soe-utils"]:GetLocation(pos)
        local desc = ("Security cameras are reporting a suspicious orange cloud coming from a door at the Pacific Standard Bank in the area of %s."):format(loc)
        TriggerServerEvent("Emergency:Server:CADAlerts", {
            ["status"] = true, ["global"] = true, ["code"] = "10-78", ["desc"] = desc, ["type"] = "Pacific Standard Alert", ["loc"] = loc, ["coords"] = pos
        })

        Wait(2000)
        TriggerServerEvent("Utils:Server:DeleteEntity", ObjToNet(charge))
        Wait(9000)
        exports["soe-ui"]:SendAlert("success", "You successfully burned the door open!", 8500)
        TriggerServerEvent("Doors:Server:SyncStateChange", {["status"] = true, ["doorID"] = thermalSpot["doorID"], ["state"] = false, ["usingThermite"] = true})
    end
end

-- WHEN TRIGGERED, ATTEMPT PANEL HACK BASED OFF DOOR
local function AttemptPanelHack(doorPanelID)
    if pacificRobbery["isHacking"] then return end

    if not exports["soe-inventory"]:HasInventoryItem("usb2") then
        exports["soe-ui"]:SendAlert("error", "You need a Red USB stick!", 5000)
        return
    end

    -- CHECK IF ANOTHER PLAYER IS TOO CLOSE
    if (exports["soe-utils"]:GetClosestPlayer(1.5) ~= nil) then
        exports["soe-ui"]:SendAlert("error", "Someone else is too close to the panel!", 5000)
        return
    end

    local canRobPacificStandard = exports["soe-nexus"]:TriggerServerCallback("Crime:Server:PacificRequirementCheck")
    if not canRobPacificStandard then
        return
    end

    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local loc = exports["soe-utils"]:GetLocation(pos)

    -- ALERT POLICE/DISPATCH
    local desc = ("Security cameras are reporting an unauthorized subject touching door control panels at the Pacific Standard Bank in the area of %s."):format(loc)
    TriggerServerEvent("Emergency:Server:CADAlerts", {
        ["status"] = true, ["global"] = true, ["code"] = "10-78", ["desc"] = desc, ["type"] = "Pacific Standard Alert", ["loc"] = loc, ["coords"] = pos
    })

    if (doorPanelID == 2) then
        if not exports["soe-inventory"]:HasInventoryItem("cellphone") then
            exports["soe-ui"]:SendAlert("error", "You need a phone!", 5000)
            return
        end

        exports["soe-ui"]:HideTooltip()
        exports["soe-ui"]:SendAlert("inform", "You start hacking the panel with your phone...", 8500)

        pacificRobbery["isHacking"] = true
        TaskPlayAnim(ped, "anim@heists@fleeca_bank@scope_out@cashier_loop", "cashier_loop", 3.5, 3.5, 3500, 1, 0, 0, 0, 0)
        Wait(3500)
        exports["soe-emotes"]:StartEmote("phoneplay")
        Wait(1200)

        TriggerEvent("MHacking:Client:Show")
        TriggerEvent("MHacking:Client:Start", math.random(3, 5), math.random(35, 45), function(success, remainingTime)
            pacificRobbery["isHacking"] = false
            StopAnimTask(PlayerPedId(), "amb@world_human_stand_mobile@male@text@base", "base", 2.5)
            exports["soe-emotes"]:EliminateAllProps()
    
            TriggerEvent("MHacking:Client:Hide")
            if success then
                TriggerServerEvent("Crime:Server:RemovePacificItem", {["status"] = true, ["item"] = "usb2"})
                exports["soe-ui"]:SendAlert("success", ("You successfully hacked the panel with %s miliseconds left"):format(remainingTime), 8500)
                TriggerServerEvent("Doors:Server:SyncStateChange", {["status"] = true, ["doorID"] = 482, ["state"] = false, ["usingThermite"] = true})

                -- SPAWN GUARDS
                exports["soe-utils"]:LoadModel(`mp_s_m_armoured_01`, 15)
                for _, guardPos in pairs(banks["Pacific Standard"]["guardLocations"]) do
                    local guard = CreatePed(4, `mp_s_m_armoured_01`, guardPos["x"], guardPos["y"], guardPos["z"], guardPos["w"], true, false)
                    GiveWeaponToPed(guard, `WEAPON_COMBATPISTOL`, 10000, false, true)

                    SetPedDropsWeaponsWhenDead(guard, false)
                    SetPedFleeAttributes(guard, 0, false)
                    SetBlockingOfNonTemporaryEvents(guard, true)
                    SetPedArmour(guard, 180)
                    SetPedAccuracy(guard, math.random(50, 75))
                    SetPedSuffersCriticalHits(guard, false)

                    SetEntityAsMissionEntity(guard, true, true)
                    TaskCombatPed(guard, PlayerPedId(), 0, 16)
                    SetPedKeepTask(guard, true)
                end
                SetModelAsNoLongerNeeded(`mp_s_m_armoured_01`)
            else
                exports["soe-ui"]:SendAlert("error", "You failed to hack the panel", 8500)
            end
        end)
    elseif (doorPanelID == 3) then
        if not exports["soe-inventory"]:HasInventoryItem("laptop") then
            exports["soe-ui"]:SendAlert("error", "You need a laptop!", 5000)
            return
        end

        local bankCardNeeded = banks["Pacific Standard"]["bankCardNeeded"]
        if not exports["soe-inventory"]:HasInventoryItem(bankCardNeeded["name"]) then
            exports["soe-ui"]:SendAlert("error", "You need a " .. bankCardNeeded["label"] .. "!", 5000)
            return
        end

        pacificRobbery["hackOutput"] = nil
        pacificRobbery["isHacking"] = true

        exports["soe-ui"]:HideTooltip()
        local panelCoords = action["panelPos"] or vector4(253.556, 228.2637, 101.6666, 70.86614)
        TaskGoStraightToCoord(ped, panelCoords["x"], panelCoords["y"], panelCoords["z"], 1.2, -1, 0.0, 0.0)
        SetEntityHeading(ped, panelCoords["w"])

        TaskPlayAnim(ped, "anim@heists@ornate_bank@hack", "hack_enter", 3.5, 3.5, 8300, 1, 0, 0, 0, 0)
        Wait(8400)
        TaskPlayAnim(ped, "anim@heists@ornate_bank@hack", "hack_loop", 8.0, 8.0, -1, 1, 0, 0, 0, 0)
        Wait(1000)

        exports["soe-utils"]:LoadModel(`hei_prop_hst_laptop`, 15)
        local laptop = CreateObject(`hei_prop_hst_laptop`, GetOffsetFromEntityInWorldCoords(ped, 0.2, 0.6, 0.0), true, true, false)
        SetEntityRotation(laptop, GetEntityRotation(ped), 2, true)

        PlaceObjectOnGroundProperly(laptop)
        while not DoesEntityExist(laptop) do
            Wait(150)
        end
        Wait(1000)

        exports["soe-challenge"]:StartDataCrack(4.75)
        while (pacificRobbery["hackOutput"] == nil) do
            Wait(150)
        end

        pacificRobbery["isHacking"] = false
        TriggerServerEvent("Utils:Server:DeleteEntity", ObjToNet(laptop))
        StopAnimTask(ped, "anim@heists@ornate_bank@hack", "hack_loop", -2.0)

        if (pacificRobbery["hackOutput"] == true) then
            exports["soe-utils"]:LoadModel(trolleyHash, 15)
            TriggerServerEvent("Crime:Server:InitPacificStandardRobbery", {["status"] = true, ["loc"] = loc, ["pos"] = pos})
            TriggerServerEvent("Crime:Server:RemovePacificItem", {["status"] = true, ["item"] = "usb2"})
            TriggerServerEvent("Crime:Server:RemovePacificItem", {["status"] = true, ["item"] = bankCardNeeded["name"]})

            for _, trolleyPos in pairs(banks["Pacific Standard"]["trolleySpots"]) do
                TriggerServerEvent("Utils:Server:DeletePropAtXYZ", "ch_prop_ch_cash_trolly_01c", vector3(trolleyPos["x"], trolleyPos["y"], trolleyPos["z"]))
                Wait(2500)

                local trolley = CreateObject(trolleyHash, trolleyPos["x"], trolleyPos["y"], trolleyPos["z"], true, true, false)
                SetEntityHeading(trolley, trolleyPos["w"])
                PlaceObjectOnGroundProperly(trolley)
                SetModelAsNoLongerNeeded(trolleyHash)
            end
        else
            exports["soe-ui"]:SendAlert("error", "You failed to hack the panel", 8500)
        end
    end
end

-- WHEN TRIGGERED, LOOT TROLLEY'S CASH PILE
local function LootTrolleys()
    local grab2Clear, grab3Clear = false, false
    local ped = PlayerPedId()

    local trolley = GetClosestObjectOfType(GetEntityCoords(ped), 1.0, trolleyHash, false, false, false)
    if #(GetEntityCoords(ped) - GetEntityCoords(trolley)) > 1.0 then
        exports["soe-ui"]:SendAlert("error", "You cannot do that from that far!", 5000)
        return
    end

    -- CHECK IF ANOTHER PLAYER IS TOO CLOSE
    if (exports["soe-utils"]:GetClosestPlayer(1) ~= nil) then
        exports["soe-ui"]:SendAlert("error", "Someone else is too close to the trolley!", 5000)
        return
    end

    if pacificRobbery["isLooting"] then
        return
    end

    pacificRobbery["isLooting"] = true
    exports["soe-utils"]:LoadModel(cashPileModel, 15)
    local CashAppear = function()
        local pos = GetEntityCoords(ped)
        local grabObj = CreateObject(cashPileModel, pos, true, true, false)

        FreezeEntityPosition(grabObj, true)
        SetEntityInvincible(grabObj, true)

        SetEntityNoCollisionEntity(grabObj, ped)
        SetEntityVisible(grabObj, false, false)
        AttachEntityToEntity(grabObj, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)

        local startedGrabbing = GetGameTimer()
        CreateThread(function()
            while GetGameTimer() - startedGrabbing < 37000 do
                Wait(1)
                DisableControlAction(0, 73, true)
                if HasAnimEventFired(ped, `CASH_APPEAR`) then
                    if not IsEntityVisible(grabObj) then
                        SetEntityVisible(grabObj, true, false)
                    end
                end

                if HasAnimEventFired(ped, `RELEASE_CASH_DESTROY`) then
                    if IsEntityVisible(grabObj) then
                        SetEntityVisible(grabObj, false, false)
                    end
                end
            end
            DeleteObject(grabObj)
        end)
    end

    if IsEntityPlayingAnim(trolley, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 3) then
        return
    end
    exports["soe-utils"]:GetEntityControl(trolley)

    local grab1 = NetworkCreateSynchronisedScene(GetEntityCoords(trolley), GetEntityRotation(trolley), 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, grab1, "anim@heists@ornate_bank@grab_cash", "intro", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkStartSynchronisedScene(grab1)
    Wait(1500)
    CashAppear()

    if not grab2clear then
        local grab2 = NetworkCreateSynchronisedScene(GetEntityCoords(trolley), GetEntityRotation(trolley), 2, false, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, grab2, "anim@heists@ornate_bank@grab_cash", "grab", 1.5, -4.0, 1, 16, 1148846080, 0)

        NetworkAddEntityToSynchronisedScene(trolley, grab2, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 4.0, -8.0, 1)
        NetworkStartSynchronisedScene(grab2)
        Wait(37000)
    end

    if not grab3clear then
        local grab3 = NetworkCreateSynchronisedScene(GetEntityCoords(trolley), GetEntityRotation(trolley), 2, false, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, grab3, "anim@heists@ornate_bank@grab_cash", "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
        NetworkStartSynchronisedScene(grab3)

        exports["soe-utils"]:GetEntityControl(trolley)
        TriggerServerEvent("Utils:Server:DeleteEntity", ObjToNet(trolley))
        TriggerServerEvent("Crime:Server:PacificBankLoot", {["status"] = true})
    end
    pacificRobbery["isLooting"] = false
end

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, LOOT TROLLEY'S CASH PILE
AddEventHandler("Crime:Client:LootCashTrolleys", LootTrolleys)

-- WHEN TRIGGERED, DO THERMAL CHARGE TASKS
AddEventHandler("Inventory:Client:UseThermalCharge", DoThermalChargeTasks)

-- WHEN TRIGGERED, SYNC PACIFIC STANDARD SAFE OPENING/CLOSING
RegisterNetEvent("Crime:Client:SyncPacificSafe", ManageSafe)

-- WHEN TRIGGERED, SYNC THERMAL CHARGE EFFECTS
RegisterNetEvent("Crime:Client:SyncThermalChargeEffects", SyncThermalChargeEffects)

-- WHEN TRIGGERED, RESET THE PACIFIC STANDARD BANK
AddEventHandler("onResourceStop", function(resource)
    if (GetCurrentResourceName() ~= resource) then return end
    ManageSafe(false, true)
end)

-- WHEN TRIGGERED, RETURN DATACRACK CALLBACK FROM MINIGAME
AddEventHandler("Challenge:Client:DatacrackCB", function(hasWon)
    if (pacificRobbery["hackOutput"] == nil) then
        pacificRobbery["hackOutput"] = hasWon or false
    end
end)

-- WHEN TRIGGERED, DO ZONE EXIT TASKS
AddEventHandler("Utils:Client:ExitedZone", function(name)
    if (name == "pacific_standard_door2" or name == "pacific_standard_door3") then
        action = nil
        exports["soe-ui"]:HideTooltip()
    end
end)

-- WHEN TRIGGERED, DO INTERACTION KEYPRESS
AddEventHandler("Utils:Client:InteractionKey", function()
    if IsPedSittingInAnyVehicle(PlayerPedId()) or exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
        return
    end

    if action and action["status"] and (cooldown < GetGameTimer()) then
        cooldown = GetGameTimer() + 2500

        if (action["atDoorPanel"] == 2) then
            AttemptPanelHack(action["atDoorPanel"])
        elseif (action["atDoorPanel"] == 3) then
            if action["canSecure"] and banks["Pacific Standard"]["vaultOpen"] then
                SecureTheVault()
            elseif not banks["Pacific Standard"]["vaultOpen"] then
                AttemptPanelHack(action["atDoorPanel"])
            end
        end
    end
end)

-- WHEN TRIGGERED, DO ZONE ENTRANCE TASKS
AddEventHandler("Utils:Client:EnteredZone", function(name, zoneData)
    if (name == "pacific_standard_door2") then
        action = {["status"] = true, ["atDoorPanel"] = 2}
        exports["soe-ui"]:ShowTooltip("fas fa-piggy-bank", "[E] Attempt to Hack Panel", "inform")
    elseif (name == "pacific_standard_door3") then
        if (exports["soe-jobs"]:GetMyJob() == "POLICE") and banks["Pacific Standard"]["vaultOpen"] then
            action = {["status"] = true, ["atDoorPanel"] = 3, ["panelPos"] = zoneData["pos"], ["canSecure"] = true}
            exports["soe-ui"]:ShowTooltip("fas fa-piggy-bank", "[E] Secure Vault", "inform")
        elseif not banks["Pacific Standard"]["vaultOpen"] then
            action = {["status"] = true, ["atDoorPanel"] = 3, ["panelPos"] = zoneData["pos"], ["canSecure"] = false}
            exports["soe-ui"]:ShowTooltip("fas fa-piggy-bank", "[E] Attempt to Hack Vault Panel", "inform")
        end
    elseif name:match("pacific_standard_sync") then
        if banks["Pacific Standard"]["vaultOpen"] then
            ManageSafe(true, true)
        else
            ManageSafe(false, true)
        end
    end
end)
