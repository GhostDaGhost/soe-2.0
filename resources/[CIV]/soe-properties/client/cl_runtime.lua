
-- HOUSING LOOP
local loopIndex = 0

CreateThread(function()
    Wait(5000)
    TriggerServerEvent("Properties:Server:RequestPropertyData")

    while true do
        loopIndex = loopIndex + 1
        Wait(5)
        -- Sets player location marker to property location
        if currentHouse ~= nil and not IsMinimapInInterior() then
            local pos = GetPropertyByID(currentHouse).entrance
            SetPlayerBlipPositionThisFrame(pos.x, pos.y)
        end

        -- EVERY SECOND, CHECK IF MENU SHOULD BE CLOSED (TOO FAR AWAY)
        if loopIndex % 200 == 0 then
            if menuProperty then
                local property = GetPropertyByID(menuProperty)
                if #(vector3(property.entrance.x, property.entrance.y, property.entrance.z) - GetEntityCoords(PlayerPedId())) > 2.0 then
                    CloseHousingMenu()
                end
            end

            if not isMenuOpen and menuProperty then
                menuProperty = nil
            end 
        end
    end
end)

