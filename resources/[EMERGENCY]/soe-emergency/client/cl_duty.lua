local menuV = assert(MenuV)
local copCount, emtCount = 0, 0

-- DUTY VARIABLES
local dutyMenu = menuV:CreateMenu("Duty", "Lets save lives! Or put people in jail!", "topright", 28, 71, 140, "size-100", "default", "menuv", "dutyMenu", "native")

-- SERVICE VEHICLE VARIABLES
local awaitVeh
local spawning, selectedVehicle = false, false
local vehHeading = GetGameplayCamRot(2) + 90.0
local svMenu = menuV:CreateMenu("Motor Pool", "Lets go go go.", "topright", 28, 71, 140, "size-100", "default", "menuv", "svMenu", "native")

-- BLIP TRACKER VARIABLES
local blipList = {}

-- ***********************
--     Local Functions
-- ***********************
-- REMOVES GHOST PREVIEW
local function RemoveGhost(_ghost)
    local ghost = _ghost
    SetEntityAsMissionEntity(ghost, true, true)
    DeleteVehicle(ghost)
    awaitVeh = nil
end

-- OPENS DUTY MENU
local function OpenDutyMenu()
    -- CLEAR MENU IF ALREADY EXISTS
    dutyMenu:ClearItems()

    local civType = exports["soe-uchuu"]:GetPlayer().CivType
    local isOnDuty = (exports["soe-jobs"]:GetMyJob() == civType)
    local dutyToggle = dutyMenu:AddCheckbox({icon = "💼", label = "Toggle Duty:", description = "", value = isOnDuty, disabled = false});
    dutyToggle:On("check", function()
        menuV:CloseAll()
        TriggerServerEvent("Jobs:Server:ToggleDuty", {status = true, dutyStatus = true, job = civType})
    end)

    dutyToggle:On("uncheck", function()
        menuV:CloseAll()
        TriggerServerEvent("Jobs:Server:ToggleDuty", {status = true, dutyStatus = false, job = civType})
    end)

    if (civType ~= "GOV") then
        local dutyList = exports["soe-nexus"]:TriggerServerCallback("Jobs:Server:GetDutyMembers") or {}
        local membersSubmenu = menuV:InheritMenu(dutyMenu, {["title"] = "Duty Roster", ["subtitle"] = "Current active members of Emergency Services"})
        dutyMenu:AddButton({icon = "🧍", label = "Active Members", value = membersSubmenu})

        for _, member in pairs(dutyList) do
            local thisMember = membersSubmenu:AddButton({icon = "🟢", label = member})
            Wait(3)
        end

        local uniformButton = dutyMenu:AddButton({icon = "👕", label = "Uniforms", select = function()
            menuV:CloseAll()
            exports["soe-appearance"]:OpenAppearanceMenu("dutyclothing", "Duty", "Gotta look good to do your job.", false, false)
        end})
    end

    dutyMenu:Open()
end

-- ON MENU CLOSED
dutyMenu:On("close", function(menu)
    collectgarbage("collect")
end)

-- CREATES GHOST VEHICLE PREVIEW
local function CreateGhostVeh(model, pos)
    local timeout = 0
    local hash = GetHashKey(model)

    --exports["soe-utils"]:LoadModel(model, 15)
    if not HasModelLoaded(hash) and IsModelInCdimage(hash) then
        RequestModel(hash)
        while not HasModelLoaded(hash) and (timeout < 2500) do
            Wait(15)
            timeout = timeout + 1
            print("REQUESTING THE MODEL TO STOP LOCKOUTS (IF THIS GOES BEYOND 2500 | REPORT IT!!): " .. timeout)
        end
    end

    if (timeout >= 2500) then
        print("I HAVE DETECTED A LOCKOUT, STOPPING THE CRASH.")
        exports["soe-ui"]:SendAlert("error", "Spawn issue detected! Terminating vehicle spawning to prevent lockout!", 4000)
        selectedVehicle = false
        awaitVeh = nil
        return nil
    end

    local ped = PlayerPedId()
    local hdg = GetEntityHeading(ped)
    local veh = CreateVehicle(hash, pos, hdg, false, true)

    SetEntityInvincible(veh, true)
    SetVehicleDirtLevel(veh, 0.0)
    SetModelAsNoLongerNeeded(hash)
    SetEntityCollision(veh, false, false)
    SetEntityAsMissionEntity(veh, true, true)
    SetEntityAlpha(veh, 100, 1)
    return veh
end

local function SpawnServiceVehicle(hash)
    selectedVehicle = true
    if not spawning then
        spawning = true
        DeleteEntity(awaitVeh)
        Wait(100)
        spawning = false
        awaitVeh = CreateGhostVeh(hash, ray)
    end

    while selectedVehicle do
        Wait(3)
        local ray = exports["soe-utils"]:GhostRaycast(100)
        DisableControlAction(0, 44)
        DisableControlAction(0, 51)
        DisableControlAction(0, 24)
        DisableControlAction(0, 200)
        DisableControlAction(0, 201)

        if (awaitVeh ~= nil) then
            if (GetEntityModel(awaitVeh) ~= GetHashKey(hash)) then
                RemoveGhost(awaitVeh)
            end
            SetEntityCoords(awaitVeh, ray)
            SetEntityHeading(awaitVeh, vehHeading)

            -- HEADING ADJUSTMENT KEY
            if IsDisabledControlPressed(0, 44) then
                vehHeading = vehHeading - 1.0
            elseif IsDisabledControlPressed(0, 51) then
                vehHeading = vehHeading + 1.0
            end

            -- CANCEL SPAWNING KEY
            if IsDisabledControlPressed(0, 200) then
                RemoveGhost(awaitVeh)
                selectedVehicle = false
                break
            end

            -- SPAWN VEHICLE KEY
            if IsDisabledControlPressed(0, 201) then
                RemoveGhost(awaitVeh)
                selectedVehicle = false

                -- SPAWN VEHICLE
                local ray = exports["soe-utils"]:GhostRaycast(100)
                local veh = exports["soe-utils"]:SpawnVehicle(hash, vector4(ray, vehHeading.x))

                -- ALT
                --TriggerEvent('persistent-vehicles/register-vehicle', veh)

                -- CREATE A LICENSE PLATE FOR THIS VEHICLE
                local plate = exports["soe-utils"]:GenerateRandomPlate()
                SetVehicleNumberPlateText(veh, plate)
                Wait(500)

                -- GIVE THE PLAYER KEYS
                exports["soe-valet"]:UpdateKeys(veh)

                -- SET THE VEHICLE AS A RENTAL
                exports["soe-utils"]:SetRentalStatus(veh)
                DecorSetBool(veh, "noInventoryLoot", true)

                Wait(350)
                -- SET SOME MODIFICATIONS FOR SOME VEHICLES
                if (hash == "riot") then
                    SetVehicleTyresCanBurst(veh, false)
                end

                if (hash == "bcsof150" or hash == "saspf150") then
                    ToggleVehicleMod(veh, 22, true)
                end

                -- SET EMERGENCY TRACKER BLIP
                if (hash ~= "boattrailer") then
                    exports["soe-nexus"]:TriggerServerCallback("Emergency:Server:SyncESBlips", VehToNet(veh), GetVehicleClass(veh))
                end
                break
            end
        else
            print("Spawn issue? Try again? Debugging this to see if we can solve lockouts. - Ghost")
            selectedVehicle = false
        end
    end
end

-- CREATES SV MENU
local function OpenSVMenu()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    local isDriver = (GetPedInVehicleSeat(veh, -1) == ped)

    -- CLEAR MENU IF ALREADY EXISTS
    svMenu:ClearItems()

    if IsPedInAnyVehicle(ped, false) and isDriver then
        -- MAKE SURE VEHICLE IS REPAIRED FIRST BEFORE CUSTOMIZING
        if (GetVehicleBodyHealth(veh) < 1000.0 or GetVehicleEngineHealth(veh) < 1000.0) then
            exports["soe-ui"]:SendAlert("error", "Vehicle must be fully repaired first", 2500)
            return
        end

        -- ***********************
        --      SV PRESETS
        -- ***********************
        svMenu:SetTitle("Service Vehicle")
        svMenu:SetSubtitle("Select options.")

        -- REQUEST SV PRESETS FROM DATABASE
        SetVehicleModKit(veh, 0)
        local hash = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
        local presets = exports["soe-nexus"]:TriggerServerCallback("Emergency:Server:RequestSVPresets", hash)

        local presetList = menuV:InheritMenu(svMenu, {["title"] = "Presets", ["subtitle"] = "Choose a preset."})
        svMenu:AddButton({icon = "🚙", label = "Presets", value = presetList})

        local customizationMenu = menuV:InheritMenu(svMenu, {["title"] = "Customization", ["subtitle"] = "Make your vehicle look pretty."})
        svMenu:AddButton({icon = "🔧", label = "Customization", value = customizationMenu})

        presetList:AddButton({icon = "✏️", label = "Create A New Preset", select = function()
            exports["soe-input"]:OpenInputDialogue("name", "Enter a name for the new preset:", function(returnData)
                if (returnData ~= nil) then
                    menuV:CloseAll()
                    local mods = exports["soe-shops"]:GetModDataFromVehicle(veh, false)
                    TriggerServerEvent("Emergency:Server:SaveSVPreset", hash, returnData, mods)
                end
            end)
        end})

        if #presets >= 1 then
            for _, preset in pairs(presets) do
                local thisPreset = menuV:InheritMenu(svMenu, {["title"] = preset.PresetName, ["subtitle"] = "Load or modify " .. preset.PresetName})
                presetList:AddButton({icon = "", label = preset.PresetName, value = thisPreset})

                thisPreset:AddButton({icon = "♻️", label = "Load Preset", select = function()
                    local fuel = exports["soe-fuel"]:GetFuel(veh)
                    exports["soe-shops"]:LoadVehicleMods(veh, preset.VehCustomizations)
                    Wait(100)
                    exports["soe-fuel"]:SetFuel(veh, fuel)
                end})

                thisPreset:AddButton({icon = "❌", label = "Delete Preset", select = function()
                    exports["soe-input"]:OpenConfirmDialogue("Are you sure you want to delete this preset?", "Yes", "No", function(returnData)
                        if returnData then
                            menuV:CloseAll()
                            TriggerServerEvent("Emergency:Server:DeleteSVPreset", preset.PresetID)
                        end
                    end)
                end})

                thisPreset:AddButton({icon = "🏷️", label = "Rename Preset", select = function()
                    exports["soe-input"]:OpenInputDialogue("name", "Enter a new name for this preset:", function(returnData)
                        if (returnData ~= nil) then
                            menuV:CloseAll()
                            TriggerServerEvent("Emergency:Server:UpdateSVPreset", preset.PresetID, returnData, "Rename")
                        end
                    end)
                end})

                thisPreset:AddButton({icon = "📝", label = "Overwrite Preset", select = function()
                    exports["soe-input"]:OpenConfirmDialogue("Are you sure you want to overwrite this preset?", "Yes", "No", function(returnData)
                        if returnData then
                            menuV:CloseAll()
                            local mods = exports["soe-shops"]:GetModDataFromVehicle(veh, false)
                            TriggerServerEvent("Emergency:Server:UpdateSVPreset", preset.PresetID, mods, "Overwrite")
                        end
                    end)
                end})
            end
        end

        -- ***********************
        --    SV CUSTOMIZATION
        -- ***********************
        local paintLabel = customizationMenu:AddButton({label = "PAINT OPTIONS", disabled = true})

        local liverySlider = customizationMenu:AddSlider({icon = '🎨', label = "Livery", values = exports["soe-shops"]:GenerateSliderValues(1, GetVehicleLiveryCount(veh))})
        liverySlider.Value = GetVehicleLivery(veh) + 1
        liverySlider:On("change", function(item, newValue, oldValue)
            if GetVehicleLivery(veh) ~= (newValue - 1) then
                SetVehicleLivery(veh, newValue - 1)
            end
        end)

        local paintCodeEntry = customizationMenu:AddButton({ icon = '🎨', label = "Modify Primary Color (By Code)", select = function()
            exports["soe-input"]:OpenInputDialogue("number", "Enter a valid primary color code:", function(returnData)
                if not tonumber(returnData) then
                    exports["soe-ui"]:SendAlert("error", "Invalid code entered!", 5000)
                    return
                end

                local _, color2 = GetVehicleColours(veh)
                SetVehicleColours(veh, tonumber(returnData), color2)
            end)
        end})

        local paintCodeEntry2 = customizationMenu:AddButton({ icon = '🎨', label = "Modify Secondary Color (By Code)", select = function()
            exports["soe-input"]:OpenInputDialogue("number", "Enter a valid secondary color code:", function(returnData)
                if not tonumber(returnData) then
                    exports["soe-ui"]:SendAlert("error", "Invalid code entered!", 5000)
                    return
                end

                local color1 = GetVehicleColours(veh)
                SetVehicleColours(veh, color1, tonumber(returnData))
            end)
        end})

        local paintCodeEntry3 = customizationMenu:AddButton({ icon = '🎨', label = "Modify Pearlescent Color (By Code)", select = function()
            exports["soe-input"]:OpenInputDialogue("number", "Enter a valid pearlescent color code:", function(returnData)
                if not tonumber(returnData) then
                    exports["soe-ui"]:SendAlert("error", "Invalid code entered!", 5000)
                    return
                end

                local _, color2 = GetVehicleExtraColours(veh)
                SetVehicleExtraColours(veh, tonumber(returnData), color2)
            end)
        end})

        local paintCodeEntry4 = customizationMenu:AddButton({ icon = '🎨', label = "Modify Wheel Color (By Code)", select = function()
            exports["soe-input"]:OpenInputDialogue("number", "Enter a valid wheel color code:", function(returnData)
                if not tonumber(returnData) then
                    exports["soe-ui"]:SendAlert("error", "Invalid code entered!", 5000)
                    return
                end

                local color1 = GetVehicleExtraColours(veh)
                SetVehicleExtraColours(veh, color1, tonumber(returnData))
            end)
        end})

        local paintSlider = customizationMenu:AddSlider({icon = '🎨', label = "Primary", values = exports["soe-shops"]:GenerateSliderValues(111, 160)})
        local paint2Slider = customizationMenu:AddSlider({icon = '🎨', label = "Secondary", values = exports["soe-shops"]:GenerateSliderValues(111, 160)})
        local paint3Slider = customizationMenu:AddSlider({icon = '🎨', label = "Pearlescent", values = exports["soe-shops"]:GenerateSliderValues(111, 160)})
        local paint4Slider = customizationMenu:AddSlider({icon = '🎨', label = "Wheel", values = exports["soe-shops"]:GenerateSliderValues(111, 160)})

        paintSlider.Value, paint2Slider.Value = GetVehicleColours(veh)
        paintSlider.Value, paint2Slider.Value = paintSlider.Value + 1, paint2Slider.Value + 1

        paint3Slider.Value, paint4Slider.Value = GetVehicleExtraColours(veh)
        paint3Slider.Value, paint4Slider.Value = paint3Slider.Value + 1, paint4Slider.Value + 1

        -- PRIMARY SLIDER
        paintSlider:On('change', function(item, newValue, oldValue)
            local color1, color2 = GetVehicleColours(veh)
            SetVehicleColours(veh, newValue, color2)
        end)

        -- SECONDARY SLIDER
        paint2Slider:On('change', function(item, newValue, oldValue)
            local color1, color2 = GetVehicleColours(veh)
            SetVehicleColours(veh, color1, newValue)
        end)

        -- PEARL SLIDER
        paint3Slider:On('change', function(item, newValue, oldValue)
            local color1, color2 = GetVehicleExtraColours(veh)
            SetVehicleExtraColours(veh, newValue, color2)
        end)

        -- WHEEL COLOR SLIDER
        paint4Slider:On('change', function(item, newValue, oldValue)
            local color1, color2 = GetVehicleExtraColours(veh)
            SetVehicleExtraColours(veh, color1, newValue)
        end)

        -- MISC OPTIONS
        local miscLabel = customizationMenu:AddButton({label = "MISC. OPTIONS", disabled = true})
        local tintSlider = customizationMenu:AddSlider({icon = '⬛', label = "Window Tint", values = exports["soe-shops"]:GenerateSliderValues(110, 5)})

        -- TINT SLIDER
        tintSlider.Value = GetVehicleWindowTint(veh) + 1
        tintSlider:On("change", function(item, newValue, oldValue)
            SetVehicleWindowTint(veh, newValue)
        end)

        -- WHEEL OPTIONS
        local wheelLabel = customizationMenu:AddButton({label = "WHEEL OPTIONS", disabled = true})
        local wheelSlider = customizationMenu:AddSlider({icon = "⚙️", label = "Modify Wheels", values = exports["soe-shops"]:GenerateSliderValues(23, GetNumVehicleMods(veh, 23))})
        wheelSlider.Value = GetVehicleMod(veh, 23) + 2

        -- MAIN WHEEL SLIDER
        wheelSlider:On("change", function(item, newValue, oldValue)
            if GetVehicleMod(veh, 23) ~= (newValue - 1) then
                SetVehicleMod(veh, 23, newValue - 1)
            end
        end)

        -- ADD ALL EXTRA OPTIONS
        local extraLabel = customizationMenu:AddButton({label = "EXTRA OPTIONS", disabled = true})
        for indexA = 0, 25 do
            if DoesExtraExist(veh, indexA) then
                local extraToggle = customizationMenu:AddConfirm({icon = "🔧", label = "Extra " .. indexA})
                extraToggle.Value = IsVehicleExtraTurnedOn(veh, indexA)

                -- TOGGLE CHANGED EVENT
                extraToggle:On("change", function(item, newValue)
                    if newValue then
                        SetVehicleExtra(veh, indexA, 0)
                    else
                        SetVehicleExtra(veh, indexA, 1)
                    end
                end)

                -- NEEDED WAIT TO MAKE SURE NOTHING IS MIXED
                Wait(10)
            end
        end

        svMenu:Open()
    else
        -- ***********************
        --        SV LIST
        -- ***********************
        svMenu:SetTitle("Motor Pool")
        svMenu:SetSubtitle("Lets go go go.")

        local char = exports["soe-uchuu"]:GetPlayer()
        if (char.CivType == "POLICE") then
            if (char.Employer == "LSPD") then
                for _, sv in pairs(lspdMotorPool) do
                    svMenu:AddButton({icon = "", label = sv.model, select = function()
                        menuV:CloseAll()
                        SpawnServiceVehicle(sv.hash)
                    end})
                end
            elseif (char.Employer == "BCSO") then
                for _, sv in pairs(bcsoMotorPool) do
                    svMenu:AddButton({icon = "", label = sv.model, select = function()
                        menuV:CloseAll()
                        SpawnServiceVehicle(sv.hash)
                    end})
                end
            elseif (char.Employer == "SAES") then
                for _, sv in pairs(bcsoMotorPool) do
                    svMenu:AddButton({icon = "", label = sv.model, select = function()
                        menuV:CloseAll()
                        SpawnServiceVehicle(sv.hash)
                    end})
                end
            elseif (char.Employer == "SASP") then
                for _, sv in pairs(saspMotorPool) do
                    svMenu:AddButton({icon = "", label = sv.model, select = function()
                        menuV:CloseAll()
                        SpawnServiceVehicle(sv.hash)
                    end})
                end
            end

            for _, sv in pairs(globalMotorPool) do
                svMenu:AddButton({icon = "", label = sv.model, select = function()
                    menuV:CloseAll()
                    SpawnServiceVehicle(sv.hash)
                end})
            end

            -- IF PLAYER IS WHITELISTED IN UNDERCOVER VEHICLE MOTOR POOL (EXPERIMENT)
            if undercoverWhitelist[tonumber(char.CharID)] then
                local umvMotorPoolLabel = svMenu:AddButton({label = "UNDERCOVER MOTOR POOL", disabled = true})
                for _, sv in pairs(undercoverMotorPool) do
                    svMenu:AddButton({icon = "", label = sv.model, select = function()
                        menuV:CloseAll()
                        SpawnServiceVehicle(sv.hash)
                    end})
                end
            end
        elseif (char.CivType == "EMS") then
            for _, sv in pairs(safrMotorPool) do
                svMenu:AddButton({icon = "", label = sv.model, select = function()
                    menuV:CloseAll()
                    SpawnServiceVehicle(sv.hash)
                end})
            end
        elseif (char.CivType == "CRIMELAB") then
            for _, sv in pairs(crimelabMotorPool) do
                svMenu:AddButton({icon = "", label = sv.model, select = function()
                    menuV:CloseAll()
                    SpawnServiceVehicle(sv.hash)
                end})
            end
        end

        svMenu:Open()
    end
end

-- ON MENU CLOSED
svMenu:On("close", function(menu)
    collectgarbage("collect")
end)

-- ***********************
--    Global Functions
-- ***********************
-- RETURN AMOUNT OF COPS ON DUTY
function GetCurrentCops()
    return copCount
end

-- RETURN AMOUNT OF EMS ON DUTY
function GetCurrentEMS()
    return emtCount
end

-- ***********************
--         Events
-- ***********************
-- CALLED FROM SERVER AFTER "/sv" IS EXECUTED
RegisterNetEvent("Emergency:Client:SVMenu", OpenSVMenu)

-- CALLED FROM SERVER AFTER "/duty" IS EXECUTED
RegisterNetEvent("Emergency:Client:DutyMenu", OpenDutyMenu)

-- RECEIVES AMOUNT OF COPS/EMS ON DUTY FROM SERVER
RegisterNetEvent("Emergency:Client:UpdateCounter")
AddEventHandler("Emergency:Client:UpdateCounter", function(emsVal, copVal)
    emtCount, copCount = emsVal, copVal
end)

-- WHEN TRIGGERED, DELETE ALL TRACKER BLIPS AS PERSON HAS GONE OFF DUTY
RegisterNetEvent("Jobs:Client:ToggleDuty", function(type, active)
    if not active then
        SetThisScriptCanRemoveBlipsCreatedByAnyScript(true)

        for _, blip in pairs(blipList) do
            while DoesBlipExist(blip) do
                RemoveBlip(blip)
                Wait(100)
            end
        end
        blipList = {}
    end
end)

-- WHEN TRIGGERED, SYNC UP TRACKER BLIPS WITH WHAT THE SERVER GIVES
RegisterNetEvent("Emergency:Client:SyncESBlips", function(blipTracker)
    for trackerPlate, tracker in pairs(blipTracker) do
        if blipList[trackerPlate] and tracker.delete then
            RemoveBlip(blipList[trackerPlate])
            blipList[trackerPlate] = nil
        elseif blipList[trackerPlate] and not tracker.delete then
            SetBlipCoords(blipList[trackerPlate], tracker.pos)
            SetBlipRotation(blipList[trackerPlate], tracker.hdg)
        elseif not blipList[trackerPlate] and not tracker.delete then
            local blip = AddBlipForCoord(tracker.pos)

            -- SET BLIP PROPERTIES
            SetBlipSprite(blip, tracker.sprite)
            SetBlipScale(blip, 1.14)
            SetBlipColour(blip, tracker.color)
        
            SetBlipRotation(blip, tracker.hdg)
            ShowHeadingIndicatorOnBlip(blip, true)
        
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(tracker.name)
            EndTextCommandSetBlipName(blip)
            blipList[trackerPlate] = blip
        end
    end
end)
