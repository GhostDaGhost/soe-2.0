jobTitle = "[Sanitation]"
garbageTruckRubbishCount = {}
garbagePayTable = {}

sanitationStartCoords = {
    [1] = {pos = vector3(-322.15, -1546.05, 31.02), spawn = vector4(-323.22, -1523.52, 27.54, 269.55), dropOff = vector3(-347.65, -1541.68, 26.72)},
    [2] = {pos = vector3(2051.62, 3174.36, 45.17), spawn = vector4(2044.82, 3179.46, 45.03, 144.29), dropOff = vector3(2055.442, 3179.604, 45.15234)}
}

-- TABLE OF TRASH BAGS
rubbishBags = {
    "prop_rub_binbag_01",
    "prop_cs_rub_binbag_01",
    "prop_ld_binbag_01",
    "prop_ld_rub_binbag_01",
    "prop_rub_binbag_sd_01",
    "prop_rub_binbag_sd_02",
    "prop_cs_street_binbag_01",
    "p_binbag_01_s",
    "ng_proc_binbag_01a",
    "prop_rub_binbag_01b",
    "prop_rub_binbag_03b",
    "prop_rub_binbag_04",
    "prop_rub_binbag_06",
    "prop_rub_binbag_08",
    "hei_prop_heist_binbag",
    "ch_chint10_binbags_smallroom_01",
    "prop_rub_binbag_03",
    "prop_rub_binbag_05"
}

-- JOB ROLES
sanitationJobRoles = {
    [0] = {
        roleName = "None",
        menuIndex = nil,
    },
    [1] = {
        roleIcon = "🗑️",
        roleName = "Garbage Collector",
        roleCollectRubbish = "Collect Rubbish",
        roleThrowInTruck = "Throw Rubbish In Truck",
        roleDropOff = "Empty Truck",
        roleDescription = "Drive your trashmaster around cleaning up the streets of San Andreas.",
        roleStartText = "Congrats on your new role as a garbage collector, now get out there and do some work!",
        roleCheckoutVehicle = "Here's your work vehicle, be sure to bring it back in one piece when you are finished.",
        roleReturnAVehicle = "Thank you for returning a truck! Have a nice day!",
        roleReturnWorkVehicle = "Thank you for bringing your truck back! Have a nice day!",
        roleVehicleTooFar = "We can't seem to find the vehicle you are returning, bring it closer to the depot.",
        roleVehicleNotFound = "Don't forget to grab the paperwork from the vehicle before returning it.",
        rolePickedup = "You picked up the rubbish bag, put it in the back of your garbage truck.",
        roleThrowRubbish = "You throw the trash bag into the truck. (%s/%s)",
        roleTruckFull = "You throw the trash bag into the truck. The truck appears full, time to empty it.",
        roleTruckForce = "You force the trash bag into the truck. The truck is full, time to empty it.",
        roleEmptyTruck = "Thanks for collecting %s rubbish bags, $%s has been added to your pay, collect it at the office.",
        roleTruckEmpty = "There's no rubbish in the truck! Get out there and do some work and stop wasting time.",
        vehicleModelHash = GetHashKey("trash2"),
        emoteName = "rubbish",
        animDic = "anim@move_m@trash",
        animLib = "idle",
        menuIndex = 0,
        interactionShowing = false,
        quantity = nil,
        maxQuantity = 250,
        payRate = 15
    },
}