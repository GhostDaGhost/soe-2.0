local sleep = 550
local loopIndex = 0
local nearbyMarkers = {}

-- REMOVES MARKER FROM THE TABLE
function RemoveMarker(name)
    table.remove(markers, name)
end
exports("RemoveMarker", RemoveMarker)

-- ADDS MARKER TO THE TABLE FOR THE LOOP TO USE
function AddMarker(name, markerProperties)
    markers[name] = markerProperties
end
exports("AddMarker", AddMarker)

-- LOOP FOR MARKER MANAGEMENT
CreateThread(function()
    Wait(3500)
    while true do
        Wait(sleep)
        loopIndex = loopIndex + 1
        if (loopIndex % 10 == 0) then
            nearbyMarkers = {}
            local pos = GetEntityCoords(PlayerPedId())
            for _, marker in pairs(markers) do
                local range = 7.2
                if marker[25] then
                    range = marker[25]
                end

                local markerPos = vector3(marker[2], marker[3], marker[4])
                if #(pos - markerPos) <= range then
                    table.insert(nearbyMarkers, marker)
                end
            end
            loopIndex = 0
        end

        if #nearbyMarkers >= 1 then
            sleep = 5
            for _, marker in pairs(nearbyMarkers) do
                DrawMarker(table.unpack(marker))
            end
        else
            sleep = 550
        end
    end
end)
