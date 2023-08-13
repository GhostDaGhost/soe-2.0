-- GET REQUEST TO UPDATE PROPERTY DATA
SetHttpHandler(function(req, res)
    if (req.path == "/refresh") then
        res.send("SUP DAWG")
        UpdatePropertyData(true)

        Wait(200)
        local unownedProperties = {}
        for _, property in pairs(propertyList) do
            if not IsPropertyOwned(property.id) then
                table.insert(unownedProperties, property)
            end
        end
        TriggerClientEvent("Housing:Client:ToggleHousingBlips", -1, unownedProperties, true)
    end
end)