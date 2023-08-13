local micClicks, micClickVolume = true, 0.1

local radioChannel, secondaryRadioChannel = 0, 0
local radioOpened, radioTimeout, disableCamera = false, false, true

submixToggle = true

-- KEY MAPPINGS
RegisterKeyMapping("radio", "[Voice] Toggle Radio UI", "KEYBOARD", "F4")
RegisterKeyMapping("+toggleradiocam", "[Voice] Radio Camera Movement", "KEYBOARD", "LMENU")

RegisterKeyMapping("+radiotalk", "[Voice] Push to Talk (Primary)", "KEYBOARD", "J")
RegisterKeyMapping("+secondaryradiotalk", "[Voice] Push to Talk (Secondary)", "KEYBOARD", "SLASH")

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, DO BROADCASTING ANIMATIONS
local function PerformBroadcastingAnimation()
    local charSettings = exports["soe-uchuu"]:GetPlayer().Settings
    if (type(charSettings) == "string") then
        charSettings = json.decode(exports["soe-uchuu"]:GetPlayer().Settings)
    end

    local savedRadioAnim = charSettings["radioAnim"] or "Shoulder Mic"
    if (radioAnimations[savedRadioAnim].dict == nil) then
        exports["soe-emotes"]:StartEmote(radioAnimations[savedRadioAnim].anim)
    else
        exports["soe-utils"]:LoadAnimDict(radioAnimations[savedRadioAnim].dict, 15)
        TaskPlayAnim(PlayerPedId(), radioAnimations[savedRadioAnim].dict, radioAnimations[savedRadioAnim].anim, 3.0, 3.0, -1, 49, 0, 0, 0, 0)
    end
    return savedRadioAnim
end

-- ADDS PLAYER TO RADIO CHANNEL SPECIFIED
local function SetMyChannel(channel, type)
    local authorized = false
    if restrictedRadioChannels[math.floor(channel)] then
        local civType = exports["soe-uchuu"]:GetPlayer().CivType
        if (civType == "POLICE" or civType == "DISPATCH" or civType == "EMS") then
            authorized = true
        end

        if (civType == "CRIMELAB" and channel == 10) then
            authorized = true
        end
    else
        authorized = true
    end

    if authorized then
        if (channel == radioChannel or channel == secondaryRadioChannel) then
            exports["soe-ui"]:SendAlert("error", "Already tuned into this channel!", 5000)
            return
        end

        SetRadioChannel(channel, type)
        exports["soe-ui"]:SendAlert("warning", ("%s Radio Channel Set To: %s MHz"):format(type, channel), 5000)
    else
        SetRadioChannel(0, type)
        exports["soe-ui"]:SendAlert("error", "This radio channel is restricted", 5000)
    end
end

-- WHEN TRIGGERED, STOP TRANSMISSION ON PRIMARY/SECONDARY RADIO
local function StopTransmission(type)
    if exports["soe-emergency"]:IsRestrained() or radioTimeout then return end

    local channel = radioChannel
    if (type == "Secondary") then
        channel = secondaryRadioChannel
    end

    if (channel > 0) and radioPressed then
        radioPressed = false

        -- GIVE A SMALL DELAY TO PREVENT ANY "CUT-OUTS"
        radioTimeout = true
        SetTimeout(350, function()
            radioTimeout = false
            MumbleClearVoiceTargetPlayers(1)
            UpdatePlayerTargets(NetworkIsPlayerTalking(PlayerId()) and callData or {})
	
            PlayMicClick(false, type)
            exports["soe-ui"]:SetTransmittingState(false, type)
            TriggerServerEvent("Voice:Server:SetTalkingOnRadio", false, type)

            exports["soe-emotes"]:EliminateAllProps()
            StopAnimTask(PlayerPedId(), "random@arrests", "generic_radio_chatter", -3.0)
            StopAnimTask(PlayerPedId(), "cellphone@", "cellphone_call_listen_base", -3.0)
            SendNUIMessage({type = "Radio.ModifyList", memberID = playerServerId, isTalking = false})
        end)
    end
end

-- WHEN TRIGGERED, START TRANSMISSION ON PRIMARY/SECONDARY RADIO
local function StartTransmission(type)
    if exports["soe-emergency"]:IsRestrained() or radioTimeout then return end

    local channel = radioChannel
    if (type == "Secondary") then
        channel = secondaryRadioChannel
    end

    --print(channel, type)
    if (channel > 0) and not radioPressed then
        --logger.info('[radio] Start broadcasting, update targets and notify server.')
        UpdatePlayerTargets(radioData, NetworkIsPlayerTalking(PlayerId()) and callData or {})

        TriggerServerEvent("Voice:Server:SetTalkingOnRadio", true, type)
        radioPressed = true
        PlayMicClick(true, type)

        exports["soe-ui"]:SetTransmittingState(true, type)
        local emote = PerformBroadcastingAnimation()

        SendNUIMessage({type = "Radio.ModifyList", memberID = playerServerId, isTalking = true})
        while radioPressed do
            Wait(3)
            -- ANIMATION CONTROL
            if (emote == "Shoulder Mic" and not IsEntityPlayingAnim(PlayerPedId(), "random@arrests", "generic_radio_chatter", 3)) then
                TaskPlayAnim(PlayerPedId(), "random@arrests", "generic_radio_chatter", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
            end

            if (emote == "Hold Radio" and not IsEntityPlayingAnim(PlayerPedId(), "cellphone@", "cellphone_call_listen_base", 3)) then
                exports["soe-emotes"]:StartEmote("radio2")
            end

            -- FORCE NORMAL PUSH TO TALK
            SetControlNormal(0, 249, 1.0)
            SetControlNormal(1, 249, 1.0)
            SetControlNormal(2, 249, 1.0)
        end
    end
end

-- WHEN TRIGGERED, SHOW RADIO UI
local function ShowRadio()
    SetNuiFocusKeepInput(true)
    SetNuiFocus(true, true)
    radioOpened = true

    -- PERFORM THE EMOTE AND TELL JAVASCRIPT TO OPEN UI
    exports["soe-emotes"]:StartEmote("radio")
    SendNUIMessage({type = "openRadio", channel = radioChannel})

    -- START A DISABLE CONTROLS LOOP
    while radioOpened do
        Wait(0)
        -- CAMERA CONTROL
        if disableCamera then
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
        end

        DisablePlayerFiring(PlayerId(), true)
        DisableControlAction(0, 24, true) -- ATTACK (L-CLICK)
        DisableControlAction(0, 25, true) -- AIM (R-CLICK)
        DisableControlAction(0, 68, true) -- ATTACK (L-CLICK)
        DisableControlAction(0, 69, true) -- AIM (R-CLICK)
        DisableControlAction(0, 70, true) -- AIM (R-CLICK)
        DisableControlAction(0, 91, true) -- AIM (R-CLICK)
        DisableControlAction(0, 92, true) -- AIM (R-CLICK)
        DisableControlAction(0, 114, true) -- AIM (R-CLICK)
        DisableControlAction(0, 330, true) -- AIM (R-CLICK)
        DisableControlAction(0, 331, true) -- AIM (R-CLICK)
        DisableControlAction(0, 347, true) -- AIM (R-CLICK)
        DisableControlAction(0, 245, true) -- OPEN CHAT (T)
        DisableControlAction(0, 199, true) -- PAUSE (P)
        DisableControlAction(0, 200, true) -- PAUSE (ESC)
        DisableControlAction(0, 12, true) -- PAUSE (ESC)
        DisableControlAction(0, 13, true) -- PAUSE (ESC)
        DisableControlAction(0, 14, true) -- PAUSE (ESC)
        DisableControlAction(0, 15, true) -- PAUSE (ESC)
        DisableControlAction(0, 16, true) -- PAUSE (ESC)
        DisableControlAction(0, 17, true) -- PAUSE (ESC)
        DisableControlAction(0, 210, true) -- L CTRL
    end
end

-- **********************
--    Global Functions
-- **********************
function UnsubscribeFromRadioChannel(type)
    SetRadioChannel(0, type)
end

function SetTalkingOnRadio(src, enabled, type)
    --print("SetTalkingOnRadio:", "| SRC:", src, "| ENABLED:", enabled, "| TYPE:", type)
    ToggleMyVoice(src, enabled, "radio")
    radioData[src] = enabled

    PlayMicClick(enabled, type)
    SendNUIMessage({type = "Radio.ModifyList", memberID = src, isTalking = enabled})
end

function SubscribeToRadioChannel(channel, type)
    channel = tonumber(channel)
    if channel then
        SetRadioChannel(channel, type)
    end
end

function SetRadioChannel(channel, type)
    if not type then return end
    TriggerServerEvent("Voice:Server:SetPlayerRadioChannel", channel, type)

    if (type == "Primary") then
        LocalPlayer.state:set("radioChannel", channel, GetConvarInt("voice_syncData", 1) == 1)
        radioChannel = channel
    elseif (type == "Secondary") then
        LocalPlayer.state:set("secondaryRadioChannel", channel, GetConvarInt("voice_syncData", 1) == 1)
        secondaryRadioChannel = channel
    end

    if (radioChannel > 0) then
        local char = exports["soe-uchuu"]:GetPlayer()
        local name = char.JobTitle .. " " .. char.FirstGiven:sub(0, 1) .. ". " .. char.LastGiven
        TriggerEvent("Voice:Client:AddToRadioList", channel, name)
    else
        SendNUIMessage({type = "Radio.ClearList"})
        SendNUIMessage({type = "Radio.ModifyList", frequency = channel})
        exports["soe-ui"]:SendAlert("warning", ("Disconnected %s Frequency"):format(type), 1500)
    end
end

function SyncRadio(_radioChannel, type)
    if not type then return end

    if (type == "Primary") then
        --logger.info("[radio] radio set serverside update to radio %s", radioChannel)
        LocalPlayer.state:set("radioChannel", _radioChannel, GetConvarInt("voice_syncData", 1) == 1)
        radioChannel = _radioChannel
    elseif (type == "Secondary") then
        --logger.info("[radio] radio set serverside update to radio %s", secondaryRadioChannel)
        LocalPlayer.state:set("secondaryRadioChannel", _radioChannel, GetConvarInt("voice_syncData", 1) == 1)
        secondaryRadioChannel = _radioChannel
    end
end

function AddPlayerToRadio(src, name)
    radioData[src] = false
    SendNUIMessage({type = "Radio.ModifyList", memberID = src, memberName = name})

    if radioPressed then
        --logger.info("[radio] %s joined radio %s while we were talking, adding them to targets", src, radioChannel)
        UpdatePlayerTargets(radioData, NetworkIsPlayerTalking(PlayerId()) and callData or {})
    --[[else
        logger.info("[radio] %s joined radio %s", src, radioChannel)]]
    end
end

function SyncRadioData(radioTable)
    radioData = radioTable
    --[[logger.info('[radio] Syncing radio table.')
    print('-------- RADIO TABLE --------')
    tPrint(radioData)
    print('-----------------------------')]]

    for tgt, enabled in pairs(radioTable) do
        if (tgt ~= playerServerId) then
            --print(json.encode(enabled))
            ToggleMyVoice(tgt, enabled.status, 'radio')
            SendNUIMessage({type = "Radio.ModifyList", memberID = tgt, memberName = enabled.name})
            SendNUIMessage({type = "Radio.ModifyList", memberID = tgt, isTalking = enabled.status})
        end
    end
end

-- PLAYS MIC CLICKS ON RADIO PTT
function PlayMicClick(value, type)
    if micClicks then
        -- MIC CLICK VARIANT CONTROL
        local sound = micClickVariants_ON[currentMicClick[type].on] or micClickVariants_ON[1]
        if not value then
            sound = micClickVariants_OFF[currentMicClick[type].off] or micClickVariants_OFF[1]
        end

        -- SEND JAVASCRIPT WHICH VARIANT TO PLAY
        SendNUIMessage({type = "playMicClick", sound = sound, volume = micClickVolume})
    end
end

function RemovePlayerFromRadio(src, type)
    if not type then return end
    if (src == playerServerId) then
        --[[if (type == "Primary") then
            logger.info('[radio] Left primary radio %s, cleaning up.', radioChannel)
        elseif (type == "Secondary") then
            logger.info('[radio] Left secondary radio %s, cleaning up.', secondaryRadioChannel)
        end]]

        for tgt in pairs(radioData) do
            if (tgt ~= playerServerId) then
                ToggleMyVoice(tgt, false, "radio")
            end
        end

        radioData = {}
        SendNUIMessage({type = "Radio.ModifyList", memberID = playerServerId, remove = true})
        UpdatePlayerTargets(NetworkIsPlayerTalking(PlayerId()) and callData or {})

        if (type == "Primary") then
            LocalPlayer.state:set('radioChannel', 0, GetConvarInt('voice_syncData', 0) == 1)
        elseif (type == "Secondary") then
            LocalPlayer.state:set('secondaryRadioChannel', 0, GetConvarInt('voice_syncData', 0) == 1)
        end
    else
        radioData[src] = nil
		ToggleMyVoice(src, false)
        SendNUIMessage({type = "Radio.ModifyList", memberID = src, remove = true})
		if radioPressed then
			--[[if (type == "Primary") then
				logger.info('[radio] %s left primary radio %s while we were talking, updating targets.', src, radioChannel)
			elseif (type == "Secondary") then
				logger.info('[radio] %s left secondary radio %s while we were talking, updating targets.', src, secondaryRadioChannel)
			end]]

			UpdatePlayerTargets(radioData, NetworkIsPlayerTalking(PlayerId()) and callData or {})
		--[[else
			if (type == "Primary") then
				logger.info('[radio] %s has left primary radio %s', src, radioChannel)
			elseif (type == "Secondary") then
				logger.info('[radio] %s has left secondary radio %s', src, secondaryRadioChannel)
			end]]
		end
	end
end

-- **********************
--        Commands
-- **********************
-- WHEN TRIGGERED, STOP TALKING ON PRIMARY RADIO
RegisterCommand("-radiotalk", function()
    StopTransmission("Primary")
end)

-- WHEN TRIGGERED, BEGIN TALKING ON PRIMARY RADIO
RegisterCommand("+radiotalk", function()
    StartTransmission("Primary")
end)

-- WHEN TRIGGERED, STOP TALKING ON SECONDARY RADIO
RegisterCommand("-secondaryradiotalk", function()
    StopTransmission("Secondary")
end)

-- WHEN TRIGGERED, BEGIN TALKING ON SECONDARY RADIO
RegisterCommand("+secondaryradiotalk", function()
    StartTransmission("Secondary")
end)

-- WHEN TRIGGERED, UN-TOGGLE THE CAMERA MOVEMENT WHILST RADIO IS OPEN
RegisterCommand("-toggleradiocam", function()
    if not radioOpened then return end
    disableCamera = true
end)

-- WHEN TRIGGERED, TOGGLE THE CAMERA MOVEMENT WHILST RADIO IS OPEN
RegisterCommand("+toggleradiocam", function()
    if not radioOpened then return end
    disableCamera = false
end)

-- WHEN TRIGGERED, BRING UP RADIO UI
RegisterCommand("radio", function()
    if exports["soe-emergency"]:IsRestrained() then return end
    if exports["soe-inventory"]:HasInventoryItem("radio") then
        ShowRadio()
    else
        exports["soe-ui"]:SendAlert("error", "You do not have a radio", 5000)
    end
end)

-- **********************
--     NUI Callbacks
-- **********************
-- WHEN TRIGGERED, RESET NUI FOCUS AND CANCEL EMOTE
RegisterNUICallback("Radio.CloseUI", function()
    SetNuiFocusKeepInput(false)
    SetNuiFocus(false, false)

    StopAnimTask(PlayerPedId(), "cellphone@", "cellphone_text_in", 2.5)
    exports["soe-emotes"]:EliminateAllProps()

    Wait(250)
    radioOpened = false
end)

-- WHEN TRIGGERED, TOGGLE POWER OF THE RADIO
RegisterNUICallback("Radio.TogglePower", function(data)
    if data.power then
        exports["soe-utils"]:PlayProximitySound(3.3, "radio-on.ogg", 0.25)
    else
        SetRadioChannel(0, "Primary")
        SetRadioChannel(0, "Secondary")
        exports["soe-utils"]:PlayProximitySound(3.0, "radio_off.ogg", 0.5)
    end
end)

-- WHEN TRIGGERED, TOGGLE MIC CLICKS FOR RADIO
RegisterNUICallback("Radio.ToggleMicClicks", function()
    micClicks = not micClicks
    if not micClicks then
        exports["soe-ui"]:SendAlert("inform", "Mic Clicks: Off", 2500)
        exports["soe-uchuu"]:UpdateSettings("radio_MicClicks", false, false)
    else
        exports["soe-ui"]:SendAlert("inform", "Mic Clicks: On", 2500)
        exports["soe-uchuu"]:UpdateSettings("radio_MicClicks", false, true)
    end
    exports["soe-utils"]:PlayProximitySound(3.0, "radio-buttonclick.ogg", 0.45)
end)

-- WHEN TRIGGERED, TOGGLE SUBMIX FOR RADIO
RegisterNUICallback("Radio.ToggleSubmix", function()
    submixToggle = not submixToggle
    if not submixToggle then
        exports["soe-ui"]:SendAlert("inform", "Submix: Off", 2500)
        exports["soe-uchuu"]:UpdateSettings("radio_Submix", false, false)
    else
        exports["soe-ui"]:SendAlert("inform", "Submix: On", 2500)
        exports["soe-uchuu"]:UpdateSettings("radio_Submix", false, true)
    end
    exports["soe-utils"]:PlayProximitySound(3.0, "radio-buttonclick.ogg", 0.45)
end)

-- WHEN TRIGGERED, CHANGE MIC CLICK VOLUME
RegisterNUICallback("Radio.ModifyClickVolume", function(data)
    if (data.state == "increase") then
        micClickVolume = micClickVolume + 0.1
        exports["soe-ui"]:SendAlert("inform", "Increasing Clicks Volume: " .. micClickVolume, 4500)
    elseif (data.state == "decrease") then
        micClickVolume = micClickVolume - 0.1
        exports["soe-ui"]:SendAlert("inform", "Decreasing Clicks Volume: " .. micClickVolume, 4500)
    elseif (data.state == "reset") then
        micClickVolume = 0.1
        exports["soe-ui"]:SendAlert("inform", "Reset Clicks Volume Back To: 0.1", 4500)
    end

    if (micClickVolume <= 0.0) then
        micClickVolume = 0.0
    end
    exports["soe-uchuu"]:UpdateSettings("radio_ClickVolume", false, micClickVolume)
    exports["soe-utils"]:PlayProximitySound(3.0, "radio-buttonclick.ogg", 0.45)
end)

-- WHEN TRIGGERED, CHANGE RADIO VOLUME
RegisterNUICallback("Radio.ModifyVolume", function(data)
    local newRadioVolume
    local radioVol = GetRadioVolume()
    if (data.state == "increase") then
        newRadioVolume = radioVol + 0.1
        exports["soe-ui"]:SendAlert("inform", "Increasing Volume: " .. newRadioVolume, 4500)
    elseif (data.state == "decrease") then
        newRadioVolume = radioVol - 0.1
        exports["soe-ui"]:SendAlert("inform", "Decreasing Volume: " .. newRadioVolume, 4500)
    elseif (data.state == "reset") then
        newRadioVolume = 0.3
        exports["soe-ui"]:SendAlert("inform", "Reset Volume Back To: 0.3", 4500)
    end

    if (newRadioVolume <= 0.0) then
        newRadioVolume = 0.0
    end
    radioVol = newRadioVolume
    SetRadioVolume(radioVol)

    exports["soe-uchuu"]:UpdateSettings("radio_Volume", false, radioVol)
    exports["soe-utils"]:PlayProximitySound(3.0, "radio-buttonclick.ogg", 0.45)
end)

-- WHEN TRIGGERED, CHANGE RADIO CHANNEL
RegisterNUICallback("Radio.SetChannel", function(data)
    if not data.powered then
        exports["soe-ui"]:SendAlert("error", "The radio is not on", 4500)
        return
    end

    local newChannel = tonumber(data.channel)
    if (newChannel == nil) then
        newChannel = 0
    end

    -- SPECIFIED CHANNEL IS OVER 1000 | DO NOT ALLOW
    if (newChannel > 1000) then
        exports["soe-ui"]:SendAlert("error", "Could not tune into that channel", 4500)
        return
    end

    if (newChannel == 0) then
        SetRadioChannel(0, data.type)
    else
        SetMyChannel(newChannel, data.type)
    end
    exports["soe-utils"]:PlayProximitySound(3.0, "radio-buttonclick.ogg", 0.45)
end)

-- WHEN TRIGGERED, CHANGE MIC CLICK VARIANT
RegisterNUICallback("Radio.ChangeClickVariant", function(data)
    if (data.type == "Off") then
        currentMicClick[data.channelType].off = currentMicClick[data.channelType].off + 1
        if (currentMicClick[data.channelType].off > #micClickVariants_OFF) then
            currentMicClick[data.channelType].off = 1
        end

        if (data.channelType == "Primary") then
            exports["soe-uchuu"]:UpdateSettings("radio_OffClickVariant", false, currentMicClick[data.channelType].off)
        elseif (data.channelType == "Secondary") then
            exports["soe-uchuu"]:UpdateSettings("radio_OffClickVariant2", false, currentMicClick[data.channelType].off)
        end
        exports["soe-ui"]:SendAlert("inform", ("%s Off Click Variant: %s/%s"):format(data.channelType, currentMicClick[data.channelType].off, #micClickVariants_OFF), 2500)
    elseif (data.type == "On") then
        currentMicClick[data.channelType].on = currentMicClick[data.channelType].on + 1
        if (currentMicClick[data.channelType].on > #micClickVariants_ON) then
            currentMicClick[data.channelType].on = 1
        end

        if (data.channelType == "Primary") then
            exports["soe-uchuu"]:UpdateSettings("radio_OnClickVariant", false, currentMicClick[data.channelType].on)
        elseif (data.channelType == "Secondary") then
            exports["soe-uchuu"]:UpdateSettings("radio_OnClickVariant2", false, currentMicClick[data.channelType].on)
        end
        exports["soe-ui"]:SendAlert("inform", ("%s On Click Variant: %s/%s"):format(data.channelType, currentMicClick[data.channelType].on, #micClickVariants_ON), 2500)
    end
    exports["soe-utils"]:PlayProximitySound(3.0, "radio-buttonclick.ogg", 0.45)
end)

-- **********************
--     	  Events
-- **********************
RegisterNetEvent("Voice:Client:SetPlayerRadio", SyncRadio)

RegisterNetEvent("Voice:Client:SyncRadioData", SyncRadioData)

RegisterNetEvent("Voice:Client:AddPlayerToRadio", AddPlayerToRadio)

RegisterNetEvent("Voice:Client:SetTalkingOnRadio", SetTalkingOnRadio)

RegisterNetEvent("Voice:Client:RemovePlayerFromRadio", RemovePlayerFromRadio)

-- WHEN TRIGGERED, RESET ALL NUI INSTANCES
AddEventHandler("UI:Client:ResetNUI", function()
    SendNUIMessage({type = "Radio.ResetUI"})
end)

-- WHEN TRIGGERED, ADD TO RADIO LIST
AddEventHandler("Voice:Client:AddToRadioList", function(channel, name)
    SendNUIMessage({type = "Radio.ClearList"})
    Wait(800)
    SendNUIMessage({type = "Radio.ModifyList", memberID = playerServerId, frequency = channel, memberName = name, self = true})
end)

-- WHEN TRIGGERED, TRANSFER SAVED RADIO SETTINGS DATA FROM DATABASE
AddEventHandler("Uchuu:Client:CharacterSelected", function()
    Wait(3500)
    local settings = exports["soe-uchuu"]:GetPlayer().Settings
    if (type(settings) == "string") then
        settings = json.decode(exports["soe-uchuu"]:GetPlayer().Settings)
    end

    if (settings["radio_Volume"] ~= nil) then
        SetRadioVolume(tonumber(settings["radio_Volume"]) or 0.3)
    end

    if (settings["radio_ClickVolume"] ~= nil) then
        micClickVolume = tonumber(settings["radio_ClickVolume"]) or 0.1
    end

    if (settings["radio_OnClickVariant"] ~= nil) then
        currentMicClick["Primary"].on = tonumber(settings["radio_OnClickVariant"]) or 1
    end

    if (settings["radio_OffClickVariant"] ~= nil) then
        currentMicClick["Primary"].off = tonumber(settings["radio_OffClickVariant"]) or 1
    end

    if (settings["radio_OnClickVariant2"] ~= nil) then
        currentMicClick["Secondary"].on = tonumber(settings["radio_OnClickVariant2"]) or 1
    end

    if (settings["radio_OffClickVariant2"] ~= nil) then
        currentMicClick["Secondary"].off = tonumber(settings["radio_OffClickVariant2"]) or 1
    end

    -- FOR SOME REASON MIC CLICKS RETURNS AS A STRING INSTEAD OF A BOOLEAN
    local clicks = settings["radio_MicClicks"]
    if (clicks ~= nil) then
        local _micClicks = true
        if (type(clicks) == "string" and clicks == "false") then
            _micClicks = false
        end
        micClicks = _micClicks
    end

    -- FOR SOME REASON SUBMIX TOGGLE RETURNS AS A STRING INSTEAD OF A BOOLEAN
    local submix = settings["radio_Submix"]
    if (submix ~= nil) then
        local _submix = true
        if (type(submix) == "string" and submix == "false") then
            _submix = false
        end
        submixToggle = _submix
    end
end)
