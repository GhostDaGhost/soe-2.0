-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, OPEN GUIDE UI
local function ShowUI()
    SendNUIMessage({type = "Guide.Open"})
    SetNuiFocus(true, true)
end

-- **********************
--     NUI Callbacks
-- **********************
-- WHEN TRIGGERED, SHUT NUI FOCUS OFF
RegisterNUICallback("Guide.Close", function()
    SetNuiFocus(false, false)
end)

-- **********************
--        Events
-- **********************
-- CALLED FROM SERVER AFTER "/guide" IS EXECUTED
RegisterNetEvent("Guide:Client:ShowUI", ShowUI)

-- WHEN TRIGGERED, RESET ALL NUI INSTANCES
AddEventHandler("UI:Client:ResetNUI", function()
    SendNUIMessage({type = "Guide.ResetUI"})
end)
