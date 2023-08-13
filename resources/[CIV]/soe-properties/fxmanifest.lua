fx_version "bodacious"
game "gta5"

name "soe-properties"
description "A script responsible for player housing, offices and garages"
author "SoE Development Team"

-- LOGS CLIENT/SERVER ERRORS
client_script "@soe-logging/client/cl_errorlog.lua"
server_script "@soe-logging/server/sv_errorlog.lua"

-- APPLIES MENUV CODE TO THIS RESOURCE
client_script "@soe-menuv/menuv.lua"

shared_scripts {
    "shared/*.lua",
}

client_scripts {
    "client/*.lua",
}

server_scripts {
    "server/*.lua",
}

exports {
    "GetProperties",
    "GetProperty",
    "GetCurrentProperty",
    "GetFurniture",
    "IsInFurniturePlacingMode",
}

server_exports {
    "GetPlayerPropertyAccess",
    "GetProperties",
    "GetProperty",
    "GetPropertySourceIsIn"
}
