local sleep = 10

CreateThread(function()
    Wait(3500)
    while true do
        Wait(sleep)
        if #myList >= 1 then
            sleep = 10
            for _, veh in pairs(myList) do
                --print(DoesEntityExist(veh.vehID))
                SetEntityAsMissionEntity(veh.vehID, true, true)
            end
        else
            sleep = 100
        end
    end
end)
