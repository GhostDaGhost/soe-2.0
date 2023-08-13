-- CREATES ZONES FOR SHOP POINTS
function CreateZones()
    -- DMVs
    for zoneID, zone in ipairs(dmvs) do
        exports["soe-utils"]:AddBoxZone(zone.name, zone.pos, zone.length, zone.width, zone.options)
        exports["soe-utils"]:AddMarker("DMV-" .. zoneID, {21, zone.options.data.marker.x, zone.options.data.marker.y, zone.options.data.marker.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 4, 139, 217, 155, 0, 1, 2, 0, 0, 0, 0, 18.0})
    end

    -- SCRAPYARDS
    for zoneID, zone in ipairs(scrapyards) do
        exports["soe-utils"]:AddBoxZone(zone.name, zone.pos, zone.length, zone.width, zone.options)
        exports["soe-utils"]:AddMarker("Scrapyard-" .. zoneID, {27, zone.options.data.marker.x, zone.options.data.marker.y, zone.options.data.marker.z - 0.92, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 2.0, 128, 68, 22, 155, 0, 0, 2, 0, 0, 0, 0, 35.5})
    end
end
