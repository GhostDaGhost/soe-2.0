fx_version "cerulean"
game "gta5"

name "soe-nexus"
description "A custom server framework written for SoE - To be used in conjunction with soe-uchuu for non-DB code"
author "Major, Boba"

client_scripts {
    "client/cl_*.lua"
}

server_scripts {
    "server/sv_*.lua"
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/js/app.js',
    'html/css/app.css',
    'html/fonts/*.woff',
    'html/fonts/*.woff2',
    'html/fonts/*.eot',
    'html/fonts/*.ttf',
}

server_exports {
    "PerformAPIRequest"
}

exports {
    "TriggerServerCallback"
}
