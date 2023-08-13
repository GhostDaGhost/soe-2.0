fx_version "cerulean"
game "gta5"

name "baseevents"
description "Core resource for vehicle/death event triggering"
author "Cfx.re (Original) / GhostDaGhost (Rewrite)"

-- LOGS CLIENT/SERVER ERRORS
client_script "@soe-logging/client/cl_errorlog.lua"
server_script "@soe-logging/server/sv_errorlog.lua"

client_scripts {
    "client/*.lua"
}

server_scripts {
    "server/*.lua"
}
