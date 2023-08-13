Citizen.CreateThread(function()
    Wait(2500)
    while true do
        TriggerEvent("Nexus:Server:DeleteOldMDTData")
        Wait(30000)
    end
end)