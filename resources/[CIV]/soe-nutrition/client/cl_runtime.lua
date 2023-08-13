local hasSpawned = false

-- CALLED WHEN PLAYER SPAWNS, START HUNGER AND THIRST DEPLETION
AddEventHandler("Uchuu:Client:PlayerSpawned", function()
    hasSpawned = true
end)

CreateThread(function()
    Wait(3500)
    -- WAIT UNTIL CHARACTER SELECTED
    while not hasSpawned do
        Wait(150)
    end

    local loopIndex = 0
    while true do
        Wait(750)
        UpdateHungerThirst()

        loopIndex = loopIndex + 1
        if (loopIndex % 250 == 0) then
            SaveLevelsToDB()
        end
    end
end)
