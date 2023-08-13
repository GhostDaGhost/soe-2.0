-- HOLDS ALL DATA ABOUT CURRENT TIME/WEATHER
twState = {
    ["time"] = {
        ["hour"] = 7,
        ["minute"] = 0
    },
    ["currentWeather"] = {
        ["weatherType"] = "CLEAR",
        ["canFollow"] = {"CLEAR", "CLEARING", "EXTRASUNNY", "SMOG", "FOGGY", "OVERCAST"},
        ["forecastText"] = {
            "Skies are clear.",
            "Expect clear skies."
        },
        ["temp"] = {
            ["min"] = 60,
            ["max"] = 80
        },
        ["endsAt"] = 7
    },
    ["overrideWeather"] = false
}

-- ***********************
--      HTTP Handler
-- ***********************
-- SERVER JSON FILE WITH CLIMATE DATA WHEN REQUESTED
SetHttpHandler(function(req, res)
    if (req.path == "/climate.json") then
        res.send(json.encode(twState))
    end
end)

-- **********************
--    Local Functions
-- **********************
-- FORMAT TIME NICELY
local function FormatTime(hour, minute)
    if #tostring(hour) < 2 then
        hour = "0" .. tostring(hour)
    end

    if #tostring(minute) < 2 then
        minute = "0" .. tostring(minute)
    end

    return hour .. ":" .. minute
end

-- **********************
--    Global Functions
-- **********************
-- GET TIME EXPORT
function GetTime(type)
    if type == "table" then
        return twState.time
    else
       return FormatTime(twState.time.hour, twState.time.minute) 
    end
end

-- GET WEATHER EXPORT
function GetWeather()
    return twState.currentWeather
end

-- TICK TIME FORWARD ONE MINUTE
function TickTime()
    if twState.time.minute == 59 then
        if twState.time.hour == 23 then
            -- NEXT DAY
            twState.time.hour = 0
            twState.time.minute = 0
            return
        end
        twState.time.minute = 0
        twState.time.hour = twState.time.hour + 1
        return
    end
    twState.time.minute = twState.time.minute + 1
    return
end

-- CHECK TO SEE IF WEATHER NEEDS TO BE CHANGED
function CheckWeather()
    if (twState.time.hour == twState.currentWeather.endsAt or twState.currentWeather.endsAt == nil) and not twState.overrideWeather then
        local nextWeather = GetRandomWeather(twState.currentWeather)
        local endsAt = twState.time.hour + math.random(2, 8)
        if endsAt > 23 then
            endsAt = 0 + (endsAt - 24)
        end
        nextWeather.endsAt = endsAt
        twState.currentWeather = nextWeather
        return
    end
end

-- **********************
--       Commands
-- **********************
-- WHEN TRIGGERED, GENERATE RANDOM WEATHER PATTERN
RegisterCommand("genweather", function()
    local src = source
    if not exports["soe-uchuu"]:IsStaff(src) then
        return
    end

    twState.currentWeather = GetRandomWeather(twState.currentWeather)
end)

-- WHEN TRIGGERED, SET CURRENT GAME WEATHER
RegisterCommand("setweather", function(source, args)
    local src = source
    if not exports["soe-uchuu"]:IsStaff(src) then
        return
    end

    if args[1] then
        twState.overrideWeather = true
		twState.currentWeather.weatherType = args[1]:upper()
		twState.currentWeather.endsAt = nil
    else
        twState.overrideWeather = false
    end

    -- UPDATE WEATHER
    TickTime()
    CheckWeather()
    TriggerClientEvent("Climate:Client:SendTWState", -1, twState)        
end)

-- WHEN TRIGGERED, SET CURRENT GAME TIME
RegisterCommand("settime", function(source, args)
    local src = source
    if not exports["soe-uchuu"]:IsStaff(src) then
        return
    end

    local hour, minute = tonumber(args[1]), tonumber(args[2])
    if not hour or not minute then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You must include hour and minute!", length = 5000})
        return
    end

    if (hour > 23 or minute > 59) then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Max Time: 23:59", length = 5000})
        return
    end

    twState.time = {["hour"] = hour, ["minute"] = minute}
    TriggerClientEvent("Climate:Client:SendTWState", -1, twState)
end)
