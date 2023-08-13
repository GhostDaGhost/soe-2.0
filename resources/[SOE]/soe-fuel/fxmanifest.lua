fx_version "cerulean"
game "gta5"

name "soe-fuel"
author "InZidiuZ (Original Author) / GhostDaGhost (Edits for SoE / UI)"
description "Core resource for the fuel system"

-- LOGS CLIENT ERRORS TO SERVER
client_script "@soe-logging/client/cl_errorlog.lua"

client_scripts {
    "shared/sh_*.lua",
    "client/cl_*.lua"
}

ui_page "html/index.html"

files {
    "html/js/*.js",
    "html/css/*.css",
    "html/index.html",
    "html/fonts/*.ttf"
}

exports {
    "GetFuel",
    "SetFuel",
    "IsFueling",
    "FindNearestFuelPump"
}
