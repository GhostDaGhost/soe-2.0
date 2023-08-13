fx_version "cerulean"
game "gta5"

name "soe-doors"
description "Core resource for doorlocks on SoE"
author "GhostDaGhost"

-- LOGS CLIENT/SERVER ERRORS
client_script "@soe-logging/client/cl_errorlog.lua"
server_script "@soe-logging/server/sv_errorlog.lua"

client_scripts {
    "client/cl_*.lua"
}

shared_scripts {
    "shared/sh_*.lua"
}

server_scripts {
    "server/sv_*.lua"
}
