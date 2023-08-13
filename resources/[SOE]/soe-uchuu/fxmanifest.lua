fx_version "cerulean"
game "gta5"
resource_type "gametype" {name = "SoE 2.0"}

name "soe-uchuu"
description "A custom server framework written for SoE - To be used in conjunction with soe-nexus for DB connections"
author "Major (Code) / GBJoel (UI)"

-- LOGS CLIENT/SERVER ERRORS
client_script "@soe-logging/client/cl_errorlog.lua"
server_script "@soe-logging/server/sv_errorlog.lua"

client_scripts {
    "client/*.lua"
}

shared_scripts {
    "shared/*.lua"
}

server_scripts {
    "server/*.lua"
}

ui_page "html/index.html"

files {
    "html/*.html",
    "html/js/*.js",
    "html/css/*.css",
    "html/img/*.png"
}

exports {
    "GetPlayer",
    "UpdateSettings",
    "UpdateGamestate"
}

server_exports {
    "IsStaff",
    "GetStaffRank",
    "UpdatePlayerData",
    "UpdateUserSettings",
    "UpdateGamestate",
    "UpdateCharacterSettings",
    "GetOnlinePlayerList",
    "GetSourceByCharacterID"
}
