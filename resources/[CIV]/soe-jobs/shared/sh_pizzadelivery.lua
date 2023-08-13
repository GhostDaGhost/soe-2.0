-- PIZZERIAS TO START/END JOB
pizzerias = {
    {
        name = "atleestreet_pizzeria",
        pos = vector3(284.62, -963.47, 29.41),
        length = 1.8,
        width = 2.2,
        options = {name = "atleestreet_pizzeria", heading = 0, minZ = 27.42, maxZ = 31.42, data = {
            spawn = vector4(284.48, -959.82, 29.41, 325.98), marker = vector3(284.62, -963.47, 29.41)
        }}
    },
    {
        name = "spanishave_pizzeria",
        pos = vector3(215.03, -18.03, 74.99),
        length = 2.8,
        width = 2.8,
        options = {name = "spanishave_pizzeria", heading = 340, minZ = 72.99, maxZ = 76.99, data = {
            spawn = vector4(211.75, -24.98, 69.69, 160.32), marker = vector3(215.03, -18.03, 74.99)
        }}
    },
    {
        name = "meteorst_pizzeria_1",
        pos = vector3(538.12, 101.13, 96.48),
        length = 2.2,
        width = 2.6,
        options = {name = "meteorst_pizzeria_1", heading = 340, minZ = 94.53, maxZ = 98.53, data = {
            spawn = vector4(534.23, 105.34, 96.55, 76.22), marker = vector3(538.37, 101.75, 96.53)
        }}
    },
    {
        name = "meteorst_pizzeria_2",
        pos = vector3(485.97, 68.2, 96.08),
        length = 3.0,
        width = 2.8,
        options = {name = "meteorst_pizzeria_2", heading = 7, minZ = 94.88, maxZ = 98.88, data = {
            spawn = vector4(480.82, 74.66, 96.82, 332.46), marker = vector3(485.21, 68.08, 96.02)
        }}
    },
    {
        name = "delperro_pizzeria",
        pos = vector3(-1529.89, -909.5, 10.14),
        length = 2.6,
        width = 1.8,
        options = {name = "delperro_pizzeria", heading = 320, minZ = 8.14, maxZ = 12.14, data = {
            spawn = vector4(-1524.83, -914.69, 10.15, 141.93), marker = vector3(-1529.41, -908.9, 10.17)
        }}
    },
}

-- LIST OF POSSIBLE PIZZA DELIVERY DESTINATIONS
pizzaDeliveryDestinations = {
    -- MISSION ROW PD
    [1] = {msg = "We got a delivery to Mission Row PD. An officer just got promoted and the Chief is ordering pizza.", pos = vector3(440.71, -981.52, 30.69)},
    -- MIRROR PARK BLVD #5
    [2] = {msg = "Address is Mirror Park Blvd #5. Got a house party going on there.", pos = vector3(1203.59, -598.6, 68.06)},
    -- CHAMBERLAIN HILLS
    [3] = {msg = "Apartment #1 at Chamberlain Hills. Careful down there, don't get shot. If you need to, use the tomato sauce to fake blood loss.", pos = vector3(-209.02, -1600.75, 34.87)},
    -- 3 ALTA STREET
    [4] = {msg = "The hotel at 3 Alta Street. I still don't understand why we put pineapple on pizza.", pos = vector3(-267.66, -958.87, 31.22)},
    -- ALTA BANNER HOTEL
    [5] = {msg = "You got a delivery at the Banner Hotel on Alta. There's a high school graduation party happening indoors.", pos = vector3(-286.58, -1061.77, 27.21)},
    -- VANILLA UNICORN
    [6] = {msg = "The Vanilla Unicorn dancers are done for the night and are hungry, deliver their 3 cheese pizzas quickly, you might get a huge tip.", pos = vector3(128.48, -1285.77, 29.28)},
    -- CONQUISTADOR ST.
    [7] = {msg = "Got an order from Conquistador St in Vespucci Beach. Heard it's nice and hot out there.", pos = vector3(-1351.39, -1128.6, 4.13)},
    -- TINSEL TOWERS
    [8] = {msg = "Tinsel Towers! Pepperoni pizza for someone over there!", pos = vector3(-636.16, 44.15, 42.7)},
    -- PINK CAGE MOTEL #17
    [9] = {msg = "Got somebody at room #17 wanting a pizza at the Pink Cage Motel.", pos = vector3(313.48, -198.27, 58.02)},
    -- ALTA POSTOP
    [10] = {msg = "Post Ops Couriers on Alta Street and Vespucci Blvd are having a party. Deliver their meats trio pizza to the desk.", pos = vector3(-232.39, -914.96, 32.31)},
    -- INTEGRITY APARTMENTS
    [11] = {msg = "Integrity Apartments on Elgin Ave and Integrity Way. Room 240 needs you to deliver their food in a hurry. Husband burnt the food and the kids are yelling that they are hungry.", pos = vector3(267.84, -640.18, 42.02)},
    -- UPPER PILLBOX HOSPITAL
    [12] = {msg = "Upper Pillbox Hospital on Elgin Ave and Integrity. The head doctor notices everyone pulling extra long shifts, take this pineapple pizza to the front desk.", pos = vector3(308.92, -591.88, 43.28)},
    -- OCCUPATION AVE COURTHOUSE
    [13] = {msg = "The judges at the courthouse on Occupation Ave and Elgin just had a long case with some moron. They are starving and grumpy, better hurry up before they throw you in jail for making them wait. Delivery it to the reception right inside the door.", pos = vector3(237.61, -415.44, 47.95)},
    -- ALTA ST AND OCCUPATION APARTMENTS
    [14] = {msg = "Stop standing around and deliver this pizza to the construction workers at their apartment on Alta St and Occupation! Lazy drivers I tell ya.", pos = vector3(-30.68, -347.03, 46.53)},
    -- GINGER STREET AND SAN ANDREAS AVE CHURCH
    [15] = {msg = "The church on Ginger Street and San Andreas Ave are having an after Sunday School pizza party, please deliver their pizza quickly.", pos = vector3(-758.93, -709.19, 30.06)},
    -- WEAZEL NEWS HQ
    [16] = {msg = "Weazel News on Palomino Ave and Lindsay Circus wants anchovy pizza, who'd want one of these things?? Can you get this nasty thing over to them quickly?", pos = vector3(-594.37, -930.6, 23.87)},
    -- MELANOMA STREET SMOKE ON THE WATER
    [17] = {msg = "Smoke on the Water on Melanoma Street is hungry, they want a 7 cheese with sausage pizza. Rush this over to them before they make brownies!", pos = vector3(-1169.08, -1573.05, 4.66)},
    -- ROB'S LIQUOR SAN ANDREAS AVE AND BAY CITY AVE
    [18] = {msg = "The Rob's Liquor store employee on San Andreas Ave and Bay City Ave is sick of eating their disgusting food they sell, please save the poor soul from it. Deliver Tuna pizza to them quickly.", pos = vector3(-1222.31, -906.9, 12.33)},
    -- DIONYSIA THEATRE PROSPERITY STREET PROMENADE
    [19] = {msg = "The Dionysia Theatre on Prosperity Street Promenade is having an employee birthday party. Quick!! Rush over their Hawaiian pizza cause its the best out there.", pos = vector3(-1276.17, -687.8, 24.65)},
    -- BAHAMA MAMAS
    [20] = {msg = "Bahama Mamas' managers are having a huge party they need to cater later tonight, they need something to eat before it starts. Get them fed quickly.", pos = vector3(-1389.22, -592.0, 30.32)}
}
