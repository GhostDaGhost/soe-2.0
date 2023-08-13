local jewelryAlarm = false

-- SYNC SHOWCASE STATE
RegisterNetEvent("Crime:Server:SetShowcaseState")
AddEventHandler("Crime:Server:SetShowcaseState", function(case, location, pos, state)
    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    jewelryCases[case].broken = state
    TriggerClientEvent("Crime:Client:SetShowcaseState", -1, case, true)

    -- RANDOMIZE LOOT GENERATOR
    math.randomseed(GetGameTimer())
    local item = jewelryLoot[math.random(1, #jewelryLoot)]
    local amount = math.random(item.min, item.max)
    if exports["soe-inventory"]:AddItem(src, "char", charID, item.hash, amount, "{}") then
        exports["soe-logging"]:ServerLog("Jewelry Robbery Loot", ("GOT %s %s FROM JEWELRY STORE CASE"):format(amount, item.hash), src)
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = ("You got %sx %s!"):format(amount, item.name), length = 5500})
    end

    -- SEND CAD ALERT
    if not jewelryAlarm then
        jewelryAlarm = true
        TriggerEvent("Crime:Server:SendRobberyAlert", location, pos, "Vangelico Jewelry Store")
    end

    -- START 15 MINUTE COOLDOWN
    if not cooldown then
        cooldown = true
        print("DEBUG: JEWELRY STORE COOLDOWN ACTIVATED")
        SetTimeout(900000, function()
            for case in pairs(jewelryCases) do
                jewelryCases[case].broken = false
                TriggerClientEvent("Crime:Client:SetJewelryAlarm", -1, false)
                TriggerClientEvent("Crime:Client:SetShowcaseState", -1, case, false)
            end
            cooldown, jewelryAlarm = false, false
            print("DEBUG: JEWELRY STORE COOLDOWN FINISHED")
        end)
    end
end)
