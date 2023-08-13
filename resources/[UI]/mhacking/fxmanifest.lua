fx_version "cerulean"
game "gta5"

name "mhacking"
author "GHMatti"
description "Hacking Minigame"

-- LOGS CLIENT ERRORS
client_script "@soe-logging/client/cl_errorlog.lua"

client_scripts {
    "client/*.lua"
}

ui_page "html/index.html"

files {
    "html/index.html",
    "html/js/*.js",
    "html/css/*.css",
    "html/img/*.png",
    "html/audio/*.ogg"
}
