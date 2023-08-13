fx_version "cerulean"
game "gta5"

name "soe-menus"
description "Core resource of the menu framework"
author "GhostDaGhost (SoE Edits) / iTexZoz (NativeUI)"

-- LOGS CLIENT ERRORS TO SERVER
client_script "@soe-logging/client/cl_errorlog.lua"

client_scripts {
    "client/*.lua",
    "shared/*.lua"
}

ui_page "html/index.html"

files {
    "html/index.html",
    "html/css/*.css",
    "html/js/*.js"
}
