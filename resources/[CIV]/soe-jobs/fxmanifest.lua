fx_version "cerulean"
game "gta5"

name "soe-jobs"
description "Core resource for civilian-based legal jobs"
author "SoE Dev Team"

-- LOGS CLIENT/SERVER ERRORS
client_script "@soe-logging/client/cl_errorlog.lua"
server_script "@soe-logging/server/sv_errorlog.lua"

-- APPLIES MENUV CODE TO THIS RESOURCE
client_script "@soe-menuv/menuv.lua"

client_scripts {
    "client/*.lua",
    "client/Taxi/*.lua",
    "client/Towing/*.lua",
    "client/Mining/*.lua",
    "client/Hotdog/*.lua",
    "client/Hunting/*.lua",
    "client/PizzaDelivery/*.lua",
    "client/Woodcutting/*.lua",
    "client/GoPostal/*.lua",
    "client/Garbage/*.lua",
    "client/Security/*.lua",
    "client/Fishing/*.lua",
    "client/News/*.lua",
    "client/TreePicking/*.lua",
    "client/CluckinBell/*.lua",
    "client/CoC/*.lua",
    "client/Prospecting/*.lua"
}

shared_scripts {
    "shared/*.lua"
}

server_scripts {
    "server/*.lua",
    "server/Taxi/*.lua",
    "server/Towing/*.lua",
    "server/Hotdog/*.lua",
    "server/Hunting/*.lua",
    "server/Woodcutting/*.lua",
    "server/PizzaDelivery/*.lua",
    "server/GoPostal/*.lua",
    "server/Garbage/*.lua",
    "server/Security/*.lua",
    "server/Mining/*.lua",
    "server/Fishing/*.lua",
    "server/TreePicking/*.lua",
    "server/CluckinBell/*.lua",
    "server/CoC/*.lua",
    "server/Prospecting/*.lua"
}

exports {
    "GetMyJob",
    "IsOnDuty",
    "IsCloseToTaxiDepot",
    "IsCloseToGoPostalDepot",
    "IsCloseToGoPostalTruck",
    "IsCloseToGoPostalPackageDestination",
    "GetHasGoPostalPackage",
    "GetHasGoPostalPayToCollect",
    "GetMyGoPostalTruck",
    "IsCloseToPizzaDeliveryDestination",
    "IsCloseToGarbageDepot",
    "IsCloseToGarbageTruck",
    "GetHasRubbishBag",
    "GetHasGarbagePayToCollect",
    "GetMyGarbageTruck",
    "IsCloseToRubbish",
    "IsCloseToRubbishDropOff",
    "IsCloseToSecurityOffice",
    "HasSecurityPayToCollect",
    "HasCheckedOutSecurityVehicle",
    "UseFishingMap",
    "UseCamera",
    "UseRag"
}

server_exports {
    "GetJob",
    "IsOnDuty",
    "GetDutyCount",
    "AddProspectingTarget",
    "AddProspectingTargets",
    "StartProspecting",
    "StopProspecting",
    "IsProspecting",
    "SetDifficulty"
}
