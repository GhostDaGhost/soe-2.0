local chopShopList = {}

-- LIST OF VEHICLES THE CHOP SHOP CAN CHOOSE FROM
local targets = {"GAUNTLET", "PREMIER", "SULTAN", "RUINER", "PICADOR", "BUCCANEER", "DOMINATOR", 
"STANIER", "PANTO", "BUFFALO", "GRANGER", "GRESLEY", "MESA", "DUNE", "REBEL", "REBEL2", "KALAHARI", 
"SANCHEZ", "BATI", "SANCHEZ2", "BALLER", "BALLER2", "PATRIOT", "BLISTA", "HAKUCHOU", "FAGGIO2", 
"ORACLE", "BJXL", "RANCHERXL", "FUSILADE", "HABANERO", "ROCOTO", "SUPERD", "NINEF", "NINEF2", 
"SENTINEL", "SENTINEL2", "DUKES", "BFINJECTION", "BISON", "SADLER", "BOBCATXL"}

-- REFRESHES CHOP SHOP'S LIST EVERY 15 MINUTES
function RefreshChopShop()
    local genList = {}
    chopShopList = {}
    math.randomseed(os.time())
    while #chopShopList ~= 8 do
        Wait(150)
        -- RANDOMLY GENERATE A VEHICLE AND THEN CHECK FOR DUPLICATES
        local vehicle = math.random(1, #targets)
        if (genList[targets[vehicle]] == nil) then
            genList[targets[vehicle]] = true
            chopShopList[#chopShopList + 1] = targets[vehicle]
        end
    end
    TriggerClientEvent("Crime:Client:RequestChopShopList", -1, chopShopList)
end

--[[RegisterCommand("devrefreshchopshop", function(source)
    local src = source
    if exports["soe-uchuu"]:IsStaff(src) then
        RefreshChopShop()
    end
end)]]

-- REQUESTED FROM CLIENT TO SYNC THEIR CHOP LIST
RegisterNetEvent("Crime:Server:RequestChopShopList")
AddEventHandler("Crime:Server:RequestChopShopList", function()
    local src = source
    TriggerClientEvent("Crime:Client:RequestChopShopList", src, chopShopList)
end)

-- REQUESTED FROM CLIENT TO DELETE A VEHICLE FROM THE CHOP LIST
RegisterNetEvent("Crime:Server:ChopVehicle")
AddEventHandler("Crime:Server:ChopVehicle", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 42248-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 42248-2 | Lua-Injecting Detected.", 0)
        return
    end
    TriggerClientEvent("Chat:Client:Message", src, "[Chop Shop]", "Thank you! We'll take it from here.", "bank")

    local found
    for k, v in pairs(chopShopList) do
        if (v == data.veh) then
            found = k
            break
        end
    end

    if found then
        -- REMOVE VEHICLE FROM THE CHOP LIST AND SYNC ALL PLAYERS' LIST
        table.remove(chopShopList, found)
        TriggerClientEvent("Crime:Client:RequestChopShopList", -1, chopShopList)

        Wait(2500)
        local price = {min = 500, max = 800}
        if exports["soe-config"]:GetConfigValue("economy", "chopshop_" .. tostring(data.class)) then
            local amount = exports["soe-config"]:GetConfigValue("economy", "chopshop_" .. tostring(data.class))
            price = {min = amount.min, max = amount.max}
        end
        math.randomseed(os.time())
        math.random() math.random() math.random()
        price = math.random(price.min, price.max)

        -- GIVE THE SOURCE THEIR CASH AND REMOVE THE DRUG ITEM DEPENDING ON THE CUSTOMER'S AMOUNT
        local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
        if exports["soe-inventory"]:AddItem(src, "char", charID, "cash", price, "{}") then
            TriggerClientEvent("Chat:Client:Message", src, "[Chop Shop]", ("You earned $%s from chopping this vehicle."):format(price), "bank")
            exports["soe-logging"]:ServerLog("Chop Shop Reward", ("HAS CHOPPED %s FOR $%s"):format(data.veh, price), src)
        end
    end
end)
