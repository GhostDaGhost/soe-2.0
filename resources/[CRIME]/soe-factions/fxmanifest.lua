fx_version "cerulean"
game "gta5"

name "soe-factions"
description "Factions management"
author "Major"

-- LOGS CLIENT/SERVER ERRORS
client_script "@soe-logging/client/cl_errorlog.lua"
server_script "@soe-logging/server/sv_errorlog.lua"

-- APPLIES MENUV CODE TO THIS RESOURCE
client_script "@soe-menuv/menuv.lua"

client_scripts {
    "client/*.lua"
}

server_scripts {
    "server/*.lua"
}

shared_scripts {
    "shared/*.lua"
}

exports {
    "CheckPermission",
    "GetGangName",
    "IsClockedIn",
    "GetClockinData",
    "GetFactionWithPerm",
}

server_exports {
    "CheckPermission",
    "GetGangName",
    "GetMaxRate",
}
