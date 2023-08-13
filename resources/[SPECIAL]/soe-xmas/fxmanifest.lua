fx_version "cerulean"
game "gta5"

name "soe-xmas"
description "Resource holding Christmas props and decorations"
author "SoE Modeling Team"

this_is_a_map "yes"

-- LOGS CLIENT ERRORS TO SERVER
client_script "@soe-logging/client/cl_errorlog.lua"

client_scripts {
    "client/*.lua"
}

file "xmasprops.ytyp"

data_file "DLC_ITYP_REQUEST" "xmasprops.ytyp"
