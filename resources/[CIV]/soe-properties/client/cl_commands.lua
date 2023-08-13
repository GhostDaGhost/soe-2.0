-- MOVE THESE TO SERVER EVENTUALLY
local debugItem = false

-- NAVIGATE TO HOUSE
RegisterCommand("navigate", function(src, args)
    if #args >= 1 then
        local property = GetPropertyByAddress(table.concat(args, " "))
        if property then
            TriggerEvent("Chat:Client:SendMessage", "properties", string.format(
                "GPS waypoint set to: ^4%s", property.address
            ))
            SetNewWaypoint(property.entrance.x, property.entrance.y)
        else
            TriggerEvent("Chat:Client:SendMessage", "properties", string.format(
                "Unable to locate address: ^4%s", table.concat(args, " ")
            ))
        end
    else
        TriggerEvent("Chat:Client:SendMessage", "properties", "You must specify an address to navigate to.")
    end
end, false)
