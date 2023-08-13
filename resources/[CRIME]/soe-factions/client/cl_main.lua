local localLostMCHash = -1865950624
local _, playerLostMCHash = AddRelationshipGroup("playerLostMCHash")
local _, playerGSBHash = AddRelationshipGroup("playerGSBHash")
local _, playerCGFHash = AddRelationshipGroup("playerCGFHash")
local _, playerLVEHash = AddRelationshipGroup("playerLVEHash")
isClockedIn, factionName, rate = false, nil, 0

myFactions = {}

-- ***********************
--    Local Functions
-- ***********************
local function ClockIn(newFactionName, newRate, factionSubtype, clockOff)
    --[[print("-- CLOCKIN/OFF --")
    print("factionName", factionName)
    print("newFactionName", newFactionName)
    print("newRate", newRate)
    print("clockOff", clockOff)]]

    if newRate <= 0 and not clockOff then
        exports["soe-ui"]:SendAlert("error", ("Your pay rate for this business is 0!"), 5000)
        return
    elseif clockOff then
        if isClockedIn then
            isClockedIn = false
        else
            exports["soe-ui"]:SendAlert("error", "You must be clocked in before clocking off!", 5000)
            return
        end
    else
        isClockedIn = not isClockedIn
    end

    if factionName == nil then
        factionName = newFactionName
    elseif factionName ~= newFactionName then
        newFactionName = factionName
    end

    if isClockedIn then
        exports["soe-ui"]:SendAlert("success", ("Clock in! | %s | $%s"):format(newFactionName, newRate), 5000)

        -- IF PLAYER CLOCKS INTO WEAZEL NEWS, CLOCK INTO LOCAL JOB ALSO TO RECEIVE ALERTS
        if factionSubtype == "weazelnews" then
            TriggerServerEvent("Jobs:Server:ToggleDuty", {status = true, dutyStatus = true, job = "NEWS", silent = true})
        else
            TriggerServerEvent("Jobs:Server:ToggleDuty", {status = true, dutyStatus = false, job = "NEWS", silent = true})
        end

        rate = newRate
    else
        exports["soe-ui"]:SendAlert("success", ("Clock off! | %s"):format(newFactionName), 5000)

        -- IF PLAYER CLOCKS OUT, CLOCK OUT OF LOCAL JOB TO STOP RECEIVING ALERTS
        TriggerServerEvent("Jobs:Server:ToggleDuty", {status = true, dutyStatus = false, job = "NEWS", silent = true})

        factionName = nil
        rate = 0
    end
end

-- ***********************
--    Global Functions
-- ***********************
-- WHEN TRIGGERED, SET RELATIONSHIPS WITH PLAYERS IF THEY ARE IN A GANG
function SetGangRelationships()
    local ped = PlayerPedId()
    local gangName = GetGangName()
    local defaultHash = GetPedRelationshipGroupDefaultHash(ped)

    -- THE LOST MC
    if (gangName == "The Lost MC") then
        -- ADD PLAYER TO THE PLAYER GROUP
        SetPedRelationshipGroupHash(ped, playerLostMCHash)

        -- SET RELATION BETWEEN PLAYER AND LOCAL
        SetRelationshipBetweenGroups(0, playerLostMCHash, localLostMCHash)
        SetRelationshipBetweenGroups(0, localLostMCHash, playerLostMCHash)
    else
        SetRelationshipBetweenGroups(3, playerLostMCHash, defaultHash)
        SetRelationshipBetweenGroups(3, defaultHash, playerLostMCHash)
    end

    -- GROVE STREET BALLAS
    if (gangName == "Grove Street Ballas") then
        -- ADD PLAYER TO THE PLAYER GROUP
        SetPedRelationshipGroupHash(ped, playerGSBHash)

        -- SET RELATION BETWEEN PLAYER AND LOCAL
        SetRelationshipBetweenGroups(0, playerGSBHash, GetHashKey("AMBIENT_GANG_BALLAS"))
        SetRelationshipBetweenGroups(0, GetHashKey("AMBIENT_GANG_BALLAS"), playerGSBHash)
    else
        SetRelationshipBetweenGroups(3, playerGSBHash, defaultHash)
        SetRelationshipBetweenGroups(3, defaultHash, playerGSBHash)
    end

    -- CHAMBERLAIN GANGSTER FAMILY
    if (gangName == "Chamberlain Gangster Families") then
        -- ADD PLAYER TO THE PLAYER GROUP
        SetPedRelationshipGroupHash(ped, playerCGFHash)

        -- SET RELATION BETWEEN PLAYER AND LOCAL
        SetRelationshipBetweenGroups(0, playerCGFHash, GetHashKey("AMBIENT_GANG_FAMILY"))
        SetRelationshipBetweenGroups(0, GetHashKey("AMBIENT_GANG_FAMILY"), playerCGFHash)
    else
        SetRelationshipBetweenGroups(3, playerCGFHash, defaultHash)
        SetRelationshipBetweenGroups(3, defaultHash, playerCGFHash)
    end

    -- LOS VAGOS DEL ESTE
    if (gangName == "Los Vagos del este") then
        -- ADD PLAYER TO THE PLAYER GROUP
        SetPedRelationshipGroupHash(ped, playerLVEHash)

        -- SET RELATION BETWEEN PLAYER AND LOCAL
        SetRelationshipBetweenGroups(0, playerLVEHash, 296331235)
        SetRelationshipBetweenGroups(0, 296331235, playerLVEHash)
    else
        SetRelationshipBetweenGroups(3, playerLVEHash, defaultHash)
        SetRelationshipBetweenGroups(3, defaultHash, playerLVEHash)
    end
end

-- WHEN TRIGGERED, GET NAME OF A GANG THE PLAYER IS IN
function GetGangName()
    -- GANG RULES STATE ONLY ONE GANG PER CHARACTER, THIS'LL DO FINE FOR NOW
    -- ITERATE THROUGH AND GET THE NAME OF THE CHARACTER'S GANG

    local name
    for _, faction in pairs(myFactions) do
        if (faction.FactionData.FactionSubtype == "gang") then
            name = tostring(faction.FactionData.FactionName)
            break
        end
    end
    return name
end

-- WHEN TRIGGERED, CHECK FACTION PERMISSIONS OF PLAYER
function CheckPermission(checkPerm)
    local charID = exports["soe-uchuu"]:GetPlayer().CharID
    local factions = exports["soe-nexus"]:TriggerServerCallback("Factions:Server:GetMyFactions", charID)

    for _, faction in pairs(factions) do
        -- IF PERSON HAS THE PERMISSION IN THEIR PERMISSION LIST
        if faction.MyData.Permissions then
            for _, permission in pairs(json.decode(faction.MyData.Permissions)) do
                if permission == checkPerm then
                    return true
                end
            end
        end

        -- IF PERSON IS AN OWNER OF THE RELEVANT FACTION SUBTYPE
        if roles[faction.MyData.Role] <= 1 then
            for category, categoryPerms in pairs(perms) do
                for categoryPerm, _ in pairs(categoryPerms) do
                    if categoryPerm == checkPerm and category == faction.FactionData.FactionSubtype then
                        return true
                    end
                end
            end
        end
    end

    -- NO PERMS
    return false
end

-- WHEN TRIGGERED, GET FACTION NAME WITH PERM
function GetFactionWithPerm(perm)
    local charID = exports["soe-uchuu"]:GetPlayer().CharID
    local factions = exports["soe-nexus"]:TriggerServerCallback("Factions:Server:GetMyFactions", charID)

    for _, faction in pairs(factions) do
        -- IF PERSON HAS THE PERMISSION IN THEIR PERMISSION LIST
        if faction.MyData.Permissions then
            for _, permission in pairs(json.decode(faction.MyData.Permissions)) do
                if permission == perm then
                    return faction.FactionData.FactionName
                end
            end
        end

        -- IF PERSON IS AN OWNER OF THE RELEVANT FACTION SUBTYPE
        if roles[faction.MyData.Role] <= 1 then
            for category, categoryPerms in pairs(perms) do
                for categoryPerm, _ in pairs(categoryPerms) do
                    if categoryPerm == perm and category == faction.FactionData.FactionSubtype then
                        return faction.FactionData.FactionName
                    end
                end
            end
        end
    end

    -- NO PERMS
    return false
end

function IsClockedIn()
    return isClockedIn
end

function GetClockinData()
    return {status = true, clockedIn = isClockedIn, businessName = factionName, rate = rate}
end

-- ***********************
--         Events
-- ***********************
-- WHEN TRIGGERED, REQUEST CHARACTER'S FACTIONS THROUGH SPAWNING
AddEventHandler("Uchuu:Client:CharacterSelected", function(charID)
    myFactions = exports["soe-nexus"]:TriggerServerCallback("Factions:Server:GetMyFactions", charID)

    Wait(6500)
    SetGangRelationships()
end)

RegisterNetEvent("Factions:Client:Clockin")
AddEventHandler("Factions:Client:Clockin", function(factionData, args)
    -- TRY TO CLOCK OFF IF NO ARGS ARE PASSED
    if #args == 0 then
        -- CLOCKOFF
        ClockIn(_, _, _, true)
        return
    end

    -- PROCESS THE FACTION DATA AND CLOCK THE PLAYER IN
    local factionName, factionSubtype, rate, found = nil, nil, 0, false
    for _, faction in pairs(factionData) do
        if faction.FactionData.FactionType == "business" then
            -- PROCESS THE ARGS AND CONSTRUCT THE BUSINESS NAME PLAYER IS TRYING TO CLOCKIN TO
            local businessName = tostring(args)
            if args[1] ~= nil then
                for index, value in pairs(args) do
                    if index >= 2 then
                        businessName = string.format("%s %s", businessName, value)
                    else
                        businessName = value
                    end
                end
            end

            -- CHECK IF PLAYER IS PART OF THAT FACTION
            if string.lower(businessName) == string.lower(faction.FactionData.FactionName) then
                factionName = faction.FactionData.FactionName
                factionSubtype = faction.FactionData.FactionSubtype

                -- SAFETY CHECKS AND INIT
                if faction.MyData.Rate > maxClockinRate then
                    return
                elseif faction.MyData.Role == "Owner" and (faction.MyData.Rate <= 0 or faction.MyData.Rate > maxClockinRate) then
                    -- SET THE CLOCKING RATE FOR OWNER TO MAX
                    rate = maxClockinRate

                    -- OWNER RATE WAS NOT INITIALIZED
                    local initOwnerRate = exports["soe-nexus"]:TriggerServerCallback("Factions:Server:ModifyFactionRoster", faction.MyData.EntryID, "Rate", maxClockinRate)
                    if initOwnerRate then
                        print(("SUCCESS - Owner Rate initialized to: %s"):format(maxClockinRate))
                    else
                        print("ERROR - An error occurred while updating owner's rate.")
                    end
                else
                    rate = faction.MyData.Rate
                end

                found = true
                break
            end
        end
    end

    -- NO MATCHING FACTION FOUND
    if not found then
        exports["soe-ui"]:SendAlert("error", "You are not part of this faction!", 5000)
    else
        ClockIn(factionName, rate, factionSubtype)
    end
end)
