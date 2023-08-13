fx_version "cerulean"
game {"rdr3", "gta5"}

name "soe-chat"
description "Core resource for text chat functions to improve quality of roleplay"
author "GhostDaGhost (SoE Edits) / Cfx.re (Original)"

-- LOGS CLIENT/SERVER ERRORS
client_script "@soe-logging/client/cl_errorlog.lua"
server_script "@soe-logging/server/sv_errorlog.lua"

webpack_config "webpack.config.js"

client_scripts {
    "client/*.lua"
}

server_scripts {
    "server/*.lua"
}

ui_page "dist/ui.html"

files {
    "dist/ui.html",
    "dist/index.css",
    "html/vendor/*.css",
    "html/vendor/fonts/*.woff2"
}

exports {
    "HideChat",
    "GetDisplayName"
}

server_exports {
    "GetDisplayName"
}

dependencies {
    "yarn",
    "webpack"
}
