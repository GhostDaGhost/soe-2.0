goPostalDestinationStatus = {}
goPostalPayTable = {}
goPostalPayRate = 15

-- LIST OF PACKAGE DESTINATIONS
goPostalPackageDestinations = {
    [1] = {stopID = 1, pos = vector3(440.71, -981.52, 30.69)},
    [2] = {stopID = 2, pos = vector3(1203.59, -598.6, 68.06)},
    [3] = {stopID = 3, pos = vector3(-209.02, -1600.75, 34.87)},
    [4] = {stopID = 4, pos = vector3(-267.66, -958.87, 31.22)},
    [5] = {stopID = 5, pos = vector3(-286.58, -1061.77, 27.21)},
    -- BAYCITY AVE - VESPUCCI BEACH
    [6] = {stopID = 6, pos = vector3(-1107.82, -1693.49, 3.37)},
    [7] = {stopID = 7, pos = vector3(-1110.27, -1661.84, 3.36)},
    [8] = {stopID = 8, pos = vector3(-1114.12, -1657.98, 3.36)},
    [9] = {stopID = 9, pos = vector3(-1122.07, -1647.85, 3.35)},
    [10] = {stopID = 10, pos = vector3(-1130.08, -1636.24, 3.36)},
    [11] = {stopID = 11, pos = vector3(-1138.41, -1624.98, 3.40)},
    [12] = {stopID = 12, pos = vector3(-1143.8, -1617.01, 3.40)},
    [13] = {stopID = 13, pos = vector3(-1146.23, -1598.64, 3.39)},
    [14] = {stopID = 14, pos = vector3(-1169.09, -1580.42, 3.39)},
    [15] = {stopID = 15, pos = vector3(-1169.59, -1573.35, 3.66)},
    [16] = {stopID = 16, pos = vector3(-1176.1, -1568.46, 3.36)},
    [17] = {stopID = 17, pos = vector3(-1184.03, -1557.51, 3.36)},
    [18] = {stopID = 18, pos = vector3(-1188.94, -1551.47, 3.36)},
    [19] = {stopID = 19, pos = vector3(-1194.24, -1543.93, 3.37)},
    [20] = {stopID = 20, pos = vector3(-1184.32, -1536.2, 3.38)},
    -- SPANISH SHOPS
    [21] = {stopID = 21, pos = vector3(201.95, -26.32, 68.9)},
    [22] = {stopID = 22, pos = vector3(210.63, -17.75, 68.89)},
    [23] = {stopID = 23, pos = vector3(237.74, -26.72, 68.89)},
    [24] = {stopID = 24, pos = vector3(255.25, -46.4, 68.94)},
    [25] = {stopID = 25, pos = vector3(173.67, -26.24, 67.35)},
    [26] = {stopID = 26, pos = vector3(114.48, -5.01, 66.82)},
    -- MIRROR PARK
    [27] = {stopID = 27, pos = vector3(1093.32, -363.13, 66.06)},
    [28] = {stopID = 28, pos = vector3(1124.3, -344.91, 66.13)},
    [29] = {stopID = 29, pos = vector3(1139.24, -432.21, 66.05)},
    [30] = {stopID = 30, pos = vector3(1163.14, -322.21, 68.2)},
    [31] = {stopID = 31, pos = vector3(1233.62, -354.92, 68.1)},
    [32] = {stopID = 32, pos = vector3(1218.13, -416.57, 66.78)},
    [33] = {stopID = 33, pos = vector3(1174.4, -418.88, 66.2)},
    [34] = {stopID = 34, pos = vector3(1211.9, -445.19, 65.95)},
    [35] = {stopID = 35, pos = vector3(1207.14, -463.59, 65.43)},
    [36] = {stopID = 36, pos = vector3(1210.09, -470.42, 65.2)},
    [37] = {stopID = 37, pos = vector3(1134.16, -475.43, 65.71)},
    [38] = {stopID = 38, pos = vector3(1148.13, -450.88, 65.98)},
    [39] = {stopID = 39, pos = vector3(1138.85, -962.58, 46.53)},
    [40] = {stopID = 40, pos = vector3(1130.32, -979.82, 45.41)},
    -- LITTLE SEOUL
    [41] = {stopID = 41, pos = vector3(-659.53, -814.12, 23.53)},
    [42] = {stopID = 42, pos = vector3(-696.95, -859.01, 22.69)},
    [43] = {stopID = 43, pos = vector3(-655.78, -863.42, 23.56)},
    [44] = {stopID = 44, pos = vector3(-654.93, -885.30, 23.66)},
    [45] = {stopID = 45, pos = vector3(-680.33, -945.5, 19.93)},
    --VESPUCCI BLVD
    [46] = {stopID = 46, pos = vector3(847.83, -1020.01, 27.88)},
    [47] = {stopID = 47, pos = vector3(818.13, -1949.83, 26.75)},
    [48] = {stopID = 48, pos = vector3(363.41, -1072.9, 29.53)},
    [49] = {stopID = 49, pos = vector3(316.11, -1086.37, 29.4)},
    [50] = {stopID = 50, pos = vector3(287.95, -1095.03, 29.42)},
    [51] = {stopID = 51, pos = vector3(149.77, -1040.75, 29.37)},
    [52] = {stopID = 52, pos = vector3(250.53, -1026.87, 29.26)},
    [53] = {stopID = 53, pos = vector3(280.8, -971.86, 29.42)}
}
