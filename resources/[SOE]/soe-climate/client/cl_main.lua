overrideTimeWeather = false

-- HOLDS ALL DATA ABOUT CURRENT TIME/WEATHER
twState = {
    ["time"] = {
        ["hour"] = 7,
        ["minute"] = 0
    },
    ["currentWeather"] = {
        ["weatherType"] = "NONE",
        ["canFollow"] = {"CLEAR", "CLEARING", "EXTRASUNNY", "SMOG", "FOGGY", "OVERCAST"},
        ["forecastText"] = {
            "Skies are clear.",
            "Expect clear skies."
        },
        ["temp"] = {
            ["min"] = 60,
            ["max"] = 80
        }
    }
}

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

-- GET THE TW STATE FROM THE SERVER (EVERY 7.5 SECONDS)
RegisterNetEvent("Climate:Client:SendTWState")
AddEventHandler(
    "Climate:Client:SendTWState",
    function(incomingState)
        local currentWeather = twState.currentWeather.weatherType

        -- CHANGE THE PHYSICAL WEATHER
        if overrideTimeWeather then
            return
        end

        if currentWeather ~= incomingState.currentWeather.weatherType then
            TriggerEvent("Climate:Client:SendWeatherChange", incomingState.currentWeather.weatherType, 60.0, false)
            Wait(500)
        end

        twState = incomingState
    end
)

-- CHANGE WEATHER IF A NEW PATTERN IS SELECTED
RegisterNetEvent("Climate:Client:SendWeatherChange")
AddEventHandler(
    "Climate:Client:SendWeatherChange",
    function(newWeather, transitionTime, notification)
        if overrideTimeWeather then
            return
        end

        SetWeatherTypeOvertimePersist(newWeather, transitionTime)
    end
)

-- For housing to prevent flooding interiors
function SetTimeWeatherOverride(toggle)
    overrideTimeWeather = toggle

    if not toggle then
        TriggerEvent("Climate:Client:SendWeatherChange", twState.currentWeather.weatherType, 5.0, false)
    end
end