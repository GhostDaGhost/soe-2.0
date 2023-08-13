-- CREATES ZONES FOR JOB POINTS
function CreateZones()
    -- PIZZA DELIVERY JOB
    for zoneID, zone in ipairs(pizzerias) do
        exports["soe-utils"]:AddBoxZone(zone.name, zone.pos, zone.length, zone.width, zone.options)
        exports["soe-utils"]:AddMarker("Pizza-" .. zoneID, {21, zone.options.data.marker.x, zone.options.data.marker.y, zone.options.data.marker.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 224, 142, 0, 155, 0, 1, 2, 0, 0, 0, 0, 18.0})
    end

    -- NEWS REPORTING JOB
    for zoneID, zone in ipairs(newsStations) do
        exports["soe-utils"]:AddBoxZone(zone.name, zone.pos, zone.length, zone.width, zone.options)
        exports["soe-utils"]:AddMarker("News-" .. zoneID, {21, zone.options.data.marker.x, zone.options.data.marker.y, zone.options.data.marker.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 186, 22, 0, 175, 0, 1, 2, 0, 0, 0, 0, 18.0})
    end

    -- TOWING JOB
    for zoneID, zone in ipairs(towingLocations) do
        exports["soe-utils"]:AddBoxZone(zone.name, zone.pos, zone.length, zone.width, zone.options)
        exports["soe-utils"]:AddMarker("Towing-" .. zoneID, {21, zone.options.data.marker.x, zone.options.data.marker.y, zone.options.data.marker.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 117, 42, 32, 195, 0, 1, 2, 0, 0, 0, 0, 18.0})
    end

    for spotID, spot in pairs(towingDropoffs) do
        exports["soe-utils"]:AddMarker("ImpoundMarker-" .. spotID, {27, spot.x, spot.y, spot.z, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 2.0, 13, 232, 255, 155, 0, 0, 2, 0, 0, 0, 0, 55.5})
    end

    -- HOTDOG SELLING JOB
    for zoneID, zone in ipairs(hotdogShops) do
        exports["soe-utils"]:AddBoxZone(zone.name, zone.pos, zone.length, zone.width, zone.options)
        exports["soe-utils"]:AddMarker("Hotdog-" .. zoneID, {21, zone.options.data.marker.x, zone.options.data.marker.y, zone.options.data.marker.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 252, 98, 3, 195, 0, 1, 2, 0, 0, 0, 0, 18.0})
    end

    -- TREE PICKING
    exports["soe-utils"]:AddBoxZone("paleto_farm", vector3(306.65, 6492.71, 29.36), 275.0, 275.2, {
        name = "paleto_farm", heading = 0, minZ = 26.64, maxZ = 33.04
    })
end
