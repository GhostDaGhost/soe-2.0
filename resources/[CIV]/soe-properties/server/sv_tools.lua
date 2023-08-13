-- REORGANIZE DATA FROM PROPERTY TABLE ROW TO BE READ BY GAME
function OrganizePropertyData(dbRow)
    dbRow.Coords = json.decode(dbRow.Coords)
    if dbRow.Interior == "" then
        dbRow.Interior = nil
    end

    if dbRow.Shell == "" then
        dbRow.Shell = nil
    end

    local property = {
        ["id"] = dbRow.PropertyID,
        ["address"] = dbRow.Address,
        ["price"] = dbRow.Value,
        ["shell"] = dbRow.Shell or nil,
        ["interior"] = dbRow.Interior or nil,
        ["entrance"] = {
            x = tonumber(dbRow.Coords.entX),
            y = tonumber(dbRow.Coords.entY),
            z = tonumber(dbRow.Coords.entZ),
            h = tonumber(dbRow.Coords.entH)
        },
        ["garage"] = {
            x = tonumber(dbRow.Coords.garageX),
            y = tonumber(dbRow.Coords.garageY),
            z = tonumber(dbRow.Coords.garageZ),
            h = tonumber(dbRow.Coords.garageH),
            capacity = dbRow.GarageSize
        }
    }
    return property
end

-- GET IF PROPERTY IS OWNED OR NOT
function IsPropertyOwned(propertyID)
    local dataString = string.format("propertyid=%s", propertyID)
    local propertyOwned = exports["soe-nexus"]:PerformAPIRequest("/api/properties/getaccessdata", dataString, true)

    if propertyOwned.status then
        return #propertyOwned.data >= 1
    end
    return true
end

-- GET PLAYERS ACCESS INFO FOR PROPERTY
function GetPlayerPropertyAccess(charID, propertyID)
    local dataString = string.format("charid=%s&propertyid=%s", charID, propertyID)
    local propertyAccess = exports["soe-nexus"]:PerformAPIRequest("/api/properties/getaccessdata", dataString, true)

    if propertyAccess.status then
        if not IsPropertyOwned(propertyID) then
            return "UNOWNED"
        elseif #propertyAccess.data >= 1 then
            return string.upper(propertyAccess.data)
        end
    end
end

-- SET PROPERTY ACCESS FOR PLAYER
function SetPlayerPropertyAccess(charID, propertyID, access)
    if access == "OWNER" or access == "TENANT" or access == "GUEST" or access == "NONE" then
        local dataString = string.format("charid=%s&propertyid=%s&access=%s", charID, propertyID, access)
        local newAccess = exports["soe-nexus"]:PerformAPIRequest("/api/properties/modifyaccessdata", dataString, true)

        if newAccess.status then
            return newAccess.status
        end
    else
        return false
    end
end