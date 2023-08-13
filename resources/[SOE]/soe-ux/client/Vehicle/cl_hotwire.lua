local hotwiring = false

-- **********************
--    Local Functions
-- **********************
-- MAIN FUNCTION THAT RUNS HOTWIRING PROCESS/MINIGAME
local function DoHotwire()
    -- ENGINE RUNNING CHECK
    if GetIsVehicleEngineRunning(myVeh) then
        exports["soe-ui"]:SendAlert("error", "Engine is already running!", 5000)
        return
    end

    -- DRIVER SEAT CHECK
    local ped = PlayerPedId()
    if (GetPedInVehicleSeat(myVeh, -1) ~= ped) then
        exports["soe-ui"]:SendAlert("error", "You need to be the driver!", 5000)
        return
    end

    -- RESTRAINT CHECK
    if exports["soe-emergency"]:IsRestrained() then
        exports["soe-ui"]:SendAlert("error", "You are restrained!", 5000)
        return
    end

    -- REQUEST SERVER FOR DATA TO SYNC REQUIRED ITEMS
    local class, plate = GetVehicleClass(myVeh), GetVehicleNumberPlateText(myVeh)
    local hotwireData = exports["soe-nexus"]:TriggerServerCallback("UX:Server:GetHotwireData", class, plate)
    if (DecorGetInt(myVeh, "vin") == 0) then
        if (math.random(1, 10000) <= hotwireData.chanceOfKeys) then
            exports["soe-valet"]:UpdateKeys(myVeh)
            exports["soe-ui"]:SendAlert("warning", "You find the keys in the ignition!", 5000)
            return
        end
    end

    local canHotwire, usedMultitool, success = false, false, false
    -- FIRST, LETS CHECK IF THIS PLAYER HAS A MULTITOOL
    if exports["soe-inventory"]:HasInventoryItem("multitool") then
        canHotwire, usedMultitool, success = true, true, true
        exports["soe-ui"]:SendAlert("success", "You use your multitool to hotwire this vehicle!", 5000)
    end

    -- NO MULTITOOL? NO PROBLEM. LETS LOOK FOR TOOLS
    if not canHotwire then
        if exports["soe-inventory"]:HasInventoryItem(hotwireData.requiredToolName) then
            canHotwire = true
            exports["soe-ui"]:SendAlert("warning", "You used a " .. hotwireData.requiredToolLabel, 5000)
        else
            exports["soe-ui"]:SendAlert("error", "You do not have a " .. hotwireData.requiredToolLabel, 5000)
        end
    end

    if canHotwire then
        hotwiring = true
        exports["soe-utils"]:LoadAnimDict("veh@handler@base", 15)
        TaskPlayAnim(ped, "veh@handler@base", "hotwire", 2.0, 2.0, -1, 49, 0, 0, 0, 0)

        -- SKILLBAR MINIGAME
        if not usedMultitool then
            local difficulty, time, thickness = hotwireData.difficulty, 5000, 10
            if (difficulty == 3) then
                time, thickness = 5000, 10
            elseif (difficulty == 2) then
                time, thickness = 3000, 5
            elseif (difficulty == 1) then
                time, thickness = 1500, 4
            end

            if exports["soe-challenge"]:Skillbar(time, thickness) then
                Wait(200)
                if exports["soe-challenge"]:Skillbar(time, thickness) then
                    Wait(200)
                    if exports["soe-challenge"]:Skillbar(time, thickness) then
                        success = true
                        TriggerServerEvent("UX:Server:Hotwire", {item = hotwireData.requiredToolName})
                    end
                end
            end
        else
            TriggerServerEvent("UX:Server:Hotwire", {item = "multitool"})
        end

        hotwiring = false
        if success then
            engine = true
            SetVehicleEngineOn(myVeh, true, false, true)
            Wait(500)

            -- IF VEHICLE ENGINE HP IS LOW, SHUT IT OFF AGAIN
            if (GetVehicleEngineHealth(myVeh) < 150) then
                SetVehicleEngineOn(myVeh, false, true, true)
            end
        end
        ClearPedTasks(ped)
    end
end

-- **********************
--    Global Functions
-- **********************
-- RETURNS IF PLAYER IS HOTWIRING
function IsHotwiring()
    return hotwiring
end

-- **********************
--        Events
-- **********************
-- CALLED FROM SERVER WHEN "/hotwire" IS EXECUTED
RegisterNetEvent("UX:Client:Hotwire")
AddEventHandler("UX:Client:Hotwire", DoHotwire)
