local action
local isDMVMenuOpen = false
local dmvMenu = menuV:CreateMenu("DMV", "Why are you here?", "topright", 72, 168, 50, "size-125", "default", "menuv", "dmvMenu", "default")

-- **********************
--    Local Functions
-- **********************
-- PROMPTS A CONFIRMATION UI FOR TRANSFERSHIP
local function ConfirmTransfer()
    exports["soe-input"]:OpenConfirmDialogue("Do you accept this vehicle transfer? Check chat for information.", "Yes", "No", function(returnData)
        TriggerServerEvent("Shops:Server:ConfirmVehicleTransfer", {response = returnData})
    end)
end

-- WHEN TRIGGERED, FIT VEHICLE WITH NEW CUSTOM PLATE
local function ConfirmCustomPlate(data)
    if not data.status then return end
    local veh = NetToVeh(data.veh)

    SetVehicleNumberPlateText(veh, data.plate)
    Wait(1500)
    exports["soe-valet"]:UpdateKeys(veh)
end

-- OPENS DMV MENU
local function OpenDMVMenu()
    if action then
        -- CLEAR MENU IF ALREADY EXISTS
        if isDMVMenuOpen then return end
        dmvMenu:ClearItems()

        -- GENERATE SUBTITLE
        local veh = GetVehiclePedIsIn(PlayerPedId(), true)
        if (veh ~= 0) then
            local plate = GetVehicleNumberPlateText(veh)
            local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh)))

            dmvMenu:SetSubtitle(model .. " | " .. plate)
            local customPlateButton = dmvMenu:AddButton({icon = "🔢", label = "Purchase Custom Plate", select = function()
                menuV:CloseAll()
                if (veh == 0) then
                    exports["soe-ui"]:SendAlert("error", "No vehicle found! Get into the one you want to customize!", 5000)
                    return
                end

                local vin = DecorGetInt(veh, "vin")
                if (vin == 0) then
                    exports["soe-ui"]:SendAlert("error", "This vehicle ain't yours", 5000)
                    return
                end

                if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(veh)) > 25.0 then
                    exports["soe-ui"]:SendAlert("error", "Vehicle too far!", 5000)
                    return
                end

                exports["soe-input"]:OpenInputDialogue("name", "Enter license plate (MAXIMUM OF 8 CHARS) to place on your " .. model .. ":", function(returnData)
                    if (returnData == nil or returnData == "" or returnData == "        " or returnData == " " or returnData == "  " or returnData == "   ") then
                        exports["soe-ui"]:SendAlert("error", "Entry invalid!", 5000)
                        return
                    end

                    if #returnData > 8 then
                        exports["soe-ui"]:SendAlert("error", "Entry too long! Must be under or at 8 characters!", 5000)
                        return
                    end

                    -- SETUP DMV FEE
                    local fee = 4500
                    if exports["soe-config"]:GetConfigValue("economy", "dmv_fee_customplate") then
                        fee = exports["soe-config"]:GetConfigValue("economy", "dmv_fee_customplate")
                    end

                    local payment = exports["soe-shops"]:NewTransaction(fee, "DMV - Custom Plate Purchase")
                    if payment then
                        TriggerServerEvent("Shops:Server:GetCustomPlate", {status = payment, veh = VehToNet(veh), vin = vin, plate = plate, newPlate = returnData, model = model})
                    end
                end)
            end})

            local sellButton = dmvMenu:AddButton({icon = "💲", label = "Sell Vehicle", select = function()
                menuV:CloseAll()
                if (veh == 0) then
                    exports["soe-ui"]:SendAlert("error", "No vehicle found! Get into the one you want to sell!", 5000)
                    return
                end

                local vin = DecorGetInt(veh, "vin")
                if (vin == 0) then
                    exports["soe-ui"]:SendAlert("error", "This vehicle ain't yours", 5000)
                    return
                end

                exports["soe-input"]:OpenInputDialogue("number", "Enter the SSN of the person you wish to give the vehicle to:", function(returnData)
                    -- FAILSAFES
                    if not tonumber(returnData) then
                        exports["soe-ui"]:SendAlert("error", "Invalid SSN entered!", 5000)
                        return
                    end
                    if (tonumber(returnData) < 0) then return end

                    -- SETUP DMV FEE
                    local fee = 35
                    if exports["soe-config"]:GetConfigValue("economy", "dmv_fee") then
                        fee = exports["soe-config"]:GetConfigValue("economy", "dmv_fee")
                    end

                    local payment = exports["soe-shops"]:NewTransaction(fee, "DMV Vehicle Transfer")
                    if payment then
                        TriggerServerEvent("Shops:Server:SellVehicleAtDMV", {target = tonumber(returnData), vin = vin, plate = plate, model = model})
                    end
                end)
            end})
        else
            dmvMenu:SetSubtitle("Why are you here?")
            dmvMenu:AddButton({icon = "😢", label = "NO VEHICLE FOUND :("})
        end

        local reissueLicenseButton = dmvMenu:AddButton({icon = "💳", label = "Re-Issue State License", select = function()
            menuV:CloseAll()
            TriggerEvent("Gov:Client:IssueNewStateLicense")
        end})

        dmvMenu:Open()
        isDMVMenuOpen = true
    end
end

-- ON MENU CLOSED
dmvMenu:On("close", function(menu)
    isDMVMenuOpen = false
end)

-- **********************
--        Events
-- **********************
-- CONFIRMS CUSTOM PLATE PURCHASE FOR VEHICLE
RegisterNetEvent("Shops:Client:ConfirmCustomPlate")
AddEventHandler("Shops:Client:ConfirmCustomPlate", ConfirmCustomPlate)

-- CONFIRMS VEHICLE TRANSFER THROUGH UI
RegisterNetEvent("Shops:Client:ConfirmVehicleTransfer")
AddEventHandler("Shops:Client:ConfirmVehicleTransfer", ConfirmTransfer)

-- ON DMV ZONE ENTRANCE
AddEventHandler("Utils:Client:EnteredZone", function(name)
    if name:match("dmv") then
        action = {status = true}
        exports["soe-ui"]:ShowTooltip("fas fa-car", "[E] DMV", "inform")
    end
end)

-- ON DMV ZONE EXIT
AddEventHandler("Utils:Client:ExitedZone", function(name)
    if name:match("dmv") then
        action = nil
        exports["soe-ui"]:HideTooltip()
        if isDMVMenuOpen then
            menuV:CloseAll()
            isDMVMenuOpen = false
        end
    end
end)

-- ON INTERACTION KEYPRESS NEAR A DMV
AddEventHandler("Utils:Client:InteractionKey", function()
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
        return
    end

    if not action then return end
    if action.status then
        OpenDMVMenu()
    end
end)
