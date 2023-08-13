fx_version "cerulean"
game "gta5"

name "soe-prison"
description "Prison resource to handle all activities for SoE's prison"
author "SoE Dev Team"

-- LOGS CLIENT ERRORS TO SERVER
client_script "@soe-logging/client/cl_errorlog.lua"

client_scripts {
    "client/cl_*.lua",
    "shared/sh_*.lua"
}

exports {
    "SendToPrison",
    "IsImprisoned",
    "IsNearElectricJob",
    "IsNearElectricalBox",
    "IsDoingElectricianJob"
}
