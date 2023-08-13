-- BUILDS TATTOOS TABLE
function SaveTattoos(tattoos)
    local done = exports["soe-nexus"]:TriggerServerCallback("Appearance:Server:SaveTattoos", tattoos)
    if done then
        LoadPlayerAppearance()
    end
end

-- BUILD APPEARANCE TABLE
function GetAppearanceTable()
    local appearance = {}
    local ped = PlayerPedId()
    local model = GetEntityModel(ped)

    appearance["model"] = model

    -- NON MP MODEL
    if model ~= GetHashKey("mp_m_freemode_01") and model ~= GetHashKey("mp_f_freemode_01") then
        appearance["isFreemode"] = false
    else
        appearance["isFreemode"] = true
    end

    -- COMPILE COMPONENTS (CLOTHING/HAIR/BEARD) FOR FREEMODE AND SKIN
    appearance["components"] = {}
    for i = 0, 11 do
        appearance["components"][i] = {
            ["drawableID"] = GetPedDrawableVariation(ped, i),
            ["textureID"] = GetPedTextureVariation(ped, i),
            ["paletteID"] = GetPedPaletteVariation(ped, i)
        }
    end

    -- COMPILE PROPS FOR FREEMODE AND SKIN
    appearance["props"] = {}
    for i = 0, 7 do
        appearance["props"][i] = {
            ["drawableID"] = GetPedPropIndex(ped, i),
            ["textureID"] = GetPedPropTextureIndex(ped, i)
        }
    end

    -- ONLY IF FREEMODE
    if appearance["isFreemode"] then

        local headBlend = nil
        TriggerEvent("hbw:GetHeadBlendData", PlayerPedId(), function(data)
            headBlend = data
        end)

        appearance["blend"] = {
            ["blendShape1"] = headBlend.FirstFaceShape,
            ["blendShape2"] = headBlend.SecondFaceShape,
            ["blendShape3"] = headBlend.ThirdFaceShape,
            ["blendSkin1"] = headBlend.FirstSkinTone,
            ["blendSkin2"] = headBlend.SecondSkinTone,
            ["blendSkin3"] = headBlend.ThirdSkinTone,
            ["blendMix1"] = headBlend.ParentFaceShapePercent,
            ["blendMix2"] = headBlend.ParentSkinTonePercent,
            ["blendMix3"] = headBlend.ParentThirdUnkPercent,
            ["blendParent"] = headBlend.IsParentInheritance
        }

        -- GET OVERLAYS
        appearance["overlays"] = {}

        for i = 0, 12 do
            local _, overlayIndex, overlayPalette, overlayColor1, overlayColor2, overlayOpacity = GetPedHeadOverlayData(ped, i)

            print(GetPedHeadOverlayData(ped, i))

            appearance["overlays"][i] = {
                ["overlayIndex"] = overlayIndex,
                ["overlayPalette"] = overlayPalette,
                ["overlayColor1"] = overlayColor1,
                ["overlayColor2"] = overlayColor2,
                ["overlayOpacity"] = overlayOpacity
            }
        end

        -- GET FACIAL FEATURES
        appearance["features"] = {}

        for i = 0, 19 do
            appearance["features"][i] = GetPedFaceFeature(ped, i)
            print(GetPedFaceFeature(ped, i))
        end

        appearance["hairColor"] = GetPedHairColor(ped)
        appearance["hairHighlightColor"] = GetPedHairHighlightColor(ped)
        appearance["eyeColor"] = GetPedEyeColor(ped)
    end

    -- RETURN TABLE
    return appearance
end

function GetOutfitTable()
    local outfit = {}
    local ped = PlayerPedId()

    outfit["components"] = {}
    for i = 1, 11 do
        if i ~= 2 then
            outfit["components"][i] = {
                ["drawableID"] = GetPedDrawableVariation(ped, i),
                ["textureID"] = GetPedTextureVariation(ped, i),
                ["paletteID"] = GetPedPaletteVariation(ped, i)
            }
        end
    end

    -- COMPILE PROPS FOR FREEMODE AND SKIN
    outfit["props"] = {}
    for i = 0, 7 do
        outfit["props"][i] = {
            ["drawableID"] = GetPedPropIndex(ped, i),
            ["textureID"] = GetPedPropTextureIndex(ped, i)
        }
    end

    return outfit
end

function GetHeritageOptions(gender)
    local options = {}
    for skinID, data in pairs(haritageOptions) do
        if data.gender == gender then
            table.insert(options, data.name)
        end
    end
    return options
end

-- GET HAIR OPTIONS FOR GENDER
function GetHairOptions(gender)
    local options = {}
    for index, hairData in pairs(hairOptions) do
        if hairData.gender == gender then
            table.insert(options, hairData.name)
        end
    end
    return options
end

-- GET MENU INDEX ID FROM PARENT NAME
function GetMenuIndexFromParent(parentName)
    for skinID, data in pairs(haritageOptions) do
        if data.name == parentName then
            return data.menuID
        end
    end
    return 0
end

-- GET SKIN ID FROM PARENT NAME
function GetSkinIDFromParent(parentName)
    for skinID, data in pairs(haritageOptions) do
        if data.name == parentName then
            return skinID
        end
    end
    return 0
end

-- RETURNS IF PLAYER IS WEARING GLOVES
function IsWearingGloves()
    local ped = PlayerPedId()
    local wearingGloves = true
    local armIndex = GetPedDrawableVariation(ped, 3)

    if (GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then
        if (maleGloves[armIndex] ~= nil and maleGloves[armIndex]) then
            wearingGloves = false
        end
    else
        if (femaleGloves[armIndex] ~= nil and femaleGloves[armIndex]) then
            wearingGloves = false
        end
    end
    return wearingGloves
end
