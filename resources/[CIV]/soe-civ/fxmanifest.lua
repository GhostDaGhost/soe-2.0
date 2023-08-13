fx_version "cerulean"
game "gta5"

name "soe-civ"
description "Core resource for general civilian interaction"
author "GhostDaGhost"

-- LOGS CLIENT/SERVER ERRORS
client_script "@soe-logging/client/cl_errorlog.lua"
server_script "@soe-logging/server/sv_errorlog.lua"

-- APPLIES MENUV CODE TO THIS RESOURCE
client_script "@soe-menuv/menuv.lua"

client_scripts {
    "client/*.lua"
}

server_scripts {
    "server/*.lua"
}

shared_scripts {
    "shared/*.lua"
}

ui_page "html/index.html"

files {
    "html/js/*.js",
    "html/css/*.css",
    "html/img/*.png",
    "html/index.html"
}

exports {
    "IsHeld",
    "IsHolding",
    "IsDragging",
    "IsDragged",
    "IsEscorting",
    "IsEscorted",
    "IsCarrying",
    "IsCarried",
    "IsOpeningCrate",
    "UseScuba",
    "UseBinoculars",
    "UseKittyLitter",
    "SetAlcoholLevel",
    "UseBreathalyzer",
    "UseMeasuringTape",
    "SetDraggingState",
    "SetCarryingState",
    "SetEscortingState",
    "SetHoldingState",
    "IsRestrained"
}
