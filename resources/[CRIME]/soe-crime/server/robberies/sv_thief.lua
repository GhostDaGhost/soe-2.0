local muggingLoot = {
    {hash = "cash", name = "Cash", luck = {min = 1, max = 79}, quantity = {min = 10, max = 25}},
    {hash = "painkillers", name = "Painkillers", luck = {min = 80, max = 84}, quantity = {min = 1, max = 3}},
    {hash = "weed_seed", name = "Weed Seed", luck = {min = 85, max = 88}, quantity = {min = 1, max = 1}},
    {hash = "WEAPON_PISTOL", name = "Pistol", luck = {min = 89, max = 91}, quantity = {min = 1, max = 1}},
    {hash = "vaultcard_green", name = "Green Bank Access Card", luck = {min = 92, max = 97}, quantity = {min = 1, max = 1}},
}

-- TRIGGERED FROM CLIENT TO REWARD PLAYER WITH LOOT
RegisterNetEvent("Crime:Server:MugLocal")
AddEventHandler("Crime:Server:MugLocal", function()
    local src = source

    -- RANDOMIZE OUR LOOT
    math.randomseed(GetGameTimer())
    math.random() math.random() math.random()

    -- 75% CHANCE OF A REWARD
    if (math.random(1, 100) <= 75) then
        math.random() math.random() math.random()
        local reward = math.random(1, 100)
        for _, loot in pairs(muggingLoot) do
            if reward >= loot.luck["min"] and reward <= loot.luck["max"] then
                reward = loot
                break
            end
        end

        local amount = math.random(reward.quantity["min"], reward.quantity["max"])
        local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
        if exports["soe-inventory"]:AddItem(src, "char", charID, reward.hash, amount, "{}") then
            exports["soe-logging"]:ServerLog("Successful Mugging", ("GOT %s %s FROM MUGGING A LOCAL"):format(amount, reward.hash), src)
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = ("You got %sx %s!"):format(amount, reward.name), length = 5500})
        end
    else
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You did not find anything of interest!", length = 5500})
    end
end)
