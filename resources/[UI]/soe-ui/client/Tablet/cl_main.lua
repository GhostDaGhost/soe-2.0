-- KEY MAPPINGS
RegisterKeyMapping("tablet", "[UI] Use Tablet", "KEYBOARD", "")

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, SHOW TABLET IF PLAYER HAS ONE
local function OpenTablet()
    if not exports["soe-inventory"]:HasInventoryItem("tablet") then
        SendAlert("error", "You do not have a tablet!", 5000)
        return
    end

    SetNuiFocus(true, true)
    SendNUIMessage({type = "Tablet.ShowUI"})
    exports["soe-emotes"]:StartEmote("tablet2")
end

-- **********************
--        Commands
-- **********************
-- WHEN TRIGGERED, SHOW TABLET IF PLAYER HAS ONE
RegisterCommand("tablet", OpenTablet)

-- **********************
--     NUI Callbacks
-- **********************
-- WHEN TRIGGERED, CLOSE TABLET UI
RegisterNUICallback("Tablet.CloseUI", function()
    SetNuiFocus(false, false)

    StopAnimTask(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a", 2.5)
    exports["soe-emotes"]:EliminateAllProps()
end)
