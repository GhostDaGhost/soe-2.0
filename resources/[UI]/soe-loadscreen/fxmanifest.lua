fx_version "cerulean"
game "gta5"

name "soe-loadscreen"
description "SoE Loading Screen v3"
author "GhostDaGhost / Addles"

-- LOGS CLIENT ERRORS TO SERVER
client_script "@soe-logging/client/cl_errorlog.lua"

files {
    "html/index.html",
    "html/css/*.css",
    "html/js/*.js",
    "html/css/img/*.png"
}

loadscreen "html/index.html"
loadscreen_manual_shutdown "yes"
