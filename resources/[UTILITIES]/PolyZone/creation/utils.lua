function handleArrowInput(center, heading)
    delta = 0.05
    DisableControlAction(0, 36, true)
    if IsDisabledControlPressed(0, 36) then -- ctrl held down
        delta = 0.01
    end

    DisableControlAction(0, 27, true)
    if IsDisabledControlPressed(0, 27) then -- arrow up
        local newCenter = PolyZone.rotate(center.xy, vector2(center.x, center.y + delta), heading)
        return vector3(newCenter.x, newCenter.y, center.z)
    end
    if IsControlPressed(0, 173) then -- arrow down
        local newCenter = PolyZone.rotate(center.xy, vector2(center.x, center.y - delta), heading)
        return vector3(newCenter.x, newCenter.y, center.z)
    end
    if IsControlPressed(0, 174) then -- arrow left
        local newCenter = PolyZone.rotate(center.xy, vector2(center.x - delta, center.y), heading)
        return vector3(newCenter.x, newCenter.y, center.z)
    end
    if IsControlPressed(0, 175) then -- arrow right
        local newCenter = PolyZone.rotate(center.xy, vector2(center.x + delta, center.y), heading)
        return vector3(newCenter.x, newCenter.y, center.z)
    end

    return center
end
