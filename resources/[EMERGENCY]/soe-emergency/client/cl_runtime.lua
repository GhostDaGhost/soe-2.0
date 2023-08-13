--EMERGENCY RUNTIME
CreateThread(function()
	Wait(3500)

	local loopIndex = 0
	while true do
		loopIndex = loopIndex + 1
		if (loopIndex % 2 == 0) then
			GetClosestSpikes() -- GET THE CLOSEST SPIKE STRIPS
			loopIndex = 0
		end
		DoSpikeStripAction() -- SPIKE YOUR CURRENT VEHICLE IF TOUCHING SPIKE STRIPS

        -- IF HOLDING LIDAR GUN
		if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("WEAPON_SNSPISTOL_MK2") then
            -- OPEN LIDAR PANEL IF NOT OPEN
			if not isRadarOpen then
				ToggleRadar(true)
			end

            -- FIND VEHICLE THEY ARE POINTING AT AND CHECK ANGLE
			local isFound, foundVeh = GetEntityPlayerIsFreeAimingAt(PlayerId())
			if isFound and isRadarOpen then
				local myHeading, vehHeading = GetEntityHeading(PlayerPedId()), GetEntityHeading(foundVeh)
				local diffHeading = math.abs((myHeading - vehHeading + 540) % 360 - 180)

				-- LIDAR WILL WORK
				if diffHeading >= 150 or diffHeading <= 30 then
					local speed = math.floor(GetEntitySpeed(foundVeh) * 2.236936)
					SendNUIMessage({type = "setSpeed", speed = speed})
					lastRadarSend = GetGameTimer()
                -- LIDAR ANGLE BAD
				else
					SendNUIMessage({type = "setSpeed", speed = "ERR"})
					lastRadarSend = GetGameTimer()
				end
			end
        -- IF NOT HOLDING GUN, CLOSE UI IF OPEN
		elseif isRadarOpen then
			ToggleRadar(false)
		end

        -- SEND SPEED 000 IF NO DATA IN 8 SECONDS
		if isRadarOpen and GetGameTimer() >= lastRadarSend + 8000 then
			SendNUIMessage({type = "setSpeed", speed = "000"})
			lastRadarSend = GetGameTimer()
		end

        -- DELAY
		Wait(250)
	end
end)
