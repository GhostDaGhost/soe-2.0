local usedLicensePlates = {[""] = true}

-- **********************
--    Global Functions
-- **********************
-- RETURNS PLAYER'S IDENTIFIERS
function GetIdentifiersFromSource(source)
    local playerIdentifiers = {}
    for _, identifier in pairs(GetPlayerIdentifiers(source)) do
        local type = string.sub(identifier, 1, string.find(identifier, ":") - 1)
        local value = string.sub(identifier, string.find(identifier, ":") + 1)
        playerIdentifiers[type] = value
    end
    return playerIdentifiers
end
exports("GetIdentifiersFromSource", GetIdentifiersFromSource)

-- **********************
--       Commands
-- **********************
RegisterCommand("xyz", function(source)
    local src = source
    TriggerClientEvent("Utils:Client:ToggleXYZ", src)
end)

RegisterCommand("copyxyz", function(source, args)
    local src = source
    if (args[1] ~= nil) then
        TriggerClientEvent("Utils:Client:SaveXYZToClipboard", src, GetEntityCoords(GetPlayerPed(src)), GetEntityHeading(GetPlayerPed(src)))
    else
        TriggerClientEvent("Utils:Client:SaveXYZToClipboard", src, GetEntityCoords(GetPlayerPed(src)))
    end
end)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, CHECK IF A PLATE IS ALREADY IN USE
AddEventHandler("Utils:Server:IsPlateUsed", function(cb, src, plate)
    local result = (usedLicensePlates[plate] ~= nil)
    cb(result)
end)

-- WHEN TRIGGERED, RESERVE LICENSE PLATE TO PREVENT IT FROM BEING USED AGAIN
AddEventHandler("Utils:Server:ReservePlate", function(cb, src, plate)
    if (plate ~= nil and plate ~= "") then
        usedLicensePlates[plate] = true
    end
    cb(true)
end)
