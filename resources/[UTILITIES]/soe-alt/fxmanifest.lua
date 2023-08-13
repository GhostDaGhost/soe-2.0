fx_version "cerulean"
game "gta5"

name "soe-alt"
description "Core resource for anti-local tow control"
author "SoE Dev Team"

-- LOGS CLIENT ERRORS TO SERVER
client_script "@soe-logging/client/cl_errorlog.lua"

client_scripts {
    "client/cl_*.lua"
}
