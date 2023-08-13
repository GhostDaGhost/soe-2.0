local towingCalls = {}
local maximumTowCalls = 6
local recentlyPaidTow = {}
local currentlyTowing = {}
local awaitingLocationData
local takenCallLocations = {}

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, GENERATE A RANDOM TOW CALL TAG
local function GenerateJobID(zone)
    math.randomseed(GetGameTimer() + 100)
    local randomTag = math.random(999999)
    local jobID = ("%s-%s"):format(zone, randomTag)
    return jobID
end

-- WHEN TRIGGERED, START A NEW TOW CALL BASED OFF SENT DATA
local function StartNewTowCall(src, call)
    -- GENERATE A RANDOM TAG FOR THE JOB ID
    local jobID = GenerateJobID(call.zone)

    -- CHECK IF THE SOURCE IS AN LEO FOR EXTRA DETAIL
    local callString = "A civilian is requesting a tow"
    if (GetJob(src) == "POLICE") then
        callString = "A law enforcement officer is requesting a tow"
    end

    -- NOTIFY ALL ON DUTY TOW OF THE NEW CALL
    towingCalls[#towingCalls + 1] = {isLocal = false, jobID = jobID, pos = call.pos, zone = call.zone, veh = call.veh, name = call.name, loc = call.loc, spawned = true}
    local callMsg = ("%s with call tag ^3%s^7 in ^3%s^7. The vehicle will be a ^5%s^7, reference map for more details."):format(callString, jobID, call.loc, call.name)

    TriggerClientEvent("Chat:Client:Message", src, "[Tow Dispatch]", "Thank you for calling a tow truck. Your call tag is: ^3" .. jobID .. "^7.", "cad")
    for playerID in pairs(exports["soe-uchuu"]:GetOnlinePlayerList()) do
        if (GetJob(playerID) == "TOW") then
            TriggerClientEvent("Jobs:Client:NewTowCall", playerID, {status = true, call = towingCalls[#towingCalls]})
            TriggerClientEvent("Chat:Client:Message", playerID, "[Tow Dispatch]", callMsg, "cad")
        end
    end
end

-- WHEN TRIGGERED, CREATE A NEW TOW CALL THROUGH AI MEANS
local function NewAITowCall()
    -- IF THERE ARE NO TOWS ON, DON'T MAKE CALLS TO PREVENT ANY FORM OF ERROR
    if (GetDutyCount("TOW") <= 0) then
        --print("DON'T MAKE A TOW CALL... NO TOWS ON DUTY.")
        return
    end

    -- IF WE HAVE REACHED THE MAXIMUM AMOUNT OF AI TOW CALLS ACTIVE
    if #towingCalls >= maximumTowCalls then
        --print("MAXIMUM AI TOW CALLS REACHED.")
        return
    end

    math.randomseed(GetGameTimer() + 100)
    local vehicle = towingVehicles[math.random(1, #towingVehicles)]
    vehicle = vehicle:lower()

    math.randomseed(GetGameTimer() + 100)
    local location = math.random(1, #towingCallLocations)
    if not takenCallLocations[location] then
        takenCallLocations[location] = true
        local hash = GetHashKey(vehicle)

        awaitingLocationData = nil
        TriggerClientEvent("Jobs:Client:GetTowCallLocation", -1, {status = true, pos = towingCallLocations[location], model = hash})
        while not awaitingLocationData do
            Wait(150)
        end

        local locData = awaitingLocationData
        local jobID = GenerateJobID(locData.zone)
        towingCalls[#towingCalls + 1] = {
            isLocal = true,
            hash = hash,
            jobID = jobID,
            pos = towingCallLocations[location],
            zone = locData.zone,
            veh = 0,
            name = locData.model,
            loc = locData.street,
            spawnLoc = location
        }

        -- FINALLY ALERT ALL TOWS
        local callMsg = ("A local law enforcement officer is requesting a tow with call tag ^3%s^7 in ^3%s^7. The vehicle will be a ^5%s^7, reference map for more details."):format(jobID, locData.street, locData.model)
        for playerID in pairs(exports["soe-uchuu"]:GetOnlinePlayerList()) do
            if (GetJob(playerID) == "TOW") then
                TriggerClientEvent("Jobs:Client:NewTowCall", playerID, {status = true, call = towingCalls[#towingCalls]})
                TriggerClientEvent("Chat:Client:Message", playerID, "[Tow Dispatch]", callMsg, "cad")
            end
        end
    end
end

-- WHEN TRIGGERED, PAY A TOW TRUCK DRIVER EXTRA (#SUPPORTLOCALBUSINESSES)
local function PayTow(src, target)
    -- IF THE SOURCE TRIED TO PAY THEMSELVES
    if (target == src) then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You can't pay yourself fool!", length = 5000})
        exports["soe-logging"]:ServerLog("Tow Payment (Extra) (Failed)", "TRIED TO PAY THEMSELVES WITH /paytow", src)
        return
    end

    -- IF THE TARGET DOESN'T EVEN EXIST
    if not DoesEntityExist(GetPlayerPed(target)) then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Tow driver not found", length = 5000})
        exports["soe-logging"]:ServerLog("Tow Payment (Extra) (Failed)", "COULD NOT PAY WITH /paytow BECAUSE TARGET NOT FOUND", src)
        return
    end

    -- IF THE TARGET ISN'T EVEN TOWING
    if (GetJob(target) ~= "TOW") then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "The individual isn't even working for a tow company!", length = 5000})
        exports["soe-logging"]:ServerLog("Tow Payment (Extra) (Failed)", "COULD NOT PAY WITH /paytow BECAUSE TARGET IS NOT ON TOW DUTY", src)
        return
    end

    local time = os.time()
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    if not recentlyPaidTow[charID] then
        recentlyPaidTow[charID] = time
    end

    if (recentlyPaidTow[charID] <= time) then
        recentlyPaidTow[charID] = time + 300

        -- GET ECONOMY VALUE OF EXTRA TOW PAYMENTS
        local amount = 80
        if exports["soe-config"]:GetConfigValue("economy", "paytow") then
            amount = exports["soe-config"]:GetConfigValue("economy", "paytow")
        end

        -- NOTIFY ALL PARTIES OF THE TOW PAYMENT
        local me = exports["soe-chat"]:GetDisplayName(src)
        local char = exports["soe-uchuu"]:GetOnlinePlayerList()[target]
        TriggerClientEvent("Chat:Client:Message", target, "[Impound]", me .." paid you $".. amount .." as extra towing payment.", "standard")
        TriggerEvent("Chat:Server:SendToJointES", "[Impound]", ("%s paid %s %s to tow a vehicle."):format(me, char.FirstGiven, char.LastGiven), "standard")

        exports["soe-bank"]:PayPrimary(target, char.CharID, amount, "Towing Payment")
        exports["soe-logging"]:ServerLog("Tow Payment (Extra) (Success)",
            ("HAS PAID %s (%s / %s) AN AMOUNT OF $%s WITH /paytow"):format(char.Username, char.FirstGiven, char.LastGiven, amount),
        src)
    else
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You already paid someone too recently", length = 8000})
        exports["soe-logging"]:ServerLog("Tow Payment (Extra) (Failed)", "COULD NOT USE /paytow BECAUSE THEY PAID TOO RECENTLY", src)
    end
end

-- **********************
--       Commands
-- **********************
-- WHEN TRIGGERED, DO TOWING TASKS
RegisterCommand("tow", function(source, args)
    local src = source
    TriggerClientEvent("Jobs:Client:TowVehicle", src, tonumber(args[1]))
end)

-- WHEN TRIGGERED, REQUEST A TOWTRUCK
RegisterCommand("requesttow", function(source)
    local src = source
    if (GetDutyCount("TOW") <= 0) then
        TriggerClientEvent("Chat:Client:Message", src, "[Tow Dispatch]", "There are no tow trucks available.", "system")
        return
    end
    TriggerClientEvent("Jobs:Client:RequestTowTruck", src, {status = true})
end)

-- WHEN TRIGGERED, CLEAR A PLAYER'S TOW CALLS
RegisterCommand("cleartowcalls", function(source)
    local src = source
    if (GetJob(src) == "TOW") then
        TriggerClientEvent("Jobs:Client:ClearTowCalls", src, {status = true})
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for on-duty tow truck drivers.")
    end
end)

-- WHEN TRIGGERED, GET A NUMBER OF TOW TRUCKS ON DUTY
RegisterCommand("towonduty", function(source)
    local src = source
    local count = GetDutyCount("TOW")
    if (count == 0 or count > 1) then
        TriggerClientEvent("Chat:Client:Message", src, "[Tow Dispatch]", ("There are currently %s tow trucks on duty."):format(count), "bank")
    else
        TriggerClientEvent("Chat:Client:Message", src, "[Tow Dispatch]", ("There is currently %s tow truck on duty."):format(count), "bank")
    end
end)

-- WHEN TRIGGERED, PAY THE SERVER ID TARGETED EXTRA FOR TOWING
RegisterCommand("paytow", function(source, args)
    local src = source
    local myJob = GetJob(src)
    if (myJob == "POLICE" or myJob == "EMS") then
        local target = tonumber(args[1])
        if (target == nil) then return end

        PayTow(src, target)
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for Emergency Services.")
    end
end)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, CREATE A NEW AI TOW CALL
AddEventHandler("Jobs:Server:NewAITowCall", NewAITowCall)

-- WHEN TRIGGERED, RETURN THE TOW CALLS DATA TO CLIENT
AddEventHandler("Jobs:Server:GetTowCalls", function(cb, src)
    cb(towingCalls)
end)

-- WHEN TRIGGERED, RETURN THE STATUS OF A AI TOW CALL VEHICLE
AddEventHandler("Jobs:Server:GetTowCallVehicleStatus", function(cb, src, callTag)
    local spawned = true
    for _, callData in pairs(towingCalls) do
        if (callData.jobID == callTag) then
            spawned = callData.spawned
            break
        end
    end
    cb(spawned)
end)

-- ADDS WHATEVER JUST GOT TOWED/UNTOWED TO SERVER SIDE DATA HERE
RegisterNetEvent("Jobs:Server:UpdateTowData")
AddEventHandler("Jobs:Server:UpdateTowData", function(towtruck, veh, trailer, slot)
    if trailer then
        if not currentlyTowing[towtruck] then
            currentlyTowing[towtruck] = {}
        end
        currentlyTowing[towtruck][slot] = veh
    else
        currentlyTowing[towtruck] = veh
    end
    TriggerClientEvent("Jobs:Client:UpdateTowData", -1, currentlyTowing)
end)

-- WHEN TRIGGERED, CONSUME A RAG FROM THE SOURCE'S INVENTORY
RegisterNetEvent("Jobs:Server:UseRag")
AddEventHandler("Jobs:Server:UseRag", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 93339-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 93339-2 | Lua-Injecting Detected.", 0)
        return
    end
    exports["soe-inventory"]:RemoveItem(src, 1, "rag")
    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "You cleaned the vehicle!", length = 8500})
end)

-- WHEN TRIGGERED, REQUEST FOR A TOW TRUCK AND ADD A NEW CALL
RegisterNetEvent("Jobs:Server:RequestTowTruck")
AddEventHandler("Jobs:Server:RequestTowTruck", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 92929-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 92929-2 | Lua-Injecting Detected.", 0)
        return
    end
    StartNewTowCall(src, data)
end)

-- WHEN TRIGGERED, RECORD LOCATION DATA OF COORDS WE PREVIOUSLY SENT
RegisterNetEvent("Jobs:Server:GetTowCallLocation")
AddEventHandler("Jobs:Server:GetTowCallLocation", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 92939-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 92939-2 | Lua-Injecting Detected.", 0)
        return
    end
    awaitingLocationData = data.locationData
end)

-- WHEN TRIGGERED, UPDATE THE SPAWNED FLAG IN THE AI TOW CALL
RegisterNetEvent("Jobs:Server:UpdateTowCallVehicleStatus")
AddEventHandler("Jobs:Server:UpdateTowCallVehicleStatus", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 92940-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 92940-2 | Lua-Injecting Detected.", 0)
        return
    end

    -- FIND THE TOW CALL MATCHING THE ID AND MARK IT AS SPAWNED
    for callID, callData in pairs(towingCalls) do
        if (callData.jobID == data.jobID) then
            towingCalls[callID].spawned = true
            break
        end
    end
end)

-- WHEN TRIGGERED, REMOVE AN AI TOW CALL
RegisterNetEvent("Jobs:Server:RemoveTowCallFromList")
AddEventHandler("Jobs:Server:RemoveTowCallFromList", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 92940-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 92940-2 | Lua-Injecting Detected.", 0)
        return
    end

    -- FIND THE TOW CALL MATCHING THE ID AND MARK IT AS SPAWNED
    for callID, callData in pairs(towingCalls) do
        if (callData.jobID == data.callID) then
            table.remove(towingCalls, callID)
            if callData.spawnLoc then
                takenCallLocations[callData.spawnLoc] = false
            end
            break
        end
    end
end)

-- PAYS TOW TRUCK DRIVER FOR TURNING IN A VEHICLE
RegisterNetEvent("Jobs:Server:PayTowTruckDriver")
AddEventHandler("Jobs:Server:PayTowTruckDriver", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 4424-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 4424-2 | Lua-Injecting Detected.", 0)
        return
    end

    -- FOR SECURITY REASONS, MAKE SURE THEIR JOB MATCHES TOWING
    if (GetJob(src) == "TOW") then
        -- GIVE THE PLAYER MONEY
        local amount = 70
        if exports["soe-config"]:GetConfigValue("economy", "impound") then
            amount = exports["soe-config"]:GetConfigValue("economy", "impound")
        end

        local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
        exports["soe-bank"]:PayPrimary(src, charID, amount, "Impounded Vehicle Delivered")
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = ("You impounded a vehicle and $%s has been deposited in your account or given in cash!"):format(tostring(amount)), length = 8500})
    end
end)

-- WHEN TRIGGERED, ANNOUNCE THAT NO TOW IS NEEDED FOR A CERTAIN CALL
RegisterNetEvent("Jobs:Server:TowCallTakenAlert")
AddEventHandler("Jobs:Server:TowCallTakenAlert", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 92940-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 92940-2 | Lua-Injecting Detected.", 0)
        return
    end

    -- BROADCAST TO ALL
    TriggerClientEvent("Chat:Client:Message", src, "[Tow Dispatch]", ("You have arrived at call ^3%s^7, hook the vehicle up and take it to the nearest impound."):format(data.callID), "cad")
    for playerID in pairs(exports["soe-uchuu"]:GetOnlinePlayerList()) do
        if (GetJob(playerID) == "TOW") then
            TriggerClientEvent("Jobs:Client:TowCallTakenAlert", playerID, {status = true, callID = data.callID, callList = towingCalls})
            if (src ~= playerID) then
                TriggerClientEvent("Chat:Client:Message", playerID, "[Tow Dispatch]", ("T-%s has claimed call ^3%s^7 and you are no longer required to go to it."):format(src, data.callID), "cad")
            end
        end
    end
end)

-- WHEN TRIGGERED, SYNC CARLIFTING GLOBALLY
RegisterNetEvent("Jobs:Server:SyncCarlifting")
AddEventHandler("Jobs:Server:SyncCarlifting", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 9291-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 9291-2 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.veh then return end
    if not data.type then return end
    TriggerClientEvent("Jobs:Client:SyncCarlifting", -1, {status = true, type = data.type, veh = data.veh})
end)

-- WHEN TRIGGERED, SYNC CARLIFTING GLOBALLY
RegisterNetEvent("Jobs:Server:DetachHookedVeh")
AddEventHandler("Jobs:Server:DetachHookedVeh", function(data)
    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 9291-3 | Lua-Injecting Detected.", 0)
        return
    end
    TriggerClientEvent("Jobs:Client:DetachHookedVeh", data.playerID, {status = true})
end)
