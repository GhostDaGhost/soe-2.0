## Client API

### Exports

##### ServerLog
```
Description: Logs action with the data you provide.

Arguments:
    -- Type (Vehicle, Staff Tool, anything)
    -- Data

Returns:
    Nothing

Examples:
    RegisterCommand(
        "logtest",
        function()
            local char = exports["soe-uchuu"]:GetPlayer()
            exports["soe-logging"]:ServerLog("Test", {
                ["CharID"] = char.CharID,
                ["Character-Name"] = string.format("%s / %s", char.FirstGiven, char.LastGiven)
            })
        end
    )
```

##### ScreenshotMyScreen
```
Description: Takes a screenshot of the client's screen. This will send the screenshot and data to the SoE Staff Channels

Arguments:
    -- Reason for screenshot taking

Returns:
    Nothing

Examples:
    RegisterCommand(
        "logtest",
        function()
            exports["screenshot-basic"]:requestScreenshotUpload(
                INSERT WEBHOOK HERE,
                "files[]",
                function(data)
                    if data ~= nil and json.decode(data).attachments and #json.decode(data).attachments > 0 then
                        TriggerServerEvent("Logging:Server:UploadScreenshot", json.decode(data).attachments[1].url, reason)
                    end
                end
            )
        end
    )
```

## Server API

### Exports

##### ServerLog
```
Description: Logs action with the data you provide.

Arguments:
    -- Type (Vehicle, Staff Tool, anything)
    -- Data

Returns:
    Nothing

Examples:
    RegisterCommand(
        "logtest",
        function(source)
            local src = source
            local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
            exports["soe-logging"]:ServerLog("Test", {
                ["CharID"] = char.CharID,
                ["Character-Name"] = string.format("%s / %s", char.FirstGiven, char.LastGiven)
            }, src)
        end
    )
```
