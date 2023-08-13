function PerformAPIRequest(apiRoute, dataString, jsonDecoded)
    -- Setup routes
    local token = GetConvar("coreAPIToken")
    local route = GetConvar("coreAPIRoute", "dev.core.soe.gg")
    local dataStringWithToken = dataString .. "&token=" .. token
    local returnData = nil

    local retry = true
    local result
    local errorCode

    for attempts = 0, 5 do
        -- Check if script needs to retry API
        if not retry then
            if exports["soe-uchuu"]:IsDevServer() then
                print("[API Request] ", ("[Route: %s]"):format(apiRoute), ("[Status: %s]"):format(errorCode), ("[Attempts: %s / 5]"):format(attempts))
            end

            -- Log API attempts in discord if attempted more than once
            if attempts >= 2 then
                -- API Discord Error Logging
                if not exports["soe-uchuu"]:IsDevServer() then
                    if (apiRoute ~= "/api/user/login" and apiRoute ~= "/api/user/create"  and apiRoute ~= "/api/phone/loginaccount") and errorCode ~= 200 then
                        local timestamp = os.date("%Y-%m-%d %H:%M:%S", os.time())
                        local data = {{["color"] = 1127128, ["title"] = ("API Error Log \nRoute: %s"):format(apiRoute), ["description"] = ("**Attempts:** %s/5 \n Status Code: %s \n Parameters: %s \nResponse:\n %s \n Timestamp: %s"):format(attempts, errorCode, "|| " .. dataString .. " ||", resultData, timestamp)}}
                        PerformHttpRequest(
                            "https://discord.com/api/webhooks/808241809591238688/JqaJEZCvwehC-sHvxxmHaM7SDQwFXSHaHDLZz4ZEqu6Edxa0CwiSBU-zqCZC5Q9oKdsv",
                            function(err, text, headers)
                            end,
                            "POST",
                            json.encode({username = "SoE API Error Logs", embeds = data}),
                            {["Content-Type"] = "application/json"}
                        )
                    end
                end
            end
            break
        end

        local apiPromise = promise.new()

        PerformHttpRequest("https://" .. route .. apiRoute,
            function(errCode, resultData, resultHeaders)
                errorCode = errCode
                
                returnData = resultData
                
                if errorCode == 200 then -- Check if HTTP status is OK
                    retry = false
                    if resultData == nil then -- Ensure resultData is not nil to prevent errors
                        returnData = false
                    end
                else -- Force API to retry connection
                    if attempts >= 4 then
                        retry = false
                    else
                        retry = true
                    end
                    returnData = false
                end

                -- Resolve promise
                apiPromise:resolve(returnData)
            end,
        "POST", dataStringWithToken)

        result = Citizen.Await(apiPromise)
    end

    if jsonDecoded then
        return json.decode(result)
    end

    return result
end
