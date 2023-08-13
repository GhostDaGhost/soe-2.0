local showHelp = false
local mhackingCallback = {}
local helpTimer, helpCycle = 0, 4000

local function ShowHelpText(s)
	SetTextComponentFormat("STRING")
	AddTextComponentString(s)
	EndTextCommandDisplayHelp(0,0,0,-1)
end

AddEventHandler("MHacking:Client:Show", function()
    nuiMsg = {}
	nuiMsg["show"] = true
	SendNUIMessage(nuiMsg)
	SetNuiFocus(true, false)
end)

AddEventHandler("MHacking:Client:Hide", function()
    nuiMsg = {}
	nuiMsg["show"] = false
	SendNUIMessage(nuiMsg)
	SetNuiFocus(false, false)
	showHelp = false
end)

AddEventHandler("MHacking:Client:Start", function(solutionlength, duration, callback)
    mhackingCallback = callback
	nuiMsg = {}
	nuiMsg["s"] = solutionlength
	nuiMsg["d"] = duration
	nuiMsg["start"] = true
	SendNUIMessage(nuiMsg)
	showHelp = true

	while showHelp do
		Wait(0)
		if helpTimer > GetGameTimer() then
			ShowHelpText("Navigate with ~y~W, A, S, D~s~ and confirm with ~y~SPACE~s~ for the left code block.")
		elseif helpTimer > GetGameTimer() - helpCycle then
			ShowHelpText("Use the ~y~Arrow Keys~s~ and ~y~ENTER~s~ for the right code block")
		else
			helpTimer = GetGameTimer() + helpCycle
		end

		if IsEntityDead(PlayerPedId()) then
			nuiMsg = {}
			nuiMsg["fail"] = true
			SendNUIMessage(nuiMsg)
		end
	end
end)

AddEventHandler("MHacking:Client:SetMsg", function(msg)
    nuiMsg = {}
	nuiMsg["displayMsg"] = msg
	SendNUIMessage(nuiMsg)
end)

RegisterNUICallback('callback', function(data, cb)
	mhackingCallback(data["success"], data["remainingtime"])
    cb('ok')
end)
