-- RADIO SUBMIX SETTINGS
local radioEffectID = CreateAudioSubmix("Radio")
SetAudioSubmixEffectRadioFx(radioEffectID, 0)
SetAudioSubmixEffectParamInt(radioEffectID, 0, GetHashKey("default"), 1)
AddAudioSubmixOutput(radioEffectID, 0)

-- PHONE SUBMIX SETTINGS
local phoneEffectID = CreateAudioSubmix("Phone")
SetAudioSubmixEffectRadioFx(phoneEffectID, 1)
SetAudioSubmixEffectParamInt(phoneEffectID, 1, GetHashKey("default"), 1)
SetAudioSubmixEffectParamFloat(phoneEffectID, 1, GetHashKey("freq_low"), 300.0)
SetAudioSubmixEffectParamFloat(phoneEffectID, 1, GetHashKey("freq_hi"), 6000.0)
AddAudioSubmixOutput(phoneEffectID, 1)

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, OPEN RADIOFX SETTINGS UI
--[[local function RadioFXConfig()
	SetNuiFocus(true, true)
	SendNUIMessage({type = "openRadioFXConfig"})
end]]

-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, ENABLE A SUBMIX DEPENDING ON THE TYPE
submixFunctions = {
	["radio"] = function(src)
		MumbleSetSubmixForServerId(src, radioEffectID)
	end,
	["phone"] = function(src)
		MumbleSetSubmixForServerId(src, phoneEffectID)
	end
}

-- **********************
--     NUI Callbacks
-- **********************
-- WHEN TRIGGERED, DO CLOSING TASKS IF RADIOFX UI IS CLOSED
--[[RegisterNUICallback("RadioFX.CloseUI", function()
	SetNuiFocus(false, false)
end)

-- WHEN TRIGGERED, SAVE RADIOFX SETTINGS FROM JAVASCRIPT
RegisterNUICallback("RadioFX.SaveSettings", function(data)
	print(json.encode(data))
	print(type(data.lowFreq), type(data.highFreq))

	if data.lowFreq then
		print("lowFreq:", data.lowFreq)
		SetAudioSubmixEffectParamFloat(radioEffectID, 0, GetHashKey("freq_low"), tonumber(data.lowFreq))
	end

	if data.highFreq then
		print("lowFreq:", data.highFreq)
		SetAudioSubmixEffectParamFloat(radioEffectID, 0, GetHashKey("freq_hi"), tonumber(data.highFreq))
	end

	if data.fudge then
		print("fudge:", data.fudge)
		SetAudioSubmixEffectParamFloat(radioEffectID, 0, GetHashKey("fudge"), tonumber(data.fudge))
	end
	exports["soe-ui"]:SendAlert("debug", "RadioFX settings updated!", 2000)
end)

-- **********************
--         Events
-- **********************
-- WHEN TRIGGERED, OPEN RADIOFX SETTINGS UI
RegisterNetEvent("Voice:Client:RadioFXConfig", RadioFXConfig)]]
