local pickaxe, isMining = nil, false
local rockModels = {"prop_rock_1_a", "prop_rock_1_b", "prop_rock_1_c", "prop_test_rocks01", "prop_test_rocks02", "prop_test_rocks03", "prop_test_rocks04",
"prop_rock_1_d", "prop_rock_1_e", "prop_rock_1_f"}

-- STARTS MINING THE ROCK
local function Minerock()
    -- IF ALREADY MINING
    if isMining then return end

    -- ITERATE AND MAKE SURE WE HAVE A ROCK NEARBY
    local ped = PlayerPedId()
    local found, pos = false, GetEntityCoords(ped)
    for _, rock in pairs(rockModels) do
        local obj = GetClosestObjectOfType(pos, 2.1, GetHashKey(rock), false)
        if DoesEntityExist(obj) then
            found = rock
            break
        end
    end

    if found then
        -- RETURN IF PLAYER DOES NOT HAVE A PICKAXE
        if not exports["soe-inventory"]:HasInventoryItem("pickaxe") then
            exports["soe-ui"]:SendAlert("error", "You need a pickaxe to mine", 4500)
            return
        end

        isMining = true
        -- ANIMATION CONTROL
        exports["soe-ui"]:SendAlert("warning", "You start mining...", 7500)
        exports["soe-utils"]:LoadAnimDict("melee@large_wpn@streamed_core", 15)
        TaskPlayAnim(ped, "melee@large_wpn@streamed_core", "car_side_attack_a", 3.0, 3.0, -1, 33, 0, 0, 0, 0)

        -- MAKE OUR PICKAXE PROP
        if not DoesEntityExist(pickaxe) then
            exports["soe-utils"]:LoadModel(GetHashKey("prop_tool_pickaxe"), 15)
            pickaxe = CreateObject(GetHashKey("prop_tool_pickaxe"), pos, 1, 1, 1)
            AttachEntityToEntity(pickaxe, ped, GetPedBoneIndex(ped, 57005), 0.08, -0.4, -0.10, 80.0, -20.0, 175.0, 1, 1, 0, 1, 0, 1)
        end

        math.randomseed(GetGameTimer())
        Wait(math.random(8500, 10000))

        -- SKILLBAR MINIGAME
        PlaySoundFrontend(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", false)
        if exports["soe-challenge"]:Skillbar(12000, math.random(5, 15)) then
            TriggerServerEvent("Jobs:Server:MineRock")
        else
            exports["soe-ui"]:SendAlert("error", "You did not find anything", 5000)
        end

        ClearPedTasks(ped)
        DeleteEntity(pickaxe)
        pickaxe, isMining = nil, false
        StopAnimTask(ped, "melee@large_wpn@streamed_core", "car_side_attack_a", 2.0)
    end
end

-- INTERACTION KEY TO MINE ROCK
AddEventHandler("Utils:Client:InteractionKey", function()
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
        return
    end
    Minerock()
end)
