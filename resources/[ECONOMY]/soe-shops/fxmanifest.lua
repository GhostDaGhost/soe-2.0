fx_version "cerulean"
game "gta5"

name "soe-shops"
description "Core resource for shops in SoE"
author "GhostDaGhost / Boba / Major"

-- LOGS CLIENT/SERVER ERRORS
client_script "@soe-logging/client/cl_errorlog.lua"
server_script "@soe-logging/server/sv_errorlog.lua"

-- APPLIES MENUV CODE TO THIS RESOURCE
client_script "@soe-menuv/menuv.lua"

client_scripts {
    "client/cl_*.lua",
    "client/DMV/cl_*.lua",
    "client/CarWash/cl_*.lua",
    "client/Modshops/cl_*.lua",
    "client/BikeRentals/cl_*.lua",
    "client/Dealerships/cl_*.lua",
    "client/VendingMachines/cl_*.lua",
    "client/Scrapyard/cl_*.lua"
}

shared_scripts {
    "shared/sh_*.lua"
}

server_scripts {
    "server/sv_*.lua",
    "server/DMV/sv_*.lua",
    "server/Modshops/sv_*.lua",
    "server/Dealerships/sv_*.lua",
    "server/VendingMachines/sv_*.lua",
    "server/Scrapyard/sv_*.lua"
}

ui_page "html/index.html"

files {
    "html/index.html",

    "html/css/style.css",
    "html/css/cards.css",
    "html/css/numberpad.css",
    "html/js/main.js",

    "html/img/logo-fleeca.png",
    "html/img/logo-maze.png"
}

exports {
    "NewTransaction",
    "IsNearStore",
    "IsNearCarWash",
    "IsUsingCarWash",
    "LoadVehicleMods",
    "IsNearBikeRental",
    "IsNearDealership",
    "GenerateSliderValues",
    "GetModDataFromVehicle"
}

server_exports {
    "GeneratePlate"
}
