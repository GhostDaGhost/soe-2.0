fx_version "bodacious"
game "gta5"

name "soe-inventory"
description "Inventory System"
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
    "html/main.js",
    "html/main.css",
    "html/index.html",
    "html/images/*.png",
    "html/zwicon.css",
    "html/fonts/zwicon.eot",
    "html/fonts/zwicon.svg",
    "html/fonts/zwicon.ttf",
    "html/fonts/zwicon.woff"
}

exports {
    "ValidateMyWeapon",
    "RequestInventory",
    "GetMyCurrentWeapon",
    "GetItemData",
    "GetItemAmt",
    "SetParachuteState"
}

server_exports {
    "RequestInventory",
    "AddItem",
    "ModifyItem",
    "UseItem",
    "ModifyItemMeta",
    "GetItemAmt",
    "GetItemData",
    "RemoveItem",
    "GetItemAmtInVehicle",
    "RemoveItemFromVehicle"
}
