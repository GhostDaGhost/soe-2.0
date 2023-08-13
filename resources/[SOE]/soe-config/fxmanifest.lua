fx_version "cerulean"
game "gta5"

name "soe-config"
description "Static confirguration data for SoE server"
author "SoE Dev Team"

-- LOGS CLIENT/SERVER ERRORS
client_script "@soe-logging/client/cl_errorlog.lua"
server_script "@soe-logging/server/sv_errorlog.lua"

shared_scripts {
    "shared/sh_main.lua",
    "shared/sh_economy.lua",
    "shared/sh_dutyreq.lua"
}

exports {
    "GetConfigValue"
}

server_exports {
    "GetConfigValue"
}

-- PLEASE READ!!!
-- NOTHING IN THIS RESOURCE SHOULD BE DYNAMICALLY CHANGED AFTER THE RESOURCE HAS STARTED
-- EVERYTHING SHOULD BE HARDCODED AND LOADED AS SUCH WHEN THE SERVER STARTS
