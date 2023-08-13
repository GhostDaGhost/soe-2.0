-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, SAVE SETTINGS INPUTTED IN THE UI
local function SaveUISettings(src, settingsData)
    local userSettings = exports["soe-uchuu"]:GetOnlinePlayerList()[src].UserSettings
    if (type(userSettings) == "string") then
        userSettings = json.decode(exports["soe-uchuu"]:GetOnlinePlayerList()[src].UserSettings)
    end

    local charSettings = exports["soe-uchuu"]:GetOnlinePlayerList()[src].Settings
    if (type(charSettings) == "string") then
        charSettings = json.decode(exports["soe-uchuu"]:GetOnlinePlayerList()[src].Settings)
    end

    --print(src, json.encode(settingsData))
    for settingIdx, settingData in pairs(settingsData) do
        -- SOUND SETTINGS
        if (settingIdx == "localSFX") then
            local volume = (settingData / 10) or 1
            TriggerClientEvent("Utils:Client:UpdateVolume", src, volume)
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Sound Volume: " .. volume, length = 5000})
        end

        if (settingIdx == "proxySFX") then
            local volume = (settingData / 10) or 1
            TriggerClientEvent("Utils:Client:UpdateProxyVolume", src, volume)
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Proxy Sound Volume: " .. volume, length = 5000})
        end

        -- CHAT SIZE
        if (settingIdx == "chatSize") then
            local currentSetting = userSettings["chatSize"] or "1.5"
            if (currentSetting ~= settingData) then
                TriggerClientEvent("Chat:Client:SetChatSize", src, settingData)
                exports["soe-uchuu"]:UpdateUserSettings(src, "chatSize", false, settingData)
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Chat Size: " .. settingData, length = 5000})
            else
                print("Unchanged", settingIdx)
            end
        end

        -- DISPATCH ALERT TOGGLE
        if (settingIdx == "mutedDispatchPing") then
            local currentSetting = charSettings["mutedDispatch"] or false
            if (currentSetting ~= settingData) then
                TriggerClientEvent("Emergency:Client:MuteDispatchNotifs", src, {status = true})
            else
                print("Unchanged", settingIdx)
            end
        end

        -- RADIO ANIMATION SWITCHING
        if (settingIdx == "radioAnimation") then
            local currentSetting = charSettings["radioAnim"] or "Shoulder Mic"
            if (currentSetting ~= settingData) then
                exports["soe-uchuu"]:UpdateCharacterSettings(src, "radioAnim", false, settingData)
            else
                print("Unchanged", settingIdx)
            end
        end

        -- STAFF TAG TOGGLE
        if (settingIdx == "hideStaffTag") then
            local currentSetting = userSettings["muteStaffTag"] or false
            if (type(currentSetting) == "string" and currentSetting == "true") then
                currentSetting = exports["soe-utils"]:ConvertToBoolean(currentSetting)
            end

            if (currentSetting ~= settingData) then
                if settingData then
                    exports["soe-uchuu"]:UpdateUserSettings(src, "muteStaffTag", false, true)
                    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Staff Tag In Messages: Muted", length = 5000})
                else
                    exports["soe-uchuu"]:UpdateUserSettings(src, "muteStaffTag", true)
                    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Staff Tag In Messages: Unmuted", length = 5000})
                end
            else
                print("Unchanged", settingIdx)
            end
        end

        -- BOOMBOX TOGGLE
        if (settingIdx == "mutedBoomboxes") then
            local currentSetting = userSettings["mutedBoomboxes"] or false
            if (currentSetting ~= settingData) then
                if settingData then
                    exports["soe-uchuu"]:UpdateUserSettings(src, "mutedBoomboxes", false, true)
                    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Boomboxes: Muted", length = 5000})
                else
                    exports["soe-uchuu"]:UpdateUserSettings(src, "mutedBoomboxes", true)
                    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Boomboxes: Unmuted", length = 5000})
                end
            else
                print("Unchanged", settingIdx)
            end
        end

        -- PHONE TOGGLE
        if (settingIdx == "mutedPhone") then
            local currentSetting = userSettings["mutedPhone"] or false
            if (currentSetting ~= settingData) then
                if settingData then
                    exports["soe-uchuu"]:UpdateUserSettings(src, "mutedPhone", false, true)
                    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Phone Notifications: Off", length = 5000})
                    TriggerClientEvent("gPhone:Client:MuteNotifications", src, {status = true})
                else
                    exports["soe-uchuu"]:UpdateUserSettings(src, "mutedPhone", true)
                    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Phone Notifications: On", length = 5000})
                end
            else
                print("Unchanged", settingIdx)
            end
        end

        -- HELP CHAT TOGGLE
        if (settingIdx == "mutedHelpChat") then
            local currentSetting = userSettings["mutedHelpChat"] or false
            if (type(currentSetting) == "string" and currentSetting == "true") then
                currentSetting = exports["soe-utils"]:ConvertToBoolean(currentSetting)
            end

            if (currentSetting ~= settingData) then
                if settingData then
                    exports["soe-uchuu"]:UpdateUserSettings(src, "mutedHelpChat", false, true)
                    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Help Chat: Muted", length = 5000})
                else
                    exports["soe-uchuu"]:UpdateUserSettings(src, "mutedHelpChat", true)
                    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Help Chat: Unmuted", length = 5000})
                end
            else
                print("Unchanged", settingIdx)
            end
        end

        -- STAFF CHAT TOGGLE
        if (settingIdx == "mutedStaffChat") then
            local currentSetting = userSettings["mutedStaffChat"] or false
            if (type(currentSetting) == "string" and currentSetting == "true") then
                currentSetting = exports["soe-utils"]:ConvertToBoolean(currentSetting)
            end

            if (currentSetting ~= settingData) then
                if settingData then
                    exports["soe-uchuu"]:UpdateUserSettings(src, "mutedStaffChat", false, true)
                    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Staff Chat: Muted", length = 5000})
                else
                    exports["soe-uchuu"]:UpdateUserSettings(src, "mutedStaffChat", true)
                    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Staff Chat: Unmuted", length = 5000})
                end
            else
                print("Unchanged", settingIdx)
            end
        end

        -- EXIT MSG TOGGLE
        if (settingIdx == "mutedExitMsgs") then
            local currentSetting = userSettings["mutedExitMsgs"] or false
            if (type(currentSetting) == "string" and currentSetting == "true") then
                currentSetting = exports["soe-utils"]:ConvertToBoolean(currentSetting)
            end

            if (currentSetting ~= settingData) then
                if settingData then
                    exports["soe-uchuu"]:UpdateUserSettings(src, "mutedExitMsgs", false, true)
                    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Exit Messages: Muted", length = 5000})
                else
                    exports["soe-uchuu"]:UpdateUserSettings(src, "mutedExitMsgs", true)
                    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Exit Messages: Unmuted", length = 5000})
                end
            else
                print("Unchanged", settingIdx)
            end
        end
    end
end

-- **********************
--       Commands
-- **********************
-- WHEN TRIGGERED, SHOW SETTINGS UI
RegisterCommand("ui", function(source)
    local src = source
    TriggerClientEvent("UI:Client:ShowSettingsUI", src)
end)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, SAVE SETTINGS INPUTTED IN THE UI
AddEventHandler("UI:Server:SaveSettings", function(cb, src, settingsData)
    SaveUISettings(src, json.decode(settingsData))

    cb(true)
end)
