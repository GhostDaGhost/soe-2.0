-- **************************
--     Machine Tampering
-- **************************
-- LIST OF MACHINE HASHES THAT CAN BE ROBBED
robbableVendingMachines = {992069095, 1114264700, -654402915, 690372739}

extraVendingMachineLoot = {
    [992069095] = {"ecola"},
    [1114264700] = {"sprunk"},
    [-654402915] = {"gummies", "candybar", "bagofcandy"}
}

-- **************************
--      Jewelry Robbery
-- **************************
-- JEWELRY LOOT GENERATOR
jewelryLoot = {
    {hash = "earrings", name = "Earrings", min = 1, max = 5},
    {hash = "necklace", name = "Necklace", min = 1, max = 5},
    {hash = "bracelet", name = "Bracelet", min = 1, max = 5},
    {hash = "goldwatch", name = "Gold Watch", min = 1, max = 5},
    {hash = "goldring", name = "Gold Ring", min = 1, max = 5}
}

-- LIST OF JEWELRY SHOWCASES THAT ARE ROBBABLE
jewelryCases = {
    [1] = {pos = vector3(-626.83, -235.35, 38.05), broken = false},
    [2] = {pos = vector3(-625.81, -234.7, 38.05), broken = false},
    [3] = {pos = vector3(-626.95, -233.14, 38.05), broken = false},
    [4] = {pos = vector3(-628.0, -233.86, 38.05), broken = false},
    [5] = {pos = vector3(-625.7, -237.8, 38.05), broken = false},
    [6] = {pos = vector3(-626.7, -238.58, 38.05), broken = false},
    [7] = {pos = vector3(-624.55, -231.06, 38.05), broken = false},
    [8] = {pos = vector3(-623.13, -232.94, 38.05), broken = false},
    [9] = {pos = vector3(-620.29, -234.44, 38.05), broken = false},
    [10] = {pos = vector3(-619.15, -233.66, 38.05), broken = false},
    [11] = {pos = vector3(-620.19, -233.44, 38.05), broken = false},
    [12] = {pos = vector3(-617.63, -230.58, 38.05), broken = false},
    [13] = {pos = vector3(-618.33, -229.55, 38.05), broken = false},
    [14] = {pos = vector3(-619.7, -230.33, 38.05), broken = false},
    [15] = {pos = vector3(-620.95, -228.6, 38.05), broken = false},
    [16] = {pos = vector3(-619.79, -227.6, 38.05), broken = false},
    [17] = {pos = vector3(-620.42, -226.6, 38.05), broken = false},
    [18] = {pos = vector3(-623.94, -227.18, 38.05), broken = false},
    [19] = {pos = vector3(-624.91, -227.87, 38.05), broken = false},
    [20] = {pos = vector3(-623.94, -228.05, 38.05), broken = false}
}

-- **************************
--      Store Robberies
-- **************************
-- LIST OF CASH REGISTERS ROBBABLE
storeRegisters = {
    -- DAVIS LTD
    {x = -47.24, y = -1757.65, z = 29.53, name = "Davis LTD", robbed = false},
    {x = -48.58, y = -1759.21, z = 29.59, name = "Davis LTD", robbed = false},
    -- PROSPERITY ST LIQUOR STORE
    {x = -1486.26, y = -378.0, z = 40.16, name = "Prosperity St. Liquor Store", robbed = false},
    -- SAN ANDREAS AVE LIQUOR STORE
    {x = -1222.03, y = -908.32, z = 12.32, name = "San Andreas Ave Liquor Store", robbed = false},
    -- LINDSAY CIRCUS LTD
    {x = -706.08, y = -915.42, z = 19.21, name = "Lindsay Circus LTD", robbed = false},
    {x = -706.16, y = -913.5, z = 19.21, name = "Lindsay Circus LTD", robbed = false},
    -- INNOCENCE BLVD 24/7
    {x = 24.47, y = -1344.99, z = 29.49, name = "Innocence Blvd 24/7", robbed = false},
    {x = 24.45, y = -1347.37, z = 29.49, name = "Innocence Blvd 24/7", robbed = false},
    -- EL RANCHO BLVD LIQUOR STORE
    {x = 1134.15, y = -982.53, z = 46.41, name = "El Rancho Blvd Liquor Store", robbed = false},
    -- MIRROR PARK 24/7
    {x = 1165.05, y = -324.49, z = 69.2, name = "Mirror Park 24/7", robbed = false},
    {x = 1164.7, y = -322.58, z = 69.2, name = "Mirror Park 24/7", robbed = false},
    -- CLINTON AVE 24/7
    {x = 373.14, y = 328.62, z = 103.56, name = "Clinton Ave 24/7", robbed = false},
    {x = 372.57, y = 326.42, z = 103.56, name = "Clinton Ave 24/7", robbed = false},
    -- NORTH ROCKFORD DRIVE LTD
    {x = -1818.9, y = 792.9, z = 138.08, name = "North Rockford Drive LTD", robbed = false},
    {x = -1820.17, y = 794.28, z = 138.08, name = "North Rockford Drive LTD", robbed = false},
    -- BANHAM CANYON LIQUOR STORE
    {x = -2966.46, y = 390.89, z = 15.04, name = "Banham Canyon Liquor Store", robbed = false},
    -- INSENO ROAD 24/7
    {x = -3041.14, y = 583.87, z = 7.9, name = "Inseno Road 24/7", robbed = false},
    {x = -3038.92, y = 584.5, z = 7.9, name = "Inseno Road 24/7", robbed = false},
    -- BARBARENO ROAD 24/7
    {x = -3244.56, y = 1000.14, z = 12.83, name = "Barbareno Road 24/7", robbed = false},
    {x = -3242.24, y = 999.98, z = 12.83, name = "Barbareno Road 24/7", robbed = false},
    -- HARMONY 24/7
    {x = 549.42, y = 2669.06, z = 42.15, name = "Harmony 24/7", robbed = false},
    {x = 549.05, y = 2671.39, z = 42.15, name = "Harmony 24/7", robbed = false},
    -- ROUTE 68 LIQUOR STORE
    {x = 1165.9, y = 2710.81, z = 38.15, name = "Route 68 Liquor Store", robbed = false},
    -- SENORA FWY 24/7
    {x = 2676.02, y = 3280.52, z = 55.24, name = "Senora Fwy 24/7", robbed = false},
    {x = 2678.07, y = 3279.39, z = 55.24, name = "Senora Fwy 24/7", robbed = false},
    -- ALHAMBRA DRIVE 24/7
    {x = 1958.96, y = 3741.98, z = 32.34, name = "Alhambra Drive 24/7", robbed = false},
    {x = 1960.13, y = 3740.0, z = 32.34, name = "Alhambra Drive 24/7", robbed = false},
    -- BRADDOCK PASS 24/7
    {x = 1728.86, y = 6417.26, z = 35.03, name = "Braddock Pass 24/7", robbed = false},
    {x = 1727.85, y = 6415.14, z = 35.03, name = "Braddock Pass 24/7", robbed = false},
    -- TEQUI-LA-LA
    {x = -563.4, y = 279.3, z = 82.98, name = "Tequi-La-La Bar", robbed = false},
    {x = -562.36, y = 287.5, z = 82.18, name = "Tequi-La-La Bar", robbed = false},
    -- AMMU-NATION / ADAM'S APPLE BLVD
    {x = 17.58, y = -1108.37, z = 29.8, name = "Adam's Apple Blvd Ammu-Nation", robbed = false},
    {x = 23.98, y = -1105.91, z = 29.8, name = "Adam's Apple Blvd Ammu-Nation", robbed = false},
    -- AMMU-NATION / LA MESA
    {x = 846.21, y = -1030.87, z = 28.19, name = "La Mesa Ammu-Nation", robbed = false},
    {x = 841.11, y = -1035.35, z = 28.19, name = "La Mesa Ammu-Nation", robbed = false},
    -- VANGELICO JEWELRY STORE
    {x = -622.27, y = -229.93, z = 38.06, name = "Vangelico Jewelry Store", robbed = false},
    -- AMMU-NATION / SPANISH AVE
    {x = 250.92, y = -45.51, z = 69.94, name = "Spanish Ave Ammu-Nation", robbed = false},
    {x = 253.35, y = -51.69, z = 69.94, name = "Spanish Ave Ammu-Nation", robbed = false},
    -- AMMU-NATION / DEL PERRO
    {x = -1307.44, y = -389.94, z = 36.7, name = "Del Perro Ammu-Nation", robbed = false},
    {x = -1304.44, y = -395.9, z = 36.7, name = "Del Perro Ammu-Nation", robbed = false},
    -- AMMU-NATION / CYPRESS FLATS
    {x = 813.96, y = -2154.58, z = 29.62, name = "Cypress Flats Ammu-Nation", robbed = false},
    {x = 808.89, y = -2159.0, z = 29.62, name = "Cypress Flats Ammu-Nation", robbed = false},
    -- AMMU-NATION / LITTLE SEOUL
    {x = -666.03, y = -937.92, z = 21.83, name = "Little Seoul Ammu-Nation", robbed = false},
    {x = -660.95, y = -933.61, z = 21.83, name = "Little Seoul Ammu-Nation", robbed = false},
    -- PALOMINO FWY 24/7
    {x = 2554.9, y = 380.94, z = 108.62, name = "Palomino Fwy 24/7", robbed = false},
    {x = 2557.25, y = 380.81, z = 108.62, name = "Palomino Fwy 24/7", robbed = false},
    -- AMMU-NATION / PALOMINO FWY
    {x = 2571.67, y = 297.0, z = 108.73, name = "Palomino Fwy Ammu-Nation", robbed = false},
    {x = 2566.64, y = 292.64, z = 108.73, name = "Palomino Fwy Ammu-Nation", robbed = false},
    -- AMMU-NATION / CHUMASH
    {x = -3170.96, y = 1083.22, z = 20.84, name = "Chumash Ammu-Nation", robbed = false},
    {x = -3173.06, y = 1089.61, z = 20.84, name = "Chumash Ammu-Nation", robbed = false},
    -- AMMU-NATION / SANDY SHORES
    {x = 1693.0, y = 3755.24, z = 34.71, name = "Sandy Shores Ammu-Nation", robbed = false},
    {x = 1693.21, y = 3761.96, z = 34.71, name = "Sandy Shores Ammu-Nation", robbed = false},
    -- AMMU-NATION / ROUTE 68
    {x = -1118.81, y = 2694.0, z = 18.55, name = "Route 68 Ammu-Nation", robbed = false},
    {x = -1117.98, y = 2700.59, z = 18.55, name = "Route 68 Ammu-Nation", robbed = false},
    -- AMMU-NATION / PALETO BAY
    {x = -331.16, y = 6079.26, z = 31.45, name = "Paleto Bay Ammu-Nation", robbed = false},
    {x = -330.61, y = 6085.92, z = 31.45, name = "Paleto Bay Ammu-Nation", robbed = false},
    -- GRAPESEED MAIN ST. LTD
    {x = 1698.04, y = 4922.98, z = 42.06, name = "Grapeseed Main St. LTD", robbed = false},
    {x = 1696.56, y = 4923.88, z = 42.06, name = "Grapeseed Main St. LTD", robbed = false},
    -- PALETO BAY 24/7
    {x = 162.11, y = 6643.29, z = 31.61, name = "Paleto Bay 24/7", robbed = false},
    {x = 160.46, y = 6641.61, z = 31.61, name = "Paleto Bay 24/7", robbed = false},
    -- POP'S PILLS / PALETO BAY
    {x = 157.85, y = 6655.49, z = 31.67, name = "Paleto Bay Pop's Pills", robbed = false},
    -- MECHANIC SHOP / PALETO BAY
    {x = 112.86, y = 6633.19, z = 31.99, name = "Paleto Bay Mechanic Shop", robbed = false},
    {x = 114.92, y = 6631.09, z = 31.97, name = "Paleto Bay Mechanic Shop", robbed = false},
    -- CHIHUAHUA HOTDOGS / VESPUCCI BLVD
    {x = 44.29, y = -1005.65, z = 29.29, name = "Vespucci Blvd Chihuahua Hotdogs", robbed = false},
    {x = 43.04, y = -1005.26, z = 29.29, name = "Vespucci Blvd Chihuahua Hotdogs", robbed = false},
    -- NORTH ROCKFORD DRIVE 24/7
    {x = -1421.83, y = -270.42, z = 46.3, name = "North Rockford Drive 24/7", robbed = false},
    {x = -1423.12, y = -271.66, z = 46.26, name = "North Rockford Drive 24/7", robbed = false},
    -- LAGO ZANCUDO 24/7
    {x = -2539.14, y = 2311.57, z = 33.41, name = "Lago Zancudo 24/7", robbed = false},
    {x = -2539.33, y = 2313.95, z = 33.41, name = "Lago Zancudo 24/7", robbed = false},
    -- DIGITAL DEN / LITTLE SEOUL
    {x = -658.07, y = -858.76, z = 24.49, name = "Little Seoul Digital Den", robbed = false},
    -- DIGITAL DEN / MIRROR PARK
    {x = -1133.49, y = -474.66, z = 66.72, name = "Mirror Park Digital Den", robbed = false},
    -- GRAPESEED MAIN ST LIQUOR STORE
    {x = 1686.7, y = 4865.36, z = 42.07, name = "Grapeseed Main St. Liquor Store", robbed = false},
    -- PALETO BAY LIQUOR STORE
    {x = -161.13, y = 6321.45, z = 31.59, name = "Paleto Bay Liquor Store", robbed = false},
    -- DAVIS AVE 24/7
    {x = 168.49, y = -1547.47, z = 29.37, name = "Davis Ave 24/7", robbed = false},
    {x = 169.89, y = -1548.94, z = 29.37, name = "Davis Ave 24/7", robbed = false},
    -- WEST ECLIPSE BLVD PACIFIC BLUFFS LTD
    {x = -2070.38, y = -332.72, z = 13.45, name = "Davis LTD", robbed = false},
    {x = -2072.41, y = -332.53, z = 13.45, name = "Davis LTD", robbed = false},
    -- Paleto Blvd Pharmacy
    {x = -172.46, y = 6386.81, z = 31.49, name = "Paleto Pharmacy", robbed = false},
    -- Best Buds
    {x = 380.24, y = -827.33, z = 29.29, name = "Best Buds", robbed = false},
    {x = 375.55, y = -827.33, z = 29.29, name = "Best Buds", robbed = false},
    -- ALHAMBRA DRIVE LTD
    {x = 2000.71, y = 3786.38, z = 32.30, name = "Sandy Shores LTD", robbed = false},
    {x = 2001.73, y = 3784.62, z = 32.30, name = "Sandy Shores LTD", robbed = false},
    -- CARSON LAUNDROMAT
    {x = 222.60, y = -1846.14, z = 27.07, name = "Laundromat", robbed = false},
    -- STRAWBERRY AVE PAWN SHOP
    {x = 173.59, y = -1317.66, z = 29.45, name = "Stawberry Ave Pawn Shop", robbed = false},
}

-- LIST OF SAFES ROBBABLE
storeSafes = {
    -- **************************
    --      Pad Lock Safes
    -- **************************

    -- PROSPERITY ST LIQUOR STORE
    {pos = vector3(-1478.94, -375.5, 39.16), type = "padlock", name = "Prosperity St. Liquor Store", robbed = false},
    -- SAN ANDREAS AVE LIQUOR STORE
    {pos = vector3(-1220.85, -916.05, 11.32), type = "padlock", name = "San Andreas Ave Liquor Store", robbed = false},
    -- EL RANCHO BLVD LIQUOR STORE
    {pos = vector3(1126.77, -980.1, 45.41), type = "padlock", name = "El Rancho Blvd Liquor Store", robbed = false},
    -- BANHAM CANYON LIQUOR STORE
    {pos = vector3(-2959.64, 387.08, 14.04), type = "padlock", name = "Banham Canyon Liquor Store", robbed = false},
    -- ROUTE 68 LIQUOR STORE
    {pos = vector3(1169.31, 2717.79, 37.15), type = "padlock", name = "Route 68 Liquor Store", robbed = false},
    -- GRAPESEED MAIN ST LIQUOR STORE
    {pos = vector3(1694.2, 4863.55, 41.07), type = "padlock", name = "Grapeseed Main St. Liquor Store", robbed = false},
    -- PALETO BAY LIQUOR STORE
    {pos = vector3(-168.27, 6318.52, 30.59), type = "padlock", name = "Paleto Bay Liquor Store", robbed = false},
    -- CARSON LAUNDROMAT
    {pos = vector3(215.59, -1854.46, 26.61), type = "padlock", name = "Laundromat", robbed = false},
    -- STRAWBERRY AVE PAWN SHOP
    {pos = vector3(167.46, -1318.87, 29.09), type = "padlock", name = "Pawn Shop", robbed = false},

    -- **************************
    --      Keypad Safes
    -- **************************
    -- DAVIS LTD
    {pos = vector3(-43.43, -1748.3, 29.42), type = "keypad", name = "Davis LTD", robbed = false},
    -- LINDSAY CIRCUS LTD
    {pos = vector3(-709.74, -904.15, 19.21), type = "keypad", name = "Lindsay Circus LTD", robbed = false},
    -- INNOCENCE BLVD 24/7
    {pos = vector3(28.21, -1339.14, 29.49), type = "keypad", name = "Innocence Blvd 24/7", robbed = false},
    -- MIRROR PARK 24/7
    {pos = vector3(1159.46, -314.05, 69.2), type = "keypad", name = "Mirror Park 24/7", robbed = false},
    -- CLINTON AVE 24/7
    {pos = vector3(378.17, 333.44, 103.56), type = "keypad", name = "Clinton Ave 24/7", robbed = false},
    -- NORTH ROCKFORD DRIVE LTD
    {pos = vector3(-1829.27, 798.76, 138.19), type = "keypad", name = "North Rockford Drive 24/7", robbed = false},
    -- INSENO ROAD 24/7
    {pos = vector3(-3047.88, 585.61, 7.9), type = "keypad", name = "Inseno Road 24/7", robbed = false},
    -- BARBARENO ROAD 24/7
    {pos = vector3(-3250.02, 1004.43, 12.83), type = "keypad", name = "Barbareno Road 24/7", robbed = false},
    -- HARMONY 24/7
    {pos = vector3(546.41, 2662.8, 42.15), type = "keypad", name = "Harmony 24/7", robbed = false},
    -- SENORA FWY 24/7
    {pos = vector3(2672.69, 3286.63, 55.24), type = "keypad", name = "Senora Fwy 24/7", robbed = false},
    -- ALHAMBRA DRIVE 24/7
    {pos = vector3(1959.26, 3748.92, 32.34), type = "keypad", name = "Alhambra Drive 24/7", robbed = false},
    -- BRADDOCK PASS 24/7
    {pos = vector3(1734.78, 6420.84, 35.03), type = "keypad", name = "Braddock Pass 24/7", robbed = false},
    -- GRAPESEED MAIN ST. LTD
    {pos = vector3(1707.68, 4920.32, 42.06), type = "keypad", name = "Grapeseed Main St. LTD", robbed = false},
    -- PALOMINO FWY 24/7
    {pos = vector3(2549.29, 384.92, 108.62), type = "keypad", name = "Palomino Fwy 24/7", robbed = false},
    -- PALETO BAY 24/7
    {pos = vector3(168.75, 6644.79, 31.61), type = "keypad", name = "Paleto Bay 24/7", robbed = false},
    -- NORTH ROCKFORD DRIVE 24/7
    {pos = vector3(-1417.01, -261.67, 46.38), type = "keypad", name = "North Rockford Drive 24/7", robbed = false},
    -- LAGO ZANCUDO 24/7
    {pos = vector3(-2542.45, 2305.5, 33.41), type = "keypad", name = "Lago Zancudo 24/7", robbed = false},
    -- DAVIS AVE 24/7
    {pos = vector3(159.76, -1542.50, 29.25), type = "keypad", name = "Davis Avenue 24/7", robbed = false},
    -- WEST ECLIPSE BLVD PACIFIC BLUFFS LTD
    {pos = vector3(-2060.68, -330.96, 13.32), type = "keypad", name = "West Eclipse Boulevard LTD", robbed = false},
    -- SANDY SHORES LTD
    {pos = vector3(1993.45, 3793.19, 32.18), type = "keypad", name = "Sandy Shores LTD", robbed = false},
}

-- **************************
--      Truck Robberies
-- **************************

armoredTrucks = {
    [1] = {x = -1327.47, y = -86.04, z = 49.31, beingRobbed = false},
    [2] = {x = -2075.88, y = -233.73, z = 21.10, beingRobbed = false},
    [3] = {x = -972.17, y = -1530.90, z = 4.89, beingRobbed = false},
    [4] = {x = 798.18, y = -1799.81, z = 29.22, beingRobbed = false},
    [5] = {x = 1247.07, y = -344.65, z = 69.08, beingRobbed = false}
}

-- **************************
--    Warehouse Robberies
-- **************************

warehouses = {
    -- ORCHARDVILLE WAREHOUSE
    [1] = {name = "Orchardville Warehouse", pos = vector3(969.53, -1727.52, 31.26), raided = false},
    -- POPULAR ST WAREHOUSE
    [2] = {name = "Popular St Warehouse", pos = vector3(926.78, -1560.14, 30.74), raided = false},
    -- LITTLE BIGHORN AVE WAREHOUSE
    [3] = {name = "Little Bighorn Ave Warehouse", pos = vector3(495.73, -1340.7, 29.31), raided = false},
    -- ALTA STREET WAREHOUSE
    [4] = {name = "Alta St Warehouse", pos = vector3(-428.84, -1728.15, 19.78), raided = false}
}

warehouseLoot = {
    {hash = "WEAPON_PISTOL", name = "Pistol", quantity = 1},
    {hash = "WEAPON_COMBATPISTOL", name = "Combat Pistol", quantity = 1},
    {hash = "emptybottle", name = "Empty Bottle", quantity = math.random(3, 5)},
    {hash = "collectionvial", name = "Collection Vials", quantity = math.random(3, 5)},
    {hash = "lightarmor", name = "Light Body Armor", quantity = 1},
    {hash = "drill", name = "Drill", quantity = 1},
    {hash = "shoe", name = "Shoes", quantity = math.random(3, 5)},
    {hash = "panties2", name = "Panties", quantity = math.random(3, 5)},
    {hash = "nintendoswitch", name = "Nintendo Switches", quantity = math.random(3, 5)},
    {hash = "headphones", name = "Beats Headphones", quantity = math.random(3, 5)},
    {hash = "earbuds", name = "Earbuds", quantity = math.random(3, 5)},
    {hash = "laptop", name = "Laptop", quantity = math.random(1, 3)},
    {hash = "violin", name = "Violin", quantity = math.random(1, 2)},
    {hash = "camera", name = "Camera", quantity = 1},
    {hash = "cash", name = "Cash", quantity = math.random(250, 650)},
    {hash = "breathalyzer", name = "Breathalyzer", quantity = math.random(1, 2)},
    {hash = "painkillers", name = "Painkillers", quantity = math.random(1, 3)},
    {hash = "WEAPON_DAGGER", name = "Antique Cavalry Dagger", quantity = 1},
    {hash = "WEAPON_GOLFCLUB", name = "Golf Club", quantity = 1},
    {hash = "WEAPON_FIREEXTINGUISHER", name = "Fire Extinguisher", quantity = 1},
    {hash = "WEAPON_REVOLVER", name = "Heavy Revolver", quantity = 1},
    {hash = "WEAPON_FLAREGUN", name = "Flare Gun", quantity = 1},
    {hash = "radio", name = "Radio", quantity = 1},
    {hash = "gps", name = "GPS", quantity = 1},
    {hash = "binos", name = "Binoculars", quantity = 1},
    {hash = "lockpick", name = "Lockpick", quantity = math.random(1, 3)},
    {hash = "tablet", name = "Samsung Tablets", quantity = math.random(2, 3)},
    {hash = "cannonball", name = "Cannon Ball", quantity = 1},
    {hash = "bankvaultkey", name = "Bank Vault Panel Key", quantity = 1}
}

warehouseCrates = {
    [1] = {pos = vector3(1053.04, -3095.89, -39.0), hdg = 179.53},
    [2] = {pos = vector3(1055.49, -3095.95, -39.0), hdg = 179.53},
    [3] = {pos = vector3(1058.01, -3096.11, -39.0), hdg = 179.53},
    [4] = {pos = vector3(1060.35, -3096.07, -39.0), hdg = 179.53},
    [5] = {pos = vector3(1062.91, -3096.17, -39.0), hdg = 179.53},
    [6] = {pos = vector3(1065.32, -3096.11, -39.0), hdg = 179.53},
    [7] = {pos = vector3(1067.57, -3096.25, -39.0), hdg = 179.53},
    [8] = {pos = vector3(1067.7, -3101.65, -39.0), hdg = 1.88},
    [9] = {pos = vector3(1065.1, -3101.83, -39.0), hdg = 1.88},
    [10] = {pos = vector3(1065.1, -3101.83, -39.0), hdg = 1.88},
    [11] = {pos = vector3(1062.58, -3101.87, -39.0), hdg = 1.88},
    [12] = {pos = vector3(1060.31, -3101.88, -39.0), hdg = 1.88},
    [13] = {pos = vector3(1057.83, -3102.02, -39.0), hdg = 1.88},
    [14] = {pos = vector3(1055.49, -3102.0, -39.0), hdg = 1.88},
    [15] = {pos = vector3(1053.09, -3101.88, -39.0), hdg = 1.88},
    [16] = {pos = vector3(1067.58, -3103.71, -39.0), hdg = 182.23},
    [17] = {pos = vector3(1065.15, -3103.61, -39.0), hdg = 182.23},
    [18] = {pos = vector3(1062.74, -3103.47, -39.0), hdg = 182.23},
    [19] = {pos = vector3(1060.3, -3103.48, -39.0), hdg = 182.23},
    [20] = {pos = vector3(1057.84, -3103.47, -39.0), hdg = 182.23},
    [21] = {pos = vector3(1055.43, -3103.38, -39.0), hdg = 182.23},
    [22] = {pos = vector3(1053.05, -3103.53, -39.0), hdg = 182.23},
    [23] = {pos = vector3(1053.15, -3109.15, -39.0), hdg = 2.39},
    [24] = {pos = vector3(1055.49, -3109.19, -39.0), hdg = 2.39},
    [25] = {pos = vector3(1057.97, -3109.16, -39.0), hdg = 2.39},
    [26] = {pos = vector3(1060.35, -3109.15, -39.0), hdg = 2.39},
    [27] = {pos = vector3(1062.79, -3109.08, -39.0), hdg = 2.39},
    [28] = {pos = vector3(1065.21, -3109.26, -39.0), hdg = 2.39},
    [29] = {pos = vector3(1067.54, -3109.08, -39.0), hdg = 2.39}
}

-- **************************
--      House Robberies
-- **************************

-- MOVED TO "sh_houses.lua" DUE TO LARGE TABLE
