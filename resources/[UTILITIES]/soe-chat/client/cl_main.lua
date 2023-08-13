local sendName = {}
statusMessages = {}

sendName["me"] = ""
sendName["do"] = ""
sendName["pm"] = "[PM]"
sendName["dev"] = "[Dev]"
sendName["ooc"] = "[OOC] "
sendName["mdt"] = "[MDT] "
sendName["taxi"] = "[Taxi]"
sendName["safr"] = "[SAFR]"
sendName["bank"] = "[Bank]"
sendName["help"] = "[Help] "
sendName["crime"] = "[Crime]"
sendName["police"] = "[Police]"
sendName["system"] = "[System]"
sendName["emotes"] = "[Emotes]"
sendName["properties"] = "[Real Estate]"
sendName["looc"] = "[Local OOC] "
sendName["modshop"] = "[Modshop] "

-- ***********************
--    Global Functions
-- ***********************
-- WHEN TRIGGERED, ALLOW CHAT SIZE TO BE CONFIGURED
function SetChatSize(newSize)
    SendNUIMessage({type = "Chat_ChangeSize", size = newSize or 1.5})
end

-- DISPLAYS NAME OF PLAYER BASED ON DUTY (EXAMPLE: Deputy Rhodes)
function GetDisplayName()
    local myJob = exports["soe-jobs"]:GetMyJob()
    local char = exports["soe-uchuu"]:GetPlayer()
    if (myJob == "POLICE" or myJob == "EMS" or myJob == "DISPATCH" or myJob == "DOJ") then
        return char.JobTitle .. " " .. char.LastGiven
    end
    return char.FirstGiven
end

-- HIDES CHAT WHEN "/hud" IS EXECUTED
function HideChat(bool)
    local savedState = GetResourceKvpString("hideState")
    local forceHide = IsScreenFadedOut() or IsPauseMenuActive()
    if bool then
        SendNUIMessage({type = "ON_SCREEN_STATE_CHANGE", hideState = (tonumber(savedState) or 0), fromUserInteraction = not forceHide})
    else
        SendNUIMessage({type = "ON_SCREEN_STATE_CHANGE", hideState = 2, fromUserInteraction = not forceHide})
    end
end

-- CALLED WHEN THE INITIAL CHAT RESOURCE IS BOOTED
function LoadTemplates()
    -- NEW CHAT TEMPLATES / WIP AND TESTING - Ghost 12/28/20
    AddTemplate("linebreak", "<hr>")
    AddTemplate("linebreak2", "<br>")
    AddTemplate("center", "<center>{1}</center>")
    AddTemplate("blank", "<font color='#ffffff'>{0} {1}</font>")
    AddTemplate("do", '<div style="padding: 0.5vw; margin: 0.2vw; background-color: rgba(1, 22, 84, 0.25); border-radius: 0.8vh;">{0} {1}</div>')
    AddTemplate("me", '<div style="padding: 0.5vw; margin: 0.2vw; background-color: rgba(21, 73, 117, 0.25); border-radius: 0.8vh;">{0} {1}</div>')
    AddTemplate("me-2", '<div style="padding: 0.5vw; margin: 0.2vw; background-color: rgba(168, 50, 86, 0.25); border-radius: 0.8vh;">{0} {1}</div>')
    AddTemplate("id", '<div style="padding: 0.5vw; margin: 0.2vw; background-color: rgba(200, 140, 200, 0.25); border-radius: 0.8vh;"><b>{0}</b>: {1}</div>')
    AddTemplate("taxi", '<div style="padding: 0.5vw; margin: 0.2vw; background-color: rgba(255, 255, 0, 0.25); border-radius: 0.8vh;"><b>{0}</b>: {1}</div>')
    AddTemplate("dev", '<div style="padding: 0.5vw; margin: 0.2vw; background-color: rgba(117, 68, 227, 0.25); border-radius: 0.8vh;"><b>{0}</b>: {1}</div>')
    AddTemplate("bank", '<div style="padding: 0.5vw; margin: 0.2vw; background-color: rgba(58, 178, 14, 0.25); border-radius: 0.8vh;"><b>{0}</b>: {1}</div>')
    AddTemplate("safr", '<div style="padding: 0.5vw; margin: 0.2vw; background-color: rgba(255, 33, 33, 0.25); border-radius: 0.8vh;"><b>{0}</b>: {1}</div>')
    AddTemplate("pm", '<div style="padding: 0.5vw; margin: 0.2vw; background-color: rgba(150, 150, 150, 0.25); border-radius: 0.8vh;"><b>{0}</b>: {1}</div>')
    AddTemplate("system", '<div style="padding: 0.5vw; margin: 0.2vw; background-color: rgba(255, 0, 0, 0.25); border-radius: 0.8vh;"><b>{0}</b>: {1}</div>')
    AddTemplate("crime", '<div style="padding: 0.5vw; margin: 0.2vw; background-color: rgba(17, 73, 138, 0.25); border-radius: 0.8vh;"><b>{0}</b>: {1}</div>')
    AddTemplate("help", '<div style="padding: 0.5vw; margin: 0.2vw; background-color: rgba(168, 10, 120, 0.25); border-radius: 0.8vh;"><b>{0}</b>: {1}</div>')
    AddTemplate("ooc", '<div style="padding: 0.5vw; margin: 0.2vw; background-color: rgba(105, 105, 105, 0.25); border-radius: 0.8vh;"><b>{0}</b>: {1}</div>')
    AddTemplate("mdt", '<div style="padding: 0.5vw; margin: 0.2vw; background-color: rgba(150, 175, 220, 0.25); border-radius: 0.8vh;"><b>{0}</b>: {1}</div>')
    AddTemplate("phone", '<div style="padding: 0.5vw; margin: 0.2vw; background-color: rgba(153, 39, 219, 0.25); border-radius: 0.8vh;"><b>{0}</b>: {1}</div>')
    AddTemplate("looc", '<div style="padding: 0.5vw; margin: 0.2vw; background-color: rgba(105, 105, 105, 0.25); border-radius: 0.8vh;"><b>{0}</b>: {1}</div>')
    AddTemplate("modshop", '<div style="padding: 0.5vw; margin: 0.2vw; background-color: rgba(105, 105, 105, 0.25); border-radius: 0.8vh;"><b>{0}</b>: {1}</div>')
    AddTemplate("emotes", '<div style="padding: 0.5vw; margin: 0.2vw; background-color: rgba(10, 171, 196, 0.25); border-radius: 0.8vh;"><b>{0}</b>: {1}</div>')
    AddTemplate("police", '<div style="padding: 0.5vw; margin: 0.2vw; background-color: rgba(68, 140, 255, 0.25); border-radius: 0.8vh;"><b>{0}</b>: {1}</div>')
    AddTemplate("properties", '<div style="padding: 0.5vw; margin: 0.2vw; background-color: rgba(224, 168, 56, 0.25); border-radius: 0.8vh;"><b>{0}</b>: {1}</div>')
    AddTemplate("standard", '<div style="padding: 0.5vw; margin: 0.2vw; background-color: rgba(68, 140, 255, 0.25); border-radius: 0.8vh;"><b>{0}</b>: {1}</div>')
    AddTemplate("cad", '<div style="padding: 0.5vw; margin: 0.2vw; background-color: rgba(61, 105, 93, 0.25); border-radius: 0.8vh;"><b>{0}</b>: {1}</div>')
end

-- ***********************
--        Commands
-- ***********************
-- WHEN TRIGGERED, ALLOW CHAT SIZE TO BE CONFIGURED
RegisterCommand("chatsize", function()
    exports["soe-input"]:OpenInputDialogue("number", "Input Chat Size (0.0 to 3.0) (Default: 1.5)", function(returnData)
        if (returnData ~= nil) then
            SendNUIMessage({type = "Chat_ChangeSize", size = returnData or 1.5})
            TriggerServerEvent("Uchuu:Server:UpdateUserSettings", {status = true, setting = "chatSize", remove = false, settingData = returnData or 1.5})
        end
    end)
end)

-- ***********************
--         Events
-- ***********************
-- WHEN TRIGGERED, ALLOW CHAT SIZE TO BE CONFIGURED
RegisterNetEvent("Chat:Client:SetChatSize", SetChatSize)

-- WHEN TRIGGERED, RESET ALL NUI INSTANCES
AddEventHandler("UI:Client:ResetNUI", function()
    SendNUIMessage({type = "hideInput", canceled = true})
    print("[Chat] UI resetted.")
end)

-- CALLED FROM THE SERVER TO UPDATE THIS CLIENT'S STATUS LIST
RegisterNetEvent("Chat:Client:GetStatusMessages")
AddEventHandler("Chat:Client:GetStatusMessages", function(_statusMessages)
    statusMessages = _statusMessages
end)

-- USED FOR GENERAL CHAT MESSAGES BUT ALLOWS BRACKETED TEXT TO BE CHOSEN WHILE COLOR FALLS UNDER A TEMPLATE
RegisterNetEvent("Chat:Client:Message")
AddEventHandler("Chat:Client:Message", function(prefix, message, template)
    AddMessage({templateId = template, multiline = true, args = {prefix, message}})
end)

-- WHEN TRIGGERED, RETRIEVE SAVED CHAT SIZE
AddEventHandler("Uchuu:Client:CharacterSelected", function()
    Wait(2500)

    local savedChatSize = json.decode(exports["soe-uchuu"]:GetPlayer().UserSettings)["chatSize"] or 1.5
    SendNUIMessage({type = "Chat_ChangeSize", size = savedChatSize})
end)

-- USED FOR GENERAL CHAT MESSAGES WITH TEMPLATE CHOOSING
RegisterNetEvent("Chat:Client:SendMessage")
AddEventHandler("Chat:Client:SendMessage", function(type, sendMessage, sender, atEnd)
    local senderT = sender
    chatType = type:lower()

    if (senderT == nil) then
        AddMessage({templateId = chatType, multiline = true, args = {sendName[chatType] or sendName["system"], sendMessage}})
    elseif senderT and not atEnd then
        AddMessage({templateId = chatType, multiline = true, args = {sendName[chatType] or sendName["system"] .. senderT, sendMessage}})
    else
        AddMessage({templateId = chatType, multiline = true, args = {sendName[chatType] or sendName["system"], sendMessage, senderT}})
    end
end)
