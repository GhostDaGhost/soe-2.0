fx_version "cerulean"
game "gta5"

name "soe-guide"
description "Core resource for the SoE commands guide"
author "GBJoel"

-- LOGS CLIENT/SERVER ERRORS
client_script "@soe-logging/client/cl_errorlog.lua"
server_script "@soe-logging/server/sv_errorlog.lua"

client_scripts {
    "client/*.lua"
}

server_scripts {
    "server/*.lua"
}

ui_page "html/index.html"

files {
    "html/js/*.js",
    "html/css/*.css",
    "html/index.html",
    "html/fonts/*.eot",
    "html/fonts/*.svg",
    "html/fonts/*.ttf",
    "html/fonts/*.woff"
}
