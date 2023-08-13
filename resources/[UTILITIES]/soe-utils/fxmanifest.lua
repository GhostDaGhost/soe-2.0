fx_version "cerulean"
game "gta5"

name "soe-utils"
description "A resource with useful common utility functions"
author "SoE Dev Team"

-- LOGS CLIENT/SERVER ERRORS
client_script "@soe-logging/client/cl_errorlog.lua"
server_script "@soe-logging/server/sv_errorlog.lua"

client_scripts {
    -- POLYZONE
    "@PolyZone/client.lua",
    "@PolyZone/BoxZone.lua",
    "@PolyZone/EntityZone.lua",
    "@PolyZone/CircleZone.lua",
    "@PolyZone/ComboZone.lua",

    -- MAIN SCRIPTS
    "client/cl_*.lua",
    "client/Utils/cl_*.lua",
    "client/Managers/cl_*.lua",
    "client/Infinity/cl_*.lua"
}

shared_scripts {
    "shared/sh_*.lua"
}

server_scripts {
    "server/sv_*.lua",
    "server/Utils/sv_*.lua",
    "server/Managers/sv_*.lua",
    "server/Infinity/sv_*.lua"
}

ui_page "html/index.html"

files {
    "html/js/*.js",
    "html/css/*.css",
    "html/index.html",
    "html/sounds/*.ogg"
}
