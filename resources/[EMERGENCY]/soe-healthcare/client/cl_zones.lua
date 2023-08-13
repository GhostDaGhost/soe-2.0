-- CREATE OUR ZONES
function CreateZones()
    for zoneID, zone in ipairs(zones) do
        exports["soe-utils"]:AddBoxZone(zone.name, zone.pos, zone.length, zone.width, zone.options)
    end
end
