callData = {}
voiceData = {}
radioData = {}

-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, RESET RADIO/CALL DATA TABLE
function ResetDataTables()
	return {radio = 0, secondaryRadio = 0, call = 0, lastRadio = 0, lastCall = 0}
end

-- WHEN TRIGGERED, RETURNS PLAYERS IN A SPECIFIC RADIO CHANNEL
function GetPlayersInRadioChannel(channel)
	local returnChannel = radioData[channel]
	if returnChannel then
		return returnChannel
	end
	return {}
end

-- WHEN TRIGGERED, UPDATE/SET A PLAYER'S ROUTING BUCKET
function UpdateRoutingBucket(src, routingBucket)
	local route
	if routingBucket then
		SetPlayerRoutingBucket(src, routingBucket)
	else
		route = GetPlayerRoutingBucket(src)
	end
	Player(src).state:set("routingBucket", route or routingBucket, true)
end

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, BEGIN SYNCING FOR NEWLY JOINED PLAYER
RegisterNetEvent("playerJoined", function()
	if not voiceData[source] then
		voiceData[source] = ResetDataTables(source)

		local plyState = Player(source).state
		plyState:set("routingBucket", 0, true)
	end
end)

-- WHEN TRIGGERED, BEGIN RESOURCE INITIALIZATION PROCEDURES
AddEventHandler("onResourceStart", function(resource)
	if (GetCurrentResourceName() ~= resource) then return end

	local players = GetPlayers()
	for i = 1, #players do
		local ply = players[i]
		if not voiceData[ply] then
			voiceData[ply] = ResetDataTables(ply)
			Player(ply).state:set("routingBucket", GetPlayerRoutingBucket(ply), true)
		end
	end
end)

-- WHEN TRIGGERED, DELETE A DROPPED PLAYER'S VOICE DATA
AddEventHandler("playerDropped", function()
	local src = source
	if voiceData[src] then
		local plyData = voiceData[src]
		if (plyData.radio ~= 0) then
			RemovePlayerFromRadio(src, plyData.radio, "Primary")
		end

		if (plyData.secondaryRadio ~= 0) then
			RemovePlayerFromRadio(src, plyData.secondaryRadio, "Secondary")
		end

		if (plyData.call ~= 0) then
			RemovePlayerFromCall(src, plyData.call)
		end
		voiceData[src] = nil
	end
end)

-- **********************
--        Threads
-- **********************
-- WHEN TRIGGERED, CREATE MUMBLE CHANNELS
CreateThread(function()
	Wait(1500)
    for channel = 1, 1024 do
        MumbleCreateChannel(channel)
    end
	print("VOIP HAS BEEN INITIALIZED. :)")
end)
