local hotwire = {}

-- TABLE TO DECIDE WHAT EACH VEHICLE CLASS WOULD NEED
local classes = {
    [0] = { -- COMPACTS
        difficulty = 2,
        chanceOfKeys = 5,
        itemsNeeded = {
            {name = "screwdriver", label = "Screwdriver"},
            {name = "electricaltape", label = "Electrical Tape"},
            {name = "wirestripper", label = "Wire Stripper"},
            {name = "pliers", label = "Pliers"}
        }
    },

    [1] = { -- SEDANS
        difficulty = 2,
        chanceOfKeys = 5,
        itemsNeeded = {
            {name = "screwdriver", label = "Screwdriver"},
            {name = "electricaltape", label = "Electrical Tape"},
            {name = "wirestripper", label = "Wire Stripper"},
            {name = "pliers", label = "Pliers"}
        }
    },

    [2] = { -- SUVs
        difficulty = 2,
        chanceOfKeys = 5,
        itemsNeeded = {
            {name = "screwdriver", label = "Screwdriver"},
            {name = "electricaltape", label = "Electrical Tape"},
            {name = "wirestripper", label = "Wire Stripper"},
            {name = "pliers", label = "Pliers"}
        }
    },

    [3] = { -- COUPES
        difficulty = 3,
        chanceOfKeys = 5,
        itemsNeeded = {
            {name = "screwdriver", label = "Screwdriver"},
            {name = "electricaltape", label = "Electrical Tape"},
            {name = "wirestripper", label = "Wire Stripper"},
            {name = "pliers", label = "Pliers"}
        }
    },

    [4] = { -- MUSCLE
        difficulty = 3,
        chanceOfKeys = 5,
        itemsNeeded = {
            {name = "screwdriver", label = "Screwdriver"},
            {name = "electricaltape", label = "Electrical Tape"},
            {name = "wirestripper", label = "Wire Stripper"},
            {name = "pliers", label = "Pliers"}
        }
    },

    [5] = { -- SPORTS CLASSICS
        difficulty = 3,
        chanceOfKeys = 5,
        itemsNeeded = {
            {name = "screwdriver", label = "Screwdriver"},
            {name = "electricaltape", label = "Electrical Tape"},
            {name = "wirestripper", label = "Wire Stripper"},
            {name = "pliers", label = "Pliers"}
        }
    },

    [6] = { -- SPORTS
        difficulty = 2,
        chanceOfKeys = 5,
        itemsNeeded = {
            {name = "screwdriver", label = "Screwdriver"},
            {name = "electricaltape", label = "Electrical Tape"},
            {name = "wirestripper", label = "Wire Stripper"},
            {name = "pliers", label = "Pliers"}
        }
    },

    [7] = { -- SUPER
        difficulty = 1,
        chanceOfKeys = 5,
        itemsNeeded = {
            {name = "laptop", label = "Laptop"},
            {name = "usb", label = "USB Stick"}
        }
    },

    [8] = { -- MOTORCYCLES
        difficulty = 3,
        chanceOfKeys = 5,
        itemsNeeded = {
            {name = "screwdriver", label = "Screwdriver"},
            {name = "electricaltape", label = "Electrical Tape"},
            {name = "wirestripper", label = "Wire Stripper"},
            {name = "pliers", label = "Pliers"}
        }
    },

    [9] = { -- OFF-ROAD
        difficulty = 3,
        chanceOfKeys = 0,
        itemsNeeded = {
            {name = "screwdriver", label = "Screwdriver"},
            {name = "electricaltape", label = "Electrical Tape"},
            {name = "wirestripper", label = "Wire Stripper"},
            {name = "pliers", label = "Pliers"}
        }
    },

    [10] = { -- INDUSTRIAL
        difficulty = 3,
        chanceOfKeys = 0,
        itemsNeeded = {
            {name = "screwdriver", label = "Screwdriver"},
            {name = "electricaltape", label = "Electrical Tape"},
            {name = "wirestripper", label = "Wire Stripper"},
            {name = "pliers", label = "Pliers"}
        }
    },

    [11] = { -- UTILITY
        difficulty = 3,
        chanceOfKeys = 0,
        itemsNeeded = {
            {name = "screwdriver", label = "Screwdriver"},
            {name = "electricaltape", label = "Electrical Tape"},
            {name = "wirestripper", label = "Wire Stripper"},
            {name = "pliers", label = "Pliers"}
        }
    },

    [12] = { -- VANS
        difficulty = 3,
        chanceOfKeys = 0,
        itemsNeeded = {
            {name = "screwdriver", label = "Screwdriver"},
            {name = "electricaltape", label = "Electrical Tape"},
            {name = "wirestripper", label = "Wire Stripper"},
            {name = "pliers", label = "Pliers"}
        }
    },

    [13] = { -- CYCLES
        difficulty = 3,
        chanceOfKeys = 0,
        itemsNeeded = {
            {name = "screwdriver", label = "Screwdriver"},
            {name = "electricaltape", label = "Electrical Tape"},
            {name = "wirestripper", label = "Wire Stripper"},
            {name = "pliers", label = "Pliers"}
        }
    },

    [14] = { -- BOATS
        difficulty = 2,
        chanceOfKeys = 0,
        itemsNeeded = {
            {name = "screwdriver", label = "Screwdriver"},
            {name = "electricaltape", label = "Electrical Tape"},
            {name = "wirestripper", label = "Wire Stripper"},
            {name = "pliers", label = "Pliers"}
        }
    },

    [15] = { -- HELICOPTERS
        difficulty = 1,
        chanceOfKeys = 0,
        itemsNeeded = {
            {name = "screwdriver", label = "Screwdriver"},
            {name = "electricaltape", label = "Electrical Tape"},
            {name = "wirestripper", label = "Wire Stripper"},
            {name = "pliers", label = "Pliers"}
        }
    },

    [16] = { -- PLANES
        difficulty = 1,
        chanceOfKeys = 0,
        itemsNeeded = {
            {name = "screwdriver", label = "Screwdriver"},
            {name = "electricaltape", label = "Electrical Tape"},
            {name = "wirestripper", label = "Wire Stripper"},
            {name = "pliers", label = "Pliers"}
        }
    },

    [17] = { -- SERVICE
        difficulty = 2,
        chanceOfKeys = 0,
        itemsNeeded = {
            {name = "screwdriver", label = "Screwdriver"},
            {name = "electricaltape", label = "Electrical Tape"},
            {name = "wirestripper", label = "Wire Stripper"},
            {name = "pliers", label = "Pliers"}
        }
    },

    [18] = { -- EMERGENCY
        difficulty = 1,
        chanceOfKeys = 0,
        itemsNeeded = {
            {name = "screwdriver", label = "Screwdriver"},
            {name = "electricaltape", label = "Electrical Tape"},
            {name = "wirestripper", label = "Wire Stripper"},
            {name = "pliers", label = "Pliers"}
        }
    },

    [19] = { -- MILITARY
        difficulty = 1,
        chanceOfKeys = 0,
        itemsNeeded = {
            {name = "screwdriver", label = "Screwdriver"},
            {name = "electricaltape", label = "Electrical Tape"},
            {name = "wirestripper", label = "Wire Stripper"},
            {name = "pliers", label = "Pliers"}
        }
    },

    [20] = { -- COMMERCIAL
        difficulty = 2,
        chanceOfKeys = 0,
        itemsNeeded = {
            {name = "screwdriver", label = "Screwdriver"},
            {name = "electricaltape", label = "Electrical Tape"},
            {name = "wirestripper", label = "Wire Stripper"},
            {name = "pliers", label = "Pliers"}
        }
    },

    [21] = { -- TRAINS
        difficulty = 1,
        chanceOfKeys = 0,
        itemsNeeded = {
            {name = "screwdriver", label = "Screwdriver"},
            {name = "electricaltape", label = "Electrical Tape"},
            {name = "wirestripper", label = "Wire Stripper"},
            {name = "pliers", label = "Pliers"}
        }
    }
}

-- **********************
--       Commands
-- **********************
RegisterCommand("hotwire", function(source)
    local src = source
    TriggerClientEvent("UX:Client:Hotwire", src)
end)

-- **********************
--        Events
-- **********************
-- CALLED FROM CLIENT TO REMOVE THE TOOL USED TO HOTWIRE
RegisterNetEvent("UX:Server:Hotwire")
AddEventHandler("UX:Server:Hotwire", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 557 | Lua-Injecting Detected.", 0)
        return
    end

    -- TOOLS HAVE A 85% CHANCE OF NOT BREAKING
    if not data.item then return end

    math.randomseed(os.time())
    if (math.random(1, 100) <= 85) then return end
    exports["soe-inventory"]:RemoveItem(src, 1, data.item)
    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Your tool has been used!", length = 5000})
end)

-- CALLBACK TO CLIENT AND SEND HOTWIRING DATA
AddEventHandler("UX:Server:GetHotwireData", function(cb, src, class, plate)
    if hotwire[plate] then
        -- IF THERE IS ALREADY HOTWIRE DATA FOR THIS PLATE
        cb(hotwire[plate])
    else
        -- IF NO DATA EXISTS, MAKE A NEW ENTRY
        local data = {}
        math.randomseed(os.time())
        math.random() math.random() math.random()
        local requiredTool = math.random(1, #classes[class].itemsNeeded)
        data.difficulty = classes[class].difficulty
        data.chanceOfKeys = classes[class].chanceOfKeys
        data.requiredToolName = classes[class].itemsNeeded[requiredTool].name
        data.requiredToolLabel = classes[class].itemsNeeded[requiredTool].label

        hotwire[plate] = data
        cb(hotwire[plate])
    end
end)
