local uploadWebhook = "https://discord.com/api/webhooks/808241809591238688/JqaJEZCvwehC-sHvxxmHaM7SDQwFXSHaHDLZz4ZEqu6Edxa0CwiSBU-zqCZC5Q9oKdsv"
local errorWords = {"failure", "error", "not", "failed", "not safe", "invalid", "cannot", ".lua", "server", "client", "attempt", "traceback", "stack", "function"}

-- THIS SENDS A DISCORD WEBHOOK MSG TO EPCG DISCORD FOR LOGGING
local function SendServerErrorMessage(...)
    -- CONTINUE PRINTING ERROR OUT IN SERVER CONSOLE
    print(...)

    -- DON'T REPORT ERRORS IF THIS SERVER IS A DEV SERVER
    if exports["soe-uchuu"]:IsDevServer() then return end
    local timestamp = os.date("%Y-%m-%d %H:%M:%S", os.time())

    local resource = GetCurrentResourceName()
    local data = {{["color"] = 14177041, ["title"] = "Server Error Log", ["description"] = ("Resource: %s \nTimestamp: %s \n\n %s"):format(resource, timestamp, ...)}}
    PerformHttpRequest(uploadWebhook, function() end, "POST", json.encode({username = "SoE Error Logs", embeds = data}), {["Content-Type"] = "application/json"})
end

-- INTERCEPT THE PRINTING ERROR FUNCTION
function Citizen.Trace(...)
    if (type(...) == "string") then
        -- IF AN ERROR WORD IS FOUND, LOG
        local args = string.lower(...)
        for _, word in pairs(errorWords) do
            if args:match(word) then
                SendServerErrorMessage(...)
                return
            end
        end
    end
end

RegisterNetEvent("Logging:Server:UploadClientError")
AddEventHandler("Logging:Server:UploadClientError", function(resource, error)
    local src = source
    -- DON'T REPORT ERRORS IF THIS SERVER IS A DEV SERVER
    if exports["soe-uchuu"]:IsDevServer() then return end
    local timestamp = os.date("%Y-%m-%d %H:%M:%S", os.time())

    -- CONSTRUCT DATA TO SEND TO DISCORD
    local username
    if (exports["soe-uchuu"]:GetOnlinePlayerList()[src].Username ~= nil) then
        username = tostring(exports["soe-uchuu"]:GetOnlinePlayerList()[src].Username)
    else
        username = "(NOT YET LOGGED IN)"
    end

    local data = {{["color"] = 9312783, ["title"] = ("Client Error Log \nBy: %s"):format(username), ["description"] = ("Resource: %s \nTimestamp: %s \n\n %s"):format(resource, timestamp, error)}}
    PerformHttpRequest(uploadWebhook, function() end, "POST", json.encode({username = "SoE Error Logs", embeds = data}), {["Content-Type"] = "application/json"})
end)
