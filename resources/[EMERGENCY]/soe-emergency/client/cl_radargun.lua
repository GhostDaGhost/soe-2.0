isRadarOpen, lastRadarSend = false, 0

-- ***********************
--    Global Functions
-- ***********************
-- OPEN/CLOSE RADAR UI
function ToggleRadar(bool)
	if bool then
		SendNUIMessage({type = "showUI"})
		SendNUIMessage({type = "setSpeed", speed = "000"})
		isRadarOpen = true
	else
		SendNUIMessage({type = "hideUI"})
		isRadarOpen = false
	end
end

-- ***********************
--     	   Events
-- ***********************
-- WHEN TRIGGERED, RESET ALL NUI INSTANCES
AddEventHandler("UI:Client:ResetNUI", function()
	SendNUIMessage({type = "hideUI"})
	print("[Radar Gun] UI resetted.")
end)
