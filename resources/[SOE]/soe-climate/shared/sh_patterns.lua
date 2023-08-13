-- ALL WEATHER TYPES AVAILABLE AND WHAT THEY CAN FOLLOW
local weatherPatterns = {}

weatherPatterns[#weatherPatterns + 1] = {
    ["weatherType"] = "RAIN",
    ["canFollow"] = {"RAIN", "SNOWLIGHT", "OVERCAST", "FOGGY", "CLOUDS", "THUNDER", "SNOWLIGHT"},
    ["chance"] = 20,
    ["forecastText"] = {
        "Rainfall across the state.",
        "Expect rain."
    },
    ["temp"] = {
        ["min"] = 40,
        ["max"] = 55
    }
}

weatherPatterns[#weatherPatterns + 1] = {
    ["weatherType"] = "CLEAR",
    ["canFollow"] = {"CLEAR", "CLEARING", "EXTRASUNNY", "SMOG", "FOGGY", "OVERCAST"},
    ["chance"] = 75,
    ["forecastText"] = {
        "Skies are clear.",
        "Expect clear skies."
    },
    ["temp"] = {
        ["min"] = 60,
        ["max"] = 80
    }
}

weatherPatterns[#weatherPatterns + 1] = {
    ["weatherType"] = "CLEARING",
    ["canFollow"] = {"CLEARING", "RAIN", "SNOWLIGHT"},
    ["chance"] = 75,
    ["forecastText"] = {
        "Skies are clearing."
    },
    ["temp"] = {
        ["min"] = 45,
        ["max"] = 60
    }
}

weatherPatterns[#weatherPatterns + 1] = {
    ["weatherType"] = "EXTRASUNNY",
    ["canFollow"] = {"EXTRASUNNY", "CLEAR", "CLEARING", "FOGGY", "SMOG"},
    ["chance"] = 75,
    ["forecastText"] = {
        "Very hot with very little to no wind."
    },
    ["temp"] = {
        ["min"] = 80,
        ["max"] = 105
    }
}

weatherPatterns[#weatherPatterns + 1] = {
    ["weatherType"] = "OVERCAST",
    ["canFollow"] = {"OVERCAST", "CLEAR", "CLEARING", "FOGGY", "SMOG", "CLOUDS"},
    ["chance"] = 55,
    ["forecastText"] = {
        "Expect overcast skies across the state."
    },
    ["temp"] = {
        ["min"] = 50,
        ["max"] = 60
    }
}

weatherPatterns[#weatherPatterns + 1] = {
    ["weatherType"] = "CLOUDS",
    ["canFollow"] = {"OVERCAST", "EXTRASUNNY", "CLEAR", "CLEARING", "FOGGY", "SMOG", "CLOUDS"},
    ["chance"] = 55,
    ["forecastText"] = {
        "Clouds are starting to move in."
    },
    ["temp"] = {
        ["min"] = 55,
        ["max"] = 65
    }
}

weatherPatterns[#weatherPatterns + 1] = {
    ["weatherType"] = "THUNDER",
    ["canFollow"] = {"RAIN", "THUNDER"},
    ["chance"] = 20,
    ["forecastText"] = {
        "Thunderstorms expected across the state. Stay indoors if possible."
    },
    ["temp"] = {
        ["min"] = 40,
        ["max"] = 55
    }
}

weatherPatterns[#weatherPatterns + 1] = {
    ["weatherType"] = "SMOG",
    ["canFollow"] = {"EXTRASUNNY", "CLEAR", "CLEARING", "SMOG"},
    ["chance"] = 50,
    ["forecastText"] = {
        "Expect heavy smog due to the warm air."
    },
    ["temp"] = {
        ["min"] = 60,
        ["max"] = 75
    }
}

weatherPatterns[#weatherPatterns + 1] = {
    ["weatherType"] = "FOGGY",
    ["canFollow"] = {"OVERCAST", "CLEAR", "CLEARING", "FOGGY", "SMOG", "RAIN", "CLOUDS"},
    ["chance"] = 50,
    ["forecastText"] = {
        "A dense fog layer is beginning to form over the state."
    },
    ["temp"] = {
        ["min"] = 45,
        ["max"] = 60
    }
}

weatherPatterns[#weatherPatterns + 1] = {
    ["weatherType"] = "SNOWLIGHT",
    ["canFollow"] = {"SNOWLIGHT", "RAIN", "BLIZZARD"},
    ["chance"] = 10,
    ["forecastText"] = {
        "Light snow expected as temperatures begin to drop."
    },
    ["temp"] = {
        ["min"] = 20,
        ["max"] = 32
    }
}

weatherPatterns[#weatherPatterns + 1] = {
    ["weatherType"] = "BLIZZARD",
    ["canFollow"] = {"SNOWLIGHT", "BLIZZARD"},
    ["chance"] = 10,
    ["forecastText"] = {
        "As winds pick up, heavy snow will begin to fall across the state."
    },
    ["temp"] = {
        ["min"] = 10,
        ["max"] = 25
    }
}

-- CHECK IF WEATHER CHOSEN CAN FOLLOW THE CURRENT WEATHER
local function CanWeatherFollow(currentWeather, prospectWeather)
    local isAllowed = false
    for _, canFollow in pairs(prospectWeather.canFollow) do
        if currentWeather.weatherType == canFollow then
            isAllowed = true
        end
    end
    return isAllowed
end

-- GET A RANDOM NEXT WEATHER
function GetRandomWeather(currentWeather)
    if not currentWeather then
        currentWeather = weatherPatterns[2]
    end

    while true do
        local selectedWeather = weatherPatterns[math.random(1, #weatherPatterns)]
        math.randomseed(GetGameTimer())

        if CanWeatherFollow(currentWeather, selectedWeather) and math.random(1, 100) <= selectedWeather.chance then
            return selectedWeather
        end

        Wait(10)
    end
end
