fx_version "cerulean"
game "gta5"

name "soe-ui"
description "Core resource for any UI for SoE"
author "SoE Dev Team"

-- LOGS CLIENT/SERVER ERRORS
client_script "@soe-logging/client/cl_errorlog.lua"
server_script "@soe-logging/server/sv_errorlog.lua"

client_scripts {
    "**/cl_*.lua",
}

server_scripts {
    "**/sv_*.lua"
}

ui_page "html/index.html"

files {
    "html/js/*.js",
    "html/js/moment/*.js",

    "html/sounds/*.ogg",

    "html/fonts/*.ttf",

    "html/css/*.css",
    "html/img/*.png",
    "html/index.html"
}
