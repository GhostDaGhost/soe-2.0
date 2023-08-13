fx_version "bodacious"
game "gta5"

name "soe-climate"
description "Primary time and weather handler for SoE servers"
author "Major"

-- LOGS CLIENT/SERVER ERRORS
client_script "@soe-logging/client/cl_errorlog.lua"
server_script "@soe-logging/server/sv_errorlog.lua"

client_scripts {
    "client/*.lua",
    "shared/*.lua"
}

server_scripts {
    "server/*.lua",
    "shared/*.lua"
}

exports {
    "GetWeather",
    "SetTimeWeatherOverride"
}

dependencies {}