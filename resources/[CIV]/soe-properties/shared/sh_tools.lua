function GetPropertyByID(propertyID)
    for _, propertyData in pairs(propertyList) do
        if propertyData.id == propertyID then
            return propertyData
        end
    end
end

function GetPropertyByAddress(address)
    for _, propertyData in pairs(propertyList) do
        if string.upper(propertyData.address) == string.upper(address) then
            return propertyData
        end
    end
end

function GetPropertyInteriorFromID(propertyId)
    local property = GetPropertyByID(propertyId)
    if property ~= nil then
        return housingInteriors[property.interior]
    end
end

function GetPropertyInteriorFromAddress(address)
    local property =   GetPropertyByAddress(address)
    if property ~= nil then
        return housingInteriors[property.interior]
    end
end

function GetProperty(propertyID)
    return GetPropertyByID(propertyID)
end

function GetProperties()
    return propertyList
end