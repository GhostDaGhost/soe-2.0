-- RECORDS THE LAST NCIC RECORD THAT WAS RAN
local lastNCIC = {}

-- RECORDS PLAYER'S CALLSIGNS
local callsigns = {}

-- TICKETS TO ACCEPT OR DECLINE
local tickets = {}

-- LIST OF MARKED FOR IMPOUND VEHICLES
local markedForImpound = {}

-- STOLEN/LOCAL/RENTED PLATE RECORDING
local localPlates, rentedPlates, stolenPlates = {}, {}, {}

SetHttpHandler(function(req, res)
    if (req.path == "/stolenplates.json") then
        res.send(json.encode(stolenPlates))
    elseif (req.path == "/rentedplates.json") then
        res.send(json.encode(rentedPlates))
    elseif (req.path == "/callsigns.json") then
        res.send(json.encode(callsigns))
    end
end)

-- GRABS MORE DATA FROM THE LAST RAN NCIC RECORD
local function CheckLastRanNCICRecord(src)
    -- MAKE SURE THERE WAS AN NCIC RECORD BOOKMARKED
    if (lastNCIC[src] ~= nil) then
        -- DISPLAY THE NAME OF THE RECORD HOLDER
        TriggerClientEvent("Chat:Client:Message", src, "[NCIC]", string.format("Full record for: %s", lastNCIC[src].name), "standard")

        -- ARRESTS
        TriggerClientEvent("Chat:Client:SendMessage", src, "center", "Arrests")
        TriggerClientEvent("Chat:Client:SendMessage", src, "linebreak")
        for k, v in pairs(lastNCIC[src].arrests) do
            TriggerClientEvent("Chat:Client:Message", src, "", string.format("^0^*[%s]:^r %s | %s | %s", k, v.reason, v.issuer, v.timestamp), "blank")
        end
        TriggerClientEvent("Chat:Client:SendMessage", src, "linebreak")

        -- TICKETS
        TriggerClientEvent("Chat:Client:SendMessage", src, "center", "Tickets")
        TriggerClientEvent("Chat:Client:SendMessage", src, "linebreak")
        for k, v in pairs(lastNCIC[src].tickets) do
            TriggerClientEvent("Chat:Client:Message", src, "", string.format("^0^*[%s]:^r %s | %s | %s", k, v.reason, v.issuer, v.timestamp), "blank")
        end
        TriggerClientEvent("Chat:Client:SendMessage", src, "linebreak")
    else
        TriggerClientEvent("Chat:Client:Message", src, "[NCIC]", "ERROR: Could not find last ran NCIC record.", "error")
    end
end

-- ISSUES A COURT RECORD ON THE CHARACTER REQUESTED
local function IssueCourtRecord(src, type, target, reason)
    if (type == "cautioncode") then
        -- LIST OF CAUTION CODES
        local cautionCodes = {["G"] = "Gang", ["V"] = "Violent", ["E"] = "Escape Risk", ["PH"] = "Police Hater", ["M"] = "Mental Instability",
        ["ST"] = "Suicidal Tendencies"}

        -- IF THE CAUTION CODE ENTERED IS INVALID
        if (cautionCodes[reason] == nil) then
            TriggerClientEvent("Chat:Client:Message", src, "[NCIC]", ('ERROR: "%s" is not a valid caution code.'):format(reason), "standard")
            return
        end
    end

    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    local name = ("%s %s %s - %s"):format(char.JobTitle, char.FirstGiven, char.LastGiven, char.Employer)
    local dataString = ("charid=%s&type=%s&recorddata=%s&issuer=%s"):format(target, type, reason, name)

    -- ENTER COURT RECORD INTO DATABASE
    local inputCourtRecord = exports["soe-nexus"]:PerformAPIRequest("/api/court/inputrecord", dataString, true)
    if inputCourtRecord.status then
        local inputter = ("%s %s"):format(char.JobTitle, char.LastGiven)
        local crim = ("%s %s"):format(inputCourtRecord.data.firstGiven, inputCourtRecord.data.lastGiven)

        -- NOTIFY LEOs IN THE SESSION OF THE ISSUED WARRANT
        if (type == "warrant") then
            exports["soe-logging"]:ServerLog("Warrant Issued", ("HAS ISSUED A WARRANT ON %s FOR %s"):format(crim, reason), src)
            TriggerEvent("Chat:Server:SendToLEOs", "[NCIC]", ("%s has issued a warrant on %s for: %s"):format(inputter, crim, reason), "standard")
        elseif (type == "want") then
            exports["soe-logging"]:ServerLog("Want Issued", ("HAS ISSUED A WANT ON %s FOR %s"):format(crim, reason), src)
            TriggerEvent("Chat:Server:SendToLEOs", "[NCIC]", ("%s has issued a want on %s for: %s"):format(inputter, crim, reason), "standard")
        elseif (type == "courtorder") then
            exports["soe-logging"]:ServerLog("Court Order Issued", ("HAS ISSUED A COURT ORDER ON %s FOR %s"):format(crim, reason), src)
            TriggerEvent("Chat:Server:SendToLEOs", "[NCIC]", ("%s has issued a court order on %s for: %s"):format(inputter, crim, reason), "standard")
        elseif (type == "cautioncode") then
            exports["soe-logging"]:ServerLog("Caution Code Issued", ("HAS ISSUED A CAUTION CODE ON %s WITH %s"):format(crim, reason), src)
            TriggerEvent("Chat:Server:SendToLEOs", "[NCIC]", ('%s gave %s caution code: "%s"'):format(inputter, crim, reason), "standard")
        end
    else
        TriggerClientEvent("Chat:Client:Message", src, "[NCIC]", ('ERROR: "%s" is not a valid SSN.'):format(target), "standard")
    end
end

-- CHANGES PLATE'S STATUS AS STOLEN/NOT STOLEN
local function MarkPlateStatus(plate, bool, src, localReported)
    -- DEFAULT STATUS WOULD BE RECOVERED
    if (bool == nil) then
        bool = false
    end

    -- CHANGE PLATE STATUS IN THE TABLE
    if (plate == nil) then return end
    stolenPlates[plate] = bool

    -- IF THE PLATE WASN'T REPORTED BY A LOCAL, NOTIFY LEOs AND LOG
    if not localReported then
        local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
        if bool then
            -- NOTIFY LEOs THAT A PLATE WAS MARKED STOLEN BY ANOTHER LEO OR DISPATCH
            TriggerEvent("Chat:Server:SendToLEOs", "[NCIC]", ("%s %s has marked plate ^3^_%s^0^r as ^1stolen^0."):format(char.JobTitle, char.LastGiven, plate:upper()), "standard")
            exports["soe-logging"]:ServerLog("Vehicle Reported", "HAS MARKED A VEHICLE WITH A FLAG | FLAG: Stolen | PLATE: " .. plate, src)
        else
            -- NOTIFY LEOs THAT A PLATE WAS MARKED RECOVERED BY ANOTHER LEO OR DISPATCH
            TriggerEvent("Chat:Server:SendToLEOs", "[NCIC]", ("%s %s has marked plate ^3^_%s^0^r as ^2recovered^0."):format(char.JobTitle, char.LastGiven, plate:upper()), "standard")
            exports["soe-logging"]:ServerLog("Vehicle Reported", "HAS MARKED A VEHICLE WITH A FLAG | FLAG: Recovered | PLATE: " .. plate, src)
        end
    else
        exports["soe-logging"]:ServerLog("Vehicle Reported", "A VEHICLE HAS BEEN REPORTED STOLEN | PLATE: " .. plate)
    end
end

-- RUNS NCIC RECORD OF SUBJECT
local function RunNCICRecord(subject, searchType, src)
    local dataString -- GET SEARCH TYPE, CHARACTER ID OR NAME
    if (searchType == "charID") then
        dataString = "charid=" .. subject
    else
        dataString = "name=" .. subject
    end

    -- SEARCH THE RECORD IN THE DATABASE
    local records = exports["soe-nexus"]:PerformAPIRequest("/api/records/getrecords", dataString, true)
    if not records["status"] then
        TriggerClientEvent("Chat:Client:Message", src, "[NCIC]", "API ERROR: Failed to load records from database.", "system")
        return
    end

    if (type(records["data"]) == "string") then -- IF THE CHARACTER DOESN'T EXIST
        TriggerClientEvent("Chat:Client:Message", src, "[NCIC]", ('ERROR: No records found for "%s".'):format(subject), "system")
    else
        -- GET COURT RECORDS AND LATEST ISSUED ID FOR THE CHARACTER
        local courtRecords = exports["soe-nexus"]:PerformAPIRequest("/api/court/requestrecord", dataString, true)
        local idNumber = exports["soe-nexus"]:PerformAPIRequest("/api/id/getlatestid", dataString, true)

        lastNCIC[src] = { -- RECORD OUR LAST RAN NCIC RECORD
            ["tickets"] = records["data"]["tickets"],
            ["arrests"] = records["data"]["arrests"],
            ["name"] = records["data"]["firstGiven"] .. " / " .. records["data"]["lastGiven"]
        }

        local title = ("^0NCIC RECORD: ^2%s ^0/ ^2%s ^0| SSN: ^2%s ^0| DOB: ^2%s"):format(records["data"]["firstGiven"], records["data"]["lastGiven"], records["data"]["charID"], records["data"]["dob"])
        TriggerClientEvent("Chat:Client:SendMessage", src, "center", title)
        TriggerClientEvent("Chat:Client:SendMessage", src, "linebreak")

        -- GET ID NUMBER
        local idNum = "^3None Issued"
        if idNumber["status"] then
            idNum = "^3" .. idNumber["data"] or 0
        end

        -- COUNT OF ARRESTS
        local arrests = "^20"
        if #records["data"]["arrests"] >= 1 then
            arrests = "^3" .. #records["data"]["arrests"]
        end

        -- COUNT OF TICKETS
        local tickets = "^20"
        if #records["data"]["tickets"] >= 1 then
            tickets = "^3" .. #records["data"]["tickets"]
        end

        local str = ("Arrests: %s ^0| Tickets: %s ^0| ID Number: ^3%s"):format(arrests, tickets, idNum)
        TriggerClientEvent("Chat:Client:Message", src, "", str, "blank")

        TriggerClientEvent("Chat:Client:SendMessage", src, "linebreak")

        -- COURT ORDERS/WARRANTS/CAUTION CODES
        if courtRecords["status"] then
            if #courtRecords["data"]["cautioncodes"] >= 1 then
                local cautionCodeStr = ""
                for _, code in pairs(courtRecords["data"]["cautioncodes"]) do
                    cautionCodeStr = ("^1%s %s"):format(cautionCodeStr, code["recorddata"])
                end
                TriggerClientEvent("Chat:Client:Message", src, "", "Caution Codes: ^1" .. cautionCodeStr, "blank")
            else
                TriggerClientEvent("Chat:Client:Message", src, "", "Caution Codes: ^2None", "blank")
            end

            if #courtRecords["data"]["courtorders"] >= 1 then
                local courtOrderStr = ""
                for _, order in pairs(courtRecords["data"]["courtorders"]) do
                    courtOrderStr = ("^3%s | (%s) %s"):format(courtOrderStr, order["timestamp"], order["recorddata"])
                end
                TriggerClientEvent("Chat:Client:Message", src, "", "Court Orders: ^3" .. courtOrderStr, "blank")
            else
                TriggerClientEvent("Chat:Client:Message", src, "", "Court Orders: ^2None", "blank")
            end

            if #courtRecords["data"]["warrants"] >= 1 then
                local warrantStr = ""
                for _, warrant in pairs(courtRecords["data"]["warrants"]) do
                    warrantStr = ("^1%s | (%s) %s"):format(warrantStr, warrant["timestamp"], warrant["recorddata"])
                end
                TriggerClientEvent("Chat:Client:Message", src, "", "Warrants: ^1" .. warrantStr, "blank")
            else
                TriggerClientEvent("Chat:Client:Message", src, "", "Warrants: ^2None", "blank")
            end

            if #courtRecords["data"]["wants"] >= 1 then
                local wantsStr = ""
                for _, wants in pairs(courtRecords["data"]["wants"]) do
                    wantsStr = ("^1%s | (%s) %s"):format(wantsStr, wants["timestamp"], wants["recorddata"])
                end
                TriggerClientEvent("Chat:Client:Message", src, "", "Wants: ^1" .. wantsStr, "blank")
            else
                TriggerClientEvent("Chat:Client:Message", src, "", "Wants: ^2None", "blank")
            end
        else
            TriggerClientEvent("Chat:Client:Message", src, "", "Caution Codes: ^2None", "blank")
            TriggerClientEvent("Chat:Client:Message", src, "", "Court Orders: ^2None", "blank")
            TriggerClientEvent("Chat:Client:Message", src, "", "Warrants: ^2None", "blank")
            TriggerClientEvent("Chat:Client:Message", src, "", "Wants: ^2None", "blank")
        end
        TriggerClientEvent("Chat:Client:SendMessage", src, "linebreak")

        -- IF THEY HAVE AT LEAST ONE OFFENSE, LET THE OFFICER KNOW THEY CAN LOOK AT A COMPLETE RECORD
        if #records["data"]["arrests"] >= 1 or #records["data"]["tickets"] >= 1 then
            TriggerClientEvent("Chat:Client:Message", src, "[NCIC]", "More information available for this record by doing: /ncicfull", "standard")
        end
    end
end

-- RUNS PLATE AND RETURNS WITH APPROPRIATE DATA
local function Runplate(plate, src)
    local name
    local isRented = false
    plate = plate:upper()

    -- CHECK IF THE PLATE DOESN'T HAVE A NAME YET. IF SO, RETURN THE PREVIOUSLY ENTERED NAME
    if (rentedPlates[plate] ~= nil) then
        -- RETURN THE RENTAL INFORMATION OF THE VEHICLE
        name = rentedPlates[plate]
        isRented = true
        RunNCICRecord(rentedPlates[plate].char, "charID", src)
    elseif (localPlates[plate] == nil) then
        -- 75% CHANCE TO RETURN A LOCAL NAME FOR A LOCAL PLATE
        if (math.random(1, 100) <= 95) then
            local randomFirst = math.random(1, #firstNames)
            local randomLast = math.random(1, #lastNames)
            local first = firstNames[randomFirst]
            local last = lastNames[randomLast]

            name = string.format("%s %s", first, last)
            localPlates[plate] = name
        else
            -- ALWAYS PROVIDE A CHANCE TO NOT RETURN ANY INFO
            name = "NO RETURN"
            localPlates[plate] = name
        end
    else
        name = localPlates[plate]
    end

    -- SEND THE REQUESTING PLAYER THE PLATE DATA
    if not isRented then
        local ownedVeh = exports["soe-nexus"]:PerformAPIRequest("/api/valet/requestplate", ("plate=%s"):format(plate), true)
        if ownedVeh and ownedVeh.status then
            -- IF THE PLATE COMES BACK TO A OWNED VEHICLE
            RunNCICRecord(ownedVeh.data.OwnerID, "charID", src)
            TriggerClientEvent("Chat:Client:Message", src, "[NCIC]", ('Plate "%s" is registered to a %s owned by %s (SSN #%s)'):format(plate, ownedVeh.data.VehModel, ownedVeh.data.OwnerName, ownedVeh.data.OwnerID), "standard")
        else
            -- IF DOESN'T RETURN ANYTHING
            if (name == "NO RETURN") then
                TriggerClientEvent("Chat:Client:Message", src, "[NCIC]", ('Plate "%s" is not registered in the database.'):format(plate), "standard")
            else
                -- IF WE GOT A LOCAL NAME FOR THE PLATE
                TriggerClientEvent("Chat:Client:Message", src, "[NCIC]", ('Plate "%s" is registered to %s'):format(plate, name), "standard")
            end
        end
    else
        -- IF THE PLATE COMES BACK TO A RENTAL
        TriggerClientEvent("Chat:Client:Message", src, "[NCIC]", ('Plate "%s" is registered to a %s rented by %s'):format(plate, name.model, name.owner), "standard")
    end

    Wait(250)

    -- PROVIDE ADDITIONAL INFORMATION
    if stolenPlates[plate] then
        -- IF PLATE IS STOLEN
        TriggerClientEvent("Chat:Client:Message", src, "[NCIC]", "^1PLATE IS FLAGGED STOLEN.", "standard")
    else
        -- IF PLATE IS CLEAN
        TriggerClientEvent("Chat:Client:Message", src, "[NCIC]", "Plate has no flags.", "standard")
    end
end

-- SENDS THE REQUESTED PLAYER TO REHAB
local function SendPlayerToRehab(src, char, target, patient, reason)
    -- INSERT REHAB DATA TO DATABASE
    local name = ("%s %s %s"):format(char.JobTitle, char.FirstGiven, char.LastGiven)
    local dataString = ("charid=%s&heldby=%s&active=%s&reason=%s"):format(patient.CharID, name, 1, reason)

    local inputData = exports["soe-nexus"]:PerformAPIRequest("/api/rehab/updaterehabdata", dataString, true)
    if inputData.status then
        -- SEND TARGET TO PARSONS REHAB CENTER
        TriggerClientEvent("Emergency:Client:RehabPlayer", target, true, reason, name)

        -- NOTIFY EMS IN THE SESSION OF THE REHAB TRANSPORT
        TriggerEvent("Chat:Server:SendToEMS", "[Rehab]", ("%s sent %s %s to Parsons Rehabilitation Center for: %s"):format(name, patient.FirstGiven, patient.LastGiven, reason), "standard")
        exports["soe-logging"]:ServerLog("Rehab", ("HAS PLACED %s (%s / %s) INTO REHAB FOR: %s"):format(patient.Username, patient.FirstGiven, patient.LastGiven, reason), src)
    end
end

-- RELEASES THE REQUESTED PLAYER OUT OF REHAB
local function ReleasePlayerFromRehab(src, char, target, patient)
    local name = ("%s %s %s"):format(char.JobTitle, char.FirstGiven, char.LastGiven)
    local dataString = ("charid=%s&heldby=%s&active=%s&reason=%s"):format(patient.CharID, name, 0, "Released")

    local inputData = exports["soe-nexus"]:PerformAPIRequest("/api/rehab/updaterehabdata", dataString, true)
    if inputData.status then
        -- SEND TARGET TO PARSONS REHAB CENTER
        TriggerClientEvent("Emergency:Client:RehabPlayer", target, false)

        -- NOTIFY EMS IN THE SESSION OF THE REHAB RELEASE
        TriggerEvent("Chat:Server:SendToEMS", "[Rehab]", ("%s released %s %s from Parsons Rehabilitation Center."):format(name, patient.FirstGiven, patient.LastGiven), "standard")

        -- NOTIFY TARGETED PATIENT OF THE REHAB RELEASE
        TriggerClientEvent("Chat:Client:Message", target, "[Rehab]", "You have been released from Parsons Rehabilitation Center. You're now free to go!", "standard")
        exports["soe-logging"]:ServerLog("Rehab", ("HAS RELEASED %s (%s / %s) FROM REHAB"):format(patient.Username, patient.FirstGiven, patient.LastGiven), src)
    end
end

-- GIVE THE PLAYER A TICKET
local function TicketPlayer(amount, reason, src, target)
    -- ENTER TICKET INTO DATABASE
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    local name = ("%s %s %s - %s"):format(char.JobTitle, char.FirstGiven, char.LastGiven, char.Employer)

    local criminal = exports["soe-uchuu"]:GetOnlinePlayerList()[target]
    if not criminal then return end

    local dataString = ("charid=%s&type=%s&amount=%s&reason=%s&issuer=%s&shouldshow=%s"):format(criminal.CharID, "ticket", amount, reason, name, 1)
    local inputTicket = exports["soe-nexus"]:PerformAPIRequest("/api/records/inputrecord", dataString, true)
    if inputTicket.status then
        local inputter = ("%s %s"):format(char.JobTitle, char.LastGiven)
        local crim = ("%s %s"):format(criminal.FirstGiven, criminal.LastGiven)

        -- NOTIFY LEOs IN THE SESSION OF THE ISSUED TICKET
        TriggerEvent("Chat:Server:SendToLEOs", "[Ticket]", ("%s gave %s a ticket of $%s for: %s"):format(inputter, crim, amount, reason), "standard")

        -- NOTIFY TARGETED RECIPIENT OF THE ISSUED TICKET
        TriggerClientEvent("Chat:Client:Message", target, "[Ticket]", ("You have received a ticket of $%s by %s for: %s"):format(amount, inputter, reason), "standard")
        TriggerClientEvent("Chat:Client:Message", target, "[Ticket]", 'Do "/signticket" or "/refuseticket"', "standard")

        tickets[target] = {charges = reason, amount = amount, issuedTo = crim, issuedBy = inputter}
        exports["soe-logging"]:ServerLog("Ticket", ("HAS GIVEN %s (%s) A TICKET OF $%s FOR %s"):format(criminal.Username, crim, amount, reason), src)
    end
end

-- GIVE THE PLAYER A BILL AND ADD TO THEIR STATE DEBT
local function BillPlayer(amount, reason, src, target)
    -- ENTER BILL INTO DATABASE
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    local name = ("%s %s %s - %s"):format(char.JobTitle, char.FirstGiven, char.LastGiven, char.Employer)

    local criminal = exports["soe-uchuu"]:GetOnlinePlayerList()[target]
    if not criminal then return end

    local dataString = ("charid=%s&type=%s&amount=%s&reason=%s&issuer=%s&shouldshow=%s"):format(criminal.CharID, "bill", amount, reason, name, 1)
    local inputBill = exports["soe-nexus"]:PerformAPIRequest("/api/records/inputrecord", dataString, true)

    if inputBill.status then
        local inputter = ("%s %s"):format(char.JobTitle, char.LastGiven)
        local crim = ("%s %s"):format(criminal.FirstGiven, criminal.LastGiven)

        -- NOTIFY LEOs IN THE SESSION OF THE ISSUED BILL
        if exports["soe-bank"]:IncreaseStateDebt(target, amount, inputter, reason, true) then
            exports["soe-logging"]:ServerLog("Bill", ("HAS GIVEN %s (%s) A BILL OF $%s FOR %s"):format(criminal.Username, crim, amount, reason), src)

            TriggerEvent("Chat:Server:SendToLEOs", "[Bill]", ("%s gave %s a bill of $%s for: %s"):format(inputter, crim, amount, reason), "standard")
            TriggerClientEvent("Chat:Client:Message", target, "[Bill]", ("You have received a bill of $%s by %s for: %s"):format(amount, inputter, reason), "standard")
        end
    end
end

-- SEND THE PLAYER TO PRISON FOR A SPECIFIED AMOUNT OF TIME
local function ArrestPlayer(time, reason, src, target)
    -- ENTER ARREST INTO DATABASE
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    local name = ("%s %s %s - %s"):format(char.JobTitle, char.FirstGiven, char.LastGiven, char.Employer)

    local criminal = exports["soe-uchuu"]:GetOnlinePlayerList()[target]
    if not criminal then return end

    local dataString = ("charid=%s&type=%s&amount=%s&reason=%s&issuer=%s&shouldshow=%s"):format(criminal.CharID, "arrest", time, reason, name, 1)
    local inputArrest = exports["soe-nexus"]:PerformAPIRequest("/api/records/inputrecord", dataString, true)

    if inputArrest.status then
        local inputter = ("%s %s"):format(char.JobTitle, char.LastGiven)
        local crim = ("%s %s"):format(criminal.FirstGiven, criminal.LastGiven)

        -- NOTIFY LEOs IN THE SESSION OF THE SENTENCING
        if (tonumber(time) ~= 0) then
            TriggerEvent("Chat:Server:SendToLEOs", "[Jail]", ("%s sentenced %s to %s month(s) with charges of: %s"):format(inputter, crim, time, reason), "standard")
        else
            TriggerEvent("Chat:Server:SendToLEOs", "[Jail]", ("%s sentenced %s with charges of: %s"):format(inputter, crim, reason), "standard")
        end

        -- NOTIFY TARGETED CRIMINAL OF THE SENTENCING AND INCREASE PRISON TIME/SEND TO JAIL
        local increaseTime = exports["soe-nexus"]:PerformAPIRequest("/api/character/prisontime", ("charid=%s&prisontime=%s"):format(criminal.CharID, time), true)
        if increaseTime.status then
            -- SEND TARGET TO PRISON
            if (tonumber(time) ~= 0) then
                TriggerClientEvent("Prison:Client:ArrestPlayer", target, time)
                TriggerClientEvent("Chat:Client:Message", target, "[Jail]", ("You have been sentenced to %s month(s) by %s for: %s"):format(time, inputter, reason), "standard")
            else
                TriggerClientEvent("Chat:Client:Message", target, "[Jail]", ("You have been sentenced by %s for: %s"):format(inputter, reason), "standard")
            end

            -- CLEAR TARGET'S WARRANTS
            exports["soe-nexus"]:PerformAPIRequest("/api/court/removerecord", ("charid=%s&type=%s&cleartype=%s"):format(criminal.CharID, "warrant", "all"), true)
            exports["soe-crime"]:ModifyDrugRunReputation(target, "Arrested")
        end

        -- LOG THE ACTION
        exports["soe-logging"]:ServerLog("Arrest", ("HAS ARRESTED %s (%s) TO %s MONTHS FOR %s"):format(criminal.Username, crim, time, reason), src)
    end
end

function GetCallsign(charID)
    return callsigns[charID]
end

function UnmarkForImpound(plate)
    if markedForImpound[plate] then
        markedForImpound[plate] = false
    end
end

function GetServiceVehicles()
    local returnTable = leoMotorPool
    for _, veh in pairs(safrMotorPool) do
        table.insert(returnTable, veh)
    end
    return returnTable
end

-- REMINDS PLAYERS ON DUTY WITHOUT A CALLSIGN TO SET ONE
function RemindIfNoCallsign()
    for src, playerData in pairs(exports["soe-uchuu"]:GetOnlinePlayerList()) do
        local job = exports["soe-jobs"]:GetJob(src)
        if (job == "POLICE" or job == "EMS") then
            if (callsigns[playerData.CharID] == nil or callsigns[playerData.CharID] == "") then
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You do not have a callsign set. You must do so to receive MDT messages and such. Please do /callsign (your callsign)", length = 6500})
            end
        end
    end
end

-- ***********************
--        Commands
-- ***********************
RegisterCommand("vin", function(source)
    local src = source
    TriggerClientEvent("Emergency:Client:FindVehicleVin", src)
end)

RegisterCommand("putincar", function(source)
    local src = source
    TriggerClientEvent("Emergency:Client:PutInCarOptions", src)
end)

RegisterCommand("pullout", function(source)
    local src = source
    TriggerClientEvent("Emergency:Client:PulloutOptions", src)
end)

RegisterCommand("takefromcar", function(source)
    local src = source
    TriggerClientEvent("Emergency:Client:PulloutOptions", src)
end)

RegisterCommand("dog", function(source)
    local src = source
    local civType = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CivType
    if (civType == "POLICE" or civType == "EMS") then
        TriggerClientEvent("Emergency:Client:OpenDogDoors", src, {status = true})
        exports["soe-chat"]:DoProximityMessage(src, 10.0, "me", "", exports["soe-chat"]:GetDisplayName(src), "releases the dog.")
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for Emergency Services.")
    end
end)

RegisterCommand("doggo", function(source)
    local src = source
    local civType = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CivType
    if (civType == "POLICE" or civType == "EMS") then
        TriggerClientEvent("Emergency:Client:TransformToDog", src)
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for Emergency Services.")
    end
end)

RegisterCommand("rights", function(source)
    local src = source
    local civType = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CivType
    if (civType == "POLICE" or civType == "DOJ") then
        local name = exports["soe-chat"]:GetDisplayName(src)
        exports["soe-chat"]:DoProximityMessage(src, 10.0, "me", "", name, "shows a card containing the Miranda Warning.")
        exports["soe-chat"]:DoProximityMessage(src, 10.0, "police", "[Rights]", "", "You have the right to remain silent. Anything you say can and will be used against you in a court of law. You have the right to speak to an attorney, and to have an attorney present during any questioning. If you cannot afford a lawyer, one will be provided for you at government expense.  Do you understand these rights?")
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for LEO.")
    end
end)

RegisterCommand("impound", function(source, args)
    local src = source
    if (exports["soe-jobs"]:GetJob(src) == "POLICE") then
        local courtesy = false
        if (args[1] ~= nil) then
            courtesy = true
        end
        TriggerClientEvent("Emergency:Client:ImpoundVehicle", src, courtesy)
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for Emergency Services.")
    end
end)

RegisterCommand("rv", function(source)
    local src = source
    local isStaff = exports["soe-uchuu"]:IsStaff(src)
    local civType = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CivType
    if (civType == "EMS" or civType == "POLICE") or isStaff then
        TriggerClientEvent("Emergency:Client:DeleteVehicle", src)
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for Emergency Services.")
    end
end)

RegisterCommand("bodybag", function(source)
    local src = source
    local civType = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CivType
    if (civType == "EMS" or civType == "POLICE") then
        TriggerClientEvent("Emergency:Client:DeletePed", src)
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for Emergency Services.")
    end
end)

RegisterCommand("heal", function(source)
    local src = source
    local civType = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CivType
    if (civType == "EMS") then
        TriggerClientEvent("Emergency:Client:Heal", src)
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for SAFR.")
    end
end)

RegisterCommand("revive", function(source)
    local src = source
    local civType = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CivType
    if (civType == "EMS" or civType == "POLICE") then
        TriggerClientEvent("Emergency:Client:Revive", src, false)
    elseif exports["soe-factions"]:CheckPermission(src, "PPREVIVE") then
        TriggerClientEvent("Emergency:Client:Revive", src, true)
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for Emergency Services.")
    end
end)

RegisterCommand("alert", function(source, args, rawCommand)
    local src = source
    local isOnDuty = exports["soe-jobs"]:IsOnDuty(src)
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    if (char.CivType == "EMS" or char.CivType == "POLICE" or char.CivType == "DISPATCH" or char.CivType == "DOJ") and isOnDuty then
        TriggerClientEvent("Chat:Client:Message", -1, "[Statewide Advisory]", rawCommand:sub(6), "standard")

        exports["soe-logging"]:ServerLog("Sent Global Advisory", "HAS SENT A GLOBAL ADVISORY | MESSAGE: " .. rawCommand:sub(6), src)
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for Emergency Services.")
    end
end)

RegisterCommand("refuseticket", function(source)
    local src = source
    if (tickets[src] ~= nil) then
        tickets[src] = nil
        local name = exports["soe-chat"]:GetDisplayName(src)
        exports["soe-chat"]:DoProximityMessage(src, 10.0, "me-2", "", name, "refused to sign the citation.")
    else
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You don't have a pending citation", length = 5000})
    end
end)

RegisterCommand("signticket", function(source)
    local src = source
    if (tickets[src] ~= nil) then
        local meta = {charges = tickets[src].charges, amount = tickets[src].amount, issuedBy = tickets[src].issuedBy, issuedTo = tickets[src].issuedTo}

        tickets[src] = nil
        local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
        if exports["soe-inventory"]:AddItem(src, "char", charID, "citation", 1, json.encode(meta)) then
            if exports["soe-bank"]:IncreaseStateDebt(src, meta.amount, "the State of San Andreas", "Issued Citation", false) then
                local name = exports["soe-chat"]:GetDisplayName(src)
                exports["soe-chat"]:DoProximityMessage(src, 10.0, "me-2", "", name, "signs the citation.")
            end
        end
    else
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You don't have a pending citation", length = 5000})
    end
end)

RegisterCommand("ticket", function(source, args, rawCommand)
    local src = source
    local isOnDuty = exports["soe-jobs"]:IsOnDuty(src)
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    if (char.CivType == "POLICE") and isOnDuty then
        if (tonumber(args[1]) == nil) then return end
        if (tonumber(args[2]) == nil or tonumber(args[2]) <= 0) then return end

        local amount = math.floor(math.abs(tonumber(args[2])))
        local reason = rawCommand:sub(string.len("/ticket " .. args[1] .. " " .. args[2] .. " "))
        TicketPlayer(amount, reason, src, tonumber(args[1]))
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for LEO.")
    end
end)

RegisterCommand("bill", function(source, args, rawCommand)
    local src = source
    local isOnDuty = exports["soe-jobs"]:IsOnDuty(src)
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    if (char.CivType == "POLICE") and isOnDuty then
        if (tonumber(args[1]) == nil) then return end
        if (tonumber(args[2]) == nil or tonumber(args[2]) <= 0) then return end

        local amount = math.floor(math.abs(tonumber(args[2])))
        local reason = rawCommand:sub(string.len("/bill " .. args[1] .. " " .. args[2] .. " "))
        BillPlayer(amount, reason, src, tonumber(args[1]))
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for LEO.")
    end
end)

RegisterCommand("arrest", function(source, args, rawCommand)
    local src = source
    local isOnDuty = exports["soe-jobs"]:IsOnDuty(src)
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    if (char.CivType == "POLICE") and isOnDuty then
        if (tonumber(args[1]) == nil) then return end
        if (tonumber(args[2]) == nil) then return end

        local time = math.floor(tonumber(args[2]))
        local reason = rawCommand:sub(string.len("arrest " .. args[1] .. " " .. args[2] .. "  "), -1)
        ArrestPlayer(time, reason, src, tonumber(args[1]))
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for LEO.")
    end
end)

RegisterCommand("mdt", function(source, args, rawCommand)
    local src = source
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    if (char.CivType == "POLICE" or char.CivType == "DISPATCH" or char.CivType == "EMS" or char.CivType == "CRIMELAB") then
        if not args[1] then return end
        local myCallsign = callsigns[char.CharID]
        if not myCallsign then
            myCallsign = "NO CALLSIGN"
        end

        local msg = rawCommand:sub(string.len("/mdt " .. args[1] .. " "))

        -- GLOBAL MDT FUNCTION
        if (tostring(args[1]) == "all") then
            exports["soe-utils"]:PlayProximitySound(src, 4.8, "mdt-send.ogg", 0.52)
            TriggerEvent("Chat:Server:SendToJointES", "[MDT]", ("Global message from %s %s [%s]: %s"):format(char.JobTitle, char.LastGiven, myCallsign, msg), "mdt")
            return
        end

        local found
        for playerID, playerData in pairs(exports["soe-uchuu"]:GetOnlinePlayerList()) do
            if (tostring(callsigns[playerData.CharID]) == tostring(args[1])) then
                found = {char = playerData, src = playerID}
                break
            end
        end

        if found then
            -- IF NOT A VALID CALLSIGN
            if not found.src then return end
            if not found.char then return end

            -- WHAT THE SENDER SEES/HEARS
            local targetCallsign = callsigns[found.char.CharID]
            exports["soe-utils"]:PlayProximitySound(src, 4.8, "mdt-send.ogg", 0.52)
            TriggerClientEvent("Chat:Client:Message", src, "[MDT]", ("Message to %s %s [%s]: %s"):format(found.char.JobTitle, found.char.LastGiven, targetCallsign, msg), "mdt")

            -- WHAT THE RECEIVER SEES/HEARS
            exports["soe-utils"]:PlayProximitySound(found.src, 4.8, "mdt-receive.ogg", 0.52)
            TriggerClientEvent("Chat:Client:Message", found.src, "[MDT]", ("Message from %s %s [%s]: %s"):format(char.JobTitle, char.LastGiven, myCallsign, msg), "mdt")

            -- LOG THE ACTION
            local sentToName = ("%s (%s / %s)"):format(found.char.Username, found.char.FirstGiven, found.char.LastGiven)
            exports["soe-logging"]:ServerLog("MDT Message", ("HAS SENT AN MDT MESSAGE | TARGET: %s | MESSAGE: %s"):format(sentToName, msg), src)
        else
            TriggerClientEvent("Chat:Client:Message", src, "[MDT]", "Invalid Callsign.", "system")
        end
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for Emergency Services.")
    end
end)

RegisterCommand("rehab", function(source, args, rawCommand)
    local src = source
    local isOnDuty = exports["soe-jobs"]:IsOnDuty(src)
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    if (char.CivType == "EMS") and isOnDuty then
        local target = tonumber(args[1])
        if (target == nil) then return end

        local reason = rawCommand:sub(string.len("rehab " .. args[1] .. "  "), -1)
        if (reason == nil) then
            TriggerClientEvent("Chat:Client:Message", src, "[Rehab]", "Enter reason for rehab.", "standard")
            return
        end

        local patient = exports["soe-uchuu"]:GetOnlinePlayerList()[target]
        if (patient == nil) then return end

        SendPlayerToRehab(src, char, target, patient, reason)
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for SAFR.")
    end
end)

RegisterCommand("rehabrelease", function(source, args)
    local src = source
    local isOnDuty = exports["soe-jobs"]:IsOnDuty(src)
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    if (char.CivType == "EMS") and isOnDuty then
        local target = tonumber(args[1])
        if (target == nil) then
            return
        end

        local patient = exports["soe-uchuu"]:GetOnlinePlayerList()[target]
        if (patient == nil) then
            return
        end
        ReleasePlayerFromRehab(src, char, target, patient)
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for SAFR.")
    end
end)

RegisterCommand("ncic", function(source, args)
    local src = source
    local isOnDuty = exports["soe-jobs"]:IsOnDuty(src)
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    if (char.CivType == "POLICE" or char.CivType == "DISPATCH" or char.CivType == "DOJ") and isOnDuty then
        local subject, searchType
        if tonumber(args[1]) then
            -- SEARCH BY CHARID
            subject, searchType = tonumber(args[1]), "charID"
        else
            -- SEARCH BY NAME
            subject, searchType = table.concat(args, " "), "name"
        end

        RunNCICRecord(subject, searchType, src)
        exports["soe-logging"]:ServerLog("Records Check", "HAS RAN A RECORD CHECK ON: " .. subject, src)
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for LEO.")
    end
end)

RegisterCommand("ncicfull", function(source)
    local src = source
    local isOnDuty = exports["soe-jobs"]:IsOnDuty(src)
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    if (char.CivType == "POLICE" or char.CivType == "DISPATCH" or char.CivType == "DOJ") and isOnDuty then
        CheckLastRanNCICRecord(src)
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for LEO.")
    end
end)

RegisterCommand("runplate", function(source, args, raw)
    local src = source
    local isOnDuty = exports["soe-jobs"]:IsOnDuty(src)
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    if (char.CivType == "POLICE" or char.CivType == "DISPATCH" or char.CivType == "DOJ") and isOnDuty then
        -- MAKE SURE WE ENTERED A PLATE
        local plate = string.sub(raw, 10)

        if (plate == nil) then
            return
        end

        -- CANCEL IF PLATE SEEMS TOO LONG
        if (#plate > 10) then
            TriggerClientEvent("Chat:Client:Message", src, "[NCIC]", "ERROR: License plate is too long!", "standard")
            return
        end

        -- RUNS PLATE AND LOGS THE ACTION
        Runplate(plate, src)
        exports["soe-logging"]:ServerLog("Plate Check", "HAS RAN A PLATE CHECK ON: " .. plate:upper(), src)
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for LEO.")
    end
end)

RegisterCommand("reportveh", function(source, args, raw)
    local src = source
    local myJob = exports["soe-jobs"]:GetJob(src)
    if (myJob == "POLICE" or myJob == "DISPATCH") then
        if (args[1] == "stolen") then
            if (args[2] ~= nil) then
                local plate = string.sub(raw, 18) -- TEMPORARY
                MarkPlateStatus(plate, true, src, false)
            end
        elseif (args[1] == "recovered") then
            if (args[2] ~= nil) then
                local plate = string.sub(raw, 21) -- TEMPORARY
                MarkPlateStatus(plate, nil, src, false)
            end
        end
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for LEO.")
    end
end)

RegisterCommand("cautioncode", function(source, args, raw)
    local src = source
    local myJob = exports["soe-jobs"]:GetJob(src)
    if (myJob == "POLICE") then
        IssueCourtRecord(src, "cautioncode", tonumber(args[1]), args[2]:upper())
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for LEO.")
    end
end)

RegisterCommand("courtorder", function(source, args, raw)
    local src = source
    local myJob = exports["soe-jobs"]:GetJob(src)
    if (myJob == "POLICE") then
        IssueCourtRecord(src, "courtorder", tonumber(args[1]), raw:sub(string.len('/courtorder '..args[1]..' ')))
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for LEO.")
    end
end)

RegisterCommand("warrant", function(source, args, raw)
    local src = source
    local myJob = exports["soe-jobs"]:GetJob(src)
    if (myJob == "POLICE") then
        IssueCourtRecord(src, "warrant", tonumber(args[1]), raw:sub(string.len('/warrant '..args[1]..' ')))
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for LEO.")
    end
end)

RegisterCommand("want", function(source, args, raw)
    local src = source
    local myJob = exports["soe-jobs"]:GetJob(src)
    if (myJob == "POLICE") then
        IssueCourtRecord(src, "want", tonumber(args[1]), raw:sub(string.len('/want '..args[1]..' ')))
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for LEO.")
    end
end)

RegisterCommand("clearwants", function(source, args)
    local src = source
    if (exports["soe-jobs"]:GetJob(src) == "POLICE") then
        if not tonumber(args[1]) then return end

        local clearWants = exports["soe-nexus"]:PerformAPIRequest("/api/court/removerecord", ("charid=%s&type=%s&cleartype=%s"):format(tonumber(args[1]), "want", "all"), true)
        if clearWants.status then
            local name = exports["soe-chat"]:GetDisplayName(src)
            exports["soe-logging"]:ServerLog("Wants Cleared", "HAS CLEARED ALL WANTS ON SSN #%s" .. args[1], src)
            TriggerEvent("Chat:Server:SendToLEOs", "[NCIC]", name .. " has cleared all wants on SSN #" .. args[1], "standard")
        end
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for LEO.")
    end
end)

RegisterCommand("badge", function(source)
    local src = source
    local badgeItems = {"bcso_badge", "lspd_badge", "sasp_badge", "safr_badge", "saes_badge", "sacl_badge"}

    for index = 1, #badgeItems do
        local items = exports["soe-inventory"]:GetItemData(src, badgeItems[index], "left")

        -- FIND THE ITEM
        for uid, itemData in pairs(items) do
            -- ONLY DO THIS ONCE
            if itemData.ItemType == "bcso_badge" or itemData.ItemType == "lspd_badge" or itemData.ItemType == "sasp_badge" or itemData.ItemType == "safr_badge" or itemData.ItemType == "saes_badge" or itemData.ItemType == "sacl_badge" then
                TriggerEvent("Jobs:Server:UseBadge", {status = true, emergencyServicesBadge = true, itemName = itemData.ItemType, uid = uid, source = src})
            elseif itemData.ItemType == "cs_badge" then
                TriggerServerEvent("Jobs:Server:UseBadge", {status = true, itemName = itemData.ItemType, uid = uid})
            end
            return
        end
    end

    -- ERROR MESSAGE IF MADE IT TO END OF FOR LOOP
    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You do not have any badges!", length = 5500})
end)

RegisterCommand("callsign", function(source, args)
    local src = source
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    if (char.CivType == "POLICE" or char.CivType == "EMS" or char.CivType == "DISPATCH" or char.CivType == "CRIMELAB") then
        if #args[1] > 6 then
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Callsign must be 6 or less characters", length = 5500})
            return
        end

        local dataString
        local setting, deleting = false, false
        if (args[1] ~= nil) then
            setting = true
            dataString = ("charid=%s&callsign=%s"):format(char.CharID, args[1])
        else
            deleting = true
            dataString = ("charid=%s"):format(char.CharID)
        end

        local setCallsign = exports["soe-nexus"]:PerformAPIRequest("/api/callsign/setcallsign", dataString, true)
        if setCallsign.status then
            if setting then
                callsigns[char.CharID] = args[1]
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = ("You set your callsign as: %s"):format(args[1]), length = 5500})
            elseif deleting then
                callsigns[char.CharID] = nil
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "You cleared your callsign", length = 5500})
            end
        end
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for Emergency Services.")
    end
end)

RegisterCommand("mutedispatch", function(source)
    local src = source
    TriggerClientEvent("Emergency:Client:MuteDispatchNotifs", src, {status = true})
end)

RegisterCommand("10-38", function(source)
    local src = source
    local playerData = exports['soe-uchuu']:GetOnlinePlayerList()[src]
    if not (playerData.CivType == "POLICE" or playerData.CivType == "EMS" or playerData.CivType == "DISPATCH") then return end
    local charID = playerData.CharID
    TriggerClientEvent("Emergency:Client:10-38", src, callsigns[charID])
end)

RegisterCommand("10-78", function(source)
    local src = source
    local playerData = exports['soe-uchuu']:GetOnlinePlayerList()[src]
    if not (playerData.CivType == "POLICE" or playerData.CivType == "EMS" or playerData.CivType == "DISPATCH") then return end
    local charID = playerData.CharID
    TriggerClientEvent("Emergency:Client:10-78", src, callsigns[charID])
end)

RegisterCommand("clrequest", function(source)
    local src = source
    local playerData = exports['soe-uchuu']:GetOnlinePlayerList()[src]
    if not (playerData.CivType == "POLICE" or playerData.CivType == "EMS" or playerData.CivType == "DISPATCH") then return end
    local charID = playerData.CharID
    TriggerClientEvent("Emergency:Client:Forensics", src, callsigns[charID])
end)

RegisterCommand("respond", function(source, args)
    local src = source
    local playerData = exports['soe-uchuu']:GetOnlinePlayerList()[src]
    if not (playerData.CivType == "POLICE" or playerData.CivType == "EMS" or playerData.CivType == "DISPATCH") then return end
    -- RESPOND TO THE LATEST CAD ALERT IF NO ARGURMENTS OR ARGUEMENTS NOT A NUMBER
    if args == nil or not tonumber(args[1]) then
        TriggerClientEvent("Emergency:Client:RespondToCAD", src, #CADAlerts)
    else
        TriggerClientEvent("Emergency:Client:RespondToCAD", src, tonumber(args[1]))
    end
end)

-- GENERATE STATE EMAIL (IF ELIGIBLE)
RegisterCommand("getemail", function(source, args)
    local src = source
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]

    -- IF NOT ELIGIBLE, RETURN. LISTED DEPARTMENTS ARE ELIGIBLE
    if char.Employer ~= "LSPD" and char.Employer ~= "BCSO" and char.Employer ~= "SASP" and char.Employer ~= "SAFR" and char.Employer ~= "DOJ" 
    and char.Employer ~= "SACL" and char.Employer ~= "SAEC" and char.Employer ~= "SAES" and char.Employer ~= "SA" then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "This command is not for you!", length = 6500})
        return
    end

    -- CHECK IF PASSWORD IS VALID
    if args[1] == nil or args[1] == "" then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You must enter a valid password (no spaces) as a second argument!", length = 6500})
        return
    end

    -- GENERATE USERNAME
    local password = args[1]
    local username = string.lower(string.sub(char.FirstGiven, 0, 1) .. string.gsub(char.LastGiven, " ", "") .. "@" .. char.Employer .. ".gov")
    username = string.gsub(username, "'", "")

    -- TRY TO CREATE THE NEW ACCOUNT
    TriggerEvent("Phones:CreateNewAccount", function(data)
        -- SUCCESSFUL
        if data.status == true then
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "Your department email has been created with the entered password. The username is " .. username, length = 6500})
        -- UNSUCCESSFUL
        else
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Unable to create your department email. Perhaps you already created it?", length = 6500})
        end
    end, src, char.CharID, 0, "email", username, "", password)
end)

-- ***********************
--         Events
-- ***********************
-- SENT FROM CLIENT TO MARK A PLATE AS STOLEN
RegisterNetEvent("Emergency:Server:MarkStolen")
AddEventHandler("Emergency:Server:MarkStolen", function(plate, bool, localReported)
    local src = source
    MarkPlateStatus(plate, bool, src, localReported)
end)

-- CALLED FROM CLIENT TO CHECK IF THE VEHICLE BY PLATE IS MARKED FOR IMPOUND
AddEventHandler("Emergency:Server:IsVehicleMarkedForImpound", function(cb, src, plate)
    if markedForImpound[plate] then
        cb(true)
    else
        cb(false)
    end
end)

-- WHEN TRIGGERED, PUT TARGET INTO A VEHICLE
RegisterNetEvent("Emergency:Server:PutInCar", function(serverID, veh, seat)
    if not serverID then return end
    local ped = GetPlayerPed(serverID)
    local veh = NetworkGetEntityFromNetworkId(veh)

    ClearPedTasks(ped)
    Wait(100)
    SetPedIntoVehicle(ped, veh, seat)
end)

-- WHEN TRIGGERED, TAKE ALL OCCUPANTS OUT OF THE VEHICLE
RegisterNetEvent("Emergency:Server:Pullout", function(serverID)
    if not serverID then return end
    local ped = GetPlayerPed(serverID)

    -- MAKE PLAYER LEAVE THE VEHICLE
    ClearPedTasksImmediately(ped)
    ClearPedTasksImmediately(ped)
    TaskLeaveVehicle(ped, GetVehiclePedIsIn(ped, false), 256)
end)

-- CALLED FROM CLIENT TO CHECK IF A VEHICLE PLATE HAS A CERTAIN STATUS
AddEventHandler("Emergency:Server:GetVehicleStatus", function(cb, src, plate, type, netID)
    if (type == "stolen") then
        if stolenPlates[plate] then
            cb(true)
        else
            cb(false)
        end
    elseif (type == "rented") then
        if rentedPlates[plate] then
            cb(true)
        else
            cb(false)
        end
    elseif (type == "owned") then
        if not netID then error("netID is nil.") return end
        if exports["soe-valet"]:IsVehicleSpawned(netID) then
            cb(true)
        else
            cb(false)
        end
    end
end)

-- CALLED FROM CLIENT TO HEAL TARGET
RegisterNetEvent("Emergency:Server:HealPlayer")
AddEventHandler("Emergency:Server:HealPlayer", function(serverID)
    local src = source
    -- HEAL THE TARGET
    local name = exports["soe-chat"]:GetDisplayName(serverID)
    TriggerClientEvent("Emergency:Client:HealPlayer", serverID)
    exports["soe-chat"]:DoProximityMessage(serverID, 10.0, "me", "", name, "looks like they're feeling better.")

    -- HEAL THE MEDIC
    TriggerClientEvent("Emergency:Client:HealPlayer", src)
    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "You use your medical supplies to help yourself as well.", length = 5500})
end)

-- WHEN TRIGGERED, SEND A CAD ALERT TO ALL LEOs AND DISPATCH
RegisterNetEvent("Emergency:Server:CADAlerts")
AddEventHandler("Emergency:Server:CADAlerts", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 5838-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 5838-2 | Lua-Injecting Detected.", 0)
        return
    end

    -- OFFSET DATA
    local randomNum = math.random(0, 20)
    local xOffset = data.coords.x + randomNum
    Wait(1)
    math.randomseed(os.time())
    randomNum = math.random(0, 20)
    local yOffset = data.coords.y + randomNum

    data.offSet = {}
    data.offSet.xOffset = xOffset
    data.offSet.yOffset = yOffset

    -- STORE CALL INTO CAD TABLE FOR REFERENCING
    data.cadID = #CADAlerts + 1
    CADAlerts[data.cadID] = {data = data, time = time}

    local time = os.date("%H:%M", os.time())
    -- SEARCH THROUGH AND SEND A CAD ALERT TO ANY LEO/DISPATCH
    if data.global then
        for playerID in pairs(exports["soe-uchuu"]:GetOnlinePlayerList()) do
            local myJob = exports["soe-jobs"]:GetJob(playerID)
            if (myJob == "POLICE" or myJob == "DISPATCH" or (myJob == "CRIMELAB" and data.crimelab)) then
                TriggerClientEvent("Emergency:Client:CADAlerts", playerID, {status = true, data = data, time = time})
            end
        end
    else
        local myJob = exports["soe-jobs"]:GetJob(src)
        if (myJob == "POLICE" or myJob == "DISPATCH") then
            TriggerClientEvent("Emergency:Client:CADAlerts", src, {status = true, data = data, time = time})
        end
    end

    -- LOG THE SOURCE OF THE CAD ALERT
    exports["soe-logging"]:ServerLog("CAD Alert", ("HAS TRIGGERED A CAD ALERT | TYPE: %s | LOCATION: %s"):format(data.type, data.loc), src)
end)

-- SEND FROM CLIENT TO DECLARE A 10-13
RegisterNetEvent("Emergency:Server:Declare1013")
AddEventHandler("Emergency:Server:Declare1013", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 5839-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 5839-2 | Lua-Injecting Detected.", 0)
        return
    end

    -- CONSTRUCT THE DESCRIPTION
    local time = os.date("%H:%M", os.time())
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    local desc = ("^1[10-13] ^7%s %s. %s has activated their panic button. Their last reported location was %s."):format(char.JobTitle, (char.FirstGiven):sub(0, 1), char.LastGiven, data.loc)

    -- SEARCH THROUGH AND SEND A DISTRESS ALERT TO ANY LEO/EMS/DISPATCH
    for playerID in pairs(exports["soe-uchuu"]:GetOnlinePlayerList()) do
        local myJob = exports["soe-jobs"]:GetJob(playerID)
        if (myJob == "POLICE" or myJob == "EMS" or myJob == "DISPATCH") then
            TriggerClientEvent("Emergency:Client:Declare1013", playerID, {status = true, pos = data.pos, role = myJob})
            TriggerClientEvent("Chat:Client:Message", playerID, ("[CAD (%s)]"):format(time), desc, "system")
        end
    end

    -- LOG THE SOURCE OF THE 10-13
    exports["soe-logging"]:ServerLog("Emergency Declared (10-13)", "HAS DECLARED A 10-13 AT " .. data.loc, src)
end)

-- SENT FROM CLIENT TO MARK A PLATE AS RENTED
RegisterNetEvent("Emergency:Server:SetRented", function(model, plate, owner)
    local src = source
    if not plate then
        return
    end

    -- GET MODEL, CHARACTER ID AND NAME
    local registration = {}
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]

    registration["model"] = model
    registration["char"] = char.CharID
    if (owner ~= nil) then
        registration["owner"] = tostring(owner)
    else
        registration["owner"] = ("%s %s"):format(char.FirstGiven, char.LastGiven)
    end
    rentedPlates[plate] = registration
end)

-- SENT FROM CLIENT TO REDUCE SOME TIME IN JAIL
RegisterNetEvent("Emergency:Server:ReduceSentence")
AddEventHandler("Emergency:Server:ReduceSentence", function(reduction, fromJob)
    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID

    -- CHECK IF REDUCTION IS FROM A PRISON JOB, DO SOME EXTRA STEPS
    if fromJob then
        -- GET THE PLAYER'S PRISON TIME FIRST
        local time = exports["soe-nexus"]:PerformAPIRequest("/api/character/prisontime", ("charid=%s"):format(charID), true)
        local newTime = tonumber(time.data) - tonumber(reduction)

        -- FINALLY SET THE PLAYER'S PRISON TIME
        local updatePrisonTime = exports["soe-nexus"]:PerformAPIRequest("/api/character/prisontime", ("charid=%s&prisontime=%s"):format(charID, newTime), false)
        if updatePrisonTime.status then
            TriggerClientEvent("Prison:Client:SyncJailTime", src, tonumber(newTime))
        end
    else
        -- SET THE PLAYER'S PRISON TIME
        exports["soe-nexus"]:PerformAPIRequest("/api/character/prisontime", ("charid=%s&prisontime=%s"):format(charID, reduction), false)
    end
end)

-- CALLED FROM CLIENT TO IMPOUND A VEHICLE NOW THAT WE HAVE A MODEL AND PLATE
RegisterNetEvent("Emergency:Server:ImpoundVehicle")
AddEventHandler("Emergency:Server:ImpoundVehicle", function(model, plate, courtesy, fromTowCall)
    local src = source

    -- MOVE VEHICLE TO IMPOUND LOT
    if not markedForImpound[plate] then
        markedForImpound[plate] = true
        if fromTowCall then return end

        -- NOTIFY ALL LEOs THAT A VEHICLE WAS MARKED FOR IMPOUND
        local name = exports["soe-chat"]:GetDisplayName(src)
        TriggerEvent("Chat:Server:SendToLEOs", "[Impound]", ('%s | Plate "%s" has been marked for impound by %s.'):format(model, plate, name), "standard")

        -- SEND THE VEHICLE TO THE IMPOUND LOT IF IT IS A PERSONAL
        local impoundVehicle = exports["soe-nexus"]:PerformAPIRequest("/api/valet/impound", ("plate=%s"):format(plate), true)
        if not impoundVehicle.status then return end

        for playerID, playerData in pairs(exports["soe-uchuu"]:GetOnlinePlayerList()) do
            if (tonumber(playerData.CharID) == tonumber(impoundVehicle.data)) then
                if not courtesy then
                    if exports["soe-bank"]:IncreaseStateDebt(playerID, 85, "San Andreas Towing", "Impound Fee", true) then
                        TriggerClientEvent("Chat:Client:Message", playerID, "[Impound]", ('Your %s | Plate "%s" has been marked for impound. $200 has been added to your state debt.'):format(model, plate), "standard")
                    end
                else
                    TriggerClientEvent("Chat:Client:Message", playerID, "[Impound]", ('Your %s | Plate "%s" has been marked for impound. The fee was waived.'):format(model, plate), "standard")
                end
            end
        end
    else
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Vehicle was already marked for impound!", length = 5500})
    end
end)

-- CALLED FROM CLIENT UPON SPAWN TO RESTORE CALLSIGN/CHECK JAIL/REHAB STATUS
RegisterNetEvent("Uchuu:Server:PlayerSpawned")
AddEventHandler("Uchuu:Server:PlayerSpawned", function()
    -- CALLSIGN CHECK
    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID

    local dataString = ("charid=%s"):format(charID)
    local getCallsign = exports["soe-nexus"]:PerformAPIRequest("/api/callsign/getcallsign", dataString, true)
    if getCallsign.status then
        callsigns[charID] = getCallsign.data.Callsign
    end

    Wait(3500)
    -- ASK THE DATABASE IF THE CHARACTER HAS A REHAB HOLD ACTIVE
    local rehabData = exports["soe-nexus"]:PerformAPIRequest("/api/rehab/requestdata", dataString, true)
    if rehabData.status then
        if (rehabData.data.Active == 1) then
            TriggerClientEvent("Emergency:Client:RehabPlayer", src, true, rehabData.data.Reason, rehabData.data.HeldBy)
        end
    end

    -- ASK THE DATABASE IF THE CHARACTER HAS A JAIL SENTENCE ACTIVE
    local jailTime = exports["soe-nexus"]:PerformAPIRequest("/api/character/prisontime", dataString, true)
    if jailTime.status then
        local time = tonumber(jailTime.data)
        if (time > 0) then
            TriggerClientEvent("Prison:Client:ArrestPlayer", src, time)
            TriggerClientEvent("Chat:Client:Message", src, "[Jail]", ("You wake up in your jail cell, you still have %s months left."):format(time), "standard")
        end
    end
end)

-- WHEN TRIGGERED, CALLBACK TO CLIENT WITH SERVER STOCK TAKING DATA
AddEventHandler("Emergency:Server:GetCADs", function(cb, src)
    cb(CADAlerts)
end)
