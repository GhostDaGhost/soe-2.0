fx_version "cerulean"
game "gta5"

author "SoE Dev Team"
description "Government Management System"

-- LOGS CLIENT/SERVER ERRORS
client_script "@soe-logging/client/cl_errorlog.lua"
server_script "@soe-logging/server/sv_errorlog.lua"

shared_scripts {
    "shared/sh_*.lua"
}

client_scripts {
    "**/cl_*.lua",
    "**/sh_*.lua"
}

server_scripts {
    "**/sv_*.lua",
    "**/sh_*.lua"
}
