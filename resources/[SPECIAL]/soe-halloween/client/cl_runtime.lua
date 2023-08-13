CreateThread(function()
    Wait(3500)
    -- WAIT UNTIL CHARACTER SELECTED
    while not hasSpawned do
        if (exports["soe-uchuu"]:GetPlayer().CharID ~= nil) then
            hasSpawned = true
        end
        Wait(150)
    end
    print("START HALLOWEEN RUNTIME")

    BeginBlackout()
    AnnounceApocalypse()

    while true do
        Wait(50000)
        DoZombieEvent()
    end
end)
