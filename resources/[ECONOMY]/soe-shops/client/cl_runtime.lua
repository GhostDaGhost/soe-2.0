local threadDelay = 550

-- HANDLES NATIVEUI MENU SHUTDOWNS
local function HandleMenuClosing()
    if isDealershipMenuOpen then menuV:CloseAll() end
    if isStoreMenuOpen then menuV:CloseAll() end
end

-- SORT ALL ITEMS IN LIST BY NAME
local function SortItemTables()
    local function nameSort(a, b)
        if a.name < b.name then
            return true
        else
            return false
        end
    end
    table.sort(items, nameSort)
    table.sort(sellableItems, nameSort)
end

CreateThread(function()
    Wait(6500)
    CreateZones()
    InitModshops()
    SortItemTables()

    while true do
        Wait(threadDelay)
        local ped = PlayerPedId()
        if IsNearVendingMachine(ped) and not usingVendingMachine and not IsPedInAnyVehicle(ped, false) then
            threadDelay = 30
            HandleVendingMachineRuntime()
        elseif IsNearStore(ped) and not IsPedInAnyVehicle(ped, false) then
            threadDelay = 450
        elseif IsNearDealership(ped) and not IsPedInAnyVehicle(ped, false) then
            threadDelay = 450
        else
            threadDelay = 550
            if showingVendingMachineHelpText then
                showingVendingMachineHelpText = false
                exports["soe-ui"]:HideTooltip()
            end
            HandleMenuClosing()
        end
    end
end)
