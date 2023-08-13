function NearHangar(playerCoords, clientPlayerCoords, clientHangarCoords)
    for i = 1, #hangarLocations do
        if
            vector3(math.floor(playerCoords.x), math.floor(playerCoords.y), math.floor(playerCoords.z)) ==
                vector3(
                    math.floor(clientPlayerCoords.x),
                    math.floor(clientPlayerCoords.y),
                    math.floor(clientPlayerCoords.z)
                )
         then
            if
                vector3(hangarLocations[i].menu.x, hangarLocations[i].menu.y, hangarLocations[i].menu.z) ==
                    clientHangarCoords
             then
                return hangarLocations[i]
            end
        end
    end
    return false
end

function HangarInteract(src, clientPlayerCoords, clientHangarCoords)
    -- Verify data matches on server
    local hangarData = NearHangar(GetEntityCoords(GetPlayerPed(src)), clientPlayerCoords, clientHangarCoords)
    if hangarData then
        -- TriggerClientEvent("Aviation:Client:OpenHangarMenu", getClientHangarAircraft)
        print("Aviation: Client data matches server.")
        -- Is near hangar
        -- local getClientHangarAircraft = GetHangarAircraft(hangarData)
        GetHangarAircraft(src, hangarData)
    else
        print("Aviation: Client data does not match on server.")
    end
end

function GetHangarAircraft(src, hangarData)
    print("before client triggered")
    TriggerClientEvent(
        "Aviation:Client:SpawnAircraft",
        src,
        "Mammatus",
        vector3(hangarData.spawn.x, hangarData.spawn.y, hangarData.spawn.z + 1)
    )
end
