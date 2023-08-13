-- *******************
--       Drugs
-- *******************
drugsPrices = {
    ["meth"] = {name = "grams of meth"},
    ["weed"] = {name = "baggies of weed"},
    ["coke"] = {name = "vials of cocaine"},
    ["crack"] = {name = "baggies of crack"},
    ["shrooms"] = {name = "baggies of magic mushrooms"}
}

-- *******************
--     Chop Shop
-- *******************
chopShops = {
    -- GRAND SENORA DESERT PLANE GRAVEYARD
    [1] = {list = vector3(2340.66, 3126.09, 48.21), dropOff = vector3(2344.26, 3131.27, 48.21)},
    -- GREENWICH PARKWAY LS CUSTOM
    [2] = {list = vector3(-1164.6, -2022.31, 13.16), dropOff = vector3(-1168.76, -2022.14, 13.16)},
    -- BAY CITY AVENUE
    [3] = {list = vector3(-1080.49, -1671.32, 4.7), dropOff = vector3(-1076.29, -1677.33, 4.58)}
}

-- ***********************
--    Money Laundering
-- ***********************
moneyLaunderers = {
    {
        name = "iceplanet_launderer",
        pos = vector3(244.76, 373.78, 105.74),
        length = 2.2,
        width = 1.8,
        options = {name = "iceplanet_launderer", heading = 70, minZ = 103.54, maxZ = 107.54, data = {
            marker = vector3(244.61, 374.23, 105.74), launderName = "Ice Planet Jewelry", commission = 0.20
        }}
    },
    {
        name = "route68_launderer",
        pos = vector3(552.61, 2658.6, 45.87),
        length = 2.2,
        width = 1.2,
        options = {name = "route68_launderer", heading = 8, minZ = 44.77, maxZ = 47.57, data = {
            marker = vector3(552.59, 2658.64, 45.86), launderName = "1007 State Route 68", commission = 0.20
        }}
    },
    {
        name = "carson_launderer",
        pos = vector3(217.65, -1850.82, 26.87),
        length = 2.1,
        width = 1.9,
        options = {name = "carson_launderer", heading = 50, minZ = 25.87, maxZ = 27.87, data = {
            marker = vector3(217.65, -1850.82, 26.87), launderName = "Carson Laundromat", commission = 0.10
        }}
    },
    {
        name = "paleto_launderer",
        pos = vector3(-33.03, 6455.32, 31.48),
        length = 2.0,
        width = 2.0,
        options = {name = "paleto_launderer", heading = 45, minZ = 29.48, maxZ = 33.48, data = {
            marker = vector3(-33.17, 6455.60, 31.47), launderName = "No Marks Cleaners", commission = 0.10
        }}
    },
    {
        name = "elrancho_launderer",
        pos = vector3(1132.66, -989.36, 46.11),
        length = 3.0,
        width = 2.4,
        options = {name = "elrancho_launderer", heading = 5, minZ = 45.31, maxZ = 47.91, data = {
            marker = vector3(1133.03, -990.51, 46.11), launderName = "Express While -U- Wait", commission = 0.10
        }}
    },
}
