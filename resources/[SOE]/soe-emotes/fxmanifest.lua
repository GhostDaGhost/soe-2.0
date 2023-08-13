fx_version "cerulean"
game "gta5"

name "soe-emotes"
description "Core resource for animations/props"
author "GhostDaGhost"

-- LOGS CLIENT/SERVER ERRORS
client_script "@soe-logging/client/cl_errorlog.lua"
server_script "@soe-logging/server/sv_errorlog.lua"

-- APPLIES MENUV CODE TO THIS RESOURCE
client_script "@soe-menuv/menuv.lua"

client_scripts {
    "client/cl_*.lua"
}

shared_scripts {
    "shared/sh_*.lua"
}

server_scripts {
    "server/sv_*.lua"
}

exports {
    "CancelEmote",
    "StartEmote",
    "SetWalkstyle",
    "EliminateAllProps",
    "IsDoingDeathAnimation",
    "RestoreSavedWalkstyle"
}

server_exports {
    "PlayEmote"
}
