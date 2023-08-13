-- AFK TIMER
idleMinutes = 30

-- NOCLIP SETTINGS
noclipSpeeds = {0.15, 0.35, 2, 4, 6, 8, 12, 20}
noclipSpeedNames = {"Super Slow", "Very Slow", "Slow", "Medium", "Fast", "Very Fast", "Super Fast", "Extremely Fast"}

-- LIST OF WEAPON HASHES THAT WOULD FLAG THE PLAYER AS USING A FORBIDDEN WEAPON
bannableWeapons = {"WEAPON_MG", "WEAPON_RPG", "WEAPON_BZGAS", "WEAPON_GRENADE", "WEAPON_MINIGUN", "WEAPON_RAILGUN", "WEAPON_COMBATMG", "WEAPON_PROXMINE",
"WEAPON_PIPEBOMB", "WEAPON_RAYCARBINE", "WEAPON_STICKYBOMB", "WEAPON_RAYMINIGUN", "WEAPON_COMBATMG_MK2", "WEAPON_HOMINGLAUNCHER", "WEAPON_GRENADELAUNCHER",
"WEAPON_COMPACTLAUNCHER", "WEAPON_GRENADELAUNCHER_SMOKE", "WEAPON_STINGER"}

-- LIST OF VEHICLE HASHES THAT WOULD FLAG THE PLAYER AS USING A FORBIDDEN VEHICLE
restrictedVehicles = {"police", "police2", "police3", "police4", "sheriff", "sheriff2", "pranger", "policeb", "rhino", "buzzard", "lazer"}

-- TEMP BAN TIME DATA
timeUnits = {
    ["s"] = 1,
    ["m"] = 60,
    ["h"] = 3600,
    ["d"] = 86400,
    ["w"] = 604800,
    ["M"] = 2592000,
    ["y"] = 31536000
}

-- LIST OF FORBIDDEN CHAT WORDS
-- SET THE BOOL TO TRUE IF YOU WANT THE WORD TO BE FLAGGED IN ANY INSTANCE AND FALSE IF YOU WANT IT TO BE FLAGGED STANDALONE ONLY
-- FOR EXAMPLE - SPIC CAN BE FOUND IN SPICE, SPICES, SUSPICIOUS, ETC. SO IT'S FALSE SO THAT IT ONLY FINDS IT BY ITSELF AND NOT IN OTHER WORDS
restrictedChatWords = {
    ["nigger"] = true,
    ["faggot"] = true,
    ["n!gger"] = true,
    ["niggger"] = true,
    ["nigggger"] = true,
    ["nigg3r"] = true,
    ["n!gg3r"] = true,
    ["niggg3r"] = true,
    ["fag"] = true,
    ["fags"] = true,
    ["faggots"] = true,
    ["faggs"] = true,
    ["retarded"] = true,
    ["retard"] = true,
    ["niger"] = true,
    ["n!ger"] = true,
    ["nig3r"] = true,
    ["n!g3r"] = true,
    ["paki"] = false,
    ["testmagicalrestrictedword"] = true,
    ["gook"] = true,
    ["kys"] = false,
    ["spic"] = false,
    ["nignog"] = true,
    ["rape"] = false
} 

-- LIST OF OBJECT HASHES THAT WOULD FLAG FIDELIS
restrictedObjects = {
    ["cargoplane"] = {log = true, ban = true, delete = true},
    ["p_cablecar_s"] = {log = true, delete = true},
    ["prop_gold_cont_01"] = {log = true, delete = true},
    ["p_spinning_anus_s"] = {log = true, delete = true},
    ["prop_fnclink_05crnr1"] = {log = true, delete = true},
    ["xs_prop_hamburgher_wl"] = {log = true, delete = true},
    ["stt_prop_stunt_tube_l"] = {log = true, delete = true},
    ["stt_prop_stunt_soccer_ball"] = {log = true, delete = true},
    ["stt_prop_stunt_track_dwuturn"] = {log = true, delete = true},
    ["stt_prop_stunt_bowling_pin"] = {log = true, delete = true},
    ["stt_prop_stunt_bowling_ball"] = {log = true, delete = true},
    ["hydra"] = {log = true, delete = false},
    ["rhino"] = {log = true, delete = false},
    ["valkyrie"] = {log = true, delete = false},
    ["lazer"] = {log = true, delete = false},
    ["savage"] = {log = true, delete = false},
    ["annihilator"] = {log = true, delete = false},
    ["khanjali"] = {log = true, delete = false},
    ["as_prop_as_dwslope30"] = {log = true, delete = true},
    ["ar_prop_ar_stunt_block_01a"] = {log = true, delete = true},
    ["ar_prop_ar_stunt_block_01b"] = {log = true, delete = true},
    ["ar_prop_ar_jump_loop"] = {log = true, delete = true},
    ["as_prop_as_stunt_target"] = {log = true, delete = true},
    ["as_prop_as_bblock_huge_04"] = {log = true, delete = true},
    ["as_prop_as_bblock_huge_05"] = {log = true, delete = true},
    ["as_prop_as_stunt_target_small"] = {log = true, delete = true},
    ["stt_prop_stunt_track_st_01"] = {log = true, delete = true},
    ["stt_prop_stunt_track_st_02"] = {log = true, delete = true},
    ["stt_prop_stunt_jump15"] = {log = true, delete = true},
    ["stt_prop_stunt_jump30"] = {log = true, delete = true},
    ["stt_prop_stunt_jump45"] = {log = true, delete = true},
    ["stt_prop_stunt_track_bumps"] = {log = true, delete = true},
    ["stt_prop_stunt_track_cutout"] = {log = true, delete = true},
    ["stt_prop_stunt_track_dwlink"] = {log = true, delete = true},
    ["stt_prop_stunt_track_dwlink_02"] = {log = true, delete = true},
    ["stt_prop_stunt_track_dwsh15"] = {log = true, delete = true},
    ["stt_prop_stunt_track_dwshort"] = {log = true, delete = true},
    ["stt_prop_stunt_track_dwslope15"] = {log = true, delete = true},
    ["stt_prop_stunt_track_dwslope30"] = {log = true, delete = true},
    ["stt_prop_stunt_track_dwslope45"] = {log = true, delete = true},
    ["stt_prop_stunt_track_dwturn"] = {log = true, delete = true},
    ["stt_prop_stunt_track_dwuturn"] = {log = true, delete = true},
    ["stt_prop_stunt_track_exshort"] = {log = true, delete = true},
    ["stt_prop_stunt_track_fork"] = {log = true, delete = true},
    ["stt_prop_stunt_track_funlng"] = {log = true, delete = true},
    ["stt_prop_stunt_track_funnel"] = {log = true, delete = true},
    ["stt_prop_stunt_track_hill"] = {log = true, delete = true},
    ["stt_prop_stunt_track_hill2"] = {log = true, delete = true},
    ["stt_prop_stunt_track_jump"] = {log = true, delete = true},
    ["stt_prop_stunt_track_slope15"] = {log = true, delete = true},
    ["stt_prop_stunt_track_slope30"] = {log = true, delete = true},
    ["stt_prop_stunt_track_slope45"] = {log = true, delete = true},
    ["prop_ld_ferris_wheel"] = {log = true, delete = true},
    ["p_ferris_wheel_amo_p"] = {log = true, delete = true},
    ["p_ferris_wheel_amo_l"] = {log = true, delete = true}, 
    ["p_ferris_wheel_amo_l2"] = {log = true, delete = true}, 
    ["stt_prop_stunt_landing_zone_01"] = {log = true, delete = true},
    ["stt_prop_stunt_ramp"] = {log = true, delete = true},
    ["stt_prop_stunt_track_dwslope30"] = {log = true, delete = true},
    ["dt1_05_damage_slod"] = {log = true, delete = true},
    ["apa_mp_h_acc_rugwoolm_03"] = {log = true, delete = true},
    ["prop_container_05a"] = {log = true, delete = true}, 
    ["stt_prop_stunt_bowling_ball"] = {log = true, delete = true}, 
    ["dt1_05_build1_damage_lod"] = {log = true, delete = true}, 
    ["p_spinning_anus_s"] = {log = true, delete = true},
    ["stt_prop_stunt_bblock_huge_01"] = {log = true, delete = true},
    ["stt_prop_stunt_bblock_huge_02"] = {log = true, delete = true},
    ["stt_prop_stunt_bblock_huge_03"] = {log = true, delete = true},
    ["stt_prop_stunt_bblock_huge_04"] = {log = true, delete = true},
    ["stt_prop_stunt_bblock_huge_05"] = {log = true, delete = true},
    ["stt_prop_stunt_bblock_hump_01"] = {log = true, delete = true},
    ["stt_prop_stunt_bblock_hump_02"] = {log = true, delete = true},
    ["stt_prop_stunt_bblock_lrg1"] = {log = true, delete = true}, 
    ["stt_prop_stunt_bblock_lrg2"] = {log = true, delete = true}, 
    ["stt_prop_stunt_bblock_lrg3"] = {log = true, delete = true}, 
    ["stt_prop_stunt_bblock_mdm1"] = {log = true, delete = true}, 
    ["stt_prop_stunt_bblock_mdm2"] = {log = true, delete = true},
    ["stt_prop_stunt_bblock_mdm3"] = {log = true, delete = true}, 
    ["stt_prop_stunt_bblock_qp"] = {log = true, delete = true}, 
    ["stt_prop_stunt_bblock_qp2"] = {log = true, delete = true}, 
    ["stt_prop_stunt_bblock_qp3"] = {log = true, delete = true}, 
    ["stt_prop_stunt_bblock_sml1"] = {log = true, delete = true}, 
    ["stt_prop_stunt_bblock_sml2"] = {log = true, delete = true}, 
    ["stt_prop_stunt_bblock_sml3"] = {log = true, delete = true}, 
    ["stt_prop_stunt_bblock_xl1"] = {log = true, delete = true}, 
    ["stt_prop_stunt_bblock_xl2"] = {log = true, delete = true}, 
    ["stt_prop_stunt_bblock_xl3"] = {log = true, delete = true}, 
    ["stt_prop_stunt_bowling_ball"] = {log = true, delete = true}, 
    ["stt_prop_stunt_bowling_pin"] = {log = true, delete = true}, 
    ["stt_prop_stunt_bowlpin_stand"] = {log = true, delete = true}, 
    ["stt_prop_stunt_domino"] = {log = true, delete = true}, 
    ["stt_prop_stunt_jump15"] = {log = true, delete = true}, 
    ["stt_prop_stunt_jump30"] = {log = true, delete = true}, 
    ["stt_prop_stunt_jump45"] = {log = true, delete = true}, 
    ["stt_prop_stunt_jump_l"] = {log = true, delete = true}, 
    ["stt_prop_stunt_jump_lb"] = {log = true, delete = true}, 
    ["stt_prop_stunt_jump_loop"] = {log = true, delete = true}, 
    ["stt_prop_stunt_jump_m"] = {log = true, delete = true}, 
    ["stt_prop_stunt_jump_mb"] = {log = true, delete = true}, 
    ["stt_prop_stunt_jump_s"] = {log = true, delete = true}, 
    ["stt_prop_stunt_jump_sb"] = {log = true, delete = true},
}

blockedExplosions = {
	[0] = {label = "Grenade", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[1] = {label = "Grenade Launcher", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[2] = {label = "Sticky Bomb", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[3] = {label = "Molotov", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[4] = {label = "Rocket", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[5] = {label = "Tank Shell", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[6] = {label = "Hi Octane", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[7] = {label = "Car", log = true, ban = false, invisible = false, silent = false, scale = 1.0},
	[8] = {label = "Plane", log = true, ban = false, invisible = false, silent = false, scale = 1.0},
	[9] = {label = "Gas Pump", log = true, ban = false, invisible = false, silent = false, scale = 1.0},
	[10] = {label = "Bike", log = true, ban = false, invisible = false, silent = false, scale = 1.0},
	[11] = {label = "Steam", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[12] = {label = "Flame", log = true, ban = false, invisible = false, silent = false, scale = 1.0},
	[13] = {label = "Water Hydrant", log = true, ban = false, invisible = false, silent = false, scale = 1.0},
	[14] = {label = "Gas Canister", log = true, ban = false, invisible = false, silent = false, scale = 1.0},
	[15] = {label = "Boat", log = true, ban = false, invisible = false, silent = false, scale = 1.0},
	[16] = {label = "Destroyed Ship", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[17] = {label = "Truck", log = true, ban = false, invisible = false, silent = false, scale = 1.0},
	[18] = {label = "Bullet", log = true, ban = false, invisible = false, silent = false, scale = 1.0},
	[19] = {label = "Smoke Grenade Launcher", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[20] = {label = "Smoke Grenade", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[21] = {label = "BZ Gas", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[22] = {label = "Flare", log = true, ban = false, invisible = false, silent = false, scale = 1.0},
	[23] = {label = "Gas Canister", log = true, ban = false, invisible = false, silent = false, scale = 1.0},
	[24] = {label = "Extinguisher", log = true, ban = false, invisible = false, silent = false, scale = 1.0},
	[25] = {label = "Programmablear", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[26] = {label = "Train", log = true, ban = false, invisible = false, silent = false, scale = 1.0},
	[27] = {label = "Barrel", log = true, ban = false, invisible = false, silent = false, scale = 1.0},
	[28] = {label = "Propane", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[29] = {label = "Blimp", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[30] = {label = "Gas Tank Explosion", log = false, ban = true, invisible = false, silent = false, scale = 1.0},
	[31] = {label = "Tanker", log = true, ban = false, invisible = false, silent = false, scale = 1.0},
	[32] = {label = "Plane Rocket", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[33] = {label = "Vehicle Bullet", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[34] = {label = "Gas Tank", log = true, ban = false, invisible = false, silent = false, scale = 1.0},
	[35] = {label = "Bird Crap", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[36] = {label = "Railgun", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[37] = {label = "Blimp 2", log = true, ban = false, invisible = false, silent = false, scale = 1.0},
	[38] = {label = "Firework", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[39] = {label = "Snowball", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[40] = {label = "Proximity Mine", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[41] = {label = "Valkyrie Cannon", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[42] = {label = "Air Defense", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[43] = {label = "Pipe Bomb", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[44] = {label = "Vehicle Mine", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[45] = {label = "Explosive Ammo", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[46] = {label = "APC Shell", log = true, ban = true, invisible = true, silent = false, scale = 1.0},
	[47] = {label = "Bomb: Cluster", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[48] = {label = "Bomb: Gas", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[49] = {label = "Bomb: Incendiary", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[50] = {label = "Bomb: Standard", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[51] = {label = "Torpedo", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[52] = {label = "Underwater Torpedo", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[53] = {label = "Bombushka Cannon Gas", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[54] = {label = "Bomb Cluster Secondary", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[55] = {label = "Hunter Barrage", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[56] = {label = "Hunter Cannon", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[57] = {label = "Rogue Cannon", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[58] = {label = "Underwater Mine", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[59] = {label = "Orbital Cannon", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[60] = {label = "Bomb Gas", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[61] = {label = "Explosive Ammo: Shotgun", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[62] = {label = "Oppressor 2 Cannon", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[63] = {label = "Mortar: Tar", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[64] = {label = "Vehicle Mine: Kinetic", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[65] = {label = "Vehicle Mine: EMP", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[66] = {label = "Vehicle Mine: Spike", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[67] = {label = "Vehicle Mine: Slick", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[68] = {label = "Vehicle Mine: Tar", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[69] = {label = "Drone", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[70] = {label = "Raygun", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[71] = {label = "Buried Mine", log = true, ban = true, invisible = false, silent = false, scale = 1.0},
	[72] = {label = "Missile", log = true, ban = true, invisible = false, silent = false, scale = 1.0}
}

-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, GET BAN LENGTH
function GetBanLength(text)
    if not text then return end

    local unit = string.sub(textLength, -1)
    local multiplier = timeUnits[unit]
    local length = tonumber(string.sub(text, 0, -2))

    return (length * multiplier) or 0
end