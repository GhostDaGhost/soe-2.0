local trees = {}

-- CALLED FROM CLIENT TO GIVE WOOD TO PLAYER
RegisterNetEvent("Jobs:Server:HarvestWood")
AddEventHandler("Jobs:Server:HarvestWood", function(grid)
    local src = source
    -- ADD THE TREE TO OUR LIST FOR COOLDOWN SOON
    if (trees[grid] == nil) then
        trees[grid] = {logs = 5, lastDamaged = GetGameTimer()}
    end

    -- IF THE TREE ISN'T ALREADY ON COOLDOWN
    if (trees[grid].logs - 1 >= 0) then
        trees[grid].logs = trees[grid].logs - 1
        trees[grid].lastDamaged = GetGameTimer()

        local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
        if exports["soe-inventory"]:AddItem(src, "char", charID, "logs", 1, "{}") then
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "You harvest a log", length = 1500})
        end
    else
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You cannot cut more from this tree", length = 2500})
    end
end)
