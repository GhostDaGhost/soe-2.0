-- VARIABLES - DO NOT MODIFY UNLESS YOU KNOW WHAT YOU'RE DOING
local range = {}
local gridItems = {}
local colorItems = {}
local opacityItems = {}
local gridsChangedThisTick = {}

local action
local lastCoords

local cam
local cameraNum = 1

local isMenuOpen = false
local pedSelected = false
local appearanceMenuPool = NativeUI.CreatePool()
local moveUp, moveDown, moveLeft, moveRight = false, false, false, false

for i = 1, 10 do
    range[i] = i
end

-- KEYBINDS
RegisterKeyMapping("+moveUp", "Move Up (Menu Grid)", "keyboard", "numpad8")
RegisterKeyMapping("+moveDown", "Move Down (Menu Grid)", "keyboard", "numpad2")
RegisterKeyMapping("+moveLeft", "Move Left (Menu Grid/Colors)", "keyboard", "numpad4")
RegisterKeyMapping("+moveRight", "Move Right (Menu Grid/Colors)", "keyboard", "numpad6")
RegisterKeyMapping("cycleappearancecams", "[Appearance] Cycle Cameras", "keyboard", "RSHIFT")

-- ***********************
--    Local Functions
-- ***********************
-- WHEN TRIGGERED, CYCLE THROUGH APPEARANCE CAMERAS
local function CycleAppearanceCamera()
    if appearanceMenuPool and appearanceMenuPool:IsAnyMenuOpen() then
        cameraNum = cameraNum + 1
        if (cameras[cameraNum] == nil) then
            cameraNum = 1
        end

        local camera = cameras[cameraNum]
        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
        exports["soe-ui"]:SendAlert("inform", "Camera Set To: " .. camera.label, 1000)
        if (camera.pos == "none") then
            DestroyCam(cam, 0)
            RenderScriptCams(0, 0, 1, 1, 1)
            SetFocusEntity(PlayerPedId())
        else
            DestroyCam(cam, 0)
            RenderScriptCams(0, 0, 1, 1, 1)
            cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
            RenderScriptCams(1, 0, 0, 1, 1)
        end
    end
end

-- CHARACTER CREATION TASKS
local function DoCharacterCreatorTasks()
    DoScreenFadeOut(1000)
    Wait(1000)

    -- TELEPORT TO A SUITABLE PLACE WITH LIGHT
    lastCoords = GetEntityCoords(PlayerPedId())
    math.random() math.random() math.random()
    TriggerServerEvent("Instance:Server:SetPlayerInstance", "CharCreator-" .. math.random(50000))

    exports["soe-fidelis"]:AuthorizeTeleport()
    SetEntityCoords(PlayerPedId(), 402.8835, -996.4879, -99.01465)
    SetEntityHeading(PlayerPedId(), 187.0866)
    SetGameplayCamRelativeHeading(60.0)
    Wait(4500)
    DoScreenFadeIn(2000)
end

-- MENU RUNTIME - NEEDS TO BE HERE DUE TO NATIVEUI
CreateThread(function()
    -- DELAY PRIOR TO LOOP START
    Wait(3500)
    CreateZones()

    -- LOOP
    while true do
        Wait(5)
        -- PROCESS THE MENU POOL IF IT EXISTS
        if appearanceMenuPool then
            appearanceMenuPool:ProcessMenus()
        end

        -- IF A MENU IS OPEN
        if appearanceMenuPool and appearanceMenuPool:IsAnyMenuOpen() then
            -- IF RIGHT KEY IS PRESSED DOWN
            if moveRight then
                for type, gridItem in pairs(gridItems) do
                    if gridItem.item:Selected() then
                        local curX, curY = gridItem.grid:CirclePosition()
                        if curX < 1.0 then
                            if gridItem.horizontal then
                                curY = 0.5
                            end
                            gridItem.grid:CirclePosition(curX + 0.01, curY)
                            table.insert(gridsChangedThisTick, type)
                        end
                    end
                end
            end

            -- IF LEFT KEY IS PRESSED DOWN
            if moveLeft then
                for type, gridItem in pairs(gridItems) do
                    if gridItem.item:Selected() then
                        local curX, curY = gridItem.grid:CirclePosition()
                        if curX > 0.0 then
                            if gridItem.horizontal then
                                curY = 0.5
                            end
                            gridItem.grid:CirclePosition(curX - 0.01, curY)
                            table.insert(gridsChangedThisTick, type)
                        end
                    end
                end
            end

            -- IF DOWN KEY IS PRESSED DOWN
            if moveDown then
                for type, gridItem in pairs(gridItems) do
                    if gridItem.item:Selected() then
                        local curX, curY = gridItem.grid:CirclePosition()
                        if curY < 1.0 and not gridItem.horizontal then
                            gridItem.grid:CirclePosition(curX, curY + 0.01)
                            table.insert(gridsChangedThisTick, type)
                        end
                    end
                end
            end

            -- IF UP KEY IS PRESSED DOWN
            if moveUp then
                for type, gridItem in pairs(gridItems) do
                    if gridItem.item:Selected() then
                        local curX, curY = gridItem.grid:CirclePosition()
                        if curY > 0.0 and not gridItem.horizontal then
                            gridItem.grid:CirclePosition(curX, curY - 0.01)
                            table.insert(gridsChangedThisTick, type)
                        end
                    end
                end
            end

            -- CAMERA MANAGEMENT
            if (cameras[cameraNum].pos ~= "none") then
                local head = GetEntityHeading(PlayerPedId()) - (cameras[cameraNum].hdg or 0.0)
                if (head < 0) then
                    head = 360.0 + head
                end

                SetCamCoord(cam, GetOffsetFromEntityInWorldCoords(PlayerPedId(), cameras[cameraNum].pos))
                SetCamRot(cam, 0.0, 0.0, head, 2)
            else
                if DoesCamExist(cam) then
                    DestroyCam(cam, 0)
                    RenderScriptCams(1, 0, 0, 1, 1)
                end
            end
        -- MENU NOT OPEN
        elseif isMenuOpen and not isCreatingNewChar then
            isMenuOpen = false
            appearanceMenuPool = nil
            appearanceMenuPool = NativeUI.CreatePool()

            DestroyCam(cam, 0)
            RenderScriptCams(0, 0, 1, 1, 1)
            SetFocusEntity(PlayerPedId())

            cam = nil
            cameraNum = 1
            LoadPlayerAppearance()
        end

        -- TRIGGER UPDATE FOR ANY GRID ITEMS CHANGED THIS TICK
        if #gridsChangedThisTick >= 1 then
            UpdateGridFeatures(gridsChangedThisTick)
            gridsChangedThisTick = {}
        end
    end
end)

-- ***********************
--    Global Functions
-- ***********************
-- RETURNS IF CHARACTER CREATION IS ACTIVE
function IsUsingAppearanceMenu()
    return isMenuOpen
end

-- WHEN TRIGGERED, GENERATE PROPER FACE FROM MOM/DAD/MIX DATA
function GenerateProperFace(mom, dad, mix, mixSkin)
    SetPedHeadBlendData(PlayerPedId(), mom, dad, nil, mom, dad, nil, mix, mixSkin, nil, false)
end

-- WHEN TRIGGERED, LOAD AN OUTFIT UP BASED OFF SENT DATA
function LoadOutfit(outfit)
    for k, v in pairs(outfit.components) do
        SetPedComponentVariation(PlayerPedId(), tonumber(k), v.drawableID, v.textureID, v.paletteID)
    end

    for k, v in pairs(outfit.props) do
        SetPedPropIndex(PlayerPedId(), tonumber(k), v.drawableID, v.textureID, true)
    end
    exports["soe-ui"]:SendAlert("success", "Outfit loaded. Be sure to save before leaving!", 5000)
end

-- CREATES A TABLE WITH GENERIC OPTIONS RANGING FROM 1 TO MAXOPTIONS. CAN SPECIFY IF A 'NONE' SHOULD BE INCLUDED AND A PREFIX (Ex: 'TestPrefix 1', 'TestPrefix2', ...)
function CreateOptionsTable(numOptions, includeNone, prefix)
    local options = {}
    if includeNone then
        table.insert(options, "None")
    end

    for i = 1, numOptions do
        if prefix then
            table.insert(options, prefix .. " " .. i)
        else
            table.insert(options, i)
        end
    end
    return options
end

-- WHEN TRIGGERED,  UPDATE GRID-BASED FEATURES
function UpdateGridFeatures(gridsChanged)
    for _, type in pairs(gridsChanged) do
        local curX, curY = gridItems[type].grid:CirclePosition()
        if curX then
            curX = (curX * 2) - 1
        end

        if curY then
            curY = (curY * 2) - 1
        end
        itemFunctions[type](curX, curY)
    end
end

-- WHEN TRIGGERED, UPDATE COLOR-BASED FEATURES
function UpdateColorFeatures(colorsChanged)
    for _, type in pairs(colorsChanged) do
        local colorIndex, itemIndex = nil, nil
        if type ~= "hair" then
            colorIndex = colorItems[type].color:CurrentSelection() - 1
            if colorItems[type].item:Index() == 1 then
                itemIndex = 255
            else
                itemIndex = colorItems[type].item:Index() - 1
            end
        else
            colorIndex = colorItems[type].color:CurrentSelection() - 1
            itemIndex = colorItems[type].item:Index() - 1
        end

        itemFunctions[type](itemIndex, colorIndex)
    end
end

-- WHEN TRIGGERED, UPDATE BLEMISH FEATURES
function UpdateBlemishFeature(opacityChanged)
    for _, type in pairs(opacityChanged) do
        -- GET OPACITY HERE WHEN WORKING
        local itemOpacity = 1.0
        local itemIndex = nil
        if opacityItems[type].item:Index() == 1 then
            itemIndex = 255
        else
            itemIndex = opacityItems[type].item:Index() - 1
        end

        itemFunctions[type](itemIndex, itemOpacity)
    end
end

-- WHEN TRIGGERED, LOAD THE PLAYER'S APPEARANCE FROM THE DB
function LoadPlayerAppearance()
    local app = exports["soe-nexus"]:TriggerServerCallback("Appearance:Server:RequestAppearance")
    if not app.model then
        isCreatingNewChar = true
        DoCharacterCreatorTasks()
        while isCreatingNewChar do
            if not appearanceMenuPool:IsAnyMenuOpen() then
                OpenAppearanceMenu("spawn", "Customize Yourself!", "Customize your character.", false, true)
            end
            Wait(1000)
        end

        return
    end

    local armor = GetPedArmour(PlayerPedId())
    local health = GetEntityHealth(PlayerPedId())
    exports["soe-utils"]:LoadModel(app.model, 15)
    SetPlayerModel(PlayerId(), app.model)

    -- RESTORE CORE COMPONENTS
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
    exports["soe-utils"]:RestoreMyItems(health, armor)

    for k, v in pairs(app.components) do
        SetPedComponentVariation(PlayerPedId(), tonumber(k), v.drawableID, v.textureID, v.paletteID)
    end

    for k, v in pairs(app.props) do
        SetPedPropIndex(PlayerPedId(), tonumber(k), v.drawableID, v.textureID, true)
    end

    if app.isFreemode then
        local blend = app.blend
        --[[print("LET US TRY TO DEBUG THIS MAN-FACE ISSUE HMM?")
        print("BLEND DATA DEBUGGING:", json.encode(blend))]]
        SetPedHeadBlendData(PlayerPedId(), blend.blendShape1, blend.blendShape2, blend.blendShape3, blend.blendSkin1, blend.blendSkin2, blend.blendSkin3, blend.blendMix1, blend.blendMix2, blend.blendMix3, blend.blendParent)

        --print("OVERLAY DEBUGGING:", json.encode(app.overlays))
        for k, v in pairs(app.overlays) do
            SetPedHeadOverlay(PlayerPedId(), tonumber(k), v.overlayIndex, v.overlayOpacity)
            SetPedHeadOverlayColor(PlayerPedId(), tonumber(k), v.overlayPalette, v.overlayColor1, v.overlayColor2)
        end

        --print("FACIAL FEATURE DEBUGGING:", json.encode(app.features))
        for k, v in pairs(app.features) do
            SetPedFaceFeature(PlayerPedId(), tonumber(k), v)
        end

        --print("HAIR COLOR DEBUGGING:", app.hairColor, "HAIR HIGHTLIGHT COLOR DEBUGGING:", app.hairHighlightColor)
        SetPedHairColor(PlayerPedId(), app.hairColor, app.hairHighlightColor)
        --print("EYE COLOR DEBUGGING:", app.eyeColor)
        SetPedEyeColor(PlayerPedId(), app.eyeColor)
    end
    myClothing = GetMyClothingAndProps()
    exports["soe-emotes"]:RestoreSavedWalkstyle()

    -- RESTORES TATTOOS
    if (app.tattoos and next(app.tattoos) ~= nil) then
        myTattoos = app.tattoos
        for _, tattoo in pairs(app.tattoos) do
            for overlayID, overlayTattoos in pairs(tattoo) do
                for tattooHash in pairs(overlayTattoos) do
                    --print("RESTORE MY TATTOOS PLS.")
                    AddPedDecorationFromHashes(PlayerPedId(), GetHashKey(overlayID), GetHashKey(tattooHash))
                end
            end
        end
    end
end

-- WHEN TRIGGERED, OPEN THE APPEARANCE MENU
function OpenAppearanceMenu(menuType, menuTitle, menuSubtitle, showInstructions, saveToDB, perms)
    -- CLOSE ANY OPEN MENUS
    appearanceMenuPool:CloseAllMenus()

    -- CHECK PERMS IF THIS CLOTHING STORE REQUIRES PERMS
    if perms ~= nil then
        local authorized = false
        -- PLAYER MUST HAVE ALL PERMS IN LIST
        for _, perm in pairs(perms) do
            if exports["soe-factions"]:CheckPermission(perm) then
                authorized = true
            else
                authorized = false
            end
        end

        -- RETURN IF PLAYER IS NOT AUTHORIZED
        if not authorized then
            exports["soe-ui"]:SendUniqueAlert("noperms", "error", "You do not have the right permissions to accessing this clothing store!", 2500)
            return
        end
    end

    -- CREATE THE PRIMARY APPEARANCE MENU AND PUT IT INTO THE POOL
    local appearanceMenu = NativeUI.CreateMenu(menuTitle, menuSubtitle, 1385, 70, 0, 0, 0, 235, 131, 52, 150)
    appearanceMenuPool:Add(appearanceMenu)

    if string.match(menuType, "clothing") then
        if GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01") or GetEntityModel(PlayerPedId()) == GetHashKey("mp_f_freemode_01") then
            local outfits = exports["soe-nexus"]:TriggerServerCallback("Appearance:Server:RequestOutfits")
            local outfitButtons = {}

            local outfitSubmenu = appearanceMenuPool:AddSubMenu(appearanceMenu, "Outfits", "Your saved outfits - Select to load or modify", "", true, true)
            outfitSubmenu.Item:SetRightBadge(BadgeStyle.Armour)

            local newOutfitButton = NativeUI.CreateItem("Create A New Outfit", "")
            outfitSubmenu.SubMenu:AddItem(newOutfitButton)

            if #outfits >= 1 then
                for _, outfit in pairs(outfits) do
                    local outfitMenu = appearanceMenuPool:AddSubMenu(outfitSubmenu.SubMenu, outfit.Name, "Load or modify " .. outfit.Name, "", true, true)
                    local loadButton = NativeUI.CreateItem("Load Outfit", "")
                    local deleteButton = NativeUI.CreateItem("Delete Outfit", "")
                    local renameButton = NativeUI.CreateItem("Rename Outfit", "")
                    local overwriteButton = NativeUI.CreateItem("Overwrite Outfit", "")

                    outfitMenu.SubMenu:AddItem(loadButton)
                    outfitMenu.SubMenu:AddItem(deleteButton)
                    outfitMenu.SubMenu:AddItem(renameButton)
                    outfitMenu.SubMenu:AddItem(overwriteButton)

                    outfitMenu.SubMenu.OnItemSelect = function(menu, item)
                        if item == loadButton then
                            LoadOutfit(json.decode(outfit.Outfit))
                            OpenAppearanceMenu(menuType, menuTitle, menuSubtitle, showInstructions, saveToDB)
                        elseif item == deleteButton then
                            exports["soe-input"]:OpenConfirmDialogue("Are you sure you want to delete " .. outfit.Name .. "?", "Delete", "Cancel", function(returnData)
                                if returnData then
                                    local deletedOutfitCB = exports["soe-nexus"]:TriggerServerCallback("Appearance:Server:DeleteOutfit", outfit.OutfitID)
                                    if deletedOutfitCB then
                                        exports["soe-ui"]:SendAlert("success", "Outfit successfully deleted!", 5000)
                                    else
                                        exports["soe-ui"]:SendAlert("error", "Unable to delete your outfit!", 5000)
                                    end
                                end
                                OpenAppearanceMenu(menuType, menuTitle, menuSubtitle, showInstructions, saveToDB)
                            end)
                        elseif item == renameButton then
                            exports["soe-input"]:OpenInputDialogue("name", "Enter a new name for this outfit:", function(returnData)
                                if returnData ~= nil then
                                    local modifiedOutfitCB = exports["soe-nexus"]:TriggerServerCallback("Appearance:Server:ModifyOutfit", outfit.OutfitID, "name", returnData)
                                    if modifiedOutfitCB then
                                        exports["soe-ui"]:SendAlert("success", "Outfit successfully renamed!", 5000)
                                    else
                                        exports["soe-ui"]:SendAlert("error", "Unable to save your renamed outfit!", 5000)
                                    end
                                end
                                OpenAppearanceMenu(menuType, menuTitle, menuSubtitle, showInstructions, saveToDB)
                            end)
                        elseif item == overwriteButton then
                            exports["soe-input"]:OpenConfirmDialogue("Are you sure you want to overwrite " .. outfit.Name .. "?", "Overwrite", "Cancel", function(returnData)
                                if returnData then
                                    local newOutfit = GetOutfitTable()
                                    local overwrittenOutfitCB = exports["soe-nexus"]:TriggerServerCallback("Appearance:Server:ModifyOutfit", outfit.OutfitID, "outfit", newOutfit)
                                    if overwrittenOutfitCB then
                                        exports["soe-ui"]:SendAlert("success", "Outfit successfully overwritten!", 5000)
                                    else
                                        exports["soe-ui"]:SendAlert("error", "Unable to overwrite your outfit!", 5000)
                                    end
                                end
                                OpenAppearanceMenu(menuType, menuTitle, menuSubtitle, showInstructions, saveToDB)
                            end)
                        end
                    end
                end

                for _, button in pairs(outfitButtons) do
                    outfitSubmenu.SubMenu:AddItem(button.outfitButton)
                end
            end

            outfitSubmenu.SubMenu.OnItemSelect = function(menu, item)
                if item == newOutfitButton then
                    exports["soe-input"]:OpenInputDialogue("name", "Enter a name for the new outfit:", function(returnData)
                        if returnData ~= nil then
                            local outfit = GetOutfitTable()
                            local savedOutfitCB = exports["soe-nexus"]:TriggerServerCallback("Appearance:Server:SaveOutfit", outfit, returnData)
                            if savedOutfitCB then
                                exports["soe-ui"]:SendAlert("success", "New outfit saved!", 5000)
                            else
                                exports["soe-ui"]:SendAlert("error", "Unable to save your new outfit!", 5000)
                            end
                            OpenAppearanceMenu(menuType, menuTitle, menuSubtitle, showInstructions, saveToDB)
                        end
                    end)
                end
            end
        end
    end

    -- SHOW THESE FOR ANY NEW SPAWNS
    if menuType == "spawn" or menuType == "new" then
        -- PED TYPE SUBMENU
        local pedSubmenu = appearanceMenuPool:AddSubMenu(appearanceMenu, "Ped Type", "Choose your ped type.", "", true, true)
        pedSubmenu.Item:SetRightBadge(BadgeStyle.Armour)

        -- SKINS
        local skinSubmenu = appearanceMenuPool:AddSubMenu(pedSubmenu.SubMenu, "Skin Models", "Choose from the following:", "WARNING: Little to no customization available!", true, true)

        -- MP PEDS
        local maleMPSelection = NativeUI.CreateItem("MP Male", "Lots of customization options!")
        local femaleMPSelection = NativeUI.CreateItem("MP Female", "Lots of customization options!")
        pedSubmenu.SubMenu:AddItem(maleMPSelection)
        pedSubmenu.SubMenu:AddItem(femaleMPSelection)

        local skinButtons = {}
        for index, skin in pairs(skinNames) do
            skinButtons[skinModels[index]] = NativeUI.CreateItem(skin, "")
            skinSubmenu.SubMenu:AddItem(skinButtons[skinModels[index]])
        end

        -- CHECK FOR BUTTON PRESS AND SET MODEL (SKIN)
        skinSubmenu.SubMenu.OnItemSelect = function(menu, item)
            for model, button in pairs(skinButtons) do
                if button == item then
                    local hash = GetHashKey(model)
                    exports["soe-utils"]:LoadModel(hash, 5)
                    SetPlayerModel(PlayerId(), hash)
                end
            end
        end

        -- CHECK FOR BUTTON PRESS AND SET MODEL (MP)
        pedSubmenu.SubMenu.OnItemSelect = function(menu, item)
            if item == maleMPSelection then
                local hash = GetHashKey("mp_m_freemode_01")
                exports["soe-utils"]:LoadModel(hash, 5)
                SetPlayerModel(PlayerId(), hash)
                SetPedComponentVariation(PlayerPedId(), 11, 0, 240, 0)
                SetPedComponentVariation(PlayerPedId(), 8, 0, 240, 0)
                SetPedComponentVariation(PlayerPedId(), 11, 6, 1, 0)
                SetPedHeadBlendData(PlayerPedId(), 21, 0, nil, 21, 0, nil, 0.5, 0.5, nil, false)
            elseif item == femaleMPSelection then
                local hash = GetHashKey("mp_f_freemode_01")
                exports["soe-utils"]:LoadModel(hash, 5)
                SetPlayerModel(PlayerId(), hash)
                SetPedComponentVariation(PlayerPedId(), 11, 0, 240, 0)
                SetPedComponentVariation(PlayerPedId(), 8, 0, 240, 0)
                SetPedComponentVariation(PlayerPedId(), 11, 6, 1, 0)
                SetPedHeadBlendData(PlayerPedId(), 21, 0, nil, 21, 0, nil, 0.5, 0.5, nil, false)
            end
        end

        -- RELOAD MENU WHEN YOU GO BACK (TO SHOW MP OPTIONS IF NEEDED)
        pedSubmenu.SubMenu.OnMenuChanged = function(menu, newMenu, forward)
            if not forward then
                OpenAppearanceMenu(menuType, menuTitle, menuSubtitle, showInstructions, saveToDB)
            end
        end

        -- HERITAGE SUBMENU
        if GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01") or GetEntityModel(PlayerPedId()) == GetHashKey("mp_f_freemode_01") then
            local heritageSubmenu = appearanceMenuPool:AddSubMenu(appearanceMenu, "Heritage", "Who's your daddy?", "", true, true)
            heritageSubmenu.Item:SetRightBadge(BadgeStyle.Heart)

            -- CREATE PARENT SELECTORS
            local parentSelector = NativeUI.CreateHeritageWindow(0, 0)
            heritageSubmenu.SubMenu:AddWindow(parentSelector)
            local momSelection = NativeUI.CreateListItem("Mother", GetHeritageOptions("Female"), 1, "")
            local dadSelection = NativeUI.CreateListItem("Father", GetHeritageOptions("Male"), 1, "")
            heritageSubmenu.SubMenu:AddItem(momSelection)
            heritageSubmenu.SubMenu:AddItem(dadSelection)

            local heritageResemblanceMixer = NativeUI.CreateSliderHeritageItem("Resemblance", range, 5, false, "")
            heritageSubmenu.SubMenu:AddItem(heritageResemblanceMixer)

            local heritageToneMixer = NativeUI.CreateSliderHeritageItem("Skin Tone", range, 5, false, "")
            heritageSubmenu.SubMenu:AddItem(heritageToneMixer)

            -- UPDATE BLEND ON SLIDER CHANGE
            heritageSubmenu.SubMenu.OnSliderChange = function(sender, item, index)
                if item == heritageResemblanceMixer or item == heritageToneMixer then
                    if index < 1.2 then
                        item:Index(1.2)
                    elseif index > 9.8 then
                        item:Index(9.8)
                    end

                    local mom = momSelection:IndexToItem(momSelection:Index())
                    local dad = dadSelection:IndexToItem(dadSelection:Index())
                    GenerateProperFace(
                        GetSkinIDFromParent(mom),
                        GetSkinIDFromParent(dad),
                        heritageResemblanceMixer:Index() / 10,
                        heritageToneMixer:Index() / 10
                    )
                end
            end

            -- UPDATE BLEND ON PARENT CHANGE
            heritageSubmenu.SubMenu.OnListChange = function(sender, item, index)
                if item == momSelection or item == dadSelection then
                    local mom = momSelection:IndexToItem(momSelection:Index())
                    local dad = dadSelection:IndexToItem(dadSelection:Index())
                    parentSelector:Index(GetMenuIndexFromParent(mom), GetMenuIndexFromParent(dad))
                    GenerateProperFace(
                        GetSkinIDFromParent(mom),
                        GetSkinIDFromParent(dad),
                        heritageResemblanceMixer:Index() / 10,
                        heritageToneMixer:Index() / 10
                    )
                end
            end
        end

        -- FEATURES SUBMENU
        if GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01") or GetEntityModel(PlayerPedId()) == GetHashKey("mp_f_freemode_01") then
            local featuresSubmenu = appearanceMenuPool:AddSubMenu(appearanceMenu, "Features", "Your face is your best asset!", "", true, true)
            featuresSubmenu.Item:SetRightBadge(BadgeStyle.Mask)

            local ped = PlayerPedId()

            -- EYEBROWS
            gridItems["brow"] = {
                ["item"] = NativeUI.CreateItem("Eyebrows", ""),
                ["grid"] = NativeUI.CreateGridPanel("Up", "In", "Out", "Down", math.abs((GetPedFaceFeature(ped, 7) + 1) / 2), math.abs((GetPedFaceFeature(ped, 6) + 1) / 2))
            }
            featuresSubmenu.SubMenu:AddItem(gridItems["brow"].item)
            gridItems["brow"].item:AddPanel(gridItems["brow"].grid)

            -- NOSE
            gridItems["nose"] = {
                ["item"] = NativeUI.CreateItem("Nose", ""),
                ["grid"] = NativeUI.CreateGridPanel("Up", "Narrow", "Wide", "Down", math.abs((GetPedFaceFeature(ped, 0) + 1) / 2), math.abs((GetPedFaceFeature(ped, 1) + 1) / 2))
            }
            featuresSubmenu.SubMenu:AddItem(gridItems["nose"].item)
            gridItems["nose"].item:AddPanel(gridItems["nose"].grid)

            -- NOSE PROFILE
            gridItems["noseprofile"] = {
                ["item"] = NativeUI.CreateItem("Nose Profile", ""),
                ["grid"] = NativeUI.CreateGridPanel("Crooked", "Short", "Long", "Curved", math.abs((-GetPedFaceFeature(ped, 2) + 1) / 2), math.abs((GetPedFaceFeature(ped, 3) + 1) / 2))
            }
            featuresSubmenu.SubMenu:AddItem(gridItems["noseprofile"].item)
            gridItems["noseprofile"].item:AddPanel(gridItems["noseprofile"].grid)

            -- NOSE TIP
            gridItems["nosetip"] = {
                ["item"] = NativeUI.CreateItem("Nose Tip", ""),
                ["grid"] = NativeUI.CreateGridPanel("Tip Up", "Tip Left", "Tip Right", "Tip Down", math.abs((-GetPedFaceFeature(ped, 5) + 1) / 2), math.abs((GetPedFaceFeature(ped, 4) + 1) / 2))
            }
            featuresSubmenu.SubMenu:AddItem(gridItems["nosetip"].item)
            gridItems["nosetip"].item:AddPanel(gridItems["nosetip"].grid)

            -- EYES
            gridItems["eyes"] = {
                ["item"] = NativeUI.CreateItem("Eyes", ""),
                ["grid"] = NativeUI.CreateHorizontalGridPanel("Narrow", "Wide", math.abs((-GetPedFaceFeature(ped, 11) + 1) / 2)),
                ["horizontal"] = true
            }
            featuresSubmenu.SubMenu:AddItem(gridItems["eyes"].item)
            gridItems["eyes"].item:AddPanel(gridItems["eyes"].grid)

            -- CHEEK BONES
            gridItems["cheekbones"] = {
                ["item"] = NativeUI.CreateItem("Cheek Bones", ""),
                ["grid"] = NativeUI.CreateGridPanel("Up", "In", "Out", "Down", math.abs((GetPedFaceFeature(ped, 9) + 1) / 2), math.abs((GetPedFaceFeature(ped, 8) + 1) / 2))
            }
            featuresSubmenu.SubMenu:AddItem(gridItems["cheekbones"].item)
            gridItems["cheekbones"].item:AddPanel(gridItems["cheekbones"].grid)

            -- CHEEKS
            gridItems["cheeks"] = {
                ["item"] = NativeUI.CreateItem("Cheeks", ""),
                ["grid"] = NativeUI.CreateHorizontalGridPanel("Gaunt", "Puffed", math.abs((-GetPedFaceFeature(ped, 10) + 1) / 2)),
                ["horizontal"] = true
            }
            featuresSubmenu.SubMenu:AddItem(gridItems["cheeks"].item)
            gridItems["cheeks"].item:AddPanel(gridItems["cheeks"].grid)

            -- LIPS
            gridItems["lips"] = {
                ["item"] = NativeUI.CreateItem("Lips", ""),
                ["grid"] = NativeUI.CreateHorizontalGridPanel("Thin", "Thick", math.abs((-GetPedFaceFeature(ped, 12) + 1) / 2)),
                ["horizontal"] = true
            }
            featuresSubmenu.SubMenu:AddItem(gridItems["lips"].item)
            gridItems["lips"].item:AddPanel(gridItems["lips"].grid)

            -- JAW
            gridItems["jaw"] = {
                ["item"] = NativeUI.CreateItem("Jaw", ""),
                ["grid"] = NativeUI.CreateGridPanel("Round", "Narrow", "Wide", "Square", math.abs((GetPedFaceFeature(ped, 13) + 1) / 2), math.abs((GetPedFaceFeature(ped, 14) + 1) / 2))
            }
            featuresSubmenu.SubMenu:AddItem(gridItems["jaw"].item)
            gridItems["jaw"].item:AddPanel(gridItems["jaw"].grid)

            -- CHIN PROFILE
            gridItems["chinprofile"] = {
                ["item"] = NativeUI.CreateItem("Chin Profile", ""),
                ["grid"] = NativeUI.CreateGridPanel("Up", "In", "Out", "Down", math.abs((GetPedFaceFeature(ped, 16) + 1) / 2), math.abs((GetPedFaceFeature(ped, 15) + 1) / 2))
            }
            featuresSubmenu.SubMenu:AddItem(gridItems["chinprofile"].item)
            gridItems["chinprofile"].item:AddPanel(gridItems["chinprofile"].grid)

            -- CHIN Shape
            gridItems["chinshape"] = {
                ["item"] = NativeUI.CreateItem("Chin Shape", ""),
                ["grid"] = NativeUI.CreateGridPanel("Rounded", "Square", "Pointed", "Bum", math.abs((GetPedFaceFeature(ped, 17) + 1) / 2), math.abs((GetPedFaceFeature(ped, 18) + 1) / 2))
            }
            featuresSubmenu.SubMenu:AddItem(gridItems["chinshape"].item)
            gridItems["chinshape"].item:AddPanel(gridItems["chinshape"].grid)
        end

        -- BLEMISHES SUBMENU
        if GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01") or GetEntityModel(PlayerPedId()) == GetHashKey("mp_f_freemode_01") then
            local blemishSubmenu = appearanceMenuPool:AddSubMenu(appearanceMenu, "Blemishes", "Nothing a little Cetaphil® can't fix!", "", true, true)
            blemishSubmenu.Item:SetRightBadge(BadgeStyle.Mask)

            -- BLEMISHES
            local blemishIndex = GetPedHeadOverlayValue(PlayerPedId(), 0)
            if (blemishIndex == 255) then
                blemishIndex = 0
            end

            opacityItems["blemishes"] = {
                ["item"] = NativeUI.CreateListItem("Face Blemishes", CreateOptionsTable(24, true, "Type"), blemishIndex + 1, "")
            }
            blemishSubmenu.SubMenu:AddItem(opacityItems["blemishes"].item)

            local blemishOpacitySelector = NativeUI.CreateProgressItem("Face Blemishes Opacity:", CreateOptionsTable(9, true, "Opacity"), 5, "", true)
            blemishSubmenu.SubMenu:AddItem(blemishOpacitySelector)

            blemishOpacitySelector.OnProgressChanged = function(menu, item, newindex)
                local item = item:IndexToItem(newindex)
                local _, currentBlemish = GetPedHeadOverlayData(PlayerPedId(), 0)
                SetPedHeadOverlay(PlayerPedId(), 0, currentBlemish, tonumber(newindex / 10))
            end

            -- AGEING
            local ageingIndex = GetPedHeadOverlayValue(PlayerPedId(), 3)
            if (ageingIndex == 255) then
                ageingIndex = 0
            end

            opacityItems["ageing"] = {
                ["item"] = NativeUI.CreateListItem("Ageing", CreateOptionsTable(15, true, "Type"), ageingIndex + 1, "")
            }
            blemishSubmenu.SubMenu:AddItem(opacityItems["ageing"].item)

            local ageOpacitySelector = NativeUI.CreateProgressItem("Ageing Opacity:", CreateOptionsTable(9, true, "Opacity"), 5, "", true)
            blemishSubmenu.SubMenu:AddItem(ageOpacitySelector)

            ageOpacitySelector.OnProgressChanged = function(menu, item, newindex)
                local item = item:IndexToItem(newindex)
                local _, currentAge = GetPedHeadOverlayData(PlayerPedId(), 3)
                SetPedHeadOverlay(PlayerPedId(), 3, currentAge, tonumber(newindex / 10))
            end

            -- COMPLEXION
            local complexionIndex = GetPedHeadOverlayValue(PlayerPedId(), 6)
            if (complexionIndex == 255) then
                complexionIndex = 0
            end

            opacityItems["complexion"] = {
                ["item"] = NativeUI.CreateListItem("Complexion", CreateOptionsTable(12, true, "Type"), complexionIndex + 1, "")
            }
            blemishSubmenu.SubMenu:AddItem(opacityItems["complexion"].item)

            local compexionOpacitySelector = NativeUI.CreateProgressItem("Complexion Opacity:", CreateOptionsTable(9, true, "Opacity"), 5, "", true)
            blemishSubmenu.SubMenu:AddItem(compexionOpacitySelector)

            compexionOpacitySelector.OnProgressChanged = function(menu, item, newindex)
                local item = item:IndexToItem(newindex)
                local _, currentComplexion = GetPedHeadOverlayData(PlayerPedId(), 6)
                SetPedHeadOverlay(PlayerPedId(), 6, currentComplexion, tonumber(newindex / 10))
            end

            -- SUN DAMAGE
            local sundamageIndex = GetPedHeadOverlayValue(PlayerPedId(), 7)
            if (sundamageIndex == 255) then
                sundamageIndex = 0
            end

            opacityItems["sundamage"] = {
                ["item"] = NativeUI.CreateListItem("Sun Damage", CreateOptionsTable(11, true, "Type"), sundamageIndex + 1, "")
            }
            blemishSubmenu.SubMenu:AddItem(opacityItems["sundamage"].item)

            local sundamageOpacitySelector = NativeUI.CreateProgressItem("Sun Damage Opacity:", CreateOptionsTable(9, true, "Opacity"), 5, "", true)
            blemishSubmenu.SubMenu:AddItem(sundamageOpacitySelector)

            sundamageOpacitySelector.OnProgressChanged = function(menu, item, newindex)
                local item = item:IndexToItem(newindex)
                local _, currentComplexion = GetPedHeadOverlayData(PlayerPedId(), 7)
                SetPedHeadOverlay(PlayerPedId(), 7, currentComplexion, tonumber(newindex / 10))
            end

            -- MOLES
            local moleIndex = GetPedHeadOverlayValue(PlayerPedId(), 9)
            if (moleIndex == 255) then
                moleIndex = 0
            end

            opacityItems["moles"] = {
                ["item"] = NativeUI.CreateListItem("Moles & Freckles", CreateOptionsTable(18, true, "Type"), moleIndex + 1, "")
            }
            blemishSubmenu.SubMenu:AddItem(opacityItems["moles"].item)

            local molesOpacitySelector = NativeUI.CreateProgressItem("Moles & Freckles Opacity:", CreateOptionsTable(9, true, "Opacity"), 5, "", true)
            blemishSubmenu.SubMenu:AddItem(molesOpacitySelector)

            molesOpacitySelector.OnProgressChanged = function(menu, item, newindex)
                local item = item:IndexToItem(newindex)
                local _, currentMole = GetPedHeadOverlayData(PlayerPedId(), 9)
                SetPedHeadOverlay(PlayerPedId(), 9, currentMole, tonumber(newindex / 10))
            end

            -- BODY BLEMISHES
            local blemish2Index = GetPedHeadOverlayValue(PlayerPedId(), 11)
            if (blemish2Index == 255) then
                blemish2Index = 0
            end

            opacityItems["blemishes2"] = {
                ["item"] = NativeUI.CreateListItem("Body Blemishes", CreateOptionsTable(12, true, "Type"), blemish2Index + 1, "")
            }
            blemishSubmenu.SubMenu:AddItem(opacityItems["blemishes2"].item)

            local bodBlemishOpacitySelector = NativeUI.CreateProgressItem("Body Blemishes Opacity:", CreateOptionsTable(9, true, "Opacity"), 5, "", true)
            blemishSubmenu.SubMenu:AddItem(bodBlemishOpacitySelector)

            bodBlemishOpacitySelector.OnProgressChanged = function(menu, item, newindex)
                local item = item:IndexToItem(newindex)
                local _, currentBodyBlemish = GetPedHeadOverlayData(PlayerPedId(), 11)
                SetPedHeadOverlay(PlayerPedId(), 11, currentBodyBlemish, tonumber(newindex / 10))
            end

            blemishSubmenu.SubMenu.OnListChange = function(sender, item, index)
                for type, opacityItem in pairs(opacityItems) do
                    if item == opacityItem.item then
                        UpdateBlemishFeature({type})
                    end
                end
            end
        end
    end

    -- SHOW THESE FOR ANY NEW SPAWNS OR BARBER SHOP
    if menuType == "spawn" or menuType == "new" or menuType == "barber" then
        -- HAIR SUBMENU
        if GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01") or GetEntityModel(PlayerPedId()) == GetHashKey("mp_f_freemode_01") then
            local hairSubmenu = appearanceMenuPool:AddSubMenu(appearanceMenu, "Hair", "Hairy nice to meet you!", "", true, true)
            hairSubmenu.Item:SetRightBadge(BadgeStyle.Barber)

            -- GET HAIR OPTIONS (NAMES)
            local hairOptions = {}
            if GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01") then
                hairOptions = GetHairOptions("Male")
            else
                hairOptions = GetHairOptions("Male")
            end

            -- HEAD HAIR
            colorItems["hair"] = {
                ["item"] = NativeUI.CreateListItem("Hair", hairOptions, GetPedDrawableVariation(PlayerPedId(), 2) + 1, ""),
                ["color"] = NativeUI.CreateColourPanel("Hair Color", ColoursPanel.HairCut)
            }
            hairSubmenu.SubMenu:AddItem(colorItems["hair"].item)
            colorItems["hair"].item:AddPanel(colorItems["hair"].color)
            colorItems["hair"].color:CurrentSelection(GetPedHairColor(PlayerPedId()), false)

            local hairHightlightSelector = NativeUI.CreateListItem("Hair Highlight", CreateOptionsTable(64, true, "Color"), GetPedHairHighlightColor(PlayerPedId()) + 1, "")
            hairSubmenu.SubMenu:AddItem(hairHightlightSelector)

            -- CHEST HAIR
            local _, chesthairIndex, _, chesthairColor, _, _ = GetPedHeadOverlayData(PlayerPedId(), 10)
            if (chesthairIndex == 255) then
                chesthairIndex = 0
            end

            colorItems["chesthair"] = {
                ["item"] = NativeUI.CreateListItem("Chest Hair", CreateOptionsTable(17, true, "Style"), chesthairIndex + 1, ""),
                ["color"] = NativeUI.CreateColourPanel("Chest Hair Color", ColoursPanel.HairCut)
            }
            hairSubmenu.SubMenu:AddItem(colorItems["chesthair"].item)
            colorItems["chesthair"].item:AddPanel(colorItems["chesthair"].color)
            colorItems["chesthair"].color:CurrentSelection(chesthairColor, false)

            local chesthairOpacitySelector = NativeUI.CreateProgressItem("Chest Hair Opacity:", CreateOptionsTable(9, true, "Opacity"), 5, "", true)
            hairSubmenu.SubMenu:AddItem(chesthairOpacitySelector)

            chesthairOpacitySelector.OnProgressChanged = function(menu, item, newindex)
                local item = item:IndexToItem(newindex)
                local _, currentChesthair = GetPedHeadOverlayData(PlayerPedId(), 10)
                SetPedHeadOverlay(PlayerPedId(), 10, currentChesthair, tonumber(newindex / 10))
            end

            -- BEARD
            local _, beardIndex, _, beardColor, _, _ = GetPedHeadOverlayData(PlayerPedId(), 1)
            if (beardIndex == 255) then
                beardIndex = 0
            end

            colorItems["beard"] = {
                ["item"] = NativeUI.CreateListItem("Facial Hair", CreateOptionsTable(29, true, "Style"), beardIndex + 1, ""),
                ["color"] = NativeUI.CreateColourPanel("Facial Hair Color", ColoursPanel.HairCut)
            }
            hairSubmenu.SubMenu:AddItem(colorItems["beard"].item)
            colorItems["beard"].item:AddPanel(colorItems["beard"].color)
            colorItems["beard"].color:CurrentSelection(beardColor, false)

            local facialHairOpacity = NativeUI.CreateProgressItem("Facial Hair Opacity:", CreateOptionsTable(9, true, "Opacity"), 5, "", true)
            hairSubmenu.SubMenu:AddItem(facialHairOpacity)

            facialHairOpacity.OnProgressChanged = function(menu, item, newindex)
                local item = item:IndexToItem(newindex)
                local _, currentBeard = GetPedHeadOverlayData(PlayerPedId(), 1)
                --[[print("FACIAL HAIR OPACITY:", tonumber(newindex / 10))
                print("CURRENT FACIAL HAIR", currentBeard)]]
                SetPedHeadOverlay(PlayerPedId(), 1, currentBeard, tonumber(newindex / 10))
            end

            -- EYEBROWS
            local _, eyebrowIndex, _, eyebrowColor, _, _ = GetPedHeadOverlayData(PlayerPedId(), 2)
            if (eyebrowIndex == 255) then
                eyebrowIndex = 0
            end

            colorItems["eyebrows"] = {
                ["item"] = NativeUI.CreateListItem("Eyebrows", CreateOptionsTable(34, true, "Style"), eyebrowIndex + 1, ""),
                ["color"] = NativeUI.CreateColourPanel("Eyebrow Color", ColoursPanel.HairCut)
            }
            hairSubmenu.SubMenu:AddItem(colorItems["eyebrows"].item)
            colorItems["eyebrows"].item:AddPanel(colorItems["eyebrows"].color)
            colorItems["eyebrows"].color:CurrentSelection(eyebrowColor, false)

            local eyebrowOpacitySelector = NativeUI.CreateProgressItem("Eyebrow Opacity:", CreateOptionsTable(9, true, "Opacity"), 5, "", true)
            hairSubmenu.SubMenu:AddItem(eyebrowOpacitySelector)

            eyebrowOpacitySelector.OnProgressChanged = function(menu, item, newindex)
                local item = item:IndexToItem(newindex)
                local _, currentBrows = GetPedHeadOverlayData(PlayerPedId(), 2)
                SetPedHeadOverlay(PlayerPedId(), 2, currentBrows, tonumber(newindex / 10))
            end

            -- CHECK FOR CHANGED LIST ITEM AND UPDATE HAIR
            hairSubmenu.SubMenu.OnListChange = function(sender, item, index)
                if (item ~= hairHightlightSelector) then
                    UpdateColorFeatures({"hair", "chesthair", "beard", "eyebrows"})
                else
                    SetPedHairColor(PlayerPedId(), GetPedHairColor(PlayerPedId()), index)
                end
            end
        end
    end

    -- SHOW THESE FOR ANY NEW SPAWNS, STYLIST, OR AT HOME
    if menuType == "spawn" or menuType == "new" or menuType == "stylist" or menuType == "home" then
        -- MAKEUP SUBMENU
        if (GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01") or GetEntityModel(PlayerPedId()) == GetHashKey("mp_f_freemode_01")) then
            local makeupSubmenu = appearanceMenuPool:AddSubMenu(appearanceMenu, "Makeup", "You're beautiful just the way you are!", "", true, true)
            makeupSubmenu.Item:SetRightBadge(BadgeStyle.Makeup)

            -- MAKEUP
            local _, makeupIndex, _, makeupColor, _, _ = GetPedHeadOverlayData(PlayerPedId(), 4)
            if (makeupIndex == 255) then
                makeupIndex = 0
            end

            colorItems["makeup"] = {
                ["item"] = NativeUI.CreateListItem("Makeup", CreateOptionsTable(75, true, "Option"), makeupIndex + 1, ""),
                ["color"] = NativeUI.CreateColourPanel("Makeup Color", ColoursPanel.Makeup)
            }
            makeupSubmenu.SubMenu:AddItem(colorItems["makeup"].item)
            colorItems["makeup"].item:AddPanel(colorItems["makeup"].color)
            colorItems["makeup"].color:CurrentSelection(makeupColor, false)

            local makeupOpacitySelector = NativeUI.CreateProgressItem("Makeup Opacity:", CreateOptionsTable(9, true, "Opacity"), 5, "", true)
            makeupSubmenu.SubMenu:AddItem(makeupOpacitySelector)

            makeupOpacitySelector.OnProgressChanged = function(menu, item, newindex)
                local item = item:IndexToItem(newindex)
                local _, currentMakeup = GetPedHeadOverlayData(PlayerPedId(), 4)
                SetPedHeadOverlay(PlayerPedId(), 4, currentMakeup, tonumber(newindex / 10))
            end

            -- BLUSH
            local _, blushIndex, _, blushColor, _, _ = GetPedHeadOverlayData(PlayerPedId(), 5)
            if (blushIndex == 255) then
                blushIndex = 0
            end

            colorItems["blush"] = {
                ["item"] = NativeUI.CreateListItem("Blush", CreateOptionsTable(7, true, "Option"), blushIndex + 1, ""),
                ["color"] = NativeUI.CreateColourPanel("Blush Color", ColoursPanel.Makeup)
            }
            makeupSubmenu.SubMenu:AddItem(colorItems["blush"].item)
            colorItems["blush"].item:AddPanel(colorItems["blush"].color)
            colorItems["blush"].color:CurrentSelection(blushColor, false)

            local blushOpacitySelector = NativeUI.CreateProgressItem("Blush Opacity:", CreateOptionsTable(9, true, "Opacity"), 5, "", true)
            makeupSubmenu.SubMenu:AddItem(blushOpacitySelector)

            blushOpacitySelector.OnProgressChanged = function(menu, item, newindex)
                local item = item:IndexToItem(newindex)
                local _, currentBlush = GetPedHeadOverlayData(PlayerPedId(), 5)
                SetPedHeadOverlay(PlayerPedId(), 5, currentBlush, tonumber(newindex / 10))
            end

            -- LIPSTICK
            local _, lipstickIndex, _, lipstickColor, _, _ = GetPedHeadOverlayData(PlayerPedId(), 8)
            if (lipstickIndex == 255) then
                lipstickIndex = 0
            end

            colorItems["lipstick"] = {
                ["item"] = NativeUI.CreateListItem("Lipstick", CreateOptionsTable(10, true, "Option"), lipstickIndex + 1, ""),
                ["color"] = NativeUI.CreateColourPanel("Lipstick Color", ColoursPanel.Makeup)
            }
            makeupSubmenu.SubMenu:AddItem(colorItems["lipstick"].item)
            colorItems["lipstick"].item:AddPanel(colorItems["lipstick"].color)
            colorItems["lipstick"].color:CurrentSelection(lipstickColor, false)

            local lipstickOpacitySelector = NativeUI.CreateProgressItem("Lipstick Opacity:", CreateOptionsTable(9, true, "Opacity"), 5, "", true)
            makeupSubmenu.SubMenu:AddItem(lipstickOpacitySelector)

            lipstickOpacitySelector.OnProgressChanged = function(menu, item, newindex)
                local item = item:IndexToItem(newindex)
                local _, currentLipstick = GetPedHeadOverlayData(PlayerPedId(), 8)
                SetPedHeadOverlay(PlayerPedId(), 8, currentLipstick, tonumber(newindex / 10))
            end

            -- EYE COLOR
            local eyeColor = GetPedEyeColor(PlayerPedId())
            local eyeColorSelector = NativeUI.CreateListItem("Eye Color", CreateOptionsTable(32, true, "Color"), (tonumber(eyeColor) + 1), "")
            makeupSubmenu.SubMenu:AddItem(eyeColorSelector)

            -- GET IF LIST IS CHANGED AND UPDATE MAKEUP
            makeupSubmenu.SubMenu.OnListChange = function(sender, item, index)
                if (item == eyeColorSelector) then
                    SetPedEyeColor(PlayerPedId(), index)
                else
                    for type, colorItem in pairs(colorItems) do
                        if item == colorItem.item then
                            UpdateColorFeatures({type})
                        end
                    end
                end
            end
        end
    end

    -- SHOW THESE FOR ANY NEW SPAWNS, AT HOME, OR AT ANY CLOTHING SHOP
    if menuType == "spawn" or menuType == "new" or menuType == "home" or string.match(menuType, "clothing") then
        -- CLOTHING SUBMENU
        local clothingSubmenu = appearanceMenuPool:AddSubMenu(appearanceMenu, "Clothing & Accessories", "Time to cover up!", "", true, true)
        clothingSubmenu.Item:SetRightBadge(BadgeStyle.Clothes)

        local clothesSubmenus = {}
        local propSubmenus = {}
        local ped = PlayerPedId()

        -- IF SKIN MODEL, SHOW HEAD SELECTION
        if GetEntityModel(PlayerPedId()) ~= GetHashKey("mp_m_freemode_01") and GetEntityModel(PlayerPedId()) ~= GetHashKey("mp_f_freemode_01") then
            clothesSubmenus[0] = {
                ["submenu"] = appearanceMenuPool:AddSubMenu(clothingSubmenu.SubMenu, "Face/Head", "Pick your face/head", "", true, true),
                ["componentID"] = NativeUI.CreateListItem("Item", CreateOptionsTable(GetNumberOfPedDrawableVariations(ped, 0), false, "Item"), GetPedDrawableVariation(ped, 0) + 1, ""),
                ["componentTexture"] = NativeUI.CreateListItem("Texture", CreateOptionsTable(GetNumberOfPedTextureVariations(ped, 0, GetPedDrawableVariation(ped, 0)), false, "Texture"), GetPedTextureVariation(ped, 0) + 1, "")
            }
            clothesSubmenus[0].submenu.SubMenu:AddItem(clothesSubmenus[0].componentID)
            clothesSubmenus[0].submenu.SubMenu:AddItem(clothesSubmenus[0].componentTexture)

            clothesSubmenus[0].submenu.SubMenu.OnListChange = function(sender, item, index)
                if item ==  clothesSubmenus[0].componentID then
                    SetPedComponentVariation(ped, 0,  clothesSubmenus[0].componentID:Index() - 1, 0, 0)
                    clothesSubmenus[0].componentTexture:UpdateItems(CreateOptionsTable(GetNumberOfPedTextureVariations(ped, 0, GetPedDrawableVariation(ped, 0)), false, "Texture"))
                    clothesSubmenus[0].componentTexture:Index(1)
                elseif item ==  clothesSubmenus[0].componentTexture then
                    SetPedComponentVariation(ped, 0,  clothesSubmenus[0].componentID:Index() - 1,  clothesSubmenus[0].componentTexture:Index() - 1, 0)
                end
            end
        end

        -- SHOW OTHER COMPONENTS FOR ALL
        for componentID, name in pairs(componentNames) do
            clothesSubmenus[componentID] = {
                ["submenu"] = appearanceMenuPool:AddSubMenu(clothingSubmenu.SubMenu, name, "Pick your " .. name, "", true, true),
                ["componentID"] = NativeUI.CreateListItem("Item", CreateOptionsTable(GetNumberOfPedDrawableVariations(ped, componentID), false, "Item"), GetPedDrawableVariation(ped, componentID) + 1, ""),
                ["componentTexture"] = NativeUI.CreateListItem("Texture", CreateOptionsTable(GetNumberOfPedTextureVariations(ped, componentID, GetPedDrawableVariation(ped, componentID)), false, "Texture"), GetPedTextureVariation(ped, componentID) + 1, "")
            }
            clothesSubmenus[componentID].submenu.SubMenu:AddItem(clothesSubmenus[componentID].componentID)
            clothesSubmenus[componentID].submenu.SubMenu:AddItem(clothesSubmenus[componentID].componentTexture)

            clothesSubmenus[componentID].submenu.SubMenu.OnListChange = function(sender, item, index)
                for componentID, componentSubmenu in pairs(clothesSubmenus) do
                    if item == componentSubmenu.componentID then
                        SetPedComponentVariation(ped, componentID, componentSubmenu.componentID:Index() - 1, 0, 0)
                        componentSubmenu.componentTexture:UpdateItems(CreateOptionsTable(GetNumberOfPedTextureVariations(ped, componentID, GetPedDrawableVariation(ped, componentID)), false, "Texture"))
                        componentSubmenu.componentTexture:Index(1)
                    elseif item == componentSubmenu.componentTexture then
                        SetPedComponentVariation(ped, componentID, componentSubmenu.componentID:Index() - 1, componentSubmenu.componentTexture:Index() - 1, 0)
                    end
                end
            end
        end

        -- SHOW ALL PROP CATEGORIES
        for componentID, name in pairs(propComponentNames) do
            propSubmenus[componentID] = {
                ["submenu"] = appearanceMenuPool:AddSubMenu(clothingSubmenu.SubMenu, name, "Pick your " .. name, "", true, true),
                ["componentID"] = NativeUI.CreateListItem("Item", CreateOptionsTable(GetNumberOfPedPropDrawableVariations(ped, componentID), true, "Item"), GetPedPropIndex(ped, componentID), ""),
                ["componentTexture"] = NativeUI.CreateListItem("Texture", CreateOptionsTable(GetNumberOfPedPropTextureVariations(ped, componentID, GetPedDrawableVariation(ped, componentID)), false, "Texture"), GetPedPropTextureIndex(ped, componentID), "")
            }
            propSubmenus[componentID].submenu.SubMenu:AddItem(propSubmenus[componentID].componentID)
            propSubmenus[componentID].submenu.SubMenu:AddItem(propSubmenus[componentID].componentTexture)

            propSubmenus[componentID].submenu.SubMenu.OnListChange = function(sender, item, index)
                for componentID, componentSubmenu in pairs(propSubmenus) do
                    if item == componentSubmenu.componentID then
                        if componentSubmenu.componentID:Index() == 1 then
                            ClearPedProp(ped, componentID)
                            componentSubmenu.componentTexture:UpdateItems({"N/A"})
                        else
                            SetPedPropIndex(ped, componentID, componentSubmenu.componentID:Index() - 2, 0, true)
                            componentSubmenu.componentTexture:UpdateItems(CreateOptionsTable(GetNumberOfPedPropTextureVariations(ped, componentID, GetPedPropIndex(ped, componentID)), false, "Texture"))
                            componentSubmenu.componentTexture:Index(1)
                        end
                    elseif item == componentSubmenu.componentTexture then
                        if componentSubmenu.componentID:Index() == 1 then
                            ClearPedProp(ped, componentID)
                        else
                            SetPedPropIndex(ped, componentID, componentSubmenu.componentID:Index() - 2, componentSubmenu.componentTexture:Index() - 1, true)
                        end
                    end
                end
            end
        end
    end

    -- SAVE/EXIT SUBMENU
    local saveSubmenu = appearanceMenuPool:AddSubMenu(appearanceMenu, "Save & Close", "Ready to go?", "", true, true)
    saveSubmenu.Item:SetRightBadge(BadgeStyle.Tick)

    -- BUTTONS FOR SAVE OR NOT
    local saveYes = NativeUI.CreateItem("Yes, I'm done!", "")
    saveYes:SetRightBadge(BadgeStyle.Tick)
    local saveNo = NativeUI.CreateItem("No, not yet!", "")
    saveNo:SetRightBadge(BadgeStyle.Alert)

    -- GET WHEN ITEM IS SELECTED
    saveSubmenu.SubMenu.OnItemSelect = function(menu, item)
        if item == saveNo then
            saveSubmenu.SubMenu:GoBack()
        elseif item == saveYes then
            isMenuOpen = false
            appearanceMenuPool = nil
            appearanceMenuPool = NativeUI.CreatePool()
            appearanceMenuPool:CloseAllMenus()

            DestroyCam(cam, 0)
            RenderScriptCams(0, 0, 1, 1, 1)
            SetFocusEntity(PlayerPedId())

            cam = nil
            cameraNum = 1
            myClothing = GetMyClothingAndProps()
            if saveToDB then
                local app = GetAppearanceTable()
                local charID = exports["soe-uchuu"]:GetPlayer().CharID
                TriggerServerEvent("Appearance:Server:SaveAppearance", charID, app)

                if isCreatingNewChar then
                    isCreatingNewChar = false
                    DoScreenFadeOut(1000)
                    Wait(1000)
                    if lastCoords then
                        exports["soe-fidelis"]:AuthorizeTeleport()
                        SetEntityCoords(PlayerPedId(), lastCoords)
                        lastCoords = nil
                    else
                        exports["soe-fidelis"]:AuthorizeTeleport()
                        SetEntityCoords(PlayerPedId(), -286.178, -1062.07, 27.20)
                    end

                    TriggerServerEvent("Instance:Server:SetPlayerInstance", -1)
                    TriggerServerEvent("Inventory:Server:StarterItemChecks", {status = true})
                    DoScreenFadeIn(2000)
                end
            end
        end
     end
    saveSubmenu.SubMenu:AddItem(saveYes)
    saveSubmenu.SubMenu:AddItem(saveNo)

    -- MENU SETTINGS/VISIBLE
    exports["soe-ui"]:HideTooltip()
    appearanceMenuPool:RefreshIndex()
    appearanceMenu:Visible(true)
    appearanceMenuPool:ControlDisablingEnabled(false)
    appearanceMenuPool:MouseEdgeEnabled(false)
    appearanceMenuPool:MouseControlsEnabled(false)
    appearanceMenuPool:DisableInstructionalButtons(false)
    isMenuOpen = true
end

-- ***********************
--       Commands
-- ***********************
-- WHEN TRIGGERED, CYCLE THROUGH CAMERAS
RegisterCommand("cycleappearancecams", CycleAppearanceCamera)

-- UP KEBIND PRESS
RegisterCommand("+moveUp", function()
    moveUp = true
end)

-- UP KEBIND UNPRESS
RegisterCommand("-moveUp", function()
    moveUp = false
end)

-- DOWN KEBIND PRESS
RegisterCommand("+moveDown", function()
    moveDown = true
end)

-- DOWN KEYBIND UNPRESS
RegisterCommand("-moveDown", function()
    moveDown = false
end)

-- LEFT KEYBIND PRESS
RegisterCommand("+moveLeft", function()
    moveLeft = true
    -- COLOR PANELS - MOVE ONLY ONE BLOCK AT A TIME
    for type, colorItem in pairs(colorItems) do
        if colorItem.item:Selected() then
            colorItem.color:GoLeft()
            UpdateColorFeatures({type})
        end
    end
end)

-- LEFT KEYBIND UNPRESS
RegisterCommand("-moveLeft", function()
    moveLeft = false
end)

-- RIGHT KEYBIND PRESS
RegisterCommand("+moveRight", function()
    moveRight = true
    -- COLOR PANELS - MOVE ONLY ONE BLOCK AT A TIME
    for type, colorItem in pairs(colorItems) do
        if colorItem.item:Selected() then
            colorItem.color:GoRight()
            UpdateColorFeatures({type})
        end
    end
end)

-- RIGHT KEYBIND UNPRESS
RegisterCommand("-moveRight", function()
    moveRight = false
end)

-- LOAD APPEARANCE
RegisterCommand("loadapp", function()
    if exports["soe-emergency"]:IsDead() then
        exports["soe-ui"]:SendUniqueAlert("loadappDead", "error", "Cannot use this command while dead!", 5000)
        return
    end
    LoadPlayerAppearance()
end)

RegisterCommand("debugclothing", function()
    print("Player Model: ", GetEntityModel(PlayerPedId()))

    print("DRAWABLES:")
    for drawable = 0, 11 do
        print(drawable .. ":", GetPedDrawableVariation(PlayerPedId(), drawable), GetPedTextureVariation(PlayerPedId(), drawable), GetPedPaletteVariation(PlayerPedId(), drawable))
    end

    print("PROPS:")
    for prop = 0, 7 do
        print(prop .. ":", GetPedPropIndex(PlayerPedId(), prop), GetPedPropTextureIndex(PlayerPedId(), prop))
    end
end)

-- ***********************
--        Events
-- ***********************
-- GET WHEN PLAYER SPAWNS SO WE CAN LOAD APPEARANCE
AddEventHandler("Uchuu:Client:PlayerSpawned", function()
    Wait(1000)
    LoadPlayerAppearance()
end)

AddEventHandler("Utils:Client:EnteredZone", function(name, zoneData)
    if name:match("Clothing") then
        action = {status = true, loc = zoneData.loc, name = zoneData.name, type = zoneData.type, perms = zoneData.perms}
        exports["soe-ui"]:ShowTooltip("fas fa-tshirt", "[E] Clothing Store", "inform")
    elseif name:match("Barber") then
        action = {status = true, loc = zoneData.loc, name = zoneData.name, type = zoneData.type}
        exports["soe-ui"]:ShowTooltip("fas fa-cut", "[E] Barbershop", "inform")
    end
end)

AddEventHandler("Utils:Client:InteractionKey", function()
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
        return
    end

    if not action then return end
    if action.status and not IsPedSittingInAnyVehicle(PlayerPedId()) then
        OpenAppearanceMenu(action.type, action.name, action.name .. " on " .. action.loc, false, true, action.perms)
    end
end)

AddEventHandler("Utils:Client:ExitedZone", function(name)
    if name:match("Clothing") or name:match("Barber") then
        action = nil
        exports["soe-ui"]:HideTooltip()
        if appearanceMenuPool and appearanceMenuPool:IsAnyMenuOpen() then
            appearanceMenuPool:CloseAllMenus()
        end
    elseif (name == "char_creator") then
        -- DON'T LET PLAYER GO TOO FAR FROM CREATOR SPOT
        if isCreatingNewChar then
            if not isCreatingNewChar then return end
            SetEntityCoords(PlayerPedId(), 402.8835, -996.4879, -99.01465)
            SetEntityHeading(PlayerPedId(), 187.0866)
            exports["soe-ui"]:SendAlert("error", "Settle down! You gotta fix yourself first", 5000)
        end
    end
end)
