factoryInventory = {
    raw = 100,
    processed = 50,
    packaged = 10
}

-- PLACES TO DO SOME STOCKTAKING
stockTakingSpots = {
    {pos = vector4(-67.54286, 6247.24, 31.08276, 314.83), nextAvailableTime = 0, occupied = false, stockTaked = false},
    {pos = vector4(-63.91648, 6240.541, 31.08276, 256.51), nextAvailableTime = 0, occupied = false, stockTaked = false},
    {pos = vector4(-74.79561, 6238.984, 31.06592, 108.49), nextAvailableTime = 0, occupied = false, stockTaked = false},
    {pos = vector4(-82.19341, 6237.903, 31.08276, 334.53), nextAvailableTime = 0, occupied = false, stockTaked = false},
    {pos = vector4(-74.95384, 6221.288, 31.08276, 231.83), nextAvailableTime = 0, occupied = false, stockTaked = false},
    {pos = vector4(-78.52747, 6219.495, 31.08276, 221.29), nextAvailableTime = 0, occupied = false, stockTaked = false},
    {pos = vector4(-84.92308, 6225.007, 31.08276, 102.98), nextAvailableTime = 0, occupied = false, stockTaked = false},
    {pos = vector4(-91.91209, 6235.531, 31.08276, 306.39), nextAvailableTime = 0, occupied = false, stockTaked = false},
    {pos = vector4(-83.74945, 6214.417, 31.08276, 200.55), nextAvailableTime = 0, occupied = false, stockTaked = false},
    {pos = vector4(-89.1956, 6211.0291, 31.06592, 185.55), nextAvailableTime = 0, occupied = false, stockTaked = false},
    {pos = vector4(-85.41099, 6233.789, 31.08276, 128.31), nextAvailableTime = 0, occupied = false, stockTaked = false},
    {pos = vector4(-108.4615, 6201.007, 31.01538, 42.59), nextAvailableTime = 0, occupied = false, stockTaked = false},
    {pos = vector4(-93.67912, 6215.367, 31.01538, 65.18), nextAvailableTime = 0, occupied = false, stockTaked = false},
    {pos = vector4(-97.46374, 6211.042, 31.01538, 84.77), nextAvailableTime = 0, occupied = false, stockTaked = false},
    {pos = vector4(-99.46813, 6208.932, 31.01538, 78.52), nextAvailableTime = 0, occupied = false, stockTaked = false},
    {pos = vector4(-101.7626, 6206.756, 31.01538, 81.04), nextAvailableTime = 0, occupied = false, stockTaked = false},
    {pos = vector4(-103.7407, 6204.765, 31.01538, 83.66), nextAvailableTime = 0, occupied = false, stockTaked = false},
    {pos = vector4(-105.8242, 6202.879, 31.01538, 66.91), nextAvailableTime = 0, occupied = false, stockTaked = false},
    {pos = vector4(-100.0484, 6204.04, 31.01538, 219.23), nextAvailableTime = 0, occupied = false, stockTaked = false},
    {pos = vector4(-97.66154, 6206.242, 31.01538, 218.9), nextAvailableTime = 0, occupied = false, stockTaked = false},
}

-- PLACES TO DO SOME PROCESSING
processingSpots = {
    {pos = vector4(-98.16264, 6212.519, 31.01538, 46.41), occupied = false},
    {pos = vector4(-100.1143, 6210.554, 31.01538, 41.85), occupied = false},
    {pos = vector4(-102.1846, 6208.497, 31.01538, 49.14), occupied = false},
    {pos = vector4(-104.1626, 6206.321, 31.01538, 46.37), occupied = false},
    {pos = vector4(-106.2462, 6204.356, 31.01538, 45.51), occupied = false},
}

-- PLACES TO DO SOME PROCESSING
packingSpots = {
    -- PICKUP SPOTS
    {pos = vector4(-157.2659, 6158.901, 31.20068, 138.36), nextAvailableTime = 0, occupied = false, packaged = false},
    {pos = vector4(-160.6418, 6162.303, 31.20068, 139.56), nextAvailableTime = 0, occupied = false, packaged = false},
    {pos = vector4(-164.044, 6165.732, 31.20068, 135.91), nextAvailableTime = 0, occupied = false, packaged = false},
    {pos = vector4(-157.2, 6162.053, 31.20068, 316.73), nextAvailableTime = 0, occupied = false, packaged = false},
    {pos = vector4(-160.7341, 6165.534, 31.20068, 314.19), nextAvailableTime = 0, occupied = false, packaged = false},
    {pos = vector4(-164.189, 6168.831, 31.20068, 315.73), nextAvailableTime = 0, occupied = false, packaged = false},
    {pos = vector4(-158.0176, 6154.47, 31.20068, 318.03), nextAvailableTime = 0, occupied = false, packaged = false},
    {pos = vector4(-161.3802, 6157.886, 31.20068, 313.87), nextAvailableTime = 0, occupied = false, packaged = false},
    {pos = vector4(-164.7956, 6161.367, 31.20068, 314.47), nextAvailableTime = 0, occupied = false, packaged = false},
    {pos = vector4(-168.211, 6164.756, 31.20068, 315.05), nextAvailableTime = 0, occupied = false, packaged = false},
    {pos = vector4(-164.9143, 6158.123, 31.20068, 137.71), nextAvailableTime = 0, occupied = false, packaged = false},
    {pos = vector4(-168.3033, 6161.459, 31.20068, 134.12), nextAvailableTime = 0, occupied = false, packaged = false},
    {pos = vector4(-172.4176, 6160.523, 31.20068, 316.04), nextAvailableTime = 0, occupied = false, packaged = false},
    {pos = vector4(-169.0418, 6157.121, 31.20068, 316.23), nextAvailableTime = 0, occupied = false, packaged = false},

    -- DROPOFF SPOTS
    {pos = vector4(-152.0571, 6141.798, 32.32971, 227.4), occupied = false, dropOff = true},
    {pos = vector4(-154.4308, 6142.721, 32.32971, 48.34), occupied = false, dropOff = true},
    {pos = vector4(-157.0813, 6141.284, 32.32971, 132.02), occupied = false, dropOff = true},
    {pos = vector4(-148.4703, 6147.429, 32.32971, 47.69), occupied = false, dropOff = true},    
    {pos = vector4(-170.0571, 6146.598, 31.20068, 135.73), occupied = false, dropOff = true},
    {pos = vector4(-173.2484, 6149.552, 31.20068, 136.7), occupied = false, dropOff = true},
}

-- JOB ROLES
jobRoles = {
    [0] = {
        roleName = "None",
        tableName = nil,
    },
    [1] = {
        roleIcon = "🖥️",
        roleName = "Stock Taker",
        roleAction = "Stock Taking",
        roleDescription = "Perform stock take at multiple locations in the factory.",
        roleStartText = "Congrats on your new role as a stock taker, now get out there and do some work!",
        roleNotification = "You've been tasked with checking to make sure our production line is running smoothly, no running or jumping!",
        roleSuccessMessage = "Everything seems to be in order.",
        workMinDuration = 25000,
        workMaxDuration = 30000,
        rewardThreshold = 10,
        rewardMin = 50,
        rewardMax = 100,
        emoteName = "tablet2",
        animDic = "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a",
        animLib = "idle_a",
        tableName = stockTakingSpots,
        jobCooldown = 300,
        jobsCompleted = 0
    },
    [2] = {
        roleIcon = "🍗",
        roleName = "Processor",
        roleAction = "Processing",
        roleDescription = "Process the chicken in the machines.",
        roleStartText = "Congrats on your new role as a processor, now get out there and do some work!",
        roleNotification = "You've been tasked with processing the chicken on the processing line, make sure everything runs smoothly!",
        roleSuccessMessage = "You've finished processing the chicken, onto the next one!",
        workMinDuration = 30000,
        workMaxDuration = 35000,
        rewardThreshold = 25,
        rewardMin = 100,
        rewardMax = 200,
        emoteName = "mechanic2",
        animDic = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
        animLib = "machinic_loop_mechandplayer",
        tableName = processingSpots,
        jobsCompleted = 0
    },
    [3] = {
        roleIcon = "📦",
        roleName = "Logistics Worker",
        roleAction = "Packaging",
        roleDescription = "Move packages from storage to the staging area for transport.",
        roleStartText = "Congrats on your new role as a logistics worker, now get out there and do some work!",
        roleNotification = "You've been tasked with moving packages from the warehouse and getting them ready for delivery, no running or jumping!",
        workMinDuration = 5000,
        workMaxDuration = 10000,
        rewardThreshold = 15,
        rewardMin = 75,
        rewardMax = 100,
        emoteName = "mechanic2",
        animDic = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
        animLib = "machinic_loop_mechandplayer",
        animDic2 = "anim@heists@box_carry@",
        animLib2 = "idle",            
        tableName = packingSpots,
        jobCooldown = 240,
        jobsCompleted = 0,
        hasLogisticsPackage = false
    }
}
