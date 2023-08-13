local factionCooldowns = {}
local takenMissions = {}

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, IF A SOURCE STARTED A MISSION, UNMARK IT AS TAKEN
AddEventHandler("playerDropped", function()
    local src = source
    for missionID, missionData in pairs(takenMissions) do
        if (missionData.src == src) then
            takenMissions[missionID] = {status = false, src = nil}
            break
        end
    end
end)

-- WHEN TRIGGERED, GIVE THE SOURCE A SUPPLY CRATE BECAUSE THEY SUCCEEDED
AddEventHandler("Crime:Server:GiveSupplyCrate", function(cb, src, supply, supplySpot)
    takenMissions[supplySpot] = {status = false, src = nil}
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    if exports["soe-inventory"]:AddItem(src, "char", charID, supply.hash, 1, "{}") then
        cb(true)
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "You completed this mission and have been rewarded a " .. supply.name, length = 12000})
        exports["soe-logging"]:ServerLog("Completed Gang Supply Mission", "HAS COMPLETED A GANG SUPPLY MISSION AND EARNED A " .. supply.name, src)
    else
        cb(false)
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Something went wrong giving you the crate", length = 5000})
        exports["soe-logging"]:ServerLog("Completed Gang Supply Mission (Failed)", "HAS FAILED TO COMPLETE A GANG SUPPLY MISSION", src)
    end
end)

-- WHEN TRIGGERED, DO CHECKS TO SEE IF THE SUPPLIER MENU CAN BE ACCESSED
AddEventHandler("Crime:Server:SupplierMenuChecks", function(cb, src, supplyType)
    -- CHECK HOW MANY COPS ARE ON TO ALLOW SUPPLY MISSIONS TO TAKE PLACE
    if (exports["soe-jobs"]:GetDutyCount("POLICE") >= exports["soe-config"]:GetConfigValue("duty", "criminal_supplier")) then
        -- CHECK SOURCE'S FACTION/GANG PERMISSION
        if not exports["soe-factions"]:CheckPermission(src, "CANSUPPLY_" .. supplyType:upper()) then
            cb(false)
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "I cannot help you.", length = 5000})
            return
        end

        cb(true)
    else
        cb(false)
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "I cannot help you for now.", length = 5000})
    end
end)

-- WHEN TRIGGERED, START UP SUPPLIER MISSION
AddEventHandler("Crime:Server:StartSupplierMission", function(cb, src, supplyType, stockName, price)
    -- CHECK IF A FACTION ALREADY DID A SUPPLY RUN THIS SESSION
    local gangName = exports["soe-factions"]:GetGangName(src)
    if not gangName then cb({status = false}) return end

    -- SECURITY DEPOSIT PRICE CHECK | AUTOBAN IF FAILED
    local setPrice = tonumber(price)
    if exports["soe-config"]:GetConfigValue("economy", stockName) then
        setPrice = exports["soe-config"]:GetConfigValue("economy", stockName).buy
    end

    -- IF THE PRICE IS DIFFERENT FROM THE CLIENT-SENT PRICE... THEY DEFINITELY HACKED OR SOMETHING
    if (tonumber(price) ~= setPrice) then
        cb({status = false})
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 69291 | Memory Editing Detected.", 0)
        return
    end

    -- CHECK IF CHARACTER HAS THE MONEY NEEDED FOR THE SECURITY DEPOSIT
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    if (exports["soe-inventory"]:GetItemAmt(src, "cash", "left") < tonumber(price)) then
        cb({status = false})
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Not enough cash!", length = 8500})
        return
    end

    -- RANDOMIZE SUPPLY LOCATION WHERE THE VAN WOULD BE
    math.randomseed(os.time() + 100)
    local spot = math.random(1, #supplyLocations[supplyType])
    local mission = supplyLocations[supplyType][spot]

    -- MAKE SURE IT ISN'T TAKEN
    if takenMissions[spot] and takenMissions[spot].status then
        cb({status = false})
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "This mission isn't available right now... try again later?", length = 5000})
        return
    end

    -- SET A COOLDOWN FOR THIS GANG FOR THE REMAINDER OF THE SESSION
    if not factionCooldowns[gangName] then
        factionCooldowns[gangName] = true
        takenMissions[spot] = {status = true, src = src}
        
        -- RETURN VALUE AND NOTIFY
        cb({status = true, data = mission, spot = spot})
        exports["soe-inventory"]:RemoveItem(src, tonumber(price), "cash")
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "debug", text = mission.msg, length = 25000})
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "debug", text = "You start supplying for the gang: " .. gangName, length = 25000})
        exports["soe-logging"]:ServerLog("Started Gang Supply Mission", ("HAS STARTED A SUPPLY RUN OF %s UNDER THE GANG %s"):format(stockName, gangName), src)
    else
        -- THIS GANG ALREADY DID A SUPPLY RUN THIS SESSION
        cb({status = false})
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "This gang already did a supply run recently!", length = 5000})
    end
end)
