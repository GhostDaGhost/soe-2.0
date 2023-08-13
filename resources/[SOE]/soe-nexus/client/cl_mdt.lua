function SendMDTDataUpdate()
    local sendData = {}

    local playerData = exports["soe-uchuu"]:GetPlayer()
    if playerData.CharID then
        local charID = playerData.CharID
        local pos = GetEntityCoords(PlayerPedId())
        local location = (exports["soe-utils"]:GetLocation(pos)):gsub(" in ", ", ")
        local seat = -1

        for i = -1, 4 do 
            if GetPedInVehicleSeat(myVeh, i) == PlayerPedId() then
                seat = i
                break
            end
        end

        local vehicle = nil

        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local myVeh = GetVehiclePedIsIn(PlayerPedId(), false)
            local vehicle = {
                ["type"] = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(myVeh))),
                ["plate"] = GetVehicleNumberPlateText(myVeh),
                ["seat"] = seat
            }
        end

        TriggerServerEvent("Nexus:Server:SendMDTData", playerData, location, vehicle)
    end
end