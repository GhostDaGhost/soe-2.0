local seqSwitch
local seqRemaingingTime = 0

local function mhackingSeqCallback(success, remainingtime)
	seqSwitch = success
	seqRemaingingTime = math.floor(remainingtime/1000.0 + 0.5)
end

AddEventHandler('mhacking:seqstart', function(solutionlength, duration, callback)
	if type(solutionlength) ~= 'table' and type(duration) ~= 'table' then
		TriggerEvent('MHacking:Client:Show')
		TriggerEvent('MHacking:Client:Start', solutionlength, duration, mhackingSeqCallback)
		while seqSwitch == nil do
			Wait(5)
		end
		TriggerEvent('MHacking:Client:Hide')
		callback(seqSwitch, seqRemaingingTime, true)
		seqRemaingingTime = 0
		seqSwitch = nil
	elseif type(solutionlength) == 'table' and type(duration) ~= 'table' then
		TriggerEvent('MHacking:Client:Show')
		seqRemaingingTime = duration
		for _, sollen in pairs(solutionlength) do
			TriggerEvent('MHacking:Client:Start', sollen, seqRemaingingTime, mhackingSeqCallback)	
			while seqSwitch == nil do
				Wait(5)
			end
			
			if next(solutionlength,_) == nil or seqRemaingingTime == 0 then
				callback(seqSwitch, seqRemaingingTime, true)
			else
				callback(seqSwitch, seqRemaingingTime, false)
			end
			seqSwitch = nil
		end
		seqRemaingingTime = 0
		TriggerEvent('MHacking:Client:Hide')
	elseif type(solutionlength) ~= 'table' and type(duration) == 'table' then
		TriggerEvent('MHacking:Client:Show')
		for _, dur in pairs(duration) do
			TriggerEvent('MHacking:Client:Start', solutionlength, dur, mhackingSeqCallback)	
			while seqSwitch == nil do
				Wait(5)
			end
			if next(duration,_) == nil then
				callback(seqSwitch, seqRemaingingTime, true)
			else
				callback(seqSwitch, seqRemaingingTime, false)
			end
			seqSwitch = nil
		end
		seqRemaingingTime = 0
		TriggerEvent('MHacking:Client:Hide')
	elseif type(solutionlength) == 'table' and type(duration) == 'table' then
		local itrTbl = {}
		local solTblLen = 0
		local durTblLen = 0
		for _ in ipairs(solutionlength) do solTblLen = solTblLen + 1 end
		for _ in ipairs(duration) do durTblLen = durTblLen + 1 end
		itrTbl = duration
		if solTblLen > durTblLen then itrTbl = solutionlength end	
		TriggerEvent('MHacking:Client:Show')
		for idx in ipairs(itrTbl) do
			TriggerEvent('MHacking:Client:Start', solutionlength[idx], duration[idx], mhackingSeqCallback)	
			while seqSwitch == nil do
				Wait(5)
			end
			if next(itrTbl,idx) == nil then
				callback(seqSwitch, seqRemaingingTime, true)
			else
				callback(seqSwitch, seqRemaingingTime, false)
			end
			seqSwitch = nil
		end
		seqRemaingingTime = 0
		TriggerEvent('MHacking:Client:Hide')
	end
end)
