local trigger = _G.TriggerServerEvent
local errorWords = {"failure", "error", "not", "failed", "not safe", "invalid", "cannot", ".lua", "server", "client", "attempt", "traceback", "stack", "function"}

-- LIST OF ERRORS TO SUPPRESS DUE TO THEM BEING TOO WEIRD OR UNFIXABLE (STATE WHY AND WHAT IT IS)
local suppressedErrors = {
    "00a1cadd00108836", -- 'SetPlayerModel' | This is happening due to addon clothing but isn't a fatal error.
    "SetPlayerModel", -- 'SetPlayerModel' | This is happening due to addon clothing but isn't a fatal error.
    "9f47b058362c84b5" -- 'GetEntityModel' | Not sure why this is happening but its not a fatal error.
}

-- **********************
--     Global Natives
-- **********************
-- LOG SERVER EVENT TRIGGERS
_G.TriggerServerEvent = function(...)
    local event = tostring(...)
    trigger(...)

    -- SENDING TOO MANY EVENT LOGS CAUSES SERVER LAG, ONLY SEND ECONOMY-RELATED
    if (event):match("Bank:Server") or (event):match("ATM:Server") then
        trigger("Logging:Server:Log", {status = true, type = "Server Event Triggered", logData = "HAS TRIGGERED SERVER EVENT: " .. ...})
    end
end

-- **********************
--    Local Functions
-- **********************
-- SEND THE ERROR TO THE SoE DEV DISCORD CHANNELS
local function SendErrorMessage(...)
    -- STILL PRINT OUT THE ERROR TO CLIENT'S CONSOLE
    print(...)

    -- CHECK IF THE ERROR ISN'T ALREADY BEING SUPPRESSED
    local found
    for _, word in pairs(suppressedErrors) do
        if string.find(..., word) then
            found = true
            break
        end
    end

    -- GRAB THE RESOURCE NAME AND SEND TO SERVER
    if not found then
        local resource = GetCurrentResourceName()
        TriggerServerEvent("Logging:Server:UploadClientError", resource, ...)
    end
end

-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, INTERCEPT THE PRINTING ERROR FUNCTION
function Citizen.Trace(...)
    if (type(...) == "string") then
        -- IF AN ERROR WORD IS FOUND, LOG
        local args = string.lower(...)
        for _, word in pairs(errorWords) do
            if string.find(args, word) then
                SendErrorMessage(...)
                return
            end
        end
    end
end
