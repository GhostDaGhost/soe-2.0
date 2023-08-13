-- CREATES POLYZONES FOR CLOTHING/BARBER/TATTOO SHOPS
function CreateZones()
    -- CLOTHING STORES
    exports["soe-utils"]:AddBoxZone("Clothing_Paleto", vector3(5.33, 6513.38, 31.88), 14.4, 13.0, {
        name = "Clothing_Paleto",
        heading = 313,
        minZ = 29.48,
        maxZ = 34.08,
        data = {
            name = "Discount Clothing",
            loc = "Paleto Blvd",
            type = "lowclothing"
        }
    })
    exports["soe-utils"]:AddBoxZone("Clothing_Grapeseed", vector3(1693.4, 4823.7, 42.07), 14.4, 13.0, {
        name = "Clothing_Grapeseed",
        heading = 8,
        data = {
            name = "Discount Clothing",
            loc = "Grapeseed Main",
            type = "lowclothing"
        }
    })
    exports["soe-utils"]:AddBoxZone("Clothing_Route68", vector3(1195.54, 2710.08, 38.23), 14.4, 13.0, {
        name = "Clothing_Route68",
        heading = 270,
        minZ = 37.23,
        maxZ = 41.23,
        data = {
            name = "Discount Clothing",
            loc = "Route 68",
            type = "lowclothing"
        }
    })
    exports["soe-utils"]:AddBoxZone("Clothing_Harmony", vector3(616.91, 2761.2, 42.09), 17.8, 9.0, {
        name = "Clothing_Harmony",
        heading = 3,
        minZ = 41.14,
        maxZ = 44.94,
        data = {
            name = "Suburban",
            loc = "Harmony",
            type = "midclothing"
        }
    })
    exports["soe-utils"]:AddBoxZone("Clothing_Zancudo", vector3(-1101.99, 2709.55, 19.11), 14.4, 13.0, {
        name = "Clothing_Zancudo",
        heading = 312,
        minZ = 13.16,
        maxZ = 21.36,
        data = {
            name = "Discount Clothing",
            loc = "Route 68",
            type = "lowclothing"
        }
    })
    exports["soe-utils"]:AddBoxZone("Clothing_Chumash", vector3(-3172.6, 1046.59, 20.86), 17.8, 9.0, {
        name = "Clothing_Chumash",
        heading = 337,
        minZ = 19.86,
        maxZ = 23.86,
        data = {
            name = "Suburban",
            loc = "Chumash",
            type = "midclothing"
        }
    })
    exports["soe-utils"]:AddBoxZone("Clothing_CougarAve", vector3(-1450.05, -237.99, 49.8), 16.4, 14.0, {
        name = "Clothing_CougarAve",
        heading = 318,
        minZ = 48.2,
        maxZ = 52.2,
        data = {
            name = "Ponsonbys",
            loc = "Cougar Ave",
            type = "highclothing"
        }
    })
    exports["soe-utils"]:AddBoxZone("Clothing_SanAndreasAve", vector3(-1193.69, -771.72, 17.32), 17.8, 9.2, {
        name = "Clothing_SanAndreasAve",
        heading = 305,
        minZ = 15.32,
        maxZ = 19.32,
        data = {
            name = "Suburban",
            loc = "Prosperity St",
            type = "midclothing"
        }
    })
    exports["soe-utils"]:AddBoxZone("Clothing_SouthRockfordDrive", vector3(-823.08, -1074.3, 11.34), 14.4, 13.0, {
        name = "Clothing_SouthRockfordDrive",
        heading = 300,
        minZ = 9.54,
        maxZ = 13.54,
        data = {
            name = "Binco",
            loc = "South Rockford Drive",
            type = "lowclothing"
        }
    })
    exports["soe-utils"]:AddBoxZone("Clothing_PortolaDrive", vector3(-709.42, -153.53, 37.42), 16.4, 14.0, {
        name = "Clothing_PortolaDrive",
        heading = 30,
        minZ = 36.22,
        maxZ = 40.22,
        data = {
            name = "Ponsonbys",
            loc = "Portola Drive",
            type = "highclothing"
        }
    })
    exports["soe-utils"]:AddBoxZone("Clothing_LasLagunasBlvd", vector3(-163.67, -303.02, 39.73), 16.4, 14.0, {
        name = "Clothing_LasLagunasBlvd",
        heading = 341,
        minZ = 38.13,
        maxZ = 42.13,
        data = {
            name = "Ponsonbys",
            loc = "Las Lagunas Blvd",
            type = "highclothing"
        }
    })
    exports["soe-utils"]:AddBoxZone("Clothing_HawickAve", vector3(124.04, -220.22, 54.56), 17.8, 9.2, {
        name = "Clothing_HawickAve",
        heading = 340,
        minZ = 52.56,
        maxZ = 56.56,
        data = {
            name = "Suburban",
            loc = "Hawick Ave",
            type = "midclothing"
        }
    })
    exports["soe-utils"]:AddBoxZone("Clothing_TextileCity", vector3(425.17, -805.26, 29.5), 14.4, 13.0, {
        name = "Clothing_TextileCity",
        heading = 0,
        minZ = 27.7,
        maxZ = 31.7,
        data = {
            name = "Binco",
            loc = "Sinner St",
            type = "lowclothing"
        }
    })
    exports["soe-utils"]:AddBoxZone("Clothing_InnocenceBlvd", vector3(75.53, -1394.03, 29.38), 14.4, 13.0, {
        name = "Clothing_InnocenceBlvd",
        heading = 0,
        minZ = 27.58,
        maxZ = 31.58,
        data = {
            name = "Discount Clothing",
            loc = "Innocence Blvd",
            type = "lowclothing"
        }
    })
    exports["soe-utils"]:AddBoxZone("Clothing_DiamondCasino", vector3(1102.57, 198.46, -49.44), 5.0, 7.4, {
        name = "Clothing_DiamondCasino",
        heading = 313,
        minZ = -50.84,
        maxZ = -46.84,
        data = {
            name = "Ponsonbys",
            loc = "Diamond Casino",
            type = "highclothing"
        }
    })
    exports["soe-utils"]:AddBoxZone("Clothing_VanillaUnicorn", vector3(105.31, -1303.32, 28.79), 5.0, 5.0, {
        name = "Clothing_VanillaUnicorn",
        heading = 312,
        minZ = 22.84,
        maxZ = 34.74,
        data = {
            name = "Vanilla Unicorn",
            loc = "Elgin Ave",
            type = "lowclothing",
            perms = {"VUCLOTHING"}
        }
    })
    exports["soe-utils"]:AddBoxZone("Clothing_BeanMachine", vector3(-634.54, 227.02, 81.87), 2.0, 2.0, {
        name = "Clothing_BeanMachine",
        heading = 312,
        minZ = 79.87,
        maxZ = 83.87,
        data = {
            name = "Bean Machine",
            loc = "West Eclipse Blvd",
            type = "lowclothing",
            perms = {"BMCLOTHING"}
        }
    })
    exports["soe-utils"]:AddBoxZone("Clothing_AutoExotic", vector3(550.24, -182.22, 54.49), 3.0, 3.0, {
        name = "Clothing_AutoExotic",
        heading = 0,
        minZ = 52.09,
        maxZ = 56.09,
        data = {
            name = "Auto Exotic",
            loc = "Elgin Ave",
            type = "lowclothing",
            perms = {"AECLOTHING"}
        }
    })
    exports["soe-utils"]:AddBoxZone("Clothing_ORyanAutoCare", vector3(956.89, -966.36, 39.51), 1.5, 1.3, {
        name = "Clothing_ORyanAutoCare",
        heading = 4,
        minZ = 36.71,
        maxZ = 40.71,
        data = {
            name = "O'Ryan Autocare",
            loc = "Vesp. Blvd",
            type = "lowclothing",
            perms = {"OACLOTHING"}
        }
    })
    exports["soe-utils"]:AddBoxZone("Clothing_Bolingbroke", vector3(1764.58, 2581.04, 45.79), 3.5, 3.5, {
        name = "Clothing_Bolingbroke",
        heading = 93.56,
        minZ = 44.79,
        maxZ = 46.79,
        data = {
            name = "Bolingbroke",
            loc = "Route 68",
            type = "lowclothing"
        }
    })
    exports["soe-utils"]:AddBoxZone("Clothing_TLMCCustomsAndTow", vector3(992.49, -135.89, 74.05), 2.0, 2.0, {
        name = "Clothing_TLMCCustomsAndTow",
        heading = 327.77,
        minZ = 72.05,
        maxZ = 76.05,
        data = {
            name = "TLMC Customs and Tow",
            loc = "Mirror Park Blvd",
            type = "lowclothing",
            perms = {"LMCLOTHING"}
        }
    })
    exports["soe-utils"]:AddBoxZone("Clothing_Bento", vector3(-173.27, 305.92, 100.91), 2.0, 2.0, {
        name = "Clothing_Bento",
        heading = 192.95,
        minZ = 99.91,
        maxZ = 101.91,
        data = {
            name = "Bento",
            loc = "Eclipse Blvd",
            type = "lowclothing",
            perms = {"BTCLOTHING"}
        }
      })
    exports["soe-utils"]:AddBoxZone("Clothing_GovenorsOffice", vector3(-541.54, -192.88, 47.41), 2.0, 2.0, {
        name = "Clothing_GovenorsOffice",
        heading = 300.52,
        minZ = 46.41,
        maxZ = 48.41,
        data = {
            name = "Govenor's Offices",
            loc = "Carcer Way",
            type = "highclothing",
            perms = {"GOCLOTHING"}
        }
    })
    exports["soe-utils"]:AddBoxZone("Clothing_WeazelNews", vector3(-584.77, -938.70, 23.85), 1.5, 1.5, {
        name = "Clothing_WeazelNews",
        heading = 174.32,
        minZ = 22.85,
        maxZ = 24.85,
        data = {
            name = "Weazel News",
            loc = "Lindsay Circus",
            type = "highclothing",
            perms = {"WNCLOTHING"}
        }
    })
    exports["soe-utils"]:AddBoxZone("Clothing_ReflectionsAutocare", vector3(1132.44, -778.96, 57.60), 1.5, 1.5, {
        name = "Clothing_ReflectionsAutocare",
        heading = 356.41,
        minZ = 56.60,
        maxZ = 58.60,
        data = {
            name = "Reflections Autocare",
            loc = "West Mirror Drive",
            type = "lowclothing",
            perms = {"RACLOTHING"}
        }
    })
    exports["soe-utils"]:AddBoxZone("Clothing_LondonCustoms", vector3(-41.78, -1064.23, 28.39), 1.5, 1.5, {
        name = "Clothing_LondonCustoms",
        heading = 74.82,
        minZ = 27.39,
        maxZ = 29.39,
        data = {
            name = "London Customs",
            loc = "Power St",
            type = "lowclothing",
            perms = {"LCCLOTHING"}
        }
    })
    exports["soe-utils"]:AddBoxZone("Clothing_HenHouse", vector3(-295.28, 6261.65, 25.08), 1.5, 1.5, {
        name = "Clothing_HenHouse",
        heading = 50.82,
        minZ = 24.08,
        maxZ = 26.08,
        data = {
            name = "Hen House",
            loc = "Paleto Blvd",
            type = "lowclothing",
            perms = {"HHCLOTHING"}
        }
    })
    exports["soe-utils"]:AddBoxZone("Clothing_PrestigeAuto", vector3(-345.22, -122.99, 39.01), 1.5, 1.5, {
        name = "Clothing_PrestigeAuto",
        heading = 75.63,
        minZ = 38.01,
        maxZ = 40.01,
        data = {
            name = "Prestige Auto",
            loc = "Carcer Way",
            type = "lowclothing",
            perms = {"PACLOTHING"}
        }
    })
    exports["soe-utils"]:AddBoxZone("Clothing_HavenResortAndSpa", vector3(-2983.32, 55.17, 11.60), 3.5, 3.5, {
        name = "Clothing_HavenResortAndSpa",
        heading = 243.46,
        minZ = 10.60,
        maxZ = 12.60,
        data = {
            name = "Haven Resort & Spa",
            loc = "Great Ocean Highway",
            type = "lowclothing",
            perms = {"HSCLOTHING"}
        }
    })

    -- BARBERSHOPS
    exports["soe-utils"]:AddBoxZone("Barber_Paleto", vector3(-278.88, 6227.9, 31.7), 6.0, 9.2, {
        name = "Barber_Paleto",
        heading = 314,
        minZ = 30.7,
        maxZ = 34.7,
        data = {
            name = "Herr Kutz",
            loc = "Paleto Blvd",
            type = "barber"
        }
    })
    exports["soe-utils"]:AddBoxZone("Barber_SandyShores", vector3(1931.98, 3730.46, 32.84), 5.4, 9.2, {
        name = "Barber_SandyShores",
        heading = 299,
        minZ = 20.69,
        maxZ = 34.89,
        data = {
            name = "O'Sheas",
            loc = "Alhambra Dr",
            type = "barber"
        }
    })
    exports["soe-utils"]:AddBoxZone("Barber_MagellanAve", vector3(-1282.97, -1117.71, 6.99), 5.4, 9.2, {
        name = "Barber_MagellanAve",
        heading = 0,
        minZ = 4.99,
        maxZ = 8.99,
        data = {
            name = "Beach Combover",
            loc = "Magellan Ave",
            type = "barber"
        }
    })
    exports["soe-utils"]:AddBoxZone("Barber_MadWayneThunder", vector3(-814.01, -184.22, 37.57), 9.2, 6.8, {
        name = "Barber_MadWayneThunder",
        heading = 300,
        minZ = 35.97,
        maxZ = 39.97,
        data = {
            name = "Bob Mulet",
            loc = "Mad Wayne Thunder",
            type = "barber"
        }
    })
    exports["soe-utils"]:AddBoxZone("Barber_HawickAve", vector3(-33.14, -152.02, 57.08), 5.4, 9.2, {
        name = "Barber_HawickAve",
        heading = 70,
        minZ = 55.08,
        maxZ = 59.08,
        data = {
            name = "Hair on Hawick",
            loc = "Hawick Ave",
            type = "barber"
        }
    })
    exports["soe-utils"]:AddBoxZone("Barber_MirrorPark", vector3(1212.1, -473.11, 66.21), 5.4, 9.2, {
        name = "Barber_MirrorPark",
        heading = 345,
        minZ = 64.21,
        maxZ = 68.21,
        data = {
            name = "Herr Kutz",
            loc = "Mirror Park",
            type = "barber"
        }
    })
    exports["soe-utils"]:AddBoxZone("Barber_CarsonAve", vector3(137.35, -1708.06, 29.29), 5.4, 9.2, {
        name = "Barber_CarsonAve",
        heading = 50,
        minZ = 27.09,
        maxZ = 31.09,
        data = {
            name = "Herr Kutz",
            loc = "Carson Ave",
            type = "barber"
        }
    })

    exports["soe-utils"]:AddBoxZone("char_creator", vector3(402.83, -996.83, -99.0), 1.6, 2.6, {
        name = "char_creator",
        heading = 0,
        minZ = -100.95,
        maxZ = -97.35
    })

    -- TATTOO PARLORS
    exports["soe-utils"]:AddBoxZone("Tattoo_Innocence", vector3(1323.0, -1652.8, 52.28), 4.2, 6.8, {name = "Tattoo_Innocence", heading = 40, minZ = 51.95, maxZ = 53.95})
    exports["soe-utils"]:AddBoxZone("Tattoo_AgujaStreet", vector3(-1154.29, -1426.76, 4.95), 4.8, 7.2, {name = "Tattoo_AgujaStreet", heading = 32, minZ = 3.95, maxZ = 7.95})
    exports["soe-utils"]:AddBoxZone("Tattoo_Vinewood", vector3(323.34, 180.65, 103.59), 5.2, 6.4, {name = "Tattoo_Vinewood", heading = 337, minZ = 102.24, maxZ = 106.64})
    exports["soe-utils"]:AddBoxZone("Tattoo_Chumash", vector3(-3170.18, 1076.27, 20.83), 7.0, 4.8, {name = "Tattoo_Chumash", heading = 335, minZ = 19.83, maxZ = 24.03})
    exports["soe-utils"]:AddBoxZone("Tattoo_Paleto", vector3(-294.15, 6200.0, 31.49), 5.1, 4.6, {name = "Tattoo_Paleto", heading = 42, minZ = 30.49, maxZ = 34.49})
    exports["soe-utils"]:AddBoxZone("Tattoo_Sandy", vector3(1864.27, 3747.97, 33.03), 5.1, 4.6, {name = "Tattoo_Sandy", heading = 209})
end
