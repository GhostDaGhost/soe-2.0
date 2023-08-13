-- TOTAL AMOUNT OF DRUGS THAT CAN BE RAN
drugrunProducts = {
    ["Weed"] = {item = "weedbrick", blip = 140},
    ["Crack"] = {item = "cracktray", blip = 497},
    ["Cocaine"] = {item = "cocainebrick", blip = 514}
}

-- SPOTS TO PICKUP MONEY WHEN THE DRUG RUN IS COMPLETE
drugrunMoneySpots = {
    { -- GROVE STREET
        pos = vector3(129.0462, -1941.969, 20.48425),
        msg = "Get your money at Grove Street. Good shit on not getting caught... now just don't get shot over there."
    },
    { -- ZANCUDO GRANDE VALLEY
        pos = vector3(-296.2286, 2786.294, 61.09229),
        msg = "The old church off of Route 68 has your payment. Good shit."
    }
}

-- SPOTS TO START/END A DRUG RUN
drugrunStartingPoints = {
    { -- POPULAR STREET
        pos = vector3(757.8857, -1865.67, 29.27991),
        msg = "You notice a bunch of Vagos around. You try to not make eye-contact as the Vagos load the vehicle with the product."
    },
    { -- GRAPESEED
        pos = vector3(1902.369, 4920.33, 48.72449),
        msg = "Grandma has been waiting for the builders to finish the barn... its been 3 years and nothing. The men come out and load the vehicle with the product."
    },
    { -- PALETO BAY
        pos = vector3(438.3297, 6460.853, 28.7406),
        msg = "You see a bunch of masked individuals load up the vehicle with the product. You realize that Grandma has a thing for barns..."
    }
}

-- SPOTS TO DROP OFF THE DRUG DURING THE RUN
drugrunDropSpots = {
    { -- EL BURRO OIL FIELDS
        pos = vector3(1481.987, -1917.705, 71.38757),
        msg = "Alrighty. We need you to take this stash to the El Burro Heights oil fields."
    },
    { -- BAYTREE CANYON ROAD
        pos = vector3(162.9758, 2286.053, 94.08423),
        msg = "There is an old barn around Baytree Canyon Road. Take this stash there."
    },
    { -- SOUTH ROCKFORD DRIVE
        pos = vector3(-652.6682, -1148.677, 9.144287),
        msg = "Behind some buildings around South Rockford Drive, there'll be someone waiting for you to deliver the product."
    },
    { -- ROUTE 68 / BUEN VINO RD
        pos = vector3(-2127.178, 2306.862, 29.65051),
        msg = "Under the bridge on Route 68 and Buen Vino Rd. Get the stash there, pronto."
    },
    { -- ZANCUDO TRAIL
        pos = vector3(-2777.248, 2712.092, 2.32019),
        msg = "There is a large area of sand right next to the Highway road into the southbound tunnel under Zancudo Racing Facility. Get the stash there."
    },
    { -- ALTURIST CULT (NUDIST CAMP)
        pos = vector3(-1125.231, 4946.426, 220.0198),
        msg = "The nudist camp on Mount Chilliad is requesting a stash. Get over there."
    },
    { -- PALETO DREAM VIEW MOTEL
        pos = vector3(-113.2879, 6355.451, 31.48718),
        msg = "We got a stash order behind the Dream View motel in Paleto Bay."
    },
    { -- GREAT OCEAN HWY HIPPIE CAMP
        pos = vector3(1425.851, 6325.662, 24.20801),
        msg = "Get this stash to the hippie camp off of Great Ocean Highway."
    },
    { -- EAST JOSHUA ROAD DMV
        pos = vector3(2466.158, 4101.323, 38.05859),
        msg = "Behind the DMV on East Joshua Road. They have been requesting this for a while now."
    },
    { -- MARINA DRIVE
        pos = vector3(468.1187, 3549.864, 33.22266),
        msg = "Behind this old abandoned building in Marina Drive. Go for it and drop off the stash behind the building."
    },
    { -- SENORA RD FARM
        pos = vector3(1242.343, 1865.235, 79.10474),
        msg = "The farm over on Senora Road wants this stash."
    },
    { -- LS CANALS
        pos = vector3(560.8879, -1026.501, 10.40808),
        msg = "The LS Canals underneath the Vespucci Blvd bridge to La Mesa. There is a old abandoned rusty car to leave the stash at."
    },
    { -- DOCKS
        pos = vector3(1196.769, -3332.004, 6.0271),
        msg = "The docks down south. Get to gate 5 and drop the stash off there."
    },
    { -- SOUTH SHAMBLES ST
        pos = vector3(988.8527, -2396.004, 30.59412),
        msg = "Between two buildings on South Shambles St in Cypress Flats are some decommissioned railroad tracks. Take the stash there."
    },
    { -- CARSON AVE
        pos = vector3(204.3297, -1854.04, 27.19043),
        msg = "The laundromat behind the buildings on Carson Ave needs a resupply on our product."
    },
    { -- MAGELLAN AVE
        pos = vector3(-1279.108, -1303.675, 4.038818),
        msg = "We got an apartment building on Magellen Ave that has purchased our product. Get it over there swiftly and safely."
    },
    { -- LAKE VINEWOOD
        pos = vector3(32.07033, 856.9187, 197.7274),
        msg = "The small dock on Lake Vinewood. Put the stash there and the recipient will come by later and pick it up."
    },
    { -- SISYPHUS THEATER
        pos = vector3(175.1077, 1245.495, 223.4403),
        msg = "The Sisyphus Theater has a underground thing going on so leave the stash at their garage. Security will recognize you."
    },
    { -- POWER ST UNDERGROUND GARAGE
        pos = vector3(89.70989, -726.8044, 33.12158),
        msg = "Leave the stash on the corner inside the Power St underground garage. Don't get caught."
    },
    { -- GROVE STREET HOUSE
        pos = vector3(109.9253, -1924.971, 20.73706),
        msg = "There's a house on Grove St that needs a resupply. Get with Tyrone there and give him his shit."
    },
    --[[{ -- LITTLE BIGHORN AVE
        pos = vector3(540.2374, -1945.319, 24.98315),
        msg = "Got a warehouse requesting a resupply on Little Bighorn Ave. Go give them their stuff."
    },]]
    { -- INVENTION CT
        pos = vector3(-1047.27, -1122.527, 2.151611),
        msg = "Get to a house on Invention Ct. Resupply needed."
    },
    { -- COUGAR AVE
        pos = vector3(-1561.292, -414.5406, 38.09229),
        msg = "Alleyway in Cougar Ave and Del Perro. You'll leave the stash in a room leading up to some stairs."
    },
    { -- LAS LAGUNAS BLVD
        pos = vector3(-148.8528, -12.61978, 58.21094),
        msg = "Apartment building off of Las Lagunas Blvd is requesting a product resupply. Don't get caught."
    },
    { -- FUDGE LANE
        pos = vector3(1296.343, -1620.343, 54.21753),
        msg = "Fudge Lane and Innocence Blvd has a resupply pending. Get them their stuff."
    }
}
