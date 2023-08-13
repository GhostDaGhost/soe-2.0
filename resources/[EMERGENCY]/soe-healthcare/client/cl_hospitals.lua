local action = nil
local isCheckingIn = false

checkedIn, checkedInBed = false, nil

-- HOSPITAL CHECK-IN TASKS
local function HospitalCheckIn(bed)
    local ped = PlayerPedId()
    checkedIn = true

    checkedInBed = bed
    exports["soe-fidelis"]:AuthorizeTeleport()
    SetEntityCoords(ped, bed.pos)
    Wait(200)
    ExecuteCommand("bed")
end

-- MAIN CHECK-IN FUNCTION
local function CheckIn()
    -- MAKE SURE WE AREN'T ALREADY CHECKING IN
    if isCheckingIn then return end
    isCheckingIn = true

    exports["soe-emotes"]:StartEmote("notepad")
    exports["soe-utils"]:Progress(
        {
            name = "checkingIn",
            duration = 5000,
            label = "Checking In",
            useWhileDead = true,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = false
            }
        },
        function(cancelled)
            isCheckingIn = false
            exports["soe-emotes"]:CancelEmote()
            if not cancelled then
                if not action then
                    exports["soe-ui"]:SendAlert("error", "You went too far!")
                    return
                end
                TriggerServerEvent("Healthcare:Server:CheckIn", action.hospital)
            end
        end
    )
end

-- CALLED FROM SERVER AFTER HOSPITAL CHECK-IN IS DONE
RegisterNetEvent("Healthcare:Client:CheckIn")
AddEventHandler("Healthcare:Client:CheckIn", HospitalCheckIn)

AddEventHandler("Utils:Client:EnteredZone", function(name, zoneData)
    if name:match("hospital_checkin") then
        action = {status = true, hospital = zoneData.hospital}
        exports["soe-ui"]:ShowTooltip("fas fa-syringe", "[E] Check In", "inform")
    elseif name:match("hospital_pc") then
        if (exports["soe-uchuu"]:GetPlayer().CivType == "EMS") then
            action = {status = true}
            exports["soe-ui"]:ShowTooltip("fas fa-laptop-medical", "[E] Check Logs", "inform")
        end
    end
end)

AddEventHandler("Utils:Client:ExitedZone", function(name)
    if name:match("hospital_checkin") or name:match("hospital_pc") then
        action = nil
        exports["soe-ui"]:HideTooltip()
    end
end)

-- INTERACTION KEYPRESS TO CHECK-IN TO HOSPITAL
AddEventHandler("Utils:Client:InteractionKey", function()
    if not action then return end
    if action.status and not IsPedSittingInAnyVehicle(PlayerPedId()) then
        if (action.hospital ~= nil) then
            CheckIn()
        else
            if (exports["soe-uchuu"]:GetPlayer().CivType == "EMS") then
                OpenLogUI()
            end
        end
    end
end)
