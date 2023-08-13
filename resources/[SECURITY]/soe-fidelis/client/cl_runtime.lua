local spawned = false

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, FULFILL SPAWNED VARIABLE
AddEventHandler("Uchuu:Client:PlayerSpawned", function()
    spawned = true
end)

-- **********************
--         Loops
-- **********************
-- MAIN RUNTIME OF THE RESOURCE
CreateThread(function()
    Wait(5500)

    local loopIndex = 0
    local checkForAFK = true
    if exports["soe-uchuu"]:IsDevServer() or exports["soe-uchuu"]:IsTrainingServer() then
        checkForAFK = false
    end

    while true do
        Wait(3)

        -- WHEN NOT SPAWNED YET, DISABLE THE FUNCTION KEYS
        if not spawned then
            DisableFunctionKeys()
        end

        -- DO AN ANTI-CHEAT SCAN | EVERY 5 SECONDS
        loopIndex = loopIndex + 1
        if (loopIndex % 500 == 0) then
            ProcessAnticheat()
        end

        -- RESTRICTED VEHICLE CHECK | EVERY 30 SECONDS
        if (loopIndex % 3000 == 0) then
            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped, false) then
                RestrictedVehicleCheck(ped)
            end
        end

        -- CURRENT RESOURCE LIST INSPECTION / AFK CHECK | EVERY MINUTE
        if (loopIndex % 6000 == 0) then
            loopIndex = 0
            InspectCurrentResources()

            -- IF THE AFK CHECK IS ENABLED
            if checkForAFK then
                AFKKicker()
            end
        end
    end
end)
