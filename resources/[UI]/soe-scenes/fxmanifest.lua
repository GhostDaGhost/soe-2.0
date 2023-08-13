fx_version "cerulean"
game "gta5"

name "soe-scenes"
description "Core resource for scenes"
author "GhostDaGhost (New / UI) / StrykZ (Original)"

-- LOGS CLIENT/SERVER ERRORS
client_script "@soe-logging/client/cl_errorlog.lua"
server_script "@soe-logging/server/sv_errorlog.lua"

shared_scripts {
    "shared/sh_*.lua"
}
client_scripts {
    "client/cl_*.lua"
}

server_scripts {
    "server/sv_*.lua"
}

ui_page "html/index.html"

files {
    "html/js/*.js",
    "html/css/*.css",
    "html/index.html"
}
