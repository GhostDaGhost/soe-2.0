-- How high abovce entrance coords to spawn housing shell
shellVerticalOffset = 200.0
propertyList = {}

-- INTERIORS - NOT USED CURRENTLY
housingInteriors = {
    -- LOW END
    ["LOW_1"] = {ENTRANCE = {x = 266.08, y = -1007.52, z = -102.0086, h = 1.9}, instance = true}, -- Low end interior 1 (DEFAULT)

    -- VLOW END
    ["VLOW_1"] = {ENTRANCE = {x = 151.53, y = -1007.58, z = -99.9999, h = 346.95}, instance = true}, -- VLow end interior 1 (DEFAULT)

    -- MED
    ["MED_1"] = {ENTRANCE = {x = 346.45, y = -1013.03, z = -100.20, entH = 347.77}, instance = true}, -- Mid end interior 1 (DEFAULT)

    -- HOUSE
    ["HOUSE_1"] = {ENTRANCE = {x = -174.31, y = 497.53, z = 136.67, entH = nil}, instance = true},
    ["HOUSE_2"] = {ENTRANCE = {x = 341.64, y = 437.69, z = 148.39, entH = nil}, instance = true},
    ["HOUSE_3"] = {ENTRANCE = {x = -682.33, y = 592.47, z = 144.39, entH = nil}, instance = true},
    ["HOUSE_4"] = {ENTRANCE = {x = -758.67, y = 618.98, z = 143.15, entH = nil}, instance = true},

    -- HOUSE2
    ["HOUSE2_1"] = {ENTRANCE = {x = 373.61, y = 423.56, z = 144.91, entH = nil}, instance = true},
    ["HOUSE2_2"] = {ENTRANCE = {x = -859.78, y = 690.95, z = 151.86, entH = nil}, instance = true},
    ["HOUSE2_3"] = {ENTRANCE = {x = -572.00, y = 661.68, z = 144.84, entH = nil}, instance = true},
    ["HOUSE2_4"] = {ENTRANCE = {x = 117.27, y = 559.77, z = 183.30, entH = nil}, instance = true},
    ["HOUSE2_5"] = {ENTRANCE = {x = -1289.78, y = 449.40, z = 96.90, entH = nil}, instance = true},

    -- Appartments
    ["WECPLISEAPT_1"] = {ENTRANCE = {x = -787.248, y = 315.680, z = 187.913}, instance = true},
    ["WECPLISEAPT_2"] = {ENTRANCE = {x = -773.885, y = 342.013,  z = 196.686}, instance = true},
    ["WECPLISEAPT_3"] = {ENTRANCE = {x = -781.977, y = 325.327, z = 176.803}, instance = true},
    ["HAWICKAPT_1"] = {ENTRANCE = {x = -603.831, y = 58.761, z = 98.200}, instance = true},

    -- UN ORGANIZED
    ["LEFUENTEBLANCA"] = {ENTRANCE={x = 1397.33056640625, y = 1142.05017089844, z = 114.33358764648400}}, -- La Fuenta Blac
	["ALTAAPT_1"] = {ENTRANCE={x = -270.538421630859, y = -940.73974609375, z = 92.51094818115230}}, -- N
	["INTEGRITYAPT_1"] = {ENTRANCE={x = -30.8175601959229, y = -595.315246582031, z = 80.0308914184570}}, -- Luxury Appt B
	["INTEGRITYAPT_2"] = {ENTRANCE={x = -18.1004009246826, y = -590.620544433594, z = 90.1148223876953}}, -- Luxury Appt A
	["WECPLISEAPT_4"] = {ENTRANCE={x = -784.695556640625, y = 323.346374511719, z = 211.9971923828130}}, -- Luxury Appt B
	["BAYCITYOFFICE_1"] = {ENTRANCE={x = -1910.099609375, y = -574.97265625, z = 19.095603942871100}}, -- Office A [Don't Instance]
	["MARATHONAPT_1"] = {ENTRANCE={x = -1452.44152832031, y = -540.203552246094, z = 74.0443572998047}}, -- Luxury Appt B
	["MARATHONAPT_2"] = {ENTRANCE={x = -1450.5263671875, y = -525.1552734375, z = 69.5566940307617000}}, -- Luxury Appt A
	["MARATHONAPT_3"] = {ENTRANCE={x = -1450.43359375, y = -525.057312011719, z = 56.9289970397949000}}, -- Luxury Appt A
	["HERITAGEAPT_1"] = {ENTRANCE={x = -912.898193359375, y = -365.340240478516, z = 114.274772644043}}, -- Luxury Appt B
	["HERITAGEAPT_2"] = {ENTRANCE={x = -907.419128417969, y = -371.880340576172, z = 109.440345764160}}, -- Luxury Appt A
	["ALTAAPT_2"] = {ENTRANCE={x = -273.04342651367, y = -967.24877929688, z = 77.231292724609}}, -- Luxury Appt A
	["ALTAOFFICE_1"] = {ENTRANCE={x = -140.62544250488, y = -619.04968261719, z = 168.8205871582}}, -- Office Appt A
	["POWEROFFICE_1"] = {ENTRANCE={x = -77.211631774902, y = -828.33227539063, z = 243.38598632813}}, -- Office Appt B
	["DELPERROOFFICE_1"] = {ENTRANCE={x = -1579.6840820313, y = -563.00817871094, z = 108.52292633057}}, -- Office Appt C
	["NORTHROCKFORDOFFICE_1"] = {ENTRANCE={x = -1394.5775146484, y = -479.63912963867, z = 72.042068481445}}, -- Office Appt D
	['73'] = {ENTRANCE={x = 1972.456,          y = 3817.181,        z = 33.42873}}, -- Trevor's Trailer
}

-- SHELLS - CURRENTLY USED
shellData = {
    -- TRAILER - USE FOR ANY TRAILER HOMES
    ["shell_trailer"] = {
        ["doorOffset"] = {x=-1.452,y=-1.928,z=2.166},
        ["heading"] = 356.72
    },

    -- LARGE RUSTIC HOUSE - LA FUENTA BLANC?
    ["shell_ranch"] = {
        ["doorOffset"] = {x=-0.706,y=-5.325,z=2.403},
        ["heading"] = 273.95
    },

    -- MID-SIZED HOUSE
    ["shell_frankaunt"] = {
        ["doorOffset"] = {x = -0.228, y = -5.548, z = 1.714},
        ["heading"] = 355.75
    },

    -- SMALL CLASS 1A
    ["shell_v16low"] = {
        ["doorOffset"] = {x=4.6,y=-6.439,z=1.0},
        ["heading"] = 355.21
    },
    -- SMALL CLASS 1B
    ["shell_lester"] = {
        ["doorOffset"] = {x=-1.527,y=-5.783,z=1.108},
        ["heading"] = 0.72
    },
    -- SMALL CLASS 2
    ["shell_v16mid"] = {
        ["doorOffset"] = {x=1.020,y=-14.200,z=1.4},
        ["heading"] = 356.72
    },
    -- SMALL CLASS 3A
    ["shell_trevor"] = {
        ["doorOffset"] = {x=0.020,y=-3.425,z=1.4},
        ["heading"] = 356.72
    },
    -- SMALL CLASS 3B
    ["shell_medium2"] = {
        ["doorOffset"] = {x = 6.070, y = 0.615, z = 1.027},
        ["heading"] = 8.03
    },

    -- MEDIUM CLASS 1
    ["shell_highendv2"] = {
        ["doorOffset"] = {x=-8.82,y=0.183,z=6.5},
        ["heading"] = 180.72
    },
    -- MEDIUM CLASS 2
    ["shell_highend"] = {
        ["doorOffset"] = {x=-20.020,y=-0.425,z=7.4},
        ["heading"] = 356.72
    },

    -- LARGE CLASS 1A
    ["shell_apartment1"] = {
        ["doorOffset"] = {x=-2.693,y=8.341,z=8.298},
        ["heading"] = 175.63
    },
    -- LARGE CLASS 1B
    ["shell_apartment2"] = {
        ["doorOffset"] = {x=-2.693,y=8.341,z=8.298},
        ["heading"] = 175.63
    },
    -- LARGE CLASS 2
    ["shell_apartment3"] = {
        ["doorOffset"] = {x=11.754,y=4.311,z=7.22},
        ["heading"] = 124.67
    },
    -- LARGE CLASS 3
    ["shell_banham"] = {
        ["doorOffset"] = {x = -3.572, y= -1.513, z = 6.255},
        ["heading"] = 86.84
    },


    ["shell_office1"] = {
        ["doorOffset"] = {x=0.020,y=-3.425,z=7.4},
        ["heading"] = 356.72
    },
    ["shell_office2"] = {
        ["doorOffset"] = {x=3.606,y=-1.951,z=1.267},
        ["heading"] = 87.41
    },
    ["shell_officebig"] = {
        ["doorOffset"] = {x=0.020,y=-3.425,z=7.4},
        ["heading"] = 356.72
    },
    ["shell_coke1"] = {
        ["doorOffset"] = {x=0.020,y=-3.425,z=7.4},
        ["heading"] = 356.72
    },
    ["shell_coke2"] = {
        ["doorOffset"] = {x=0.020,y=-3.425,z=7.4},
        ["heading"] = 356.72
    },
    ["shell_meth"] = {
        ["doorOffset"] = {x=0.020,y=-3.425,z=7.4},
        ["heading"] = 356.72
    },
    ["shell_weed"] = {
        ["doorOffset"] = {x=0.020,y=-3.425,z=7.4},
        ["heading"] = 356.72
    },
    ["shell_weed2"] = {
        ["doorOffset"] = {x=0.020,y=-3.425,z=7.4},
        ["heading"] = 356.72
    },
}

-- ACCESS TYPE IDS AND NAMES
accessTypes = {
    [0] = "OWNER",
    [1] = "TENANT",
    [2] = "GUEST",
    [3] = "NONE"
}

RegisterCommand('offseth', function(src, args)
    local entrancePos = GetCurrentProperty().entrance
    local newZ = entrancePos.z + 200.0
    local pos = GetEntityCoords(PlayerPedId())

    local xDiff = pos.x - entrancePos.x
    local yDiff = pos.y - entrancePos.y
    local zDiff = pos.z - newZ
    TriggerEvent("Chat:Client:SendMessage", "properties", string.format(
        "Offset: X: ^3%s ^7Y: ^3%s ^7Z: ^3%s", xDiff, yDiff, zDiff
    ))
end, false)