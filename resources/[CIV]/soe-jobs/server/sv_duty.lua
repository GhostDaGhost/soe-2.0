local isOnDuty, currentJob = {}, {}
local secretPassword = "pelicanComposition" -- SECRET PASSWORD TO USE THE HTTP HANDLER

-- ***********************
--      HTTP Handlers
-- ***********************
-- WHEN TRIGGERED, DO THE FOLLOWING
SetHttpHandler(function(req, res)
    -- SHOW A LIST OF ON DUTY SERVER IDs AND THEIR JOB
    if (req.path == "/duty/" .. secretPassword) then
        local roster = exports["soe-utils"]:DebugDumpTable(currentJob)
        res.send(roster)
    end

    -- MANUALLY RESET ALL DUTY STATUSES
    if (req.path == "/resetduty/" .. secretPassword) then
        isOnDuty, currentJob = {}, {}
        res.send("DUTY STATUS OF ALL PLAYERS RESETTED.")
    end
end)

-- ***********************
--    Local Functions
-- ***********************
-- CONSTRUCTS DUTY NOTIFICATION MESSAGE
local function SendJobInfo(src)
    local job = GetJob(src)

    local message
    if (job == "SECURITY") then
        message = "After going on duty at a security office, check out a vehicle. You'll be given a site to patrol. Go to the assigned area (Marked on your GPS) and wait at each checkpoint for about 15 seconds."
            .. " You'll then be told you can proceed to the next checkpoint or to the next site if you have completed your patrol at your current site! Check your GPS for an updated route/blip."
    elseif (job == "Unemployed") then
        message = "You need help getting a job? Look for job icons on the map."
    elseif (job == "NEWS") then
        message = "Drive around and look for interesting events to report on! Sometimes we will get tips from civilians of high-profile criminal activity!"
    else
        message = "Can't help you, sorry!"
    end

    TriggerClientEvent("Chat:Client:Message", src, "[My Job]", message, "taxi")
end

-- CONSTRUCTS DUTY NOTIFICATION MESSAGE
local function ConstructNotification(type)
    -- SOME JOBS DON'T HAVE GOOD NAMES FOR DUTY TOGGLING (BECAUSE OF THE DUTY TABLE :))
    local name
    if (type == "PIZZA") then
        name = "You are now on duty as a pizza delivery employee for Pizza This..."
    elseif (type == "HOTDOG") then
        name = "You are now on duty as a hotdog selling employee for Chihuahua Hotdogs"
    elseif (type == "TAXI") then
        name = "You are now on duty as a taxi driver for Downtown Cab Co."
    elseif (type == "GOPOSTAL") then
        name = "You are now on duty as a truck driver for GoPostal."
    elseif (type == "GARBAGE") then
        name = "You are now on duty as a sanitation officer for San Andreas Sanitation."
    elseif (type == "DOJ") then
        name = "You are now on duty as an employee for the San Andreas Department of Justice."
    elseif (type == "SECURITY") then
        name = "You are now on duty as an employee for Merryweather Security Services."
    elseif (type == "NEWS") then
        name = "You are now on duty as an employee for Weazel News."
    elseif (type == "CLUCKINBELL") then
        name = "You are now on duty as an employee for Cluckin' Bell."
    else
        name = "On Duty As: " .. type
    end
    return name
end

-- ***********************
--    Global Functions
-- ***********************
-- WHEN TRIGGERED, RETURN IF SOURCE IS ON A JOB
function IsOnDuty(src)
    return isOnDuty[src]
end

-- WHEN TRIGGERED, RETURN JOB OF SOURCE ASSIGNED TO
function GetJob(src)
    if isOnDuty[src] then
        return currentJob[src]
    end
    return "Unemployed"
end

-- WHEN TRIGGERED, RETURN COUNT OF MEMBERS IN A SPECIFIED JOB
function GetDutyCount(job)
    local count = 0
    for _, memberJob in pairs(currentJob) do
        if (memberJob == job) then
            count = count + 1
        end
    end
    return count
end

-- ***********************
--        Commands
-- ***********************
-- WHEN TRIGGERED, SHOW JOB GUIDE
RegisterCommand("jobinfo", function(source)
    local src = source
    SendJobInfo(src)
end)

-- WHEN TRIGGERED, DISPLAY CURRENT JOB
RegisterCommand("job", function(source)
    local src = source
    local myJob = GetJob(src)
    if (myJob ~= "Unemployed") then
        if (myJob == "CLUCKINBELL") then
            myJob = "Cluckin' Bell"
        end
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "You are employed by " .. myJob, length = 7500})
    else
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "You are currently unemployed", length = 7500})
    end
end)

-- ***********************
--         Events
-- ***********************
-- WHEN TRIGGERED, MAKE SOURCE GO OFF DUTY UPON DISCONNECTION
AddEventHandler("playerDropped", function()
    local src = source
    isOnDuty[src] = nil
    currentJob[src] = nil
end)

-- WHEN TRIGGERED, REQUEST ON-DUTY LEO/EMS/DISPATCH MEMBERS IN A LIST
AddEventHandler("Jobs:Server:GetDutyMembers", function(cb, src)
    local list = {}

    for member, memberJob in pairs(currentJob) do
        if (memberJob == "POLICE" or memberJob == "EMS" or memberJob == "DISPATCH") then
            local char = exports["soe-uchuu"]:GetOnlinePlayerList()[member]
            if char then
                local callsign = exports["soe-emergency"]:GetCallsign(char.CharID)
                local name = ("%s. %s | %s"):format((char.FirstGiven):sub(0, 1), char.LastGiven, callsign or 0)
                list[#list + 1] = name
            end
        end
    end
    cb(list or {})
end)

-- WHEN TRIGGERED, TOGGLE DUTY OF THE SOURCE
RegisterNetEvent("Jobs:Server:ToggleDuty", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 83843-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 83843-2 | Lua-Injecting Detected.", 0)
        return
    end

    -- CHECK IF INCOMING JOB IS VALID
    if not validJobs[data.job] then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = data.job .. " is not a valid job type!", length = 5000})
        exports["soe-logging"]:ServerLog("Duty Toggle Failure", "TRIED TO GO ON DUTY AS " .. data.job, src)
        return
    end

    -- DUTY TOGGLE
    if data.dutyStatus then
        if not data.silent then
            local name = ConstructNotification(data.job)
            TriggerClientEvent("Jobs:Client:ToggleDuty", src, data.job, true)
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = name, length = 5000})
        end

        isOnDuty[src] = true
        currentJob[src] = data.job

        if not data.silent then
            -- START DUTY TIME AND SUBMIT LOG
            exports["soe-logging"]:ServerLog("Duty Toggled On", "HAS GONE ON DUTY AS " .. data.job, src)

            -- GIVE NEWS REPORTERS A CAMERA
            local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
            if (data.job == "NEWS") then
                if exports["soe-inventory"]:AddItem(src, "char", charID, "weazelcamera", 1, "{}") then
                    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "You have been given a weazel news camera to help your journey", length = 5000})
                end
            elseif (data.job == "HOTDOG") then
                if exports["soe-inventory"]:AddItem(src, "char", charID, "hotdogbun", 40, "{}") then
                    if exports["soe-inventory"]:AddItem(src, "char", charID, "hotdogweiner", 40, "{}") then
                        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "Your hotdog cart has been filled with supplies", length = 5000})
                    end
                end
            end
        end
    else
        isOnDuty[src] = false
        currentJob[src] = "Unemployed"

        TriggerClientEvent("Jobs:Client:ToggleDuty", src, data.job, false)

        if not data.silent then
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "You have gone off duty", length = 5000})
            exports["soe-logging"]:ServerLog("Duty Toggled Off", "HAS GONE OFF DUTY FROM " .. data.job, src)

            -- TAKE THE NEWS REPORTERS' CAMERA
            if (data.job == "NEWS") then
                local amount = exports["soe-inventory"]:GetItemAmt(src, "weazelcamera", "left")
                exports["soe-inventory"]:RemoveItem(src, amount, "weazelcamera")
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "We'll be taking back our camera(s)", length = 5000})
            elseif (data.job == "HOTDOG") then
                ResetHotdogSupplyRestock(src)
            end
        end
    end
end)
