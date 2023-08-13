fx_version "cerulean"
game "gta5"

name "soe-csi"
description "Forensics/Investigations Resource"
author "GhostDaGhost / Major"

-- LOGS CLIENT/SERVER ERRORS
client_script "@soe-logging/client/cl_errorlog.lua"
server_script "@soe-logging/server/sv_errorlog.lua"

shared_scripts {
    "shared/*.lua"
}

client_scripts {
    "client/*.lua"
}

server_scripts {
    "server/*.lua"
}

exports {
    "UseGSRKit",
    "AddBloodDrop",
    "AddBulletCasing",
    "SetGSRInfliction"
}

server_exports {
    "AddToForensicsQueue"
}
