fx_version "cerulean"
game "gta5"

name "soe-ux"
description "Core resource for user experience functions and events"
author "GhostDaGhost"

-- LOGS CLIENT/SERVER ERRORS
client_script "@soe-logging/client/cl_errorlog.lua"
server_script "@soe-logging/server/sv_errorlog.lua"

shared_scripts {
    "shared/sh_*.lua"
}

client_scripts {
    "**/cl_*.lua",
}

server_scripts {
    "**/sv_*.lua"
}

ui_page "html/index.html"

files {
    "html/index.html",
    "html/js/*.js",
    "html/css/*.css"
}

exports {
    "UseGSRKit",
    "ToggleEngine",
    "ToggleSeatbelt",
    "IsWearingSeatbelt",
    "ToggleVehicleDoor",
    "InstallTunerLaptop"
}
