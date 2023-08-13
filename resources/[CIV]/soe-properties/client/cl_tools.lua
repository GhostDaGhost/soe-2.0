function GetCurrentProperty()
    if currentHouse ~= nil then
        return GetPropertyByID(currentHouse)
    else
        return nil
    end
end

-- GET CLOSEST PROPERTY ENTRANCE
function GetClosestProperty()
    local pos = GetEntityCoords(PlayerPedId())
    local closest = false
    local closestDistance = 99

    for _, data in pairs(propertyList) do
        local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, data.entrance.x, data.entrance.y, data.entrance.z, true)

        -- Minimum distance of 2
        if distance <= 2.0 and distance < closestDistance then
            closest = data
            closestDistance = distance
        end
    end

    return closest, closestDistance
end

-- GET CLOSEST PROPERTY EXIT
function GetClosestExit()
    local pos = GetEntityCoords(PlayerPedId())
    -- Iterate through housing interiors from shared/sh_housingData
    for _, data in pairs(housingInteriors) do
        local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, data.ENTRANCE.x, data.ENTRANCE.y, data.ENTRANCE.z, true)

        -- Only check if less than 2, shouldn't be that close to two at the same time
        if distance <= 2.0 then
            return data, distance
        end
    end
    return false
end

-- TOGGLE HOUSING BLIPS - NOT WORKING YET?
function ToggleHousingBlips(unownedList, toggle)
    if #housingBlips > 0 then
        for _,blip in pairs(housingBlips) do
            RemoveBlip(blip)
        end
        exports["soe-ui"]:SendAlert('error', "Housing blips removed")
        housingBlips = {}
    elseif toggle == nil then
        toggle = true
    end

    if toggle then
        for _,data in pairs(unownedList) do
            local blip = AddBlipForCoord(data.entrance.x, data.entrance.y, data.entrance.z)
            SetBlipScale(blip, 0.8)
            SetBlipSprite(blip, 350)
            SetBlipColour(blip, 69)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Property For Sale")
            EndTextCommandSetBlipName(blip)

            table.insert(housingBlips, blip)
        end
        exports["soe-ui"]:SendAlert('inform', "Housing blips created")
    end
end

-- GET ENTRANCE OFFSET FROM COORDS
function GetOffsetFromCoords(x1, y1, z1, x2, y2, z2)
    local xDiff = x2 - x1
    local yDiff = y2 - y1
    local zDiff = z2 - z1
    return {x=xDiff, y=yDiff, z=zDiff}
end

-- GET ENTRANCE OFFSET FROM PROPERTY ID
function GetOffsetFromPropertyID(propertyId, x, y, z)
    local property = GetPropertyByID(propertyId)
    local newZ = property.entrance.z + shellVerticalOffset
    return GetOffsetFromCoords(property.entrance.x, property.entrance.y, newZ, x, y, z)
end

-- GET COORDS OF HOUSE FROM OFFSET
function GetCoordsFromOffset(x, y, z, xOffset, yOffset, zOffset)
    return {x = x + xOffset, y = y + yOffset, z = z + zOffset}
end

-- GET COORDS OF HOUSE FROM PROPERTY OFFSET
function GetCoordsFromPropertyOffset(propertyId, xOffset, yOffset, zOffset)
    local property = GetPropertyByID(propertyId)
    local newZ = property.entrance.z + shellVerticalOffset
    return GetCoordsFromOffset(property.entrance.x, property.entrance.y, newZ, xOffset, yOffset, zOffset)
end

-- TELEPORT INTO AN INTERIOR
function PropertyTeleport(x, y, z, h)
    DoScreenFadeOut(500)
    Wait(500)
    FreezeEntityPosition(PlayerPedId(), true)
    exports["soe-fidelis"]:AuthorizeTeleport()
    SetEntityCoords(PlayerPedId(), x, y, z)

    if h ~= nil then
        SetEntityHeading(PlayerPedId(), h)
    end

    RequestCollisionAtCoord(x, y, z)
    while not HasCollisionLoadedAroundEntity(PlayerPedId()) do 
        Wait(5) 
    end

    FreezeEntityPosition(PlayerPedId(), false)
    DoScreenFadeIn(500)
    Wait(500)
end
