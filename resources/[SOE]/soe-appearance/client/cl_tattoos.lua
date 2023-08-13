local action
local tattoo = {}
local selectedTattoos = {}
local menuV = assert(MenuV)
local tattooMenu = menuV:CreateMenu("Tattoos", "Lets ink it up!", "topright", 104, 0, 122, "size-125", "default", "menuv", "tattooMenu", "default")

myTattoos = {}

-- ***********************
--    Local Functions
-- ***********************
-- WHEN TRIGGERED, OPENS TATTOO MENU
local function OpenTattooMenu(target, targetTats, targetGender)
    if tattoo.isMenuOpen then return end
    local ped = PlayerPedId()

    -- CLEAR MENU IF ALREADY EXISTS
    tattooMenu:ClearItems()
    if (targetTats or targetTats == "None") then
        tattoo.target = target
        tattoo.editingOthers = true

        if (targetTats == "None") then
            selectedTattoos = {}
        else
            selectedTattoos = targetTats
        end
        tattooMenu:SetSubtitle("Lets ink this person up!")
    else
        selectedTattoos = myTattoos
        tattooMenu:SetSubtitle("Lets ink it up!")
        if (GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then
            SetPedComponentVariation(ped, 11, 15, 0, 1)
            SetPedComponentVariation(ped, 4, 14, 0, 1)
            SetPedComponentVariation(ped, 3, 15, 0, 1)
            SetPedComponentVariation(ped, 8, 15, 0, 1)
        elseif (GetEntityModel(ped) == GetHashKey("mp_f_freemode_01")) then
            SetPedComponentVariation(ped, 11, 15, 0, 1)
            SetPedComponentVariation(ped, 4, 56, 0, 1)
            SetPedComponentVariation(ped, 3, 15, 0, 1)
            SetPedComponentVariation(ped, 8, 15, 0, 1)
        end
    end

    local categoryMenu = menuV:InheritMenu(tattooMenu, {["title"] = "Categories", ["subtitle"] = "Choose a tattoo category"})
    tattooMenu:AddButton({icon = "🎨", label = "Categories", value = categoryMenu})

    local confirmButton = tattooMenu:AddButton({icon = "✔️", label = "Save & Exit", select = function()
        --[[if (next(selectedTattoos) == nil) then
            menuV:CloseAll()
            exports["soe-ui"]:SendAlert("error", "Select some tattoos first!", 5000)
            return
        end]]

        if tattoo.editingOthers then
            TriggerServerEvent("Appearance:Server:CloseTattooMenu", {status = true, purchased = true, tattoos = selectedTattoos, serverID = tattoo.target})

            menuV:CloseAll()
            selectedTattoos = {}
            tattoo.isMenuOpen = false
            tattoo.target = nil
        else
            local payment = exports["soe-shops"]:NewTransaction(500, "Tattoo Job")
            if payment then
                myTattoos = selectedTattoos
                SaveTattoos(myTattoos)
    
                menuV:CloseAll()
                selectedTattoos = {}
                tattoo.isMenuOpen = false
            end
        end
    end})

    local clearAllButton = tattooMenu:AddButton({icon = "❌", label = "Clear All Tattoos", select = function()
        exports["soe-input"]:OpenConfirmDialogue("Are you sure you want to clear all the tattoos?", "Clear Them", "Keep Them", function(returnData)
            if returnData then
                selectedTattoos = {}
                if tattoo.editingOthers then
                    TriggerServerEvent("Appearance:Server:SyncTattoo", {status = true, clearall = true, serverID = target})
                else
                    ClearPedDecorations(ped)
                end
            end
        end)
    end})

    local myGender = GetGender(ped)
    if targetGender then
        myGender = targetGender
    end

    exports["soe-ui"]:SendAlert("inform", "Loading tattoos menu...", 7000)
    local defaultTattooChecks = selectedTattoos
    for categoryID in pairs(tattoos) do
        local thisCategory = menuV:InheritMenu(tattooMenu, {["title"] = tattoos[categoryID].name, ["subtitle"] = "Start looking through!"})
        categoryMenu:AddButton({icon = "", label = tattoos[categoryID].name, value = thisCategory})

        for tattooID, tattooData in pairs(tattoos[categoryID][tostring(myGender)]) do
            if (defaultTattooChecks[tattooData.zone] == nil) then
                defaultTattooChecks[tattooData.zone] = {}
            end

            if (defaultTattooChecks[tattooData.zone][categoryID] == nil) then
                defaultTattooChecks[tattooData.zone][categoryID] = {}
            end

            local isTattooed = false
            if (defaultTattooChecks[tattooData.zone][categoryID][tattooID] ~= nil) then
                isTattooed = true
            end

            local thisItem = thisCategory:AddConfirm({icon = "", label = tattooData.name})
            thisItem.Value = isTattooed

            thisItem:On("change", function(item, newValue)
                if newValue then
                    if (selectedTattoos[tattooData.zone] == nil) then
                        selectedTattoos[tattooData.zone] = {}
                    end

                    if (selectedTattoos[tattooData.zone][categoryID] == nil) then
                        selectedTattoos[tattooData.zone][categoryID] = {}
                    end

                    if (selectedTattoos[tattooData.zone][categoryID][tattooID] == nil) then
                        selectedTattoos[tattooData.zone][categoryID][tattooID] = tattooID
                        if tattoo.editingOthers then
                            TriggerServerEvent("Appearance:Server:SyncTattoo", {status = true, serverID = target, delete = false, tattoos = selectedTattoos})
                        else
                            AddPedDecorationFromHashes(ped, GetHashKey(categoryID), GetHashKey(tattooID))
                        end
                    end
                else
                    if (selectedTattoos[tattooData.zone][categoryID][tattooID] ~= nil) then
                        selectedTattoos[tattooData.zone][categoryID][tattooID] = nil
                        if tattoo.editingOthers then
                            TriggerServerEvent("Appearance:Server:SyncTattoo", {status = true, serverID = target, delete = true, tattoos = selectedTattoos})
                        else
                            ClearPedDecorations(ped)
                        end

                        for _, selected in pairs(selectedTattoos) do
                            for overlayID, overlayTattoos in pairs(selected) do
                                for tattooHash in pairs(overlayTattoos) do
                                    if not tattoo.editingOthers then
                                        AddPedDecorationFromHashes(ped, GetHashKey(overlayID), GetHashKey(tattooHash))
                                    end
                                end
                            end
                        end
                    end
                end
                Wait(1)
            end)
            Wait(3)
        end
    end

    tattooMenu:Open()
    tattoo.isMenuOpen = true
    exports["soe-ui"]:HideTooltip()
end

-- ON MENU CLOSED
tattooMenu:On("close", function(menu)
    selectedTattoos = {}
    tattoo.isMenuOpen = false
    if tattoo.editingOthers then
        TriggerServerEvent("Appearance:Server:CloseTattooMenu", {status = true, purchased = false, serverID = tattoo.target})
        tattoo.target = nil
        tattoo.editingOthers = false
        return
    end

    LoadPlayerAppearance()
end)

-- ***********************
--         Events
-- ***********************
-- WHEN TRIGGERED, REFRESH THIS PLAYER BECAUSE THEY FINISHED WITH TATTOOS
RegisterNetEvent("Appearance:Client:RefreshTattooTarget")
AddEventHandler("Appearance:Client:RefreshTattooTarget", function(data)
    if not data.status then return end
    LoadPlayerAppearance()
end)

-- ON ZONE ENTRANCE
AddEventHandler("Utils:Client:EnteredZone", function(name)
    if name:match("Tattoo") then
        action = {status = true}
        exports["soe-ui"]:ShowTooltip("fas fa-paint-brush", "[E] Tattoo Shop", "inform")
    end
end)

-- ON ZONE EXIT
AddEventHandler("Utils:Client:ExitedZone", function(name)
    if name:match("Tattoo") then
        action = nil
        exports["soe-ui"]:HideTooltip()
        if tattoo.isMenuOpen then
            menuV:CloseAll()
        end
    end
end)

-- ON INTERACTION KEYPRESS
AddEventHandler("Utils:Client:InteractionKey", function()
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
        return
    end
    
    if not action then return end
    if action.status then
        OpenTattooMenu(nil, nil, nil)
    end
end)

-- WHEN TRIGGERED, SYNC THE TARGET'S TATTOO PROCESS
RegisterNetEvent("Appearance:Client:SyncTattoo")
AddEventHandler("Appearance:Client:SyncTattoo", function(data)
    if not data.status then return end

    local ped = PlayerPedId()
    if data.clearall then
        ClearPedDecorations(ped)
        return
    end

    if data.delete then
        ClearPedDecorations(ped)
    end

    for _, selected in pairs(data.tattoos) do
        for overlayID, overlayTattoos in pairs(selected) do
            for tattooHash in pairs(overlayTattoos) do
                AddPedDecorationFromHashes(ped, GetHashKey(overlayID), GetHashKey(tattooHash))
            end
        end
    end
end)

-- WHEN TRIGGERED, OPEN TATTOO MENU TO CUSTOMIZE TARGET'S TATTOO
RegisterNetEvent("Appearance:Client:DoTattoosOnPlayer")
AddEventHandler("Appearance:Client:DoTattoosOnPlayer", function(data)
    if not data.status then return end
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
        return
    end

    -- ZONE CHECK
    if not action then
        exports["soe-ui"]:SendAlert("error", "You must be inside a tattoo shop", 5000)
        return
    end

    if not data.target then return end
    if not DoesEntityExist(GetPlayerPed(GetPlayerFromServerId(data.target))) then
        return
    end
    OpenTattooMenu(data.target, data.tattoos, data.gender)
end)
