-- LOCAL VARIABLES
local SOEMenu = assert(MenuV)
local toggleNeons, originalModifications
local isMenuOpen, isLoading = false, false
local vehMenuMain = SOEMenu:CreateMenu("Los Santos Customs", 'ALL YOUR CAR NEEDS IN ONE PLACE!', 'topright', 255, 255, 255, 'size-100', 'default', 'menuv', 'vehMenuMain', 'native')
local myModifications = {}

-- PROCESS TRANSACTION FOR HOUSE
function ProcessModshopTransaction(type, total, shop)
    local payment
    if type == "repair" then
        payment = exports["soe-shops"]:NewTransaction(tonumber(total), "Vehicle Repairs - " .. shop.name)
    elseif type == "mod" then
        payment = exports["soe-shops"]:NewTransaction(tonumber(total), "Vehicle Modifications - " .. shop.name)
    end

    if payment then
        print("SUCCESS ON TRANSACTION SIDE, MODIFYING VEHICLE")
        return true
    end
    print("FAILURE ON THE TRANSACTION SIDE, NOT MODIFYING VEHICLE")
    return false
end

function InitModshops()
    for shopID, shop in pairs(modShops) do
        --[[if not shop.noMarker then
            exports["soe-utils"]:AddMarker("Modshop-" .. shopID, {27, shop.pos.x, shop.pos.y, shop.pos.z - 0.92, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 2.0, 75, 245, 66, 140, 0, 0, 2, 0, 0, 0, 0, 35.5})
        end]]--

        if not shop.noBlip then
            local blip = AddBlipForCoord(shop.pos)
            local name = "Repair Shop"
            if shop.canCustomize then
                SetBlipSprite(blip, 72)
                SetBlipScale(blip, 0.6)
                name = "Modshop"
            else
                SetBlipSprite(blip, 402)
                SetBlipScale(blip, 0.8)
            end
            SetBlipColour(blip, 24)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(name)
            EndTextCommandSetBlipName(blip)
            Wait(15)
        end
    end
end

-- OPEN VEHICLE MENU
local function OpenModshopMenu(isInVeh, canCustomize, shop)
    -- CLEAR MENU IF IT ALREADY EXISTS
    vehMenuMain:ClearItems()
    vehMenuMain:SetTitle(shop.name)

    local doesNotNeedToPay = false
    if shop.staff or shop.isEmergencyServices and isInVeh then
        local authorized = false
        local civType = exports["soe-uchuu"]:GetPlayer().CivType
        local myVeh = GetVehiclePedIsIn(PlayerPedId(), false)

        if shop.isEmergencyServices then
            if (civType == "POLICE" or civType == "EMS" or civType == "CRIMELAB") and GetVehicleClass(myVeh) == 18 then
                doesNotNeedToPay = true
                authorized = true
            elseif (civType ~= "POLICE" and civType ~= "EMS" and civType ~= "CRIMELAB") then
                exports["soe-ui"]:SendUniqueAlert("notAuthorized", "error", "You are not authorized to use this repair station!", 5000)
            elseif GetVehicleClass(myVeh) ~= 18 then
                if GetEntityModel(myVeh) == `speedo4` then -- CRIMELAB
                    doesNotNeedToPay = true
                    authorized = true
                else
                    exports["soe-ui"]:SendUniqueAlert("emergencyOnly", "error", "You can only repair emergency service vehicles here!", 5000)
                end
            end
        elseif shop.staff then
            doesNotNeedToPay = true
            authorized = true
        end

        if not authorized then
            SOEMenu:CloseAll()
            isMenuOpen = false
            return
        end        
    end

    -- CREATE SUBMENUS
    local vehRepairMenu = SOEMenu:InheritMenu(vehMenuMain, {["title"] = false, ["subtitle"] = "HAD A BIT OF AN ACCIDENT? WE'VE GOT YOU COVERED!" })
    local vehModMenu = SOEMenu:InheritMenu(vehMenuMain, {["title"] = false, ["subtitle"] = "IT'S YOUR CAR, HAVE IT YOUR WAY!"})
    local vehPickupMenu = SOEMenu:InheritMenu(vehMenuMain, {["title"] = false,["subtitle"] = "YOUR CAR WAS SAFE AND SOUND WITH US!"})
    local vehQuoteMenu = SOEMenu:InheritMenu(vehMenuMain, {["title"] = false, ["subtitle"] = "READY TO ROCK AND ROLL? HERE'S THE QUOTE!"})
    local vehColorCodeMenu = SOEMenu:InheritMenu(vehMenuMain, {["title"] = false, ["subtitle"] = "HATE USING SLIDERS? INPUT YOUR CODES! WE GOT YOU!"})

    -- IF IN A VEHICLE
    if isInVeh then
        -- MAIN MENU BUTTONS
        local myVeh = GetVehiclePedIsIn(PlayerPedId(), false)
        local repairButton = vehMenuMain:AddButton({icon = '🛠️', label = 'Repair Options', value = vehRepairMenu})

        local modButton
        if canCustomize and GetVehicleEngineHealth(myVeh) == 1000 and GetVehicleBodyHealth(myVeh) == 1000 then 
            modButton = vehMenuMain:AddButton({icon = '🔧', label = 'Modification Options', value = vehModMenu}) 
        elseif canCustomize then
            TriggerEvent("Chat:Client:SendMessage", "modshop", "This shop can modify your vehicle but it needs to be fully repaired first!")
        end

        -- REPAIR MENU QUOTE | GET CAR VALUE
        local carValue = 20000
        local displayName = GetDisplayNameFromVehicleModel(GetEntityModel(myVeh))
        if exports["soe-config"]:GetConfigValue("economy", displayName:lower()) then
            carValue = exports["soe-config"]:GetConfigValue("economy", displayName:lower()).buy
        end

        local discountText, stockStatus = "", true
        local price, time = GetRepairDetails(carValue, myVeh)
        originalModifications = GetModDataFromVehicle(myVeh, true)

        local canModify = exports["soe-factions"]:CheckPermission("CANMODIFY")
        local inspectButton = vehMenuMain:AddButton({icon = '🔍', label = 'Inspect Vehicle', select = function()
            local title = "Inspection List for the " .. GetLabelText(displayName)
            TriggerEvent("Chat:Client:SendMessage", "center", title)
            TriggerEvent("Chat:Client:SendMessage", "linebreak")

            local vin = DecorGetInt(myVeh, "vin")
            if (vin ~= 0) then
                TriggerEvent("Chat:Client:Message", "", "^0^*[VIN]: ^r^2" .. vin, "blank")
            else
                TriggerEvent("Chat:Client:Message", "", "^0^*[VIN]: ^r^3Unreadable", "blank")
            end
            TriggerEvent("Chat:Client:Message", "", "^0^*[License Plate]: ^r^2" .. GetVehicleNumberPlateText(myVeh), "blank")

            TriggerEvent("Chat:Client:SendMessage", "linebreak")
        end})

        if exports["soe-factions"]:CheckPermission("CANREPAIR") then
            discountText = "<br><b>Employee discount active!</b>"
        end

        -- GET QUOTE
        local quote
        if stockStatus and doesNotNeedToPay then
            quote = string.format(
                "Your Quote: <br><br> Price: <font style='color:lightgreen'>FREE</font><br> Estimated Duration: <font style='color:lightblue'>%s</font><br> Part Status: <font style='color:lightgreen'>In Stock</font>" .. discountText, 
                "1 Min."
            )
        elseif stockStatus then
            quote = string.format(
                "Your Quote: <br><br> Estimated Price: <font style='color:lightgreen'>$%s</font><br> Estimated Duration: <font style='color:lightblue'>%s</font><br> Part Status: <font style='color:lightgreen'>In Stock</font>" .. discountText, 
                price, 
                "1 Min."
            )
        else
            quote = string.format(
                "Your Quote: <br><br> Estimated Price: <font style='color:lightgreen'>$%s</font><br> Estimated Duration: <font style='color:lightblue'>%s</font><br> Part Status: <font style='color:tomato'>Out of Stock</font>" .. discountText, 
                price, 
                time
            )
        end

        -- REPAIR MENU BUTTONS
        local priceQuote = vehRepairMenu:AddButton({label = quote, disabled = true})
        local acceptQuote = vehRepairMenu:AddButton({icon = '✔️', label = 'Accept Quote', select = function()
            local process = false
            if not doesNotNeedToPay then
                process = ProcessModshopTransaction("repair", math.floor(tonumber(price)), shop)
            else
                process = true
            end

            if process then
                SOEMenu:CloseAll()
                isMenuOpen, isLoading = false, true
                exports["soe-utils"]:Progress(
                    {
                        name = "fixingVehicle",
                        duration = 25000,
                        label = "Repair in Progress",
                        useWhileDead = false,
                        canCancel = false,
                        controlDisables = {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true
                        }
                    },
                    function(cancelled)
                        if not cancelled then
                            isLoading = false
                            FreezeEntityPosition(myVeh, false)
                            TriggerServerEvent("Utils:Server:SyncVehicleRepair", {status = true, entity = VehToNet(myVeh)})
                            --exports["soe-utils"]:RepairVehicle(myVeh)
                            SetVehicleEngineHealth(myVeh, 1000.0)
                            SetVehicleEngineHealth(myVeh, 1000.0)
                        end
                    end
                )
            else
                -- DO NOTHING
            end
        end})

        local declineQuote = vehRepairMenu:AddButton({ icon = '❌', label = 'Decline Quote'})

        -- MODIFICATION MENU | SET VEHICLE MODKIT
        SetVehicleModKit(myVeh, 0)

        -- MISC OPTIONS
        local miscLabel = vehModMenu:AddButton({label = "MISC. OPTIONS", disabled = true})
        local tintSlider = vehModMenu:AddSlider({icon = '⬛', label = "Modify Tint", values = GenerateSliderValues(110, 5)})
        local plateSlider = vehModMenu:AddSlider({icon = '🚘', label = "Modify Plate Type", values = GenerateSliderValues(115, 3)})
        local xenonToggle = vehModMenu:AddConfirm({icon = '💡', label = "Xenon Headlights"})
        local neonUnderglowToggle = vehModMenu:AddConfirm({icon = '🚨', label = "Neon Underglow"})

        tintSlider.Value = GetVehicleWindowTint(myVeh) + 1
        plateSlider.Value = GetVehicleNumberPlateTextIndex(myVeh) + 1
        xenonToggle.Value = IsToggleModOn(myVeh, 22)

        local areNeonsOn = false
        if originalModifications.toggles then
            areNeonsOn = originalModifications.toggles.neons
        end
        neonUnderglowToggle.Value = areNeonsOn

        -- TINT SLIDER
        tintSlider:On('change', function(item, newValue, oldValue)
            SetVehicleWindowTint(myVeh, newValue)
            myModifications[110] = exports["soe-config"]:GetConfigValue("economy", "modshop_110")
        end)

        -- PLATE TYPE SLIDER
        plateSlider:On('change', function(item, newValue, oldValue)
            SetVehicleNumberPlateTextIndex(myVeh, newValue)
            myModifications[115] = exports["soe-config"]:GetConfigValue("economy", "modshop_115")
        end)

        -- XENON TOGGLE
        xenonToggle:On('change', function(item, newValue, oldValue)
            ToggleVehicleMod(myVeh, 22, newValue)
            myModifications[117] = exports["soe-config"]:GetConfigValue("economy", "modshop_117")
        end)

        -- NEON UNDERGLOW TOGGLE
        neonUnderglowToggle:On("change", function(item, newValue)
            toggleNeons = not toggleNeons
            myModifications[121] = exports["soe-config"]:GetConfigValue("economy", "modshop_121")
        end)

        -- PAINT/LIVERY OPTIONS
        local paintLabel = vehModMenu:AddButton({label = "PAINT OPTIONS", disabled = true})
        local colorCodeSubmenuButton = vehModMenu:AddButton({icon = '🎨', label = 'Color Code Inputs', value = vehColorCodeMenu})

        if (GetVehicleLiveryCount(myVeh) >= 1) then
            local liverySlider2 = vehModMenu:AddSlider({icon = '🎨', label = "Modify Primary Livery", values = GenerateSliderValues(1, GetVehicleLiveryCount(myVeh))})
            liverySlider2.Value = GetVehicleLivery(myVeh) + 1
            liverySlider2:On("change", function(item, newValue, oldValue)
                if (GetVehicleLivery(myVeh) ~= (newValue - 1)) then
                    SetVehicleLivery(myVeh, newValue - 1)
                    myModifications[122] = exports["soe-config"]:GetConfigValue("economy", "modshop_48")
                end
            end)
        end

        if (GetNumVehicleMods(myVeh, 48) >= 1) then
            local liverySlider = vehModMenu:AddSlider({icon = '🎨', label = "Modify Secondary Livery", values = GenerateSliderValues(48, GetNumVehicleMods(myVeh, 48))})
            liverySlider.Value = GetVehicleMod(myVeh, 48) + 2

            liverySlider:On('change', function(item, newValue, oldValue)
                ApplyModification(myVeh, 48, newValue - 1, exports["soe-config"]:GetConfigValue("economy", "modshop_48"))
            end)
        end

        local paintCodeEntry = vehColorCodeMenu:AddButton({ icon = '🎨', label = "Enter Primary Color", select = function()
            exports["soe-input"]:OpenInputDialogue("number", "Enter a valid primary color code:", function(returnData)
                if not tonumber(returnData) then
                    exports["soe-ui"]:SendAlert("error", "Invalid code entered!", 5000)
                    return
                end

                local _, color2 = GetVehicleColours(myVeh)
                SetVehicleColours(myVeh, tonumber(returnData), color2)
                myModifications[111] = exports["soe-config"]:GetConfigValue("economy", "modshop_111")
            end)
        end})

        local paintCodeEntry2 = vehColorCodeMenu:AddButton({ icon = '🎨', label = "Enter Secondary Color", select = function()
            exports["soe-input"]:OpenInputDialogue("number", "Enter a valid secondary color code:", function(returnData)
                if not tonumber(returnData) then
                    exports["soe-ui"]:SendAlert("error", "Invalid code entered!", 5000)
                    return
                end

                local color1 = GetVehicleColours(myVeh)
                SetVehicleColours(myVeh, color1, tonumber(returnData))
                myModifications[112] = exports["soe-config"]:GetConfigValue("economy", "modshop_112")
            end)
        end})

        local paintCodeEntry3 = vehColorCodeMenu:AddButton({ icon = '🎨', label = "Enter Pearlescent Color", select = function()
            exports["soe-input"]:OpenInputDialogue("number", "Enter a valid pearlescent color code:", function(returnData)
                if not tonumber(returnData) then
                    exports["soe-ui"]:SendAlert("error", "Invalid code entered!", 5000)
                    return
                end

                local _, color2 = GetVehicleExtraColours(myVeh)
                SetVehicleExtraColours(myVeh, tonumber(returnData), color2)
                myModifications[113] = exports["soe-config"]:GetConfigValue("economy", "modshop_113")
            end)
        end})

        local paintCodeEntry4 = vehColorCodeMenu:AddButton({ icon = '🎨', label = "Enter Wheel Color", select = function()
            exports["soe-input"]:OpenInputDialogue("number", "Enter a valid wheel color code:", function(returnData)
                if not tonumber(returnData) then
                    exports["soe-ui"]:SendAlert("error", "Invalid code entered!", 5000)
                    return
                end

                local color1 = GetVehicleExtraColours(myVeh)
                SetVehicleExtraColours(myVeh, color1, tonumber(returnData))
                myModifications[114] = exports["soe-config"]:GetConfigValue("economy", "modshop_114")
            end)
        end})

        local paintCodeEntry5 = vehColorCodeMenu:AddButton({ icon = '🎨', label = "Enter Dashboard Color", select = function()
            exports["soe-input"]:OpenInputDialogue("number", "Enter a valid dashboard color code:", function(returnData)
                if not tonumber(returnData) then
                    exports["soe-ui"]:SendAlert("error", "Invalid code entered!", 5000)
                    return
                end

                SetVehicleDashboardColor(myVeh, tonumber(returnData))
                myModifications[123] = exports["soe-config"]:GetConfigValue("economy", "modshop_123")
            end)
        end})

        local paintCodeEntry6 = vehColorCodeMenu:AddButton({ icon = '🎨', label = "Enter Interior Color", select = function()
            exports["soe-input"]:OpenInputDialogue("number", "Enter a valid interior color code:", function(returnData)
                if not tonumber(returnData) then
                    exports["soe-ui"]:SendAlert("error", "Invalid code entered!", 5000)
                    return
                end

                SetVehicleInteriorColor(myVeh, tonumber(returnData))
                myModifications[124] = exports["soe-config"]:GetConfigValue("economy", "modshop_124")
            end)
        end})

        local paintSlider = vehModMenu:AddSlider({icon = '🎨', label = "Modify Primary Color", values = GenerateSliderValues(111, 160)})
        local paint2Slider = vehModMenu:AddSlider({icon = '🎨', label = "Modify Secondary Color", values = GenerateSliderValues(111, 160)})
        local paint3Slider = vehModMenu:AddSlider({icon = '🎨', label = "Modify Pearlescent Color", values = GenerateSliderValues(111, 160)})
        local paint4Slider = vehModMenu:AddSlider({icon = '🎨', label = "Modify Wheel Color", values = GenerateSliderValues(111, 160)})
        local paint5Slider = vehModMenu:AddSlider({icon = '🎨', label = "Modify Dashboard Color", values = GenerateSliderValues(111, 160)})
        local paint6Slider = vehModMenu:AddSlider({icon = '🎨', label = "Modify Interior Color", values = GenerateSliderValues(111, 160)})

        paintSlider.Value, paint2Slider.Value = GetVehicleColours(myVeh)
        paintSlider.Value, paint2Slider.Value = paintSlider.Value + 1, paint2Slider.Value + 1

        paint3Slider.Value, paint4Slider.Value = GetVehicleExtraColours(myVeh)
        paint3Slider.Value, paint4Slider.Value = paint3Slider.Value + 1, paint4Slider.Value + 1

        paint5Slider.Value = GetVehicleDashboardColor(myVeh)
        paint5Slider.Value = paint5Slider.Value + 1

        paint6Slider.Value = GetVehicleInteriorColor(myVeh)
        paint6Slider.Value = paint6Slider.Value + 1

        -- PRIMARY SLIDER
        paintSlider:On('change', function(item, newValue, oldValue)
            local color1, color2 = GetVehicleColours(myVeh)
            SetVehicleColours(myVeh, newValue, color2)
            myModifications[111] = exports["soe-config"]:GetConfigValue("economy", "modshop_111")
        end)

        -- SECONDARY SLIDER
        paint2Slider:On('change', function(item, newValue, oldValue)
            local color1, color2 = GetVehicleColours(myVeh)
            SetVehicleColours(myVeh, color1, newValue)
            myModifications[112] = exports["soe-config"]:GetConfigValue("economy", "modshop_112")
        end)

        -- PEARL SLIDER
        paint3Slider:On('change', function(item, newValue, oldValue)
            local color1, color2 = GetVehicleExtraColours(myVeh)
            SetVehicleExtraColours(myVeh, newValue, color2)
            myModifications[113] = exports["soe-config"]:GetConfigValue("economy", "modshop_113")
        end)

        -- WHEEL COLOR SLIDER
        paint4Slider:On('change', function(item, newValue, oldValue)
            local color1, color2 = GetVehicleExtraColours(myVeh)
            SetVehicleExtraColours(myVeh, color1, newValue)
            myModifications[114] = exports["soe-config"]:GetConfigValue("economy", "modshop_114")
        end)

        -- DASHBOARD COLOR SLIDER
        paint5Slider:On('change', function(item, newValue, oldValue)
            SetVehicleDashboardColor(myVeh, newValue)
            myModifications[123] = exports["soe-config"]:GetConfigValue("economy", "modshop_123")
        end)

        -- INTERIOR COLOR SLIDER
        paint6Slider:On('change', function(item, newValue, oldValue)
            SetVehicleInteriorColor(myVeh, newValue)
            myModifications[124] = exports["soe-config"]:GetConfigValue("economy", "modshop_124")
        end)

        -- WHEEL OPTIONS
        local wheelLabel = vehModMenu:AddButton({label = "WHEEL/TIRE OPTIONS", disabled = true})
        local wheelSlider = vehModMenu:AddSlider({icon = '🚘', label = "Modify Wheels", values = GenerateSliderValues(23, GetNumVehicleMods(myVeh, 23))})
        --local wheelTypeSlider = vehModMenu:AddSlider({icon = '🚘', label = "Modify Wheel Category", values = GenerateSliderValues(116, 9)})
        local tireToggle = vehModMenu:AddConfirm({icon = '🚘', label = "Install Custom Tires"})

        wheelSlider.Value = GetVehicleMod(myVeh, 23) + 2
        --wheelTypeSlider.Value = GetVehicleWheelType(myVeh)
        tireToggle.Value = GetVehicleModVariation(myVeh, 23)

        -- MAIN WHEEL SLIDER
        wheelSlider:On('change', function(item, newValue, oldValue)
            ApplyModification(myVeh, 23, newValue - 1, exports["soe-config"]:GetConfigValue("economy", "modshop_23"))
        end)

        -- WHEEL CATEGORY SLIDER
        --[[wheelTypeSlider:On('change', function(item, newValue, oldValue)
            SetVehicleWheelType(myVeh, newValue)
            myModifications[116] = exports["soe-config"]:GetConfigValue("economy", "modshop_116")
        end)]]

        -- CUSTOM TIRE TOGGLE
        tireToggle:On('change', function(item, newValue, oldValue)
            SetVehicleMod(myVeh, 23, GetVehicleMod(myVeh, 23), newValue)
            SetVehicleMod(myVeh, 24, GetVehicleMod(myVeh, 24), newValue)
            myModifications[118] = exports["soe-config"]:GetConfigValue("economy", "modshop_118")
        end)

        -- ADD ALL COSMETIC MOD OPTIONS
        local modsLabel = vehModMenu:AddButton({label = "BODY OPTIONS", disabled = true})
        for modIndex = 0, 46 do
            if modIndex ~= 11 and modIndex ~= 12 and modIndex ~= 13 and modIndex ~= 15 and modIndex ~= 16 and modIndex ~= 23 then
                local numMods = GetNumVehicleMods(myVeh, modIndex)
                if modItems[modIndex] then
                    -- SLIDER ITEM
                    local modSlider = vehModMenu:AddSlider({icon = '🔧', label = "Modify " .. modItems[modIndex].title, values = GenerateSliderValues(modIndex, numMods)})
                    modSlider.Value = GetVehicleMod(myVeh, modIndex) + 2

                    -- SLIDER CHANGED EVENT
                    modSlider:On('change', function(item, newValue)
                        local price = tonumber(GetItemValue(carValue, myVeh, modIndex, newValue - 1, false))
                        ApplyModification(myVeh, modIndex, newValue - 1, price)
                    end)

                    -- NEEDED WAIT TO MAKE SURE NOTHING IS MIXED
                    Wait(10)
                end
            end
        end

        -- ADD ALL PERFORMANCE MOD OPTIONS
        local permformanceLabel = vehModMenu:AddButton({label = "PERFORMANCE OPTIONS", disabled = true})
        if canModify then
            TriggerEvent("Chat:Client:SendMessage", "modshop", "You can do upgrades as you are a mechanic!")
            for modIndex = 0, 46 do
                if (modIndex == 11 or modIndex == 12 or modIndex == 13 or modIndex == 15 or modIndex == 16) then
                    local numMods = GetNumVehicleMods(myVeh, modIndex)
                    if modItems[modIndex] and numMods >= 2 then

                        -- SLIDER ITEM
                        local modSlider = vehModMenu:AddSlider({icon = '🔧', label = "Modify " .. modItems[modIndex].title, values = GenerateSliderValues(modIndex, numMods)})
                        modSlider.Value = GetVehicleMod(myVeh, modIndex) + 2

                        -- SLIDER CHANGED EVENT
                        modSlider:On('change', function(item, newValue)
                            local price = tonumber(GetItemValue(carValue, myVeh, modIndex, newValue - 1, false))
                            ApplyModification(myVeh, modIndex, newValue - 1, price)
                        end)

                        -- NEEDED WAIT TO MAKE SURE NOTHING IS MIXED
                        Wait(10)
                    end
                end
            end

            -- TURBO
            local turboToggle = vehModMenu:AddConfirm({icon = '💨', label = "Turbocharger"})
            turboToggle.Value = IsToggleModOn(myVeh, 18)
            turboToggle:On('change', function(item, newValue)
                ToggleVehicleMod(myVeh, 18, newValue)
                myModifications[119] = exports["soe-config"]:GetConfigValue("economy", "modshop_119")
            end)
        else
            local blockedUpgradesButton = vehModMenu:AddButton({icon = "", label = "You cannot do upgrades as you are not a mechanic!"})
            TriggerEvent("Chat:Client:SendMessage", "modshop", "You cannot do upgrades as you are not a mechanic!")
        end

        -- ADD ALL EXTRA OPTIONS
        local extraLabel = vehModMenu:AddButton({label = "EXTRA OPTIONS", disabled = true})
        for modIndex = 0, 25 do
            if DoesExtraExist(myVeh, modIndex) then
                local extraToggle = vehModMenu:AddConfirm({icon = '🔧', label = "Extra " .. modIndex})
                extraToggle.Value = IsVehicleExtraTurnedOn(myVeh, modIndex)

                -- TOGGLE CHANGED EVENT
                extraToggle:On('change', function(item, newValue)
                    myModifications[120] = exports["soe-config"]:GetConfigValue("economy", "modshop_120")
                    if newValue then
                        SetVehicleExtra(myVeh, modIndex, 0)
                    else
                        SetVehicleExtra(myVeh, modIndex, 1)
                    end
                end)

                -- NEEDED WAIT TO MAKE SURE NOTHING IS MIXED
                Wait(10)
            end
        end

        -- GET MOD QUOTE
        vehModMenu:AddButton({icon = '📝', label = "Get Quote", value = vehQuoteMenu, select = function()
            vehQuoteMenu:ClearItems()

            local quote = GenerateQuote()
            local priceQuoteMod = vehQuoteMenu:AddButton({label = quote, disabled = true})
            local acceptQuoteMod = vehQuoteMenu:AddButton({icon = '✔️', label = 'Accept Quote', select = function()
                local process = false
                if not doesNotNeedToPay then
                    process = ProcessModshopTransaction("mod", math.floor(tonumber(GetModsTotalPrice())), shop)
                else
                    process = true
                end
    
                if process then
                    SOEMenu:CloseAll()
                    isMenuOpen, isLoading = false, true
                    exports["soe-utils"]:Progress(
                        {
                            name = "modifyingVehicle",
                            duration = 25000,
                            label = "Modifications in Progress",
                            useWhileDead = false,
                            canCancel = false,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true
                            }
                        },
                        function(cancelled)
                            if not cancelled then
                                isLoading = false
                                FreezeEntityPosition(myVeh, false)
                                myModifications = {}

                                local vin = DecorGetInt(myVeh, "vin")
                                local mods = GetModDataFromVehicle(myVeh, false)
                                if (vin ~= 0) then
                                    TriggerServerEvent("Shops:Server:UpdateVehicleMods", {status = true, vin = tonumber(vin), mods = mods})
                                end
                            end
                        end
                    )
                else
                    -- DO NOTHING
                end
            end})

            local declineQuoteMod = vehQuoteMenu:AddButton({icon = '❌', label = 'Decline Quote'})
        end})
    -- NOT IN A VEHICLE - COMING SOON
    else
        local pickupButton = vehMenuMain:AddButton({icon = '🚘', label = 'Retrieve Vehicle', value = vehPickupMenu})
    end

    -- OPEN MENU AND FREEZE PLAYER/CONTROLS
    vehMenuMain:Open()
    FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), true)
    isMenuOpen = true
    while isMenuOpen do
        Wait(5)
        DisableControlAction(0, 23)
        DisableControlAction(0, 75)
    end
end
exports("OpenModshopMenu", OpenModshopMenu)

-- GENERATE VALUES FOR A SLIDER BASED ON MOD INFO
function GenerateSliderValues(modIndex, numMods)
    local returnTable = {}
    local stockValue = 0
    local myVeh = GetVehiclePedIsIn(PlayerPedId(), false)
    local offset = 1

    table.insert(returnTable, {
        ["label"] = modItems[modIndex]["labels"][0] or "Stock",
        ["value"] = stockValue
    })

    for i = 1, numMods do
        local label = modItems[modIndex]["labels"][i]

        if not label then
            label = GetLabelText(GetModTextLabel(myVeh, modIndex, i - offset))
            if label == nil or label == "NULL" then
                label = "Option " .. i
            end
        end

        table.insert(returnTable, {
            ["label"] = label,
            ["value"] = i
        })
    end

    return returnTable
end

-- GET THE VALUE OF AN ITEM
function GetItemValue(carValue, modVeh, modType, modIndex, addCurrency)
    local value = 0
    if tonumber(exports["soe-config"]:GetConfigValue("economy", "modshop_" .. modType)) >= 1 then
        value = tonumber(GetConfigValue("economy", "modshop_" .. modType))
    else
        value = carValue * tonumber(exports["soe-config"]:GetConfigValue("economy", "modshop_" .. modType))
    end

    if modType == 11 or modType == 12 or modType == 13 or modType == 15 or modType == 16 then
        value = value * (modIndex + 1)
    end

    if GetVehicleMod(modVeh, modType) == modIndex then
        return "INSTALLED"
    end

    if #string.sub(value, string.find(tostring(value), "%.") + 1) < 2 then
        if addCurrency then
            return "$" .. value .. "0"
        end
        return value .. "0"
    end

    if addCurrency then
        return "$" .. value
    end
    return value
end

-- GET THE REPAIR DETAILS FROM HOW DAMAGED THE VEHICLE IS
function GetRepairDetails(carValue, veh)
    local vehEngineDamage = 1000.0 - GetVehicleEngineHealth(veh)
    local vehBodyDamage = 1000.0 - GetVehicleBodyHealth(veh)

    local price = (carValue * (vehEngineDamage * .000025)) + (carValue * (vehBodyDamage * .000025))
    price = math.floor(price * 10^2 + 0.5) / 10^2
    
    -- IF DOORS ARE MISSING, ADD SOME CHARGE
    for i = 0, 5 do
        if IsVehicleDoorDamaged(veh, i) then
            price = price + 100
        end
    end

    local time = (((vehEngineDamage - 0) * (10 - 0)) / (1000 - 0)) + (((vehBodyDamage - 0) * (10 - 0)) / (1000 - 0))
    --time = math.floor(time) .. " Mins."
    time = "25 Seconds"

    if exports["soe-factions"]:CheckPermission("CANREPAIR") then
        TriggerEvent("Chat:Client:SendMessage", "modshop", "You're getting the employee discount of 40% off!")
        price = price * 0.6
    end
    return price, time
end

-- APPLY MOD TO VEHICLE AND ADD TO QUOTE
function ApplyModification(modVeh, modType, modIndex, modPrice)
    if GetVehicleMod(modVeh, modType) ~= modIndex then
        SetVehicleMod(modVeh, modType, modIndex, GetVehicleModVariation(modVeh, 23))
        myModifications[modType] = modPrice
    end
end

-- GENERATE A FINAL QUOTE
function GenerateQuote()
    local stockStatus = true
    local quote
    local totalPrice, totalTime = 0, 0
    local discountText = ""

    if exports["soe-factions"]:CheckPermission("CANMODIFY") then
        discountText = "<br><b>Employee discount active!</b>"
    end

    if stockStatus then
        quote = "Your Quote: <br><br> Estimated Price: <font style='color:lightgreen'>$%s</font><br> Estimated Duration: <font style='color:lightblue'>%s</font><br> Part Status: <font style='color:lightgreen'>In Stock</font>" .. discountText .. "<br><br> Breakdown:"
    else
        quote = "Your Quote: <br><br> Estimated Price: <font style='color:lightgreen'>$%s</font><br> Estimated Duration: <font style='color:lightblue'>%s</font><br> Part Status: <font style='color:tomato'>Out of Stock</font>" .. discountText .. "<br><br> Breakdown:"
    end

    for modType, modPrice in pairs(myModifications) do
        totalPrice = totalPrice + modPrice
        totalTime = totalTime + 2
        quote = quote .. string.format("<br>Modified %s: <font style='color:lightgreen'>$%s</font>", modItems[modType].title, modPrice)
    end

    if exports["soe-factions"]:CheckPermission("CANMODIFY") then
        totalPrice = totalPrice * 0.6
    end

    --quote = string.format(quote, totalPrice, totalTime .. " Mins.")
    quote = string.format(quote, totalPrice, "25 Seconds")
    return quote
end

function GetModsTotalPrice()
    local totalPrice = 0
    for modType, modPrice in pairs(myModifications) do
        totalPrice = totalPrice + modPrice
    end

    if exports["soe-factions"]:CheckPermission("CANMODIFY") then
        totalPrice = totalPrice * 0.6
    end
    return totalPrice
end

-- GET MOD DATA FROM THE SELECTED VEHICLE
function GetModDataFromVehicle(veh, pullFromDB)
    local currentData = {mods = {}, extras = {}, paint = {}, toggles = {}}
    if pullFromDB then
        local vin = DecorGetInt(veh, "vin")
        if (vin ~= 0) then
            -- PULL FROM DATABASE THE VEHICLE'S CUSTOMIZATION MODS
            local getModData = exports["soe-nexus"]:TriggerServerCallback("Shops:Server:GetVehicleModData", vin)
            if getModData.status then
                currentData = json.decode(getModData.data)
                local saveNeonSelection = toggleNeons
                if (toggleNeons == nil) then
                    toggleNeons = false
                end

                if not currentData.toggles then
                    currentData.toggles = {}
                end

                if (currentData ~= nil and currentData.toggles ~= nil) then
                    if currentData.toggles.neons then
                        toggleNeons = true
                    end
                end

                if (saveNeonSelection == false) then
                    toggleNeons = false
                end
                currentData.toggles.neons = toggleNeons
                return currentData
            else
                -- TRY AND NORMALLY PULL DATA IF DATABASE WAS NO-GO
                GetModDataFromVehicle(veh, false)
            end
        else
            -- TRY AND NORMALLY PULL DATA IF VIN WAS NO-GO
            GetModDataFromVehicle(veh, false)
        end
    end

    -- GATHER VEHICLE'S MODS
    currentData.mods.livery = GetVehicleMod(veh, 48)
    currentData.mods.livery2 = GetVehicleLivery(veh)
    currentData.mods.tint = GetVehicleWindowTint(veh)
    currentData.mods.plateType = GetVehicleNumberPlateTextIndex(veh)

    currentData.mods.spoiler = GetVehicleMod(veh, 0)
    currentData.mods.frontBumper = GetVehicleMod(veh, 1)
    currentData.mods.rearBumper = GetVehicleMod(veh, 2)
    currentData.mods.sideSkirts = GetVehicleMod(veh, 3)
    currentData.mods.exhaust = GetVehicleMod(veh, 4)
    currentData.mods.frame = GetVehicleMod(veh, 5)
    currentData.mods.grille = GetVehicleMod(veh, 6)
    currentData.mods.hood = GetVehicleMod(veh, 7)
    currentData.mods.fender = GetVehicleMod(veh, 8)
    currentData.mods.rightFender = GetVehicleMod(veh, 9)
    currentData.mods.roof = GetVehicleMod(veh, 10)

    currentData.mods.engine = GetVehicleMod(veh, 11)
    currentData.mods.brakes = GetVehicleMod(veh, 12)
    currentData.mods.transmission = GetVehicleMod(veh, 13)
    currentData.mods.horn = GetVehicleMod(veh, 14)
    currentData.mods.suspension = GetVehicleMod(veh, 15)
    currentData.mods.armor = GetVehicleMod(veh, 16)

    currentData.mods.frontWheel = GetVehicleMod(veh, 23)
    currentData.mods.rearWheel = GetVehicleMod(veh, 24)
    currentData.mods.plateHolder = GetVehicleMod(veh, 25)
    currentData.mods.vanityPlate = GetVehicleMod(veh, 26)
    currentData.mods.trimA = GetVehicleMod(veh, 27)
    currentData.mods.ornaments = GetVehicleMod(veh, 28)
    currentData.mods.dashboard = GetVehicleMod(veh, 29)
    currentData.mods.dial = GetVehicleMod(veh, 30)
    currentData.mods.doorSpeaker = GetVehicleMod(veh, 31)
    currentData.mods.seats = GetVehicleMod(veh, 32)
    currentData.mods.steeringWheel = GetVehicleMod(veh, 33)
    currentData.mods.shifterLeavers = GetVehicleMod(veh, 34)
    currentData.mods.modPlate = GetVehicleMod(veh, 35)
    currentData.mods.speakers = GetVehicleMod(veh, 36)
    currentData.mods.trunk = GetVehicleMod(veh, 37)
    currentData.mods.hydrolic = GetVehicleMod(veh, 38)
    currentData.mods.engineBlock = GetVehicleMod(veh, 39)
    currentData.mods.airFilter = GetVehicleMod(veh, 40)
    currentData.mods.struts = GetVehicleMod(veh, 41)
    currentData.mods.archCover = GetVehicleMod(veh, 42)
    currentData.mods.aerials = GetVehicleMod(veh, 43)
    currentData.mods.trimB = GetVehicleMod(veh, 44)
    currentData.mods.tank = GetVehicleMod(veh, 45)
    currentData.mods.windows = GetVehicleMod(veh, 46)
    --currentData.mods.wheelCategory = GetVehicleWheelType(veh)

    -- GATHER VEHICLE'S EXTRAS
    local extras = {}
    for i = 1, 30 do
        if DoesExtraExist(veh, i) then
            if IsVehicleExtraTurnedOn(veh, i) then
                extras[i] = 1
            else
                extras[i] = 0
            end
        end
    end
    currentData.extras = extras

    -- GATHER VEHICLE PAINT DATA
    local paint = {}
    local primary, secondary = GetVehicleColours(veh)
    local pearlescent, wheelColor = GetVehicleExtraColours(veh)
    local dashboardColor, interiorColor = GetVehicleDashboardColor(veh), GetVehicleInteriorColor(veh)
    local smokeColor = table.pack(GetVehicleTyreSmokeColor(veh))

    paint.primary = primary
    paint.wheel = wheelColor
    paint.secondary = secondary
    paint.pearlescent = pearlescent
    paint.tiresmoke = smokeColor
    paint.dashboardColor = dashboardColor
    paint.interiorColor = interiorColor
    currentData.paint = paint

    -- GATHER VEHICLE TOGGLES DATA
    local toggles = {}
    toggles.neons = toggleNeons
    toggles.turbo = IsToggleModOn(veh, 18)
    toggles.xenon = IsToggleModOn(veh, 22)
    toggles.customTires = GetVehicleModVariation(veh, 23)
    currentData.toggles = toggles
    return json.encode(currentData)
end

-- LOADS VEHICLE PAINT AND MODIFICATIONS
function LoadVehicleMods(veh, data)
    local modData
    -- DATA IS JSON, OTHERWISE DIRECTLY USE AS TABLE
    if (type(data) == "string") then
        modData = json.decode(data)
    else
        modData = data
    end
    SetVehicleModKit(veh, 0)

    -- SET EXTRAS FROM DATA
    if (modData["extras"] ~= nil) then
        for i, extra in pairs(modData["extras"]) do
            local set = false
            if (extra == 1) then
                set = false
            else
                set = true
            end
            SetVehicleExtra(veh, tonumber(i), set)
        end
    end

    -- SET MODS FROM DATA // START
    if (modData["mods"] ~= nil) then
        if (modData["mods"].livery ~= nil) then
            SetVehicleMod(veh, 48, modData["mods"].livery, false)
        end

        if (modData["mods"].livery2 ~= nil) then
            SetVehicleLivery(veh, modData["mods"].livery2)
        end

        if (modData["mods"].tint ~= nil) then
            SetVehicleWindowTint(veh, modData["mods"].tint)
        end

        if (modData["mods"].plateType ~= nil) then
            SetVehicleNumberPlateTextIndex(veh, modData["mods"].plateType)
        end

        if (modData["mods"].spoiler ~= nil) then
            SetVehicleMod(veh, 0, modData["mods"].spoiler, false)
        end

        if (modData["mods"].frontBumper ~= nil) then
            SetVehicleMod(veh, 1, modData["mods"].frontBumper, false)
        end

        if (modData["mods"].rearBumper ~= nil) then
            SetVehicleMod(veh, 2, modData["mods"].rearBumper, false)
        end

        if (modData["mods"].sideSkirts ~= nil) then
            SetVehicleMod(veh, 3, modData["mods"].sideSkirts, false)
        end

        if (modData["mods"].exhaust ~= nil) then
            SetVehicleMod(veh, 4, modData["mods"].exhaust, false)
        end

        if (modData["mods"].frame ~= nil) then
            SetVehicleMod(veh, 5, modData["mods"].frame, false)
        end

        if (modData["mods"].grille ~= nil) then
            SetVehicleMod(veh, 6, modData["mods"].grille, false)
        end

        if (modData["mods"].hood ~= nil) then
            SetVehicleMod(veh, 7, modData["mods"].hood, false)
        end

        if (modData["mods"].fender ~= nil) then
            SetVehicleMod(veh, 8, modData["mods"].fender, false)
        end

        if (modData["mods"].rightFender ~= nil) then
            SetVehicleMod(veh, 9, modData["mods"].rightFender, false)
        end

        if (modData["mods"].roof ~= nil) then
            SetVehicleMod(veh, 10, modData["mods"].roof, false)
        end

        if (modData["mods"].engine ~= nil) then
            SetVehicleMod(veh, 11, modData["mods"].engine, false)
        end

        if (modData["mods"].brakes ~= nil) then
            SetVehicleMod(veh, 12, modData["mods"].brakes, false)
        end

        if (modData["mods"].transmission ~= nil) then
            SetVehicleMod(veh, 13, modData["mods"].transmission, false)
        end

        if (modData["mods"].horn ~= nil) then
            SetVehicleMod(veh, 14, modData["mods"].horn, false)
        end

        if (modData["mods"].suspension ~= nil) then
            SetVehicleMod(veh, 15, modData["mods"].suspension, false)
        end

        if (modData["mods"].armor ~= nil) then
            SetVehicleMod(veh, 16, modData["mods"].armor, false)
        end

        if (modData["mods"].frontWheel ~= nil) then
            SetVehicleMod(veh, 23, modData["mods"].frontWheel, false)
        end

        if (modData["mods"].rearWheel ~= nil) then
            SetVehicleMod(veh, 24, modData["mods"].rearWheel, false)
        end

        if (modData["mods"].plateHolder ~= nil) then
            SetVehicleMod(veh, 25, modData["mods"].plateHolder, false)
        end

        if (modData["mods"].vanityPlate ~= nil) then
            SetVehicleMod(veh, 26, modData["mods"].vanityPlate, false)
        end

        if (modData["mods"].trimA ~= nil) then
            SetVehicleMod(veh, 27, modData["mods"].trimA, false)
        end

        if (modData["mods"].ornaments ~= nil) then
            SetVehicleMod(veh, 28, modData["mods"].ornaments, false)
        end

        if (modData["mods"].dashboard ~= nil) then
            SetVehicleMod(veh, 29, modData["mods"].dashboard, false)
        end

        if (modData["mods"].dial ~= nil) then
            SetVehicleMod(veh, 30, modData["mods"].dial, false)
        end

        if (modData["mods"].doorSpeaker ~= nil) then
            SetVehicleMod(veh, 31, modData["mods"].doorSpeaker, false)
        end

        if (modData["mods"].seats ~= nil) then
            SetVehicleMod(veh, 32, modData["mods"].seats, false)
        end

        if (modData["mods"].steeringWheel ~= nil) then
            SetVehicleMod(veh, 33, modData["mods"].steeringWheel, false)
        end

        if (modData["mods"].shifterLeavers ~= nil) then
            SetVehicleMod(veh, 34, modData["mods"].shifterLeavers, false)
        end

        if (modData["mods"].modPlate ~= nil) then
            SetVehicleMod(veh, 35, modData["mods"].modPlate, false)
        end

        if (modData["mods"].speakers ~= nil) then
            SetVehicleMod(veh, 36, modData["mods"].speakers, false)
        end

        if (modData["mods"].trunk ~= nil) then
            SetVehicleMod(veh, 37, modData["mods"].trunk, false)
        end

        if (modData["mods"].hydrolic ~= nil) then
            SetVehicleMod(veh, 38, modData["mods"].hydrolic, false)
        end

        if (modData["mods"].engineBlock ~= nil) then
            SetVehicleMod(veh, 39, modData["mods"].engineBlock, false)
        end

        if (modData["mods"].airFilter ~= nil) then
            SetVehicleMod(veh, 40, modData["mods"].airFilter, false)
        end

        if (modData["mods"].struts ~= nil) then
            SetVehicleMod(veh, 41, modData["mods"].struts, false)
        end

        if (modData["mods"].archCover ~= nil) then
            SetVehicleMod(veh, 42, modData["mods"].archCover, false)
        end

        if (modData["mods"].aerials ~= nil) then
            SetVehicleMod(veh, 43, modData["mods"].aerials, false)
        end

        if (modData["mods"].trimB ~= nil) then
            SetVehicleMod(veh, 44, modData["mods"].trimB, false)
        end

        if (modData["mods"].tank ~= nil) then
            SetVehicleMod(veh, 45, modData["mods"].tank, false)
        end

        if (modData["mods"].windows ~= nil) then
            SetVehicleMod(veh, 46, modData["mods"].windows, false)
        end

        --[[if (modData["mods"].wheelCategory ~= nil) then
            SetVehicleWheelType(veh, modData["mods"].wheelCategory)
        end]]
    end
    -- SET MODS FROM DATA // END

    -- SET PAINT FROM DATA
    if (modData["paint"] ~= nil) then
        SetVehicleColours(veh, modData["paint"].primary, modData["paint"].secondary)
        SetVehicleExtraColours(veh, modData["paint"].pearlescent, modData["paint"].wheel)
        if (modData["paint"].dashboardColor ~= nil) then
            SetVehicleDashboardColor(veh, modData["paint"].dashboardColor)
        end

        if (modData["paint"].interiorColor ~= nil) then
            SetVehicleInteriorColor(veh, modData["paint"].interiorColor)
        end

        if (modData["paint"].tiresmoke ~= nil) then
            SetVehicleTyreSmokeColor(veh, modData["paint"].tiresmoke[1], modData["paint"].tiresmoke[2], modData["paint"].tiresmoke[3])
        end
    end

    -- SET TOGGLES FROM DATA
    if (modData["toggles"] ~= nil) then
        if (modData["toggles"].turbo ~= nil) then
            ToggleVehicleMod(veh, 18, modData["toggles"].turbo)
        end

        if (modData["toggles"].xenon ~= nil) then
            ToggleVehicleMod(veh, 22, modData["toggles"].xenon)
        end

        if (modData["toggles"].customTires ~= nil and modData["toggles"].customTires) then
            SetVehicleMod(veh, 23, modData["mods"].frontWheel, true)
            SetVehicleMod(veh, 24, modData["mods"].rearWheel or modData["mods"].frontWheel, true)
        end

        if (modData["toggles"].neons ~= nil) then
            if modData["toggles"].neons then
                toggleNeons = true
            else
                toggleNeons = false
            end
        end
    end
end

-- ON MENU CLOSED, UNFREEZE AND RESET VEHICLE MODS TO WHAT THEY WERE BEFORE
vehMenuMain:On('close', function(menu)
    FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), false)
    if exports["soe-utils"]:GetTableSize(myModifications) > 0 then
        LoadVehicleMods(GetVehiclePedIsIn(PlayerPedId()), originalModifications or {})
    end

    isMenuOpen = false
    myModifications = {}
    toggleNeons = nil
end)

-- ***********************
--         Events
-- ***********************
-- INTERACT KEY - CHANGE TO F2 MENU IN THE FUTURE
AddEventHandler("Utils:Client:InteractionKey", function()
    -- MENU ALREADY OPEN
    if isMenuOpen or isLoading then return end

    local pos = GetEntityCoords(PlayerPedId())
    for _, shop in pairs(modShops) do
        if #(pos - shop.pos) <= 3.5 then
            OpenModshopMenu(IsPedInAnyVehicle(PlayerPedId(), false), shop.canCustomize, shop)
            return
        end
    end
end)
