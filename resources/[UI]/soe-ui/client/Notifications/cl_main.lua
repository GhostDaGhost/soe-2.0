-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, OPEN NOTIFICATION LOG
local function OpenLog()
    SetNuiFocus(true, true)
    SendNUIMessage({action = "Notif.OpenLog"})
end

-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, HIDE INTERACTION TOOLTIP
function HideTooltip()
    SendNUIMessage({type = "Notif.HideTooltip"})
end
exports("HideTooltip", HideTooltip)

-- WHEN TRIGGERED, HIDES ONSCREEN TEXT
function HideOnscreenText()
    SendNUIMessage({type = "Notif.RemoveOnscreenText"})
end
exports("HideOnscreenText", HideOnscreenText)

-- WHEN TRIGGERED, SHOWS ONSCREEN TEXT // REPLACEMENT FOR DRAWTEXT NATIVE
function DisplayText(text)
    SendNUIMessage({type = "Notif.DisplayOnscreenText", text = text})
end
exports("DisplayText", DisplayText)

-- WHEN TRIGGERED, CREATE A INTERACTION TOOLTIP
function ShowTooltip(icon, text, color)
    SendNUIMessage({type = "Notif.ShowTooltip", icon = icon, text = text, color = color})
end
exports("ShowTooltip", ShowTooltip)

-- WHEN TRIGGERED, CREATE A NORMAL ALERT
function SendAlert(type, text, length, style)
    SendNUIMessage({action = "Notif.Create", type = type, text = text, length = length, style = style})
end
exports("SendAlert", SendAlert)

-- WHEN TRIGGERED, CREATE A UNIQUE ALERT
function SendUniqueAlert(id, type, text, length, style)
    SendNUIMessage({action = "Notif.Create", id = id, type = type, text = text, style = style})
end
exports("SendUniqueAlert", SendUniqueAlert)

-- WHEN TRIGGERED, CREATE A PERSISTENT ALERT
function PersistentAlert(action, id, type, text, style)
    if (action:upper() == "START") then
        SendNUIMessage({action = "Notif.Create", persist = action, id = id, type = type, text = text, style = style})
    elseif (action:upper() == "END") then
        SendNUIMessage({action = "Notif.Create", persist = action, id = id})
    end
end
exports("PersistentAlert", PersistentAlert)

-- **********************
--     NUI Callbacks
-- **********************
-- WHEN TRIGGERED, CLOSE NOTIFICATION LOG
RegisterNUICallback("Notif.CloseLog", function()
    SetNuiFocus(false, false)
end)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, OPEN NOTIFICATION LOG
RegisterNetEvent("Notify:Client:OpenLog", OpenLog)

-- WHEN TRIGGERED, CREATE A NORMAL ALERT
RegisterNetEvent("Notify:Client:SendAlert", function(data)
    SendAlert(data.type, data.text, data.length, data.style)
end)

-- WHEN TRIGGERED, CREATE A UNIQUE ALERT
RegisterNetEvent("Notify:Client:UniqueAlert", function(data)
    SendUniqueAlert(data.id, data.type, data.text, data.length, data.style)
end)

-- WHEN TRIGGERED, CREATE A PERSISTENT ALERT
RegisterNetEvent("Notify:Client:PersistentAlert", function(data)
    PersistentAlert(data.action, data.id, data.type, data.text, data.style)
end)
