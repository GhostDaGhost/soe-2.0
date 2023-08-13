-- GET RUBBISH COUNT IN GARBAGE TRUCK
RegisterNetEvent("Jobs:Server:Garbage:GetTruckRubbishCount")
AddEventHandler(
    "Jobs:Server:Garbage:GetTruckRubbishCount",
    function(data)
        local src = source
        if not data then
            TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 991 | Lua-Injecting Detected.", 0)
            return
        end

        if not data.status then
            TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 990 | Lua-Injecting Detected.", 0)
            return
        end

        if IsOnDuty(src) and (GetJob(src) == "GARBAGE") then
			-- ADD GARBAGE TRUCK TO LIST IF NOT ALREADY IN LIST AND INITIALIZE TO 0
			if garbageTruckRubbishCount[data.vehiclePlate] == nil then
				--print("INITIALIZED GARBAGE TRUCK WITH PLATE " .. tostring(data.vehiclePlate))
				garbageTruckRubbishCount[data.vehiclePlate] = 0
			end

			local garbageCount = garbageTruckRubbishCount[data.vehiclePlate]
            TriggerClientEvent("Jobs:Client:GetRubbishCountInTruck", src, garbageCount)
        end
    end
)

-- UPDATE RUBBISH IN GARBAGE TRUCK
RegisterNetEvent("Jobs:Server:Garbage:UpdateTruckRubbish")
AddEventHandler(
    "Jobs:Server:Garbage:UpdateTruckRubbish",
    function(data)
        local src = source
        if not data then
            TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 991 | Lua-Injecting Detected.", 0)
            return
        end

        if not data.status then
            TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 989 | Lua-Injecting Detected.", 0)
            return
        end

        if IsOnDuty(src) and (GetJob(src) == "GARBAGE") then
			garbageTruckRubbishCount[data.vehiclePlate] = garbageTruckRubbishCount[data.vehiclePlate] + data.amount
            --[[print("garbageTruckRubbishCount[data.vehiclePlate]", garbageTruckRubbishCount[data.vehiclePlate])
            print("sanitationJobRoles[data.roleID].maxQuantity", sanitationJobRoles[data.roleID].maxQuantity)]]
			if garbageTruckRubbishCount[data.vehiclePlate] >= sanitationJobRoles[data.roleID].maxQuantity then
				TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = sanitationJobRoles[data.roleID].roleTruckFull, length = 5000})
			else
				TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = string.format(sanitationJobRoles[data.roleID].roleThrowRubbish, garbageTruckRubbishCount[data.vehiclePlate], sanitationJobRoles[data.roleID].maxQuantity), length = 5000})
			end
        end
    end
)

-- UPDATE RUBBISH IN GARBAGE TRUCK
RegisterNetEvent("Jobs:Server:Garbage:EmptyTruck")
AddEventHandler(
    "Jobs:Server:Garbage:EmptyTruck",
    function(data)
        local src = source
        if not data then
            TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 991 | Lua-Injecting Detected.", 0)
            return
        end

        if not data.status then
            TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 988 | Lua-Injecting Detected.", 0)
            return
        end

        if IsOnDuty(src) and (GetJob(src) == "GARBAGE") then
			-- ADD CHAR ID TO GARBAGE POY TABLE IF NOT ALREADY IN LIST AND INITIALIZE TO 0
			if garbagePayTable[data.charID] == nil then
				garbagePayTable[data.charID] = 0
			end
            
            -- INITIALIZE TRUCK TO 0
            if garbageTruckRubbishCount[data.vehiclePlate] == nil then
                garbageTruckRubbishCount[data.vehiclePlate] = 0
            end

            if garbageTruckRubbishCount[data.vehiclePlate] == 0 then
                TriggerClientEvent("Chat:Client:Message", src, jobTitle, sanitationJobRoles[data.roleID].roleTruckEmpty, "taxi")
            else
			    local pay = garbageTruckRubbishCount[data.vehiclePlate] * sanitationJobRoles[data.roleID].payRate
			    garbagePayTable[data.charID] = garbagePayTable[data.charID] + pay

			    TriggerClientEvent("Chat:Client:Message", src, jobTitle, string.format(sanitationJobRoles[data.roleID].roleEmptyTruck, garbageTruckRubbishCount[data.vehiclePlate], math.floor(pay)), "taxi")
            end

			-- EMPTIES THE GARBAGE TRUCK
			garbageTruckRubbishCount[data.vehiclePlate] = 0
        end
    end
)

-- SEND PAY AMOUNT TO CLIENT
AddEventHandler("Jobs:Server:Garbage:GetPayTable", function(cb, src)
    cb(garbagePayTable)
end)

-- PAY PLAYER AMOUNT OWED
RegisterNetEvent("Jobs:Server:Garbage:CollectPay")
AddEventHandler(
    "Jobs:Server:Garbage:CollectPay",
    function(data)
        local src = source
        if not data then
            TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 991 | Lua-Injecting Detected.", 0)
            return
        end

        if not data.status then
            TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 987 | Lua-Injecting Detected.", 0)
            return
        end

        local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
		local payAmount = garbagePayTable[char.CharID]

        if exports["soe-inventory"]:AddItem(src, "char", char.CharID, "cash", payAmount, "") then
			TriggerClientEvent("Chat:Client:Message", src, jobTitle, string.format("You received your pay of $%s", math.floor(payAmount)), "taxi")
			garbagePayTable[char.CharID] = 0
		end
    end
)