local result = false
local gameOver = false

function Skillbar(time, length)
    result = false

    Wait(150)
    SetNuiFocus(true, false)
    SendNUIMessage({game = "skillbar", speed = time, challenge = length})

    while not gameOver do
        Wait(365)
        --print("WAITING FOR SKILLGAME TO BE OVER.")
    end

    gameOver = false
    return result
end

RegisterNUICallback(
    "endSkillbar",
    function(data)
        SetNuiFocus(false, false)
        if data.hasWon then
            result = true
        end
        gameOver = true
    end
)
