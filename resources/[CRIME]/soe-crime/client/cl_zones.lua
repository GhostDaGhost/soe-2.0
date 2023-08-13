-- CREATES ZONES FOR LOCATIONS
function CreateZones()
    -- MONEY LAUNDERING
    for zoneID, zone in pairs(moneyLaunderers) do
        exports["soe-utils"]:AddBoxZone(zone["name"], zone["pos"], zone["length"], zone["width"], zone["options"])
        exports["soe-utils"]:AddMarker("Launderer-" .. zoneID, {21, zone["options"].data.marker.x, zone["options"].data.marker.y, zone["options"].data.marker.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 110, 0, 0, 195, 0, 1, 2, 0, 0, 0, 0, 18.0})
    end

    -- BANK VAULTS
    for zoneID, zone in pairs(bankVaults) do
        exports["soe-utils"]:AddBoxZone(zone["name"], zone["pos"], zone["length"], zone["width"], zone["options"])
        exports["soe-utils"]:AddMarker("BankVault-" .. zoneID, {32, zone["options"].data.marker.x, zone["options"].data.marker.y, zone["options"].data.marker.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.17, 0.17, 0.17, 110, 0, 0, 133, 0, 1, 2, 0, 0, 0, 0, 16.0})
    end

    -- BANK VAULT AREAS
    for zoneID, zone in pairs(bankVaultZones) do
        exports["soe-utils"]:AddBoxZone(zone["name"], zone["pos"], zone["length"], zone["width"], zone["options"])
    end

    -- HITMAN JOB POINTS
    for zoneID, zone in pairs(hitmanZones) do
        exports["soe-utils"]:AddBoxZone(zone["name"], zone["pos"], zone["length"], zone["width"], zone["options"])
    end

    -- DRUG RUN STARTING LOCATIONS
    for pointID, point in pairs(drugrunStartingPoints) do
        exports["soe-utils"]:AddMarker("Drugrun-" .. pointID, {27, point["pos"].x, point["pos"].y, point["pos"].z - 0.92, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 2.0, 201, 47, 0, 155, 0, 0, 2, 0, 0, 0, 0, 25.5})
    end

    -- GANG SUPPLIER LOCATIONS
    for zoneID, zone in pairs(supplyLocations["Zones"]) do
        exports["soe-utils"]:AddBoxZone(zone["name"], zone["pos"], zone["length"], zone["width"], zone["options"])
    end
end
