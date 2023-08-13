local hasSpawned = false

-- ***********************
--         Events
-- ***********************
-- WHEN TRIGGERED, START FACTIONS RUNTIME
AddEventHandler("Uchuu:Client:PlayerSpawned", function()
    hasSpawned = true

    Wait(3500)
    while true do
        Wait(45000)
        SetGangRelationships()
    end
end)
