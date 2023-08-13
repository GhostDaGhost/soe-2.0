-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, REMOVE PLAYER FROM ANY RADIO CHANNEL
function RemovePlayerFromRadio(src, radioChannel, type)
	--logger.info("[radio] Removed %s from %s Radio %s", src, type, radioChannel)

	radioData[radioChannel] = radioData[radioChannel] or {}
	for player in pairs(radioData[radioChannel]) do
		TriggerClientEvent("Voice:Client:RemovePlayerFromRadio", player, src, type)
	end

	radioData[radioChannel][src] = nil
	voiceData[src] = voiceData[src] or ResetDataTables(src)

	if (type == "Primary") then
		voiceData[src].radio = 0
	elseif (type == "Secondary") then
		voiceData[src].secondaryRadio = 0
	end
end

-- WHEN TRIGGERED, ADD PLAYER TO A RADIO CHANNEL
function AddPlayerToRadio(src, radioChannel, type)
	--logger.info("[radio] Added %s to %s Radio %s", src, type, radioChannel)

	radioData[radioChannel] = radioData[radioChannel] or {}
	local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
	local name = char.JobTitle .. " " .. char.FirstGiven:sub(0, 1) .. ". " .. char.LastGiven

	for player in pairs(radioData[radioChannel]) do
		TriggerClientEvent("Voice:Client:AddPlayerToRadio", player, src, name)
	end
	voiceData[src] = voiceData[src] or ResetDataTables(src)

	if (type == "Primary") then
		voiceData[src].radio = radioChannel
	elseif (type == "Secondary") then
		voiceData[src].secondaryRadio = radioChannel
	end

	radioData[radioChannel][src] = {status = false, type = type, name = name}
	TriggerClientEvent("Voice:Client:SyncRadioData", src, radioData[radioChannel])
end

-- WHEN TRIGGERED, SET PLAYER TO A RADIO CHANNEL
function SetPlayerRadioChannel(src, radioChannel, type)
	if not type then return end
	if GetInvokingResource() then
		TriggerClientEvent("Voice:Client:SetPlayerRadio", src, radioChannel, type)
	end

	voiceData[src] = voiceData[src] or ResetDataTables(src)
	local plyVoice = voiceData[src]

	local radioChannel = tonumber(radioChannel)
	if not radioChannel then
		error(("radioChannel was not a number. Got: %s Expected: Number"):format(type(radioChannel)))
		return
	end

	local targetRadio = plyVoice.radio
	if (type == "Secondary") then
		targetRadio = plyVoice.secondaryRadio
	end

	if (radioChannel ~= 0 and targetRadio == 0) then
		AddPlayerToRadio(src, radioChannel, type)
	elseif (radioChannel == 0) then
		RemovePlayerFromRadio(src, targetRadio, type)
	elseif (targetRadio > 0) then
		RemovePlayerFromRadio(src, targetRadio, type)
		AddPlayerToRadio(src, radioChannel, type)
	end
end

-- WHEN TRIGGERED, TOGGLE TALKING STATE FOR A PLAYER
function SetTalkingOnRadio(talking, type)
	local src = source

	voiceData[src] = voiceData[src] or ResetDataTables(src)
	local plyVoice = voiceData[src]

	local radioTbl = radioData[plyVoice.radio]
	if (type == "Secondary") then
		radioTbl = radioData[plyVoice.secondaryRadio]
	end

	if radioTbl then
		--[[if (type == "Secondary") then
			logger.info("[radio] Set %s to talking: %s on secondary radio %s", src, talking, plyVoice.secondaryRadio)
		elseif (type == "Primary") then
			logger.info("[radio] Set %s to talking: %s on primary radio %s", src, talking, plyVoice.radio)
		end]]

		--print("radioTbl:", json.encode(radioTbl))
		for player, playerData in pairs(radioTbl) do
			--print(json.encode(playerData))
			if (player ~= src) then
				TriggerClientEvent("Voice:Client:SetTalkingOnRadio", player, src, talking, playerData.type)
				--logger.verbose("[radio] Sync %s to let them know %s is %s with type %s", player, src, talking and "talking" or "not talking", playerData.type)
			end
		end
	end
end

-- **********************
--       Commands
-- **********************
-- WHEN TRIGGERED, OPEN RADIOFX SETTINGS UI
--[[RegisterCommand("radiofx", function(source)
	local src = source
	TriggerClientEvent("Voice:Client:RadioFXConfig", src)
end)]]

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, TOGGLE TALKING STATE FOR A PLAYER
RegisterNetEvent("Voice:Server:SetTalkingOnRadio", SetTalkingOnRadio)

-- WHEN TRIGGERED, SET PLAYER TO A RADIO CHANNEL
RegisterNetEvent("Voice:Server:SetPlayerRadioChannel", function(radioChannel, type)
	SetPlayerRadioChannel(source, radioChannel, type)
end)
