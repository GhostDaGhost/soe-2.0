local pickingMachine = false

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, CHECK IF ATM CAN BE ROBBED
local function CanMachineBeRobbed(machineCoords)
    local checkMachineStatus = exports["soe-nexus"]:TriggerServerCallback("Crime:Server:CheckMachineStatus", machineCoords)
    if checkMachineStatus["robbable"] then
        return true
    end
    return false, checkMachineStatus["msg"]
end

-- WHEN TRIGGERED, ROB ATM BUT FIRST CHECK VALIDALITY
local function DoMachineRobbery()
    -- PERFORM A SAFE GUARD OF DISTANCE
    local targetMachine = exports["soe-utils"]:GetEntityPlayerIsLookingAt(3.0, 0.2, 286, PlayerPedId())
    if (targetMachine == 0) then
        exports["soe-ui"]:SendAlert("error", "You are not near an machine!", 5000)
        return
    end

    -- CHECK IF ATM CAN BE ROBBED
    local machineCoords = GetEntityCoords(targetMachine)
    if #(GetEntityCoords(PlayerPedId()) - machineCoords) > 1.5 then
        exports["soe-ui"]:SendAlert("error", "You are too far from the machine!", 5000)
        return
    end

    local canRob, errorMsg = CanMachineBeRobbed(machineCoords)
    if not canRob then
        exports["soe-ui"]:SendAlert("error", errorMsg or "This machine cannot be robbed right now.", 5000)
        return
    end

    -- CHECK IF PLAYER HAS LOCKPICK
    if not exports["soe-inventory"]:HasInventoryItem("lockpick") then
        exports["soe-ui"]:SendAlert("error", "You need a lockpick!", 5000)
        return
    end

    -- EXPLOIT CHECK
    if pickingMachine then
        exports["soe-ui"]:SendAlert("error", "You are already doing this!", 5000)
        return
    end

    -- CHECK IF THERE'S A NEARBY PLAYER TO STOP DOUBLE-OPENING
    if exports["soe-utils"]:GetClosestPlayer(3) then
        exports["soe-ui"]:SendAlert("error", "Someone is too close to you!", 5000)
        return
    end

    exports["soe-ui"]:HideTooltip()
    TaskTurnPedToFaceEntity(PlayerPedId(), targetMachine, -1)

    math.randomseed(GetGameTimer())
    if (math.random(1, 100) <= 63) then
        local loc = exports["soe-utils"]:GetLocation(machineCoords)
        local desc = ("A caller is reporting a subject tampering with a vending machine in the area of %s."):format(loc)
        TriggerServerEvent("Emergency:Server:CADAlerts", {
            ["status"] = true, ["global"] = true, ["code"] = "10-31", ["desc"] = desc, ["type"] = "Machine Tampering", ["loc"] = loc, ["coords"] = machineCoords
        })
    end

    pickingMachine = true
    if exports["soe-challenge"]:StartLockpicking(true) then
        exports["soe-nexus"]:TriggerServerCallback("Crime:Server:SetMachineStatus", machineCoords)
        exports["soe-nexus"]:TriggerServerCallback("Crime:Server:MachineRobberyLoot", GetEntityModel(targetMachine))
    end
    pickingMachine = false
end

-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, RETURN IF PLAYER IS DRILLING VENDING MACHINE
function IsPickingMachine()
    return pickingMachine
end
exports("IsPickingMachine", IsPickingMachine)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, ROB MACHINE BUT FIRST CHECK VALIDALITY
AddEventHandler("Crime:Client:DoMachineRobbery", DoMachineRobbery)
