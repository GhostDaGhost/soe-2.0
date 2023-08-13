fx_version "cerulean"
game "gta5"

name "soe-logging"
description "SoE Logging System"
author "GhostDaGhost"

client_scripts {
    "client/*.lua"
}

server_scripts {
    "server/*.lua"
}

exports {
    "ServerLog",
    "ScreenshotMyScreen"
}

server_exports {
    "ServerLog",
    "ScreenshotScreen"
}
