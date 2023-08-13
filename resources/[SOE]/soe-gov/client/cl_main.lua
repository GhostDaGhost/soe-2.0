local action
local cooldown = 0

-- ***********************
--     Local Functions
-- ***********************
-- WHEN TRIGGERED, ISSUE PLAYER A NEW STATE LICENSE
local function IssueNewStateLicense()
    if (cooldown > GetGameTimer()) then
        exports["soe-ui"]:SendAlert("error", "Wait a bit before doing that again", 5000)
        return
    end

    exports["soe-utils"]:GetMugshotURL(PlayerPedId(), function(imageURL)
        -- UPLOAD ERROR HANDLER
        if imageURL == nil then
            exports["soe-ui"]:SendAlert("error", "We had troubles taking your photo. Please try again!", 5000)
            return
        end

        cooldown = GetGameTimer() + 2500
        exports["soe-nexus"]:TriggerServerCallback("Gov:Server:IssueNewStateLicense", GetGameTimer(), imageURL)
    end)
end

-- ***********************
--        Commands
-- ***********************
-- WHEN TRIGGERED, REQUEST FOR AN ACTIVE LAWYER
RegisterCommand("requestlawyer", function()
    if (exports["soe-jobs"]:GetMyJob() == "POLICE") then
        local pos = GetEntityCoords(PlayerPedId())
        TriggerServerEvent("Gov:Server:RequestForLawyer", {status = true, loc = exports["soe-utils"]:GetLocation(pos)})
    else
        TriggerEvent("Chat:Client:SendMessage", "system", "This command is only available for LEO.")
    end
end)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, ISSUE PLAYER A NEW STATE LICENSE
RegisterNetEvent("Gov:Client:IssueNewStateLicense")
AddEventHandler("Gov:Client:IssueNewStateLicense", IssueNewStateLicense)

-- WHEN TRIGGERED, RESET ZONE DATA
AddEventHandler("Utils:Client:ExitedZone", function(name)
    if not name:match("reissuelicense") then return end
    action = nil

    exports["soe-ui"]:HideTooltip()
end)

-- WHEN TRIGGERED, GRAB ZONE WE ARE IN
AddEventHandler("Utils:Client:EnteredZone", function(name)
    if not name:match("reissuelicense") then return end
    action = {status = true}

    exports["soe-ui"]:ShowTooltip("far fa-address-card", "[E] Re-Issue State ID", "inform")
end)

-- WHEN TRIGGERED, DO INTERACTION KEYPRESS TASKS
AddEventHandler("Utils:Client:InteractionKey", function()
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
        return
    end

    if action and action.status then
        IssueNewStateLicense()
    end
end)

AddEventHandler("onClientResourceStart", function(resource)
    if (GetCurrentResourceName() ~= resource) then return end
    Wait(3500)

    for zoneID, zone in pairs(zones) do
        exports["soe-utils"]:AddBoxZone(zone["name"], zone["pos"], zone["measurements"]["length"], zone["measurements"]["width"], zone["options"])
        exports["soe-utils"]:AddMarker("GovPoint-" .. zoneID, {21, zone.options.data.marker.x, zone.options.data.marker.y, zone.options.data.marker.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 186, 22, 0, 175, 0, 1, 2, 0, 0, 0, 0, 17.5})
    end
end)
