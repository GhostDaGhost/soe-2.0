local callChannel = 0

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, CREATE A TALLKING ON PHONE THREAD
local function CreatePhoneThread()
	CreateThread(function()
		local changed = false
		while (callChannel ~= 0) do
			if NetworkIsPlayerTalking(PlayerId()) and not changed then
				changed = true
				UpdatePlayerTargets(radioPressed and radioData or {}, callData)
				TriggerServerEvent("Voice:Server:SetTalkingOnCall", true)
			elseif changed and NetworkIsPlayerTalking(PlayerId()) ~= 1 then
				changed = false
				MumbleClearVoiceTargetPlayers(1)
				TriggerServerEvent("Voice:Server:SetTalkingOnCall", false)
			end
			Wait(0)
		end
	end)
end

-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, RESET CALL CHANNEL
function RemovePlayerFromCall()
	SetCallChannel(0)
end

-- WHEN TRIGGERED, ADD TO CALL CHANNEL
function AddPlayerToCall(channel)
	channel = tonumber(channel)
	if channel then
		SetCallChannel(channel)
	end
end

-- WHEN TRIGGERED, SET CALL CHANNEL
function SetCallChannel(channel)
	TriggerServerEvent("Voice:Server:SetPlayerCallChannel", channel)
	callChannel = channel

	LocalPlayer.state:set("callChannel", channel, GetConvarInt("voice_syncData", 1) == 1)
	CreatePhoneThread()
end

-- **********************
--    	  Events
-- **********************
RegisterNetEvent("Voice:Client:AddPlayerToCall", function(src)
	callData[src] = false
end)

RegisterNetEvent("Voice:Client:SetPlayerToCall", function(_callChannel)
	callChannel = _callChannel
	LocalPlayer.state:set("callChannel", _callChannel, GetConvarInt("voice_syncData", 1) == 1)
	CreatePhoneThread()
end)

RegisterNetEvent("Voice:Client:SetTalkingOnCall", function(tgt, enabled)
	if (tgt ~= playerServerId) then
		callData[tgt] = enabled
		ToggleMyVoice(tgt, enabled, 'phone')
	end
end)

RegisterNetEvent("Voice:Client:SyncCallData", function(callTable, channel)
	callData = callTable
	for tgt, enabled in pairs(callTable) do
		if (tgt ~= playerServerId) then
			ToggleMyVoice(tgt, enabled, "phone")
		end
	end
end)

RegisterNetEvent("Voice:Client:RemovePlayerFromCall", function(src)
	if (src == playerServerId) then
		for tgt in pairs(callData) do
			if (tgt ~= playerServerId) then
				ToggleMyVoice(tgt, false, "phone")
			end
		end
		callData = {}

		MumbleClearVoiceTargetPlayers(1)
		UpdatePlayerTargets(radioPressed and radioData or {}, callData)
		LocalPlayer.state:set("callChannel", 0, GetConvarInt("voice_syncData", 1) == 1)
	else
		callData[src] = nil
		ToggleMyVoice(src, false, "phone")

		if NetworkIsPlayerTalking(PlayerId()) then
			MumbleClearVoiceTargetPlayers(1)
			UpdatePlayerTargets(radioPressed and radioData or {}, callData)
		end
	end
end)
