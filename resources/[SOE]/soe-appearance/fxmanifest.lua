fx_version "cerulean"
game "gta5"

name "soe-appearance"
description "Resource holding clothing functions"
author "Major"

-- LOGS CLIENT/SERVER ERRORS
client_script "@soe-logging/client/cl_errorlog.lua"
server_script "@soe-logging/server/sv_errorlog.lua"

-- LOADS NATIVEUI CODE INTO THIS RESOURCE
client_script "@soe-menus/client/cl_nativeui.lua"

-- APPLIES MENUV CODE TO THIS RESOURCE
client_script "@soe-menuv/menuv.lua"

client_scripts {
    "client/HeadBlendWrapper.net.dll",
    "client/*.lua",
    "shared/*.lua"
}

server_scripts {
    "server/*.lua",
    "shared/*.lua"
}

exports {
    "IsWearingGloves",
    "GetHeadBlendData",
    "OpenAppearanceMenu",
    "LoadPlayerAppearance",
    "IsUsingAppearanceMenu",
    "ToggleParachute"
}
