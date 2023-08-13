fx_version "cerulean"
game "gta5"

name "soe-crime"
description "Core resource for crime events"
author "GhostDaGhost"

-- LOGS CLIENT/SERVER ERRORS
client_script "@soe-logging/client/cl_errorlog.lua"
server_script "@soe-logging/server/sv_errorlog.lua"

-- APPLIES MENUV CODE TO THIS RESOURCE
client_script "@soe-menuv/menuv.lua"

shared_scripts {
    "shared/sh_*.lua",
    "shared/misc/sh_*.lua",
    "shared/drugs/sh_*.lua"
}

client_scripts {
    "client/cl_*.lua",
    "client/misc/cl_*.lua",
    "client/drugs/cl_*.lua",
    "client/chopshop/cl_*.lua",
    "client/robberies/cl_*.lua",
    "client/moneyLaunderer/cl_*.lua"
}

server_scripts {
    "server/sv_*.lua",
    "server/misc/sv_*.lua",
    "server/drugs/sv_*.lua",
    "server/chopshop/sv_*.lua",
    "server/robberies/sv_*.lua",
    "server/moneyLaunderer/sv_*.lua"
}

ui_page "html/index.html"

files {
    "html/js/*.js",
    "html/css/*css",
    "html/img/*.png",
    "html/index.html"
}

exports {
    "UseThermite",
    "StartWeedRun",
    "SmokeCocaine",
    "GetStoreSafes",
    "LockpickVehicle",
    "IsNearChopShop",
    "IsNearChopShopDropOff",
    "IsRobbingAHouse",
    "GetCashRegisters",
    "IsNearJewelryShowcase",
    "GetTruckRobberyStartSpots",
    "IsNearWarehouse",
    "IsNearWarehouseCrate",
    "IsNearRobbableHouse",
    "IsNearHouseItem"
}

server_exports {
    "RestoreDrugRunReputation",
    "ModifyDrugRunReputation"
}
