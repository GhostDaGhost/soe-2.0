local gsr, casings, bloodDrops, fingerprints, vehFingerprints, vehicleFragments = {}, {}, {}, {}, {}, {} -- GENERAL VARIABLES
local analyzedBlood, scannedCasings, analyzedPrints, analyzedFragments = {}, {}, {}, {} -- ANALYZED ITEMS AWAITING RETURN
local forensicsQueue = {} -- QUEUE OF ITEMS TO BE ANALYZED WHEN INVENTORY IS CLOSED

local vehSeats = { -- MAP OF SEATS TO THEIR DOOR NAMES
    [-1] = "Front Left Door",
    [0] = "Front Right Door",
    [1] = "Rear Left Door",
    [2] = "Rear Right Door"
}

-- ***********************
--     HTTP Handlers
-- ***********************
-- WHEN TRIGGERED, DO THE FOLLOWING
SetHttpHandler(function(req, res)
    if (req.path == "/csidebug.json") then -- DEBUG
        local returnData = {
            ["gsr"] = gsr,
            ["casings"] = casings,
            ["blood"] = bloodDrops,
            ["prints"] = fingerprints,
            ["vehprints"] = vehFingerprints,
            ["vehfragments"] = vehicleFragments
        }
        res.send(json.encode(returnData))
    end
end)

-- ***********************
--     Local Functions
-- ***********************
-- WHEN TRIGGERED, CREATE UNIQUE IDs FOR CASINGS
local function GenerateEvidenceID(type)
    if (type == "Casing") then
        local caseID = math.random(10000, 99999)
        if (casings[caseID] ~= nil) then
            caseID = math.random(10000, 99999)
        end
        return caseID
    elseif (type == "Blood") then
        local bloodID = math.random(10000, 99999)
        if (bloodDrops[bloodID] ~= nil) then
            bloodID = math.random(10000, 99999)
        end
        return bloodID
    elseif (type == "Fingerprint") then
        local printID = math.random(10000, 99999)
        if (fingerprints[printID] ~= nil) then
            printID = math.random(10000, 99999)
        end
        return printID
    elseif (type == "Vehicle Fragment") then
        local fragmentID = math.random(10000, 99999)
        if (vehicleFragments[fragmentID] ~= nil) then
            fragmentID = math.random(10000, 99999)
        end
        return fragmentID
    end
end

-- ***********************
--    Global Functions
-- ***********************
-- WHEN TRIGGERED, ADD AN ITEM TO THE QUEUE TO BE ANALYZED ONCE INV IS CLOSED
function AddToForensicsQueue(itemID, forensicType, src)
    local sauce = src
    local itemID = tostring(itemID)
    local myInventory = exports["soe-inventory"]:RequestInventory(src, "left", true)

    if forensicsQueue[src] == nil then
        forensicsQueue[src] = {
            ["casings"] = {},
            ["blood"] = {},
            ["prints"] = {},
            ["vehfragments"] = {}
        }
    end

    local item = myInventory["leftInventory"][itemID]
    if forensicType == 1 and (item["ItemType"] == "pistol_casing" or item["ItemType"] == "shotgun_shell" or item["ItemType"] == "rifle_casing") then
        forensicsQueue[src]["casings"][#forensicsQueue[src]["casings"] + 1] = json.decode(item["ItemMeta"])["casingID"]
    elseif forensicType == 2 and item["ItemType"] == "bloodsample" then
        forensicsQueue[src]["blood"][#forensicsQueue[src]["blood"] + 1] = json.decode(item["ItemMeta"])["bloodID"]
    elseif forensicType == 3 and item["ItemType"] == "liftedprint" then
        forensicsQueue[src]["prints"][#forensicsQueue[src]["prints"] + 1] = json.decode(item["ItemMeta"])["printID"]
    elseif forensicType == 4 and item["ItemType"] == "vehiclefragment" then
        forensicsQueue[src]["vehfragments"][#forensicsQueue[src]["vehfragments"] + 1] = json.decode(item["ItemMeta"])["fragmentID"]
    end
end

-- ***********************
--        Commands
-- ***********************
-- COMMAND MADE TO IDENTIFY CLOSEST PLAYER
RegisterCommand("identify", function(source)
    local src = source
    local civType = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CivType
    if (civType == "POLICE" or civType == "EMS") then
        TriggerClientEvent("CSI:Client:IdentifyPlayer", src)
    else
        TriggerClientEvent("Chat:Client:SendMessage", src, "system", "This command is only available for Emergency Services.")
    end
end)

-- WHEN TRIGGERED, GET IF CRIME LAB IS AVAILABLE
RegisterCommand("techsonduty", function(source)
    local src = source
    local count = exports["soe-jobs"]:GetDutyCount("CRIMELAB")
    if (count >= 1) then
        TriggerClientEvent("Chat:Client:Message", src, "[SA Crime Lab]", "There's at least 1 lab tech currently on duty!", "bank")
    else
        TriggerClientEvent("Chat:Client:Message", src, "[SA Crime Lab]", "There's no lab techs on duty currently!", "bank")
    end
end)

-- ***********************
--         Events
-- ***********************
-- WHEN TRIGGERED, SYNC EVIDENCE UPON RESOURCE STARTUP
AddEventHandler("CSI:Server:SyncEvidence", function(cb, src)
    cb(casings, bloodDrops, fingerprints, vehicleFragments)
end)

-- WHEN TRIGGERED, CLEAN FINGERPRINTS FROM VEHICLE
RegisterNetEvent("CSI:Server:CleanPrintsFromVeh")
AddEventHandler("CSI:Server:CleanPrintsFromVeh", function(plate)
    if vehFingerprints[plate] ~= nil then
        vehFingerprints[plate] = {}
    end
end)

-- WHEN TRIGGERED, INFLICT GSR ON SOURCE UPON SHOOTING
RegisterNetEvent("CSI:Server:InflictGSR", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 77767-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data["status"] then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 77767-2 | Lua-Injecting Detected.", 0)
        return
    end
    gsr[src] = GetGameTimer()
end)

-- WHEN TRIGGERED, USE GSR KIT TO FIND IF POSITIVE OR NEGATIVE FOR RESIDUE
RegisterNetEvent("CSI:Server:UseGSRKit", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 77766-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data["status"] then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 77766-2 | Lua-Injecting Detected.", 0)
        return
    end

    local target = data["target"]
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[target]
    if (gsr[target] == nil or gsr[target] + 1800000 < GetGameTimer()) then
        TriggerClientEvent("Chat:Client:Message", src, "[GSR]", data["kitName"] .. " | Negative", "standard")
        TriggerEvent("CSI:Server:GiveItem", "gsr", {["result"] = "Negative", ["label"] = data["kitName"]}, src)
    else
        TriggerClientEvent("Chat:Client:Message", src, "[GSR]", data["kitName"] .. " | Positive", "standard")
        TriggerEvent("CSI:Server:GiveItem", "gsr", {["result"] = "Positive", ["label"] = data["kitName"]}, src)
    end
end)

-- WHEN TRIGGERED, UPDATE THE FINGERPRINTS TABLE
RegisterNetEvent("CSI:Server:AddFingerprint")
AddEventHandler("CSI:Server:AddFingerprint", function()
    local src = source
    local pos = GetEntityCoords(GetPlayerPed(src))

    local printID = GenerateEvidenceID("Fingerprint")
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]

    -- INSERT INTO FINGERPRINTS TABLE
    fingerprints[printID] = {
        ["pos"] = pos or vector3(0, 0, 0),
        ["dna"] = char.CharID or 0,
        ["time"] = os.date("%x %X")
    }

    -- UPDATE ALL CLIENTS' FINGERPRINTS TABLE
    TriggerClientEvent("CSI:Client:AddFingerprint", -1, printID, fingerprints[printID])
end)

-- WHEN TRIGGERED, UPDATE THE VEHICLE FINGERPRINTS TABLE
RegisterNetEvent("CSI:Server:AddVehFingerprint", function(data)
    local src = source
    local printID = GenerateEvidenceID("Fingerprint")
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]

    -- IF THE PLATE ALREADY EXISTS
    local plate, door = data["plate"], data["door"]
    if vehFingerprints[plate] ~= nil then
        vehFingerprints[plate][door] = {["dna"] = char.CharID, ["plate"] = plate, ["pos"] = data["pos"]}
    else
        vehFingerprints[plate] = {}
        vehFingerprints[plate][door] = {["dna"] = char.CharID, ["plate"] = plate, ["pos"] = data["pos"]}
    end
end)

-- WHEN TRIGGERED, DUST VEHICLE FOR FINGERPRINTS
RegisterNetEvent("CSI:Server:DustForVehPrints")
AddEventHandler("CSI:Server:DustForVehPrints", function(plate, seat)
    local src = source
    if vehFingerprints[plate] ~= nil then
        for vehSeat, data in pairs(vehFingerprints[plate]) do
            if vehSeat == seat then
                local printMeta = {printID = GenerateEvidenceID("Fingerprint"), dna = data.dna, data = data["plate"], data2 = vehSeats[seat], location = data.pos, printType = "Vehicle"}
                TriggerEvent("CSI:Server:GiveItem", "fingerprint", printMeta, src)
                vehFingerprints[plate][vehSeat] = nil
                return
            end
        end
    end
    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "No prints were found on this surface.", length = 1500})
end)

-- WHEN TRIGGERED, UPDATE THE BLOOD SPLATTER TABLE
RegisterNetEvent("CSI:Server:SpillBlood")
AddEventHandler("CSI:Server:SpillBlood", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 77762-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data["status"] then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 77762-2 | Lua-Injecting Detected.", 0)
        return
    end

    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    local bloodID = GenerateEvidenceID("Blood")
    local pos = GetEntityCoords(GetPlayerPed(src))

    bloodDrops[bloodID] = { -- INSERT INTO BLOOD DROPS TABLE
        ["pos"] = pos or vector3(0, 0, 0),
        ["dna"] = char.CharID or 0,
        ["time"] = os.date("%x %X")
    }

    -- UPDATE ALL CLIENTS' BLOOD DROP TABLE
    TriggerClientEvent("CSI:Client:SpillBlood", -1, bloodID, bloodDrops[bloodID])
    exports["soe-logging"]:ServerLog("Blood Spilled", "HAS SPILLED SOME BLOOD | DATA: " .. json.encode(bloodDrops[bloodID]), src)
end)

-- WHEN TRIGGERED, ADD VEHICLE FRAGMENT
RegisterNetEvent("CSI:Server:AddVehicleFragment", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 777695-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data["status"] then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 777695-1 | Lua-Injecting Detected.", 0)
        return
    end

    local veh = NetworkGetEntityFromNetworkId(data["veh"])
    local pos = GetEntityCoords(veh)
    local primaryColor = GetVehicleColours(veh)

    local genericColor = exports["soe-utils"]:GetGenericVehicleColor(primaryColor)
    local detailedColor = exports["soe-utils"]:GrabVehicleColors()[tostring(primaryColor)]

    local fragmentID = GenerateEvidenceID("Vehicle Fragment")
    vehicleFragments[fragmentID] = { -- INSERT INTO BLOOD DROPS TABLE
        ["pos"] = pos or vector3(0, 0, 0),
        ["genericColor"] = genericColor or "Unknown Color",
        ["detailedColor"] = detailedColor or "Unknown Color"
    }

    -- UPDATE ALL CLIENTS' VEHICLE FRAGMENT TABLE
    TriggerClientEvent("CSI:Client:AddVehicleFragment", -1, fragmentID, vehicleFragments[fragmentID])
    exports["soe-logging"]:ServerLog("Vehicle Fragment Dropped", "HAS DROPPED A VEHICLE FRAGMENT | DATA: " .. json.encode(vehicleFragments[fragmentID]), src)
end)

-- WHEN TRIGGERED, ADD BULLET CASING
RegisterNetEvent("CSI:Server:AddCasing", function(serialNumber, weapon, weaponType, weather, wearingGloves)
    local src = source
    if weapon and weaponType then
        local caseID = GenerateEvidenceID("Casing")
        local pos = GetEntityCoords(GetPlayerPed(src))

        casings[caseID] = { -- INSERT INTO CASINGS TABLE
            ["pos"] = pos,
            ["model"] = weapon,
            ["serial"] = serialNumber,
            ["type"] = weaponType,
            ["time"] = os.date("%x %X")
        }

        -- UPDATE ALL CLIENTS' CASINGS TABLE
        TriggerClientEvent("CSI:Client:AddCasing", -1, caseID, casings[caseID])
        exports["soe-logging"]:ServerLog("Casing Dropped", ("HAS DROPPED A CASING | WEATHER: %s | WEARING GLOVES: %s | DATA: %s"):format(weather, wearingGloves, json.encode(casings[caseID])), src)
    end
end)

-- WHEN TRIGGERED, IDENTIFY CHARACTER ASSOCIATED WITH SERVER ID
RegisterNetEvent("CSI:Server:IdentifyPlayer", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 77765-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data["status"] then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 77765-2 | Lua-Injecting Detected.", 0)
        return
    end

    -- CHECK IF PLAYER HAS MORE THAN ONE ARREST
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[data["target"]]
    local checkArrests = exports["soe-nexus"]:PerformAPIRequest("/api/records/getrecords", "charid=" .. char.CharID, true)

    if checkArrests["status"] then -- IF TARGET HAS BEEN ARRESTED BEFORE, GIVE A SUCCESSFUL READING FOR THE FINGERPRINT
        TriggerClientEvent("Chat:Client:Message", data["target"], "[Identification]", "Your fingerprints were ran through a scanner.", "id")
        if #checkArrests["data"]["arrests"] >= 1 then
            TriggerClientEvent("Chat:Client:Message", src, "[Identification]", ("You identified SSN #%s through fingerprint identification."):format(char.CharID), "id")
        else
            TriggerClientEvent("Chat:Client:Message", src, "[Identification]", "You were not able to identify this fingerprint.", "system")
        end
    end
end)

-- WHEN TRIGGERED, GIVE SOURCE CASING/BLOOD DROP CAPSULE
RegisterNetEvent("CSI:Server:GiveItem")
AddEventHandler("CSI:Server:GiveItem", function(type, metaData, inputSource)
    local src = source
    if inputSource then
        src = inputSource
    end

    local itemName = "pistol_casing"
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    if (type == "casing") then
        if casings[metaData["casingID"]] then
            casings[metaData["casingID"]] = nil
        end

        if (metaData["gunType"] == "Pistol") or (metaData["gunType"] == "SMG") then
            itemName = "pistol_casing"
        elseif (metaData["gunType"] == "Assault") or (metaData["gunType"] == "Snipers") then
            itemName = "rifle_casing"
        elseif (metaData["gunType"] == "Shotgun") then
            itemName = "shotgun_shell"
        end
    elseif (type == "blooddrop") then
        if bloodDrops[metaData["bloodID"]] then
            bloodDrops[metaData["bloodID"]] = nil
        end

        itemName = "bloodsample"
        exports["soe-inventory"]:RemoveItem(src, 1, "collectionvial")
    elseif (type == "fingerprint") then
        itemName = "liftedprint"
    elseif (type == "gsr") then
        itemName = "gsrresult"
    elseif (type == "Vehicle Fragment") then
        if vehicleFragments[metaData["fragmentID"]] then
            vehicleFragments[metaData["fragmentID"]] = nil
        end

        itemName = "vehiclefragment"
    end

    Wait(100)
    TriggerClientEvent("CSI:Client:SyncEvidence", -1, casings, bloodDrops)
    if exports["soe-inventory"]:AddItem(src, "char", char.CharID, itemName, 1, json.encode(metaData)) then
        if (type == "casing") then
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Bullet casing picked up", length = 1500})
        elseif (type == "blooddrop") then
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Blood drop collected", length = 1500})
        elseif (type == "fingerprint") then
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "A fingerprint has been lifted from the surface", length = 1500})
        elseif (type == "gsr") then
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "You label the test kit for future reference.", length = 1500})
        elseif (type == "Vehicle Fragment") then
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = "Vehicle fragment picked up", length = 1500})
        end

        local msg = ("HAS PICKED UP A EVIDENCE PIECE | NAME: %s | DATA: %s"):format(type, json.encode(metaData))
        exports["soe-logging"]:ServerLog("Evidence Piece Picked Up", msg, src)
    end
end)

-- CALLED FROM CLIENT TO ANALYZE CASINGS
RegisterNetEvent("CSI:Server:AnalyzeCasings")
AddEventHandler("CSI:Server:AnalyzeCasings", function(src)
    if #forensicsQueue[src]["casings"] <= 0 then -- RETURN IF THERE'S NO CASINGS TO ANALYZE
        return
    end

    -- SOURCE
    local src = src
    if src == nil then
        src = source
    end

    -- GET INVENTORY AND ITEM DATA
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    local myInventory = exports["soe-inventory"]:RequestInventory(src, "left", true)

    for _, casingID in pairs(forensicsQueue[src]["casings"]) do -- FIND THE ITEM
        local foundItem
        for _, item in pairs(myInventory["leftInventory"]) do
            if (json.decode(item["ItemMeta"])["casingID"] == tonumber(casingID)) then
                foundItem = item
                break
            end
        end
        
        -- ADD TO CASINGS TABLE
        if (scannedCasings[char.CharID] == nil) then
            scannedCasings[char.CharID] = {}
        end

        scannedCasings[char.CharID][#scannedCasings[char.CharID] + 1] = {
            id = json.decode(foundItem["ItemMeta"])["casingID"],
            type = json.decode(foundItem["ItemMeta"])["gunType"],
            model = json.decode(foundItem["ItemMeta"])["gunModel"],
            location = json.decode(foundItem["ItemMeta"])["location"],
            serialNum = json.decode(foundItem["ItemMeta"])["serialNum"]
        }

        -- GET CASING ID AND SET PROCESSING TIME
        local casingID = json.decode(foundItem["ItemMeta"])["casingID"]
        local time = 1000

        if char.CivType ~= "CRIMELAB" then
            -- RANDOMIZE 5-10 MINUTES
            math.randomseed(casingID)
            time = math.random(300000, 600000)
        end

        -- SET TIMEOUT AND PRINT RESULTS
        SetTimeout(time, function()
            local type = json.decode(foundItem["ItemMeta"])["gunType"]
            local model = json.decode(foundItem["ItemMeta"])["gunModel"]
            local location = json.decode(foundItem["ItemMeta"])["location"]
            local serialNum = json.decode(foundItem["ItemMeta"])["serialNum"]

            -- EMAIL RESULTS
            local username = string.lower(string.sub(char.FirstGiven, 0, 1) .. string.gsub(char.LastGiven, " ", "") .. "@" .. char.Employer .. ".gov")
            username = string.gsub(username, "'", "")

            TriggerEvent("Phones:LogEmail", 0, "labtech@sacl.gov", username, char.CharID, 
            (
                "<b>Lab results - Casing #%s</b>\nHello %s %s. We've finished analyzing the casing you submitted (#%s). Please find the results of our analysis below."
                .. "\n\n<b>Casing Type:</b> %s\n<b>Gun Model:</b> %s\n<b>Gun Serial Number:</b> %s\n<b>Collected At:</b> %s"
            ):format(casingID, char.JobTitle, char.LastGiven, casingID, type, model, serialNum, location))
        end)
    end

    -- CREATE LIST OF IDS
    local casingIDs = ""
    for _, casingID in pairs(forensicsQueue[src]["casings"]) do
        casingIDs = casingIDs .. ", " .. casingID
    end
    casingIDs = string.sub(casingIDs, 3) -- CUT OFF INITIAL COMMA
    forensicsQueue[src]["casings"] = {}

    -- PRINT LAB NOTIFICATION
    if char.CivType == "CRIMELAB" then
        TriggerClientEvent("Chat:Client:Message", src, "[Laboratory]", ("You begin analysis on the following casings (IDs): %s"):format(casingIDs), "mdt")
    else
        TriggerClientEvent("Chat:Client:Message", src, "[Laboratory]", ("You place the following casings (IDs) next to the lab equipment for the scientists to begin analyzing: %s"):format(casingIDs), "mdt")
        TriggerClientEvent("Chat:Client:Message", src, "[Laboratory]", "You will receive your casing results shortly!", "mdt")
    end
end)

-- CALLED FROM CLIENT TO ANALYZE BLOOD DROPS
RegisterNetEvent("CSI:Server:AnalyzeBloodDrops")
AddEventHandler("CSI:Server:AnalyzeBloodDrops", function(src)
    if #forensicsQueue[src]["blood"] <= 0 then -- RETURN IF THERE'S NO CASINGS TO ANALYZE
        return
    end

    -- SOURCE
    local src = src
    if src == nil then
        src = source
    end

    -- GET INVENTORY AND ITEM DATA
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    local myInventory = exports["soe-inventory"]:RequestInventory(src, "left", true)

    for _, bloodID in pairs(forensicsQueue[src]["blood"]) do -- FIND THE ITEM
        local foundItem
        for _, item in pairs(myInventory["leftInventory"]) do
            if (json.decode(item["ItemMeta"]).bloodID == tonumber(bloodID)) then
                foundItem = item
                break
            end
        end
        
        -- ADD TO CASINGS TABLE
        if (analyzedBlood[char.CharID] == nil) then
            analyzedBlood[char.CharID] = {}
        end

        analyzedBlood[char.CharID][#analyzedBlood[char.CharID] + 1] = {
            dna = json.decode(foundItem["ItemMeta"])["dna"],
            id = json.decode(foundItem["ItemMeta"])["bloodID"],
            location = json.decode(foundItem["ItemMeta"])["location"]
        }

        -- GET BLOOD ID AND SET PROCESSING TIME
        local bloodID = json.decode(foundItem["ItemMeta"])["bloodID"]
        local time = 1000

        if char.CivType ~= "CRIMELAB" then -- RANDOMIZE 10-15 MINUTES
            math.randomseed(bloodID)
            time = math.random(600000, 900000)
        end

        -- SET TIMEOUT AND PRINT RESULTS
        SetTimeout(time, function()
            local dna = json.decode(foundItem["ItemMeta"])["dna"]
            local location = json.decode(foundItem["ItemMeta"])["location"]

            -- CHECK IF PLAYER HAS MORE THAN ONE ARREST
            local checkArrests = exports["soe-nexus"]:PerformAPIRequest("/api/records/getrecords", "charid=" .. dna, true)
            if checkArrests["status"] then -- IF TARGET HAS BEEN ARRESTED BEFORE, GIVE A SUCCESSFUL READING FOR THE DNA
                if (#checkArrests["data"]["arrests"] <= 0) then
                    dna = "UNKNOWN (Not on File)"
                end
            end

            -- EMAIL RESULTS
            local username = string.lower(string.sub(char.FirstGiven, 0, 1) .. string.gsub(char.LastGiven, " ", "") .. "@" .. char.Employer .. ".gov")
            username = string.gsub(username, "'", "")

            TriggerEvent("Phones:LogEmail", 0, "labtech@sacl.gov", username, char.CharID, 
            (
                "<b>Lab Results - Blood Sample #%s</b>\nHello %s %s. We've finished analyzing the blood sample you submitted (#%s). Please find the results of our analysis below."
                .. "\n\n<b>Returns To (SSN):</b> %s\n<b>Collected At:</b> %s"
            ):format(bloodID, char.JobTitle, char.LastGiven, bloodID, dna, location))
        end)
    end

    -- CREATE LIST OF IDS
    local bloodIDs = ""
    for _, bloodID in pairs(forensicsQueue[src]["blood"]) do
        bloodIDs = bloodIDs .. ", " .. bloodID
    end
    bloodIDs = string.sub(bloodIDs, 3) -- CUT OFF INITIAL COMMA
    forensicsQueue[src]["blood"] = {}

    -- PRINT LAB NOTIFICATION
    if char.CivType == "CRIMELAB" then
        TriggerClientEvent("Chat:Client:Message", src, "[Laboratory]", ("You begin analysis on the following blood samples (IDs): %s"):format(bloodIDs), "mdt")
    else
        TriggerClientEvent("Chat:Client:Message", src, "[Laboratory]", ("You place the following blood samples (IDs) next to the lab equipment for the scientists to begin analyzing: %s"):format(bloodIDs), "mdt")
        TriggerClientEvent("Chat:Client:Message", src, "[Laboratory]", "You will receive your blood sample results shortly!", "mdt")
    end
end)

-- CALLED FROM CLIENT TO ANALYZE FINGERPRINTS
RegisterNetEvent("CSI:Server:AnalyzePrints")
AddEventHandler("CSI:Server:AnalyzePrints", function(src)
    if #forensicsQueue[src]["prints"] <= 0 then -- RETURN IF THERE'S NO CASINGS TO ANALYZE
        return
    end

    -- SOURCE
    local src = src
    if src == nil then
        src = source
    end

    -- GET INVENTORY AND ITEM DATA
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    local myInventory = exports["soe-inventory"]:RequestInventory(src, "left", true)

    for _, printID in pairs(forensicsQueue[src]["prints"]) do -- FIND THE ITEM
        local foundItem
        for _, item in pairs(myInventory["leftInventory"]) do
            if (json.decode(item["ItemMeta"]).printID == tonumber(printID)) then
                foundItem = item
                break
            end
        end
        
        -- ADD TO PRINTS TABLE
        if (analyzedPrints[char.CharID] == nil) then
            analyzedPrints[char.CharID] = {}
        end

        analyzedPrints[char.CharID][#analyzedPrints[char.CharID] + 1] = {
            id = json.decode(foundItem["ItemMeta"])["printID"],
            type = json.decode(foundItem["ItemMeta"])["printType"],
            data = json.decode(foundItem["ItemMeta"])["data"],
            location = json.decode(foundItem["ItemMeta"])["location"],
            dna = json.decode(foundItem["ItemMeta"])["dna"]
        }

        -- GET CASING ID AND SET PROCESSING TIME
        local printID = json.decode(foundItem["ItemMeta"])["printID"]
        local time = 1000

        if char.CivType ~= "CRIMELAB" then
            -- RANDOMIZE 8-12 MINUTES
            math.randomseed(printID)
            time = math.random(480000, 720000)
        end

        -- SET TIMEOUT AND PRINT RESULTS
        SetTimeout(time, function()
            local type = json.decode(foundItem["ItemMeta"])["printType"]
            local data = json.decode(foundItem["ItemMeta"])["data"]
            local data2 = json.decode(foundItem["ItemMeta"])["data2"]
            local location = json.decode(foundItem["ItemMeta"])["location"]
            local dna = json.decode(foundItem["ItemMeta"])["dna"]

            -- FIND OUT IF THE FINGERPRINT IS ON FILE AND PRINT RETURN
            local checkArrests = exports["soe-nexus"]:PerformAPIRequest("/api/records/getrecords", "charid=" .. dna, true)
            if checkArrests["status"] then -- IF TARGET HAS BEEN ARRESTED BEFORE, GIVE A SUCCESSFUL READING FOR THE FINGERPRINT
                if #checkArrests["data"]["arrests"] == 0 then
                    dna = "UNKNOWN (Not on File)"
                end
            end

            -- EMAIL RESULTS
            local username = string.lower(string.sub(char.FirstGiven, 0, 1) .. string.gsub(char.LastGiven, " ", "") .. "@" .. char.Employer .. ".gov")
            username = string.gsub(username, "'", "")

            TriggerEvent("Phones:LogEmail", 0, "labtech@sacl.gov", username, char.CharID, 
            (
                "<b>Lab results - Fingerprint #%s</b>\nHello %s %s. We've finished analyzing the lifted fingerprint you submitted (#%s). Please find the results of our analysis below."
                .. "\n\n<b>Lifted From:</b> %s (%s - %s)\n<b>Returns To (SSN):</b> %s\n<b>Lifted At:</b> %s"
            ):format(printID, char.JobTitle, char.LastGiven, printID, type, data, data2, dna, location))
        end)
    end

    -- CREATE LIST OF IDS
    local printIDs = ""
    for _, printID in pairs(forensicsQueue[src]["prints"]) do
        printIDs = printIDs .. ", " .. printID
    end
    printIDs = string.sub(printIDs, 3) -- CUT OFF INITIAL COMMA
    forensicsQueue[src]["prints"] = {}

    -- PRINT LAB NOTIFICATION
    if char.CivType == "CRIMELAB" then
        TriggerClientEvent("Chat:Client:Message", src, "[Laboratory]", ("You begin analysis on the following lifted fingerprints (IDs): %s"):format(printIDs), "mdt")
    else
        TriggerClientEvent("Chat:Client:Message", src, "[Laboratory]", ("You place the following lifted fingerprints (IDs) next to the lab equipment for the scientists to begin analyzing: %s"):format(printIDs), "mdt")
        TriggerClientEvent("Chat:Client:Message", src, "[Laboratory]", "You will receive your fingerprint analysis results shortly!", "mdt")
    end
end)

-- WHEN TRIGGERED, ANALYZE VEHICLE FRAGMENTS
RegisterNetEvent("CSI:Server:AnalyzeVehFragments")
AddEventHandler("CSI:Server:AnalyzeVehFragments", function(src)
    if #forensicsQueue[src]["vehfragments"] <= 0 then -- RETURN IF THERE'S NO FRAGMENTS TO ANALYZE
        return
    end

    -- SOURCE
    local src = src
    if src == nil then
        src = source
    end

    -- GET INVENTORY AND ITEM DATA
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]
    local myInventory = exports["soe-inventory"]:RequestInventory(src, "left", true)

    for _, fragmentID in pairs(forensicsQueue[src]["vehfragments"]) do -- FIND THE ITEM
        local foundItem
        for _, item in pairs(myInventory["leftInventory"]) do
            if (json.decode(item["ItemMeta"])["fragmentID"] == tonumber(fragmentID)) then
                foundItem = item
                break
            end
        end
        
        -- ADD TO PRINTS TABLE
        if (analyzedFragments[char.CharID] == nil) then
            analyzedFragments[char.CharID] = {}
        end

        analyzedFragments[char.CharID][#analyzedFragments[char.CharID] + 1] = {
            ["id"] = json.decode(foundItem["ItemMeta"])["fragmentID"],
            ["location"] = json.decode(foundItem["ItemMeta"])["location"],
            ["genericColor"] = json.decode(foundItem["ItemMeta"])["genericColor"],
            ["detailedColor"] = json.decode(foundItem["ItemMeta"])["detailedColor"]
        }

        -- GET CASING ID AND SET PROCESSING TIME
        local fragmentID = json.decode(foundItem["ItemMeta"])["fragmentID"]
        local time = 1000

        if char.CivType ~= "CRIMELAB" then
            -- RANDOMIZE 8-12 MINUTES
            math.randomseed(fragmentID)
            time = math.random(480000, 720000)
        end

        -- SET TIMEOUT AND PRINT RESULTS
        SetTimeout(time, function()
            local detailedColor = json.decode(foundItem["ItemMeta"])["detailedColor"]
            local genericColor = json.decode(foundItem["ItemMeta"])["genericColor"]
            local location = json.decode(foundItem["ItemMeta"])["location"]

            -- EMAIL RESULTS
            local username = string.lower(string.sub(char.FirstGiven, 0, 1) .. string.gsub(char.LastGiven, " ", "") .. "@" .. char.Employer .. ".gov")
            username = string.gsub(username, "'", "")

            TriggerEvent("Phones:LogEmail", 0, "labtech@sacl.gov", username, char.CharID, 
            (
                "<b>Lab results - Vehicle Fragment #%s</b>\nHello %s %s. We've finished analyzing the vehicle fragment you submitted (#%s). Please find the results of our analysis below."
                .. "\n\n<b>Generic Color:</b> %s\n<b>Detailed Color:</b> %s\n<b>Recovered At:</b> %s"
            ):format(fragmentID, char.JobTitle, char.LastGiven, fragmentID, genericColor, detailedColor, location))
        end)
    end

    -- CREATE LIST OF IDS
    local fragmentIDs = ""
    for _, fragmentID in pairs(forensicsQueue[src]["vehfragments"]) do
        fragmentIDs = fragmentIDs .. ", " .. fragmentID
    end
    fragmentIDs = string.sub(fragmentIDs, 3) -- CUT OFF INITIAL COMMA
    forensicsQueue[src]["vehfragments"] = {}

    -- PRINT LAB NOTIFICATION
    if char.CivType == "CRIMELAB" then
        TriggerClientEvent("Chat:Client:Message", src, "[Laboratory]", "You begin analysis on the following vehicle fragments (IDs): " .. fragmentIDs, "mdt")
    else
        TriggerClientEvent("Chat:Client:Message", src, "[Laboratory]", "You place the following vehicle fragments (IDs) next to the lab equipment for the scientists to begin analyzing: " .. fragmentIDs, "mdt")
        TriggerClientEvent("Chat:Client:Message", src, "[Laboratory]", "You will receive your vehicle fragment analysis results shortly!", "mdt")
    end
end)
