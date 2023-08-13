
fx_version 'bodacious'
game 'gta5'

name 'soe-gphone'
description 'A new, custom phone framework developed by GBJoel (UI) and Major (Client-side) - 2.0 re-write by Boba'
author 'GBJoel/Major/Boba'

-- LOGS CLIENT/SERVER ERRORS
client_script "@soe-logging/client/cl_errorlog.lua"
server_script "@soe-logging/server/sv_errorlog.lua"

client_scripts {
    "client/*.lua",
}

server_scripts {
    "server/*.lua",
}

ui_page "html/index.html"

files {
    "html/*.js",
    "html/main.css",
    "html/devices.min.css",
    "html/index.html",
    "html/zwicon.css",
    "html/fonts/zwicon.eot",
    "html/fonts/zwicon.svg",
    "html/fonts/zwicon.ttf",
    "html/fonts/zwicon.woff",
    "html/sounds/*.ogg",
    "html/images/*.png"
}

-- exports {
--     "setPrimaryPhoneData",
--     "sendFakeText",
--     "isTypingInPhone"
-- }

exports {
    "IsPhoneOpen",
    "InventoryUse"
}
