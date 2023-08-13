fx_version "cerulean"
game "gta5"

name "soe-emergency"
description "Resource holding scripts related to the emergency services"
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
    "IsOnDuty",
    "IsDead",
    "GetCurrentCops",
    "GetCurrentEMS",
    "IsImprisoned",
    "IsInRehab",
    "ShouldReportInThisArea",
    "LockpickCuffs",
    "UseTintMeter",
    "IsRestrained",
    "IsHandcuffed",
    "IsZipTied"
}

server_exports {
    "IsDead",
    "GetCallsign",
    "ExtinguishFire",
    "UnmarkForImpound",
    "GetServiceVehicles",
    "IsRestrained",
    "IsHandcuffed",
    "IsZipTied"
}

ui_page "html/index.html"

files {
    "html/js/*.js",
    "html/css/*.css",
    "html/index.html",
    "html/fonts/*.woff",
	"html/fonts/*.woff2"
}
