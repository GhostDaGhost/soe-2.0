-- LIST OF MODELS THAT A SLICE COULD APPEAR FOR
models = {
    ["Campfire"] = -1065766299, -- CAMPFIRE

    ["Meters"] = { -- PARKING METERS
        [-1940238623] = true,
        [2108567945] = true
    }
}

-- LIST OF MENU SLICES AND SUBMENUS
menus = {
    {
        id = "general",
        name = "General",
        icon = "#globe",
        showIf = function()
            return true
        end,
        subMenus = {"general:putincar", "general:pullout", "general:drag", "general:escort", "general:carry", "general:piggyback", "general:hold"}
    },
    {
        id = "clothing",
        name = "Clothing",
        icon = "#clothing",
        showIf = function()
            return true
        end,
        subMenus = {"clothing:shirt", "clothing:pants", "clothing:shoes", "clothing:mask", "clothing:hat", "clothing:ears", "clothing:vest"}
    },
    {
        id = "emotes",
        name = "Animations",
        icon = "#emote",
        type = "command",
        func = "emotemenu",
        closeOnClick = true,
        showIf = function()
            return true
        end
    },
    {
        id = "vehicle",
        name = "Vehicle",
        icon = "#vehicle",
        showIf = function()
            return IsPedSittingInAnyVehicle(PlayerPedId())
        end,
        subMenus = {"vehicle:seatbelt", "vehicle:engine", "vehicle:neutralgear", "vehicle:shuffleseats"}
    },
    {
        id = "police-tools",
        name = "Police Interaction",
        icon = "#shield",
        showIf = function()
            return (exports["soe-jobs"]:GetMyJob() == "POLICE")
        end,
        subMenus = {"police:identify"}
    },
    {
        id = "ems-tools",
        name = "EMS Interaction",
        icon = "#syringe",
        showIf = function()
            return (exports["soe-jobs"]:GetMyJob() == "EMS")
        end,
        subMenus = {"ems:triage", "ems:heal", "ems:revive", "ems:putinbed"}
    },
    {
        id = "robRegister",
        name = "Rob Register",
        icon = "#cash-register",
        type = "client",
        func = "Crime:Client:RobRegister",
        closeOnClick = true,
        showIf = function()
            for _, register in pairs(exports["soe-crime"]:GetCashRegisters()) do
                if #(GetEntityCoords(PlayerPedId()) - vector3(register.x, register.y, register.z)) <= 1.0 then
                    return true
                end
            end
            return false
        end
    },
    {
        id = "robSafe",
        name = "Rob Safe",
        icon = "#piggy-bank",
        type = "client",
        func = "Crime:Client:RobSafe",
        closeOnClick = true,
        showIf = function()
            for _, safe in pairs(exports["soe-crime"]:GetStoreSafes()) do
                if #(GetEntityCoords(PlayerPedId()) - safe.pos) <= 1.0 then
                    return true
                end
            end
            return false
        end
    },
    {
        id = "robJewelryShowcase",
        name = "Rob Jewelry Case",
        icon = "#gem",
        type = "client",
        func = "Crime:Client:RobJewelryShowcase",
        closeOnClick = true,
        showIf = function()
            return exports["soe-crime"]:IsNearJewelryShowcase()
        end
    },
    {
        id = "impoundVehicle",
        name = "Impound",
        icon = "#paste",
        type = "command",
        func = "impound",
        closeOnClick = true,
        showIf = function(_, entity)
            return (exports["soe-jobs"]:GetMyJob() == "POLICE") and IsEntityAVehicle(entity)
        end
    },
    {
        id = "robParkingMeter",
        name = "Rob Parking Meter",
        icon = "#parking",
        type = "client",
        func = "Crime:Client:RobMeter",
        closeOnClick = true,
        showIf = function(_, entity)
            return models["Meters"][GetEntityModel(entity)]
        end
    },
    {
        id = "hotwire",
        name = "Hotwire",
        icon = "#screwdriver",
        type = "command",
        func = "hotwire",
        closeOnClick = true,
        showIf = function()
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsIn(ped, false)
            if (GetPedInVehicleSeat(veh, -1) == ped) and not GetIsVehicleEngineRunning(veh) then
                return true
            end
            return false
        end
    },
    {
        id = "fuelVehicle",
        name = "Fuel Vehicle",
        icon = "#gas-pump",
        type = "client",
        func = "Fuel:Client:FuelVehicle",
        closeOnClick = true,
        showIf = function()
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            if not IsPedSittingInAnyVehicle(ped) then
                local obj = exports["soe-fuel"]:FindNearestFuelPump()
                local objPos = GetEntityCoords(obj)
                if (obj ~= 0) then
                    if #(pos - objPos) < 2.6 then
                        return true
                    end
                end
            end
            return false
        end
    },
    {
        id = "startTaxiDuty",
        name = "Start Taxi Duty",
        icon = "#taxi",
        type = "client",
        func = "Jobs:Client:RentTaxiAndStartJob",
        closeOnClick = true,
        showIf = function()
            local isOnDuty = exports["soe-jobs"]:IsOnDuty()
            local nearTaxiDepot = exports["soe-jobs"]:IsCloseToTaxiDepot()
            if nearTaxiDepot and not isOnDuty then
                return true
            end
            return false
        end
    },
    {
        id = "lookForTaxiCustomers",
        name = "Look For Customers",
        icon = "#taxi",
        type = "client",
        func = "Jobs:Client:LookForTaxiCustomers",
        closeOnClick = true,
        showIf = function()
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsIn(ped, false)
            local myJob = exports["soe-jobs"]:GetMyJob()
            local isOnDuty = exports["soe-jobs"]:IsOnDuty()
            local isDriver = (GetPedInVehicleSeat(veh, -1) == ped)
            if isDriver and isOnDuty and (myJob == "TAXI") then
                return true
            end
            return false
        end
    },
    {
        id = "reportTaxiLost",
        name = "Report Taxi Lost",
        icon = "#taxi",
        type = "client",
        func = "Jobs:Client:ReportTaxiLost",
        closeOnClick = true,
        showIf = function()
            local myJob = exports["soe-jobs"]:GetMyJob()
            local isOnDuty = exports["soe-jobs"]:IsOnDuty()
            local nearTaxiDepot = exports["soe-jobs"]:IsCloseToTaxiDepot()
            if nearTaxiDepot and isOnDuty and (myJob == "TAXI") then
                return true
            end
            return false
        end
    },
    {
        id = "clockOffTaxi",
        name = "Go Off Duty",
        icon = "#taxi",
        type = "client",
        func = "Jobs:Client:RentTaxiAndStartJob",
        closeOnClick = true,
        showIf = function()
            local myJob = exports["soe-jobs"]:GetMyJob()
            local isOnDuty = exports["soe-jobs"]:IsOnDuty()
            local nearTaxiDepot = exports["soe-jobs"]:IsCloseToTaxiDepot()
            if nearTaxiDepot and isOnDuty and (myJob == "TAXI") then
                return true
            end
            return false
        end
    },
    {
        id = "browseStore",
        name = "Browse Store",
        icon = "#shopping-basket",
        type = "client",
        func = "Shops:Client:BrowseStore",
        closeOnClick = true,
        showIf = function()
            local ped = PlayerPedId()
            local inVeh = IsPedSittingInAnyVehicle(ped)
            local isNearStore = exports["soe-shops"]:IsNearStore(ped)
            if isNearStore and not inVeh then
                return true
            end
            return false
        end
    },
    {
        id = "useCarWash",
        name = "Wash Car",
        icon = "#shower",
        type = "client",
        func = "Shops:Client:UseCarWash",
        closeOnClick = true,
        showIf = function()
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsIn(ped, false)
            local isDriver = (GetPedInVehicleSeat(veh, -1) == ped)
            local isNearWash = exports["soe-shops"]:IsNearCarWash()
            if isDriver and isNearWash then
                return true
            end
            return false
        end
    },
    {
        id = "rentBike",
        name = "Rent Bicycle",
        icon = "#bicycle",
        type = "client",
        func = "Shops:Client:RentBike",
        closeOnClick = true,
        showIf = function()
            local ped = PlayerPedId()
            local isNearRental = exports["soe-shops"]:IsNearBikeRental()
            if isNearRental and not IsPedSittingInAnyVehicle(ped) then
                return true
            end
            return false
        end
    },
    {
        id = "returnRentedBike",
        name = "Return Bicycle",
        icon = "#bicycle",
        type = "client",
        func = "Shops:Client:ReturnRentedBike",
        closeOnClick = true,
        showIf = function()
            local ped = PlayerPedId()
            local isNearRental = exports["soe-shops"]:IsNearBikeRental()
            if isNearRental and IsPedSittingInAnyVehicle(ped) then
                return true
            end
            return false
        end
    },
    {
        id = "browseDealership",
        name = "Browse Dealership",
        icon = "#vehicle",
        type = "client",
        func = "Shops:Client:BrowseDealership",
        closeOnClick = true,
        showIf = function()
            local ped = PlayerPedId()
            local inVeh = IsPedSittingInAnyVehicle(ped)
            local isNearDealership = exports["soe-shops"]:IsNearDealership(ped)
            if isNearDealership and not inVeh then
                return true
            end
            return false
        end
    },
    {
        id = "startGoPostal",
        name = "Start Go Postal Job",
        icon = "#globe",
        type = "client",
        func = "Jobs:Client:StartOrStopGoPostalJob",
        closeOnClick = true,
        showIf = function()
            local isOnDuty = exports["soe-jobs"]:IsOnDuty()
            local nearGoPostalDepot = exports["soe-jobs"]:IsCloseToGoPostalDepot()

            if nearGoPostalDepot and not isOnDuty then
                return true
            end
            return false
        end
    },
    {
        id = "stopGoPostal",
        name = "Stop Go Postal Job",
        icon = "#globe",
        type = "client",
        func = "Jobs:Client:StartOrStopGoPostalJob",
        closeOnClick = true,
        showIf = function()
            local isOnDuty = exports["soe-jobs"]:IsOnDuty()
            local nearGoPostalDepot = exports["soe-jobs"]:IsCloseToGoPostalDepot()

            if nearGoPostalDepot and isOnDuty then
                return true
            end
            return false
        end
    },
    {
        id = "getGoPostalPackage",
        name = "Get Package",
        icon = "#globe",
        type = "client",
        func = "Jobs:Client:GetReturnGoPostalPackage",
        closeOnClick = true,
        showIf = function()
            local isOnDuty = exports["soe-jobs"]:IsOnDuty()
            local nearGoPostalTruck = exports["soe-jobs"]:IsCloseToGoPostalTruck()
            local hasPackage = exports["soe-jobs"]:GetHasGoPostalPackage()

            if nearGoPostalTruck and isOnDuty and not hasPackage then
                return true
            end
            return false
        end
    },
    {
        id = "returnGoPostalPackage",
        name = "Return Package",
        icon = "#globe",
        type = "client",
        func = "Jobs:Client:GetReturnGoPostalPackage",
        closeOnClick = true,
        showIf = function()
            local isOnDuty = exports["soe-jobs"]:IsOnDuty()
            local nearGoPostalTruck = exports["soe-jobs"]:IsCloseToGoPostalTruck()
            local hasPackage = exports["soe-jobs"]:GetHasGoPostalPackage()

            if nearGoPostalTruck and isOnDuty and hasPackage then
                return true
            end
            return false
        end
    },
    {
        id = "deliverGoPostalPackage",
        name = "Deliver Package",
        icon = "#globe",
        type = "client",
        func = "Jobs:Client:DeliverGoPostalPackage",
        closeOnClick = true,
        showIf = function()
            local isOnDuty = exports["soe-jobs"]:IsOnDuty()
            local nearPackageDestination = exports["soe-jobs"]:IsCloseToGoPostalPackageDestination()
            local hasPackage = exports["soe-jobs"]:GetHasGoPostalPackage()

            if nearPackageDestination and isOnDuty and hasPackage then
                return true
            end
            return false
        end
    },
    {
        id = "collectGoPostalPay",
        name = "Collect Pay",
        icon = "#piggy-bank",
        type = "client",
        func = "Jobs:Client:CollectGoPostalPay",
        closeOnClick = true,
        showIf = function()
            local nearGoPostalDepot = exports["soe-jobs"]:IsCloseToGoPostalDepot()
            local hasPayToCollect = exports["soe-jobs"]:GetHasGoPostalPayToCollect()

            if nearGoPostalDepot and hasPayToCollect ~= nil then
                if hasPayToCollect >= 1 then
                    return true
                else
                    return false
                end
            end
            return false
        end
    },
    {
        id = "spawnGoPostalTruck",
        name = "Get GoPostal Truck",
        icon = "#globe",
        type = "client",
        func = "Jobs:Client:SpawnGoPostalTruck",
        closeOnClick = true,
        showIf = function()
            local isOnDuty = exports["soe-jobs"]:IsOnDuty()
            local nearGoPostalDepot = exports["soe-jobs"]:IsCloseToGoPostalDepot()
            local myGoPostalTruck = exports["soe-jobs"]:GetMyGoPostalTruck()
            local currentJob = exports["soe-jobs"]:GetMyJob()

            if nearGoPostalDepot and isOnDuty and myGoPostalTruck == nil and currentJob == "GOPOSTAL" then
                return true
            end
            return false
        end
    },
    {
        id = "returnGoPostalTruck",
        name = "Return GoPostal Truck",
        icon = "#globe",
        type = "client",
        func = "Jobs:Client:ReturnGoPostalTruck",
        closeOnClick = true,
        showIf = function()
            local nearGoPostalDepot = exports["soe-jobs"]:IsCloseToGoPostalDepot()
            local myGoPostalTruck = exports["soe-jobs"]:GetMyGoPostalTruck()

            if nearGoPostalDepot and myGoPostalTruck ~= nil then
                return true
            end
            return false
        end
    },
    {
        id = "useATM",
        name = "Use ATM",
        icon = "#hand-holding-usd",
        type = "client",
        func = "Bank:Client:UseATM",
        closeOnClick = true,
        showIf = function()
            local isNearATM = exports["soe-bank"]:NearATM()
            return isNearATM and not IsPedSittingInAnyVehicle(PlayerPedId())
        end
    },
    {
        id = "robATM",
        name = "Rob ATM",
        icon = "#gavel",
        type = "client",
        func = "Crime:Client:DoATMRobbery",
        closeOnClick = true,
        showIf = function()
            local isNearATM = exports["soe-bank"]:NearATM()
            return isNearATM and not IsPedSittingInAnyVehicle(PlayerPedId())
        end
    },
    {
        id = "harvestAnimal",
        name = "Harvest Animal",
        icon = "#dove",
        type = "client",
        func = "Jobs:Client:HarvestAnimal",
        closeOnClick = true,
        showIf = function(_, entity)
            local inVeh = IsPedSittingInAnyVehicle(PlayerPedId())
            if HasPedGotWeapon(PlayerPedId(), "WEAPON_KNIFE", false) and IsEntityDead(entity) and not IsPedHuman(entity) and not inVeh then
                return true
            end
            return false
        end
    },
    {
        id = "startSecurityDuty",
        name = "Start Security Job",
        icon = "#security",
        type = "client",
        func = "Jobs:Client:StartSecurityDuty",
        closeOnClick = true,
        showIf = function()
            return exports["soe-jobs"]:IsCloseToSecurityOffice() and not exports["soe-jobs"]:IsOnDuty()
        end
    },
    {
        id = "stopSecurityDuty",
        name = "End Security Job",
        icon = "#security",
        type = "client",
        func = "Jobs:Client:EndSecurityDuty",
        closeOnClick = true,
        showIf = function()
            return exports["soe-jobs"]:IsCloseToSecurityOffice() and (exports["soe-jobs"]:GetMyJob() == "SECURITY")
        end
    },
    {
        id = "stolenSecurityCar",
        name = "Report Vehicle Missing",
        icon = "#security",
        type = "client",
        func = "Jobs:Client:StolenPatrolCar",
        closeOnClick = true,
        showIf = function()
            if exports["soe-jobs"]:IsCloseToSecurityOffice() and exports["soe-jobs"]:GetMyJob() == "SECURITY" and exports["soe-jobs"]:HasCheckedOutSecurityVehicle() then
                return true
            end
            return false
        end
    },
    {
        id = "getSecurityVehicle",
        name = "Check-Out Patrol Car",
        icon = "#security",
        type = "client",
        func = "Jobs:Client:SpawnPatrolCar",
        closeOnClick = true,
        showIf = function()
            if exports["soe-jobs"]:IsCloseToSecurityOffice() and exports["soe-jobs"]:GetMyJob() == "SECURITY" and not exports["soe-jobs"]:HasCheckedOutSecurityVehicle() then
                return true
            end
            return false
        end
    },
    {
        id = "getChopShopList",
        name = "Get Target List",
        icon = "#vehicle",
        type = "client",
        func = "Crime:Client:DisplayChopShopList",
        closeOnClick = true,
        showIf = function()
            return exports["soe-crime"]:IsNearChopShop() and not IsPedSittingInAnyVehicle(PlayerPedId())
        end
    },
    {
        id = "turnVehicleInChopShop",
        name = "Turn Vehicle In",
        icon = "#vehicle",
        type = "client",
        func = "Crime:Client:TurnInChopShopVehicle",
        closeOnClick = true,
        showIf = function()
            return exports["soe-crime"]:IsNearChopShopDropOff() and IsPedSittingInAnyVehicle(PlayerPedId())
        end
    },
    {
        id = "startElectricianJob",
        name = "Toggle Electrician Job",
        icon = "#charging-station",
        type = "client",
        func = "Prison:Client:StartElectricianJob",
        closeOnClick = true,
        showIf = function()
            return exports["soe-prison"]:IsImprisoned() and exports["soe-prison"]:IsNearElectricJob()
        end
    },
    {
        id = "fixElectricalBoxInPrison",
        name = "Fix Electrical Box",
        icon = "#charging-station",
        type = "client",
        func = "Prison:Client:FixElectricalBox",
        closeOnClick = true,
        showIf = function()
            return exports["soe-prison"]:IsImprisoned() and exports["soe-prison"]:IsDoingElectricianJob() and exports["soe-prison"]:IsNearElectricalBox()
        end
    },
    {
        id = "raidWarehouse",
        name = "Raid Warehouse",
        icon = "#warehouse",
        type = "client",
        func = "Crime:Client:RaidWarehouse",
        closeOnClick = true,
        showIf = function()
            return exports["soe-crime"]:IsNearWarehouse()
        end
    },
    {
        id = "raidWarehouseCrate",
        name = "Open Crate",
        icon = "#hand-holding-usd",
        type = "client",
        func = "Crime:Client:RaidWarehouseCrate",
        closeOnClick = true,
        showIf = function()
            return exports["soe-crime"]:IsNearWarehouseCrate()
        end
    },
    {
        id = "breakIntoHouse",
        name = "Break Into House",
        icon = "#home",
        type = "client",
        func = "Crime:Client:BreakIntoHouse",
        closeOnClick = true,
        showIf = function()
            return exports["soe-crime"]:IsNearRobbableHouse()
        end
    },
    {
        id = "lootHouseItem",
        name = "Find Loot",
        icon = "#hand-holding-usd",
        type = "client",
        func = "Crime:Client:LootHouseItem",
        closeOnClick = true,
        showIf = function()
            return exports["soe-crime"]:IsNearHouseItem()
        end
    },
    {
        id = "useCampfire",
        name = "Cook On Campfire",
        icon = "#campfire",
        type = "client",
        func = "Civ:Client:UseCampFire",
        closeOnClick = true,
        showIf = function(_, entity)
            return GetEntityModel(entity) == models["Campfire"]
        end
    },
    {
        id = "robVendingMachine",
        name = "Tamper Vending Machine",
        icon = "#gavel",
        type = "client",
        func = "Crime:Client:DoMachineRobbery",
        closeOnClick = true,
        showIf = function(_, entity)
            return models["Vending Machines"] and models["Vending Machines"][GetEntityModel(entity)]
        end
    },
    {
        id = "lootCashTrolley",
        name = "Loot Trolley",
        icon = "#hand-holding-usd",
        type = "client",
        func = "Crime:Client:LootCashTrolleys",
        closeOnClick = true,
        showIf = function(_, entity)
            return models["Cash Trolley"] and models["Cash Trolley"][GetEntityModel(entity)]
        end
    },
}

subMenus = {
    -- GENERAL SUBMENUS
    ["general:putincar"] = {
        title = "Put In Vehicle",
        icon = "#globe",
        type = "command",
        func = "putincar",
        closeOnClick = true
    },
    ["general:pullout"] = {
        title = "Take From Vehicle",
        icon = "#globe",
        type = "command",
        func = "pullout",
        closeOnClick = true
    },
    ["general:drag"] = {
        title = "Drag",
        icon = "#globe",
        type = "command",
        func = "drag",
        closeOnClick = true
    },
    ["general:escort"] = {
        title = "Escort",
        icon = "#globe",
        type = "command",
        func = "escort",
        closeOnClick = true
    },
    ["general:carry"] = {
        title = "Carry",
        icon = "#globe",
        type = "command",
        func = "carry",
        closeOnClick = true
    },
    ["general:hold"] = {
        title = "Hold",
        icon = "#globe",
        type = "command",
        func = "hold",
        closeOnClick = true
    },
    ["general:piggyback"] = {
        title = "Piggyback",
        icon = "#globe",
        type = "command",
        func = "piggyback",
        closeOnClick = true
    },
    -- CLOTHING SUBMENUS
    ["clothing:shirt"] = {
        title = "Shirt/Jacket",
        icon = "#globe",
        type = "command",
        func = "shirt",
        closeOnClick = true
    },
    ["clothing:pants"] = {
        title = "Pants",
        icon = "#globe",
        type = "command",
        func = "pants",
        closeOnClick = true
    },
    ["clothing:shoes"] = {
        title = "Shoes",
        icon = "#globe",
        type = "command",
        func = "shoes",
        closeOnClick = true
    },
    ["clothing:mask"] = {
        title = "Mask",
        icon = "#globe",
        type = "command",
        func = "mask",
        closeOnClick = true
    },
    ["clothing:hat"] = {
        title = "Hat",
        icon = "#globe",
        type = "command",
        func = "hat",
        closeOnClick = true
    },
    ["clothing:ears"] = {
        title = "Earpiece",
        icon = "#globe",
        type = "command",
        func = "ear",
        closeOnClick = true
    },
    ["clothing:vest"] = {
        title = "Vest",
        icon = "#globe",
        type = "command",
        func = "vest",
        closeOnClick = true
    },
    -- VEHICLE SUBMENUS
    ["vehicle:engine"] = {
        title = "Toggle Engine",
        icon = "#car-battery",
        type = "command",
        func = "engine",
        closeOnClick = true
    },
    ["vehicle:seatbelt"] = {
        title = "Toggle Seatbelt",
        icon = "#compress-alt",
        type = "command",
        func = "belt",
        closeOnClick = true
    },
    ["vehicle:neutralgear"] = {
        title = "Neutral Gear",
        icon = "#lightbulb",
        type = "command",
        func = "neutral",
        closeOnClick = true
    },
    ["vehicle:shuffleseats"] = {
        title = "Shuffle Seats",
        icon = "#random",
        type = "command",
        func = "shuffle",
        closeOnClick = true
    },
    -- POLICE TOOL SUBMENUS
    ["police:identify"] = {
        title = "Identify",
        icon = "#user-tag",
        type = "command",
        func = "identify",
        closeOnClick = true
    },
    -- EMS TOOL SUBMENUS
    ["ems:triage"] = {
        title = "Triage",
        icon = "#syringe",
        type = "command",
        func = "triage",
        closeOnClick = true
    },
    ["ems:heal"] = {
        title = "Heal",
        icon = "#syringe",
        type = "command",
        func = "heal",
        closeOnClick = true
    },
    ["ems:revive"] = {
        title = "Revive",
        icon = "#syringe",
        type = "command",
        func = "revive",
        closeOnClick = true
    },
    ["ems:putinbed"] = {
        title = "Put In Bed",
        icon = "#syringe",
        type = "command",
        func = "putinbed",
        closeOnClick = true
    }
}
