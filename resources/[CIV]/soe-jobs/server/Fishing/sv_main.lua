RegisterCommand("fish", function(source)
    local src = source
    if (exports["soe-inventory"]:GetItemAmt(src, "fishingrod", "left") < 1) then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You do not have a fishing rod", length = 5000})
        return
    elseif (exports["soe-inventory"]:GetItemAmt(src, "lobworm", "left") < 1) then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You do not have any lobworm", length = 5000})
        return
    end
    TriggerClientEvent("Jobs:Client:DoFishing", src)
end)

-- REQUESTED FROM SERVER AFTER A REEL-IN HAPPENS
RegisterNetEvent("Jobs:Server:FishingReward")
AddEventHandler("Jobs:Server:FishingReward", function(mySpot)
    local src = source
    -- GET APPROPRIATE LOOT TABLE BASED OFF SPOT
    local myReward = false
    for spot, reward in pairs(fishingRewards) do
        if (spot == mySpot.rarity) then
            myReward = reward
            break
        end
    end

    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    if myReward then
        -- 25% CHANCE OF A TRASH/RARE ITEM BEING FOUND
        if exports["soe-utils"]:GetRandomChance(25) then
            -- RANDOMIZE TRASH ITEM BEING FOUND
            math.randomseed(os.time())
            local randomTrash = trashFishingRewards[math.random(1, #trashFishingRewards)]
            if exports["soe-inventory"]:AddItem(src, "char", charID, randomTrash.hash, 1, "{}") then
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "You got your lobworm back!", length = 5000})
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = ("You caught 1x %s!"):format(randomTrash.name), length = 5500})
                exports["soe-logging"]:ServerLog("Fishing Trash Reward", ("HAS CAUGHT %s WITH RARITY OF %s"):format(randomTrash.hash, mySpot.rarity), src)
            end
        else
            -- REMOVE LOBWORM
            exports["soe-inventory"]:RemoveItem(src, 1, "lobworm")
            if exports["soe-utils"]:GetRandomChance(90) then
                -- RANDOMIZE FISH BEING CAUGHT
                math.randomseed(os.time())
                local randomReward = myReward[math.random(1, #myReward)]
                if exports["soe-inventory"]:AddItem(src, "char", charID, randomReward.hash, 1, "{}") then
                    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = ("You caught 1x %s!"):format(randomReward.name), length = 5500})
                    exports["soe-logging"]:ServerLog("Fishing Reward", ("HAS CAUGHT %s WITH RARITY OF %s"):format(randomReward.hash, mySpot.rarity), src)
                end
            else
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "The fish got away with the lobworm!", length = 5500})
            end
        end

        -- CHANCE OF FISHING ROD BREAKING
        math.randomseed(os.time())
        local chance = math.random(100)
        if (chance >= 99) then
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Your fishing rod broke!", length = 8500})
            exports["soe-inventory"]:RemoveItem(src, 1, "fishingrod")
        end
    end
end)
