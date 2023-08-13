local zones = {}
local insideZone = false

CreateThread(function()
    Wait(3500)
    while true do
        Wait(500)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        for zoneID, zoneData in pairs(zones) do
            if zones[zoneID]:isPointInside(pos) then
                insideZone = true

                TriggerEvent("Utils:Client:EnteredZone", zoneID, zoneData.data)
                while insideZone do
                    local inZonePos = GetEntityCoords(ped)
                    if not zones[zoneID]:isPointInside(inZonePos) then 
                        insideZone = false
                    end
                    Wait(250)
                end
                TriggerEvent("Utils:Client:ExitedZone", zoneID)
            end
        end
    end
end)

function AddCircleZone(name, center, radius, options)
    --if (zones[name] ~= nil) then return end
    zones[name] = CircleZone:Create(center, radius, options)
end
exports("AddCircleZone", AddCircleZone)

function AddBoxZone(name, center, length, width, options)
    --if (zones[name] ~= nil) then return end
    zones[name] = BoxZone:Create(center, length, width, options)
end
exports("AddBoxZone", AddBoxZone)

function AddPolyzone(name, points, options)
    --if (zones[name] ~= nil) then return end
    zones[name] = PolyZone:Create(points, options)
end
exports("AddPolyzone", AddPolyzone)
