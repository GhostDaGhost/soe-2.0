local returnData
local dataReturned = false

-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, OPEN AN INPUT BOX TO TYPE NUMBERS OR WORDS INTO IT
function OpenInputDialogue(type, message, cb)
    SendNUIMessage({type = type, message = message})
    SetNuiFocus(true, true)

    while not dataReturned do
        Wait(100)
    end

    cb(returnData)
    returnData = nil
    dataReturned = false
end

-- WHEN TRIGGERED, OPEN A CONFIRM BOX WITH YES/NO OPTIONS (CUSTOMIZABLE) TO CONFIRM A USER'S SELECTION
function OpenConfirmDialogue(message, yesText, noText, cb)
    SendNUIMessage({type = "confirm", message = message, yesText = yesText, noText = noText})
    SetNuiFocus(true, true)

    while not dataReturned do
        Wait(100)
    end

    cb(returnData)
    returnData = nil
    dataReturned = false
end

-- WHEN TRIGGERED, OPEN A SELECTION DIALOGUE WITH PROVIDED OPTIONS
function OpenSelectDialogue(message, options, cb)
    SendNUIMessage({type = "selection", message = message, options = options})
    SetNuiFocus(true, true)

    while not dataReturned do
        Wait(100)
    end

    cb(returnData)
    returnData = nil
    dataReturned = false
end

-- **********************
--     NUI Callbacks
-- **********************
-- WHEN TRIGGERED, RETURN INPUT DATA FROM THE BOX
RegisterNUICallback("Input.ReturnData", function(data)
    SetNuiFocus(false, false)

    returnData = data.input
    dataReturned = true
end)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, RESET ALL NUI INSTANCES
AddEventHandler("UI:Client:ResetNUI", function()
    SendNUIMessage({type = "Input.ResetUI"})
end)
