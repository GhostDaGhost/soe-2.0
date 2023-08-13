fx_version "cerulean"
game "gta5"

name "soe-voice"
description "VOIP system based off Mumble for FiveM."
author "SoE Dev Team"

-- LOGS CLIENT/SERVER ERRORS
client_script "@soe-logging/client/cl_errorlog.lua"
server_script "@soe-logging/server/sv_errorlog.lua"

lua54 "yes"

shared_scripts {
    "shared/sh_*.lua"
}

client_scripts {
    "client/**/cl_*.lua"
}

server_scripts {
    "server/**/sv_*.lua"
}

ui_page "html/index.html"

files {
	"html/js/*.js",
	"html/css/*.css",
	"html/img/*.png",
	"html/ogg/*.ogg",
	"html/index.html",
	"html/fonts/*.ttf"
}

exports {
    "SetCallVolume",
    "GetCallVolume",
    "SetRadioVolume",
    "GetRadioVolume",
    "AddPlayerToCall",
    "SetPlayerVolume",
    "ToggleMutePlayer",
    "SetRadioChannel",
    "SetCallChannel",
    "SubscribeToRadioChannel",
    "UnsubscribeFromRadioChannel",
    "RemovePlayerFromCall"
}

server_exports {
    "UpdateRoutingBucket",
    "SetPlayerCallChannel",
    "GetPlayersInRadioChannel",
}
