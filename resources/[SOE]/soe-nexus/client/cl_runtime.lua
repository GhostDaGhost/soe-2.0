Citizen.CreateThread(function()
    Wait(2500)
    while true do
        SendMDTDataUpdate()
        Wait(10000)
    end
end)