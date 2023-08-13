-- LIST OF STOCK THAT THE SUPPLIER HAS
supplyStock = {
    ["Weapons"] = {
        --{icon = "🔫", name = "Crate of Machine Pistols", hash = "crateofmachinepistols"}, UNTIL SMG AMMO CAN BE FIXED. :) - Ghost 6/20/21
        {icon = "🔫", name = "Crate of Compact Rifles", hash = "crateofcompactrifles"},
        {icon = "🔫", name = "Crate of Assault Rifles", hash = "crateofassaultrifles"},
        {icon = "🔫", name = "Crate of AP Pistols", hash = "crateofappistols"},
        {icon = "🔫", name = "Crate of Micro SMGs", hash = "crateofmicrosmgs"},
        {icon = "🔫", name = "Crate of DB Shotguns", hash = "crateofdbshotguns"},
        {icon = "🔫", name = "Crate of Sawed-Off Shotguns", hash = "crateofsawedoffshotguns"}
    },

    ["Drugs"] = {
        {icon = "💊", name = "Crate of Cocaine", hash = "crateofcocaine"},
        {icon = "💊", name = "Crate of Crack", hash = "crateofcrack"},
        {icon = "💊", name = "Crate of Meth", hash = "crateofmeth"},
        {icon = "💊", name = "Crate of Shrooms", hash = "crateofshrooms"},
    },

    ["Attachments"] = {
        {icon = "🛠️", name = "Crate of Small Silencers", hash = "crateofsmallsilencers"},
        {icon = "🛠️", name = "Crate of Large Silencers", hash = "crateoflargesilencers"},
    }
}

-- LIST OF LOCATIONS DEPENDING ON THE TYPE
supplyLocations = {
    -- LIST OF ZONES FOR SUPPLIER MISSION INITIATIONS
    ["Zones"] = {
        {
            name = "crimesupplier_delperro",
            pos = vector3(-1885.28, -325.28, 57.13),
            length = 2.0,
            width = 1.8,
            options = {name = "crimesupplier_delperro", heading = 0, minZ = 54.73, maxZ = 58.73, data = {type = "Weapons"}}
        },
        {
            name = "crimesupplier_baytree",
            pos = vector3(-45.71, 1918.55, 195.34),
            length = 1.8,
            width = 2.2,
            options = {name = "crimesupplier_baytree", heading = 5, minZ = 193.14, maxZ = 197.14, data = {type = "Drugs"}}
        },
        {
            name = "crimesupplier_grapeseed",
            pos = vector3(2567.54, 4652.24, 34.08),
            length = 1.8,
            width = 1.6,
            options = {name = "crimesupplier_grapeseed", heading = 24, minZ = 31.68, maxZ = 35.68, data = {type = "Attachments"}}
        }
    },

    -- AFTER THE VAN IS COLLECTED, DROP IT OFF AT A RANDOM POINT BELOW
    ["Destinations"] = {
        vector3(-166.2989, -2707.648, 5.993408),
        vector3(-165.5736, -2686.615, 6.010254),
        vector3(1760.295, -1654.576, 112.6696),
        vector3(-585.7714, -1593.679, 26.73547),
        vector3(276.1319, 2883.125, 43.60217),
        vector3(2553.31, 4671.771, 33.93042),
        vector3(1729.635, 4773.495, 41.81616),
        vector3(2308.919, 4887.244, 41.79932),
        vector3(-109.1736, 2805.231, 53.15601)
    },

    -- LIST OF PLACES WHERE A WEAPON CRATE VAN WOULD BE SPAWNED
    ["Weapons"] = {
        {
            ped = GetHashKey("csb_mweather"),
            vehiclePos = vector4(462.6198, -3235.464, 6.060791, 269.2914),
            vehicles = {"burrito3", "gburrito", "gburrito2", "speedo", "speedo2", "rumpo"},
            msg = "Received word that Merryweather has a van with a weapon crate sealed inside at their base in the docks. Go get it.",
            npcs = {
                {pos = vector4(468.0659, -3226.444, 6.060791, 226.7717), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_ASSAULTSMG", "WEAPON_SMG"}},
                {pos = vector4(482.3604, -3239.96, 6.060791, 45.35433), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_ASSAULTSMG", "WEAPON_SMG"}},
                {pos = vector4(496.8264, -3222.488, 6.060791, 272.126), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_ASSAULTSMG", "WEAPON_SMG"}},
                {pos = vector4(463.7143, -3261.244, 6.060791, 36.8504), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_ASSAULTSMG", "WEAPON_SMG"}}
            }
        },
        {
            ped = GetHashKey("mp_m_bogdangoon"),
            vehiclePos = vector4(2862.013, 1466.057, 24.54504, 68.03149),
            vehicles = {"burrito3", "gburrito", "gburrito2", "speedo", "speedo2", "rumpo"},
            msg = "The power station has a weapon van held there. Go get it and deliver it to the destination when you got it.",
            npcs = {
                {pos = vector4(2854.787, 1479.297, 24.73035, 167.2441), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_ASSAULTSMG", "WEAPON_SMG"}},
                {pos = vector4(2846.242, 1460.387, 24.56189, 348.6614), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_ASSAULTSMG", "WEAPON_SMG"}},
                {pos = vector4(2833.714, 1480.193, 24.57874, 167.2441), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_ASSAULTSMG", "WEAPON_SMG"}},
                {pos = vector4(2835.033, 1486.18, 24.7135, 257.9528), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_ASSAULTSMG", "WEAPON_SMG"}},
                {pos = vector4(2867.723, 1476.501, 24.56189, 164.4095), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_ASSAULTSMG", "WEAPON_SMG"}},
                {pos = vector4(2861.13, 1454.862, 24.56189, 342.9921), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_ASSAULTSMG", "WEAPON_SMG"}},
                {pos = vector4(2847.218, 1458.396, 32.5824, 348.6614), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_ASSAULTSMG", "WEAPON_SMG"}},
                {pos = vector4(2855.842, 1455.956, 32.5824, 342.9921), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_ASSAULTSMG", "WEAPON_SMG"}},
                {pos = vector4(2862.105, 1479.125, 29.7179, 167.2441), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_ASSAULTSMG", "WEAPON_SMG"}},
                {pos = vector4(2849.96, 1482.527, 29.7179, 167.2441), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_ASSAULTSMG", "WEAPON_SMG"}},
                {pos = vector4(2848.563, 1492.84, 29.7179, 22.67716), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_ASSAULTSMG", "WEAPON_SMG"}},
                {pos = vector4(2826.594, 1462.18, 24.54504, 308.9764), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_ASSAULTSMG", "WEAPON_SMG"}},
            }
        }
    },

    -- LIST OF PLACES WHERE A DRUG CRATE VAN WOULD BE SPAWNED
    ["Drugs"] = {
        {
            ped = GetHashKey("mp_m_exarmy_01"),
            vehiclePos = vector4(1261.53, 1911.93, 78.51501, 223.937),
            vehicles = {"burrito3", "gburrito", "gburrito2", "speedo", "speedo2", "rumpo"},
            msg = "There's a small factory off of Senora Road where a group of hillbillies are keeping the van.",
            npcs = {
                {pos = vector4(1264.365, 1918.075, 78.49817, 238.1102), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}},
                {pos = vector4(1260.435, 1903.754, 78.85205, 311.811), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}},
                {pos = vector4(1268.545, 1894.787, 79.62708, 280.6299), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}},
                {pos = vector4(1279.266, 1909.424, 82.07031, 116.2205), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}},
                {pos = vector4(1267.899, 1935.204, 80.03149, 136.063), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}},
                {pos = vector4(1245.112, 1906.76, 78.70032, 36.8504), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}},
                {pos = vector4(1282.549, 1891.015, 83.51941, 48.18897), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}},
                {pos = vector4(1290.963, 1915.306, 84.58093, 232.4409), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}},
            }
        },
        {
            ped = GetHashKey("s_m_m_highsec_01"),
            vehiclePos = vector4(144.3297, -3002.677, 7.02124, 357.1653),
            vehicles = {"burrito3", "gburrito", "gburrito2", "speedo", "speedo2", "rumpo"},
            msg = "Go down to the docks and there should be a location where some people have the van held up.",
            npcs = {
                {pos = vector4(134.5187, -3000.369, 7.02124, 337.3228), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}},
                {pos = vector4(140.4527, -2988.554, 7.02124, 187.0866), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}},
                {pos = vector4(154.0615, -2993.895, 7.02124, 59.52756), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}},
                {pos = vector4(153.3495, -3002.334, 7.02124, 25.51181), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}},
                {pos = vector4(160.9978, -2987.011, 5.892334, 300.4724), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}},
                {pos = vector4(161.3011, -2971.305, 5.892334, 172.9134), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}},
                {pos = vector4(156.989, -2986.022, 5.892334, 2.834646), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}},
                {pos = vector4(128.3868, -2983.648, 6.886475, 272.126), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}}
            }
        },
        {
            ped = GetHashKey("u_m_y_proldriver_01"),
            vehiclePos = vector4(364.5099, 3559.938, 33.37439, 22.67716),
            vehicles = {"burrito3", "gburrito", "gburrito2", "speedo", "speedo2", "rumpo"},
            msg = "Small building on Marina Drive. They got the van held up there.",
            npcs = {
                {pos = vector4(364.6813, 3573.679, 33.3407, 87.87402), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}},
                {pos = vector4(366.1978, 3590.901, 33.37439, 42.51968), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}},
                {pos = vector4(344.0835, 3586.708, 33.59338, 342.9921), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}},
                {pos = vector4(344.7692, 3557.934, 33.29016, 252.2835), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}},
                {pos = vector4(340.022, 3542.11, 33.37439, 5.669291), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}},
                {pos = vector4(322.9846, 3551.565, 33.29016, 300.4724), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}},
                {pos = vector4(317.2352, 3574.655, 33.22266, 274.9606), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}},
                {pos = vector4(341.5516, 3603.626, 33.61023, 221.1024), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}}
            }
        },
        {
            ped = GetHashKey("s_m_m_fibsec_01"),
            vehiclePos = vector4(1009.82, -2528.545, 28.30261, 354.3307),
            vehicles = {"burrito3", "gburrito", "gburrito2", "speedo", "speedo2", "rumpo"},
            msg = "Large warehouse on Hanger Way at Elysian Fields has the van held there. Take out the corrupt guards there.",
            npcs = {
                {pos = vector4(1016.941, -2529.059, 28.28577, 45.35433), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}},
                {pos = vector4(1014.224, -2518.009, 28.30261, 87.87402), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}},
                {pos = vector4(1018.787, -2511.323, 28.47107, 82.20473), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}},
                {pos = vector4(996.6857, -2513.42, 28.28577, 266.4567), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}},
                {pos = vector4(997.8461, -2530.101, 28.45422, 28.34646), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}},
                {pos = vector4(975.6264, -2523.376, 28.43738, 257.9528), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}},
                {pos = vector4(976.5758, -2511.073, 28.43738, 289.1339), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}},
                {pos = vector4(978.567, -2498.387, 28.28577, 303.3071), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_APPISTOL"}}
            }
        }
    },

    -- LIST OF PLACES WHERE A ATTACHMENTS CRATE VAN WOULD BE SPAWNED
    ["Attachments"] = {
        {
            ped = GetHashKey("csb_ramp_mex"),
            vehiclePos = vector4(-299.2747, 2816.281, 59.17139, 240.9449),
            vehicles = {"burrito3", "gburrito", "gburrito2", "speedo", "speedo2", "rumpo"},
            msg = "The old church off of Route 68. Go get the shipment and take out the gang members there.",
            npcs = {
                {pos = vector4(-302.2154, 2804.044, 59.44104, 238.1102), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_PISTOL"}},
                {pos = vector4(-296.3604, 2817.811, 59.18823, 272.126), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_PISTOL"}},
                {pos = vector4(-290.6374, 2801.881, 59.07031, 121.8898), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_PISTOL"}},
                {pos = vector4(-297.5341, 2785.701, 60.80591, 82.20473), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_PISTOL"}},
                {pos = vector4(-311.8681, 2772.791, 62.27185, 345.8268), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_PISTOL"}},
                {pos = vector4(-315.6132, 2789.196, 59.64319, 206.9291), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_PISTOL"}},
                {pos = vector4(-295.9517, 2819.921, 59.17139, 289.1339), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_PISTOL"}}
            }
        },
        {
            ped = GetHashKey("mp_m_avongoon"),
            vehiclePos = vector4(-1070.492, -1671.27, 4.443237, 34.01575),
            vehicles = {"burrito3", "gburrito", "gburrito2", "speedo", "speedo2", "rumpo"},
            msg = "Alleyway on Melanoma St. Take out the odd goons and take the van.",
            npcs = {
                {pos = vector4(-1069.978, -1664.018, 4.527466, 158.7402), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_PISTOL"}},
                {pos = vector4(-1076.083, -1655.75, 4.426392, 82.20473), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_PISTOL"}},
                {pos = vector4(-1083.653, -1663.965, 4.645386, 345.8268), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_PISTOL"}},
                {pos = vector4(-1086.818, -1656.897, 4.409546, 257.9528), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_PISTOL"}},
                {pos = vector4(-1102.826, -1643.96, 7.931152, 246.6142), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_PISTOL"}},
                {pos = vector4(-1089.719, -1652.993, 7.442505, 232.4409), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_PISTOL"}},
                {pos = vector4(-1082.993, -1647.27, 4.426392, 110.5512), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_PISTOL"}},
                {pos = vector4(-1105.886, -1633.477, 4.611694, 277.7953), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_PISTOL"}}
            }
        },
        {
            ped = GetHashKey("csb_bogdan"),
            vehiclePos = vector4(1217.604, -2903.631, 5.858643, 178.5827),
            vehicles = {"burrito3", "gburrito", "gburrito2", "speedo", "speedo2", "rumpo"},
            msg = "A Russian gang on the docks have the shipment inside a van. Take the goons out and steal the van.",
            npcs = {
                {pos = vector4(1222.998, -2901.785, 5.858643, 119.0551), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_PISTOL"}},
                {pos = vector4(1206.699, -2919.178, 5.858643, 249.4488), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_PISTOL"}},
                {pos = vector4(1221.323, -2936.914, 5.858643, 85.03937), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_PISTOL"}},
                {pos = vector4(1198.721, -2953.292, 5.892334, 223.937), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_PISTOL"}},
                {pos = vector4(1200.91, -2927.868, 5.892334, 90.70866), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_PISTOL"}},
                {pos = vector4(1204.352, -2901.561, 5.875488, 170.0787), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_PISTOL"}},
                {pos = vector4(1227.429, -2919.138, 9.312866, 90.70866), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_PISTOL"}}
            }
        },
        {
            ped = GetHashKey("csb_mweather"),
            vehiclePos = vector4(2465.763, 1588.826, 32.71716, 274.9606),
            vehicles = {"burrito3", "gburrito", "gburrito2", "speedo", "speedo2", "rumpo"},
            msg = "Across the power station, the shipment is guarded heavily. Get it out of there safe and sound.",
            npcs = {
                {pos = vector4(2471.288, 1594.655, 32.71716, 87.87402), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_PISTOL"}},
                {pos = vector4(2461.042, 1595.222, 32.71716, 286.2992), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_PISTOL"}},
                {pos = vector4(2466.923, 1582.444, 32.71716, 306.1417), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_PISTOL"}},
                {pos = vector4(2477.591, 1573.82, 32.71716, 348.6614), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_PISTOL"}},
                {pos = vector4(2482.286, 1600.062, 32.71716, 184.252), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_PISTOL"}},
                {pos = vector4(2492.097, 1596.976, 32.71716, 113.3858), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_PISTOL"}},
                {pos = vector4(2492.69, 1582.101, 32.71716, 59.52756), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_PISTOL"}},
                {pos = vector4(2490.673, 1570.088, 32.71716, 31.1811), weapons = {"WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_PISTOL"}}
            }
        },
    }
}
