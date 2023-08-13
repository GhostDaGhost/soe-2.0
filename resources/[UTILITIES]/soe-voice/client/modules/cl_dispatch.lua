local isListOpen = false

-- KEY MAPPINGS
--RegisterKeyMapping("toggleradiolist", "[Voice] Toggle Dispatch Radio List", "KEYBOARD", "")

-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, RETURN IF DISPATCH RADIO LIST IS OPEN
function IsDispatchRadioOpen()
    return isListOpen
end
exports("IsDispatchRadioOpen", IsDispatchRadioOpen)

function ToggleRadioList()
    local char = exports["soe-uchuu"]:GetPlayer()
    if (char.CivType ~= "DISPATCH") then
        return
    end

    if not isListOpen then
        isListOpen = true
        SendNUIMessage({type = "Radio.ToggleList", show = true})
    else
        isListOpen = false
        SendNUIMessage({type = "Radio.ToggleList", show = false})
    end
end

-- **********************
--        Commands
-- **********************
--RegisterCommand("toggleradiolist", ToggleRadioList)
