securityVehicles = {}
securityOffices = {}
securitySites = {}

securityVehicles[#securityVehicles + 1] = {
    ["model"] = "dilettante2",
    ["vehType"] = "sedan"
}

securityVehicles[#securityVehicles + 1] = {
    ["model"] = "gresley2",
    ["vehType"] = "suv"
}

securityOffices[#securityOffices + 1] = {
    ["pos"] = vector3(109.44, -1090.43, 29.3),
    ["vehSpawn"] = vector4(111.33, -1081.18, 28.69, 339.53)
}

securityOffices[#securityOffices + 1] = {
    ["pos"] = vector3(-228.23, 6332.9, 32.42),
    ["vehSpawn"] = vector4(-222.91, 6341.72, 31.85, 315.25)
}

securitySites[#securitySites + 1] = {
    ["name"] = "The Maze Bank Arena",
    ["vehType"] = "sedan",
    ["description"] = "Patrol the arena exterior. Check all exterior entrances and check in with all parking guard booths.",
    ["checkpoints"] = {
        [1] = {pos = vector3(-198.68, -1941.13, 27.62), type = "veh"},
        [2] = {pos = vector3(-286.71, -1920.00, 29.95), type = "foot"},
        [3] = {pos = vector3(-253.80, -1992.19, 30.15), type = "foot"},
        [4] = {pos = vector3(-362.09, -2017.31, 29.95), type = "foot"},
        [5] = {pos = vector3(-394.09, -1909.94, 29.95), type = "foot"},
        [6] = {pos = vector3(-255.43, -2088.25, 27.11), type = "veh"},
        [7] = {pos = vector3(-72.54, -1999.94, 17.51), type = "veh"},
        [8] = {pos = vector3(-37.29, -2092.31, 16.20), type = "veh"},
        [9] = {pos = vector3(-166.26, -2149.55, 16.20), type = "veh"}
    }
}

securitySites[#securitySites + 1] = {
    ["name"] = "Los Santos International Airport",
    ["vehType"] = "sedan",
    ["description"] = "Patrol the airport facilities. Check in with all guard booths and confirm all parking lots are secure.",
    ["checkpoints"] = {
        [1] = {pos = vector3(-994.41, -2423.66, 13.39), type = "veh"},
        [2] = {pos = vector3(-1015.44, -2598.90, 38.60), type = "veh"},
        [3] = {pos = vector3(-1118.72, -2688.34, 13.45), type = "veh"},
        [4] = {pos = vector3(-953.37, -2780.37, 13.46), type = "veh"},
        [5] = {pos = vector3(-933.99, -2646.31, 38.60), type = "veh"},
        [6] = {pos = vector3(-933.45, -2549.82, 13.53), type = "veh"}
    }
}

securitySites[#securitySites + 1] = {
    ["name"] = "The Redwood Lights Track",
    ["vehType"] = "suv",
    ["description"] = "The construction company has hired us to ensure their equipment is secure at the track. Patrol the area and please go easy on the vehicle.",
    ["checkpoints"] = {
        [1] = {pos = vector3(1162.27, 2127.13, 54.76), type = "veh"},
        [2] = {pos = vector3(1217.99, 2392.84, 65.43), type = "veh"},
        [3] = {pos = vector3(1029.99, 2487.95, 48.84), type = "veh"},
        [4] = {pos = vector3(878.92, 2347.10, 51.18), type = "veh"}
    }
}

securitySites[#securitySites + 1] = {
    ["name"] = "The Lago Zancudo Racing Facility",
    ["vehType"] = "sedan",
    ["description"] = "Patrol the racing facility and surrounding training facilities to ensure they are secure. Check in with all guard booths. No racing the car!",
    ["checkpoints"] = {
        [1] = {pos = vector3(-1588.47, 2798.53, 16.38), type = "veh"},
        [2] = {pos = vector3(-1711.12, 3007.35, 32.51), type = "veh"},
        [3] = {pos = vector3(-2245.31, 3319.46, 32.32), type = "veh"},
        [4] = {pos = vector3(-1792.04, 3146.62, 32.35), type = "veh"},
        [5] = {pos = vector3(-2602.21, 3320.74, 32.30), type = "veh"},
        [6] = {pos = vector3(-2300.44, 3389.47, 30.52), type = "veh"},
        [7] = {pos = vector3(-2448.75, 3653.17, 13.65), type = "veh"}
    }
}

securitySites[#securitySites + 1] = {
    ["name"] = "The Paleto Forest Sawmill",
    ["vehType"] = "suv",
    ["description"] = "Ensure that the facility and all equipment is secure. Patrol the premises and check in with all guard booths.",
    ["checkpoints"] = {
        [1] = {pos = vector3(-842.83, 5411.69, 34.02), type = "veh"},
        [2] = {pos = vector3(-570.77, 5253.83, 69.96), type = "veh"},
        [3] = {pos = vector3(-598.01, 5349.19, 69.93), type = "veh"},
        [4] = {pos = vector3(-545.52, 5377.51, 70.05), type = "veh"},
        [5] = {pos = vector3(-819.04, 5438.94, 32.99), type = "veh"}
    }
}

securitySites[#securitySites + 1] = {
    ["name"] = "The Palmer-Taylor Power Station",
    ["vehType"] = "sedan",
    ["description"] = "Patrol the power station facility to ensure it is secure. Check in with all guard booths.",
    ["checkpoints"] = {
        [1] = {pos = vector3(2662.14, 1638.76, 24.08), type = "veh"},
        [2] = {pos = vector3(2724.68, 1361.99, 24.02), type = "veh"},
        [3] = {pos = vector3(2836.59, 1470.84, 24.05), type = "veh"},
        [4] = {pos = vector3(2827.39, 1668.91, 24.11), type = "veh"},
        [5] = {pos = vector3(2666.99, 1703.66, 23.98), type = "veh"}
    }
}

securitySites[#securitySites + 1] = {
    ["name"] = "The Del Perro Pier",
    ["vehType"] = "sedan",
    ["description"] = "This is one of our largest accounts. Patrol the pier and surrounding parking lots. Thousands of people depend on your doing your job here!",
    ["checkpoints"] = {
        [1] = {pos = vector3(-1614.61, -817.51, 9.56), type = "veh"},
        [2] = {pos = vector3(-1661.30, -945.61, 7.23), type = "veh"},
        [3] = {pos = vector3(-1617.25, -958.12, 12.51), type = "veh"},
        [4] = {pos = vector3(-1600.54, -1045.03, 12.52), type = "veh"},
        [5] = {pos = vector3(-1657.77, -1098.05, 13.14), type = "foot"},
        [6] = {pos = vector3(-1803.73, -1197.79, 13.02), type = "foot"},
        [7] = {pos = vector3(-1859.82, -1241.68, 8.62), type = "foot"}
    }
}

securitySites[#securitySites + 1] = {
    ["name"] = "STD Construction",
    ["vehType"] = "suv",
    ["description"] = "They have multiple active construction sites in the downtown area. Stop by and patrol all their sites to ensure they're safe and secure.",
    ["checkpoints"] = {
        [1] = {pos = vector3(093.00, -1027.72, 27.58), type = "veh"},
        [2] = {pos = vector3(-207.61, -1107.37, 22.64), type = "veh"},
        [3] = {pos = vector3(-112.3, -953.12, 27.61), type = "veh"},
        [4] = {pos = vector3(-471.47, -873.93, 23.74), type = "veh"},
        [5] = {pos = vector3(-508.91, -1034.57, 23.45), type = "veh"},
        [6] = {pos = vector3(2.03, -397.98, 39.36), type = "veh"},
        [7] = {pos = vector3(135.09, -375.97, 43.2), type = "veh"},
        [8] = {pos = vector3(45.77, -447.82, 39.86), type = "veh"}
    }
}

securitySites[#securitySites + 1] = {
    ["name"] = "The Davis Quartz Mine",
    ["vehType"] = "suv",
    ["description"] = "A fairly large account. Patrol the quarry area, ensuring the facility is secure. Be careful to remain clear of large machinery.",
    ["checkpoints"] = {
        [1] = {pos = vector3(2573.89, 2715.98, 42.35), type = "veh"},
        [2] = {pos = vector3(2839.12, 2785.31, 58.89), type = "veh"},
        [3] = {pos = vector3(3072.79, 2990.83, 91.79), type = "veh"},
        [4] = {pos = vector3(2667.63, 2901.03, 36.27), type = "veh"},
        [5] = {pos = vector3(2691.16, 2757.24, 37.68), type = "veh"},
        [6] = {pos = vector3(2590.60, 2805.4, 34.06), type = "veh"}
    }
}