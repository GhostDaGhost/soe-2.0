-- CHECK IF ABLE TO CHANGE RANGE WITHIN VEHICLE | WIP
rangeChangeCheckInsideVehicle = false

-- LIST OF USABLE 'ON' MIC CLICKS
micClickVariants_ON = {"audio_on1", "audio_on2", "audio_on3", "audio_on4", "audio_on5"}

-- LIST OF USABLE 'OFF' MIC CLICKS
micClickVariants_OFF = {"audio_off1", "audio_off2", "audio_off3", "audio_off4", "audio_off5", "audio_off6", "audio_off7"}

-- VOIP RANGE DISTANCE AND LABELS
voiceRanges = {
	{1.8, "Whisper"}, -- Whisper speech distance in gta distance units
	{8.0, "Normal"}, -- Normal speech distance in gta distance units
	{14.0, "Shouting"} -- Shout speech distance in gta distance units
}

-- CURRENT RADIO/PHONE VOLUMES
volumes = {
	["radio"] = 0.3,
	["phone"] = 0.3
}

-- CURRENT MIC CLICKS
currentMicClick = {
	["Primary"] = {on = 1, off = 1},
	["Secondary"] = {on = 1, off = 1}
}

-- RADIO ANIMATIONS
radioAnimations = {
	["Hold Radio"] = {dict = nil, anim = "radio2"}, -- USE SOE-EMOTES FOR THIS ONE
	["Shoulder Mic"] = {dict = "random@arrests", anim = "generic_radio_chatter"}
}

-- LIST OF RESTRICTED RADIO CHANNELS
restrictedRadioChannels = {
	[1] = true, -- COMBINED OPS
	[2] = true, -- LEO OPS
	[3] = true, -- EMS OPS
	[4] = true, -- TAC OPS
	[6] = true,
	[7] = true,
	[8] = true,
	[9] = true,
	[10] = true
}
