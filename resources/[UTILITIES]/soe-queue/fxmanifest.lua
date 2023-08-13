fx_version "bodacious"
game "gta5"

name "soe-queue"
description "Queue system resource."
author "Nick78111"

-- LOGS CLIENT/SERVER ERRORS
client_script "@soe-logging/client/cl_errorlog.lua"
server_script "@soe-logging/server/sv_errorlog.lua"

server_script "server/sv_queue_config.lua"
server_script "connectqueue.lua"

server_script "shared/sh_queue.lua"
client_script "shared/sh_queue.lua"
