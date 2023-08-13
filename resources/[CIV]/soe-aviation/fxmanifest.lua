fx_version "bodacious"
game "gta5"

author "SoE Dev Team"
description "Aviation"

-- LOGS CLIENT/SERVER ERRORS
client_script "@soe-logging/client/cl_errorlog.lua"
server_script "@soe-logging/server/sv_errorlog.lua"

client_scripts {
    "**/cl_*.lua"
}

server_scripts {
    "**/sv_*.lua"
}

ui_page "client/html/index.html"

files {
    "client/html/index.html",
    "client/html/css/*.css",
    "client/html/js/*.js"
}

exports {
    "IsUsingHelicam"
}
