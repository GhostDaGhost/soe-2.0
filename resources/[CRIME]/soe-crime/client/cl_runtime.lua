-- MAIN LOOP
CreateThread(function()
    Wait(3500)
    exports["soe-menus"]:AddModelToRadialData("Vending Machines", robbableVendingMachines)
    exports["soe-menus"]:AddModelToRadialData("Cash Trolley", {412463629})

    CreateZones()
    LoadAnimationDictionaries()

    local loopIndex = 0
    while true do
        Wait(600)

        loopIndex = loopIndex + 1
        if (loopIndex % 210 == 0) then
            HomicideCheck()
        elseif (loopIndex % 5050 == 0) then
            robbedParkingMeters = {}
        end
    end
end)
