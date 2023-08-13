-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, OPEN HELP UI
local function OpenGuide()
    SetNuiFocus(true, true)
    SendNUIMessage({type = "Help.Open"})
end

-- **********************
--     NUI Callbacks
-- **********************
-- WHEN TRIGGERED, SHUT NUI FOCUS OFF
RegisterNUICallback("Help.CloseUI", function()
    SetNuiFocus(false, false)
end)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, OPEN HELP UI
RegisterNetEvent("Help:Client:OpenGuide", OpenGuide)

-- WHEN TRIGGERED, RESET ALL NUI INSTANCES
AddEventHandler("UI:Client:ResetNUI", function()
    SendNUIMessage({type = "Help.ResetUI"})
end)
