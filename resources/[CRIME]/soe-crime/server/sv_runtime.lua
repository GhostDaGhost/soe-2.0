local loopIndex = 0

CreateThread(function()
    Wait(3500)
    InitWeedplants()
    RefreshChopShop()

    while true do
        Wait(10000)
        HandleMoneyLaundering()
        TriggerEvent("Crime:Server:EnsurePlantsSpawn")

        loopIndex = loopIndex + 1
        if (loopIndex % 6 == 0) then
            TriggerEvent("Crime:Server:ATMStatusCooldownCheck")
        end

        if (loopIndex % 9 == 0) then
            TriggerEvent("Crime:Server:MachineStatusCooldownCheck")
        end

        -- EVERY 15 MINUTES
        if (loopIndex % 90 == 0) then
            -- RESET STORE SAFES
            for safe in pairs(storeSafes) do
                storeSafes[safe].robbed = false
                TriggerClientEvent("Crime:Client:SetSafeStatus", -1, safe, false)
            end
    
            -- RESET STORE REGISTERS
            for register in pairs(storeRegisters) do
                storeRegisters[register].robbed = false
                TriggerClientEvent("Crime:Client:SetRegisterStatus", -1, register, false)
            end
        end

        -- EVERY 30 MINUTES | RESET CHOP SHOP LIST
        if (loopIndex % 180 == 0) then
            RefreshChopShop()
        end

        -- EVERY 1 HOUR | GROW WEED PLANTS
        if (loopIndex % 360 == 0) then
            loopIndex = 0
            TriggerEvent("Crime:Server:GrowWeedPlants")
        end
    end
end)
