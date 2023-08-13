CADAlerts = {}
hospitals = {}
hospitals["Pillbox Hospital"] = {pos = vector4(360.66, -585.12, 28.82, 242.03)}
hospitals["Sandy Shores Medical"] = {pos = vector4(1820.94, 3678.97, 34.27, 210.65)}
hospitals["Paleto Medical"] = {pos = vector4(-263.10, 6327.42, 32.42, 314.01)}

-- LIST OF WINDOW TINTS BY NUMBER/LABEL
tintLevels = {[0] = "No Tint", [1] = "Blackout", [2] = "Dark Smoke", [3] = "Light Smoke", [4] = "Limo", [5] = "Stock", [6] = "Green"}

-- LIST OF CHARACTER IDs AUTHORIZED TO USE THE UNDERCOVER VEHICLE MOTORPOOL (BCSO DOESN'T HAVE SPECIFIC DETECTIVE RANKS... THIS CAN BE CHANGED LATER)
undercoverWhitelist = {
    [115] = true, -- GHOST'S DEV CHARACTER
    [36] = true, -- CHRISTOPHER/CARR
    [7] = true, -- CHARLES/BANKS (LSPD COMMAND)
    [27] = true, -- TWITCH/WILLIAMS (LSPD COMMAND/INVESTIGATOR)
    [720] = true, -- OZ/WATSON (LSPD Detective)
}

-- LIST OF CAD ALERT CALLS
alerts = {
    ["Shots Fired"] = {
        code = "10-32A",
        desc = "A caller is reporting they heard gunshots in the area of %s.",
        blip = {}
    },
    ["Drive-By Shooting"] = {
        code = "10-32B",
        desc = "A caller is reporting somebody discharging a firearm from a vehicle in the area of %s. The vehicle is reported as a %s in color %s with a plate of: %s",
        blip = {}
    },
    ["Homicide"] = {
        code = "10-31",
        desc = "A caller reports that a dead body was discovered in the area of %s.",
        blip = {}
    },
    ["Tire Slashing"] = {
        code = "10-31",
        desc = "A caller is reporting they witnessed somebody slash a vehicle's tire in the area of %s.",
        blip = {}
    },
    ["Parking Meter Tampering"] = {
        code = "10-31",
        desc = "A caller is reporting they witnessed somebody tampering with a parking meter in the area of %s.",
        blip = {}
    },
    ["Mugging"] = {
        code = "10-31",
        desc = "A caller is reporting an in-progress armed robbery attempt in the area of %s.",
        blip = {}
    },
    ["Attempted Vehicle Break-In"] = {
        code = "10-35A",
        desc = "A caller is reporting a subject attempting to break into a parked vehicle in the area of %s.",
        blip = {}
    },
    ["Armed Carjacking"] = {
        code = "10-35B",
        desc = "A caller is reporting an armed theft of an occupied vehicle in the area of %s. The stolen vehicle is reported as a %s in color %s. Plate: %s",
        blip = {}
    },
    ["Carjacking"] = {
        code = "10-35C",
        desc = "A caller is reporting a theft of an occupied vehicle in the area of %s. The stolen vehicle is reported as a %s in color %s. Plate: %s",
        blip = {}
    },
    ["Grand Theft Auto"] = {
        code = "10-35D",
        desc = "A caller is reporting a vehicle theft in the area of %s. The stolen vehicle is reported as a %s in color %s. Plate: %s",
        blip = {}
    },
    ["Vehicle Break-In"] = {
        code = "10-35E",
        desc = "A caller is reporting a vehicle break-in in the area of %s. The vehicle is reported as a %s in color %s. Plate: %s",
        blip = {}
    },
    ["Attempted Carjacking"] = {
        code = "10-35F",
        desc = "A caller is reporting an attempted theft of an occupied vehicle in the area of %s. The vehicle is reported as a %s in color %s. Plate: %s",
        blip = {}
    },
    ["Attempted Armed Carjacking"] = {
        code = "10-35G",
        desc = "A caller is reporting an attempted armed theft of an occupied vehicle in the area of %s. The vehicle is reported as a %s in color %s. Plate: %s",
        blip = {}
    },
    ["Suspicious Transaction"] = {
        code = "10-37",
        partialPlate = true,
        desc = "A caller is reporting a suspicious transaction in the area of %s. The vehicle is reported as a %s in color %s. Partial plate: %s",
        blip = {}
    },
    ["Motor Vehicle Collision"] = {
        code = "10-50",
        desc = "A caller is reporting there was a vehicle collision in the area of %s. The involved vehicle is reported as a %s in color %s.",
        blip = {}
    },
    ["Attempted Drug Sale"] = {
        code = "10-31",
        desc = "A caller is reporting a subject attempting to sell a suspicious substance in the area of %s.",
        blip = {}
    },
    ["Illegal Fishing"] = {
        code = "10-31",
        desc = "A caller is reporting a subject possibly illegally fishing in the area of %s.",
        blip = {}
    },
    ["Commercial Alarm"] = {
        code = "10-90",
        blip = {}
    },
    ["Commercial Alarm (Store)"] = {
        code = "10-35",
        blip = {}
    },
    ["Home Invasion"] = {
        code = "10-35",
        blip = {}
    },
    ["Warehouse Burglary"] = {
        code = "10-35",
        blip = {}
    },
    ["10-38"] = {
        code = "10-38",
        desc = "%s is in a traffic stop with a %s in color %s with license plate of %s on %s",
        blip = {}
    },
    ["10-78"] = {
        code = "10-78",
        desc = "%s is requesting assistance on %s",
        blip = {}
    },
    ["10-75"] = {
        code = "10-75",
        desc = "%s is requesting a forensics unit to %s. Please make contact with them via /mdt %s [message]",
        blip = {}
    },
}

-- ZONES WITH SPECIFIED CRIME REPORT CHANCES
reportChances = {
    ["DELBE"] = 0.4, -- Del Perro Beach
    ["DELPE"] = 0.7, -- Del Perro
    ["PBLUFF"] = 0.5, -- Pacific Bluffs
    ["VCANA"] = 0.9, -- Vespucci Canals
    ["VESP"] = 0.5, -- Vespucci
    ["DELSOL"] = 0.5, -- Puerto Del Sol
    ["KOREAT"] = 0.3, -- Little Seoul
    ["LOSPUER"] = 0.4, -- La Puerta
    ["BEACH"] = 0.4, -- Vespucci Beach
    ["AIRP"] = 1.0, -- Los Santos International
    ["ELYSIAN"] = 0.1, -- Elysian Island
    ["CYPRE"] = 0.2, -- Cypress Flats
    ["TERMINA"] = 0.1, -- Terminal / Los Santos Dock
    ["EBURO"] = 0.3, -- El Burro Heights
    ["PALHIGH"] = 0.1, -- Palomino Highlands
    ["MURRI"] = 0.2, -- Murrietta Heights
    ["RANCHO"] = 0.2, -- Rancho
    ["DAVIS"] = 0.2, -- Davis
    ["STRAW"] = 0.7, -- Strawberry
    ["MORN"] = 0.5, -- Morningwood
    ["RICHM"] = 0.9, -- Richman
    ["golf"] = 1.0, -- Golf Course
    ["CHIL"] = 0.7, -- Vinewood Hills
    ["DTVINE"] = 0.9, -- Downtown Vinewood
    ["HORS"] = 0.7, -- Vinewood Racetrack
    ["EAST_V"] = 0.5, -- East Vinewood
    ["MIRR"] = 0.5, -- Mirror Park
    ["TATAMO"] = 0.1, -- Tataviam Mountains
    ["LMESA"] = 0.4, -- La Mesa
    ["TEXTI"] = 0.7, -- Textile City
    ["PBOX"] = 0.8, -- Pillbox Hill
    ["DOWNT"] = 0.8, -- Downtown
    ["VINE"] = 0.7, -- Vinewood
    ["ROCKF"] = 0.9, -- Rockford Hills
    ["MOVIE"] = 1.0, -- Backlot City
    ["WVINE"] = 0.5, -- West Vinewood
    ["HAWICK"] = 0.5, -- Hawick
    ["ALTA"] = 0.8, -- Alta
    ["WINDF"] = 0.1, -- Windfarm
    ["PALMPOW"] = 0.8, -- Palmer T Power Station
    ["ZQ_UAR"] = 0.8, -- Davis Quartz
    ["DESRT"] = 0.2, -- Grand Senora Desert
    ["JAIL"] = 1.0, -- Bolingbrooke Pen
    ["GALLI"] = 0.8, -- Galileo Park
    ["GREATC"] = 0.2, -- Great Chaparral
    ["TONGVAV"] = 0.4, -- Tongva Valley
    ["RGLEN"] = 0.4, -- Richman Glen
    ["BHAMCA"] = 0.4, -- Banham Canyon
    ["CHU"] = 0.4, -- Chumash
    ["TONGVAH"] = 1.0, -- Tongva Hills
    ["LAGO"] = 0.4, -- Lago Zancudo
    ["ARMYB"] = 1.0, -- Lago Zancudo Racing Facility
    ["ZANCUDO"] = 1.0, -- Zancudo River
    ["HARMO"] = 0.5, -- Harmony
    ["ALAMO"] = 0.5, -- Alamo Sea
    ["SLAB"] = 0.1, -- Stab City
    ["MTJOSE"] = 0.1, -- Mount Josiah
    ["NCHU"] = 0.1, -- North Chumash
    ["CANNY"] = 0.1, -- Raton Canyon
    ["CMSW"] = 0.1, -- Chiliad Wilderness
    ["PALCOV"] = 0.3, -- Paleto Cove
    ["PALFOR"] = 0.3, -- Paleto Forest
    ["MTCHIL"] = 0.1, -- Mount Chiliad
    ["PALETO"] = 0.7, -- Paleto
    ["PROCOB"] = 0.3, -- Procopio Promenade
    ["MTGORDO"] = 0.1, -- Mount Gordo
    ["GRAPES"] = 0.4, -- Grapeseed
    ["RTRAK"] = 0.6, -- Red Lights Racetrack
    ["SANDY"] = 0.3, -- Sandy Shores
    ["BRADP"] = 0.1, -- Braddock Pass
    ["ELGORL"] = 0.1, -- Cape Catfish
    ["SANCHIA"] = 0.1, -- San Chianski Mountains
    ["HUMLAB"] = 0.9, -- Humane Labs
    ["LACT"] = 0.2, -- Land Act Reservoir
    ["LDAM"] = 0.2, -- Land Act Dam
    ["SKID"] = 1.0, -- Mission Row
    ["LEGSQU"] = 1.0, -- Legion Square
    ["BURTON"] = 0.3, -- Burton
    ["BANNING"] = 0.3, -- Banning
    ["STAD"] = 0.7, -- Maze Bank Arena
    ["OBSERV"] = 0.6, -- Galileo Observatory
    ["CHAMH"] = 0.2, -- Chamberlain Hills
    ["ZP_ORT"] = 0.4, -- Port of South LS
    ["NOOSE"] = 1.0, -- NOOSE HQ
    ["CCREAK"] = 0.2, -- Cassidy Creek
    ["CALAFB"] = 0.2, -- Calafia Bridge
    ["ISHEIST"] = 0.0, -- CAYO PERICO
    [""] = 0.3
}

-- RANDOM LOCAL NAMES FOR PLATES
firstNames = {
    "Jens",
    "Roscoe",
    "Isabelle",
    "Bradleigh",
    "Annalise",
    "Anna",
    "Alexander",
    "Haya",
    "Neha",
    "Joss",
    "Ross",
    "Daniela",
    "Audrey",
    "Aubrey",
    "Emilis",
    "Emma",
    "Kush",
    "Marcus",
    "Joseph",
    "Rachel",
    "Sid",
    "Leia",
    "Alastair",
    "Kathryn",
    "Malia",
    "Cindy",
    "Benjamin",
    "Edward",
    "Katherine",
    "Moses",
    "Nick",
    "Jonathan",
    "Hailey",
    "Bonnie",
    "James",
    "Joe",
    "Willey",
    "Russell",
    "Curtis",
    "Jamie",
    "Katie",
    "Kate",
    "Kristopher",
    "Chris",
    "Chance",
    "Lourdes",
    "Christian",
    "Sofia",
    "Sophia",
    "Victoria",
    "Mark",
    "Louis",
    "Lucas",
    "Robert",
    "Alistair",
    "Charlize",
    "Charlie",
    "Lily-Ann",
    "Lily",
    "Annie",
    "Deanna",
    "Ariya",
    "Gary",
    "Baxter",
    "Aidan",
    "Alia",
    "Ayla",
    "Manav",
    "Felix",
    "Kat",
    "Jennifer",
    "Jenny",
    "Jen",
    "Ella-Louise",
    "Ella",
    "Elsa",
    "Max",
    "Chloe",
    "Finn",
    "Alma",
    "Cassie",
    "Cassidy",
    "Ishika",
    "Vikki",
    "Vicky",
    "Alex",
    "Lamar",
    "Tyler",
    "Tye",
    "Scarlet",
    "Billie",
    "Elin",
    "Kelsie",
    "Kenzie",
    "Sidra",
    "Ronan",
    "Carl",
    "Cari",
    "Persephone",
    "Orla",
    "Elicia",
    "Kai",
    "Elaina",
    "Alaina",
    "Christina",
    "Christie",
    "Kira",
    "Riley",
    "Niyah",
    "Mitchell",
    "Jadine",
    "Jason",
    "Ryan",
    "Amiya",
    "Carrie",
    "Carrie-Ann",
    "Flora",
    "Rida",
    "Juliette",
    "Juliet",
    "Sasha",
    "Luke",
    "Ken",
    "Kacey",
    "Casey",
    "Kasey",
    "Reegan",
    "Nicholas",
    "Albert",
    "Maeve",
    "Chantelle",
    "Charly",
    "Joyce",
    "David",
    "Sofie",
    "Woodrow",
    "Abigayle",
    "Ellie",
    "Dennis",
    "Sarah",
    "Jim",
    "Jimbob",
    "Debbie",
    "Karen",
    "Sadie",
    "Alyssa",
    "Aaron",
    "Gail",
    "Sahra",
    "Cole",
    "Ruby",
    "Misha",
    "Tanner",
    "Becky",
    "Betsy",
    "Rayan",
    "Anand",
    "Tolga",
    "Bryn",
    "Britney",
    "Cara",
    "Kara",
    "Hayden",
    "Zishan",
    "Rida",
    "Sean",
    "Joely",
    "Jolene",
    "Teddy",
    "Ollie",
    "Oscar",
    "Oliver",
    "Abraham",
    "Abigail",
    "Otis",
    "Marek",
    "Shea",
    "Amelia",
    "Arabella",
    "Jia",
    "Edan",
    "Juan",
    "Diego",
    "Steve",
    "Angus",
    "Michelle",
    "Danyl",
    "Peyton",
    "Pharell",
    "Zac",
    "Emelie",
    "Zachary",
    "Zack",
    "Brenda",
    "Elizabeth",
    "Phillip",
    "Carla",
    "Chad",
    "Brett"
}

lastNames = {
    "Domico",
    "Wines",
    "Wells",
    "Penn",
    "Chase",
    "Fernandez",
    "Shepard",
    "Jackson",
    "Pugh",
    "Burt",
    "Irvine",
    "Mcphee",
    "Rodriguez",
    "Watson",
    "Matthews",
    "Prescott",
    "Terry",
    "Rudd",
    "Davey",
    "Burns",
    "Brooks",
    "Gilmore",
    "Mackenzie",
    "Elliott",
    "Crawford",
    "Griffin",
    "Rollins",
    "Hansen",
    "Diaz",
    "Price",
    "Jefferson",
    "Browne",
    "Blackwell",
    "Wallace",
    "Salas",
    "Cunningham",
    "Lancaster",
    "Medrano",
    "Ashton",
    "Barber",
    "Maynard",
    "Clifford",
    "Washington",
    "Dotson",
    "Hanson",
    "Ahmed",
    "Bowes",
    "Bowen",
    "Romero",
    "Subcleff",
    "Massey",
    "Mosset",
    "Knoll",
    "Quarterman",
    "Thach",
    "Whitnell",
    "Novack",
    "Gordon",
    "Hammond",
    "Almond",
    "Gomez",
    "Sawyer",
    "Robertson",
    "Horne",
    "Hilbourne",
    "Abbott",
    "Fisher",
    "Forrest",
    "Farrow",
    "Shaw",
    "Greene",
    "Banks",
    "Peterson",
    "Lamb",
    "Sinclair",
    "Fitzgerald",
    "Graves",
    "Finch",
    "Schneider",
    "Pearce",
    "Morales",
    "Lopez",
    "Reynolds",
    "Lee",
    "Delgado",
    "Larsen",
    "Benson",
    "Whitmore",
    "Gibson",
    "Beech",
    "Cobb",
    "Meadows",
    "Johnson",
    "Serrano",
    "Ashton",
    "Pollard",
    "Ramirez",
    "Wilson",
    "Patel",
    "Oakley",
    "Stafford",
    "Gonzalez",
    "O'Connor",
    "Whiteley",
    "Harris",
    "Mcmillan",
    "Stewart",
    "Connolly",
    "Schmitt",
    "Costello",
    "Barnes",
    "Stamper",
    "Campbell"
}
