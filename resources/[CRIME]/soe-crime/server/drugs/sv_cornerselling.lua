local customerMessages = {
    "Eyyy this is the good shit! Appreciate it homie.",
    "Time to hit all this up at home. Thanks.",
    "You never saw me. You never spoke to me. Thank you for your kindness.",
    "Here... thats all I got right now in my pocket. This is gonna be soothing."
}

-- PERFORMS DRUG SALE ACTIONS
local function DoCornerDrugSale(product, amount, price)
    local src = source
    -- INVENTORY ITEM NAME MATCHING
    local myProduct = nil
    if (product == "meth") then
        myProduct = "gramofmeth"
    elseif (product == "weed") then
        myProduct = "weed_smallbag"
    elseif (product == "coke") then
        myProduct = "cocainevial"
    elseif (product == "shrooms") then
        myProduct = "shrooms"
    elseif (product == "crack") then
        myProduct = "crack_smallbag"
    end

    -- IF THIS SOMEHOW HAPPENS, ERROR OUT
    if not myProduct then print("Fatal error with processing corner selling drug transaction.") return end

    -- GIVE THE SOURCE THEIR CASH AND REMOVE THE DRUG ITEM DEPENDING ON THE CUSTOMER'S AMOUNT
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    if exports["soe-inventory"]:AddItem(src, "char", charID, "cash", tonumber(price), "{}") then
        exports["soe-inventory"]:RemoveItem(src, tonumber(amount), myProduct)
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "You accepted this offer", length = 5000})
        TriggerClientEvent("Chat:Client:Message", src, "[Drugs]", ("You sold %s %s for $%s."):format(amount, drugsPrices[product].name, price), "bank")

        -- MAKE A CUSTOMER CHAT MESSAGE
        math.randomseed(os.time())
        local customerMsg = customerMessages[math.random(1, #customerMessages)]
        TriggerClientEvent("Chat:Client:Message", src, "[Customer]", customerMsg, "bank")
        exports["soe-logging"]:ServerLog("Corner Selling Drug Transaction", ("HAS SOLD %s %s FOR $%s"):format(amount, drugsPrices[product].name, price), src)
    end
end

RegisterCommand("cornersell", function(source, args)
    local src = source
    if (args[1] == "weed" or args[1] == "coke" or args[1] == "meth" or args[1] == "shrooms" or args[1] == "crack") then
        local hasEnough = false
        if (args[1] == "meth") then
            if (exports["soe-inventory"]:GetItemAmt(src, "gramofmeth", "left") >= 1) then hasEnough = true end
        elseif (args[1] == "weed") then
            if (exports["soe-inventory"]:GetItemAmt(src, "weed_smallbag", "left") >= 1) then hasEnough = true end
        elseif (args[1] == "coke") then
            if (exports["soe-inventory"]:GetItemAmt(src, "cocainevial", "left") >= 1) then hasEnough = true end
        elseif (args[1] == "shrooms") then
            if (exports["soe-inventory"]:GetItemAmt(src, "shrooms", "left") >= 1) then hasEnough = true end
        elseif (args[1] == "crack") then
            if (exports["soe-inventory"]:GetItemAmt(src, "crack_smallbag", "left") >= 1) then hasEnough = true end
        end

        if hasEnough then
            TriggerClientEvent("Crime:Client:ToggleCornerSell", src, args[1])
        else
            TriggerClientEvent("Crime:Client:ToggleCornerSell", src, "none")
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You don't have enough of this product", length = 5000})
        end
    else
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Invalid product type", length = 5000})
    end
end)

-- CALLED FROM CLIENT AFTER A DRUG SALE IS DONE
RegisterNetEvent("Crime:Server:DoCornerDrugSale")
AddEventHandler("Crime:Server:DoCornerDrugSale", DoCornerDrugSale)
