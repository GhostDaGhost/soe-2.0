-- ADD STOP IF CHANCE IS GREATER THAN 40
local function packageDestinationInitialize()
	for _, data in pairs(goPostalPackageDestinations) do
		local stopChance = math.random(1, 100)
		--[[print("-----")
		print("data.stopID: " .. tostring(data.stopID))
		print("stopChance: " .. tostring(stopChance))]]
		
		-- DEBUG
		stopChance = 100
		
		if stopChance >= 40 then
			--print("adding stop: " .. tostring(data.stopID))
			goPostalDestinationStatus[data.stopID] = {stopID = data.stopID, pos = data.pos, availability = true, lastDrop = 0}
		end
	end
end

-- SENT FROM CLIENT TO GIVE SOURCE PACKAGE DESTINATION STATUS TABLE
RegisterNetEvent("Jobs:Server:GoPostalGetDestinationStatus")
AddEventHandler(
    "Jobs:Server:GoPostalGetDestinationStatus",
    function(playerServerId)
        Wait(500)
        local src = source
		
		if src == nil then
			src = playerServerId
		end
		
        if IsOnDuty(src) and (GetJob(src) == "GOPOSTAL") then
            TriggerClientEvent("Jobs:Client:GoPostalGetDestinationStatus", src, goPostalDestinationStatus)
        end
    end
)

-- SETS THE AVAILABILITY OF STOP TO FALSE
RegisterNetEvent("Jobs:Server:UpdateDestinationAvailability")
AddEventHandler(
    "Jobs:Server:UpdateDestinationAvailability",
    function(playerServerId, stopID)
        Wait(500)
        local src = source
		
		if src == nil then
			src = playerServerId
		end
		
        if IsOnDuty(src) and (GetJob(src) == "GOPOSTAL") then
			--print("SETTING STOP " .. tostring(stopID) .. " AVAILAIBLITY TO FALSE")
			local ostime = os.time()
			goPostalDestinationStatus[stopID].lastDrop = ostime
			goPostalDestinationStatus[stopID].availability = false
        end
    end
)

-- SETS THE AVAILABILITY OF STOP TO FALSE
RegisterNetEvent("Jobs:Server:UpdateGoPostalPackageDeliveredByPlayer")
AddEventHandler(
    "Jobs:Server:UpdateGoPostalPackageDeliveredByPlayer",
    function(playerServerId, charID, amount)
        Wait(500)
        local src = source
		
		if src == nil then
			src = playerServerId
		end
		
        if IsOnDuty(src) and (GetJob(src) == "GOPOSTAL") then
			--print(string.format("UPDATING SERVER LIST - %s TO PACKAGES DELVIERED BY %s", amount, charID))
			if goPostalPayTable[charID] == nil then
				goPostalPayTable[charID] = amount
			else
				goPostalPayTable[charID] = goPostalPayTable[charID] + amount
			end
        end
    end
)

-- GET PACKAGES DELIVERED FOR CHARID
RegisterNetEvent("Jobs:Server:GetPayDataForCharID")
AddEventHandler(
    "Jobs:Server:GetPayDataForCharID",
    function(playerServerId, charID)
        Wait(500)
        local src = source
		
		if src == nil then
			src = playerServerId
		end
		
        if IsOnDuty(src) and (GetJob(src) == "GOPOSTAL") then
			local maxPay = goPostalPayTable[charID] * goPostalPayRate
			local payData = {payAmount = goPostalPayTable[charID], maxPay = maxPay, goPostalPayRate = goPostalPayRate}
            TriggerClientEvent("Jobs:Client:GetPayDataForCharID", src, payData)
        end
    end
)

-- PAY PLAYER AMOUNT OWED
RegisterNetEvent("Jobs:Server:CollectGoPostalPay")
AddEventHandler(
    "Jobs:Server:CollectGoPostalPay",
    function(playerServerId)
        local src = source
		
		if src == nil then
			src = playerServerId
		end
		
		Wait(500)
        local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
		local maxPay = goPostalPayTable[char.CharID] * goPostalPayRate
		
		--[[print("-----")
		print("CharID: " .. tostring(char.CharID))
		print("goPostalPayTable[char.CharID]: " .. tostring(goPostalPayTable[char.CharID]))
		print("goPostalPayRate: " .. tostring(goPostalPayRate))
		print("maxPay: " .. tostring(maxPay))]]		

        if exports["soe-inventory"]:AddItem(src, "char", char.CharID, "cash", maxPay, "") then
			TriggerClientEvent("Chat:Client:Message", src, "[GoPostal]", string.format("You received your pay of $%s for delievering %s packages", math.floor(maxPay), goPostalPayTable[char.CharID]), "taxi")
		end
    end
)

AddEventHandler(
    "onResourceStart",
    function(resource)
		--print("- GOPOSTAL PACKAGE DESTINATION INITIALIZE -")
        if resource ~= GetCurrentResourceName() then
            return
        end
        packageDestinationInitialize()
    end
)