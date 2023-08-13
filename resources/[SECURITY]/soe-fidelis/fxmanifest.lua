fx_version "cerulean"
game "gta5"

name "soe-fidelis"
description "Semper Fidelis - SoE anticheat system"
author "Major"

-- LOGS CLIENT/SERVER ERRORS
client_script "@soe-logging/client/cl_errorlog.lua"
server_script "@soe-logging/server/sv_errorlog.lua"

-- APPLIES MENUV CODE TO THIS RESOURCE
client_script "@soe-menuv/menuv.lua"

client_scripts {
    "client/*.lua",
    "shared/*.lua"
}

server_scripts {
    "server/*.lua",
    "shared/*.lua"
}

exports {
    "ResetIdleTimer",
    "ProcessAnticheat",
    "AuthorizeTeleport",
    "ValidateChatMessage"
}
