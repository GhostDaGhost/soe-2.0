local mutedTbl = {}
local voipWarnings = {}
local currentRouting = 0
local disableSubmixReset = {}
local lastGridChange, nextRoutingRefresh = GetGameTimer(), GetGameTimer()

callData = {}
radioData = {}
currentGrid = 0
radioPressed, mode = false, 2
playerServerId = GetPlayerServerId(PlayerId())

-- KEY MAPPINGS
RegisterKeyMapping("cycleproximity", "[Voice] Cycle Proximity", "KEYBOARD", "DELETE")

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, GET MAX GRID SIZE
local function GetMaxSize(zoneRadius)
	return math.floor(math.max(4500.0 + 8192.0, 0.0) / zoneRadius + math.max(8022.0 + 8192.0, 0.0) / zoneRadius)
end

-- WHEN TRIGGERED, RETURNS CURRENT GRID ZONE
local function GetGridZone()
	local zoneRadius = 256
	local pos = GetEntityCoords(PlayerPedId())
	if (nextRoutingRefresh < GetGameTimer()) then
		nextRoutingRefresh = GetGameTimer() + 500
		currentRouting = LocalPlayer.state.routingBucket or 0
	end

	local sectorX = math.max(pos.x + 8192.0, 0.0) / zoneRadius
	local sectorY = math.max(pos.y + 8192.0, 0.0) / zoneRadius
	return (math.ceil(sectorX + sectorY) + (currentRouting * GetMaxSize(zoneRadius)))
end

-- WHEN TRIGGERED, CYCLE VOICE PROXIMITY
local function CycleVoiceProximity()
	local voiceMode = mode
	local newMode = voiceMode + 1
	voiceMode = (newMode <= #voiceRanges and newMode) or 1
	local voiceModeData = voiceRanges[voiceMode]

	-- CHECK IF RANGE CAN BE ALTERED WHEN INSIDE VEHICLE AND DOING CERTAIN THINGS
	if rangeChangeCheckInsideVehicle then
		local veh = GetVehiclePedIsIn(PlayerPedId(), false)
		if (veh ~= 0) and not AllowRangeChange(veh) then
			voiceMode = 1 -- WHISPER
			voiceModeData = voiceRanges[voiceMode]
		end
	end

	MumbleSetAudioInputDistance(voiceModeData[1] + 0.0)
	mode = voiceMode
	LocalPlayer.state:set("proximity", {
		index = voiceMode,
		distance =  voiceModeData[1],
		mode = voiceModeData[2],
	}, GetConvarInt("voice_syncData", 1) == 1)

	exports["soe-ui"]:SetVoiceRangeState(voiceMode)
end

-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, RETURN PHONE VOLUME
function GetCallVolume()
	return volumes["phone"]
end

-- WHEN TRIGGERED, RETURN RADIO VOLUME
function GetRadioVolume()
	return volumes["radio"]
end

-- WHEN TRIGGERED, SET PHONE VOLUME
function SetCallVolume(vol)
	SetPlayerVolume(vol, "phone")
end

-- WHEN TRIGGERED, SET RADIO VOLUME
function SetRadioVolume(vol)
	SetPlayerVolume(vol, "radio")
end

-- WHEN TRIGGERED, TOGGLE MUTE OF A SELECTED SERVER ID
function ToggleMutePlayer(src)
	if mutedTbl[src] then
		mutedTbl[src] = nil
		MumbleSetVolumeOverrideByServerId(src, -1.0)
	else
		mutedTbl[src] = true
		MumbleSetVolumeOverrideByServerId(src, 0.0)
	end
end

-- WHEN TRIGGERED, SET THE PLAYER'S VOLUME
function SetPlayerVolume(volume, volumeType)
	local volume = tonumber(volume)
	local checkType = type(volume)
	if (checkType ~= "number") then
		return error("SetPlayerVolume expected type number, got " .. checkType)
	end

	if volumeType then
		if volumes[volumeType] then
			LocalPlayer.state:set(volumeType, volume, GetConvarInt("voice_syncData", 1) == 1)
			volumes[volumeType] = volume
		else
			error("SetPlayerVolume got a invalid volume type " .. volumeType)
		end
	else
		for types in pairs(volumes) do
			volumes[types] = volume
			LocalPlayer.state:set(types, volume, GetConvarInt("voice_syncData", 1) == 1)
		end
	end
end

function UpdatePlayerTargets(...)
	local targets = {...}
	local addedPlayers = {[playerServerId] = true}

	--print("UpdatePlayerTargets:", ...)
	for i = 1, #targets do
		for id in pairs(targets[i]) do
			if addedPlayers[id] and id ~= playerServerId then
				--logger.verbose("[main] %s is already target don\'t re-add", id)
				goto skip_loop
			end

			if not addedPlayers[id] then
				--logger.verbose("[main] Adding %s as a voice target", id)
				addedPlayers[id] = true
				MumbleAddVoiceTargetPlayerByServerId(1, id)
			end
			::skip_loop::
		end
	end
end

function ToggleMyVoice(src, enabled, moduleType)
	--logger.verbose("[main] Updating %s to talking: %s with submix %s", src, enabled, moduleType)
	if enabled then
		MumbleSetVolumeOverrideByServerId(src, enabled and volumes[moduleType])
		if moduleType then
			if (moduleType == "radio" and not submixToggle) then
				return
			end

			disableSubmixReset[src] = true
			submixFunctions[moduleType](src)
		else
			MumbleSetSubmixForServerId(src, -1)
		end
	else
		disableSubmixReset[src] = nil
		SetTimeout(250, function()
			if not disableSubmixReset[src] then
				MumbleSetSubmixForServerId(src, -1)
			end
		end)
		MumbleSetVolumeOverrideByServerId(src, -1.0)
	end
end

function UpdateMyZone(forced)
	local newGrid = GetGridZone()
	if newGrid ~= currentGrid or forced then
		--[[logger.verbose("Time since last grid change: %s", (GetGameTimer() - lastGridChange) / 1000)
		logger.info("Updating zone from %s to %s and adding nearby grids, was forced: %s", currentGrid, newGrid, forced)]]
		lastGridChange = GetGameTimer()

		currentGrid = newGrid
		MumbleClearVoiceTargetChannels(1)
		NetworkSetVoiceChannel(currentGrid)
		LocalPlayer.state:set("grid", currentGrid, true)

		for nearbyGrids = currentGrid - 3, currentGrid + 3 do
			MumbleAddVoiceTargetChannel(1, nearbyGrids)
		end
	end
end

-- CHECKS MICROPHONE AND AUDIO SETTINGS TO SEE IF THEY ARE WORKING CORRECTLY
function CheckVoiceSetting(type)
	local setting = GetConvarInt(type, -1)

	if not voipWarnings[type] then
		if (setting == 0) then
			voipWarnings[type] = true

			local msg = "VOIP issues detected! Try relogging or check your voice settings."
			if (type == "profile_voiceEnable") then
				msg = "Our VOIP has detected that your voice chat is disabled. Make sure to enable this in your settings!"
			elseif (type == "profile_voiceTalkEnabled") then
				msg = "Our VOIP has detected that your microphone is disabled. Make sure to enable this in your settings!"
			elseif (type == "profile_voiceChatMode") then
				msg = "Our VOIP has detected that you aren't using Push To Talk. Make sure to switch to this in your settings!"
			end
			exports["soe-ui"]:PersistentAlert("start", "voipWarning_" .. type, "error", msg, 5)

			CreateThread(function()
				while (GetConvarInt(type, -1) == 0) do
					Wait(1000)
				end

				voipWarnings[type] = false
				exports["soe-ui"]:PersistentAlert("end", "voipWarning_" .. type)
			end)
		end
	end
	return (setting == 1)
end

-- **********************
--    	 Commands
-- **********************
-- WHEN TRIGGERED, CYCLE VOICE PROXIMITY
RegisterCommand("cycleproximity", CycleVoiceProximity)

-- WHEN TRIGGERED, PRINT OUT CURRENT GRID
RegisterCommand("grid", function()
    print("My current grid is:", currentGrid)
end)

--[[RegisterCommand("vol", function(source, args) NEEDS TESTING
    if not args[1] then return end
    local volume = tonumber(args[1])
    if volume then
        SetPlayerVolume(volume / 100)
    end
end)]]

-- WHEN TRIGGERED, ATTEMPT RESYNC WITH MUMBLE
RegisterCommand("vsync", function()
	local newGrid = GetGridZone()
	print(("[vsync] Forcing zone from %s to %s and resetting voice targets."):format(currentGrid, newGrid))

	NetworkSetVoiceChannel(newGrid + 100)
	MumbleSetVoiceTarget(0)
	MumbleClearVoiceTarget(1)
	MumbleSetVoiceTarget(1)
	MumbleClearVoiceTargetPlayers(1)
	UpdateMyZone(true)
end)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, RESET GRID
AddEventHandler("mumbleDisconnected", function()
	currentGrid = -1
end)

-- WHEN TRIGGERED, RESET GRID
AddEventHandler("mumbleConnected", function(address, shouldReconnect)
	logger.log("Connected to mumble server with address of %s, should reconnect on disconnect is set to %s", GetConvarInt("voice_hideEndpoints", 1) == 1 and "HIDDEN" or address, shouldReconnect)
	Wait(1000)
	UpdateMyZone(true)
end)

-- WHEN TRIGGERED, PERFORM SCRIPT INITIALIZATION PROCEDURES
AddEventHandler("onClientResourceStart", function(resource)
	if (GetCurrentResourceName() ~= resource) then return end
	print("Starting script initialization.")

	-- SET HOW FAR A PLAYER CAN TALK
	local voiceModeData = voiceRanges[mode]
	MumbleSetAudioInputDistance(voiceModeData[1] + 0.0)
	LocalPlayer.state:set("proximity", {
		index = mode,
		distance =  voiceModeData[1],
		mode = voiceModeData[2],
	}, GetConvarInt("voice_syncData", 1) == 1)

	-- SET HOW FAR A PLAYER CAN HEAR
	MumbleSetAudioOutputDistance(voiceRanges[#voiceRanges][1] + 0.0)
	while not MumbleIsConnected() do
		Wait(250)
	end

	MumbleSetVoiceTarget(0)
	MumbleClearVoiceTarget(1)
	MumbleSetVoiceTarget(1)

	UpdateMyZone()
	print("Script initialization finished.")
end)
