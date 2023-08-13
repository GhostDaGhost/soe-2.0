fx_version "cerulean"
game "gta5"

name "soe-halloween"
description "Core resource for halloween events"
author "SoE Development Team"

-- LOGS CLIENT ERRORS TO SERVER
client_script "@soe-logging/client/cl_errorlog.lua"

client_scripts {
    "client/cl_*.lua"
}

shared_scripts {
    "shared/sh_*.lua"
}
