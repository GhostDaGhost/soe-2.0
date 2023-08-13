-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, SHOW SETTINGS UI
local function ShowSettingsUI()
    SetNuiFocus(true, true)
    SendNUIMessage({type = "Settings.OpenUI"})
end

-- **********************
--     NUI Callbacks
-- **********************
-- WHEN TRIGGERED, RESET NUI INSTANCES
RegisterNUICallback("Settings.ResetPressed", function()
    ResetUI()
end)

-- WHEN TRIGGERED, SHUT NUI FOCUS OFF
RegisterNUICallback("Settings.CloseUI", function()
    SetNuiFocus(false, false)
end)

-- WHEN TRIGGERED, SAVE SETTINGS INPUTTED IN THE UI
RegisterNUICallback("Settings.Save", function(data)
    local inputtedSettings = json.decode(data["inputtedSettings"])

    -- TOGGLE SOME THINGS THAT ARE IN THE CLIENT ONLY
    if (inputtedSettings["blackboxes"] ~= nil) then
        blackboxes = inputtedSettings["blackboxes"]
    end

    if (inputtedSettings["roundedMap"] ~= nil and setupRoundMap ~= inputtedSettings["roundedMap"]) then
        SetResourceKvp("uidata.roundedMap", tostring(inputtedSettings["roundedMap"]))
        SendAlert("success", "Minimap shape changed!", 8500)
        SetupRoundMinimap()
    end

    if (inputtedSettings["showMapBorder"] ~= nil and showMapBorder ~= inputtedSettings["showMapBorder"]) then
        SetResourceKvp("uidata.showMapBorder", tostring(inputtedSettings["showMapBorder"]))
        showMapBorder = inputtedSettings["showMapBorder"] or false
        SendAlert("success", "Minimap border toggled!", 8500)
    end

    if (inputtedSettings["licenseFade"] ~= nil and GetResourceKvpString("uidata.licenseFade") ~= tostring(inputtedSettings["licenseFade"])) then
        licenseFade = inputtedSettings["licenseFade"] or false
        SetResourceKvp("uidata.licenseFade", tostring(inputtedSettings["licenseFade"]))
    end

    if (inputtedSettings["licenseTimer"] ~= nil and GetResourceKvpInt("uidata.licenseTimer") ~= tonumber(inputtedSettings["licenseTimer"])) then
        licenseTimer = inputtedSettings["licenseTimer"] or 10000
        SetResourceKvpInt("uidata.licenseTimer", tonumber(inputtedSettings["licenseTimer"]))
    end

    if (inputtedSettings["licenseFadeTime"] ~= nil and GetResourceKvpInt("uidata.licenseFadeTime") ~= tonumber(inputtedSettings["licenseFadeTime"])) then
        licenseFadeTime = inputtedSettings["licenseFadeTime"] or 3500
        SetResourceKvpInt("uidata.licenseFadeTime", tonumber(inputtedSettings["licenseFadeTime"]))
    end

    if (inputtedSettings["useLicenseChatMsg"] ~= nil and GetResourceKvpString("uidata.licenseChatMessage") ~= tostring(inputtedSettings["useLicenseChatMsg"])) then
        useChatMessageForLicense = inputtedSettings["useLicenseChatMsg"] or false
        SetResourceKvp("uidata.licenseChatMessage", tostring(inputtedSettings["useLicenseChatMsg"]))
    end

    -- SAVE OTHER SETTINGS IN THE SERVER-SIDE
    exports["soe-nexus"]:TriggerServerCallback("UI:Server:SaveSettings", data["inputtedSettings"])
end)

-- WHEN TRIGGERED, GET SETTINGS OF PLAYER
RegisterNUICallback("Settings.GetSettings", function(data, cb)
    local userSettings = json.decode(exports["soe-uchuu"]:GetPlayer().UserSettings)

    if (data.getType == "General") then
        local charSettings = exports["soe-uchuu"]:GetPlayer().Settings
        if (type(charSettings) == "string") then
            charSettings = json.decode(exports["soe-uchuu"]:GetPlayer().Settings)
        end

        cb({
            sound = exports["soe-utils"]:GetSoundLevel() or 1,
            mutedBoomboxes = userSettings["mutedBoomboxes"] or false,
            mutedDispatchPing = charSettings["mutedDispatch"] or false,
            mutedPhone = userSettings["mutedPhone"] or false,
            radioAnim = charSettings["radioAnim"] or "Shoulder Mic",
        })
    elseif (data.getType == "UI") then
        local roundedMap, mapBorder = true, true
        if (GetResourceKvpString("uidata.roundedMap") == "nil" or GetResourceKvpString("uidata.roundedMap") == "false") then
            roundedMap = false
        end

        if (GetResourceKvpString("uidata.showMapBorder") == "nil" or GetResourceKvpString("uidata.showMapBorder") == "false") then
            mapBorder = false
        end

        cb({
            mutedHelpChat = userSettings["mutedHelpChat"] or false,
            mutedStaffChat = userSettings["mutedStaffChat"] or false,
            mutedExitMsgs = userSettings["mutedExitMsgs"] or false,
            chatSize = userSettings["chatSize"] or 1.5,
            hideStaffTag = userSettings["muteStaffTag"] or false,
            blackboxes = blackboxes,
            roundedMap = roundedMap,
            showMapBorder = mapBorder,
            shouldLicenseFade = licenseFade or false,
            licenseTimer = licenseTimer or 10000,
            licenseFadeTime = licenseFadeTime or 3500,
            useChatMessageForLicense = useChatMessageForLicense or false
        })
    end
end)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, SHOW SETTINGS UI
RegisterNetEvent("UI:Client:ShowSettingsUI", ShowSettingsUI)
