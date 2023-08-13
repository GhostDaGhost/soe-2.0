fx_version "cerulean"
game "gta5"

name "soe-input"
description "An inputbox developed by GBJoel for any purpose on SoE"
author "GBJoel"

-- LOGS CLIENT ERRORS TO SERVER
client_script "@soe-logging/client/cl_errorlog.lua"

client_scripts {
    "client/cl_main.lua"
}

ui_page "html/index.html"

files {
    "html/main.js",
    "html/main.css",
    "html/index.html"
}

exports {
    "OpenInputDialogue",
    "OpenConfirmDialogue",
    "OpenSelectDialogue"
}
