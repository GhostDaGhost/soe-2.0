local passed = false
local isLockpicking = false

function StartLockpicking(bool)
    -- A NASTY FAILSAFE FOR RADIAL MENU SELECTION
    -- ALSO ONE FOR CHATBOX GETTING STUCK
    if (bool == true) then
        Wait(1000)
    end

    SetNuiFocus(bool, bool)
    SendNUIMessage({action = "toggleLockpicking", toggle = bool})
    SetCursorLocation(0.5, 0.2)
    isLockpicking = bool

    -- ANIMATION CONTROL
    if isLockpicking then
        local ped = PlayerPedId()
        exports["soe-utils"]:LoadAnimDict("anim@gangops@facility@servers@", 15)
        exports["soe-ui"]:SendAlert("inform", "You begin lockpicking", 1500)
        while isLockpicking do
            Wait(200)
            if not IsEntityPlayingAnim(ped, "anim@gangops@facility@servers@", "hotwire", 3) then
                TaskPlayAnim(ped, "anim@gangops@facility@servers@", "hotwire", 1.0, 1.0, -1, 49, 0, 0, 0, 0)
            end
        end
        ClearPedTasks(ped)
    end

    return passed
end

RegisterNUICallback("Lockpicking.Exit", function()
    StartLockpicking(false)
    passed = false
end)

RegisterNUICallback("Lockpicking.Success", function()
    StartLockpicking(false)
    exports["soe-utils"]:PlayProximitySound(3.0, "lockpick-unlock.ogg", 0.45)
    exports["soe-ui"]:SendAlert("success", "You successfully lockpicked", 1500)
    passed = true
end)

RegisterNUICallback("Lockpicking.Failure", function(data)
    if data.broken then
        exports["soe-ui"]:SendAlert("error", "Your pin broke", 1500)
        exports["soe-utils"]:PlayProximitySound(3.5, "lockpick-break.ogg", 0.5)

        -- TAKE A LOCKPICK AWAY CHANCE
        math.randomseed(GetGameTimer())
        math.random() math.random() math.random()
        if (math.random(1, 100) > 85) then
            exports["soe-ui"]:SendAlert("error", "You lost a lockpick!", 7500)
            TriggerServerEvent("Challenge:Server:BreakLockpick")
        end
    end
    StartLockpicking(false)
    passed = false
end)
