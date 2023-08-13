-- PUMP MODEL HASHES
pumpModels = {
    [-2007231801] = true,
    [1339433404] = true,
    [1694452750] = true,
    [1933174915] = true,
    [-462817101] = true,
    [-469694731] = true,
    [-164877493] = true
}

-- Class multipliers. If you want SUVs to use less fuel, you can change it to anything under 1.0, and vise versa.
classes = {
    [0] = 1.0, -- Compacts
    [1] = 1.0, -- Sedans
    [2] = 1.0, -- SUVs
    [3] = 1.0, -- Coupes
    [4] = 1.0, -- Muscle
    [5] = 1.0, -- Sports Classics
    [6] = 1.0, -- Sports
    [7] = 1.0, -- Super
    [8] = 1.0, -- Motorcycles
    [9] = 1.0, -- Off-road
    [10] = 1.0, -- Industrial
    [11] = 1.0, -- Utility
    [12] = 1.0, -- Vans
    [13] = 0.0, -- Cycles
    [14] = 1.0, -- Boats
    [15] = 1.0, -- Helicopters
    [16] = 1.0, -- Planes
    [17] = 1.0, -- Service
    [18] = 1.0, -- Emergency
    [19] = 1.0, -- Military
    [20] = 1.0, -- Commercial
    [21] = 1.0 -- Trains
}

-- The left part is at percentage RPM, and the right is how much fuel (divided by 10) you want to remove from the tank every second
fuelUsage = {
    [1.0] = 0.6,
    [0.9] = 0.5,
    [0.8] = 0.4,
    [0.7] = 0.45,
    [0.6] = 0.40,
    [0.5] = 0.35,
    [0.4] = 0.3,
    [0.3] = 0.25,
    [0.2] = 0.2,
    [0.1] = 0.1,
    [0.0] = 0.0
}
