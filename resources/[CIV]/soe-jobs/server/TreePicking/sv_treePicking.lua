-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, SEND UPDATED TREE LIST TO ALL CLIENTS
RegisterNetEvent("Jobs:Server:TreePicking:GetTreeData")
AddEventHandler("Jobs:Server:TreePicking:GetTreeData", function()
    local src = source 
    TriggerClientEvent("Jobs:Client:TreePicking:UpdateTreeList", src, treePicking.PickableTrees)
end)

-- UPDATE SERVER TREE DATA WITH CLIENT DATA
RegisterNetEvent("Jobs:Server:TreePicking:UpdateTree")
AddEventHandler("Jobs:Server:TreePicking:UpdateTree", function(treeIndex, picked)
    treePicking.PickableTrees[treeIndex].picked = true
    treePicking.PickableTrees[treeIndex].lastPicked = os.time()

    -- SEND UPDATED TREE LIST TO ALL CLIENTS
    TriggerClientEvent("Jobs:Client:TreePicking:UpdateTreeList", -1, treePicking.PickableTrees)
end)

-- REQUESTED FROM CLIENT TO GIVE PICK TREE REWARDS
RegisterNetEvent("Jobs:Server:TreePicking:PickTree")
AddEventHandler("Jobs:Server:TreePicking:PickTree", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 929 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 930 | Lua-Injecting Detected.", 0)
        return
    end

    -- CHECK IF TREE INDEX WAS SENT TO PREVENT ERROR
    if not data.treeIndex then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Something went wrong doing this! Tree index was not specified!", length = 5000})
        return
    end

    -- GIVE ORANGES
    math.randomseed(os.time())
    local amount = math.random(3, 5)
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    if exports["soe-inventory"]:AddItem(src, "char", charID, treePicking.PickableTrees[data.treeIndex].itemName, amount, "{}") then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = ("You got %sx %s!"):format(amount, treePicking.PickableTrees[data.treeIndex].name), length = 5000})
    end
end)
