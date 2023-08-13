ammoTypes = {
    ["WEAPON_PISTOL"] = "pistol_magazine",
    ["WEAPON_PISTOL_MK2"] = "pistol_magazine",
    ["WEAPON_VINTAGEPISTOL"] = "pistol_magazine",
    ["WEAPON_HEAVYPISTOL"] = "pistol_magazine",
    ["WEAPON_FIREWORK"] = "ammo_firework",
    ["WEAPON_CERAMICPISTOL"] = "pistol_magazine",
    ["WEAPON_PISTOL50"] = "pistol_magazine",
    ["WEAPON_ASSAULTRIFLE"] = "ammo_rifle",
    ["WEAPON_MARKSMANRIFLE"] = "ammo_sniper",
    ["WEAPON_MARKSMANRIFLE_MK2"] = "ammo_sniper",
    ["WEAPON_SNIPERRIFLE"] = "ammo_sniper",
    ["WEAPON_HEAVYSNIPER"] = "ammo_sniper",
    ["WEAPON_HEAVYSNIPER_MK2"] = "ammo_sniper",
    ["WEAPON_CARBINERIFLE"] = "ammo_rifle",
    ["WEAPON_COMPACTRIFLE"] = "ammo_rifle",
    ["WEAPON_SPECIALCARBINE"] = "ammo_rifle",
    ["WEAPON_SPECIALCARBINE_MK2"] = "ammo_rifle",
    ["WEAPON_CARBINERIFLE_MK2"] = "ammo_rifle",
    ["WEAPON_STUNGUN"] = "ammo_taser",
    ["WEAPON_PUMPSHOTGUN"] = "ammo_shotgun",
    ["WEAPON_BULLPUPSHOTGUN"] = "ammo_shotgun",
    ["WEAPON_SAWNOFFSHOTGUN"] = "ammo_shotgun",
    ["WEAPON_ASSAULTSHOTGUN"] = "ammo_shotgun",
    ["WEAPON_HEAVYSHOTGUN"] = "ammo_shotgun",
    ["WEAPON_DBSHOTGUN"] = "ammo_shotgun",
    ["WEAPON_AUTOSHOTGUN"] = "ammo_shotgun",
    ["WEAPON_PUMPSHOTGUN_MK2"] = "ammo_beanbag",
    ["WEAPON_COMBATPISTOL"] = "pistol_magazine",
    ["WEAPON_APPISTOL"] = "pistol_magazine",
    ["WEAPON_MINISMG"] = "ammo_smg",
    ["WEAPON_MACHINEPISTOL"] = "ammo_smg",
    ["WEAPON_FLAREGUN"] = "ammo_flaregun",
    ["WEAPON_SMG"] = "ammo_mp5",
    ["WEAPON_GUSENBERG"] = "ammo_smg",
    ["WEAPON_MUSKET"] = "ammo_musket",
    ["WEAPON_REVOLVER"] = "ammo_revolver",
    ["WEAPON_MARKSMANPISTOL"] = "ammo_revolver",
    ["WEAPON_NAVYREVOLVER"] = "ammo_revolver",
    ["WEAPON_DOUBLEACTION"] = "ammo_revolver",
    ["WEAPON_REVOLVER_MK2"] = "ammo_revolver",
    ["WEAPON_COMBATSHOTGUN"] = "ammo_shotgun",
    ["WEAPON_MILITARYRIFLE"] = "ammo_rifle",
    ["WEAPON_SNSPISTOL"] = "pistol_magazine",
    ["WEAPON_SNSPISTOL_MK2"] = "pistol_magazine",
    ["WEAPON_MICROSMG"] = "ammo_smg",
    ["WEAPON_SMG_MK2"] = "ammo_mp5",
    ["WEAPON_ASSAULTSMG"] = "ammo_mp5",
    ["WEAPON_GLOCK"] = "pistol_magazine",
    ["WEAPON_SIGP226"] = "pistol_magazine",
}

weaponAttachments = {
    ["Pistol Flashlight"] = {
        ["WEAPON_PISTOL"] = "COMPONENT_AT_PI_FLSH",
        ["WEAPON_COMBATPISTOL"] = "COMPONENT_AT_PI_FLSH",
        ["WEAPON_APPISTOL"] = "COMPONENT_AT_PI_FLSH",
        ["WEAPON_PISTOL50"] = "COMPONENT_AT_PI_FLSH",
        ["WEAPON_HEAVYPISTOL"] = "COMPONENT_AT_PI_FLSH",
        ["WEAPON_REVOLVER_MK2"] = "COMPONENT_AT_PI_FLSH",
        --["WEAPON_SNSPISTOL_MK2"] = "COMPONENT_AT_PI_FLSH_03",
        ["WEAPON_PISTOL_MK2"] = "COMPONENT_AT_PI_FLSH_02",
        ["WEAPON_MICROSMG"] = "COMPONENT_AT_PI_FLSH",
        ["WEAPON_GLOCK"] = "COMPONENT_AT_PI_FLSH",
        ["WEAPON_SIGP226"] = "COMPONENT_AT_PI_FLSH",
    },

    ["Rifle Flashlight"] = {
        ["WEAPON_SMG"] = "COMPONENT_AT_AR_FLSH",
        ["WEAPON_ASSAULTSMG"] = "COMPONENT_AT_AR_FLSH",
        ["WEAPON_SMG_MK2"] = "COMPONENT_AT_AR_FLSH",
        ["WEAPON_COMBATPDW"] = "COMPONENT_AT_AR_FLSH",
        ["WEAPON_PUMPSHOTGUN"] = "COMPONENT_AT_AR_FLSH",
        ["WEAPON_ASSAULTSHOTGUN"] = "COMPONENT_AT_AR_FLSH",
        ["WEAPON_BULLPUPSHOTGUN"] = "COMPONENT_AT_AR_FLSH",
        --["WEAPON_PUMPSHOTGUN_MK2"] = "COMPONENT_AT_AR_FLSH",
        ["WEAPON_HEAVYSHOTGUN"] = "COMPONENT_AT_AR_FLSH",
        ["WEAPON_COMBATSHOTGUN"] = "COMPONENT_AT_AR_FLSH",
        ["WEAPON_ASSAULTRIFLE"] = "COMPONENT_AT_AR_FLSH",
        ["WEAPON_CARBINERIFLE"] = "COMPONENT_AT_AR_FLSH",
        ["WEAPON_ADVANCEDRIFLE"] = "COMPONENT_AT_AR_FLSH",
        ["WEAPON_SPECIALCARBINE"] = "COMPONENT_AT_AR_FLSH",
        ["WEAPON_BULLPUPRIFLE"] = "COMPONENT_AT_AR_FLSH",
        ["WEAPON_BULLPUPRIFLE_MK2"] = "COMPONENT_AT_AR_FLSH",
        ["WEAPON_SPECIALCARBINE_MK2"] = "COMPONENT_AT_AR_FLSH",
        ["WEAPON_ASSAULTRIFLE_MK2"] = "COMPONENT_AT_AR_FLSH",
        ["WEAPON_CARBINERIFLE_MK2"] = "COMPONENT_AT_AR_FLSH",
        ["WEAPON_MILITARYRIFLE"] = "COMPONENT_AT_AR_FLSH",
        ["WEAPON_MARKSMANRIFLE_MK2"] = "COMPONENT_AT_AR_FLSH",
        ["WEAPON_MARKSMANRIFLE"] = "COMPONENT_AT_AR_FLSH",
        ["WEAPON_GRENADELAUNCHER"] = "COMPONENT_AT_AR_FLSH"
    },

    ["Small Silencer"] = {
        ["WEAPON_PISTOL"] = "COMPONENT_AT_PI_SUPP",
        ["WEAPON_COMBATPISTOL"] = "COMPONENT_AT_PI_SUPP",
        ["WEAPON_APPISTOL"] = "COMPONENT_AT_PI_SUPP",
        ["WEAPON_HEAVYPISTOL"] = "COMPONENT_AT_PI_SUPP",
        --["WEAPON_SNSPISTOL_MK2"] = "COMPONENT_AT_PI_SUPP_02",
        ["WEAPON_PISTOL_MK2"] = "COMPONENT_AT_PI_SUPP_02",
        ["WEAPON_SMG"] = "COMPONENT_AT_PI_SUPP",
        ["WEAPON_SMG_MK2"] = "COMPONENT_AT_PI_SUPP",
        ["WEAPON_MACHINEPISTOL"] = "COMPONENT_AT_PI_SUPP"
    },

    ["Large Silencer"] = {
        ["WEAPON_PISTOL50"] = "COMPONENT_AT_AR_SUPP_02",
        ["WEAPON_MICROSMG"] = "COMPONENT_AT_AR_SUPP_02",
        ["WEAPON_ASSAULTSMG"] = "COMPONENT_AT_AR_SUPP_02",
        ["WEAPON_PUMPSHOTGUN"] = "COMPONENT_AT_SR_SUPP",
        ["WEAPON_ASSAULTSHOTGUN"] = "COMPONENT_AT_AR_SUPP",
        ["WEAPON_BULLPUPSHOTGUN"] = "COMPONENT_AT_AR_SUPP_02",
        --["WEAPON_PUMPSHOTGUN_MK2"] = "COMPONENT_AT_SR_SUPP_03",
        ["WEAPON_HEAVYSHOTGUN"] = "COMPONENT_AT_AR_SUPP_02",
        ["WEAPON_COMBATSHOTGUN"] = "COMPONENT_AT_AR_SUPP",
        ["WEAPON_ASSAULTRIFLE"] = "COMPONENT_AT_AR_SUPP_02",
        ["WEAPON_CARBINERIFLE"] = "COMPONENT_AT_AR_SUPP",
        ["WEAPON_ADVANCEDRIFLE"] = "COMPONENT_AT_AR_SUPP",
        ["WEAPON_SPECIALCARBINE"] = "COMPONENT_AT_AR_SUPP_02",
        ["WEAPON_BULLPUPRIFLE"] = "COMPONENT_AT_AR_SUPP",
        ["WEAPON_BULLPUPRIFLE_MK2"] = "COMPONENT_AT_AR_SUPP",
        ["WEAPON_SPECIALCARBINE_MK2"] = "COMPONENT_AT_AR_SUPP_02",
        ["WEAPON_ASSAULTRIFLE_MK2"] = "COMPONENT_AT_AR_SUPP_02",
        ["WEAPON_CARBINERIFLE_MK2"] = "COMPONENT_AT_AR_SUPP",
        ["WEAPON_MILITARYRIFLE"] = "COMPONENT_AT_AR_SUPP",
        ["WEAPON_SNIPERRIFLE"] = "COMPONENT_AT_AR_SUPP_02",
        ["WEAPON_MARKSMANRIFLE_MK2"] = "COMPONENT_AT_AR_SUPP",
        ["WEAPON_HEAVYSNIPER_MK2"] = "COMPONENT_AT_SR_SUPP_03",
        ["WEAPON_MARKSMANRIFLE"] = "COMPONENT_AT_AR_SUPP"
    },

    ["Holographic Sight"] = {
        ["WEAPON_REVOLVER_MK2"] = "COMPONENT_AT_SIGHTS",
        ["WEAPON_SMG_MK2"] = "COMPONENT_AT_SIGHTS_SMG",
        --["WEAPON_PUMPSHOTGUN_MK2"] = "COMPONENT_AT_SIGHTS",
        ["WEAPON_BULLPUPRIFLE_MK2"] = "COMPONENT_AT_SIGHTS",
        ["WEAPON_SPECIALCARBINE_MK2"] = "COMPONENT_AT_SIGHTS",
        ["WEAPON_ASSAULTRIFLE_MK2"] = "COMPONENT_AT_SIGHTS",
        ["WEAPON_CARBINERIFLE_MK2"] = "COMPONENT_AT_SIGHTS",
        ["WEAPON_COMBATMG_MK2"] = "COMPONENT_AT_SIGHTS",
        ["WEAPON_MARKSMANRIFLE_MK2"] = "COMPONENT_AT_SIGHTS",
        ["WEAPON_PISTOL_MK2"] = "COMPONENT_AT_PI_RAIL"
    },

    ["Normal Scope"] = {
        ["WEAPON_REVOLVER_MK2"] = "COMPONENT_AT_SCOPE_MACRO_MK2",
        --["WEAPON_SNSPISTOL_MK2"] = "COMPONENT_AT_PI_RAIL_02",
        ["WEAPON_MICROSMG"] = "COMPONENT_AT_SCOPE_MACRO",
        ["WEAPON_SMG"] = "COMPONENT_AT_SCOPE_MACRO_02",
        ["WEAPON_ASSAULTSMG"] = "COMPONENT_AT_SCOPE_MACRO",
        ["WEAPON_COMBATPDW"] = "COMPONENT_AT_SCOPE_SMALL",
        ["WEAPON_ASSAULTRIFLE"] = "COMPONENT_AT_SCOPE_MACRO",
        ["WEAPON_CARBINERIFLE"] = "COMPONENT_AT_SCOPE_MEDIUM",
        ["WEAPON_ADVANCEDRIFLE"] = "COMPONENT_AT_SCOPE_SMALL",
        ["WEAPON_SPECIALCARBINE"] = "COMPONENT_AT_SCOPE_MEDIUM",
        ["WEAPON_BULLPUPRIFLE"] = "COMPONENT_AT_SCOPE_SMALL",
        ["WEAPON_CARBINERIFLE_MK2"] = "COMPONENT_AT_SCOPE_MEDIUM_MK2",
        ["WEAPON_MILITARYRIFLE"] = "COMPONENT_AT_SCOPE_SMALL"
    },

    ["Rifle Grip"] = {
        ["WEAPON_COMBATPDW"] = "COMPONENT_AT_AR_AFGRIP",
        ["WEAPON_ASSAULTSHOTGUN"] = "COMPONENT_AT_AR_AFGRIP",
        ["WEAPON_BULLPUPSHOTGUN"] = "COMPONENT_AT_AR_AFGRIP",
        ["WEAPON_HEAVYSHOTGUN"] = "COMPONENT_AT_AR_AFGRIP",
        ["WEAPON_ASSAULTRIFLE"] = "COMPONENT_AT_AR_AFGRIP",
        ["WEAPON_CARBINERIFLE"] = "COMPONENT_AT_AR_AFGRIP",
        ["WEAPON_SPECIALCARBINE"] = "COMPONENT_AT_AR_AFGRIP",
        ["WEAPON_BULLPUPRIFLE"] = "COMPONENT_AT_AR_AFGRIP",
        ["WEAPON_BULLPUPRIFLE_MK2"] = "COMPONENT_AT_AR_AFGRIP_02",
        ["WEAPON_SPECIALCARBINE_MK2"] = "COMPONENT_AT_AR_AFGRIP_02",
        ["WEAPON_ASSAULTRIFLE_MK2"] = "COMPONENT_AT_AR_AFGRIP_02",
        ["WEAPON_CARBINERIFLE_MK2"] = "COMPONENT_AT_AR_AFGRIP_02",
        ["WEAPON_MARKSMANRIFLE_MK2"] = "COMPONENT_AT_AR_AFGRIP_02",
        ["WEAPON_MARKSMANRIFLE"] = "COMPONENT_AT_AR_AFGRIP"
    }
}