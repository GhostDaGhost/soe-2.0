myClothing = nil

-- **********************
--    Local Functions
-- **********************
-- TOGGLES A CHOSEN PIECE OF CLOTHING
local function ClothingToggle(piece)
    local ped = PlayerPedId()

    -- CHECK IF PED IS MP MALE OR FEMALE
    local myGender
    if (GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then
        myGender = "Male"
    elseif (GetEntityModel(ped) == GetHashKey("mp_f_freemode_01")) then
        myGender = "Female"
    end

    -- IF WE ARE NOT A MULTIPLAYER PED, RETURN
    if (myGender == nil) then
        exports["soe-ui"]:SendAlert("error", "You must be a multiplayer ped", 5000)
        return
    end

    if (myClothing == nil) then return end
    local clothing = myClothing["Clothing"]
    local props = myClothing["Props"]

    -- BEGIN TOGGLES
    if (piece == "undershirt") then
        -- TOGGLE UNDERSHIRT
        exports["soe-utils"]:LoadAnimDict("clothingtie", 15)
        TaskPlayAnim(ped, "clothingtie", "try_tie_negative_a", 3.0, 3.0, 1200, 51, 0, 0, 0, 0)
        Wait(1200)

        if (myGender == "Male") then
            if (GetPedDrawableVariation(ped, 8) ~= 15) then
                -- TOGGLE TO NO UNDERSHIRT
                SetPedComponentVariation(ped, 8, 15, 0, 0)
            else
                -- TOGGLE BACK TO SAVED UNDERSHIRT
                SetPedComponentVariation(ped, 8, clothing.Drawable["8"], clothing.Texture["8"], 0)
            end
        elseif (myGender == "Female") then
            if (GetPedDrawableVariation(ped, 8) ~= 14) then
                -- TOGGLE TO NO UNDERSHIRT
                SetPedComponentVariation(ped, 8, 14, 0, 0)
            else
                -- TOGGLE BACK TO SAVED UNDERSHIRT
                SetPedComponentVariation(ped, 8, clothing.Drawable["8"], clothing.Texture["8"], 0)
            end
        end
    elseif (piece == "hair") then
        -- TOGGLE HAIR
        exports["soe-utils"]:LoadAnimDict("clothingtie", 15)
        TaskPlayAnim(ped, "clothingtie", "check_out_a", 3.0, 3.0, 2000, 51, 0, 0, 0, 0)
        Wait(2000)

        local currentHair = GetPedDrawableVariation(ped, 2)
        for variationID, variationData in pairs(variations["Hair"][myGender]) do
            if (currentHair == variationID) then
                print("MATCHES VARIATION ID.")
                SetPedComponentVariation(ped, 2, variationData, clothing.Texture["2"], 0)
                break
            elseif (currentHair == variationData) then
                print("MATCHES VARIATION DATA.")
                SetPedComponentVariation(ped, 2, clothing.Drawable["2"], clothing.Texture["2"], 0)
                break
            end
		end
    elseif (piece == "bag") then
        -- TOGGLE BAG VARIATION
        exports["soe-utils"]:LoadAnimDict("anim@heists@money_grab@duffel", 15)
        TaskPlayAnim(ped, "anim@heists@money_grab@duffel", "enter", 1.0, 1.0, 1350, 49, 0, 0, 0, 0)
        Wait(1500)

        if (GetPedDrawableVariation(ped, 5) == -1) then
            SetPedComponentVariation(ped, 5, clothing.Drawable["5"], clothing.Texture["5"], 0)
        else
            SetPedComponentVariation(ped, 5, -1, -1, 1)
        end
    elseif (piece == "ear") then
        -- TOGGLE EAR VARIATION
        exports["soe-utils"]:LoadAnimDict("mp_cp_stolen_tut", 15)
        TaskPlayAnim(ped, "mp_cp_stolen_tut", "b_think", 3.0, 3.0, 900, 51, 0, 0, 0, 0)
        Wait(900)

        if (GetPedPropIndex(ped, 2) == -1) then
            SetPedPropIndex(ped, 2, props.Drawable["2"], props.Texture["2"], true)
        else
            ClearPedProp(ped, 2)
        end
    elseif (piece == "watch") then
        -- TOGGLE WATCH VARIATION
        exports["soe-utils"]:LoadAnimDict("nmt_3_rcm-10", 15)
        TaskPlayAnim(ped, "nmt_3_rcm-10", "cs_nigel_dual-10", 3.0, 3.0, 1200, 51, 0, 0, 0, 0)
        Wait(1200)

        if (GetPedPropIndex(ped, 6) == -1) then
            SetPedPropIndex(ped, 6, props.Drawable["6"], props.Texture["6"], true)
        else
            ClearPedProp(ped, 6)
        end
    elseif (piece == "bracelet") then
        -- TOGGLE BRACELET VARIATION
        exports["soe-utils"]:LoadAnimDict("nmt_3_rcm-10", 15)
        TaskPlayAnim(ped, "nmt_3_rcm-10", "cs_nigel_dual-10", 3.0, 3.0, 1200, 51, 0, 0, 0, 0)
        Wait(1200)

        if (GetPedPropIndex(ped, 7) == -1) then
            SetPedPropIndex(ped, 7, props.Drawable["7"], props.Texture["7"], true)
        else
            ClearPedProp(ped, 7)
        end
    elseif (piece == "hat") then
        -- TOGGLE HAT VARIATION
        if (GetPedPropIndex(ped, 0) == -1) then
            exports["soe-utils"]:LoadAnimDict("veh@common@fp_helmet@", 15)
            TaskPlayAnim(ped, "veh@common@fp_helmet@", "put_on_helmet", 3.0, 3.0, 1650, 51, 0, 0, 0, 0)
            Wait(1650)
            SetPedPropIndex(ped, 0, props.Drawable["0"], props.Texture["0"], true)
        else
            exports["soe-utils"]:LoadAnimDict("missheist_agency2ahelmet", 15)
            TaskPlayAnim(ped, "missheist_agency2ahelmet", "take_off_helmet_stand", 3.0, 3.0, 1200, 51, 0, 0, 0, 0)
            Wait(1200)
            ClearPedProp(ped, 0)
        end
    elseif (piece == "glasses") then
        -- TOGGLE GLASSES VARIATION
        if (GetPedPropIndex(ped, 1) == -1) then
            exports["soe-utils"]:LoadAnimDict("clothingspecs", 15)
            TaskPlayAnim(ped, "clothingspecs", "try_glasses_negative_b", 1.0, 1.0, 1050, 49, 0, 0, 0, 0)
            Wait(1050)
            SetPedPropIndex(ped, 1, props.Drawable["1"], props.Texture["1"], true)
        else
            exports["soe-utils"]:LoadAnimDict("clothingspecs", 15)
            TaskPlayAnim(ped, "clothingspecs", "take_off", 3.0, 3.0, 1100, 51, 0, 0, 0, 0)
            Wait(1100)
            ClearPedProp(ped, 1)
        end
    elseif (piece == "mask") then
        -- TOGGLE MASK
        if (GetPedDrawableVariation(ped, 1) ~= 0) then
            -- TOGGLE TO NO MASK
            exports["soe-utils"]:LoadAnimDict("missfbi4", 15)
            TaskPlayAnim(ped, "missfbi4", "takeoff_mask", 3.0, 3.0, 1200, 49, 0, 0, 0, 0)
            Wait(1200)
            SetPedComponentVariation(ped, 1, 0, 0, 0)
        else
            -- TOGGLE BACK TO SAVED MASK
            exports["soe-utils"]:LoadAnimDict("mp_masks@standard_car@ds@", 15)
            TaskPlayAnim(ped, "mp_masks@standard_car@ds@", "put_on_mask", 3.0, 3.0, 850, 49, 0, 0, 0, 0)
            Wait(850)
            SetPedComponentVariation(ped, 1, clothing.Drawable["1"], clothing.Texture["1"], 0)
        end
    elseif (piece == "shirt") then
        -- TOGGLE SHIRT
        exports["soe-utils"]:LoadAnimDict("clothingtie", 15)
        TaskPlayAnim(ped, "clothingtie", "try_tie_negative_a", 3.0, 3.0, 1200, 51, 0, 0, 0, 0)
        Wait(1200)

        if (myGender == "Male") then
            if (GetPedDrawableVariation(ped, 11) ~= 15) then
                -- TOGGLE TO SHIRTLESS
                SetPedComponentVariation(ped, 3, 15, 0, 0)
                SetPedComponentVariation(ped, 11, 15, 0, 0)
            else
                -- TOGGLE BACK TO SAVED SHIRT
                SetPedComponentVariation(ped, 3, clothing.Drawable["3"], clothing.Texture["3"], 0)
                SetPedComponentVariation(ped, 11, clothing.Drawable["11"], clothing.Texture["11"], 0)
            end
        elseif (myGender == "Female") then
            if (GetPedDrawableVariation(ped, 11) ~= 15) then
                -- TOGGLE TO SHIRTLESS
                SetPedComponentVariation(ped, 3, 15, 0, 0)
                SetPedComponentVariation(ped, 11, 15, 0, 0)
            else
                -- TOGGLE BACK TO SAVED SHIRT
                SetPedComponentVariation(ped, 3, clothing.Drawable["3"], clothing.Texture["3"], 0)
                SetPedComponentVariation(ped, 11, clothing.Drawable["11"], clothing.Texture["11"], 0)
            end
        end
    elseif (piece == "pants") then
        -- TOGGLE PANTS
        exports["soe-utils"]:LoadAnimDict("re@construction", 15)
        TaskPlayAnim(ped, "re@construction", "out_of_breath", 3.0, 3.0, 1300, 51, 0, 0, 0, 0)
        Wait(1300)

        if (myGender == "Male") then
            if (GetPedDrawableVariation(ped, 4) ~= 90) then
                -- TOGGLE TO NO PANTS
                SetPedComponentVariation(ped, 4, 90, 1, 0)
            else
                -- TOGGLE BACK TO SAVED PANTS
                SetPedComponentVariation(ped, 4, clothing.Drawable["4"], clothing.Texture["4"], 0)
            end
        elseif (myGender == "Female") then
            if (GetPedDrawableVariation(ped, 4) ~= 15) then
                -- TOGGLE TO NO PANTS
                SetPedComponentVariation(ped, 4, 15, 0, 0)
            else
                -- TOGGLE BACK TO SAVED PANTS
                SetPedComponentVariation(ped, 4, clothing.Drawable["4"], clothing.Texture["4"], 0)
            end
        end
    elseif (piece == "shoes") then
        -- TOGGLE SHOES
        exports["soe-utils"]:LoadAnimDict("random@domestic", 15)
        TaskPlayAnim(ped, "random@domestic", "pickup_low", 3.0, 3.0, 1200, 49, 0, 0, 0, 0)
        Wait(1200)

        if (myGender == "Male") then
            if (GetPedDrawableVariation(ped, 6) ~= 42) then
                -- TOGGLE TO BAREFEET
                SetPedComponentVariation(ped, 6, 42, 0, 0)
            else
                -- TOGGLE BACK TO SAVED SHOES
                SetPedComponentVariation(ped, 6, clothing.Drawable["6"], clothing.Texture["6"], 0)
            end
        elseif (myGender == "Female") then
            if (GetPedDrawableVariation(ped, 6) ~= 40) then
                -- TOGGLE TO BAREFEET
                SetPedComponentVariation(ped, 6, 40, 0, 0)
            else
                -- TOGGLE BACK TO SAVED SHOES
                SetPedComponentVariation(ped, 6, clothing.Drawable["6"], clothing.Texture["6"], 0)
            end
        end
    elseif (piece == "vest") then
        -- TOGGLE VEST
        exports["soe-utils"]:LoadAnimDict("clothingtie", 15)
        TaskPlayAnim(ped, "clothingtie", "try_tie_negative_a", 3.0, 3.0, 1200, 49, 0, 0, 0, 0)
        Wait(1200)

        if (GetPedDrawableVariation(ped, 9) ~= 0) then
            -- TOGGLE TO NO VEST
            SetPedComponentVariation(ped, 9, 0, 0, 0)
        else
            -- TOGGLE BACK TO SAVED VEST
            SetPedComponentVariation(ped, 9, clothing.Drawable["9"], clothing.Texture["9"], 0)
        end
    elseif (piece == "neck") then
        -- TOGGLE NECKLACE
        exports["soe-utils"]:LoadAnimDict("clothingtie", 15)
        TaskPlayAnim(ped, "clothingtie", "try_tie_positive_a", 3.0, 3.0, 2100, 49, 0, 0, 0, 0)
        Wait(2100)

        if (GetPedDrawableVariation(ped, 7) ~= 0) then
            -- TOGGLE TO NO NECKLACE
            SetPedComponentVariation(ped, 7, 0, 0, 0)
        else
            -- TOGGLE BACK TO SAVED NECKLACE
            SetPedComponentVariation(ped, 7, clothing.Drawable["7"], clothing.Texture["7"], 0)
        end
    elseif (piece == "decals") then
        -- TOGGLE DECALS
        if (GetPedDrawableVariation(ped, 10) ~= 0) then
            -- TOGGLE TO NO DECALS
            SetPedComponentVariation(ped, 10, 0, 0, 0)
        else
            -- TOGGLE BACK TO SAVED DECALS
            SetPedComponentVariation(ped, 10, clothing.Drawable["10"], clothing.Texture["10"], 0)
        end
    elseif (piece == "bra") then
        if (myGender ~= "Female") then
            exports["soe-ui"]:SendAlert("error", "This toggle is for females only!", 5000)
            return
        end

        exports["soe-utils"]:LoadAnimDict("clothingtie", 15)
        TaskPlayAnim(ped, "clothingtie", "try_tie_negative_a", 3.0, 3.0, 1200, 49, 0, 0, 0, 0)
        Wait(1200)

        if (GetPedDrawableVariation(ped, 11) ~= 205) then
            SetPedComponentVariation(ped, 3, 15, 0, 0)
            SetPedComponentVariation(ped, 11, 205, 1, 0)
        else
            SetPedComponentVariation(ped, 3, 15, 0, 0)
            SetPedComponentVariation(ped, 11, 15, 0, 0)
        end
    elseif (piece == "accessories") then
        exports["soe-utils"]:LoadAnimDict("clothingtie", 15)
        TaskPlayAnim(ped, "clothingtie", "try_tie_negative_a", 3.0, 3.0, 1200, 49, 0, 0, 0, 0)
        Wait(1200)
        -- TOGGLE ACCESSORES
        if (GetPedDrawableVariation(ped, 7) ~= 0) then
            -- TOGGLE TO NO ACCESSORES
            SetPedComponentVariation(ped, 7, 0, 0, 0)
        else
            -- TOGGLE BACK TO SAVED ACCESSORES
            SetPedComponentVariation(ped, 7, clothing.Drawable["7"], clothing.Texture["7"], 0)
        end
    elseif (piece == "Bathrobe") then -- TOGGLE BATHROBE
        exports["soe-utils"]:LoadAnimDict("clothingtie", 15)
        TaskPlayAnim(ped, "clothingtie", "try_tie_negative_a", 3.0, 3.0, 1200, 51, 0, 0, 0, 0)
        Wait(1200)

        if (myGender == "Male") then
            if (GetPedDrawableVariation(ped, 11) ~= 215 and GetPedDrawableVariation(ped, 4) ~= 85) then
                SetPedComponentVariation(ped, 3, 14, 0, 0)
                SetPedComponentVariation(ped, 4, 85, 0, 0)
                SetPedComponentVariation(ped, 6, 24, 0, 0)
                SetPedComponentVariation(ped, 8, 15, 0, 0)
                SetPedComponentVariation(ped, 11, 215, 0, 0)
                exports["soe-ui"]:SendAlert("inform", "Do /loadapp or use the robe item again to reset back to previous outfit!", 6500)
            else
                SetPedComponentVariation(ped, 3, clothing["Drawable"]["3"], clothing["Texture"]["3"], 0)
                SetPedComponentVariation(ped, 4, clothing["Drawable"]["4"], clothing["Texture"]["4"], 0)
                SetPedComponentVariation(ped, 6, clothing["Drawable"]["6"], clothing["Texture"]["6"], 0)
                SetPedComponentVariation(ped, 8, clothing["Drawable"]["8"], clothing["Texture"]["8"], 0)
                SetPedComponentVariation(ped, 11, clothing["Drawable"]["11"], clothing["Texture"]["11"], 0)
            end
        elseif (myGender == "Female") then
            if (GetPedDrawableVariation(ped, 11) ~= 228 and GetPedDrawableVariation(ped, 4) ~= 99) then
                SetPedComponentVariation(ped, 3, 15, 0, 0)
                SetPedComponentVariation(ped, 4, 99, 0, 0)
                SetPedComponentVariation(ped, 6, 5, 0, 0)
                SetPedComponentVariation(ped, 8, 9, 0, 0)
                SetPedComponentVariation(ped, 11, 228, 0, 0)
                exports["soe-ui"]:SendAlert("inform", "Do /loadapp or use the robe item again to reset back to previous outfit!", 6500)
            else
                SetPedComponentVariation(ped, 3, clothing["Drawable"]["3"], clothing["Texture"]["3"], 0)
                SetPedComponentVariation(ped, 4, clothing["Drawable"]["4"], clothing["Texture"]["4"], 0)
                SetPedComponentVariation(ped, 6, clothing["Drawable"]["6"], clothing["Texture"]["6"], 0)
                SetPedComponentVariation(ped, 8, clothing["Drawable"]["8"], clothing["Texture"]["8"], 0)
                SetPedComponentVariation(ped, 11, clothing["Drawable"]["11"], clothing["Texture"]["11"], 0)
            end
        end
    end
end

-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, TOGGLE PARACHUTE
function ToggleParachute(toggle)
    toggle = toggle or false
    local ped = PlayerPedId()

    if not myClothing then return end
    local clothing = myClothing["Clothing"]

    if (GetPedDrawableVariation(ped, 5) == 0) or toggle then
        SetPedComponentVariation(ped, 5, 1, 0, 0)
    else
        SetPedComponentVariation(ped, 5, clothing.Drawable["5"], clothing.Texture["5"], 0)
    end
end

-- COMPILES CLOTHING DRAWABLES/TXTs INTO A TABLE
function GetMyClothingAndProps()
    local ped = PlayerPedId()
    local myClothes = {}
    local textureProps = {}
    local drawableProps = {}
    local drawableClothes = {}
    local textureClothes = {}

    for i = 0, 11 do
        drawableClothes[i] = GetPedDrawableVariation(ped, i)
        textureClothes[i] = GetPedTextureVariation(ped, i)
    end

    for i = 0, 7 do
        drawableProps[i] = GetPedPropIndex(ped, i)
        textureProps[i] = GetPedPropTextureIndex(ped, i)
    end

    myClothes = {
        Clothing = {Drawable = drawableClothes, Texture = textureClothes},
        Props = {Drawable = drawableProps, Texture = textureProps}
    }
    myClothes = json.decode(json.encode(myClothes))
    return myClothes
end

-- **********************
--        Events
-- **********************
-- CALLED FROM SERVER ANYTIME A CLOTHING TOGGLE COMMAND IS EXECUTED
RegisterNetEvent("Appearance:Client:PieceToggles")
AddEventHandler("Appearance:Client:PieceToggles", ClothingToggle)
