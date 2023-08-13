fx_version "cerulean"
game "gta5"

name "soe-challenge"
author "GhostDaGhost"
description "Core resource for minigames involving skill. (Lockpicking, drilling, skillbar, safecracking)"

-- LOGS CLIENT/SERVER ERRORS
client_script "@soe-logging/client/cl_errorlog.lua"
server_script "@soe-logging/server/sv_errorlog.lua"

client_scripts {
    "client/*.lua",
    "shared/*.lua"
}

server_scripts {
    "server/*.lua"
}

ui_page "html/index.html"

files {
    "html/index.html",
    "html/img/*.png",
    "html/css/*.css",
    "html/js/*.js"
}

exports {
    "Skillbar",
    "UseSlimjim",
    "UseRepairKit",
    "UseScratchOff",
    "StartDrilling",
    "UsePlasmaCutter",
    "StartLockpicking",
    "StartSafeCracking"
}
