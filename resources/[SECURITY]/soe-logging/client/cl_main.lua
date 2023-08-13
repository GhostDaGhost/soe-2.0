local uploadWebhook = "https://discordapp.com/api/webhooks/770512477821337620/mNnzuoL4ybMmtveizAiSahnOMyr1hTybDIIFM0zV7DIRMAq1S92yv2nLmxRtCGHbV9q-"

-- ***********************
--    Global Functions
-- ***********************
-- RECEIVES DATA FROM THE EXPORT AND SENDS TO SERVER FOR DB UPLOAD
function ServerLog(type, data)
    TriggerServerEvent("Logging:Server:Log", {status = true, type = type, logData = data})
end

-- WHEN TRIGGERED, SCREENSHOT THE PLAYER'S SCREEN
function ScreenshotMyScreen(reason)
    exports["screenshot-basic"]:requestScreenshotUpload(uploadWebhook, "files[]", function(data)
        if data ~= nil and json.decode(data).attachments and #json.decode(data).attachments > 0 then
            TriggerServerEvent("Logging:Server:UploadScreenshot", json.decode(data).attachments[1].url, reason)
        end
    end)
end

-- ***********************
--         Events
-- ***********************
-- WHEN TRIGGERED, SCREENSHOT THE PLAYER'S SCREEN
RegisterNetEvent("Logging:Client:TakeThisSucker", ScreenshotMyScreen)
