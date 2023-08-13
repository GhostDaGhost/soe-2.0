counterSpot = {}
storageSpot = {}
suppliesSpot = {}

suppliesSpot.beanMachine = {
    name = "Bean Machine",
    pos = {
        vector3(-631.4242, 224.8747, 81.86816)
    },
    recipes = {
        {name = "Apple Pie x5", itemIcon = "🥧", itemName = "bm_applepie", itemDisplayName = "Apple Pie", amount = 5, supply = "small"},
        {name = "Apple Pie x25", itemIcon = "🥧", itemName = "bm_applepie", itemDisplayName = "Apple Pie", amount = 25, supply = "large"},
        {name = "Cappuccino x5", itemIcon = "☕", itemName = "bm_cappuccino", itemDisplayName = "Cappuccino", amount = 5, supply = "small"},
        {name = "Cappuccino x25", itemIcon = "☕", itemName = "bm_cappuccino", itemDisplayName = "Cappuccino", amount = 25, supply = "large"},
        {name = "Chai Latte x5", itemIcon = "☕", itemName = "bm_chailatte", itemDisplayName = "Chai Latte", amount = 5, supply = "small"},
        {name = "Chai Latte x25", itemIcon = "☕", itemName = "bm_chailatte", itemDisplayName = "Chai Latte", amount = 25, supply = "large"},
        {name = "Carrot Cake x5", itemIcon = "🎂", itemName = "bm_carrotcake", itemDisplayName = "Carrot Cake", amount = 5, supply = "small"},
        {name = "Carrot Cake x25", itemIcon = "🎂", itemName = "bm_carrotcake", itemDisplayName = "Carrot Cake", amount = 25, supply = "large"},
        {name = "Iced Coffee x5", itemIcon = "🥤", itemName = "bm_icedcoffee", itemDisplayName = "Iced Coffee", amount = 5, supply = "small"},
        {name = "Iced Coffee x25", itemIcon = "🥤", itemName = "bm_icedcoffee", itemDisplayName = "Iced Coffee", amount = 25, supply = "large"},
        {name = "Red Velvet Cake x5", itemIcon = "🎂", itemName = "bm_redvelvetcake", itemDisplayName = "Red Velvet Cake", amount = 5, supply = "small"},
        {name = "Red Velvet Cake x25", itemIcon = "🎂", itemName = "bm_redvelvetcake", itemDisplayName = "Red Velvet Cake", amount = 25, supply = "large"},
    },
    supplies = {
        small = {
            requiredItem = "smallboxofbeanmachinesupplies",
            requiredItemName = "Small Box of Bean Machine Supplies",
        },
        large = {
            requiredItem = "largeboxofbeanmachinesupplies",
            requiredItemName = "Large Box of Bean Machine Supplies",
        }
    },
    perms = {"BMSUPPLIES"}
}

suppliesSpot.beanMachineGarage = {
    name = "Bean Machine Garage",
    pos = {
        vector3(-634.69, 208.83, 74.15),
    },
    perms = {"BMGARAGE"}
}

suppliesSpot.smokeOnTheWater = {
    name = "Smoke On The Water",
    pos = {
        vector3(-1169.81, -1570.25, 4.66),
        vector3(-230.82, -306.03, 29.87)
    },
    recipes = {
        {name = "SOTW Party Pack x4", itemIcon = "📦", itemName = "sotw_partypack", itemDisplayName = "SOTW Party Pack", amount = 4, supply = "small"},
        {name = "SOTW Party Pack x10", itemIcon = "📦", itemName = "sotw_partypack", itemDisplayName = "SOTW Party Pack", amount = 10, supply = "large"},
        {name = "SOTW Golden Sunrise Party Pack x4", itemIcon = "📦", itemName = "sotw_partypack_goldensunrise", itemDisplayName = "SOTW Golden Sunrise Party Pack", amount = 4, supply = "small"},
        {name = "SOTW Golden Sunrise Party Pack x10", itemIcon = "📦", itemName = "sotw_partypack_goldensunrise", itemDisplayName = "SOTW Golden Sunrise Party Pack", amount = 10, supply = "large"},
        {name = "SOTW Purple Nurple Party Pack x4", itemIcon = "📦", itemName = "sotw_partypack_purplenurple", itemDisplayName = "SOTW Purple Nurple Party Pack", amount = 4, supply = "small"},
        {name = "SOTW Purple Nurple Party Pack x10", itemIcon = "📦", itemName = "sotw_partypack_purplenurple", itemDisplayName = "SOTW Purple Nurple Party Pack", amount = 10, supply = "large"},
        {name = "SOTW Teal Appeal Party Pack x4", itemIcon = "📦", itemName = "sotw_partypack_tealappeal", itemDisplayName = "SOTW Teal Appeal Party Pack", amount = 4, supply = "small"},
        {name = "SOTW Teal Appeal Party Pack x10", itemIcon = "📦", itemName = "sotw_partypack_tealappeal", itemDisplayName = "SOTW Teal Appeal Party Pack", amount = 10, supply = "large"},
    },
    supplies = {
        small = {
            requiredItem = "smallboxofsotwsupplies",
            requiredItemName = "Small Box of SOTW Supplies",
        },
        large = {
            requiredItem = "largeboxofsotwsupplies",
            requiredItemName = "Large Box of SOTW Supplies",
        }
    },
    perms = {"SOTWSUPPLIES"}
}

suppliesSpot.lastTrain = {
    name = "Last Train",
    pos = {
        vector3(-384.3297, 265.0549, 86.4176)
    },
    recipes = {
        {name = "Beef Burrito x5", itemIcon = "🌮", itemName = "beefburrito", itemDisplayName = "Beef Burrito", amount = 5, supply = "small"},
        {name = "Beef Burrito x25", itemIcon = "🌮", itemName = "beefburrito", itemDisplayName = "Beef Burrito", amount = 25, supply = "large"},
        {name = "Beef Rump Steak x5", itemIcon = "🥩", itemName = "lt_beefrumpsteak", itemDisplayName = "Beef Rump Steak", amount = 5, supply = "small"},
        {name = "Beef Rump Steak x25", itemIcon = "🥩", itemName = "lt_beefrumpsteak", itemDisplayName = "Beef Rump Steak", amount = 25, supply = "large"},
        {name = "Beer Battered Onion Rings x5", itemIcon = "🍟", itemName = "lt_onionrings", itemDisplayName = "Beer Battered Onion Rings", amount = 5, supply = "small"},
        {name = "Beer Battered Onion Rings x25", itemIcon = "🍟", itemName = "lt_onionrings", itemDisplayName = "Beer Battered Onion Rings", amount = 25, supply = "large"},
        {name = "Blue Rasphberry Slushie x5", itemIcon = "🥤", itemName = "lt_blueraspberryslushie", itemDisplayName = "Blue Rasphberry Slushie", amount = 5, supply = "small"},
        {name = "Blue Rasphberry Slushie x25", itemIcon = "🥤", itemName = "lt_blueraspberryslushie", itemDisplayName = "Blue Rasphberry Slushie", amount = 25, supply = "large"},
        {name = "Brownie x5", itemIcon = "🍪", itemName = "brownie", itemDisplayName = "Brownie", amount = 5, supply = "small"},
        {name = "Brownie x25", itemIcon = "🍪", itemName = "brownie", itemDisplayName = "Brownie", amount = 25, supply = "large"},
        {name = "Curry Wurst x5", itemIcon = "🌯", itemName = "lt_currywurst", itemDisplayName = "Curry Wurst", amount = 5, supply = "small"},
        {name = "Curry Wurst x25", itemIcon = "🌯", itemName = "lt_currywurst", itemDisplayName = "Curry Wurst", amount = 25, supply = "large"},
        {name = "Fries x5", itemIcon = "🍟", itemName = "lt_fries", itemDisplayName = "Fries", amount = 5, supply = "small"},
        {name = "Fries x25", itemIcon = "🍟", itemName = "lt_fries", itemDisplayName = "Fries", amount = 25, supply = "large"},
    },
    supplies = {
        small = {
            requiredItem = "smallboxoflasttrainsupplies",
            requiredItemName = "Small Box of Last Train Supplies",
        },
        large = {
            requiredItem = "largeboxoflasttrainsupplies",
            requiredItemName = "Large Box of Last Train Supplies",
        }
    },
    perms = {"LTSUPPLIES"}
}

suppliesSpot.bahamaMamas = {
    name = "Bahama Mamas",
    pos = {
        vector3(-1377.56, -627.0989, 30.81323),
        vector3(-1393.912, -605.3538, 30.30774),
    },
    recipes = {
        {name = "Rum and Coke x5", itemIcon = "🥃", itemName = "rumandcoke", itemDisplayName = "Rum and Coke", amount = 5, supply = "small"},
        {name = "Rum and Coke x25", itemIcon = "🥃", itemName = "rumandcoke", itemDisplayName = "Rum and Coke", amount = 25, supply = "large"},
        {name = "Whiskey On The Rocks x5", itemIcon = "🥃", itemName = "whiskeyrocks", itemDisplayName = "Whiskey On The Rocks", amount = 5, supply = "small"},
        {name = "Whiskey On The Rocks x25", itemIcon = "🥃", itemName = "whiskeyrocks", itemDisplayName = "Whiskey On The Rocks", amount = 25, supply = "large"}
    },
    supplies = {
        small = {
            requiredItem = "smallboxofbahamasupplies",
            requiredItemName = "Small Box of Bahama Mamams Supplies",
        },
        large = {
            requiredItem = "largeboxofbahamasupplies",
            requiredItemName = "Large Box of Bahama Mamams Supplies",
        }
    },
    perms = {"BAHAMASUPPLIES"}
}

suppliesSpot.vanillaUnicorn = {
    name = "Vanilla Unicorn",
    pos = {
        vector3(128.7033, -1282.655, 29.26306),
    },
    recipes = {
        {name = "Appletini x5", itemIcon = "🍹", itemName = "vu_appletini", itemDisplayName = "Appletini", amount = 5, supply = "small"},
        {name = "Appletini x25", itemIcon = "🍹", itemName = "vu_appletini", itemDisplayName = "Appletini", amount = 25, supply = "large"},
        {name = "Barbeque Wings x5", itemIcon = "🍗", itemName = "vu_bbqwings", itemDisplayName = "Barbeque Wings", amount = 5, supply = "small"},
        {name = "Barbeque Wings x25", itemIcon = "🍗", itemName = "vu_bbqwings", itemDisplayName = "Barbeque Wings", amount = 25, supply = "large"},
        {name = "Buffalo Cauliflower Wings x5", itemIcon = "🍗", itemName = "vu_buffalocauliflowerwings", itemDisplayName = "Buffalo Cauliflower Wings", amount = 5, supply = "small"},
        {name = "Buffalo Cauliflower Wings x25", itemIcon = "🍗", itemName = "vu_buffalocauliflowerwings", itemDisplayName = "Buffalo Cauliflower Wings", amount = 25, supply = "large"},
        {name = "Jalapeno Cheese Pops x5", itemIcon = "🧀", itemName = "vu_jalapenocheesepops", itemDisplayName = "Jalapeno Cheese Pops", amount = 5, supply = "small"},
        {name = "Jalapeno Cheese Pops x25", itemIcon = "🧀", itemName = "vu_jalapenocheesepops", itemDisplayName = "Jalapeno Cheese Pops", amount = 25, supply = "large"},
        {name = "Sex On The Beach x5", itemIcon = "🍹", itemName = "vu_sexonthebeach", itemDisplayName = "Sex On The Beach", amount = 5, supply = "small"},
        {name = "Sex On The Beach x25", itemIcon = "🍹", itemName = "vu_sexonthebeach", itemDisplayName = "Sex On The Beach", amount = 25, supply = "large"},
        {name = "Strawberry Daiquiri x5", itemIcon = "🍹", itemName = "vu_strawberrydaiquiri", itemDisplayName = "Strawberry Daiquiri", amount = 5, supply = "small"},
        {name = "Strawberry Daiquiri x25", itemIcon = "🍹", itemName = "vu_strawberrydaiquiri", itemDisplayName = "Strawberry Daiquiri", amount = 25, supply = "large"},
    },
    supplies = {
        small = {
            requiredItem = "smallboxofvusupplies",
            requiredItemName = "Small Box of Vanilla Unicorn Supplies",
        },
        large = {
            requiredItem = "largeboxofvusupplies",
            requiredItemName = "Large Box of Vanilla Unicorn Supplies",
        }
    },
    perms = {"VUSUPPLIES", "VUGARAGE"}
}

suppliesSpot.burgerShot = {
    name = "Burger Shot",
    pos = {
        vector3(-1199.93, -898.91, 13.98),
    },
    recipes = {
        {name = "Burger Shot 6 Lb Burger x5", itemIcon = "🍔", itemName = "bs_6lbburger", itemDisplayName = "Burger Shot 6 Lb Burger", amount = 5, supply = "small"},
        {name = "Burger Shot 6 Lb Burger x25", itemIcon = "🍔", itemName = "bs_6lbburger", itemDisplayName = "Burger Shot 6 Lb Burger", amount = 25, supply = "large"},
        {name = "Burger Shot Bleeder Meal x5", itemIcon = "🍔", itemName = "bs_bleedermeal", itemDisplayName = "Burger Shot Bleeder Meal", amount = 5, supply = "small"},
        {name = "Burger Shot Bleeder Meal x25", itemIcon = "🍔", itemName = "bs_bleedermeal", itemDisplayName = "Burger Shot Bleeder Meal", amount = 25, supply = "large"},
        {name = "Burger Shot Fries x5", itemIcon = "🍟", itemName = "bs_fries", itemDisplayName = "Burger Shot Fries", amount = 5, supply = "small"},
        {name = "Burger Shot Fries x25", itemIcon = "🍟", itemName = "bs_fries", itemDisplayName = "Burger Shot Fries", amount = 25, supply = "large"},
        {name = "Burger Shot Meatless Meal x5", itemIcon = "🍔", itemName = "bs_meatlessmeal", itemDisplayName = "Burger Shot Meatless Meal", amount = 5, supply = "small"},
        {name = "Burger Shot Meatless Meal x25", itemIcon = "🍔", itemName = "bs_meatlessmeal", itemDisplayName = "Burger Shot Meatless Meal", amount = 25, supply = "large"},
        {name = "Burger Shot Money Shot Meal x5", itemIcon = "🍔", itemName = "bs_moneyshotmeal", itemDisplayName = "Burger Shot Money Shot Meal", amount = 5, supply = "small"},
        {name = "Burger Shot Money Shot Meal x25", itemIcon = "🍔", itemName = "bs_moneyshotmeal", itemDisplayName = "Burger Shot Money Shot Meal", amount = 25, supply = "large"},
        {name = "Burger Shot Torpedo Meal x5", itemIcon = "🍔", itemName = "bs_torpedomeal", itemDisplayName = "Burger Shot Torpedo Meal", amount = 5, supply = "small"},
        {name = "Burger Shot Torpedo Meal x25", itemIcon = "🍔", itemName = "bs_torpedomeal", itemDisplayName = "Burger Shot Torpedo Meal", amount = 25, supply = "large"},
    },
    supplies = {
        small = {
            requiredItem = "smallboxofbssupplies",
            requiredItemName = "Small Box of Burger Shot Supplies",
        },
        large = {
            requiredItem = "largeboxofbssupplies",
            requiredItemName = "Large Box of Burger Shot Supplies",
        }
    },
    perms = {"BSSUPPLIES"}
}

suppliesSpot.burgerShotGarage = {
    name = "Burger Shot",
    pos = {
        vector3(-1177.93, -891.43, 13.76),
    },
    perms = {"BSGARAGE"}
}

suppliesSpot.craigOneilBusinessesServicesAndRentalsGarage = {
    name = "Craig O'Neil Businesses, Services, and Rentals",
    pos = {
        vector3(-1304.07, -1262.3, 4.39),
    },
    perms = {"COGARAGE"}
}

suppliesSpot.lawsonLunchbox = {
    name = "Lawson Lunchbox",
    pos = {
        vector3(2697.36, 4324.66, 45.84),
    },
    recipes = {
        {name = "Bacon & Egg Rollup x5", itemIcon = "🌯", itemName = "ll_baconeggrollup", itemDisplayName = "Bacon & Egg Rollup", amount = 5, supply = "small"},
        {name = "Bacon & Egg Rollup x25", itemIcon = "🌯", itemName = "ll_baconeggrollup", itemDisplayName = "Bacon & Egg Rollup", amount = 25, supply = "large"},
        {name = "Biscuits & Gravy x5", itemIcon = "🍪", itemName = "ll_biscuitsandgravy", itemDisplayName = "Biscuits & Gravy", amount = 5, supply = "small"},
        {name = "Biscuits & Gravy x25", itemIcon = "🍪", itemName = "ll_biscuitsandgravy", itemDisplayName = "Biscuits & Gravy", amount = 25, supply = "large"},
        {name = "Chicken Fried Steak x5", itemIcon = "🥩", itemName = "ll_chickenfriedstreak", itemDisplayName = "Chicken Fried Steak", amount = 5, supply = "small"},
        {name = "Chicken Fried Steak x25", itemIcon = "🥩", itemName = "ll_chickenfriedstreak", itemDisplayName = "Chicken Fried Steak", amount = 25, supply = "large"},
        {name = "Grits x5", itemIcon = "🍲", itemName = "ll_grits", itemDisplayName = "Grits", amount = 5, supply = "small"},
        {name = "Grits x25", itemIcon = "🍲", itemName = "ll_grits", itemDisplayName = "Grits", amount = 25, supply = "large"},
        {name = "Hot Wings x5", itemIcon = "🍗", itemName = "ll_hotwings", itemDisplayName = "Hot Wings", amount = 5, supply = "small"},
        {name = "Hot Wings x25", itemIcon = "🍗", itemName = "ll_hotwings", itemDisplayName = "Hot Wings", amount = 25, supply = "large"},
        {name = "Sweet Tea x5", itemIcon = "🥤", itemName = "ll_sweettea", itemDisplayName = "Sweet Tea", amount = 5, supply = "small"},
        {name = "Sweet Tea x25", itemIcon = "🥤", itemName = "ll_sweettea", itemDisplayName = "Sweet Tea", amount = 25, supply = "large"},
        {name = "Chili Cheese Fries x5", itemIcon = "🍟", itemName = "ll_chilicheesefries", itemDisplayName = "Chili Cheese Fries", amount = 5, supply = "small"},
        {name = "Chili Cheese Fries x25", itemIcon = "🍟", itemName = "ll_chilicheesefries", itemDisplayName = "Chili Cheese Fries", amount = 25, supply = "large"},
        {name = "Smoked Brisket x5", itemIcon = "🥩", itemName = "ll_smokedbrisket", itemDisplayName = "Smoked Brisket", amount = 5, supply = "small"},
        {name = "Smoked Brisket  x25", itemIcon = "🥩", itemName = "ll_smokedbrisket", itemDisplayName = "Smoked Brisket", amount = 25, supply = "large"},
        {name = "Pulled Pork Platter x5", itemIcon = "🐖", itemName = "ll_pulledporkplatter", itemDisplayName = "Pulled Pork Platter", amount = 5, supply = "small"},
        {name = "Pulled Pork Platter x25", itemIcon = "🐖", itemName = "ll_pulledporkplatter", itemDisplayName = "Pulled Pork Platter", amount = 25, supply = "large"},
    },
    supplies = {
        small = {
            requiredItem = "smallboxofllsupplies",
            requiredItemName = "Small Box of Lawson Lunchbox Supplies",
        },
        large = {
            requiredItem = "largeboxofllsupplies",
            requiredItemName = "Large Box of Lawson Lunchbox Supplies",
        }
    },
    perms = {"LLSUPPLIES", "LLGARAGE"}
}

suppliesSpot.diamondCasino = {
    name = "Diamond Casino",
    pos = {
        vector3(1110.46, 208.84, -49.44),
        vector3(1113.51, 208.64, -49.44)
    },
    recipes = {
        {name = "Long Island x5", itemIcon = "🍹", itemName = "dc_longisland", itemDisplayName = "Long Island", amount = 5, supply = "small"},
        {name = "Long Island x25", itemIcon = "🍹", itemName = "dc_longisland", itemDisplayName = "Long Island", amount = 25, supply = "large"},
        {name = "Margarita x5", itemIcon = "🍹", itemName = "dc_margarita", itemDisplayName = "Margarita", amount = 5, supply = "small"},
        {name = "Margarita x25", itemIcon = "🍹", itemName = "dc_margarita", itemDisplayName = "Margarita", amount = 25, supply = "large"},
        {name = "Martini x5", itemIcon = "🍹", itemName = "dc_martini", itemDisplayName = "Martini", amount = 5, supply = "small"},
        {name = "Martini x25", itemIcon = "🍹", itemName = "dc_martini", itemDisplayName = "Martini", amount = 25, supply = "large"},
        {name = "Mimosa x5", itemIcon = "🍹", itemName = "dc_mimosa", itemDisplayName = "Mimosa", amount = 5, supply = "small"},
        {name = "Mimosa x25", itemIcon = "🍹", itemName = "dc_mimosa", itemDisplayName = "Mimosa Rib", amount = 25, supply = "large"},
        {name = "Pretzels x5", itemIcon = "🥨", itemName = "dc_pretzels", itemDisplayName = "Pretzels", amount = 5, supply = "small"},
        {name = "Pretzels x25", itemIcon = "🥨", itemName = "dc_pretzels", itemDisplayName = "Pretzels", amount = 25, supply = "large"},
        {name = "Prime Rib x5", itemIcon = "🍖", itemName = "dc_primerib", itemDisplayName = "Prime Rib", amount = 5, supply = "small"},
        {name = "Prime Rib x25", itemIcon = "🍖", itemName = "dc_primerib", itemDisplayName = "Prime Rib", amount = 25, supply = "large"},
    },
    supplies = {
        small = {
            requiredItem = "smallboxofdcsupplies",
            requiredItemName = "Small Box of Diamond Casino Supplies",
        },
        large = {
            requiredItem = "largeboxofdcsupplies",
            requiredItemName = "Large Box of Diamond Casino Supplies",
        }
    },
    perms = {"DCSUPPLIES"}
}

suppliesSpot.bratsKeys = {
    name = "Brat's Keys",
    pos = {
        vector3(163.36, 6650.68, 31.66)
    },
    recipes = {
        {name = "Lockpick x5", itemIcon = "🔑", itemName = "lockpick", itemDisplayName = "Lockpick", amount = 5, supply = "small"},
        {name = "Lockpick x25", itemIcon = "🔑", itemName = "lockpick", itemDisplayName = "Lockpick", amount = 25, supply = "large"},
        {name = "Cuff Key x5", itemIcon = "🔑", itemName = "cuffkey", itemDisplayName = "Cuff Key", amount = 5, supply = "small"},
        {name = "Cuff Key x25", itemIcon = "🔑", itemName = "cuffkey", itemDisplayName = "Cuff Key", amount = 25, supply = "large"},
    },
    supplies = {
        small = {
            requiredItem = "smallboxofbksupplies",
            requiredItemName = "Small Box of Brat's Keys Supplies",
        },
        large = {
            requiredItem = "largeboxofbksupplies",
            requiredItemName = "Large Box of Brat's Keys Supplies",
        }
    },
    perms = {"BKSUPPLIES"}
}

suppliesSpot.galaxyNightclub = {
    name = "Galaxy Nightclub",
    pos = {
        vector3(-1577.09, -3018.29, -79.01),
        vector3(-1583.06, -3013.60, -76.02),
        vector3(-1610.68, -3018.78, -75.21),
    },
    recipes = {
        {name = "Cosmopolitain x5", itemIcon = "🍹", itemName = "gn_cosmopolitain", itemDisplayName = "Cosmopolitain", amount = 5, supply = "small"},
        {name = "Cosmopolitain x25", itemIcon = "🍹", itemName = "gn_cosmopolitain", itemDisplayName = "Cosmopolitain", amount = 25, supply = "large"},
        {name = "Galaxy x5", itemIcon = "🥃", itemName = "gn_galaxy", itemDisplayName = "Galaxy", amount = 5, supply = "small"},
        {name = "Galaxy x25", itemIcon = "🥃", itemName = "gn_galaxy", itemDisplayName = "Galaxy", amount = 25, supply = "large"},
        {name = "Lemon Drop x5", itemIcon = "🍹", itemName = "gn_lemondrop", itemDisplayName = "Lemon Drop", amount = 5, supply = "small"},
        {name = "Lemon Drop x25", itemIcon = "🍹", itemName = "gn_lemondrop", itemDisplayName = "Lemon Drop", amount = 25, supply = "large"},
        {name = "Pornstar Martini x5", itemIcon = "🍹", itemName = "gn_pornstarmartini", itemDisplayName = "Pornstar Martini", amount = 5, supply = "small"},
        {name = "Pornstar Martini x25", itemIcon = "🍹", itemName = "gn_pornstarmartini", itemDisplayName = "Pornstar Martini", amount = 25, supply = "large"},
        {name = "Taste Of Diamonds x5", itemIcon = "🍾", itemName = "gn_tasteofdiamonds", itemDisplayName = "Taste Of Diamonds", amount = 5, supply = "small"},
        {name = "Taste Of Diamonds x25", itemIcon = "🍾", itemName = "gn_tasteofdiamonds", itemDisplayName = "Taste Of Diamonds", amount = 25, supply = "large"},
        {name = "Whiskey Sour x5", itemIcon = "🥃", itemName = "gn_whiskeysour", itemDisplayName = "Whiskey Sour", amount = 5, supply = "small"},
        {name = "Whiskey Sour x25", itemIcon = "🥃", itemName = "gn_whiskeysour", itemDisplayName = "Whiskey Sour", amount = 25, supply = "large"},
    },
    supplies = {
        small = {
            requiredItem = "smallboxofgnsupplies",
            requiredItemName = "Small Box of Galaxy Nightclub Supplies",
        },
        large = {
            requiredItem = "largeboxofgnsupplies",
            requiredItemName = "Large Box of Galaxy Nightclub Supplies",
        }
    },
    perms = {"GNSUPPLIES"}
}

suppliesSpot.smIndustries = {
    name = "SM Industries",
    pos = {
        vector3(473.68, -1951.94, 24.60),
    },
    recipes = {
        -- SOONTM
    },
    supplies = {
        small = {
            requiredItem = "smallboxofsisupplies",
            requiredItemName = "Small Box of SM Industries Supplies",
        },
        large = {
            requiredItem = "largeboxofflsupplies",
            requiredItemName = "Large Box of SM Industries Supplies",
        }
    },
    perms = {"SMSUPPLIES", "SMGARAGE"}
}

suppliesSpot.solomonDistilleries = {
    name = "Solomon Distilleries",
    pos = {
        vector3(961.8461, -2503.042, 28.43738),
    },
    recipes = {
        {name = "Lost Lager x5", itemIcon = "🍺", itemName = "sd_lostlager", itemDisplayName = "Lost Lager", amount = 5, supply = "small"},
        {name = "Lost Lager x25", itemIcon = "🍺", itemName = "sd_lostlager", itemDisplayName = "Lost Lager", amount = 25, supply = "large"},
        {name = "Vanilla Unicorn Vodka x5", itemIcon = "🥃", itemName = "sd_vuvodka", itemDisplayName = "Vanilla Unicorn Vodka", amount = 5, supply = "small"},
        {name = "Vanilla Unicorn Vodka x25", itemIcon = "🥃", itemName = "sd_vuvodka", itemDisplayName = "Vanilla Unicorn Vodka", amount = 25, supply = "large"},
        {name = "Petrovka x5", itemIcon = "🥃", itemName = "sd_petrovka", itemDisplayName = "Petrovka", amount = 5, supply = "small"},
        {name = "Petrovka x25", itemIcon = "🥃", itemName = "sd_petrovka", itemDisplayName = "Petrovka", amount = 25, supply = "large"},
        {name = "Ms Clover's x5", itemIcon = "🥃", itemName = "sd_msclovers", itemDisplayName = "Ms Clover's", amount = 5, supply = "small"},
        {name = "Ms Clover's x25", itemIcon = "🥃", itemName = "sd_msclovers", itemDisplayName = "Ms Clover's", amount = 25, supply = "large"},
    },
    supplies = {
        small = {
            requiredItem = "smallboxofsdsupplies",
            requiredItemName = "Small Box of Solomon Distilleries Supplies",
        },
        large = {
            requiredItem = "largeboxofsdsupplies",
            requiredItemName = "Large Box of Solomon Distilleries Supplies",
        }
    },
    perms = {"SDSUPPLIES"}
}

suppliesSpot.solomonDistilleriesGarage = {
    name = "Solomon Distilleries",
    pos = {
        vector3(1018.81, -2511.79, 28.47),
    },
    perms = {"SDGARAGE"}
}

suppliesSpot.celticShield = {
    name = "Celtic Shield Security",
    pos = {
        vector3(871.70, -1016.21, 31.64),
    },
    recipes = {
        {name = "Blank Celtic Security Badge x5", itemIcon = "📛", itemName = "cs_badge_blank", itemDisplayName = "Blank Celtic Security Badge", amount = 5, supply = "small"},
        {name = "Blank Celtic Security Badge x25", itemIcon = "📛", itemName = "cs_badge_blank", itemDisplayName = "Blank Celtic Security Badge", amount = 25, supply = "large"},
    },
    supplies = {
        small = {
            requiredItem = "smallboxofcssupplies",
            requiredItemName = "Small Box of Celtic Security Supplies",
        },
        large = {
            requiredItem = "largeboxofcssupplies",
            requiredItemName = "Large Box of Celtic Security Supplies",
        }
    },
    perms = {"CSSUPPLIES", "CSGARAGE"}
}

suppliesSpot.fourLeafVineyard = {
    name = "Four Leaf Vineyard",
    pos = {
        vector3(-1928.90, 2059.98, 140.83),
    },
    recipes = {
        {name = "WineWood Blanc x5", itemIcon = "🍾", itemName = "fl_winewoodblanc", itemDisplayName = "WineWood Blanc", amount = 5, supply = "small"},
        {name = "WineWood Blanc x25", itemIcon = "🍾", itemName = "fl_winewoodblanc", itemDisplayName = "WineWood Blanc", amount = 25, supply = "large"},
        {name = "Blaue Balle x5", itemIcon = "🍾", itemName = "fl_blaueballe", itemDisplayName = "Blaue Balle", amount = 5, supply = "small"},
        {name = "Blaue Balle x25", itemIcon = "🍾", itemName = "fl_blaueballe", itemDisplayName = "Blaue Balle", amount = 25, supply = "large"},
        {name = "Port Zancudo x5", itemIcon = "🍾", itemName = "fl_portzancudo", itemDisplayName = "Port Zancudo", amount = 5, supply = "small"},
        {name = "Port Zancudo x25", itemIcon = "🍾", itemName = "fl_portzancudo", itemDisplayName = "Port Zancudo", amount = 25, supply = "large"},
        {name = "Les Santos Special x5", itemIcon = "🍾", itemName = "fl_lessantosspecial", itemDisplayName = "Les Santos Special", amount = 5, supply = "small"},
        {name = "Les Santos Special x25", itemIcon = "🍾", itemName = "fl_lessantosspecial", itemDisplayName = "Les Santos Special", amount = 25, supply = "large"},
        {name = "Chardonjay x5", itemIcon = "🍾", itemName = "fl_chardonjay", itemDisplayName = "Chardonjay", amount = 5, supply = "small"},
        {name = "Chardonjay x25", itemIcon = "🍾", itemName = "fl_chardonjay", itemDisplayName = "Chardonjay", amount = 25, supply = "large"},
    },
    supplies = {
        small = {
            requiredItem = "smallboxofflsupplies",
            requiredItemName = "Small Box of Four Leaf Vineyard Supplies",
        },
        large = {
            requiredItem = "largeboxofflsupplies",
            requiredItemName = "Large Box of Four Leaf Vineyard Supplies",
        }
    },
    perms = {"FLSUPPLIES"}
}

suppliesSpot.yellowjack = {
    name = "The Yellow Jack",
    pos = {
        vector3(1981.74, 3052.29, 47.21),
        vector3(1984.06, 3049.66, 47.21),
    },
    recipes = {
        {name = "Boiler Maker x5", itemIcon = "🍺", itemName = "yj_boilermaker", itemDisplayName = "Boiler Maker", amount = 5, supply = "small"},
        {name = "Boiler Maker x25", itemIcon = "🍺", itemName = "yj_boilermaker", itemDisplayName = "Boiler Maker", amount = 25, supply = "large"},
        {name = "Tequila x5", itemIcon = "🍺", itemName = "yj_tequila", itemDisplayName = "Bottle of Tequila", amount = 5, supply = "small"},
        {name = "Tequila x25", itemIcon = "🍺", itemName = "yj_tequila", itemDisplayName = "Bottle of Tequila", amount = 25, supply = "large"},
        {name = "Whiskey x5", itemIcon = "🍺", itemName = "yj_whiskey", itemDisplayName = "Bottle of  Whiskey", amount = 5, supply = "small"},
        {name = "Whiskey x25", itemIcon = "🍺", itemName = "yj_whiskey", itemDisplayName = "Bottle of Whiskey", amount = 25, supply = "large"},
        {name = "Breakfast Burrito x5", itemIcon = "🌯", itemName = "yj_breakfastburrito", itemDisplayName = "Breakfast Burrito", amount = 5, supply = "small"},
        {name = "Breakfast Burrito x25", itemIcon = "🌯", itemName = "yj_breakfastburrito", itemDisplayName = "Breakfast Burrito", amount = 25, supply = "large"},
        {name = "Grilled Cheese & Soup x5", itemIcon = "🥪", itemName = "yj_grilledcheeseandsoup", itemDisplayName = "Grilled Cheese & Soup", amount = 5, supply = "small"},
        {name = "Grilled Cheese & Soup x25", itemIcon = "🥪", itemName = "yj_grilledcheeseandsoup", itemDisplayName = "Grilled Cheese & Soup", amount = 25, supply = "large"},
        {name = "Chicken & Rice x5", itemIcon = "🍗", itemName = "yj_chickenandrice", itemDisplayName = "Chicken & Rice", amount = 5, supply = "small"},
        {name = "Chicken & Rice x25", itemIcon = "🍗", itemName = "yj_chickenandrice", itemDisplayName = "Chicken & Rice", amount = 25, supply = "large"},
    },
    supplies = {
        small = {
            requiredItem = "smallboxofyjsupplies",
            requiredItemName = "Small Box of Yellow Jack Supplies",
        },
        large = {
            requiredItem = "largeboxofyjsupplies",
            requiredItemName = "Large Box of Yellow Jack Supplies",
        }
    },
    perms = {"YJSUPPLIES"}
}

suppliesSpot.luchettis = {
    name = "Luchetti's",
    pos = {
        vector3(288.58, -985.13, 29.43),
        vector3(285.15, -983.76, 29.43),
    },
    recipes = {
        {name = "Baked Ziti x5", itemIcon = "🍝", itemName = "lu_bakedziti", itemDisplayName = "Baked Ziti", amount = 5, supply = "small"},
        {name = "Baked Ziti x25", itemIcon = "🍝", itemName = "lu_bakedziti", itemDisplayName = "Baked Ziti", amount = 25, supply = "large"},
        {name = "Cannoli x5", itemIcon = "🌯", itemName = "lu_cannoli", itemDisplayName = "Cannoli", amount = 5, supply = "small"},
        {name = "Cannoli x25", itemIcon = "🌯", itemName = "lu_cannoli", itemDisplayName = "Cannoli", amount = 25, supply = "large"},
        {name = "Devine Deli x5", itemIcon = "🥪", itemName = "lu_devinedeli", itemDisplayName = "Devine Deli", amount = 5, supply = "small"},
        {name = "Devine Deli x25", itemIcon = "🥪", itemName = "lu_devinedeli", itemDisplayName = "Devine Deli", amount = 25, supply = "large"},
        {name = "Fettucineal Fredo x5", itemIcon = "🍝", itemName = "lu_fettucinealfredo", itemDisplayName = "Fettucineal Fredo", amount = 5, supply = "small"},
        {name = "Fettucineal Fredo x25", itemIcon = "🍝", itemName = "lu_fettucinealfredo", itemDisplayName = "Fettucineal Fredo", amount = 25, supply = "large"},
        {name = "Manicotti x5", itemIcon = "🌯", itemName = "lu_manicotti", itemDisplayName = "Manicotti", amount = 5, supply = "small"},
        {name = "Manicotti x25", itemIcon = "🌯", itemName = "lu_manicotti", itemDisplayName = "Manicotti", amount = 25, supply = "large"},
        {name = "Spaghetti x5", itemIcon = "🍝", itemName = "lu_spaghetti", itemDisplayName = "Spaghetti", amount = 5, supply = "small"},
        {name = "Spaghetti x25", itemIcon = "🍝", itemName = "lu_spaghetti", itemDisplayName = "Spaghetti", amount = 25, supply = "large"},
        {name = "Tiramisu x5", itemIcon = "🍰", itemName = "lu_tiramisu", itemDisplayName = "Tiramisu", amount = 5, supply = "small"},
        {name = "Tiramisu x25", itemIcon = "🍰", itemName = "lu_tiramisu", itemDisplayName = "Tiramisu", amount = 25, supply = "large"},
    },
    supplies = {
        small = {
            requiredItem = "smallboxoflusupplies",
            requiredItemName = "Small Box of Luchetti's Supplies",
        },
        large = {
            requiredItem = "largeboxoflusupplies",
            requiredItemName = "Large Box of Luchetti's Supplies",
        }
    },
    perms = {"LUSUPPLIES"}
}

suppliesSpot.stewartsOutdoorAdventures = {
    name = "Stewart's Outdoor Adventures",
    pos = {
        vector3(-712.40, -1298.74, 5.10),
    },
    perms = {"SOGARAGE", "SOSEA"}
}

suppliesSpot.strykerAir = {
    name = "Stryker Air",
    pos = {
        vector3(-704.20, -1398.54, 5.49),
    },
    perms = {"SAGARAGE", "SAAIR"}
}

suppliesSpot.sanAndreasVehicleRentals = {
    name = "San Andreas Vehicle Rentals",
    garages = 3,
    pos = {
        vector3(-150.15, -165.49, 43.62),
    },
    perms = {"SRGARAGE", "SRGARAGECLIENT"}
}

suppliesSpot.satosNoodleExchange = {
    name = "Sato's Noodle Exchange",
    pos = {
        vector3(-1238.89, -267.88, 37.75),
    },
    recipes = {
        {name = "Braised Beef Ramen x5", itemIcon = "🍜", itemName = "sn_braisedbeeframen", itemDisplayName = "Braised Beef Ramen", amount = 5, supply = "small"},
        {name = "Braised Beef Ramen x25", itemIcon = "🍜", itemName = "sn_braisedbeeframen", itemDisplayName = "Braised Beef Ramen", amount = 25, supply = "large"},
        {name = "Gyoza x5", itemIcon = "🥟", itemName = "sn_gyoza", itemDisplayName = "Gyoza", amount = 5, supply = "small"},
        {name = "Gyoza x25", itemIcon = "🥟", itemName = "sn_gyoza", itemDisplayName = "Gyoza", amount = 25, supply = "large"},
        {name = "Japanese Pan Noodles x5", itemIcon = "🍝", itemName = "sn_japanesepannoodles", itemDisplayName = "Japanese Pan Noodles", amount = 5, supply = "small"},
        {name = "Japanese Pan Noodles x25", itemIcon = "🍝", itemName = "sn_japanesepannoodles", itemDisplayName = "Japanese Pan Noodles", amount = 25, supply = "large"},
        {name = "Lemon Ice Tea x5", itemIcon = "🥤", itemName = "sn_lemonicetea", itemDisplayName = "Lemon Ice Tea", amount = 5, supply = "small"},
        {name = "Lemon Ice Tea x25", itemIcon = "🥤", itemName = "sn_lemonicetea", itemDisplayName = "Lemon Ice Tea", amount = 25, supply = "large"},
        {name = "Pad Thai x5", itemIcon = "🍝", itemName = "sn_padthai", itemDisplayName = "Pad Thai", amount = 5, supply = "small"},
        {name = "Pad Thai x25", itemIcon = "🍝", itemName = "sn_padthai", itemDisplayName = "Pad Thai", amount = 25, supply = "large"},
        {name = "Stir Fry Chicken Noodles x5", itemIcon = "🍝", itemName = "sn_stirfrychickennoodles", itemDisplayName = "Stir Fry Chicken Noodles", amount = 5, supply = "small"},
        {name = "Stir Fry Chicken Noodles x25", itemIcon = "🍝", itemName = "sn_stirfrychickennoodles", itemDisplayName = "Stir Fry Chicken Noodles", amount = 25, supply = "large"},
    },
    supplies = {
        small = {
            requiredItem = "smallboxofsnsupplies",
            requiredItemName = "Small Box of Sato's Noodle Exchange Supplies",
        },
        large = {
            requiredItem = "largeboxofsnsupplies",
            requiredItemName = "Large Box of Sato's Noodle Exchange Supplies",
        }
    },
    perms = {"SNSUPPLIES"}
}

suppliesSpot.satosNoodleExchangeGarage = {
    name = "Sato's Noodle Exchange Garage",
    pos = {
        vector3(-1232.35, -261.48, 38.72),
    },
    perms = {"SNGARAGE"}
}

suppliesSpot.luckyLeprechaunAleHouse = {
    name = "Lucky Leprechaun Ale House",
    pos = {
        vector3(1220.11, -419.50, 67.76),
    },
    recipes = {
        {name = "Coddle x5", itemIcon = "🍲", itemName = "lh_coddle", itemDisplayName = "Coddle", amount = 5, supply = "small"},
        {name = "Coddle x25", itemIcon = "🍲", itemName = "lh_coddle", itemDisplayName = "Coddle", amount = 25, supply = "large"},
        {name = "Fish & Chips x5", itemIcon = "🍟", itemName = "lh_fishandchips", itemDisplayName = "Fish & Chips", amount = 5, supply = "small"},
        {name = "Fish & Chips x25", itemIcon = "🍟", itemName = "lh_fishandchips", itemDisplayName = "Fish & Chips", amount = 25, supply = "large"},
        {name = "Guinness Pint x5", itemIcon = "🍺", itemName = "lh_guinnesspint", itemDisplayName = "Guinness Pint", amount = 5, supply = "small"},
        {name = "Guinness Pint x25", itemIcon = "🍺", itemName = "lh_guinnesspint", itemDisplayName = "Guinness Pint", amount = 25, supply = "large"},
        {name = "Jameson x5", itemIcon = "🍾", itemName = "lh_jameson", itemDisplayName = "Jameson", amount = 5, supply = "small"},
        {name = "Jameson x25", itemIcon = "🍾", itemName = "lh_jameson", itemDisplayName = "Jameson", amount = 25, supply = "large"},
        {name = "Smithwicks x5", itemIcon = "🍺", itemName = "lh_smithwicks", itemDisplayName = "Smithwicks", amount = 5, supply = "small"},
        {name = "Smithwicks x25", itemIcon = "🍺", itemName = "lh_smithwicks", itemDisplayName = "Smithwicks", amount = 25, supply = "large"},
        {name = "Boozy Shamrock Shake x5", itemIcon = "🍺", itemName = "lh_shamrockshake", itemDisplayName = "Shamrock Shake", amount = 5, supply = "small"},
        {name = "Boozy Shamrock Shake x25", itemIcon = "🍺", itemName = "lh_shamrockshake", itemDisplayName = "Shamrock Shake", amount = 25, supply = "large"},
        {name = "Soda Bread x5", itemIcon = "🍞", itemName = "lh_sodabread", itemDisplayName = "Soda Bread", amount = 5, supply = "small"},
        {name = "Soda Bread x25", itemIcon = "🍞", itemName = "lh_sodabread", itemDisplayName = "Soda Bread", amount = 25, supply = "large"},
    },
    supplies = {
        small = {
            requiredItem = "smallboxoflhsupplies",
            requiredItemName = "Small Box of Lucky Leprechaun Supplies",
        },
        large = {
            requiredItem = "largeboxoflhsupplies",
            requiredItemName = "Large Box of Lucky Leprechaun Supplies",
        }
    },
    perms = {"LHSUPPLIES"}
}

suppliesSpot.rabbitHole = {
    name = "Rabbit Hole",
    pos = {
        vector3(1121.06, -3143.12, -37.07),
    },
    recipes = {
        {name = "Between The Hops IPA x5", itemIcon = "🍺", itemName = "rh_betweenhops", itemDisplayName = "Between The Hops IPA", amount = 5, supply = "small"},
        {name = "Between The Hops IPA x25", itemIcon = "🍺", itemName = "rh_betweenhops", itemDisplayName = "Between The Hops IPA", amount = 25, supply = "large"},
        {name = "Nachos & Cheese x5", itemIcon = "🧀", itemName = "rh_nachosandcheese", itemDisplayName = "Nachos & Cheese", amount = 5, supply = "small"},
        {name = "Nachos & Cheese x25", itemIcon = "🧀", itemName = "rh_nachosandcheese", itemDisplayName = "Nachos & Cheese", amount = 25, supply = "large"},
        {name = "Outsiders Ale x5", itemIcon = "🍺", itemName = "rh_outsidersale", itemDisplayName = "Outsiders Ale", amount = 5, supply = "small"},
        {name = "Outsiders Ale x25", itemIcon = "🍺", itemName = "rh_outsidersale", itemDisplayName = "Outsiders Ale", amount = 25, supply = "large"},
        {name = "Paleto Porter x5", itemIcon = "🍺", itemName = "rh_paletoporter", itemDisplayName = "Paleto Porter", amount = 5, supply = "small"},
        {name = "Paleto Porter x25", itemIcon = "🍺", itemName = "rh_paletoporter", itemDisplayName = "Paleto Porter", amount = 25, supply = "large"},
        {name = "Peanuts x5", itemIcon = "🥜", itemName = "rh_peanuts", itemDisplayName = "Peanuts", amount = 5, supply = "small"},
        {name = "Peanuts x25", itemIcon = "🥜", itemName = "rh_peanuts", itemDisplayName = "Peanuts", amount = 25, supply = "large"},
        {name = "PRIC Stout x5", itemIcon = "🍺", itemName = "rh_pricstout", itemDisplayName = "PRIC Stout", amount = 5, supply = "small"},
        {name = "PRIC Stout x25", itemIcon = "🍺", itemName = "rh_pricstout", itemDisplayName = "PRIC Stout", amount = 25, supply = "large"},
    },
    supplies = {
        small = {
            requiredItem = "smallboxofrhsupplies",
            requiredItemName = "Small Box of Rabbit Hole Supplies",
        },
        large = {
            requiredItem = "largeboxofrhsupplies",
            requiredItemName = "Large Box of Rabbit Hole Supplies",
        }
    },
    perms = {"RHSUPPLIES"}
}

suppliesSpot.luckLeprechaunGarage = {
    name = "Lucky Leprechaun Garage",
    pos = {
        vector3(1217.64, -424.11, 67.58),
    },
    perms = {"LHGARAGE"}
}

suppliesSpot.skinnyDicksTowing = {
    name = "Skinny Dick's Towing Garage",
    pos = {
        vector3(948.63, -1010.33, 42.00),
    },
    perms = {"STGARAGE"}
}

suppliesSpot.tlmcCustomsAndTowGarage = {
    name = "TLMC Customs and Tow Garage",
    pos = {
        vector3(989.50, -135.93, 74.05),
    },
    perms = {"LMGARAGE"}
}

suppliesSpot.bento = {
    name = "Bento",
    pos = {
        vector3(-176.91, 304.71, 97.45),
        vector3(-177.43, 301.96, 97.45),
        vector3(-172.84, 301.56, 97.45),
    },
    recipes = {
        {name = "Bubble Tea x5", itemIcon = "🥤", itemName = "bt_bubbletea", itemDisplayName = "Bubble Tea", amount = 5, supply = "small"},
        {name = "Bubble Tea x25", itemIcon = "🥤", itemName = "bt_bubbletea", itemDisplayName = "Bubble Tea", amount = 25, supply = "large"},
        {name = "Chicken Bento x5", itemIcon = "🍱", itemName = "bt_chickenbento", itemDisplayName = "Chicken Bento", amount = 5, supply = "small"},
        {name = "Chicken Bento x25", itemIcon = "🍱", itemName = "bt_chickenbento", itemDisplayName = "Chicken Bento", amount = 25, supply = "large"},
        {name = "Nogogi Bento x5", itemIcon = "🍱", itemName = "bt_nogogibento", itemDisplayName = "Nogogi Bento", amount = 5, supply = "small"},
        {name = "Nogogi Bento x25", itemIcon = "🍱", itemName = "bt_nogogibento", itemDisplayName = "Nogogi Bento", amount = 25, supply = "large"},
        {name = "Pork Bento x5", itemIcon = "🍱", itemName = "bt_porkbento", itemDisplayName = "Pork Bento", amount = 5, supply = "small"},
        {name = "Pork Bento x25", itemIcon = "🍱", itemName = "bt_porkbento", itemDisplayName = "Pork Bento", amount = 25, supply = "large"},
        {name = "Sushi Platter x5", itemIcon = "🍣", itemName = "bt_sushiplatter", itemDisplayName = "Sushi Platter", amount = 5, supply = "small"},
        {name = "Sushi Platter x25", itemIcon = "🍣", itemName = "bt_sushiplatter", itemDisplayName = "Sushi Platter", amount = 25, supply = "large"},
        {name = "Takoyaki x5", itemIcon = "🐙", itemName = "bt_takoyaki", itemDisplayName = "Takoyaki", amount = 5, supply = "small"},
        {name = "Takoyaki x25", itemIcon = "🐙", itemName = "bt_takoyaki", itemDisplayName = "Takoyaki", amount = 25, supply = "large"},
    },
    supplies = {
        small = {
            requiredItem = "smallboxofbtsupplies",
            requiredItemName = "Small Box of Bento Supplies",
        },
        large = {
            requiredItem = "largeboxofbtsupplies",
            requiredItemName = "Large Box of Bento Supplies",
        }
    },
    perms = {"BTSUPPLIES"}
}

suppliesSpot.bentoGarage = {
    name = "Bento Garage",
    pos = {
        vector3(-172.33, 320.27, 97.98),
    },
    perms = {"BTGARAGE"}
}

suppliesSpot.streamlineSalesAndRepairsGarage = {
    name = "Streamline Sales and Repairs Garage",
    pos = {
        vector3(-19.85, -1086.79, 26.57),
    },
    perms = {"SLGARAGE"}
}

suppliesSpot.weazelNewsGarage = {
    name = "Weazel News Garage",
    pos = {
        vector3(-563.01, -887.04, 25.19),
    },
    perms = {"WNGARAGE"}
}

suppliesSpot.bestBuds = {
    name = "Best Buds",
    pos = {
        vector3(375.61, -824.19, 29.30),
        vector3(382.23, -816.40, 29.30),
    },
    recipes = {
        {name = "Starburst THC Gummies x5", itemIcon = "🍬", itemName = "bb_starburstthcgummies", itemDisplayName = "Starburst THC Gummies", amount = 5, supply = "small"},
        {name = "Starburst THC Gummies x25", itemIcon = "🍬", itemName = "bb_starburstthcgummies", itemDisplayName = "Starburst THC Gummies", amount = 25, supply = "large"},
        {name = "Cookies And Cream Bar x5", itemIcon = "🍫", itemName = "bb_cookiesandcreambar", itemDisplayName = "Cookies And Cream Bar", amount = 5, supply = "small"},
        {name = "Cookies And Cream Bar x25", itemIcon = "🍫", itemName = "bb_cookiesandcreambar", itemDisplayName = "Cookies And Cream Bar", amount = 25, supply = "large"},
        {name = "Cannabis Brownie x5", itemIcon = "🍪", itemName = "bb_cannabisbrownie", itemDisplayName = "Cannabis Brownie", amount = 5, supply = "small"},
        {name = "Cannabis Brownie x25", itemIcon = "🍪", itemName = "bb_cannabisbrownie", itemDisplayName = "Cannabis Brownie", amount = 25, supply = "large"},
        {name = "Pineapple Express Joint x5", itemIcon = "🚬", itemName = "bb_joint_pineappleexpress", itemDisplayName = "Pineapple Express Joint", amount = 5, supply = "small"},
        {name = "Pineapple Express Joint x25", itemIcon = "🚬", itemName = "bb_joint_pineappleexpress", itemDisplayName = "Pineapple Express Joint", amount = 25, supply = "large"},
        {name = "Chernobyl Joint x5", itemIcon = "🚬", itemName = "bb_joint_chernobyl", itemDisplayName = "Chernobyl Joint", amount = 5, supply = "small"},
        {name = "Chernobyl Joint x25", itemIcon = "🚬", itemName = "bb_joint_chernobyl", itemDisplayName = "Chernobyl Joint", amount = 25, supply = "large"},
        {name = "Seed Packet x5", itemIcon = "🌿", itemName = "bb_seedpacket", itemDisplayName = "Seed Packet", amount = 5, supply = "small"},
        {name = "Seed Packet x25", itemIcon = "🌿", itemName = "bb_seedpacket", itemDisplayName = "Seed Packet", amount = 25, supply = "large"},
        {name = "Pumpkin Spice Cannabis Roll x5", itemIcon = "🍪", itemName = "bb_pumpkinspice", itemDisplayName = "Pumpkin Spice Cannabis Roll", amount = 5, supply = "small"},
        {name = "Pumpkin Spice Cannabis Roll x25", itemIcon = "🍪", itemName = "bb_pumpkinspice", itemDisplayName = "Pumpkin Spice Cannabis Roll", amount = 25, supply = "large"},
    },
    supplies = {
        small = {
            requiredItem = "smallboxofbbsupplies",
            requiredItemName = "Small Box of Best Buds Supplies",
        },
        large = {
            requiredItem = "largeboxofbbsupplies",
            requiredItemName = "Large Box of Best Buds Supplies",
        }
    },
    perms = {"BBSUPPLIES"}
}

suppliesSpot.bestBudsGarage = {
    name = "Best Buds Garage",
    pos = {
        vector3(372.03, -827.17, 29.28),
    },
    perms = {"BBGARAGE"}
}

suppliesSpot.coolBeans = {
    name = "Cool Beans",
    pos = {
        vector3(-1198.00, -1144.81, 7.83),
        vector3(-1199.76, -1141.23, 7.83),
        vector3(-1197.13, -1142.85, 7.83),
    },
    recipes = {
        {name = "Little Balls x5", itemIcon = "🍩", itemName = "cb_littleballs", itemDisplayName = "Little Balls", amount = 5, supply = "small"},
        {name = "Little Balls x25", itemIcon = "🍩", itemName = "cb_littleballs", itemDisplayName = "Little Balls", amount = 25, supply = "large"},
        {name = "Cream Pie x5", itemIcon = "🧁", itemName = "cb_creampie", itemDisplayName = "Cream Pie", amount = 5, supply = "small"},
        {name = "Cream Pie x25", itemIcon = "🧁", itemName = "cb_creampie", itemDisplayName = "Cream Pie", amount = 25, supply = "large"},
        {name = "Cakepops x5", itemIcon = "🍭", itemName = "cb_cakepops", itemDisplayName = "Cakepops", amount = 5, supply = "small"},
        {name = "Cakepops x25", itemIcon = "🍭", itemName = "cb_cakepops", itemDisplayName = "Cakepops", amount = 25, supply = "large"},
        {name = "Dirty Chai x5", itemIcon = "☕", itemName = "cb_dirtychai", itemDisplayName = "Dirty Chai", amount = 5, supply = "small"},
        {name = "Dirty Chai x25", itemIcon = "☕", itemName = "cb_dirtychai", itemDisplayName = "Dirty Chai", amount = 25, supply = "large"},
        {name = "Peach Tea x5", itemIcon = "🥤", itemName = "cb_peachtea", itemDisplayName = "Peach Tea", amount = 5, supply = "small"},
        {name = "Peach Tea x25", itemIcon = "🥤", itemName = "cb_peachtea", itemDisplayName = "Peach Tea", amount = 25, supply = "large"},
        {name = "Iced Coffee With Donut x5", itemIcon = "🥤", itemName = "cb_icedcoffeewithdonut", itemDisplayName = "Iced Coffee With Donut", amount = 5, supply = "small"},
        {name = "Iced Coffee With Donut x25", itemIcon = "🥤", itemName = "cb_icedcoffeewithdonut", itemDisplayName = "Iced Coffee With Donut", amount = 25, supply = "large"},
    },
    supplies = {
        small = {
            requiredItem = "smallboxofcbsupplies",
            requiredItemName = "Small Box of Cool Beans Supplies",
        },
        large = {
            requiredItem = "largeboxofcbsupplies",
            requiredItemName = "Large Box of Cool Beans Supplies",
        }
    },
    perms = {"CBSUPPLIES"}
}

suppliesSpot.coolBeansGarage = {
    name = "Cool Beans Garage",
    pos = {
        vector3(-1182.92, -1132.30, 5.69),
    },
    perms = {"CBGARAGE"}
}

suppliesSpot.reflectionsAutocareGarage = {
    name = "Reflections Autocare Garage",
    pos = {
        vector3(1132.52, -798.59, 57.57),
    },
    perms = {"RAGARAGE"}
}

suppliesSpot.prestigeAutoGarage = {
    name = "Prestige Auto Garage",
    pos = {
        vector3(-354.7253, -128.2549, 39.42346),
    },
    perms = {"PAGARAGE"}
}

suppliesSpot.pantherSuppliesGarage = {
    name = "Panther Supplies Inc. Garage",
    pos = {
        vector3(-844.1274, -2790.976, 13.94653),
    },
    perms = {"PSGARAGE"}
}

suppliesSpot.henHouse = {
    name = "Hen House",
    pos = {
        vector3(-299.05, 6271.36, 31.47),
        vector3(-296.36, 6262.93, 31.47),
    },
    recipes = {
        {name = "Meat Lovers Omelette x5", itemIcon = "🍳", itemName = "hh_meatloversomlette", itemDisplayName = "Meat Lovers Omelette", amount = 5, supply = "small"},
        {name = "Meat Lovers Omelette x25", itemIcon = "🍳", itemName = "hh_meatloversomlette", itemDisplayName = "Meat Lovers Omelette", amount = 25, supply = "large"},
        {name = "Marinated Grilled Chicken x5", itemIcon = "🍗", itemName = "hh_marinatedgrilledchicken", itemDisplayName = "Marinated Grilled Chicken", amount = 5, supply = "small"},
        {name = "Marinated Grilled Chicken x25", itemIcon = "🍗", itemName = "hh_marinatedgrilledchicken", itemDisplayName = "Marinated Grilled Chicken", amount = 25, supply = "large"},
        {name = "Fried Chicken x5", itemIcon = "🍗", itemName = "hh_friedchicken", itemDisplayName = "Fried Chicken", amount = 5, supply = "small"},
        {name = "Fried Chicken x25", itemIcon = "🍗", itemName = "hh_friedchicken", itemDisplayName = "Fried Chicken", amount = 25, supply = "large"},
        {name = "Chicken Mac x5", itemIcon = "🧀", itemName = "hh_chickenmac", itemDisplayName = "Chicken Mac", amount = 5, supply = "small"},
        {name = "Chicken Mac x25", itemIcon = "🧀", itemName = "hh_chickenmac", itemDisplayName = "Chicken Mac", amount = 25, supply = "large"},
        {name = "Tater Nachos x5", itemIcon = "🧀", itemName = "hh_taternachos", itemDisplayName = "Tater Nachos", amount = 5, supply = "small"},
        {name = "Tater Nachos x25", itemIcon = "🧀", itemName = "hh_taternachos", itemDisplayName = "Tater Nachos", amount = 25, supply = "large"},
        {name = "Shot of Jager Bomb x5", itemIcon = "🥃", itemName = "hh_jaegerbomb", itemDisplayName = "Shot of Jager Bomb", amount = 5, supply = "small"},
        {name = "Shot of Jager Bomb x25", itemIcon = "🥃", itemName = "hh_jaegerbomb", itemDisplayName = "Shot of Jager Bomb", amount = 25, supply = "large"},
    },
    supplies = {
        small = {
            requiredItem = "smallboxofhhsupplies",
            requiredItemName = "Small Box of Hen House Supplies",
        },
        large = {
            requiredItem = "largeboxofhhsupplies",
            requiredItemName = "Large Box of Hen House Supplies",
        }
    },
    perms = {"HHSUPPLIES"}
}

suppliesSpot.henHouseGarage = {
    name = "Hen House Garage",
    pos = {
        vector3(-304.33, 6286.92, 31.49),
    },
    perms = {"HHGARAGE"}
}

suppliesSpot.fpLogisticsGarage = {
    name = "FP Logistics Garage",
    pos = {
        vector3(844.77, -891.82, 25.25),
    },
    perms = {"FPGARAGE"}
}

suppliesSpot.sexOnTheBeach = {
    name = "Sex On The Beach",
    pos = {
        vector3(-169.36, 233.14, 88.04),
    },
    recipes = {
        {name = "The Step Fred x5", itemIcon = "📦", itemName = "sb_stepfred", itemDisplayName = "The Step Fred", amount = 5, supply = "small"},
        {name = "The Step Fred x25", itemIcon = "📦", itemName = "sb_stepfred", itemDisplayName = "The Step Fred", amount = 25, supply = "large"},
        {name = "The Frostdickle x5", itemIcon = "📦", itemName = "sb_frostdickle", itemDisplayName = "The Frostdickle", amount = 5, supply = "small"},
        {name = "The Frostdickle x25", itemIcon = "📦", itemName = "sb_frostdickle", itemDisplayName = "The Frostdickle", amount = 25, supply = "large"},
        {name = "The Goose x5", itemIcon = "📦", itemName = "sb_goose", itemDisplayName = "The Goose", amount = 5, supply = "small"},
        {name = "The Goose x25", itemIcon = "📦", itemName = "sb_goose", itemDisplayName = "The Goose", amount = 25, supply = "large"},
        {name = "Lube x5", itemIcon = "📦", itemName = "sb_lube", itemDisplayName = "Sex on the beach Lube", amount = 5, supply = "small"},
        {name = "Lube x25", itemIcon = "📦", itemName = "sb_lube", itemDisplayName = "Sex on the beach Lube", amount = 25, supply = "large"},
        {name = "Heidi Sex Doll x5", itemIcon = "📦", itemName = "sb_heidi", itemDisplayName = "Sex on the beach Heidi", amount = 5, supply = "small"},
        {name = "Heidi Sex Doll x25", itemIcon = "📦", itemName = "sb_heidi", itemDisplayName = "Sex on the beach Heidi", amount = 25, supply = "large"},
    },
    supplies = {
        small = {
            requiredItem = "smallboxofsbsupplies",
            requiredItemName = "Small Box of Sex On The Beach Supplies",
        },
        large = {
            requiredItem = "largeboxofsbsupplies",
            requiredItemName = "Large Box of Sex On The Beach Supplies",
        }
    },
    perms = {"SBSUPPLIES"}
}

suppliesSpot.sexOnTheBeachGarage = {
    name = "Sex On The Beach Garage",
    pos = {
        vector3(-172.48, 218.37, 89.89),
    },
    perms = {"SBGARAGE"}
}

suppliesSpot.dextersCustomsCars = {
    name = "Dexter's Custom Cars Garage",
    pos = {
        vector3(1217.62, 2740.33, 37.99),
    },
    perms = {"DCGARAGE"}
}

suppliesSpot.oryanAutocareGarage = {
    name = "O'Ryan Autocare Garage",
    pos = {
        vector3(911.76, -976.79, 39.49),
    },
    perms = {"OAGARAGE"}
}

suppliesSpot.williamsCustomMotorworksGarage = {
    name = "Williams Custom Motorworks Garage",
    pos = {
        vector3(-205.94, -1327.58, 30.89),
    },
    perms = {"WCGARAGE"}
}

suppliesSpot.losSantosLogisticsGarage = {
    name = "Los Santos Logistics Garage",
    pos = {
        vector3(96.76, -2216.23, 6.16),
    },
    perms = {"LSGARAGE"}
}

suppliesSpot.scrillasMovingServiceGarage = {
    name = "Scrilla's Moving Service Garage",
    pos = {
        vector3(715.49, -974.47, 24.90),
    },
    perms = {"SSGARAGE"}
}

suppliesSpot.londonCustoms = {
    name = "London Customs Garage",
    pos = {
        vector3(-33.61, -1025.57, 28.79),
    },
    perms = {"LCGARAGE"}
}

suppliesSpot.havenResortAndSpa = {
    name = "Haven Resort And Spa",
    pos = {
        vector3(-2992.59, 49.46, 12.26),
        vector3(-2990.59, 54.75, 12.26),
        vector3(-3040.35, 82.36, 12.82),
    },
    recipes = {
        {name = "Meat Board x5", itemIcon = "🍗", itemName = "hs_meatboard", itemDisplayName = "Meat Board", amount = 5, supply = "small"},
        {name = "Meat Board x25", itemIcon = "🍗", itemName = "hs_meatboard", itemDisplayName = "Meat Board", amount = 25, supply = "large"},
        {name = "Baby Bear x5", itemIcon = "🥤", itemName = "hs_babybear", itemDisplayName = "Baby Bear", amount = 5, supply = "small"},
        {name = "Baby Bear x25", itemIcon = "🥤", itemName = "hs_babybear", itemDisplayName = "Baby Bear", amount = 25, supply = "large"},
        {name = "Lemon and Cucumber Water x5", itemIcon = "🥤", itemName = "hs_lemonandcucumberwater", itemDisplayName = "Lemon and Cucumber Water", amount = 5, supply = "small"},
        {name = "Lemon and Cucumber Water x25", itemIcon = "🥤", itemName = "hs_lemonandcucumberwater", itemDisplayName = "Lemon and Cucumber Water", amount = 25, supply = "large"},
        {name = "Smokey Sunrise x5", itemIcon = "🥃", itemName = "hs_kentuckysunrise", itemDisplayName = "Smokey Sunrise", amount = 5, supply = "small"},
        {name = "Smokey Sunrise x25", itemIcon = "🥃", itemName = "hs_kentuckysunrise", itemDisplayName = "Smokey Sunrise", amount = 25, supply = "large"},
        {name = "Pool Float x5", itemIcon = "📦", itemName = "hs_float", itemDisplayName = "Pool Float", amount = 5, supply = "small"},
        {name = "Pool Float x25", itemIcon = "📦", itemName = "hs_float", itemDisplayName = "Pool Float", amount = 25, supply = "large"},
        {name = "Soft Spa Robe x5", itemIcon = "📦", itemName = "hs_softsparobe", itemDisplayName = "Soft Spa Robe", amount = 5, supply = "small"},
        {name = "Soft Spa Robe x25", itemIcon = "📦", itemName = "hs_softsparobe", itemDisplayName = "Soft Spa Robe", amount = 25, supply = "large"},
    },
    supplies = {
        small = {
            requiredItem = "smallboxofhssupplies",
            requiredItemName = "Small Box of Haven Resort And Spa Supplies",
        },
        large = {
            requiredItem = "largeboxofhssupplies",
            requiredItemName = "Large Box of Haven Resort And Spa Supplies",
        }
    },
    perms = {"HSSUPPLIES"}
}

suppliesSpot.havenResortAndSpaGarage = {
    name = "Haven Resort And Spa Garage",
    pos = {
        vector3(-2963.22, 65.22, 11.60),
    },
    perms = {"HSGARAGE"}
}

suppliesSpot.arcadeorama = {
    name = "Arcade O'Rama",
    pos = {
        vector3(738.91, -826.22, 22.66),
        vector3(736.48, -824.28, 22.66)
    },
    recipes = {
        {name = "Nachos x5", itemIcon = "🧀", itemName = "ao_nachos", itemDisplayName = "Nachos", amount = 5, supply = "small"},
        {name = "Nachos x25", itemIcon = "🧀", itemName = "ao_nachos", itemDisplayName = "Nachos", amount = 25, supply = "large"},
        {name = "Chicken Nuggets x5", itemIcon = "🍗", itemName = "ao_chickennuggets", itemDisplayName = "Chicken Nuggets", amount = 5, supply = "small"},
        {name = "Chicken Nugget x25", itemIcon = "🍗", itemName = "ao_chickennuggets", itemDisplayName = "Chicken Nuggets", amount = 25, supply = "large"},
        {name = "Pizza x5", itemIcon = "🧀", itemName = "ao_pizza", itemDisplayName = "Pizza", amount = 5, supply = "small"},
        {name = "Pizza x25", itemIcon = "🧀", itemName = "ao_pizza", itemDisplayName = "Pizza", amount = 25, supply = "large"},
        {name = "Chilli Cheese Tops x5", itemIcon = "🧀", itemName = "ao_chillicheese", itemDisplayName = "Chilli Cheese Tops", amount = 5, supply = "small"},
        {name = "Chilli Cheese Tops x25", itemIcon = "🧀", itemName = "ao_chillicheese", itemDisplayName = "Chilli Cheese Tops", amount = 25, supply = "large"},
        {name = "Rocket Fuel x5", itemIcon = "🍺", itemName = "ao_rocketfuel", itemDisplayName = "Rocket Fuel", amount = 5, supply = "small"},
        {name = "Rocket Fuel x25", itemIcon = "🍺", itemName = "ao_rocketfuel", itemDisplayName = "Rocket Fuel", amount = 25, supply = "large"},
        {name = "Milkshake x5", itemIcon = "🥤", itemName = "ao_milkshake", itemDisplayName = "Milkshake", amount = 5, supply = "small"},
        {name = "Milkshake x25", itemIcon = "🥤", itemName = "ao_milkshake", itemDisplayName = "Milkshake", amount = 25, supply = "large"},
    },
    supplies = {
        small = {
            requiredItem = "smallboxofaosupplies",
            requiredItemName = "Small Box of Arcade O'Rama Supplies",
        },
        large = {
            requiredItem = "largeboxofaosupplies",
            requiredItemName = "Large Box of Arcade O'Rama Supplies",
        }
    },
    perms = {"AOSUPPLIES"}
}


suppliesSpot.lnbCandies = {
    name = "L And B Candies",
    pos = {
        vector3(-146.38, 6303.52, 31.56),
        vector3(-164.2, 6306.11, 31.3),
    },
    recipes = {
        {name = "Kitten Candy x5", itemIcon = "🍬", itemName = "lb_kittencandy", itemDisplayName = "Kitten Candy", amount = 5, supply = "small"},
        {name = "Kitten Candy x25", itemIcon = "🍬", itemName = "lb_kittencandy", itemDisplayName = "Kitten Candy", amount = 25, supply = "large"},
        {name = "Puppy Candy x5", itemIcon = "🍬", itemName = "lb_puppycandy", itemDisplayName = "Puppy Candy", amount = 5, supply = "small"},
        {name = "Puppy Candy x25", itemIcon = "🍬", itemName = "lb_puppycandy", itemDisplayName = "Puppy Candy", amount = 25, supply = "large"},
        {name = "Peanut Butter Chocolate Bar x5", itemIcon = "🍫", itemName = "lb_peanutchoc", itemDisplayName = "Peanut Butter Chocolate Bar", amount = 5, supply = "small"},
        {name = "Peanut Butter Chocolate Bar x25", itemIcon = "🍫", itemName = "lb_peanutchoc", itemDisplayName = "Peanut Butter Chocolate Bar", amount = 25, supply = "large"},
        {name = "Milk Chocolate Bar x5", itemIcon = "🍫", itemName = "lb_milkchoc", itemDisplayName = "Milk Chocolate Bar", amount = 5, supply = "small"},
        {name = "Milk Chocolate Bar x25", itemIcon = "🍫", itemName = "lb_milkchoc", itemDisplayName = "Milk Chocolate Bar", amount = 25, supply = "large"},
        {name = "White Chocolate Bar x5", itemIcon = "🍫", itemName = "lb_whitechoc", itemDisplayName = "White Chocolate Bar", amount = 5, supply = "small"},
        {name = "White Chocolate Bar x25", itemIcon = "🍫", itemName = "lb_whitechoc", itemDisplayName = "White Chocolate Bar", amount = 25, supply = "large"},
        {name = "Dog Treats x5", itemIcon = "🍪", itemName = "lb_dogtreat", itemDisplayName = "Dog Treats", amount = 5, supply = "small"},
        {name = "Dog Treats x25", itemIcon = "🍪", itemName = "lb_dogtreat", itemDisplayName = "Dog Treats", amount = 25, supply = "large"},
    },
    supplies = {
        small = {
            requiredItem = "smallboxoflbsupplies",
            requiredItemName = "Small Box of L And B Candies Supplies",
        },
        large = {
            requiredItem = "largeboxoflbsupplies",
            requiredItemName = "Large Box of L And B Candies Supplies",
        }
    },
    perms = {"LBSUPPLIES"}
}
-- CRAFT

suppliesSpot.eastLosSantosFoundry = {
    name = "East Los Santos Foundry",
    pos = {
        vector3(1109.28, -2007.80, 31.03)
    },
    recipes = {
        {
            name = "Steel Bar x2", itemIcon = "🔥", itemName = "steelbar", itemDisplayName = "Steel Bar", amount = 2, craftTime = 2500,
            ingredients = {
                {itemName = "ironore", itemDisplayName = "Iron Ore", requiredAmount = 2},
                {itemName = "coal", itemDisplayName = "Coal", requiredAmount = 4},
            },
        },
    },
    perms = {"CANUSESMELTER"},
    craft = true,
}

suppliesSpot.paletoForestSawmill = {
    name = "Paleto Forest Sawmill",
    pos = {
        vector3(-552.73, 5348.51, 74.74)
    },
    recipes = {
        {
            name = "Wooden Planks", itemIcon = "🌲", itemName = "woodenplanks", itemDisplayName = "Wooden Planks", amount = 1, craftTime = 5000,
            ingredients = {
                {itemName = "logs", itemDisplayName = "Logs", requiredAmount = 1},
            },
        },
    },
    craft = true,
}

-- SHOP STORAGES

storageSpot[#storageSpot+1] = {
    name = "Burger Shot",
    pos = vector3(-1202.55, -894.99, 13.98),
    perms = {"BSSTORAGE"},
    range = 1.25
}

storageSpot[#storageSpot+1] = {
    name = "FP Logistics",
    pos = vector3(844.7, -902.86, 25.25),
    perms = {"FPSTORAGE"},
    range = 1.25
}

storageSpot[#storageSpot+1] = {
    name = "Hestia Foundation",
    pos = vector3(747.3, -1214.91, 24.75),
    perms = {"HFSTORAGE"},
    range = 1.25
}

storageSpot[#storageSpot+1] = {
    name = "Smoke On The Water",
    pos = vector3(-1167.17, -1573.02, 3.94),
    perms = {"SOTWSTORAGE"},
    range = 1.25
}

storageSpot[#storageSpot+1] = {
    name = "Smoke On The Water",
    pos = vector3(-224.2418, -314.6637, 29.88647),
    perms = {"SOTWSTORAGE"},
    range = 1.25
}

storageSpot[#storageSpot+1] = {
    name = "Vanilla Unicorn",
    pos = vector3(133.78, -1289.60, 29.26),
    perms = {"VUSTORAGE"},
    range = 1.25
}

storageSpot[#storageSpot+1] = {
    name = "Bean Machine",
    pos = vector3(-631.85, 227.74, 81.87),
    perms = {"BMSTORAGE"},
    range = 2.5
}

storageSpot[#storageSpot+1] = {
    name = "Last Train",
    pos = vector3(-384.46, 263.70, 86.42),
    perms = {"LTSTORAGE"},
    range = 2.5
}

storageSpot[#storageSpot+1] = {
    name = "Lawson Lunchbox",
    pos = vector3(2697.36, 4324.66, 45.84),
    perms = {"LLSTORAGE"},
    range = 2.5
}

storageSpot[#storageSpot+1] = {
    name = "Diamond Casino",
    pos = vector3(1111.86, 208.13, -48.75),
    perms = {"DCSTORAGE"},
    range = 4.0
}

storageSpot[#storageSpot+1] = {
    name = "Diamond Casino Top Bar",
    pos = vector3(949.08, 16.82, 116.16),
    perms = {"DCSTORAGE"},
    range = 4.0
}

storageSpot[#storageSpot+1] = {
    name = "O'Ryan Autocare",
    pos = vector3(951.63, -964.11, 39.49),
    perms = {"OASTORAGE"},
    range = 1.5
}

storageSpot[#storageSpot+1] = {
    name = "Williams Custom Motorworks Garage",
    pos = vector3(-206.99, -1341.15, 34.89),
    perms = {"WCSTORAGE"},
    range = 1.5
}

storageSpot[#storageSpot+1] = {
    name = "Brat's Keys",
    pos = vector3(161.41, 6652.91, 31.66),
    perms = {"BKSTORAGE"},
    range = 1.5
}

storageSpot[#storageSpot+1] = {
    name = "Galaxy Nightclub",
    pos = vector3(-1577.09, -3018.29, -79.01),
    perms = {"GNSTORAGE"},
    range = 1.5
}

storageSpot[#storageSpot+1] = {
    name = "Galaxy Nightclub",
    pos = vector3(-1583.06, -3013.60, -76.02),
    perms = {"GNSTORAGE"},
    range = 1.5
}

storageSpot[#storageSpot+1] = {
    name = "Galaxy Nightclub",
    pos = vector3(-1610.68, -3018.78, -75.21),
    perms = {"GNSTORAGE"},
    range = 1.5
}

storageSpot[#storageSpot+1] = {
    name = "SM Industries",
    pos = vector3(473.68, -1951.94, 24.60),
    perms = {"GNSTORAGE"},
    range = 1.5
}

storageSpot[#storageSpot+1] = {
    name = "Solomon Distilleries",
    pos = vector3(961.85, -2503.04, 28.44),
    perms = {"SDSTORAGE"},
    range = 1.5
}

storageSpot[#storageSpot+1] = {
    name = "Celtic Shield Security",
    pos = vector3(871.70, -1016.21, 31.64),
    perms = {"CSSTORAGE"},
    range = 1.5
}

storageSpot[#storageSpot+1] = {
    name = "Four Leaf Vineyard",
    pos = vector3(-1928.90, 2059.98, 140.83),
    perms = {"FLSTORAGE"},
    range = 1.5
}

storageSpot[#storageSpot+1] = {
    name = "The Yellow Jack",
    pos = vector3(1994.69, 3043.42, 47.21),
    perms = {"YJSTORAGE"},
    range = 1.25
}

storageSpot[#storageSpot+1] = {
    name = "Luchetti's",
    pos = vector3(294.25, -984.17, 29.41),
    perms = {"LUSTORAGE"},
    range = 4.0
}

storageSpot[#storageSpot+1] = {
    name = "Luchetti's Wine Cabinet",
    pos = vector3(294.50, -975.84, 29.43),
    perms = {"LUSTORAGE"},
    range = 1.5
}

storageSpot[#storageSpot+1] = {
    name = "Mr. Blacks Ammunation",
    pos = vector3(13.93, -1106.10, 29.79),
    perms = {"MASTORAGE"},
    range = 4.0
}

storageSpot[#storageSpot+1] = {
    name = "Stewart's Outdoor Adventures",
    pos = vector3(-712.40, -1298.74, 5.10),
    perms = {"SOSTORAGE"},
    range = 4.0
}

storageSpot[#storageSpot+1] = {
    name = "Stryker Air",
    pos = vector3(-704.20, -1398.54, 5.49),
    perms = {"SASTORAGE"},
    range = 4.0
}

storageSpot[#storageSpot+1] = {
    name = "San Andreas Vehicle Rentals",
    pos = vector3(-150.15, -165.49, 43.62),
    perms = {"SRSTORAGE"},
    range = 4.0
}

storageSpot[#storageSpot+1] = {
    name = "Sato's Noodle Exchange",
    pos = vector3(-1240.93, -268.44, 37.75),
    perms = {"SNSTORAGE"},
    range = 2.5
}

storageSpot[#storageSpot+1] = {
    name = "Lucky Leprechaun Ale House",
    pos = vector3(1220.11, -419.50, 67.76),
    perms = {"LHSTORAGE"},
    range = 2.0
}

storageSpot[#storageSpot+1] = {
    name = "Skinny Dick's Towing",
    pos = vector3(948.63, -1010.33, 42.00),
    perms = {"STSTORAGE"},
    range = 2.0
}

storageSpot[#storageSpot+1] = {
    name = "Rabbit Hole",
    pos = vector3(1121.01, -3152.47, -37.07),
    perms = {"RHSTORAGE"},
    range = 2.0
}

storageSpot[#storageSpot+1] = {
    name = "TLMC Customs & Tow",
    pos = vector3(985.11, -92.10, 74.84),
    perms = {"LMSTORAGE"},
    range = 4.0
}

storageSpot[#storageSpot+1] = {
    name = "Bento",
    pos = vector3(-174.65, 312.40, 97.98),
    perms = {"BTSTORAGE"},
    range = 5.0
}

storageSpot[#storageSpot+1] = {
    name = "Streamline Sales And Repairs",
    pos = vector3(-27.88, -1103.97, 26.42),
    perms = {"SLSTORAGE"},
    range = 2.0
}

storageSpot[#storageSpot+1] = {
    name = "Govenor's Desk",
    pos = vector3(-546.00, -202.32, 47.07),
    perms = {"GOSTORAGE"},
    range = 2.0
}

storageSpot[#storageSpot+1] = {
    name = "Govenor's Offices",
    pos = vector3(-541.54, -192.88, 47.41),
    perms = {"GOSTORAGE2"},
    range = 2.0
}

storageSpot[#storageSpot+1] = {
    name = "Weazel News",
    pos = vector3(-582.70, -937.48, 23.85),
    perms = {"WNSTORAGE"},
    range = 2.0
}

storageSpot[#storageSpot+1] = {
    name = "Best Buds",
    pos = vector3(381.69, -819.71, 29.70),
    perms = {"BBSTORAGE"},
    range = 2.0
}

storageSpot[#storageSpot+1] = {
    name = "Cool Beans",
    pos = vector3(-1197.53, -1142.10, 7.83),
    perms = {"CBSTORAGE"},
    range = 2.0
}

storageSpot[#storageSpot+1] = {
    name = "Reflections Autocare",
    pos = vector3(1156.47, -780.45, 57.60),
    perms = {"RASTORAGE"},
    range = 2.0
}

storageSpot[#storageSpot+1] = {
    name = "Reflections Autocare Workshop",
    pos = vector3(1154.36, -792.38, 57.60),
    perms = {"RASTORAGE"},
    range = 2.0
}

storageSpot[#storageSpot+1] = {
    name = "Reflections Autocare Workshop",
    pos = vector3(1147.94, -785.53, 57.59),
    perms = {"RASTORAGE"},
    range = 2.0
}

storageSpot[#storageSpot+1] = {
    name = "Hen House",
    pos = vector3(-300.40, 6272.62, 31.47),
    perms = {"HHSTORAGE"},
    range = 2.0
}

storageSpot[#storageSpot+1] = {
    name = "Hen House",
    pos = vector3(-296.08, 6262.98, 31.47),
    perms = {"HHSTORAGE"},
    range = 2.5
}

storageSpot[#storageSpot+1] = {
    name = "Bahama Mamas 1",
    pos = vector3(-1385.18, -606.36, 30.32),
    perms = {"BAHAMASTORAGE"},
    range = 1.5
}

storageSpot[#storageSpot+1] = {
    name = "Bahama Mamas 2",
    pos = vector3(-1371.25, -625.82, 30.82),
    perms = {"BAHAMASTORAGE"},
    range = 1.5
}

storageSpot[#storageSpot+1] = {
    name = "Sex On The Beach",
    pos = vector3(-169.36, 233.14, 88.04),
    perms = {"SBSTORAGE"},
    range = 2.0
}

storageSpot[#storageSpot+1] = {
    name = "Dexter's Custom Cars",
    pos = vector3(1230.67, 2739.01, 37.99),
    perms = {"DCSTORAGE"},
    range = 2.25
}

storageSpot[#storageSpot+1] = {
    name = "The Jewel Of Hatton",
    pos = vector3(-631.19, -229.48, 38.04),
    perms = {"JHSTORAGE"},
    range = 2.0
}

storageSpot[#storageSpot+1] = {
    name = "Los Santos Logistics",
    pos = vector3(96.76, -2216.23, 6.16),
    perms = {"LSSTORAGE"},
    range = 2.0
}

storageSpot[#storageSpot+1] = {
    name = "Scrilla's Moving Service",
    pos = vector3(706.39, -960.55, 30.39),
    perms = {"SSSTORAGE"},
    range = 2.0
}

storageSpot[#storageSpot+1] = {
    name = "London Customs",
    pos = vector3(-15.55, -1055.38, 32.40),
    perms = {"LCSTORAGE"},
    range = 1.5
}

storageSpot[#storageSpot+1] = {
    name = "London Customs Workshop",
    pos = vector3(-36.04, -1070.10, 28.39),
    perms = {"LCSTORAGE"},
    range = 2.0
}

storageSpot[#storageSpot+1] = {
    name = "London Customs Workshop",
    pos = vector3(-34.52, -1038.11, 28.59),
    perms = {"LCSTORAGE"},
    range = 2.5
}

storageSpot[#storageSpot+1] = {
    name = "Prestige Auto",
    pos = vector3(-345.22, -122.99, 39.01),
    perms = {"PASTORAGE"},
    range = 2.0
}

storageSpot[#storageSpot+1] = {
    name = "Haven Resort And Spa",
    pos = vector3(-2989.44, 51.86, 12.26),
    perms = {"HSSTORAGE"},
    range = 1.75
}

storageSpot[#storageSpot+1] = {
    name = "Haven Resort And Spa",
    pos = vector3(-3033.7, 88.97, 12.35),
    perms = {"HSSTORAGE"},
    range = 1.75
}

storageSpot[#storageSpot+1] = {
    name = "Haven Resort And Spa",
    pos = vector3(-3040.35, 82.36, 12.82),
    perms = {"HSSTORAGE"},
    range = 1.5
}

storageSpot[#storageSpot+1] = {
    name = "Arcade O'Rama",
    pos = vector3(736.60, -825.75, 22.66),
    perms = {"AOSTORAGE"},
    range = 1.5
}

storageSpot[#storageSpot+1] = {
    name = "Arcade O'Rama Safe",
    pos = vector3(741.53, -811.17, 24.26),
    perms = {"AOSTORAGE"},
    range = 1.5
}

-- SHOP COUNTERS

counterSpot[#counterSpot+1] = {
    name = "Burger Shot 1",
    pos = vector3(-1196.28, -891.34, 15.09),
    range = 1.60
}

counterSpot[#counterSpot+1] = {
    name = "Burger Shot 2",
    pos = vector3(-1194.75, -893.60, 15.01),
    range = 1.60
}

counterSpot[#counterSpot+1] = {
    name = "Burger Shot 3",
    pos = vector3(-1193.70, -895.48, 15.01),
    range = 1.60
}

counterSpot[#counterSpot+1] = {
    name = "Burger Shot Order Up",
    pos = vector3(-1197.14, -894.50, 13.98),
    range = 1.60
}

counterSpot[#counterSpot+1] = {
    name = "Burger Shot Drive Thru",
    pos = vector3(-1194.02, -907.65, 13.76),
    range = 1.60
}

counterSpot[#counterSpot+1] = {
    name = "Bean Machine",
    pos = vector3(-635.04, 235.00, 81.87),
    range = 1.8
}

counterSpot[#counterSpot+1] = {
    name = "Last Train",
    pos = vector3(-382.22, 265.25, 86.42),
    range = 1.4
}

counterSpot[#counterSpot+1] = {
    name = "Vanilla Unicorn",
    pos = vector3(129.15, -1284.95, 29.29),
    range = 1.60
}

counterSpot[#counterSpot+1] = {
    name = "Bahama Mama Bar 1 - Counter",
    pos = vector3(-1392.1, -606.65, 30.46),
    range = 1.60
}

counterSpot[#counterSpot+1] = {
    name = "Bahama Mama Bar 1 - Counter",
    pos = vector3(-1393.35, -603.19, 30.66),
    range = 1.60
}

counterSpot[#counterSpot+1] = {
    name = "Bahama Mama Bar 2 - Counter",
    pos = vector3(-1376.44, -627.8, 30.74),
    range = 1.60
}

counterSpot[#counterSpot+1] = {
    name = "Diamond Casino 1",
    pos = vector3(1114.30, 206.60, -48.20),
    range = 1.8
}

counterSpot[#counterSpot+1] = {
    name = "Diamond Casino 2",
    pos = vector3(1111.73, 210.83, -48.11),
    range = 1.8
}

counterSpot[#counterSpot+1] = {
    name = "Diamond Casino 3",
    pos = vector3(1109.62, 206.45, -48.23),
    range = 1.8
}

counterSpot[#counterSpot+1] = {
    name = "Diamond Casino BlackJack 1",
    pos = vector3(1148.8, 269.79, -51.76),
    range = 1.7
}

counterSpot[#counterSpot+1] = {
    name = "Diamond Casino BlackJack 2",
    pos = vector3(1151.64, 266.86, -51.74),
    range = 1.7
}

counterSpot[#counterSpot+1] = {
    name = "Diamond Casino Top Bar 1",
    pos = vector3(944.93, 14.14, 116.27),
    range = 1.5
}

counterSpot[#counterSpot+1] = {
    name = "Diamond Casino Top Bar 2",
    pos = vector3(946.72, 16.84, 116.31),
    range = 1.5
}

counterSpot[#counterSpot+1] = {
    name = "Brat's Keys",
    pos = vector3(158.31, 6653.78, 32.63),
    range = 1.8
}

counterSpot[#counterSpot+1] = {
    name = "Galaxy Nightclub 1",
    pos = vector3(-1577.88, -3015.55, -79.01),
    range = 1.60
}

counterSpot[#counterSpot+1] = {
    name = "Galaxy Nightclub 2",
    pos = vector3(-1585.50, -3012.61, -76.02),
    range = 1.60
}

counterSpot[#counterSpot+1] = {
    name = "The Yellow Jack",
    pos = vector3(1985.08, 3054.03, 47.21),
    range = 1.60
}

counterSpot[#counterSpot+1] = {
    name = "Luchetti's",
    pos = vector3(288.76, -977.17, 29.60),
    range = 1.60
}

counterSpot[#counterSpot+1] = {
    name = "Luchetti's Order Up",
    pos = vector3(282.79, -984.53, 29.43),
    range = 1.50
}

counterSpot[#counterSpot+1] = {
    name = "Mr. Blacks Ammunation",
    pos = vector3(21.48, -1105.60, 29.8),
    range = 1.60
}

counterSpot[#counterSpot+1] = {
    name = "Sato's Noodle Exchange 1",
    pos = vector3(-1235.65, -270.44, 37.63),
    range = 1.60
}

counterSpot[#counterSpot+1] = {
    name = "Sato's Noodle Exchange 2",
    pos = vector3(-1237.28, -271.34, 37.63),
    range = 1.60
}

counterSpot[#counterSpot+1] = {
    name = "Sato's Noodle Exchange 3",
    pos = vector3(-1238.90, -272.23, 37.63),
    range = 1.60
}

counterSpot[#counterSpot+1] = {
    name = "Lucky Leprechaun Ale House 1",
    pos = vector3(1222.66, -419.08, 67.73),
    range = 1.6
}

counterSpot[#counterSpot+1] = {
    name = "Lucky Leprechaun Ale House 2",
    pos = vector3(1224.11, -420.16, 67.78),
    range = 1.9
}

counterSpot[#counterSpot+1] = {
    name = "Lucky Leprechaun Ale House Table 1",
    pos = vector3(1221.41, -413.59, 67.66),
    range = 1.3
}

counterSpot[#counterSpot+1] = {
    name = "Lucky Leprechaun Ale House Table 2",
    pos = vector3(1224.39, -414.37, 67.62),
    range = 1.3
}

counterSpot[#counterSpot+1] = {
    name = "Lucky Leprechaun Ale House Table 3",
    pos = vector3(1227.31, -415.22, 67.51),
    range = 1.3
}

counterSpot[#counterSpot+1] = {
    name = "Lucky Leprechaun Ale House O'Ryans Booth",
    pos = vector3(1230.4, -415.8, 67.55),
    range = 1.3
}


counterSpot[#counterSpot+1] = {
    name = "Rabbit Hole",
    pos = vector3(1121.99, -3143.58, -37.04),
    range = 1.6
}

counterSpot[#counterSpot+1] = {
    name = "Bento Order Up",
    pos = vector3(-172.83, 305.62, 97.45),
    range = 1.50
}

counterSpot[#counterSpot+1] = {
    name = "Bento",
    pos = vector3(-171.34, 295.02, 93.80),
    range = 1.6
}

counterSpot[#counterSpot+1] = {
    name = "Paleto Sheriff's Office",
    pos = vector3(-447.68, 6012.96, 31.62),
    range = 1.5
}

counterSpot[#counterSpot+1] = {
    name = "Sandy Shores Sheriff's Office",
    pos = vector3(1852.30, 3687.30, 34.35),
    range = 1.5
}

counterSpot[#counterSpot+1] = {
    name = "Sandy Shores Sheriff's Office Pantry",
    pos = vector3(1855.04, 3694.30, 38.08),
    range = 1.75
}

counterSpot[#counterSpot+1] = {
    name = "Pillbox Hospital Pantry",
    pos = vector3(303.86, -600.45, 43.28),
    range = 1.75
}

counterSpot[#counterSpot+1] = {
    name = "Paleto Medical Center Pantry",
    pos = vector3(-264.11, 6323.86, 32.41),
    range = 1.75
}

counterSpot[#counterSpot+1] = {
    name = "Sandy Shores Medical Center Pantry",
    pos = vector3(1844.28, 3681.26, 34.27),
    range = 1.75
}

counterSpot[#counterSpot+1] = {
    name = "Best Buds",
    pos = vector3(377.26, -827.42, 29.38),
    range = 1.75
}

counterSpot[#counterSpot+1] = {
    name = "Cool Beans",
    pos = vector3(-1200.98, -1137.09, 7.83),
    range = 1.75
}

counterSpot[#counterSpot+1] = {
    name = "Hen House 1",
    pos = vector3(-296.63, 6264.23, 31.60),
    range = 1.75
}

counterSpot[#counterSpot+1] = {
    name = "Hen House 2",
    pos = vector3(-297.68, 6261.38, 31.78),
    range = 1.75
}

counterSpot[#counterSpot+1] = {
    name = "Sex On The Beach",
    pos = vector3(-173.66, 230.11, 88.05),
    range = 1.75
}

counterSpot[#counterSpot+1] = {
    name = "Dexter's Custom Cars",
    pos = vector3(1230.96, 2732.04, 38.11),
    range = 1.75
}

counterSpot[#counterSpot+1] = {
    name = "The Jewel Of Hatton",
    pos = vector3(-623.26, -231.57, 38.04),
    range = 1.75
}

counterSpot[#counterSpot+1] = {
    name = "Smoke On The Water - Beachside",
    pos = vector3(-1170.54, -1572.47, 4.66),
    range = 1.50
}

counterSpot[#counterSpot+1] = {
    name = "Smoke On The Water 1",
    pos = vector3(-229.65, -314.4, 29.89),
    range = 1.75
}

counterSpot[#counterSpot+1] = {
    name = "Smoke On The Water 2",
    pos = vector3(-226.18, -314.67, 29.94),
    range = 1.75
}

counterSpot[#counterSpot+1] = {
    name = "Haven Resort And Spa 1",
    pos = vector3(-3038.40, 83.08, 12.94),
    range = 1.75
}

counterSpot[#counterSpot+1] = {
    name = "Haven Resort And Spa 2",
    pos = vector3(-3039.84, 84.31, 12.94),
    range = 1.75
}

counterSpot[#counterSpot+1] = {
    name = "Haven Resort And Spa Outside Bar 1",
    pos = vector3(-3023.09, 41.33, 10.1),
    range = 1.75
}

counterSpot[#counterSpot+1] = {
    name = "Haven Resort And Spa Outside Bar 2",
    pos = vector3(-3021.68, 38.01, 10.01),
    range = 1.75
}

counterSpot[#counterSpot+1] = {
    name = "Arcade O'rama Bar 1",
    pos = vector3(740.14, -824.23, 22.66),
    range = 1.75
}

counterSpot[#counterSpot+1] = {
    name = "Arcade O'rama Bar 2",
    pos = vector3(738.63, -821.96, 22.66),
    range = 1.75
}
