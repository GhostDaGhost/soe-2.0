local lawyerTitle = "Defense Attorney / Public Defender"
local licenseCooldowns = {}

-- ***********************
--    Local Functions
-- ***********************
-- WHEN TRIGGERED, GET AMOUNT OF LAWYERS ON DUTY
local function GetLawyersOnDuty(src)
    local count = 0
    for _, playerData in pairs(exports["soe-uchuu"]:GetOnlinePlayerList()) do
        if (playerData.JobTitle == lawyerTitle) then
            count = count + 1
        end
    end

    if (count >= 1) then
        TriggerClientEvent("Chat:Client:Message", src, "[DOJ]", ("There are currently %s lawyers around."):format(count), "bank")
    else
        TriggerClientEvent("Chat:Client:Message", src, "[DOJ]", ("There is currently %s lawyer around."):format(count), "bank")
    end
end

-- WHEN TRIGGERED, ISSUE A NEW STATE LICENSE
local function IssueNewStateLicense(src, gameTime, imageURL)
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    if licenseCooldowns[char.CharID] and (licenseCooldowns[char.CharID] > gameTime) then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "There is a long wait after getting your last license!", length = 7500})
        exports["soe-logging"]:ServerLog("State License Issued - Failed", "TRIED TO GET A NEW STATE LICENSE AT CITY HALL BUT FAILED | REASON: TOO SOON", src)
        return
    end

    licenseCooldowns[char.CharID] = gameTime + 5400000 -- 1.5 HOURS
    local itemMeta = {
        ["SSN"] = char.CharID,
        ["FirstGiven"] = char.FirstGiven,
        ["LastGiven"] = char.LastGiven,
        ["DOB"] = char.DOB,
        ["Gender"] = char.Gender,
        ["ImageURL"] = imageURL
    }

    if exports["soe-inventory"]:AddItem(src, "char", char.CharID, "statelicense", 1, json.encode(itemMeta)) then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "The City Hall staff issue you a new state license", length = 7500})
        exports["soe-logging"]:ServerLog("State License Issued", "GOT A NEW STATE LICENSE AT CITY HALL", src)
    end
end

-- WHEN TRIGGERED, REQUEST FOR AN ACTIVE LAWYER
local function RequestForLawyer(src, data)
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 23013-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 23013-2 | Lua-Injecting Detected.", 0)
        return
    end

    local loc = data.loc
    local name = exports["soe-chat"]:GetDisplayName(src)

    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "You requested for a lawyer!", length = 7500})
    for playerID, playerData in pairs(exports["soe-uchuu"]:GetOnlinePlayerList()) do
        if (playerData.JobTitle == lawyerTitle) then
            TriggerClientEvent("Chat:Client:Message", playerID, "[DOJ]", ("A lawyer has been requested by %s at %s."):format(name, loc), "cad")
        end
    end
end

-- ***********************
--        Commands
-- ***********************
-- WHEN TRIGGERED, SHOW ID TO CLIENTS NEARBY SOURCE (REPLACED WITH PHYSICAL IDs)
--[[RegisterCommand("id", function(source)
    local src = source
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    exports["soe-chat"]:DoProximityMessage(src, 10.0, "id", "[ID]", "", ("TTID #: ^2%s ^0SSN #: ^2%s ^0| First: ^2%s ^0Last: ^2%s ^0| DOB: ^2%s"):format(src, char.CharID, char.FirstGiven, char.LastGiven, char.DOB))
end)]]

-- WHEN TRIGGERED, GET AMOUNT OF LAWYERS ON DUTY
RegisterCommand("lawyeronduty", function(source)
    local src = source
    local job = exports["soe-jobs"]:GetJob(src) 
    if (job == "POLICE" or job == "DOJ") then
        GetLawyersOnDuty(src)
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for LEO.")
    end
end)

-- ***********************
--         Events
-- ***********************
-- WHEN TRIGGERED, REQUEST FOR AN ACTIVE LAWYER
AddEventHandler("Gov:Server:IssueNewStateLicense", function(cb, src, gameTime, imageURL)
    cb(true)
    IssueNewStateLicense(src, gameTime, imageURL)
end)

-- WHEN TRIGGERED, REQUEST FOR AN ACTIVE LAWYER
RegisterNetEvent("Gov:Server:RequestForLawyer", function(data)
    local src = source
    if (exports["soe-jobs"]:GetJob(src) == "POLICE") then
        RequestForLawyer(src, data)
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for LEO.")
    end
end)
