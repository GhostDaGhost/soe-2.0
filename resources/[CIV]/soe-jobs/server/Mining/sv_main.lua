local miningRewards = {
    {name = "Copper Ore", hash = "copperore"},
    {name = "Silver Ore", hash = "silverore"},
    {name = "Gold Ore", hash = "goldore"},
    {name = "Iron Ore", hash = "ironore"},
    {name = "Coal", hash = "coal"},
}

local miningJewelryRewards = {
    {name = "Sapphire", hash = "sapphire"},
    {name = "Ruby", hash = "ruby"},
    {name = "Gold Nugget", hash = "goldnugget"},
    {name = "Emerald", hash = "emerald"},
    {name = "Diamond", hash = "diamond"}
}

-- REQUESTED FROM CLIENT TO GIVE MINING REWARDS
RegisterNetEvent("Jobs:Server:MineRock")
AddEventHandler("Jobs:Server:MineRock", function()
    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID

    -- GIVE ROCKS NO MATTER WHAT
    math.randomseed(os.time())
    local rockAmount, oreAmount = math.random(1, 5), math.random(1, 3)
    if exports["soe-inventory"]:AddItem(src, "char", charID, "rocks", rockAmount, "{}") then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = ("You got %sx Rocks!"):format(rockAmount), length = 5000})
    end

    -- RANDOMIZE AND GIVE ORE
    if exports["soe-utils"]:GetRandomChance(35) then
        local oreFound = miningRewards[math.random(1, #miningRewards)]
        if exports["soe-inventory"]:AddItem(src, "char", charID, oreFound.hash, oreAmount, "{}") then
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = ("You got %sx %s!"):format(oreAmount, oreFound.name), length = 5000})
        end
    end

    -- CHANCE OF A JEWELRY ITEM BEING FOUND
    if exports["soe-utils"]:GetRandomChance(30) then
        math.randomseed(GetGameTimer())
        local jewelryAmount = math.random(1, 2)
        local jewelryFound = miningJewelryRewards[math.random(1, #miningJewelryRewards)]
        if exports["soe-inventory"]:AddItem(src, "char", charID, jewelryFound.hash, jewelryAmount, "{}") then
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = ("You got %sx %s!"):format(jewelryAmount, jewelryFound.name), length = 5000})
        end
    end
end)
