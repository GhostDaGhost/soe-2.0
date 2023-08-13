-- LIST OF VEHICLES THAT'LL SPAWN WHEN AN AI CALLS IN A TOW
towingVehicles = {"GAUNTLET", "PREMIER", "SULTAN", "TAMPA", "VIGERO", "STALION", "RUINER", "RATLOADER", "VOODOO", "PICADOR",
"BUCCANEER", "DOMINATOR", "STANIER", "PANTO", "BUFFALO", "BODHI2", "GRANGER", "GRESLEY", "MESA", "MESA3", "DUNE", "REBEL",
"REBEL2", "KALAHARI", "BALLER", "BALLER2", "PATRIOT", "BLISTA2"}

-- LOCATIONS TO DROP OFF A VEHICLE
towingDropoffs = {
    vector3(401.23, -1632.89, 28.35), -- DAVIS IMPOUND
    vector3(-174.57, 6279.96, 30.61), -- PALETO SCRAPYARD
    vector3(263.5121, 2579.011, 44.17), -- HARMONY SCRAPYARD
    vector3(-239.46, -1183.2, 22.11), -- ADAMS APPLE IMPOUND LOT
}

-- LIST OF LOCATIONS WHERE AN AI TOW CALL CAN HAPPEN
towingCallLocations = {
    vector4(58.93187, 6669.257, 31.8916, 127.5591),
    vector4(-241.7934, 6407.736, 31.20068, 116.2205),
    vector4(-936.4352, 2742.25, 25.60657, 257.9528),
    vector4(202.7604, 2898.461, 44.73108, 65.19685),
    vector4(1332.237, 3550.47, 34.92456, 93.5433),
    vector4(1714.352, 1700.136, 80.30115, 187.0866),
    vector4(-509.2879, -1203.785, 19.2373, 317.4803),
    vector4(-268.6154, 6376.417, 30.71204, 297.6378),
    vector4(520.9187, 4258.233, 53.08862, 229.6063),
    vector4(1984.734, 4602.461, 40.73767, 303.3071),
    vector4(3144.185, 5050.352, 20.60217, 62.36221),
    vector4(493.4637, 350.8615, 136.5626, 31.1811),
    vector4(495.7055, -701.6176, 25.21899, 195.5905),
    vector4(1420.47, -1630.246, 59.91284, 243.7795),
    vector4(-330.844, -1352.347, 31.28503, 348.6614),
    vector4(-1176.87, -1744.048, 4.021973, 34.01575),
    vector4(-1866.752, 740.7824, 132.4344, 110.5512),
    vector4(-916.9714, 1997.736, 135.9897, 19.84252),
    vector4(532.6285, 2108.4, 85.22119, 317.4803),
    vector4(1179.956, 1201.701, 160.3883, 121.8898),
    vector4(204.3956, 419.4725, 118.6512, 308.9764),
    vector4(-394.9583, -266.5846, 35.36267, 45.35433),
    vector4(-895.6879, -472.589, 36.62634, 297.6378),
    vector4(2454.396, -694.1671, 62.03589, 272.126),
    vector4(853.3715, 3103.292, 40.19849, 65.19685),
    vector4(2040.013, 3389.604, 45.11865, 206.9291),
    vector4(585.9956, -93.00659, 69.04541, 294.8032),
    vector4(-973.1736, -655.5428, 24.57874, 116.2205),
    vector4(-1604.69, -167.7495, 55.61609, 218.2677),
    vector4(-164.8088, -1748.769, 30.00439, 138.8976)
}

-- TOWED VEHICLE OFFSETS WHEN ON A BED
towingData = {
    [GetHashKey("flatbed")] = {
        ["default"] = vector3(0.0, -2.0, 1.0),
        ["maxLength"] = 6.5,
        ["class"] = {},
        ["vehicle"] = {},
    },
    [GetHashKey("trflat")] = {
        ["default"] = vector3(0.0, -1.0, 1.5),
        ["maxLength"] = 15.0,
        ["class"] = {},
        ["vehicle"] = {}
    },
    [GetHashKey("boattrailer")] = {
        ["default"] = vector3(0.0, -1.0, 0.0),
        ["maxLength"] = 10.0,
        ["offset"] = -8.5,
        ["class"] = {},
        ["vehicle"] = {},
        ["bone"] = 0
    },
    [GetHashKey("tr2")] = {
        ["default"] = vector3(0.0, -1.0, 1.5),
        ["maxLength"] = 6.5,
        ["class"] = {},
        ["vehicle"] = {},
        [1] = {pos = vector3(0.0, 5.0, 0.8), rot = -1.0},
        [2] = {pos = vector3(0.0, 0.0, 0.9), rot = -2.0},
        [3] = {pos = vector3(0.0, -5.0, 0.9), rot = 4.0},
        [4] = {pos = vector3(0.0, 5.0, 2.8), rot = 4.0},
        [5] = {pos = vector3(0.0, 0.0, 2.9), rot = -4.0},
        [6] = {pos = vector3(0.0, -5.0, 3.0), rot = 2.0}
    },
    [GetHashKey("caracara2")] = {
        ["default"] = vector3(0.0, -2.5, 0.75),
        ["maxLength"] = 6.5,
        ["whitelist"] = {[8] = true, [9] = true, [13] = true, [14] = true},
        ["class"] = {},
        ["vehicle"] = {},
    },
    [GetHashKey("sadler")] = {
        ["default"] = vector3(0.0, -2.20, 0.75),
        ["maxLength"] = 6.5,
        ["whitelist"] = {[8] = true, [9] = true, [13] = true, [14] = true},
        ["class"] = {},
        ["vehicle"] = {},
    },
    [GetHashKey("sandking")] = {
        ["default"] = vector3(0.0, -2.20, 0.75),
        ["maxLength"] = 6.5,
        ["whitelist"] = {[8] = true, [9] = true, [13] = true, [14] = true},
        ["class"] = {},
        ["vehicle"] = {},
    },
    [GetHashKey("sandking2")] = {
        ["default"] = vector3(0.0, -2.20, 0.75),
        ["maxLength"] = 6.5,
        ["whitelist"] = {[8] = true, [9] = true, [13] = true, [14] = true},
        ["class"] = {},
        ["vehicle"] = {},
    },
    [GetHashKey("bison")] = {
        ["default"] = vector3(0.0, -2.20, 0.75),
        ["maxLength"] = 6.5,
        ["whitelist"] = {[8] = true, [9] = true, [13] = true, [14] = true},
        ["class"] = {},
        ["vehicle"] = {},
    },
    [GetHashKey("slamtruck")] = {
        ["default"] = vector3(0.0, -2.20, 1.0),
        ["maxLength"] = 6.5,
        ["class"] = {},
        ["vehicle"] = {},
    },
    [GetHashKey("everon")] = {
        ["default"] = vector3(0.0, -2.20, 0.75),
        ["maxLength"] = 6.5,
        ["whitelist"] = {[8] = true, [9] = true, [13] = true, [14] = true},
        ["class"] = {},
        ["vehicle"] = {},
    },
    [GetHashKey("bobcatxl")] = {
        ["default"] = vector3(0.0, -2.20, 0.75),
        ["maxLength"] = 6.5,
        ["whitelist"] = {[8] = true, [9] = true, [13] = true, [14] = true},
        ["class"] = {},
        ["vehicle"] = {},
    },
}

-- TOWING LOCATIONS TO START/END JOB
towingLocations = {
    {
        name = "davis_towing",
        pos = vector3(409.54, -1623.12, 29.29),
        length = 2.0,
        width = 7.0,
        options = {name = "davis_towing", heading = 50, minZ = 27.74, maxZ = 31.74, data = {
            spawn = vector4(406.21, -1642.48, 29.29, 228.61), marker = vector3(409.38, -1623.06, 29.29)
        }}
    },
    {
        name = "paleto_towing",
        pos = vector3(-196.02, 6265.41, 31.49),
        length = 3.0,
        width = 3.0,
        options = {name = "paleto_towing", heading = 310, minZ = 30.09, maxZ = 34.09, data = {
            spawn = vector4(-193.33, 6285.26, 31.43, 335.15), marker = vector3(-195.46, 6264.64, 31.49)
        }}
    },
    {
        name = "harmony_towing",
        pos = vector3(255.8, 2585.75, 45.09),
        length = 2.2,
        width = 1.8,
        options = {name = "harmony_towing", heading = 10, minZ = 43.29, maxZ = 47.29, data = {
            spawn = vector4(257.8813, 2577.666, 45.16919, 93.5433), marker = vector3(256.0615, 2585.829, 44.9165)
        }}
    }
}

hookTowTrucks = {
    [GetHashKey("towtruck")] = true,
    [GetHashKey("towtruck2")] = true,
}