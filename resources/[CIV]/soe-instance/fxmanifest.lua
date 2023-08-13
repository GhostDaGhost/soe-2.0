fx_version "bodacious"
game "gta5"

name "soe-instance"
description "A script responsible for managing player and entity instances"
author "blm456"

client_scripts {
    "client/*.lua",
}

server_scripts {
    "server/*.lua",
}

exports {
    "GetPlayerInstance",
    "GetEntityInstance"
}

server_exports {
    "SetPlayerInstance",
    "SetEntityInstance",
    "GetPlayerInstance",
    "GetEntityInstance"
}
