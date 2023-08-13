fx_version "cerulean"
game "gta5"

name "soe-help"
description "Core resource for a general help guide"
author "SoE Dev Team"

-- LOGS CLIENT/SERVER ERRORS
client_script "@soe-logging/client/cl_errorlog.lua"
server_script "@soe-logging/server/sv_errorlog.lua"

client_scripts {
    "client/*.lua"
}

server_scripts {
    "server/*.lua"
}

ui_page "html/start.html"

files {
    -- MAIN SOURCES
    "html/js/*.js",
    "html/css/*.css",
    "html/img/*.png",
    "html/*.html"
}
