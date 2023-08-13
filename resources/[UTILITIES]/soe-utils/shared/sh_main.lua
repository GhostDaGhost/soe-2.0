-- **********************
--    Global Functions
-- **********************
-- RETURNS AREA NAME FROM SELECTED INDEX
function GetAreaNames()
    return areaNames
end
exports("GetAreaNames", GetAreaNames)

-- WHEN TRIGGERED, RETURN VEHICLE COLOR NAME FROM SELECTED INDEX
function GrabVehicleColors()
    return vehColors
end
exports("GrabVehicleColors", GrabVehicleColors)

-- WHEN TRIGGERED, RETURN GENERIC VEHICLE FROM SENT INDEX
function GetGenericVehicleColor(colorIdx)
    if genericVehicleColors[colorIdx] then
        return FirstToUpper(genericVehicleColors[colorIdx])
    end
    return "Unknown Color"
end
exports("GetGenericVehicleColor", GetGenericVehicleColor)

-- WHEN TRIGGERED, CAPITALIZE THE FIRST LETTER OF A WORD
function FirstToUpper(str)
    return str:gsub("^%l", string.upper)
end
exports("FirstToUpper", FirstToUpper)

-- RETURNS TIME FROM START TIMER
function TimeSince(start)
    local time = GetGameTimer()
    return (time - start)
end
exports("TimeSince", TimeSince)

function GetRandomChance(percent)
    math.randomseed(GetGameTimer())
    math.random() math.random() math.random()
    return percent >= math.random(1, 100)
end
exports("GetRandomChance", GetRandomChance)

-- RETURNS IF PLAYER IS A DOG
function IsModelADog(ped)
    local model = GetEntityModel(ped)
    if (dogModels[model] ~= nil) then
        return true
    end
    return false
end
exports("IsModelADog", IsModelADog)

-- RETURNS WEAPON NAME FROM HASH KEY
function GetWeaponNameFromHashKey(hash)
    for _, weapon in pairs(weaponNames) do
        if (hash == GetHashKey(weapon)) then
            return weapon
        end
    end
    return nil
end
exports("GetWeaponNameFromHashKey", GetWeaponNameFromHashKey)

function DebugDumpTable(table)
    if (type(table) == "table") then
        local s = "{ "
        for k, v in pairs(table) do
            if (type(k) ~= "number") then
                k = '"'..k..'"'
            end
            s = string.format("%s[%s] = %s,", s, k, DebugDumpTable(v))
        end
        return s .. "} "
    else
        return tostring(table)
    end
end
exports("DebugDumpTable", DebugDumpTable)

-- RETURNS CARDINAL DIRECTION OF PLAYER'S HEADING
function GetDirection(heading)
    if ((heading >= 0 and heading < 45) or (heading >= 315 and heading < 360)) then
        return "North"
    elseif (heading >= 45 and heading < 135) then
        return "West"
    elseif (heading >= 135 and heading < 225) then
        return "South"
    elseif (heading >= 225 and heading < 315) then
        return "East"
    else
        return "North"
    end
end
exports("GetDirection", GetDirection)

function GetTableSize(tab)
    local size = 0
    for _, _ in pairs(tab) do
        size = size + 1
    end
    return size
end
exports("GetTableSize", GetTableSize)

-- WHEN TRIGGERED, CONVERT A STRING TO A BOOLEAN (UNTIL LUA ADDS A WAY)
function ConvertToBoolean(str)
    if (str == "true") then
        return true
    elseif (str == "false") then
        return false
    end
    return false
end
exports("ConvertToBoolean", ConvertToBoolean)
