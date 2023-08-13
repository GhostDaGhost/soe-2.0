-- LIST OF SEAPLANES CAN ANCHOR
seaplanes = {"dodo", "tula", "seabreeze"}

-- WEAPON CLASS BLACKLIST FROM GSR
gsrBlacklist = {
    [-37788308] = true,
    [690389602] = true, -- TASER
    [1548507267] = true, -- THROWN
    [1595662460] = true -- PETROL CAN
}

-- AREAS OF NO SHOTS FIRED CALLS
excludedShotsFiredZones = {
    -- ADAM'S APPLE BLVD AMMU-NATION
    {pos = vector3(13.14, -1098.0, 29.8), range = 20},
    -- POPULAR ST AMMU-NATION
    {pos = vector3(821.66, -2163.71, 29.6), range = 20},
    -- MISSION ROW PD SHOOTING RANGE
    {pos = vector3(485.89, -1009.84, 30.69), range = 22},
    -- ZANCUDO RACING FACILITY RANGE
    {pos = vector3(-2134.141, 3259.886, 32.80151), range = 22}
}

-- TABLE FULL OF SLUNG WEAPONS
slungWeaponList = {
    {Hash = GetHashKey("WEAPON_SMG"), obj = nil, model = "w_sb_smg", active = false, pos = vector3(0.0, -0.125, 0.0), rot = vector3(0.0, 120.0, 0.0)},
    {Hash = GetHashKey("WEAPON_MUSKET"), obj = nil, model = "w_ar_musket", active = false, pos = vector3(0.1, -0.125, 0.0), rot = vector3(0.0, 145.0, 0.0)},
    {Hash = GetHashKey("WEAPON_PUMPSHOTGUN"), obj = nil, model = "w_sg_pumpshotgun", active = false, pos = vector3(0.1, -0.125, 0.0), rot = vector3(0.0, 200.0, 0.0)},
    {Hash = GetHashKey("WEAPON_ASSAULTRIFLE"), obj = nil, model = "w_ar_assaultrifle", active = false, pos = vector3(0.1, -0.125, 0.0), rot = vector3(0.0, 120.0, 0.0)},
    {Hash = GetHashKey("WEAPON_CARBINERIFLE"), obj = nil, model = "w_ar_carbinerifle", active = false, pos = vector3(0.05, -0.125, 0.0), rot = vector3(0.0, 160.0, 0.0)},
    {Hash = GetHashKey("WEAPON_CARBINERIFLE_MK2"), obj = nil, model = "w_ar_carbineriflemk2", active = false, pos = vector3(0.05, -0.125, 0.0), rot = vector3(0.0, 150.0, 0.0)},
    {Hash = GetHashKey("WEAPON_PUMPSHOTGUN_MK2"), obj = nil, model = "w_sg_pumpshotgunmk2", active = false, pos = vector3(0.1, -0.125, 0.0), rot = vector3(0.0, 220.0, 0.0)},
    {Hash = GetHashKey("WEAPON_HEAVYSNIPER"), obj = nil, model = "w_sr_heavysniper", active = false, pos = vector3(0.1, -0.125, 0.0), rot = vector3(0.0, 223.0, 0.0)}
}

-- WEAPON RECOIL BASED ON MODEL
recoils = {
    ["WEAPON_PISTOL"] = 0.3, -- PISTOL
    ["WEAPON_PISTOL_MK2"] = 0.5, -- PISTOL MK2
    ["WEAPON_COMBATPISTOL"] = 0.2, -- COMBAT PISTOL
    ["WEAPON_CERAMICPISTOL"] = 0.23, -- CERAMIC PISTOL
    ["WEAPON_GLOCK"] = 0.25, -- GLOCK 17
    ["WEAPON_SIGP226"] = 0.23, -- SIG SAUER P226
    ["WEAPON_APPISTOL"] = 0.3, -- AP PISTOL
    ["WEAPON_PISTOL50"] = 0.6, -- PISTOL .50
    ["WEAPON_MICROSMG"] = 0.8, -- MICRO SMG
    ["WEAPON_SMG"] = 0.4, -- SMG
    ["WEAPON_ASSAULTRIFLE"] = 0.54, -- ASSAULT RIFLE
    ["WEAPON_CARBINERIFLE"] = 0.53, -- CARBINE RIFLE
    ["WEAPON_CARBINERIFLE_MK2"] = 0.53, -- CARBINE RIFLE MK2
    ["WEAPON_PUMPSHOTGUN"] = 0.4, -- PUMP SHOTGUN
    ["WEAPON_MACHINEPISTOL"] = 0.41, -- MACHINE PISTOL
    ["WEAPON_PUMPSHOTGUN_MK2"] = 0.35, -- PUMP SHOTGUN MK2
    ["WEAPON_SAWNOFFSHOTGUN"] = 0.7, -- SAWNOFF SHOTGUN
    ["WEAPON_STUNGUN"] = 0.1, -- STUN GUN
    ["WEAPON_SNIPERRIFLE"] = 0.5, -- SNIPER RIFLE
    ["WEAPON_HEAVYSNIPER"] = 0.9, -- HEAVY SNIPER
    ["WEAPON_HEAVYSNIPER_MK2"] = 0.11, -- HEAVY SNIPER MK2
    ["WEAPON_SNSPISTOL"] = 0.2, -- SNS PISTOL
    ["WEAPON_GUSENBERG"] = 0.43, -- GUSENBERG
    ["WEAPON_SPECIALCARBINE"] = 0.2, -- SPECIAL CARBINE
    ["WEAPON_HEAVYPISTOL"] = 0.4, -- HEAVY PISTOL
    ["WEAPON_VINTAGEPISTOL"] = 0.4, -- VINTAGE PISTOL
    ["WEAPON_MUSKET"] = 0.7, -- MUSKET
    ["WEAPON_MARKSMANRIFLE"] = 0.3, -- MARKSMAN RIFLE
    ["WEAPON_MARKSMANRIFLE_MK2"] = 0.25, -- MARKSMAN RIFLE MK2
    ["WEAPON_FLAREGUN"] = 0.9, -- FLARE GUN
    ["WEAPON_MARKSMANPISTOL"] = 0.9, -- MARKSMAN PISTOL
    ["WEAPON_DOUBLEACTION"] = 0.45, -- DOUBLE ACTION REVOLVER
    ["WEAPON_REVOLVER_MK2"] = 0.6, -- REVOLVER MK2
    ["WEAPON_DBSHOTGUN"] = 0.7, -- DOUBLE BARREL SHOTGUN
    ["WEAPON_COMPACTRIFLE"] = 0.42, -- COMPACT RIFLE
    ["WEAPON_MINISMG"] = 0.42, -- MINI SMG
    ["WEAPON_REVOLVER"] = 0.75 -- HEAVY REVOLVER
}

-- BOOM BOOM BOOM
boomBoxes = {
    {hash = "prop_boombox_01", name = "boombox"},
    {hash = "prop_poolball_cue", name = "dummyboombox", radius = 1.25},
    {hash = "bkr_prop_clubhouse_jukebox_01b", name = "jukebox", offSet = true, xOffSet = 0.0, yOffSet = 0.0, zOffSet = 1.0},
    {hash = "bkr_prop_clubhouse_jukebox_01a", name = "jukebox2", offSet = true, xOffSet = 0.0, yOffSet = 0.0, zOffSet = 1.0},
    {hash = "bkr_prop_clubhouse_jukebox_02a", name = "jukebox3", offSet = true, xOffSet = 0.0, yOffSet = 0.0, zOffSet = 1.0},
    {hash = "prop_50s_jukebox", name = "50sjukebox", offSet = true, xOffSet = 0.0, yOffSet = -0.25, zOffSet = 1.0},
    {hash = "prop_jukebox_01", name = "classicjukebox", offSet = true, xOffSet = 0.0, yOffSet = 0.0, zOffSet = 1.0},
    {hash = "prop_jukebox_02", name = "classicjukebox2", offSet = true, xOffSet = 0.0, yOffSet = -0.25, zOffSet = 1.0},
    {hash = "ch_prop_arcade_jukebox_01a", name = "arcadejukebox", offSet = true, xOffSet = 0.0, yOffSet = 0.0, zOffSet = 1.0},
}