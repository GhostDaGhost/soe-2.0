local bedsTaken = {}
local pedDamage = {}
local bleedingBones = {}
local hospitalCheckIns = {}

-- LIST OF HOSPITAL BEDS TO USE ON CHECK-IN
local beds = {
    -- PILLBOX HOSPITAL
    {pos = vector3(309.32, -577.49, 44.2), occupied = false, hospital = "Pillbox Hospital"},
    {pos = vector3(307.81, -581.79, 44.2), occupied = false, hospital = "Pillbox Hospital"},
    {pos = vector3(311.35, -582.66, 44.2), occupied = false, hospital = "Pillbox Hospital"},
    {pos = vector3(313.84, -579.13, 44.2), occupied = false, hospital = "Pillbox Hospital"},
    {pos = vector3(314.58, -584.04, 44.2), occupied = false, hospital = "Pillbox Hospital"},
    {pos = vector3(319.37, -581.04, 44.2), occupied = false, hospital = "Pillbox Hospital"},
    {pos = vector3(317.77, -585.34, 44.2), occupied = false, hospital = "Pillbox Hospital"},
    {pos = vector3(324.16, -582.92, 44.2), occupied = false, hospital = "Pillbox Hospital"},
    {pos = vector3(322.69, -587.21, 44.2), occupied = false, hospital = "Pillbox Hospital"},

    -- SANDY MEDICAL
    {pos = vector3(1817.11, 3674.65, 35.2), occupied = false, hospital = "Sandy Shores Medical"},
    {pos = vector3(1818.19, 3672.91, 35.2), occupied = false, hospital = "Sandy Shores Medical"},
    {pos = vector3(1819.18, 3671.34, 35.2), occupied = false, hospital = "Sandy Shores Medical"},
    {pos = vector3(1818.25, 3677.71, 35.2), occupied = false, hospital = "Sandy Shores Medical"},
    {pos = vector3(1819.87, 3678.9, 35.2), occupied = false, hospital = "Sandy Shores Medical"},

    -- PALETO MEDICAL
    {pos = vector3(-256.50, 6327.87, 33.34), occupied = false, hospital = "Paleto Medical"},
    {pos = vector3(-258.76, 6329.78, 33.34), occupied = false, hospital = "Paleto Medical"},
    {pos = vector3(-262.36, 6326.45, 33.34), occupied = false, hospital = "Paleto Medical"},
    {pos = vector3(-259.95, 6324.22, 33.34), occupied = false, hospital = "Paleto Medical"},
    {pos = vector3(-257.41, 6321.91, 33.34), occupied = false, hospital = "Paleto Medical"},
}

-- LOG A RESPAWN AS A HOSPITAL CHECK-IN
function LogThisRespawn(char)
    local timestamp = os.date("%Y-%m-%d %H:%M:%S", os.time())
    local name = ("%s %s"):format(char.FirstGiven, char.LastGiven)
    hospitalCheckIns[#hospitalCheckIns + 1] = {name = name, ssn = char.CharID, dob = char.DOB, timestamp = timestamp, hospital = "Med-Evac"}
end

RegisterCommand("bed", function(source)
    local src = source
    TriggerClientEvent("Healthcare:Client:GetInBed", src, false)
end)

RegisterCommand("takefrombed", function(source)
    local src = source
    TriggerClientEvent("Healthcare:Client:TakeFromBedOptions", src)
end)

RegisterCommand("triage", function(source)
    local src = source
    TriggerClientEvent("Healthcare:Client:TriageOptions", src)
end)

RegisterCommand("putinbed", function(source)
    local src = source
    local noCharge = false
    if (exports["soe-jobs"]:GetJob(src) == "EMS") then
        noCharge = true
    end
    TriggerClientEvent("Healthcare:Client:PutInBedOptions", src, noCharge)
end)

-- DISCONNECTION FAILSAFE WHILE IN BED FROM CHECK-IN
AddEventHandler("playerDropped", function()
    local src = source
    if (bedsTaken[src] ~= nil) then
        beds[bedsTaken[src]].occupied = false
    end
end)

-- TRIGGERED FROM CLIENT TO GRAB HOSPITAL LOGS
AddEventHandler("Healthcare:Server:GetLogs", function(cb, src)
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    exports["soe-logging"]:ServerLog("Grabbed Hospital Check-In Logs", "HAS REQUESTED FOR HOSPITAL CHECK-IN LOGS", src)

    cb(hospitalCheckIns)
end)

-- TRIGGERED FROM CLIENT TO MARK A BED AS UNOCCUPIED
RegisterNetEvent("Healthcare:Server:CheckOutOfBed")
AddEventHandler("Healthcare:Server:CheckOutOfBed", function(bed)
    --beds[bed].occupied = false
    local src = source
    if (bedsTaken[src] ~= nil) then
        beds[bedsTaken[src]].occupied = false
    end
end)

-- TRIGGERED FROM CLIENT TO MAKE THE DRAGGED/ESCORTED PLAYER GET IN A BED
RegisterNetEvent("Healthcare:Server:PutInBed")
AddEventHandler("Healthcare:Server:PutInBed", function(target, noCharge)
    TriggerClientEvent("Healthcare:Client:GetInBed", target, noCharge)
end)

-- TRIGGERED FROM CLIENT TO MAKE THE CLOSEST PLAYER LEAVE A BED
RegisterNetEvent("Healthcare:Server:TakeFromBed")
AddEventHandler("Healthcare:Server:TakeFromBed", function(target)
    TriggerClientEvent("Healthcare:Client:TakeFromBed", target)
end)

-- TRIGGERED FROM CLIENT TO RESET THE SOURCE'S DAMAGE
RegisterNetEvent("Healthcare:Server:ResetPedDamage")
AddEventHandler("Healthcare:Server:ResetPedDamage", function()
    local src = source
    pedDamage[src] = {}
    bleedingBones[src] = {}
end)

-- TRIGGERED FROM CLIENT TO MARK A BONE AS "BLEEDING"
RegisterNetEvent("Healthcare:Server:MarkBoneAsBleeding")
AddEventHandler("Healthcare:Server:MarkBoneAsBleeding", function(bone)
    local src = source
    if (bleedingBones[src] == nil) then
        bleedingBones[src] = {}
    end
    bleedingBones[src] = bone
end)

-- TRIGGERED FROM CLIENT TO UPDATE THE SOURCE'S DAMAGE
RegisterNetEvent("Healthcare:Server:UpdatePedDamage")
AddEventHandler("Healthcare:Server:UpdatePedDamage", function(damage)
    local src = source
    if (pedDamage[src] == nil) then
        pedDamage[src] = {}
    end

    local time = os.time()
    for _, v in pairs(damage) do
        if (pedDamage[src][v.type] == nil) then
            pedDamage[src][v.type] = {}
        end
        pedDamage[src][v.type][#pedDamage[src][v.type] + 1] = {type = v.type, bone = v.bone, time = time}
    end
end)

-- TRIGGERED FROM CLIENT TO START A PATIENT CHECK-IN
RegisterNetEvent("Healthcare:Server:CheckIn")
AddEventHandler("Healthcare:Server:CheckIn", function(hospitalName)
    local src = source
    local timestamp = os.date("%Y-%m-%d %H:%M:%S", os.time())
    local char = exports["soe-uchuu"]:GetOnlinePlayerList()[src]

    for k, v in pairs(beds) do
        if not v.occupied then
            if (v.hospital == hospitalName) then
                v.occupied = true
                bedsTaken[src] = k
                TriggerClientEvent("Healthcare:Client:CheckIn", src, v)
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "You check yourself into the hospital and the local medical staff take you to a hospital bed.", length = 8500})

                -- LOG TO SERVER / HOSPITAL STAFF
                local charName = ("%s %s"):format(char.FirstGiven, char.LastGiven)
                hospitalCheckIns[#hospitalCheckIns + 1] = {name = charName, ssn = char.CharID, dob = char.DOB, timestamp = timestamp, hospital = v.hospital}
                exports["soe-logging"]:ServerLog("Hospital Check-In", "HAS CHECKED IN AT " .. hospitalName, src)
                return
            end
        end
    end
    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "There are no beds available!", length = 5000})
end)

-- TRIGGERED FROM BOTH CLIENT OR SERVER TO CHECK OWN OR OTHERS' INJURIES
RegisterNetEvent("Healthcare:Server:TriagePlayer")
AddEventHandler("Healthcare:Server:TriagePlayer", function(targetID)
    local src = source
    if (pedDamage[targetID] == nil) then
        pedDamage[targetID] = {}
    end

    local time = os.time()
    for k, v in pairs(pedDamage[targetID]) do
        for key, value in pairs(v) do
            if (time + 7200000 < value.time) then
                pedDamage[k][key] = nil
            end
        end
    end

    local boneDamage = {}
    for k, v in pairs(pedDamage[targetID]) do
        for key, value in pairs(v) do
            if (boneDamage[value.bone] == nil) then
                boneDamage[value.bone] = {}
            end
            if (boneDamage[value.bone][k] == nil) then
                boneDamage[value.bone][k] = {}
            end
            boneDamage[value.bone][k][#boneDamage[value.bone][k] + 1] = value
        end
    end

    --[[print(json.encode(pedDamage[targetID]))
    print(json.encode(boneDamage))]]
    for k, v in pairs(boneDamage) do
        local num = 0
        for key, value in pairs(v) do
            num = num + #value
            if (num > 1) then
                TriggerClientEvent("Chat:Client:Message", src, "[Triage]", ("^0%s %s wounds on the ^3%s^0."):format(num, key, bones[k]), "standard")
            else
                TriggerClientEvent("Chat:Client:Message", src, "[Triage]", ("^0%s %s wound on the ^3%s^0."):format(num, key, bones[k]), "standard")
            end
        end
    end
    TriggerClientEvent("Healthcare:Client:TriagePlayer", src, bleedingBones[targetID])
end)
