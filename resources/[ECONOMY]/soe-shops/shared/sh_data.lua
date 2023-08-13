-- **************************
--      Buy Limit
-- **************************
boxBuyLimit = 30
crateBuyLimit = 20
quantityPurchasedByBusinesss = {}

-- **************************
--      Dealerships
-- **************************
dealershipsdiscountPerc = 0.35
maxDiscountPrice = 10000

-- **************************
--      Stores
-- **************************
storesDiscountPerc = 0.40

-- **************************
--      Buy/Sell Stores
-- **************************

-- TABLE OF STORES ACCESSIBLE AND CAN BE BOUGHT/SOLD ITEMS FROM
stores = {
    -- PALETO BAY 24/7
    {pos = vector4(160.45, 6641.81, 31.61, 224.52), name = "24/7", method = "buyFrom", type = "convenience"},
    -- PALETO BAY LIQUOR STORE
    {pos = vector4(-161.23, 6321.35, 31.59, 317.44), name = "Rob's Liquor", method = "buyFrom", type = "liquor"},
    -- PALETO BAY AMMU-NATION
    {pos = vector4(-330.66, 6085.94, 31.45, 221.45), name = "Ammu-Nation", method = "buyFrom", type = "guns", multistore = true},
    -- BRADDOCK PASS 24/7
    {pos = vector4(1727.85, 6415.49, 35.04, 247.52), name = "24/7", method = "buyFrom", type = "convenience"},
    -- GRAPESEED MAIN ST. LTD
    {pos = vector4(1697.63, 4923.26, 42.06, 328.07), name = "LTD", method = "buyFrom", type = "convenience"},
    -- GRAPESEED MAIN ST. LIQUOR STORE
    {pos = vector4(1686.83, 4866.04, 42.07, 100.29), name = "Rob's Liquor", method = "buyFrom", type = "liquor"},
    -- ALHAMBRA DRIVE 24/7
    {pos = vector4(1959.72, 3740.43, 32.34, 300.08), name = "24/7", method = "buyFrom", type = "convenience"},
    -- SANDY SHORES AMMU-NATION
    {pos = vector4(1693.08, 3762.08, 34.71, 226.05), name = "Ammu-Nation", method = "buyFrom", type = "guns", multistore = true},
    -- SENORA FWY 24/7
    {pos = vector4(2677.47, 3279.56, 55.24, 331.29), name = "24/7", method = "buyFrom", type = "convenience"},
    -- SENORA FWY U-TOOL
    {pos = vector4(2748.47, 3472.52, 55.68, 248.31), name = "U-Tool", method = "buyFrom", type = "hardware"},
    -- ROUTE 68 LIQUOR STORE
    {pos = vector4(1165.19, 2710.83, 38.16, 183.63), name = "Rob's Liquor", method = "buyFrom", type = "liquor"},
    -- HARMONY 24/7
    {pos = vector4(549.37, 2670.61, 42.16, 102.14), name = "24/7", method = "buyFrom", type = "convenience"},
    -- LAGO ZANCUDO 24/7
    {pos = vector4(-2539.14, 2313.4, 33.41, 94.63), name = "24/7", method = "buyFrom", type = "convenience"},
    -- NORTH ROCKFORD DRIVE 24/7
    {pos = vector4(-1819.53, 793.84, 138.08, 132.01), name = "24/7", method = "buyFrom", type = "convenience"},
    -- LAGO ZANCUDO AMMU-NATION
    {pos = vector4(-1118.07, 2700.68, 18.55, 222.83), name = "Ammu-Nation", method = "buyFrom", type = "guns"},
    -- CHUMASH AMMU-NATION
    {pos = vector4(-3173.22, 1089.64, 20.84, 240.46), name = "Ammu-Nation", method = "buyFrom", type = "guns"},
    -- CHUMASH 24/7
    {pos = vector4(-3242.86, 999.87, 12.83, 354.44), name = "24/7", method = "buyFrom", type = "convenience"},
    -- BANHAM CANYON 24/7
    {pos = vector4(-3039.56, 584.32, 7.91, 18.41), name = "24/7", method = "buyFrom", type = "convenience"},
    -- BANHAM CANYON LIQUOR STORE
    {pos = vector4(-2966.13, 391.29, 15.04, 94.93), name = "Rob's Liquor", method = "buyFrom", type = "liquor"},
    -- PROSPERITY STREET LIQUOR STORE
    {pos = vector4(-1486.49, -377.51, 40.16, 139.48), name = "Rob's Liquor", method = "buyFrom", type = "liquor"},
    -- ROCKFORD HILLS LTD
    {pos = vector4(-1422.13, -271.08, 46.28, 42.98), name = "LTD", method = "buyFrom", type = "convenience"},
    -- ROCKFORD HILLS AMMU-NATION
    {pos = vector4(-1304.28, -395.96, 36.7, 75.84), name = "Ammu-Nation", method = "buyFrom", type = "guns", multistore = true},
    -- SAN ANDREAS AVE LIQUOR STORE
    {pos = vector4(-1221.57, -908.15, 12.33, 35.72), name = "Rob's Liquor", method = "buyFrom", type = "liquor"},
    -- LITTLE SEOUL LTD
    {pos = vector4(-705.93, -914.21, 19.22, 90.83), name = "LTD", method = "buyFrom", type = "convenience"},
    -- LITTLE SEOUL AMMU-NATION
    {pos = vector4(-661.05, -933.42, 21.83, 176.44), name = "Ammu-Nation", method = "buyFrom", type = "guns"},
    -- ADAM'S APPLE BLVD AMMU-NATION
    {pos = vector4(23.91, -1105.8, 29.8, 159.36), name = "Ammu-Nation", method = "buyFrom", type = "guns", multistore = true, ownedBy = "mrblacksammunation"},
    -- INNOCENCE BLVD 24/7
    {pos = vector4(24.37, -1346.64, 29.5, 271.36), name = "24/7", method = "buyFrom", type = "convenience"},
    -- GROVE STREET LTD
    {pos = vector4(-47.1, -1758.45, 29.42, 53.48), name = "LTD", method = "buyFrom", type = "convenience"},
    -- SPANISH AVE AMMU-NATION
    {pos = vector4(253.39, -51.81, 69.94, 65.78), name = "Ammu-Nation", method = "buyFrom", type = "guns"},
    -- LA MESA AMMU-NATION
    {pos = vector4(841.07, -1035.4, 28.19, 354.45), name = "Ammu-Nation", method = "buyFrom", type = "guns"},
    -- POPULAR ST AMMU-NATION
    {pos = vector4(808.87, -2159.24, 29.62, 359.7), name = "Ammu-Nation", method = "buyFrom", type = "guns", multistore = true},
    -- VESPUCCI BLVD LIQUOR STORE
    {pos = vector4(1134.14, -982.89, 46.42, 281.53), name = "Rob's Liquor", method = "buyFrom", type = "liquor"},
    -- MIRROR PARK LTD
    {pos = vector4(1164.98, -323.33, 69.21, 102.78), name = "LTD", method = "buyFrom", type = "convenience"},
    -- PALOMINO FWY 24/7
    {pos = vector4(2556.67, 380.66, 108.62, 2.17), name = "24/7", method = "buyFrom", type = "convenience"},
    -- PALOMINO FWY AMMU-NATION
    {pos = vector4(2566.63, 292.48, 108.73, 356.68), name = "Ammu-Nation", method = "buyFrom", type = "guns"},
    -- DAVIS MEGA MALL
    {pos = vector4(55.07, -1739.2, 29.59, 52.1), name = "Davis Mega Mall", method = "buyFrom", type = "hardware"},
    -- PALETO BAY BAY HARDWARE
    {pos = vector4(-11.07, 6499.52, 31.5, 47.14), name = "Bay Hardware", method = "buyFrom", type = "hardware"},
    -- CHUMASH HARDWARE
    {pos = vector4(-3153.83, 1053.78, 20.86, 339.32), name = "Hardware", method = "buyFrom", type = "hardware"},
    -- MISSION ROW PD - ARMORY
    {pos = vector4(480.68, -996.84, 30.69, 92.11), name = "Armory", method = "buyFrom", type = "leo_armory", policeOnly = true},
    -- ROCKFORD HILLS PD - ARMORY
    {pos = vector4(-579.37, -112.55, 33.89, 297.01), name = "Armory", method = "buyFrom", type = "leo_armory", policeOnly = true},
    -- SANDY SO - ARMORY
    {pos = vector4(1859.90, 3690.22, 34.27, 53.32), name = "Armory", method = "buyFrom", type = "leo_armory", policeOnly = true},
    -- BEAVER BUSH RANGER STATION - ARMORY
    {pos = vector4(386.32, 799.53, 187.68, 181.53), name = "Armory", method = "buyFrom", type = "leo_armory", policeOnly = true},
    -- PALETO SO - ARMORY
    {pos = vector4(-436.54, 5989.35, 31.72, 49.44), name = "Armory", method = "buyFrom", type = "leo_armory", policeOnly = true},
    -- PILLBOX HOSPITAL - EMS ARMORY
    {pos = vector4(306.75, -601.78, 43.28, 342.64), name = "Armory", method = "buyFrom", type = "ems_armory", emsOnly = true},
    -- SANDY SO MEDICAL - EMS ARMORY
    {pos = vector4(1825.89, 3674.0, 34.27, 349.79), name = "Armory", method = "buyFrom", type = "ems_armory", emsOnly = true},
    -- CARSON AVE LOCKSMITH
    {pos = vector4(170.04, -1799.56, 29.32, 320.92), name = "Locksmith", method = "buyFrom", type = "locksmith"},
    -- LITTLE SEOUL DIGITAL DEN
    {pos = vector4(-657.7, -858.88, 24.49, 4.17), name = "Digital Den", method = "buyFrom", type = "electronic"},
    -- MIRROR PARK DIGITAL DEN
    {pos = vector4(1132.84, -474.5, 66.72, 348.34), name = "Digital Den", method = "buyFrom", type = "electronic"},
    -- CLINTON AVE 24/7
    {pos = vector4(372.54, 326.53, 103.57, 255.11), name = "24/7", method = "buyFrom", type = "convenience"},
    -- SANDY SHORES ELECTRONIC STORE
    {pos = vector4(1703.75, 3778.85, 34.75, 217.85), name = "Electronics", method = "buyFrom", type = "electronic"},
    -- POWER STREET DIGITAL DEN
    {pos = vector4(-41.45, -1036.73, 28.49, 66.89), name = "Digital Den", method = "buyFrom", type = "electronic"},
    -- SINNER STREET DIGITAL DEN
    {pos = vector4(392.93, -831.96, 29.29, 226.49), name = "Digital Den", method = "buyFrom", type = "electronic"},
    -- ECLIPSE BLVD DIGITAL DEN
    {pos = vector4(-509.47, 278.63, 83.32, 175.29), name = "Digital Den", method = "buyFrom", type = "electronic"},
    -- PALETO BLVD ELECTRONIC STORE
    {pos = vector4(-276.05, 6239.24, 31.49, 45.67), name = "Electronics", method = "buyFrom", type = "electronic"},
    -- CARSON AVE PHARMACY
    {pos = vector4(214.01, -1835.06, 27.54, 322.52), name = "Family Pharmacy", method = "buyFrom", type = "pharmacy"},
    -- MIRROR PARK PHARMACY
    {pos = vector4(1142.69, -452.07, 66.98, 256.77), name = "Betta Life", method = "buyFrom", type = "pharmacy"},
    -- HARMONY PLAZA PHARMACY
    {pos = vector4(591.14, 2744.6, 42.04, 183.71), name = "Dollar Pills", method = "buyFrom", type = "pharmacy"},
    -- ALTA ST PHARMACY
    {pos = vector4(98.39, -225.62, 54.64, 341.36), name = "Dollar Pills", method = "buyFrom", type = "pharmacy"},
    -- VINEWOOD 24/7
    {pos = vector4(152.28, 236.9, 106.83, 157.46), name = "24/7", method = "buyFrom", type = "grocery"},
    -- STRAWBERRY PAWN SHOP
    {pos = vector4(172.60, -1317.86, 29.33, 243.78), name = "Pawn Shop", method = "sellTo", type = "pawn_shop"},
    -- ADAM'S APPLE BLVD AMMU-NATION WEAPON SHOP
    {pos = vector4(23.91, -1105.8, 29.8, 159.36), name = "Ammu-Nation Buyback", method = "sellTo", type = "ammu-nation", multistore = true},
    -- CLINTON AVE PAWN SHOP
    {pos = vector4(412.2, 315.06, 103.13, 204.47), name = "F.T. Pawn", method = "sellTo", type = "pawn_shop"},
    -- BOULEVARD DEL PERRO PAWN SHOP
    {pos = vector4(-1459.37, -413.92, 35.73, 164.89), name = "Vinewood Pawn", method = "sellTo", type = "pawn_shop"},
    -- PALETO BLVD PAWN SHOP
    {pos = vector4(-326.16, 6228.54, 31.5, 225.16), name = "Paleto Pawn", method = "sellTo", type = "pawn_shop"},
    -- HARMONY PAWN SHOP
    {pos = vector4(556.33, 2674.59, 42.17, 10.64), name = "Harmony Pawn", method = "sellTo", type = "pawn_shop"},
    -- PALETO ELECTRONICS PAWN SHOP
    {pos = vector4(-30.81, 6480.71, 31.5, 47.49), name = "Ray's Electronics", method = "sellTo", type = "electronic"},
    -- STRAWBERRY ELECTRONICS PAWN SHOP
    {pos = vector4(66.03, -1467.73, 29.29, 231.14), name = "Leroy's Electronics", method = "sellTo", type = "electronic"},
    -- PLAICE PLACE MINING SHOP
    {pos = vector4(48.82, -2677.52, 6.01, 272.64), name = "Ore Shop", method = "sellTo", type = "mining"},
    -- BOULEVARD DEL PERRO FENCE
    {pos = vector4(-1201.88, -247.23, 37.95, 334.12), name = "Fence", method = "sellTo", type = "fence"},
    -- EL BURRO BLVD FENCE (RAIDED BY THE LSPD ON THE 10TH OF JUNE 2021)
    --{pos = vector4(1259.1, -2558.27, 42.72, 229.67), name = "Fence", method = "sellTo", type = "fence"},
    -- CHUPACABRA BOAT FENCE
    {pos = vector4(-221.39, -2374.15, 21.33, 122.14), name = "Fence", method = "sellTo", type = "fence"},
    -- POPULAR STREET AMMU-NATION WEAPON SHOP
    {pos = vector4(808.87, -2159.24, 29.62, 359.7), name = "Ammu-Nation Buyback", method = "sellTo", type = "ammu-nation", multistore = true},
    -- ROCKFORD HILLS AMMU-NATION WEAPON SHOP
    {pos = vector4(-1304.28, -395.96, 36.7, 75.84), name = "Ammu-Nation Buyback", method = "sellTo", type = "ammu-nation", multistore = true},
    -- SANDY SHORES AMMU-NATION WEAPON SHOP
    {pos = vector4(1693.08, 3762.08, 34.71, 226.05), name = "Ammu-Nation Buyback", method = "sellTo", type = "ammu-nation", multistore = true },
    -- PALETO AMMU-NATION WEAPON SHOP
    {pos = vector4(-330.66, 6085.94, 31.45, 221.45), name = "Ammu-Nation Buyback", method = "sellTo", type = "ammu-nation", multistore = true},
    -- SAN ANDREAS AVE JEWELRY PAWN
    {pos = vector4(346.44, -874.8, 29.29, 1.84), name = "Jewelry Pawn", method = "sellTo", type = "jewelry"},
    -- PALETO FOREST SAWMILL
    {pos = vector4(-841.27, 5401.24, 34.62, 298.1), name = "Paleto Sawmill", method = "sellTo", type = "woodcutting"},
    -- PALETO FOREST LODGE
    {pos = vector4(-679.1, 5834.36, 17.33, 132.57), name = "Paleto Lodge", method = "sellTo", type = "lodge"},
    -- GRAPESEED FISHERY
    {pos = vector4(1321.24, 4314.6, 38.15, 78.22), name = "Calafia Fishery", method = "sellTo", type = "fishing", multistore = true},
    -- GREAT OCEAN HWY FISHERY
    {pos = vector4(-1592.98, 5202.93, 4.31, 292.8), name = "GOH Fishery", method = "sellTo", type = "fishing", multistore = true},
    -- CATFISH VIEW FISHERY
    {pos = vector4(3817.41, 4482.42, 5.99, 203.68), name = "Catfish Fishery", method = "sellTo", type = "fishing", multistore = true},
    -- BOLLINGBROKE PRISON - ARMORY
    {pos = vector4(1782.06, 2543.51, 45.8, 270.54), name = "Armory", method = "buyFrom", type = "leo_armory", policeOnly = true},
    -- BOLLINGBROKE PRISON - CAFETERIA
    {pos = vector4(1779.51, 2589.57, 45.8, 358.37), name = "Bollingbroke's Finest", method = "buyFrom", type = "prison", prison = true},
    -- VESPUCCI BEACH FISHERY
    {pos = vector4(-1479.52, -949.79, 10.20, 0.0), name = "Beachfront Market", method = "sellTo", type = "fishing", multistore = true},
    -- VESPUCCI BEACH FISHERY SUPPLIES
    {pos = vector4(-1479.52, -949.79, 10.20, 0.0), name = "Beachfront Market Supplies", method = "buyFrom", type = "fishing_supplies", multistore = true},
    -- GRAPESEED FISHERY SUPPLIES
    {pos = vector4(1321.24, 4314.6, 38.15, 78.22), name = "Calafia Fishery Supplies", method = "buyFrom", type = "fishing_supplies", multistore = true},
    -- GREAT OCEAN HWY FISHERY SUPPLIES
    {pos = vector4(-1592.98, 5202.93, 4.31, 292.8), name = "GOH Fishery Supplies", method = "buyFrom", type = "fishing_supplies", multistore = true},
    -- CATFISH VIEW FISHERY SUPPLIES
    {pos = vector4(3817.41, 4482.42, 5.99, 203.68), name = "Catfish Fishery Supplies", method = "buyFrom", type = "fishing_supplies", multistore = true},
    -- WEAZEL NEWS
    {pos = vector4(-594.66, -929.94, 23.87, 272.27), name = "Weazel News", method = "sellTo", type = "weazel_news"},
    -- HAWICK THRIFT STORE
    {pos = vector4(65.38, -137.53, 55.11, 207.34), name = "Thrift Store", method = "sellTo", type = "thrift_store"},
    -- PALETO THRIFT STORE
    {pos = vector4(-315.72, 6194.19, 31.55, 38.17), name = "Thrift Store", method = "sellTo", type = "thrift_store"},
    -- PALETO PHARMACY
    {pos = vector4(-171.31, 6386.82, 31.49, 133.23), name = "Paleto Pharmacy", method = "buyFrom", type = "pharmacy"},
    -- PALETO FRUIT BUYER
    {pos = vector4(416.2945, 6520.787, 27.71277, 261.83), name = "Paleto Farms", method = "sellTo", type = "fruit_store"},
    -- IMPORTS SELLER
    {pos = vector4(813.6528, -2982.501, 6.010254, 271.44), name = "Jetsam Terminal - Crates", method = "buyFrom", type = "imports_crates", multistore = true, perms = {"CANIMPORTCRATES"}},
    {pos = vector4(813.6528, -2982.501, 6.010254, 271.44), name = "Jetsam Terminal - Boxes", method = "buyFrom", type = "imports_boxes", multistore = true, perms = {"CANIMPORTBOXES"}},
    -- GRANDMA
    {pos = vector4(1961.064, 5184.791, 47.93262, 272.126), name = "Grandma", method = "buyFrom", type = "grandma"},
    -- ALTA SANITATION BUYER
    {pos = vector4(-322.15, -1546.05, 31.02, 340.56), name = "Sell Junk", method = "sellTo", type = "sanitation_store", multistore = true},
    -- CAT CLAW SANITATION BUYER
    {pos = vector4(2051.62, 3174.36, 45.17, 340.56), name = "Sell Junk", method = "sellTo", type = "sanitation_store", multistore = true},
    -- ALTA SANITATION
    {pos = vector4(-322.15, -1546.05, 31.02, 340.56), name = "Buy Junk", method = "buyFrom", type = "sanitation_buyStore", multistore = true},
    -- CAT CLAW SANITATION
    {pos = vector4(2051.62, 3174.36, 45.17, 340.56), name = "Buy Junk", method = "buyFrom", type = "sanitation_buyStore", multistore = true},
    -- ALTA SCRAPYARD
    {pos = vector4(-484.65, -1730.37, 19.54, 199.82), name = "Buy Scrap", method = "buyFrom", type = "scrapyard_buyStore", multistore = true},
    -- ALTA SCRAPYARD BUYER
    {pos = vector4(-484.65, -1730.37, 19.54, 199.82), name = "Sell Scrap", method = "sellTo", type = "scrapyard_store", multistore = true},
    -- DAVIS AVE 24/7
    {pos = vector4(168.53, -1548.71, 29.25, 314.1), name = "24/7", method = "buyFrom", type = "convenience"},
    -- STRAWBERRY AVE FURNITURE STORE
    {pos = vector4(339.0725, -776.9802, 29.26306, 70.86614), name = "Krapea", method = "buyFrom", type = "furniture"},
    -- CARSON AVE FURNITURE STORE
    {pos = vector4(209.644, -1831.596, 27.78027, 320.315), name = "Furniture", method = "buyFrom", type = "furniture"},
    -- PALETO BLVD FURNITURE STORE
    {pos = vector4(-39.59, 6471.5, 31.5, 48.3), name = "Furniture", method = "buyFrom", type = "furniture"},
    -- WEST ECLIPSE BLVD PACIFIC BLUFFS LTD
    {pos = vector4(-2071.21, -331.82, 13.32, 175.75), name = "LTD", method = "buyFrom", type = "convenience"},
    -- BLACK MARKET
    {pos = vector4(870.27, -2313.18, 30.57, 353.45), name = "Black Market", method = "buyFrom", type = "blackmarket"},
    -- SASP HQ - ARMORY
    {pos = vector4(1549.79, 838.96, 77.66, 155.91), name = "Armory", method = "buyFrom", type = "leo_armory", policeOnly = true},
    -- SANDY SHORES MEDICAL ARMORY
    {pos = vector4(1825.306, 3674.664, 34.26746, 303.3071), name = "Armory", method = "buyFrom", type = "ems_armory", emsOnly = true},
    -- PALETO BAY MEDICAL ARMORY
    {pos = vector4(-252.4483, 6309.521, 32.41394, 317.4803), name = "Armory", method = "buyFrom", type = "ems_armory", emsOnly = true},
    -- PALETO BAY FIRE STATION ARMORY
    {pos = vector4(-359.367, 6113.539, 31.43665, 229.6063), name = "Armory", method = "buyFrom", type = "ems_armory", emsOnly = true},
    -- MISSION ROW PD CRIME LAB
    {pos = vector4(481.3451, -993.5736, 30.67834, 355.26), name = "Crime Lab", method = "buyFrom", type = "crimelab_armory", crimelabOnly = true},
    -- SANDY SHORES LTD
    {pos = vector4(2000.018, 3785.80, 32.18, 300.47), name = "LTD", method = "buyFrom", type = "convenience"},
}

items = {
    -- *********************
    --    Standard Items
    -- *********************
    {name = "Bottle of Water", hash = "water", type = "liquids", buyFrom = {"convenience", "grocery", "prison"}},
    {name = "1.5L Bottle of Water", hash = "waterlarge", type = "liquids", buyFrom = {"convenience", "leo_armory", "ems_armory", "crimelab_armory"}},
    {name = "Sandwich", hash = "sandwich", type = "food", buyFrom = {"convenience", "prison", "crimelab_armory"}},
    {name = "Packet of Grape Juice", hash = "grape", type = "liquids", buyFrom = {"convenience", "grocery", "prison"}},
    {name = "Radio", hash = "radio", type = "hardware", buyFrom = {"hardware", "electronic", "leo_armory", "ems_armory", "fishing_supplies", "crimelab_armory"}},
    {name = "Binoculars", hash = "binos", type = "hardware", buyFrom = {"hardware", "leo_armory", "ems_armory", "fishing_supplies", "crimelab_armory"}},
    {name = "Phat Chips", hash = "phatchips", type = "food", buyFrom = {"convenience", "liquor"}},
    {name = "Beer", hash = "beer", type = "liquids", buyFrom = {"liquor"}},
    {name = "Combat Knife", hash = "WEAPON_KNIFE", type = "misc", buyFrom = {"guns"}},
    {name = "Antique Cavalry Dagger", hash = "WEAPON_DAGGER", type = "misc", buyFrom = {"guns"}},
    {name = "Bag of Gummy Bears", hash = "gummies", type = "food", buyFrom = {"convenience", "liquor"}},
    {name = "Hotdog", hash = "hotdog", type = "food", buyFrom = {"convenience"}},
    {name = "Donut", hash = "donut", type = "food", buyFrom = {"convenience", "leo_armory"}},
    {name = "Pickaxe", hash = "pickaxe", type = "hardware", buyFrom = {"hardware"}},
    {name = "Handcuffs", hash = "handcuffs", type = "hardware", buyFrom = {"hardware", "leo_armory"}},
    {name = "Breathalyzer", hash = "breathalyzer", type = "hardware", buyFrom = {"hardware", "pharmacy", "leo_armory", "ems_armory", "crimelab_armory"}},
    {name = "Tint Meter", hash = "tintmeter", type = "hardware", buyFrom = {"hardware", "leo_armory"}},
    {name = "Collection Vial", hash = "collectionvial", type = "hardware", buyFrom = {"pharmacy", "leo_armory", "ems_armory", "crimelab_armory"}},
    {name = "Lockpick", hash = "lockpick", type = "hardware", buyFrom = {"locksmith"}},
    {name = "Cuff Key", hash = "cuffkey", type = "hardware", buyFrom = {"locksmith", "hardware", "leo_armory"}},
    {name = "Hatchet", hash = "WEAPON_HATCHET", type = "weapon", buyFrom = {"hardware"}},
    {name = "Crowbar", hash = "WEAPON_CROWBAR", type = "weapon", buyFrom = {"hardware"}},
    {name = "Golf Club", hash = "WEAPON_GOLFCLUB", type = "weapon", buyFrom = {"hardware"}},
    {name = "Baseball Bat", hash = "WEAPON_BAT", type = "weapon", buyFrom = {"hardware"}},
    {name = "Hammer", hash = "WEAPON_HAMMER", type = "weapon", buyFrom = {"hardware"}},
    {name = "Battle Axe", hash = "WEAPON_BATTLEAXE", type = "weapon", buyFrom = {"hardware"}},
    {name = "Core Tablet", hash = "tablet", type = "misc", buyFrom = {"leo_armory", "ems_armory", "electronic"}},
    {name = "Floppy Disk", hash = "floppydisk", type = "misc", buyFrom = {"electronic"}},
    {name = "Digital Watch", hash = "digitalwatch", type = "misc", buyFrom = {"electronic"}},
    {name = "Calculator Watch", hash = "calculatorwatch", type = "misc", buyFrom = {"electronic"}},
    {name = "GPS", hash = "gps", type = "misc", buyFrom = {"electronic"}, "fishing_supplies"},
    {name = "Drill", hash = "drill", type = "hardware", buyFrom = {"hardware"}},
    {name = "Drill Bit", hash = "drillbit", type = "hardware", buyFrom = {"hardware"}},
    {name = "First Aid Kit", hash = "firstaidkit", type = "misc", buyFrom = {"convenience", "pharmacy", "hardware", "leo_armory", "ems_armory"}},
    {name = "Fire Extinguisher", hash = "WEAPON_FIREEXTINGUISHER", type = "hardware", buyFrom = {"hardware", "leo_armory", "ems_armory"}},
    {name = "Scratch-Off Ticket", hash = "scratchoff", type = "misc", buyFrom = {"convenience"}},
    {name = "Dice", hash = "dice", type = "misc", buyFrom = {"convenience"}},
    {name = "Deck of Cards", hash = "deckofcards", type = "misc", buyFrom = {"convenience"}},
    {name = "Rag", hash = "rag", type = "misc", buyFrom = {"convenience", "hardware", "leo_armory", "ems_armory", "crimelab_armory"}},
    {name = "Flashlight", hash = "WEAPON_FLASHLIGHT", type = "misc", buyFrom = {"leo_armory", "ems_armory", "hardware", "crimelab_armory"}},
    {name = "Repair Kit", hash = "repairkit", type = "hardware", buyFrom = {"leo_armory", "ems_armory", "hardware"}},
    {name = "Light Body Armor", hash = "lightarmor", type = "misc", buyFrom = {"leo_armory", "ems_armory", "guns"}},
    {name = "Painkillers", hash = "painkillers", type = "drug", buyFrom = {"pharmacy", "ems_armory"}},
    {name = "Morphine", hash = "morphine", type = "drug", buyFrom = {"ems_armory"}},
    {name = "Pack of 60mg Pseudophedrine Pills", hash = "60mgPseudophedrinePills", type = "drug", buyFrom = {"pharmacy"}},
    {name = "Bottle of 1L Hydrochloric Acid", hash = "1LHydrochloricAcidBottle", type = "drug", buyFrom = {"pharmacy"}},
    {name = "Kitty Litter", hash = "kittylitter", type = "hardware", buyFrom = {"leo_armory", "ems_armory", "hardware"}},
    {name = "Plasma Cutter", hash = "plasmacutter", type = "hardware", buyFrom = {"ems_armory", "hardware"}},
    {name = "Pliers", hash = "pliers", type = "hardware", buyFrom = {"hardware"}},
    {name = "Wire Stripper", hash = "wirestripper", type = "hardware", buyFrom = {"hardware"}},
    {name = "Electrical Tape", hash = "electricaltape", type = "hardware", buyFrom = {"hardware"}},
    {name = "Screwdriver", hash = "screwdriver", type = "hardware", buyFrom = {"hardware"}},
    {name = "Measuring Tape", hash = "measuringtape", type = "hardware", buyFrom = {"hardware"}},
    {name = "Bun", hash = "bun", type = "groceries", buyFrom = {"grocery"}},
    {name = "Beef Patty", hash = "beefpatty", type = "groceries", buyFrom = {"grocery"}},
    {name = "Lettuce", hash = "lettuce", type = "groceries", buyFrom = {"grocery"}},
    {name = "American Cheese Slice", hash = "americancheeseslice", type = "groceries", buyFrom = {"grocery"}},
    {name = "Cheddar Cheese Slice", hash = "cheddarcheeseslice", type = "groceries", buyFrom = {"grocery"}},
    {name = "Swiss Cheese Slice", hash = "swisscheeseslice", type = "groceries", buyFrom = {"grocery"}},
    {name = "Vegan Cheese Slice", hash = "vegancheeseslice", type = "groceries", buyFrom = {"grocery"}},
    {name = "Onion", hash = "onion", type = "groceries", buyFrom = {"grocery"}},
    {name = "Avocado", hash = "avocado", type = "groceries", buyFrom = {"grocery"}},
    {name = "Garlic", hash = "garlic", type = "groceries", buyFrom = {"grocery"}},
    {name = "Hot Dog Buns", hash = "hotdogbun", type = "groceries", buyFrom = {"grocery"}},
    {name = "Hot Dog Weiner", hash = "hotdogweiner", type = "groceries", buyFrom = {"grocery"}},
    {name = "Rice", hash = "rice", type = "groceries", buyFrom = {"grocery"}},
    {name = "Fishing Rod", hash = "fishingrod", type = "hardware", buyFrom = {"hardware", "fishing_supplies"}},
    {name = "Fishing Map", hash = "fishingmap", type = "misc", buyFrom = {"hardware", "convenience", "fishing_supplies"}},
    {name = "Lobworm", hash = "lobworm", type = "misc", buyFrom = {"hardware", "convenience", "grocery", "fishing_supplies"}},
    {name = "Makeup Kit", hash = "makeupkit", type = "misc", buyFrom = {"convenience"}},
    {name = "Beach Towel", hash = "beachtowel", type = "misc", buyFrom = {"hardware"}},
    {name = "Blue Tent", hash = "bluetent", type = "misc", buyFrom = {"hardware", "fishing_supplies"}},
    {name = "Mic Stand", hash = "micstand", type = "misc", buyFrom = {"hardware"}},
    {name = "Campfire", hash = "campfire", type = "misc", buyFrom = {"hardware", "fishing_supplies"}},
    {name = "Petrol Can", hash = "WEAPON_PETROLCAN", type = "weapon", buyFrom = {"hardware", "fishing_supplies", "leo_armory", "ems_armory", "crimelab_armory"}},
    {name = "Basketball", hash = "basketball", type = "misc", buyFrom = {"hardware"}},
    {name = "Soil Bag", hash = "soil_bag", type = "misc", buyFrom = {"hardware"}},
    {name = "Empty Pot", hash = "empty_pot", type = "misc", buyFrom = {"hardware"}},
    {name = "Weed Seeds", hash = "weed_seed", type = "misc", buyFrom = {"grandma"}},
    {name = "Pack of Cigarettes", hash = "cigarettepack", type = "misc", buyFrom = {"convenience"}},
    {name = "Bag of Lollipops", hash = "lollipopbag", type = "food", buyFrom = {"ems_armory"}},
    {name = "Bag", hash = "bag", type = "misc", buyFrom = {"convenience", "hardware", "grocery"}},
    {name = "Boombox", hash = "boombox", type = "misc", buyFrom = {"electronic"}},
    {name = "Jackstand", hash = "jackstand", type = "misc", buyFrom = {"hardware", "ems_armory"}},
    {name = "Camera", hash = "camera", type = "misc", buyFrom = {"electronic", "crimelab_armory"}},
    {name = "Champagne Glass", hash = "champagneglass", type = "misc", buyFrom = {"hardware", "convenience", "grocery"}},
    {name = "Shot Glass", hash = "shotglass", type = "misc", buyFrom = {"hardware", "convenience", "grocery"}},
    {name = "Gin", hash = "gin", type = "liquids", buyFrom = {"liquor"}},
    {name = "Rum", hash = "rum", type = "liquids", buyFrom = {"liquor"}},
    {name = "Vermouth", hash = "vermouth", type = "liquids", buyFrom = {"liquor"}},
    {name = "Vodka", hash = "vodka", type = "liquids", buyFrom = {"liquor"}},
    {name = "Wine (Red)", hash = "redwine", type = "liquids", buyFrom = {"liquor"}},
    {name = "Wine (White)", hash = "whitewine", type = "liquids", buyFrom = {"liquor"}},
    {name = "Scissors", hash = "scissors", type = "misc", buyFrom = {"hardware"}},
    {name = "Zip Ties", hash = "zipties", type = "misc", buyFrom = {"hardware"}},
    {name = "Parachute", hash = "GADGET_PARACHUTE", type = "misc", buyFrom = {"hardware"}},
    {name = "Metal Detector", hash = "metaldetector", type = "misc", buyFrom = {"hardware"}},
    {name = "Sledgehammer", hash = "WEAPON_SLEDGEHAMMER", type = "weapon", buyFrom = {"hardware"}},
    {name = "Unicorn", hash = "WEAPON_UNICORN", type = "weapon", buyFrom = {"hardware"}},

    -- *********************
    --        Guns
    -- *********************
    {name = "Taser Cartridge", hash = "ammo_taser", type = "misc", buyFrom = {"ems_armory", "leo_armory"}},
    {name = "Musket Powder", hash = "ammo_musket", type = "misc", buyFrom = {"guns"}},
    {name = "Revolver Ammo", hash = "ammo_revolver", type = "misc", buyFrom = {"guns"}},
    {name = "SMG Ammo", hash = "ammo_smg", type = "misc", buyFrom = {"guns"}},
    {name = "MP5 Ammo", hash = "ammo_mp5", type = "misc", buyFrom = {"guns", "leo_armory"}},
    {name = "Shotgun Ammo", hash = "ammo_shotgun", type = "misc", buyFrom = {"guns", "leo_armory"}},
    {name = "Rifle Ammo", hash = "ammo_rifle", type = "misc", buyFrom = {"guns", "leo_armory"}},
    {name = "Pistol Magazine", hash = "pistol_magazine", type = "misc", buyFrom = {"guns", "leo_armory"}},
    {name = "Sniper Ammo", hash = "ammo_sniper", type = "misc", buyFrom = {"guns", "leo_armory"}},
    {name = "Beanbag Ammo", hash = "ammo_beanbag", type = "misc", buyFrom = {"leo_armory"}},
    {name = "Flare Gun Ammo", hash = "ammo_flaregun", type = "misc", buyFrom = {"leo_armory", "ems_armory", "guns", "hardware", "fishing_supplies"}},
    {name = "Rifle Flashlight", hash = "rifle_flashlight", type = "misc", buyFrom = {"leo_armory"}},
    {name = "Pistol Flashlight", hash = "pistol_flashlight", type = "misc", buyFrom = {"guns", "leo_armory"}},
    {name = "Heavy Sniper", hash = "WEAPON_HEAVYSNIPER", type = "weapon", buyFrom = {"leo_armory"}},
    {name = "Carbine Rifle Mk II", hash = "WEAPON_CARBINERIFLE_MK2", type = "weapon", buyFrom = {"leo_armory"}},
    {name = "Taser", hash = "WEAPON_STUNGUN", type = "weapon", buyFrom = {"leo_armory", "ems_armory"}},
    {name = "Flare Gun", hash = "WEAPON_FLAREGUN", type = "weapon", buyFrom = {"leo_armory", "ems_armory", "guns", "hardware", "fishing_supplies"}},
    {name = "Carbine Rifle", hash = "WEAPON_CARBINERIFLE", type = "weapon", buyFrom = {"leo_armory"}},
    {name = "Pump Shotgun", hash = "WEAPON_PUMPSHOTGUN", type = "weapon", buyFrom = {"leo_armory"}},
    {name = "Beanbag Shotgun", hash = "WEAPON_PUMPSHOTGUN_MK2", type = "weapon", buyFrom = {"leo_armory"}},
    {name = "Combat Pistol", hash = "WEAPON_COMBATPISTOL", type = "weapon", buyFrom = {"guns", "leo_armory"}},
    {name = "Pistol", hash = "WEAPON_PISTOL", type = "weapon", buyFrom = {"guns"}},
    {name = "Pistol Mk II", hash = "WEAPON_PISTOL_MK2", type = "weapon", buyFrom = {"guns", "leo_armory"}},
    {name = "Vintage Pistol", hash = "WEAPON_VINTAGEPISTOL", type = "weapon", buyFrom = {"guns"}},
    {name = "Heavy Pistol", hash = "WEAPON_HEAVYPISTOL", type = "weapon", buyFrom = {"guns"}},
    {name = "Ceramic Pistol", hash = "WEAPON_CERAMICPISTOL", type = "weapon", buyFrom = {"guns"}},
    {name = "Musket", hash = "WEAPON_MUSKET", type = "weapon", buyFrom = {"guns"}},
    {name = "Double Action Revolver", hash = "WEAPON_DOUBLEACTION", type = "weapon", buyFrom = {"guns"}},
    {name = "Lidar Speed Gun", hash = "WEAPON_SNSPISTOL_MK2", type = "weapon", buyFrom = {"leo_armory"}},
    {name = "Heavy Revolver", hash = "WEAPON_REVOLVER", type = "weapon", buyFrom = {"guns"}},
    {name = "Holographic Sight", hash = "holographic_sight", type = "weapon", buyFrom = {"guns", "leo_armory"}},
    {name = "Gun Scope", hash = "gun_scope", type = "weapon", buyFrom = {"guns", "leo_armory"}},
    {name = "Rifle Grip", hash = "rifle_grip", type = "weapon", buyFrom = {"guns", "leo_armory"}},
    {name = "MP5", hash = "WEAPON_SMG", type = "weapon", buyFrom = {"leo_armory"}},

    -- *********************
    --     Armory Items
    -- *********************
    {name = "Body Armor", hash = "bodyarmor", type = "misc", buyFrom = {"leo_armory"}},
    {name = "Plate Carrier", hash = "platecarrier", type = "misc", buyFrom = {"leo_armory"}},
    {name = "Nightstick", hash = "WEAPON_NIGHTSTICK", type = "weapon", buyFrom = {"leo_armory"}},
    {name = "Tear Gas", hash = "WEAPON_SMOKEGRENADE", type = "weapon", buyFrom = {"leo_armory"}},
    {name = "Gunshot Residue Kit", hash = "gsrkit", type = "hardware", buyFrom = {"leo_armory", "crimelab_armory"}},
    {name = "Spike Strips", hash = "spikestrips", type = "hardware", buyFrom = {"leo_armory"}},
    {name = "Slimjim", hash = "slimjim", type = "hardware", buyFrom = {"leo_armory", "ems_armory"}},
    {name = "Police Barrier", hash = "policebarrier", type = "hardware", buyFrom = {"leo_armory"}},
    {name = "Traffic Cone", hash = "cone3", type = "hardware", buyFrom = {"leo_armory", "ems_armory", "crimelab_armory"}},
    {name = "Bodybag", hash = "bodybag", type = "hardware", buyFrom = {"leo_armory", "ems_armory"}},
    {name = "Medbag", hash = "medbag", type = "hardware", buyFrom = {"leo_armory", "ems_armory"}},
    {name = "Work Light", hash = "worklight", type = "hardware", buyFrom = {"leo_armory", "ems_armory", "crimelab_armory"}},
    {name = "Multitool", hash = "multitool", type = "hardware", buyFrom = {"leo_armory", "ems_armory"}},
    {name = "Engine Killswitch", hash = "enginekiller", type = "hardware", buyFrom = {"leo_armory"}},
    {name = "Blank Emergency Services Badge", hash = "emergencyservices_badge_blank", type = "misc", buyFrom = {"leo_armory", "ems_armory", "crimelab_armory"}},
    {name = "Fingerprint Kit", hash = "printkit", type = "hardware", buyFrom = {"leo_armory", "crimelab_armory"}},

    -- *********************
    --       Phones
    -- *********************
    {name = "Ocean Blue gPhone", hash = "cellphone", type = "misc", isPhone = true, phoneStyle = "blue", buyFrom = {"electronic"}},
    {name = "Crimson Red gPhone", hash = "cellphone", type = "misc", isPhone = true, phoneStyle = "red", buyFrom = {"electronic"}},
    {name = "Rose Pink gPhone", hash = "cellphone", type = "misc", isPhone = true, phoneStyle = "pink", buyFrom = {"electronic"}},
    {name = "Mint Green gPhone", hash = "cellphone", type = "misc", isPhone = true, phoneStyle = "green", buyFrom = {"electronic"}},
    {name = "Slate Gray gPhone", hash = "cellphone", type = "misc", isPhone = true, phoneStyle = "gray", buyFrom = {"electronic"}},
    {name = "Midnight Black gPhone", hash = "cellphone", type = "misc", isPhone = true, phoneStyle = "black", buyFrom = {"electronic"}},
    {name = "Ice White gPhone", hash = "cellphone", type = "misc", isPhone = true, phoneStyle = "white", buyFrom = {"electronic"}},

    -- *********************
    --       Containers
    -- *********************
    {name = "Laptops - Small", hash = "smallcrateoflaptops", type = "misc", buyFrom = {"imports_crates"}},
    {name = "Laptops - Large", hash = "largecrateoflaptops", type = "misc", buyFrom = {"imports_crates"}},
    {name = "Headphones - Small", hash = "smallcrateofheadphones", type = "misc", buyFrom = {"imports_crates"}},
    {name = "Headphones - Large", hash = "largecrateofheadphones", type = "misc", buyFrom = {"imports_crates"}},
    {name = "Tablets - Small", hash = "smallcrateoftablets", type = "misc", buyFrom = {"imports_crates"}},
    {name = "Tablets - Large", hash = "largecrateoftablets", type = "misc", buyFrom = {"imports_crates"}},
    {name = "Advanced Repair Kit - Small", hash = "smallcrateofadvancedrepairkit", type = "misc", buyFrom = {"imports_crates"}},
    {name = "Advanced Repair Kit - Large", hash = "largecrateofadvancedrepairkit", type = "misc", buyFrom = {"imports_crates"}},
    {name = "Scubagear MkII - Small", hash = "smallcrateofscubagearmkii", type = "misc", buyFrom = {"imports_crates"}},
    {name = "Scubagear MkII - Large", hash = "largecrateofscubagearmkii", type = "misc", buyFrom = {"imports_crates"}},
    {name = "SOTW Supplies - Small", hash = "smallboxofsotwsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "SOTW Supplies - Large", hash = "largeboxofsotwsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Haven Spa and Resort Supplies - Small", hash = "smallboxofhssupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Haven Spa and Resort Supplies - Large", hash = "largeboxofhssupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Bean Machine Supplies - Small", hash = "smallboxofbeanmachinesupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Bean Machine Supplies - Large", hash = "largeboxofbeanmachinesupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Last Train Supplies - Small", hash = "smallboxoflasttrainsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Last Train Supplies - Large", hash = "largeboxoflasttrainsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Bahama Mamams Supplies - Small", hash = "smallboxofbahamasupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Bahama Mamams Supplies - Large", hash = "largeboxofbahamasupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Vanilla Unicorn Supplies - Small", hash = "smallboxofvusupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Vanilla Unicorn Supplies - Large", hash = "largeboxofvusupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Burger Shot Supplies - Small", hash = "smallboxofbssupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Burger Shot Supplies - Large", hash = "largeboxofbssupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Lawson Lunchbox Supplies - Small", hash = "smallboxofllsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Lawson Lunchbox Supplies - Large", hash = "largeboxofllsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Diamond Casino Supplies - Small", hash = "smallboxofdcsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Diamond Casino Supplies - Large", hash = "largeboxofdcsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Brat's Keys Supplies - Small", hash = "smallboxofbksupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Brat's Keys Supplies - Large", hash = "largeboxofbksupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Galaxy Nightclub Supplies - Small", hash = "smallboxofgnsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Galaxy Nightclub Supplies - Large", hash = "largeboxofgnsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Solomon Distilleries Supplies - Small", hash = "smallboxofsdsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Solomon Distilleries Supplies - Large", hash = "largeboxofsdsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Celtic Shield Security Supplies - Small", hash = "smallboxofcssupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Celtic Shield Security Supplies - Large", hash = "largeboxofcssupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Four Leaf Vineyard Supplies - Small", hash = "smallboxofflsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Four Leaf Vineyard Supplies - Large", hash = "largeboxofflsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Luchetti's Supplies - Small", hash = "smallboxoflusupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Luchetti's Supplies - Large", hash = "largeboxoflusupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Sato's Noodle Exchange Supplies - Small", hash = "smallboxofsnsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Sato's Noodle Exchange Supplies - Large", hash = "largeboxofsnsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Lucky Leprechaun Supplies - Small", hash = "smallboxoflhsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Lucky Leprechaun Supplies - Large", hash = "largeboxoflhsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Rabbit Hole Supplies - Small", hash = "smallboxofrhsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Rabbit Hole Supplies - Large", hash = "largeboxofrhsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Yellow Jack Supplies - Small", hash = "smallboxofyjsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Yellow Jack Supplies - Large", hash = "largeboxofyjsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Cool Beans Supplies - Small", hash = "smallboxofcbsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Cool Beans Supplies - Large", hash = "largeboxofcbsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Hen House Supplies - Small", hash = "smallboxofhhsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Hen House Supplies - Large", hash = "largeboxofhhsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Bento Supplies - Small", hash = "smallboxofbtsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Bento Supplies - Large", hash = "largeboxofbtsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Best Buds Supplies - Small", hash = "smallboxofbbsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Best Buds Supplies - Large", hash = "largeboxofbbsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Sex On The Beach - Small", hash = "smallboxofsbsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Sex On The Beach - Large", hash = "largeboxofsbsupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Arcade-O'Rama - Small", hash = "smallboxofaosupplies", type = "misc", buyFrom = {"imports_boxes"}},
    {name = "Arcade-O'Rama - Large", hash = "largeboxofaosupplies", type = "misc", buyFrom = {"imports_boxes"}},

    -- *********************
    --       Junk/Scrap
    -- *********************
    {name = "Scrap Metal", hash = "scrapmetal", buyFrom = {"scrapyard_buyStore"}},
    {name = "Empty Bottle", hash = "emptybottle", buyFrom = {"sanitation_buyStore"}},

    -- *********************
    --       Black Market
    -- *********************
    {name = "Thermal Charge", hash = "thermalcharge", type = "misc", buyFrom = {"blackmarket"}},
}

sellableItems = {
    -- *********************
    --        Guns
    -- *********************
    {name = "Taser", hash = "WEAPON_STUNGUN", sellTo = {"fence"}},
    {name = "Pistol", hash = "WEAPON_PISTOL", sellTo = {"ammu-nation"}},
    {name = "Pistol Mk II", hash = "WEAPON_PISTOL_MK2", sellTo = {"ammu-nation"}},
    {name = "Combat Pistol", hash = "WEAPON_COMBATPISTOL", sellTo = {"ammu-nation"}},
    {name = "Musket", hash = "WEAPON_MUSKET", sellTo = {"ammu-nation"}},
    {name = "Flare Gun", hash = "WEAPON_FLAREGUN", sellTo = {"ammu-nation"}},
    {name = "Pump Shotgun", hash = "WEAPON_PUMPSHOTGUN", sellTo = {"fence"}},
    {name = "Heavy Sniper", hash = "WEAPON_HEAVYSNIPER", sellTo = {"fence"}},
    {name = "Carbine Rifle", hash = "WEAPON_CARBINERIFLE", sellTo = {"fence"}},
    {name = "Vintage Pistol", hash = "WEAPON_VINTAGEPISTOL", sellTo = {"ammu-nation"}},
    {name = "Carbine Rifle Mk II", hash = "WEAPON_CARBINERIFLE_MK2", sellTo = {"fence"}},
    {name = "Beanbag Shotgun", hash = "WEAPON_PUMPSHOTGUN_MK2", sellTo = {"fence"}},
    {name = "Double Action Revolver", hash = "WEAPON_DOUBLEACTION", sellTo = {"ammu-nation"}},
    {name = "Combat Knife", hash = "WEAPON_KNIFE", sellTo = {"ammu-nation"}},
    {name = "Heavy Revolver", hash = "WEAPON_REVOLVER", sellTo = {"ammu-nation"}},

    -- *********************
    --    Standard Items
    -- *********************
    {name = "Wood Logs", hash = "logs", sellTo = {"woodcutting"}},
    {name = "Wooden Planks", hash = "woodenplanks", sellTo = {"woodcutting"}},
    {name = "Broken Cellphone", hash = "brokencellphone", sellTo = {"pawn_shop", "electronic"}},
    {name = "Tablet", hash = "tablet", sellTo = {"electronic"}},
    {name = "Drill", hash = "drill", sellTo = {"pawn_shop"}},
    {name = "Radio", hash = "radio", sellTo = {"pawn_shop"}},
    {name = "Morphine", hash = "morphine", sellTo = {"fence"}},
    {name = "Binoculars", hash = "binos", sellTo = {"pawn_shop"}},
    {name = "Handcuffs", hash = "handcuffs", sellTo = {"pawn_shop"}},
    {name = "Tint Meter", hash = "tintmeter", sellTo = {"pawn_shop"}},
    {name = "Breathalyzer", hash = "breathalyzer", sellTo = {"pawn_shop"}},
    {name = "Body Armor", hash = "bodyarmor", sellTo = {"fence"}},
    {name = "Plate Carrier", hash = "platecarrier", sellTo = {"fence"}},
    {name = "Slimjim", hash = "slimjim", sellTo = {"fence"}},
    {name = "Nightstick", hash = "WEAPON_NIGHTSTICK", sellTo = {"fence"}},
    {name = "Golf Club", hash = "WEAPON_GOLFCLUB", sellTo = {"pawn_shop"}},
    {name = "Tear Gas", hash = "WEAPON_SMOKEGRENADE", sellTo = {"fence"}},
    {name = "Antique Cavalry Dagger", hash = "WEAPON_DAGGER", sellTo = {"pawn_shop", "ammu-nation"}},
    {name = "Violin", hash = "violin", sellTo = {"pawn_shop"}},
    {name = "Switchblade", hash = "WEAPON_SWITCHBLADE", sellTo = {"fence"}},
    {name = "Metal Detector", hash = "metaldetector", sellTo = {"pawn_shop"}},

    -- *******************
    --      Jewelry
    -- *******************
    {name = "Ruby", hash = "ruby", sellTo = {"jewelry"}},
    {name = "Sapphire", hash = "sapphire", sellTo = {"jewelry"}},
    {name = "Gold Nugget", hash = "goldnugget", sellTo = {"jewelry"}},
    {name = "Emerald", hash = "emerald", sellTo = {"jewelry"}},
    {name = "Diamond", hash = "diamond", sellTo = {"jewelry"}},
    {name = "Gold Rings", hash = "goldring", sellTo = {"pawn_shop"}},
    {name = "Necklace", hash = "necklace", sellTo = {"pawn_shop"}},
    {name = "Bracelet", hash = "bracelet", sellTo = {"pawn_shop"}},
    {name = "Gold Watch", hash = "goldwatch", sellTo = {"pawn_shop"}},
    {name = "Earrings", hash = "earrings", sellTo = {"pawn_shop"}},

    -- *******************
    --       Ores
    -- *******************
    {name = "Copper Ore", hash = "copperore", sellTo = {"mining"}},
    {name = "Silver Ore", hash = "silverore", sellTo = {"mining"}},
    {name = "Gold Ore", hash = "goldore", sellTo = {"mining"}},
    {name = "Rocks (x20)", hash = "rocks", quantity = 20, sellTo = {"mining"}},

    -- *********************
    --       Electronics
    -- *********************
    {name = "gPhone", hash = "cellphone", sellTo = {"electronic"}},
    {name = "Laptop", hash = "laptop", sellTo = {"electronic"}},
    {name = "USB Drive", hash = "usb", sellTo = {"electronic"}},
    {name = "Nintendo Switch", hash = "nintendoswitch", sellTo = {"electronic"}},
    {name = "Earbuds", hash = "earbuds", sellTo = {"electronic"}},
    {name = "Beats Headphones", hash = "headphones", sellTo = {"electronic"}},
    {name = "Floppy Disk", hash = "floppydisk", sellTo = {"electronic"}},
    {name = "Digital Watch", hash = "digitalwatch", sellTo = {"electronic"}},
    {name = "Calculator Watch", hash = "calculatorwatch", sellTo = {"electronic"}},
    {name = "Camera", hash = "camera", sellTo = {"electronic", "pawn_shop"}},
    {name = "Broken BTHeadphones (x5)", hash = "brokenheadphones", quantity = 5, sellTo = {"electronic"}},
    {name = "Broken Compact Digicam (x5)", hash = "brokencompactdigicam", quantity = 5, sellTo = {"electronic"}},
    {name = "Broken Compact Video Game (x5)", hash = "brokennintendoswitch", quantity = 5, sellTo = {"electronic"}},
    {name = "Broken Laptop (x5)", hash = "brokenlaptop", quantity = 5, sellTo = {"electronic"}},
    {name = "Broken mp3 (x5)", hash = "brokenmp3", quantity = 5, sellTo = {"electronic"}},
    {name = "Broken Tablet (x5)", hash = "brokentablet", quantity = 5, sellTo = {"electronic"}},

    -- *********************
    --       Fishes
    -- *********************
    {name = "Sunfish", hash = "sunfish", sellTo = {"fishing"}},
    {name = "Smallmouth Bass", hash = "bass", sellTo = {"fishing"}},
    {name = "Rainbow Trout", hash = "rainbowtrout", sellTo = {"fishing"}},
    {name = "Fresh Water Salmon", hash = "freshwatersalmon", sellTo = {"fishing"}},
    {name = "Channel Catfish", hash = "channelcatfish", sellTo = {"fishing"}},
    {name = "Red Drum", hash = "reddrum", sellTo = {"fishing"}},
    {name = "Tilapia", hash = "tilapia", sellTo = {"fishing"}},
    {name = "Corvina", hash = "corvina", sellTo = {"fishing"}},
    {name = "Large Mouth Bass", hash = "largemouthbass", sellTo = {"fishing"}},
    {name = "Carp", hash = "carp", sellTo = {"fishing"}},
    {name = "White Catfish", hash = "whitecatfish", sellTo = {"fishing"}},
    {name = "Sword Fish", hash = "swordfish", sellTo = {"fishing"}},
    {name = "Cod", hash = "cod", sellTo = {"fishing"}},
    {name = "Perch", hash = "perch", sellTo = {"fishing"}},
    {name = "Seabass", hash = "seabass", sellTo = {"fishing"}},
    {name = "Rockfish", hash = "rockfish", sellTo = {"fishing"}},
    {name = "Flounder", hash = "flounder", sellTo = {"fishing"}},
    {name = "Mackerel", hash = "mackerel", sellTo = {"fishing"}},
    {name = "Yellow Fin Tuna", hash = "yellowfintuna", sellTo = {"fishing"}},
    {name = "Halibut", hash = "halibut", sellTo = {"fishing"}},
    {name = "Turtle", hash = "turtle", sellTo = {"fence"}},
    {name = "Razorback Sucker", hash = "razorbacksucker", sellTo = {"fence"}},
    {name = "Fresh Water Eel", hash = "freshwatereel", sellTo = {"fence"}},
    {name = "River Sturgeon", hash = "riversturgeon", sellTo = {"fence"}},

    -- *********************
    --       Lodge
    -- *********************
    {name = "Boar Meat", hash = "boarmeat", sellTo = {"lodge"}},
    {name = "Boar Pelt", hash = "boarpelt", sellTo = {"lodge"}},
    {name = "Poor Boar Pelt", hash = "boarpeltpoor", sellTo = {"lodge"}},
    {name = "Perfect Boar Pelt", hash = "boarpeltperfect", sellTo = {"lodge"}},
    {name = "Deer Meat", hash = "deermeat", sellTo = {"lodge"}},
    {name = "Deer Pelt", hash = "deerpelt", sellTo = {"lodge"}},
    {name = "Poor Deer Pelt", hash = "deerpeltpoor", sellTo = {"lodge"}},
    {name = "Perfect Deer Pelt", hash = "deerpeltperfect", sellTo = {"lodge"}},
    {name = "Small Game Meat", hash = "smallgamemeat", sellTo = {"lodge"}},
    {name = "Small Game Pelt", hash = "smallgamepelt", sellTo = {"lodge"}},
    {name = "Poor Small Game Pelt", hash = "smallgamepeltpoor", sellTo = {"lodge"}},
    {name = "Perfect Small Game Pelt", hash = "smallgamepeltperfect", sellTo = {"lodge"}},
    {name = "Chicken Meat", hash = "birdmeat", sellTo = {"lodge"}},
    {name = "Bird Meat", hash = "chickenmeat", sellTo = {"lodge"}},
    {name = "Mountain Lion Meat", hash = "mountainlionmeat", sellTo = {"fence"}},
    {name = "Mountain Lion Pelt", hash = "mountainlionpelt", sellTo = {"fence"}},
    {name = "Poor Mountain Lion Pelt", hash = "mountainlionpeltpoor", sellTo = {"fence"}},
    {name = "Perfect Mountain Lion Pelt", hash = "mountainlionpeltperfect", sellTo = {"fence"}},

    -- *********************
    --       Weazel News
    -- *********************
    {name = "Picture", hash = "awkwardpics", sellTo = {"weazel_news"}},

    -- *********************
    --       Thrift Store
    -- *********************
    {name = "Broken Belt Buckle", hash = "brokenbeltbuckle", sellTo = {"thrift_store"}},
    {name = "Old Coat Button", hash = "oldcoatbutton", sellTo = {"thrift_store"}},
    {name = "Shoe", hash = "shoe", sellTo = {"thrift_store"}},
    {name = "Red Panties", hash = "panties1", sellTo = {"thrift_store"}},
    {name = "Blue Panties", hash = "panties2", sellTo = {"thrift_store"}},
    {name = "White Panties", hash = "panties3", sellTo = {"thrift_store"}},
    {name = "Designer Glasses", hash = "designersunglasses", sellTo = {"thrift_store"}},

    -- *********************
    --       Fruit Store
    -- *********************
    {name = "Orange", hash = "orange", sellTo = {"fruit_store"}},
    {name = "Tomato", hash = "tomato", sellTo = {"fruit_store"}},

    -- *********************
    --     Sanitation Store
    -- *********************
    {name = "Empty Bottle (x10)", hash = "emptybottle", quantity = 10, sellTo = {"sanitation_store"}},
    {name = "Empty Soda Can (x5)", hash = "emptysodacan", quantity = 5, sellTo = {"sanitation_store"}},
    {name = "Empty Can (x5)", hash = "emptycan", quantity = 5, sellTo = {"sanitation_store"}},
    {name = "Bottle Cap (x10)", hash = "bottlecap", quantity = 10, sellTo = {"sanitation_store"}},
    {name = "Dried up ballpoint pen (x10)", hash = "drypen", quantity = 10, sellTo = {"sanitation_store"}},

    -- *********************
    --       Scrapyard
    -- *********************
    {name = "Arrowhead (x5)", hash = "arrowhead", quantity = 5, sellTo = {"scrapyard_store"}},
    {name = "Bad Sparkplug (x10)", hash = "badsparkplug", quantity = 10, sellTo = {"scrapyard_store"}},
    {name = "CDs (x10)", hash = "cds", quantity = 10, sellTo = {"scrapyard_store"}},
    {name = "Broken Belt Buckle (x5)", hash = "brokenbeltbuckle", quantity = 5, sellTo = {"scrapyard_store"}},
    {name = "Dog Tag (x5)", hash = "dogtag", quantity = 5, sellTo = {"scrapyard_store"}},
    {name = "HDD (x5)", hash = "hdd", quantity = 5, sellTo = {"scrapyard_store"}},
    {name = "Old Fork (x10)", hash = "oldfork", quantity = 10, sellTo = {"scrapyard_store"}},
    {name = "Scrap Metal (x3)", hash = "scrapmetal", quantity = 3, sellTo = {"scrapyard_store"}},
    {name = "Musketball (x4)", hash = "musketball", quantity = 4, sellTo = {"scrapyard_store"}},
    {name = "Cannon Ball (x2)", hash = "cannonball", quantity = 2, sellTo = {"scrapyard_store"}},
    {name = "Old Knife (x1)", hash = "oldknife", quantity = 1, sellTo = {"scrapyard_store"}},
    {name = "Rusty Slimjim (x1)", hash = "rustyslimjim", quantity = 1, sellTo = {"scrapyard_store"}},
    {name = "Rusty Multitool (x1)", hash = "rustymultitool", quantity = 1, sellTo = {"scrapyard_store"}},
    {name = "Rusty Pocket Watch (x1)", hash = "rustypocketwatch", quantity = 1, sellTo = {"scrapyard_store"}},
}

-- **************************
--      Vending Machines
-- **************************
-- TABLE OF VENDING MACHINE TYPES THAT ARE USABLE
vendingMachines = {
    {hash = "weed_vending", item = "joint", name = "Weed", prop = "prop_weed_bottle", price = 55},
    {hash = "v_ret_247_donuts", item = "donut", name = "Donut", prop = "prop_donut_01", price = 2, bypassAnim = true},
    {hash = "prop_vend_soda_01", item = "ecola", name = "E-Cola", prop = "prop_ecola_can", price = 1},
    {hash = "prop_vend_soda_02", item = "sprunk", name = "Sprunk", prop = "prop_ld_can_01", price = 1},
    {hash = "prop_vend_coffe_01", item = "coffee", name = "Coffee", prop = "prop_fib_coffee", price = 5,bypassAnim = true},
    {hash = "prop_gumball_01", item = "gumball", name = "Gumball", prop = "prop_poolball_cue", price = 1, isGumball = true, bypassAnim = true},
    {hash = "prop_gumball_02", item = "gumball", name = "Gumball", prop = "prop_poolball_cue", price = 1, isGumball = true, bypassAnim = true},
    {hash = "prop_gumball_03", item = "gumball", name = "Gumball", prop = "prop_poolball_cue", price = 1, isGumball = true, bypassAnim = true},
}

-- **************************
--      Bicycle Rentals
-- **************************
-- TABLE OF LOCATIONS TO RENT A BICYCLE
bikeRentals = {
    -- ALTA TRAIN STATION
    {pos = vector3(-203.91, -1007.56, 29.15), yaw = -20.0, model = "bmx"},
    -- VESPUCCI GARAGE
    {pos = vector3(-362.07, -781.59, 33.96), yaw = 90.0, model = "bmx"},
    -- UPPER PILLBOX HOSPITAL
    {pos = vector3(283.72, -616.15, 43.4), yaw = -20.0, model = "bmx"},
    -- MISSION ROW PD
    {pos = vector3(441.35, -965.94, 28.99), yaw = -1.0, model = "bmx"},
    -- DAVIS MEGA-MALL
    {pos = vector3(5.25, -1711.92, 29.28), yaw = 204.24, model = "cruiser"},
    -- ADAM'S APPLE BLVD AMMU-NATION
    {pos = vector3(-14.44, -1116.36, 26.67), yaw = 248.0, model = "cruiser"},
    -- STRAWBERRY UNDER OLYMPIC FWY
    {pos = vector3(259.97, -1203.92, 29.28), yaw = 179.36, model = "cruiser"},
    -- BUS DEPOT ON SINNER ST
    {pos = vector3(434.38, -657.29, 28.77), yaw = 268.76, model = "bmx"},
    -- BRIDGE STREET PARK
    {pos = vector3(885.90, -273.85, 65.63), yaw = 320.95, model = "bmx"},
    -- SPANISH AND ALTA
    {pos = vector3(213.14, -42.41, 68.95), yaw = 340.72, model = "bmx"},
    -- REDWOOD LIGHTS TRACK
    {pos = vector3(875.76, 2358.89, 51.68), yaw = 6.8, model = "cruiser"},
    -- YELLOW JACK
    {pos = vector3(2011.16, 3049.91, 47.21), yaw = 237.45, model = "cruiser"},
    -- SANDY SHORES
    {pos = vector3(1699.39, 3760.86, 34.47), yaw = 135.65, model = "cruiser"},
    -- HARMONY
    {pos = vector3(608.99, 2745.83, 41.98), yaw = 0.0, model = "cruiser"},
    -- HARMONY BANK
    {pos = vector3(1153.27, 2662.37, 37.99), yaw = 90.0, model = "cruiser"},
    -- GRAPESEED
    {pos = vector3(1702.92, 4936.27, 42.07), yaw = 234.60, model = "cruiser"},
    -- EAST OF PALETO
    {pos = vector3(159.78, 6588.31, 32.02), yaw = 275.0, model = "cruiser"},
    -- WEST OF PALETO
    {pos = vector3(-331.48, 6242.68, 31.53), yaw = 134.76, model = "cruiser"},
    -- MOUNT CHILLIAD (SUMMIT)
    {pos = vector3(501.93, 5601.29, 796.59), yaw = 352.0, model = "scorcher"},
    -- DAVIS IMPOUND
    {pos = vector3(394.53, -1602.03, 29.29), yaw = 147.47, model = "cruiser"},
    -- ALTA SANITATION LOT
    {pos = vector3(-312.8044, -1512.633, 27.8645), yaw = 163.7, model = "cruiser"},
    -- NORTH ROCKFORD DRIVE GARAGE
    {pos = vector3(-1155.138, -734.611, 20.18091), yaw = 20.47, model = "bmx"},
    -- ECLIPSE BLVD GARAGE
    {pos = vector3(-329.6308, 269.9473, 86.28284), yaw = 15.77, model = "bmx"},
    -- MIRROR PARK GARAGE
    {pos = vector3(1033.701, -767.1033, 57.99194), yaw = 238.41, model = "bmx"},
    -- COMMERCIAL GARAGE
    {pos = vector3(1017.706, -2290.826, 30.49304), yaw = 217.15, model = "bmx"},
    -- LSIA
    {pos = vector3(-1016.136, -2696.163, 13.96338), yaw = 148.52, model = "scorcher"},
    -- POWER STREET GARAGE
    {pos = vector3(45.57363, -903.8901, 29.9707), yaw = 339.97, model = "bmx"},
    -- OCCUPATION GARAGE
    {pos = vector3(260.6505, -348.211, 44.63), yaw = 161.07, model = "bmx"},
    -- BOULEVARD DEL PERRO
    {pos = vector3(-1523.446, -453.2835, 35.58167), yaw = 32.1, model = "cruiser"},
    -- CITY HALL
    {pos = vector3(-504.356, -254.8088, 35.64905), yaw = 203.25, model = "cruiser"},
    -- ALTA SCRAPYARD
    {pos = vector3(-410.3077, -1705.807, 19.42273), yaw = 253.53, model = "bmx"},
    --Hestia Foundation
    {pos = vector3(743.14, -1234.61, 24.77), yaw = 355.77, model = "bmx"}
}

-- **************************
--        Car Washes
-- **************************
-- TABLE OF LOCATIONS TO WASH CAR
carWashes = {
    -- INNOCENCE BLVD
    {
        hdg = 89.2,
        canUseAnimation = true,
        startPos = vector3(49.19, -1392.02, 28.42),
        endPos = vector3(-3.80, -1391.69, 28.30),
        particlesStart = {
            -- FIRST ROLL (LEFT)
            {pos = vector3(37.43, -1393.49, 29.50), xRot = -90.0},
            {pos = vector3(37.43, -1393.49, 30.50), xRot = -90.0},
            -- FIRST ROLL (RIGHT)
            {pos = vector3(37.44, -1390.14, 29.50), xRot = 90.0},
            {pos = vector3(37.44, -1390.14, 30.50), xRot = 90.0},
            -- LAST ROLL (LEFT)
            {pos = vector3(14.21, -1393.54, 29.50), xRot = -90.0},
            {pos = vector3(14.21, -1393.54, 30.50), xRot = -90.0},
            -- LAST ROLL (RIGHT)
            {pos = vector3(14.30, -1390.10, 29.50), xRot = 90.0},
            {pos = vector3(14.30, -1390.10, 30.50), xRot = 90.0}
        }
    },

    -- LITTLE SEOUL
    {canUseAnimation = false, startPos = vector3(-699.81, -933.96, 18.64)},

    -- CARSON AVE
    {canUseAnimation = false, startPos = vector3(168.14, -1715.67, 29.05)},

    -- PALETO BAY
    {canUseAnimation = false, startPos = vector3(-75.13, 6424.35, 31.25)}
}

-- **************************
--    Vehicle Dealerships
-- **************************
-- TABLE OF ACCESSIBLE DEALERSHIPS TO BUY VEHICLES
dealerships = {
    -- DAVIS AVE - MOSLEY AUTO -- MUSCLE
    {
        name = "Mosley Auto",
        range = 10.5,
        defaultGarage = "Vespucci Garage",
        pos = vector3(-33.77, -1676.9, 29.48),
        preview = vector4(-25.98, -1681.1, 29.43, 95.36),
        vehicles = {
            {hash = "blade"},
            {hash = "buccaneer"},
            {hash = "buccaneer2"},
            {hash = "chino"},
            {hash = "chino2"},
            {hash = "clique"},
            {hash = "coquette3"},
            {hash = "deviant"},
            {hash = "dukes"},
            {hash = "faction"},
            {hash = "faction2"},
            {hash = "faction3"},
            {hash = "ellie"},
            {hash = "gauntlet"},
            {hash = "gauntlet3"},
            {hash = "hermes"},
            {hash = "hotknife"},
            {hash = "hustler"},
            {hash = "impaler"},
            {hash = "dominator"},
            {hash = "gauntlet5"},
            {hash = "sabregt"},
            {hash = "sabregt2"}
        },
        icon = "🚗",
    },
    -- JAMESTOWN -- MUSCLE2
    {
        name = "Jamestown Dealership",
        range = 22.5,
        defaultGarage = "Vespucci Garage",
        pos = vector3(484.61, -1876.52, 26.13),
        preview = vector4(479.49, -1890.09, 26.09, 292.66),
        vehicles = {
            {hash = "tampa"},
            {hash = "tulip"},
            {hash = "vamos"},
            {hash = "vigero"},
            {hash = "virgo"},
            {hash = "virgo2"},
            {hash = "virgo3"},
            {hash = "voodoo"},
            {hash = "yosemite"},
            {hash = "lurcher"},
            {hash = "moonbeam2"},
            {hash = "nightshade"},
            {hash = "peyote2"},
            {hash = "phoenix"},
            {hash = "picador"},
            {hash = "ruiner"},
            {hash = "slamvan3"},
            {hash = "slamvan"},
            {hash = "dukes3"}
        },
        icon = "🚗",
    },
    -- STRAWBERRY AVE - MOTORCYCLES
    {
        name = "Sanders",
        range = 25.5,
        defaultGarage = "Vespucci Garage",
        pos = vector3(268.36, -1155.37, 29.29),
        preview = vector4(267.0, -1159.64, 29.26, 90.2),
        vehicles = {
            {hash = "akuma"},
            {hash = "bati"},
            {hash = "bati2"},
            {hash = "bf400"},
            {hash = "carbonrs"},
            {hash = "cliffhanger"},
            {hash = "defiler"},
            {hash = "double"},
            {hash = "enduro"},
            {hash = "esskey"},
            {hash = "faggio"},
            {hash = "faggio2"},
            {hash = "faggio3"},
            {hash = "fcr"},
            {hash = "fcr2"},
            {hash = "hakuchou"},
            {hash = "hakuchou2"},
            {hash = "lectro"},
            {hash = "manchez"},
            {hash = "nemesis"},
            {hash = "pcj"},
            {hash = "sanchez"},
            {hash = "sanchez2"},
            {hash = "sovereign"},
            {hash = "stryder"},
            {hash = "thrust"},
            {hash = "vader"},
            {hash = "vindicator"},
            {hash = "vortex"},
            {hash = "diablous"},
            {hash = "diablous2"}
        },
        icon = "🚗",
    },
    -- MARINA DR - CHOPPERS
    {
        name = "Ride or Die Cycles",
        range = 18.5,
        defaultGarage = "Harmony Garage",
        pos = vector3(914.88, 3567.32, 33.79),
        preview = vector4(917.39, 3562.62, 33.8, 264.72),
        vehicles = {
            {hash = "avarus"},
            {hash = "bagger"},
            {hash = "chimera"},
            {hash = "daemon2"},
            {hash = "wolfsbane"},
            {hash = "gargoyle"},
            {hash = "hexer"},
            {hash = "innovation"},
            {hash = "nightblade"},
            {hash = "zombiea"},
            {hash = "zombieb"}
        },
        icon = "🏍️",
    },
    -- EL RANCHO BLVD - COMMERCIAL
    {
        name = "Commercial",
        range = 55.5,
        defaultGarage = "Commercial Garage",
        pos = vector3(1220.55, -1270.41, 35.36),
        preview = vector4(1204.68, -1267.67, 35.23, 177.04),
        vehicles = {
            {hash = "flatbed"},
            --{hash = "roadside"},
            {hash = "mule3"},
            {hash = "benson"},
            {hash = "packer"},
            {hash = "forklift"},
            {hash = "biff"},
            {hash = "pounder"},
            {hash = "utillitruck2"},
            {hash = "utillitruck3"},
            {hash = "rubble"},
            {hash = "phantom"},
            {hash = "phantom3"},
            {hash = "coach"},
            {hash = "stretch"},
            {hash = "romero"},
            {hash = "taco"},
            {hash = "bus"},
            {hash = "airbus"},
            {hash = "wastelander"},
            {hash = "towtruck"},
            {hash = "mower"},
            {hash = "caddy"},
            {hash = "caddy2"},
            {hash = "caddy3"},
            {hash = "stockade"},
            {hash = "boxville"},
            {hash = "boxville2"},
            {hash = "boxville3"},
            {hash = "boxville4"},
            {hash = "mixer"},
            {hash = "mixer2"},
            {hash = "tiptruck"},
            {hash = "tiptruck2"},
            {hash = "hauler"},
            {hash = "mule"},
            {hash = "mule2"},
            {hash = "rumpo"},
            {hash = "pony"},
            {hash = "burrito"},
            {hash = "youga"},
            {hash = "speedo"},
            {hash = "youga3"},
            {hash = "rumpo3"}
        },
        icon = "🚚",
    },
    -- ADAM'S APPLE BLVD - SPORTS
    {
        name = "Premium Deluxe Motorsports",
        range = 15.5,
        defaultGarage = "Vespucci Garage",
        pos = vector3(-56.6, -1096.74, 26.42),
        preview = vector4(-49.47, -1096.6, 24.42, 206.6),
        vehicles = {
            {hash = "alpha"},
            {hash = "banshee"},
            {hash = "bestiagts"},
            {hash = "blista2"},
            {hash = "buffalo"},
            {hash = "buffalo2"},
            {hash = "carbonizzare"},
            {hash = "comet2"},
            {hash = "comet3"},
            {hash = "comet5"},
            {hash = "dominator3"},
            {hash = "coquette"},
            {hash = "coquette4"},
            {hash = "drafter"},
            {hash = "elegy"},
            {hash = "elegy2"},
            {hash = "feltzer2"},
            {hash = "flashgt"},
            {hash = "furoregt"},
            {hash = "fusilade"},
            {hash = "futo"},
            {hash = "gb200"},
            {hash = "komoda"},
            {hash = "imorgon"},
            {hash = "issi7"},
            {hash = "italigto"},
            {hash = "jugular"},
            {hash = "jester"},
            {hash = "jester3"},
            {hash = "gauntlet4"}
        },
        icon = "🚗",
    },
    -- ECLIPSE BLVD - SPORTS CLASSIC
    {
        name = "Sport Classics'",
        range = 30.5,
        defaultGarage = "Vespucci Garage",
        pos = vector3(-277.74, 282.66, 89.89),
        preview = vector4(-270.75, 285.74, 90.52, 182.36),
        vehicles = {
            {hash = "btype3"},
            {hash = "casco"},
            {hash = "cheetah2"},
            {hash = "coquette2"},
            {hash = "dynasty"},
            {hash = "fagaloa"},
            {hash = "feltzer3"},
            {hash = "gt500"},
            {hash = "infernus2"},
            {hash = "jb700"},
            {hash = "mamba"},
            {hash = "manana2"},
            {hash = "michelli"},
            {hash = "monroe"},
            {hash = "nebula"},
            {hash = "peyote"},
            {hash = "peyote3"},
            {hash = "pigalle"},
            {hash = "rapidgt3"},
            {hash = "retinue"},
            {hash = "retinue2"},
            -- {hash = "savestra"}, --REMOVED BY CARR DUE TO ABILITY TO HAVE WEAPONS
            {hash = "stinger"},
            {hash = "stingergt"},
            {hash = "swinger"},
            {hash = "torero"},
            {hash = "tornado"},
            {hash = "tornado2"},
            {hash = "turismo2"},
            -- {hash = "viseris"}, --REMOVED BY CARR DUE TO ABILITY TO HAVE WEAPONS
            {hash = "z190"},
            {hash = "ztype"},
            {hash = "zion3"},
            {hash = "cheburek"}
        },
        icon = "🚗",
    },
    -- MAD WAYNE THUNDER - LUXURY DEALER
    {
        name = "Luxury Dealership",
        range = 18.5,
        defaultGarage = "Vespucci Garage",
        pos = vector3(-776.86, -244.42, 37.12),
        preview = vector4(-765.57, -245.09, 37.25, 200.0),
        vehicles = {
            {hash = "autarch"},
            {hash = "bullet"},
            {hash = "cheetah"},
            {hash = "prototipo"},
            {hash = "entity2"},
            {hash = "emerus"},
            {hash = "fmj"},
            {hash = "furia"},
            {hash = "italigtb2"},
            {hash = "krieger"},
            {hash = "nero2"},
            {hash = "pfister811"},
            {hash = "sc1"},
            {hash = "t20"},
            {hash = "tempesta"},
            {hash = "tigon"},
            {hash = "tezeract"},
            {hash = "thrax"},
            {hash = "tyrant"},
            {hash = "vagner"},
            {hash = "visione"},
            {hash = "zorrusso"},
            {hash = "xa21"},
            {hash = "italirsx"},
            {hash = "taipan"},
            {hash = "cyclone"},
            {hash = "gp1"},
            {hash = "nero"},
            {hash = "penetrator"},
            {hash = "tyrus"},
            {hash = "sheava"},
            {hash = "reaper"},
            {hash = "osiris"},
            {hash = "zentorno"},
            {hash = "turismor"},
            {hash = "infernus"},
            {hash = "entityxf"},
            {hash = "adder"}
        },
        icon = "🚗",
    },
    -- SPANISH AVE - SPORTS
    {
        name = "Sport's Dealership",
        range = 25.5,
        defaultGarage = "Vespucci Garage",
        pos = vector3(-69.09, 63.63, 71.89),
        preview = vector4(-84.32, 78.83, 71.56, 150.0),
        vehicles = {
            {hash = "khamelion"},
            {hash = "kuruma"},
            {hash = "locust"},
            {hash = "lynx"},
            {hash = "massacro"},
            {hash = "neo"},
            {hash = "neon"},
            {hash = "ninef"},
            {hash = "ninef2"},
            {hash = "omnis"},
            {hash = "paragon"},
            {hash = "pariah"},
            {hash = "penumbra"},
            {hash = "penumbra2"},
            {hash = "raiden"},
            {hash = "rapidgt"},
            {hash = "rapidgt2"},
            {hash = "raptor"},
            {hash = "revolter"},
            {hash = "ruston"},
            {hash = "schafter2"},
            {hash = "schafter3"},
            {hash = "schlagen"},
            {hash = "schwarzer"},
            {hash = "sentinel3"},
            {hash = "seven70"},
            {hash = "specter"},
            {hash = "specter2"},
            {hash = "streiter"},
            {hash = "sugoi"},
            {hash = "sultan"},
            {hash = "sultan2"},
            {hash = "sultanrs"},
            {hash = "verlierer2"},
            {hash = "surano"},
            {hash = "vstr"},
            {hash = "tropos"},
            {hash = "banshee2"},
            {hash = "voltic"}
        },
        icon = "🚗",
    },
    -- ALTA ST - SCRAP YARD
    {
        name = "Scrap 4 Cash",
        range = 40,
        defaultGarage = "Vespucci Garage",
        pos = vector3(-498.99, -1714.01, 19.9),
        preview = vector4(-510.49, -1735.81, 19.14, 321.85),
        vehicles = {
            {hash = "emperor2"},
            {hash = "regina"},
            {hash = "tornado3"},
            {hash = "tornado6"},
            {hash = "surfer2"},
            {hash = "journey"},
            {hash = "minivan"},
            {hash = "tractor"},
            {hash = "ratloader"},
            {hash = "glendale"},
            {hash = "bfinjection"},
            {hash = "ratbike"},
            {hash = "rebel"},
            {hash = "voodoo2"}
        },
        forImports = false,
    },
    -- ALTA ST - SUVS
    {
        name = "Arcadius Dealership",
        range = 18.5,
        defaultGarage = "Vespucci Garage",
        pos = vector3(-117.19, -604.42, 36.28),
        preview = vector4(-110.0, -604.06, 36.28, 217.8),
        vehicles = {
            {hash = "baller"},
            {hash = "baller2"},
            {hash = "baller3"},
            {hash = "baller4"},
            {hash = "bjxl"},
            {hash = "cavalcade"},
            {hash = "cavalcade2"},
            {hash = "contender"},
            {hash = "dubsta"},
            {hash = "dubsta2"},
            {hash = "fq2"},
            {hash = "granger"},
            {hash = "gresley"},
            {hash = "habanero"},
            {hash = "huntley"},
            {hash = "landstalker"},
            {hash = "landstalker2"},
            {hash = "mesa"},
            {hash = "novak"},
            {hash = "patriot"},
            {hash = "patriot2"},
            {hash = "radi"},
            {hash = "rebla"},
            {hash = "rocoto"},
            {hash = "seminole"},
            {hash = "seminole2"},
            {hash = "serrano"},
            {hash = "toros"},
            {hash = "xls"}
        },
        icon = "🚗",
    },
    -- ROUTE 68 -- OFFROAD
    {
        name = "Dexter's Lot",
        range = 18.5,
        defaultGarage = "Harmony Garage",
        pos = vector3(1228.91, 2728.95, 38.01),
        preview = vector4(1234.27, 2721.81, 38.0, 180.0),
        vehicles = {
            {hash = "bifta"},
            {hash = "blazer"},
            {hash = "blazer4"},
            {hash = "brawler"},
            {hash = "caracara2"},
            {hash = "dloader"},
            {hash = "dubsta3"},
            {hash = "dune"},
            {hash = "everon"},
            {hash = "freecrawler"},
            {hash = "hellion"},
            {hash = "kalahari"},
            {hash = "kamacho"},
            {hash = "mesa3"},
            {hash = "outlaw"},
            {hash = "rancherxl"},
            {hash = "rebel2"},
            {hash = "riata"},
            {hash = "sandking"},
            {hash = "sandking2"},
            {hash = "vagrant"},
            {hash = "bison"},
            {hash = "bodhi2"},
            {hash = "bobcatxl"},
            {hash = "sadler"},
            {hash = "winky"},
            {hash = "yosemite3"},
            {hash = "guardian"}
        },
        icon = "🚗",
    },
    -- AUTOPIA PARKWAY -- COUPES AND COMPACTS
    {
        name = "Coupe Dealership",
        range = 40,
        defaultGarage = "Vespucci Garage",
        pos = vector3(-962.04, -2070.6, 9.41),
        preview = vector4(-968.65, -2070.66, 9.41, 133.33),
        vehicles = {
            {hash = "cogcabrio"},
            {hash = "exemplar"},
            {hash = "f620"},
            {hash = "felon"},
            {hash = "felon2"},
            {hash = "jackal"},
            {hash = "oracle"},
            {hash = "oracle2"},
            {hash = "sentinel"},
            {hash = "sentinel2"},
            {hash = "windsor"},
            {hash = "windsor2"},
            {hash = "zion"},
            {hash = "zion2"},
            {hash = "asbo"},
            {hash = "blista"},
            {hash = "brioso"},
            {hash = "club"},
            {hash = "dilettante"},
            {hash = "kanjo"},
            {hash = "issi2"},
            {hash = "panto"},
            {hash = "prairie"},
            {hash = "rhapsody"},
            {hash = "weevil"},
            {hash = "brioso2"},
            {hash = "issi3"},
            {hash = "flashgt"}
        },
        icon = "🚗",
    },
    -- PALETO BLVD - SEDANS
    {
        name = "Sedan Dealersip",
        range = 18.5,
        defaultGarage = "Paleto Garage",
        pos = vector3(-223.11, 6243.02, 43.57),
        preview = vector4(-221.91, 6249.61, 31.49, 54.12),
        vehicles = {
            {hash = "asea"},
            {hash = "asterope"},
            {hash = "cognoscenti"},
            {hash = "cog55"},
            {hash = "emperor"},
            {hash = "fugitive"},
            {hash = "glendale"},
            {hash = "glendale2"},
            {hash = "ingot"},
            {hash = "intruder"},
            {hash = "premier"},
            {hash = "primo"},
            {hash = "primo2"},
            {hash = "superd"},
            {hash = "surge"},
            {hash = "tailgater"},
            {hash = "warrener"},
            {hash = "washington"},
            {hash = "stafford"}
        },
        icon = "🚗",
    },
    -- BUCCANEAR WAY -- DRIFT
    {
        name = "Driftin",
        range = 18.5,
        defaultGarage = "Vespucci Garage",
        pos = vector3(1207.36, -3122.52, 5.54),
        preview = vector4(1202.35, -3116.21, 5.54, 337.14),
        vehicles = {
            {hash = "tampa2"},
            {hash = "yosemite2"}
        },
        icon = "🚗",
    },
    -- CAYO PERICO VEHICLES
    {
        name = "Perico Dealership",
        range = 18.5,
        defaultGarage = "Perico Garage",
        pos = vector3(4993.05, -5193.33, 2.51),
        preview = vector4(4989.22, -5183.27, 2.51, 268.55),
        vehicles = {
            {hash = "blazer"},
            -- {hash = "blazer5"},
            {hash = "caracara2"},
            {hash = "bfinjection"},
            {hash = "mesa3"},
            {hash = "squaddie"},
            {hash = "verus"},
            {hash = "outlaw"}
        },
        perms = {"CANIMPORTVEHICLES"},
        forImports = false,
    },
    -- BOATS

    -- SHANK STREET - MARINER
    {
        name = "Shank St.",
        range = 15.0,
        defaultGarage = "Shank St. Mariner",
        pos = vector3(-781.11, -1397.25, 1.6),
        preview = vector4(-783.7, -1400.4, -0.5, 227.7),
        vehicles = {
            {hash = "marquis"},
            {hash = "jetmax"},
            {hash = "squalo"},
            {hash = "tropic"},
            {hash = "tropic2"},
            {hash = "speeder"},
            {hash = "speeder2"},
            {hash = "toro"},
            {hash = "toro2"},
            {hash = "dinghy"},
            {hash = "seashark"},
            {hash = "seashark3"},
            {hash = "dinghy2"},
            {hash = "dinghy3"},
            {hash = "dinghy4"},
            {hash = "submersible"},
            {hash = "submersible2"},
            {hash = "longfin"}
        },
        forImports = false,
    },
    -- CALAFIA - MARINER
    {
        name = "Calafia Boats",
        range = 20.0,
        defaultGarage = "Millers Mariner",
        pos = vector3(1339.25, 4225.27, 33.92),
        preview = vector4(1347.3, 4223.7, 30.9, 164.6),
        vehicles = {
            {hash = "marquis"},
            {hash = "tropic"},
            {hash = "dinghy"},
            {hash = "seashark"},
            {hash = "dinghy2"},
            {hash = "dinghy3"},
            {hash = "dinghy4"},
            {hash = "suntrap"}
        },
        forImports = false,
    },
    -- CAYO PERICO - DOCKS
    {
        name = "Perico Docks",
        range = 18.5,
        defaultGarage = "Perico Docks",
        pos = vector3(4906.92, -5172.01, 2.48),
        preview = vector4(4901.87, -5172.04, 0.5, 335.43),
        vehicles = {
            {hash = "tropic"},
            {hash = "dinghy"},
            {hash = "seashark"},
            {hash = "dinghy2"},
            {hash = "dinghy3"},
            {hash = "dinghy4"},
            {hash = "suntrap"},
            {hash = "seashark3"},
            {hash = "tropic2"},
            {hash = "speeder"},
            {hash = "speeder2"},
            {hash = "longfin"}
        },
        perms = {"CANIMPORTVEHICLES"},
        forImports = false,
    },
    -- CATFISH VIEW - DOCKS
    {
        name = "Catfish Docks",
        range = 25.0,
        defaultGarage = "Catfish Dock",
        pos = vector3(3817.41, 4482.42, 5.99),
        preview = vector4(3874.65, 4464.20, -0.50, 358.09),
        vehicles = {
            {hash = "tug"},
        },
        forImports = false,
    },
    -- BIKES -- VESPUCCI BEACH
    {
        name = "Bikes",
        range = 18.5,
        defaultGarage = "Vespucci Garage",
        pos = vector3(-1108.33, -1693.67, 4.37),
        preview = vector4(-1105.85, -1694.83, 4.37, 306.43),
        vehicles = {
            {hash = "bmx"},
            {hash = "cruiser"},
            {hash = "fixter"},
            {hash = "scorcher"},
            {hash = "tribike"},
            {hash = "tribike2"},
            {hash = "tribike3"}
        },
        forImports = false,
    },
    -- BUCCANEAR WAY -- IMPORTS
    {
        name = "Offshore Imports",
        range = 20.0,
        defaultGarage = "Offshore Imports Garage",
        pos = vector3(822.46, -3188.07, 5.99),
        preview = vector4(815.29, -3196.00, 5.89, 124.72),
        perms = {"CANIMPORTVEHICLES"},
        isImport = true,
    },
}
