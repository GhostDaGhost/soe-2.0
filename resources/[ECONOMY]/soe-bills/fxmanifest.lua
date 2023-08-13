fx_version "cerulean"
game "gta5"

name "soe-bills"
description "Billing resource associated with loan system"
author "Major (Code) / GBJoel (UI)"

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
    "html/index.html",
    "html/js/*.js",
    "html/css/*.css",
    "html/fonts/zwicon.eot",
    "html/fonts/zwicon.svg",
    "html/fonts/zwicon.ttf",
    "html/fonts/zwicon.woff"
}
