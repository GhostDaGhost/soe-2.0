local hungerLevel = 250
local thirstLevel = 250
local maxHungerLevel = 250
local maxThirstLevel = 250
local hpLostFromThirstOrHunger = 0
local factorthirstLevel = (1000 * 100) / 7500000 -- Ratio to consume thirst"s bar
local factorhungerLevel = (1000 * 100) / 10000000 -- Ratio to consume hunger"s bar

local function GetSpeed()
    local vx, vy, vz = table.unpack(GetEntityVelocity(PlayerPedId()))
    return math.sqrt(vx * vx + vy * vy + vz * vz)
end

function GetHunger()
    return hungerLevel
end

function GetThirst()
    return thirstLevel
end

function SetLevels(hunger, thirst)
    hungerLevel = hunger
    thirstLevel = thirst
end

function SaveLevelsToDB()
    exports["soe-uchuu"]:UpdateGamestate("hunger", false, math.ceil(hungerLevel))
    exports["soe-uchuu"]:UpdateGamestate("thirst", false, math.ceil(thirstLevel))
end

function UpdateHungerThirst()
    local ped = PlayerPedId()
    local health = GetEntityHealth(ped)
    if hungerLevel <= 0 then
        hungerLevel = 0
        exports["soe-ui"]:SendUniqueAlert("starving", "error", "You are starving!", 4000)
        if not exports["soe-emergency"]:IsDead() then
            SetEntityHealth(ped, health - 1)
            hpLostFromThirstOrHunger = hpLostFromThirstOrHunger + 1
        end
    elseif hungerLevel <= maxHungerLevel * 0.10 and hungerLevel >= maxHungerLevel * 0.095 then
        exports["soe-ui"]:SendUniqueAlert("hungry", "inform", "You are very hungry!", 4000)
    end

    if thirstLevel <= 0 then
        thirstLevel = 0
        exports["soe-ui"]:SendUniqueAlert("dehydrated", "error", "You are dehydrated!", 4000)
        if not exports["soe-emergency"]:IsDead() then
            SetEntityHealth(ped, health - 2)
            hpLostFromThirstOrHunger = hpLostFromThirstOrHunger + 2
        end
    elseif thirstLevel <= maxThirstLevel * 0.10 and thirstLevel >= maxThirstLevel * 0.095 then
        exports["soe-ui"]:SendUniqueAlert("thirsty", "inform", "You are very thirsty!", 4000)
    end

    if IsPedOnFoot(ped) then
        local x = math.min(GetSpeed(), 10) + 0.5
        if IsPedInMeleeCombat(ped) then
            x = x + 1
            hungerLevel = hungerLevel - (factorhungerLevel * x)
            thirstLevel = thirstLevel - (factorthirstLevel * x)
        else
            hungerLevel = hungerLevel - (factorhungerLevel * x)
            thirstLevel = thirstLevel - (factorthirstLevel * x)
        end
    else
        hungerLevel = hungerLevel - factorhungerLevel
        thirstLevel = thirstLevel - factorthirstLevel
    end

    -- RESTORE PLAYER HP LOST FROM HUNGER/THIRST IF HUNGER AND THIRST IS NOT 0 AND PLAYER NOT ALREADY AT FULL HP
    if hpLostFromThirstOrHunger > 0 and hungerLevel > 0 and thirstLevel > 0 and health < GetEntityMaxHealth(ped) then
        SetEntityHealth(ped, health + 1)
        hpLostFromThirstOrHunger = hpLostFromThirstOrHunger - 1
    end
end

function UpdateFoodAndDrink(newHungerLevel, newThirstLevel)
    hungerLevel = hungerLevel + newHungerLevel
    thirstLevel = thirstLevel + newThirstLevel

    if hungerLevel > maxHungerLevel then
        hungerLevel = maxHungerLevel
    end
    if thirstLevel > maxThirstLevel then
        thirstLevel = maxThirstLevel
    end
end

function Eat(food, hungerChange, thirstChange)
    -- DETERMINE EATING DURATION BY CHANGE
    local eatDuration = hungerChange * 25
    if (eatDuration < 2500) then
        eatDuration = 2500
    end

    -- DETERMINE PROP BY THE FOOD
    local animDict = "mp_player_inteat@burger"
    local anim = "mp_player_int_eat_burger_fp"
    local propModel = "prop_cs_burger_01"
    local rotX, rotY, rotZ = 120.0, 16.0, 60.0
    local propX, propY, propZ = 0.13, 0.07, 0.02
    if (food == "Hamburger") then
        propModel = "prop_cs_burger_01"
    elseif (food == "Sandwich") then
        propModel = "prop_sandwich_01"
    elseif (food == "Donut") then
        propModel = "prop_amb_donut"
    elseif (food == "Bread") then
        propModel = "v_res_fa_bread03"
    elseif (food == "ps&qs") then
        propModel = "prop_candy_pqs"
    elseif (food == "Chips") then
        propModel = "v_ret_ml_chips3"
    elseif (food == "Chips") then
        propModel = "v_ret_ml_chips3"
    elseif (food == "Hotdog") then
        propModel = "prop_cs_hotdog_01"
        rotX, rotY, rotZ = 160.0, 0.0, -50.0
    elseif (food == "Gumball") then
        propModel = "prop_poolball_cue"
    end

    if exports["soe-utils"]:IsModelADog(PlayerPedId()) then
        animDict = ""
        anim = ""
        propModel = ""
    end

    exports["soe-utils"]:Progress(
        {
            name = "eat",
            duration = eatDuration,
            label = "Eating",
            useWhileDead = true,
            canCancel = true,
            controlDisables = {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true
            },
            animation = {
                animDict = animDict,
                anim = anim,
                flags = 49
            },
            prop = {
                model = propModel,
                bone = 18905,
                coords = {x = propX, y = propY, z = propZ},
                rotation = {x = rotX, y = rotY, z = rotZ}
            }
        },
        function(cancelled)
            if not cancelled then
                UpdateFoodAndDrink(hungerChange, thirstChange)
            end
        end
    )
end

function Drink(drink, hungerChange, thirstChange)
    -- DETERMINE DRINKING DURATION BY CHANGE
    local drinkDuration = thirstChange * 25
    if (drinkDuration < 2500) then
        drinkDuration = 2500
    end

    -- DETERMINE PROP BY THE DRINK
    local animDict = "mp_player_intdrink"
    local anim = "loop_bottle"
    local propModel = "prop_ld_flow_bottle"
    local rotX, rotY, rotZ = -95.0, 0.0, -20.0
    local propX, propY, propZ = 0.07, 0.0, 0.03
    if (drink == "Water Bottle") then
        propModel = "prop_ld_flow_bottle"
    elseif (drink == "Beer") then
        propModel = "prop_amb_beer_bottle"
    elseif (drink == "Coffee") then
        propModel = "p_amb_coffeecup_01"
    elseif (drink == "E-Cola") then
        propModel = "prop_ecola_can"
    elseif (drink == "Sprunk") then
        propModel = "prop_ld_can_01"
    elseif (drink == "Energy Drink") then
        propModel = "prop_energy_drink"
    elseif (drink == "Whiskey") then
        propModel = "p_whiskey_bottle_s"
    elseif (drink == "Juice") then
        propModel = "prop_cs_paper_cup"
    elseif (drink == "Milk") then
        propModel = "prop_cs_milk_01"
    elseif (drink == "Vodka") then
        propX, propY, propZ = -0.01, -0.25, 0.05
        propModel = "prop_vodka_bottle"
    elseif (drink == "whiskyGlass") then
        propModel = "prop_drink_whisky"
    elseif (drink == "champagneGlass") then
        propModel = "prop_drink_champ"
    elseif (drink == "shotGlass") then
        propModel = "p_cs_shot_glass_2_s"
    end

    if exports["soe-utils"]:IsModelADog(PlayerPedId()) then
        animDict = ""
        anim = ""
        propModel = ""
    end

    exports["soe-utils"]:Progress(
        {
            name = "drinking",
            duration = drinkDuration,
            label = "Drinking",
            useWhileDead = true,
            canCancel = true,
            controlDisables = {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true
            },
            animation = {
                animDict = animDict,
                anim = anim,
                flags = 49
            },
            prop = {
                model = propModel,
                bone = 36029,
                coords = {x = propX, y = propY, z = propZ},
                rotation = {x = rotX, y = rotY, z = rotZ}
            }
        },
        function(cancelled)
            if not cancelled then
                UpdateFoodAndDrink(hungerChange, thirstChange)
            end
        end
    )
end
