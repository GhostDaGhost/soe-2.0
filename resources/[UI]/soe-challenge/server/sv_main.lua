RegisterNetEvent("Challenge:Server:BreakLockpick")
AddEventHandler("Challenge:Server:BreakLockpick", function()
    local src = source
    exports["soe-inventory"]:RemoveItem(src, 1, "lockpick")
end)

RegisterNetEvent("Challenge:Server:BreakDrillBit")
AddEventHandler("Challenge:Server:BreakDrillBit", function()
    local src = source
    exports["soe-inventory"]:RemoveItem(src, 1, "drillbit")
end)

RegisterNetEvent("Challenge:Server:UseScratchOff")
AddEventHandler("Challenge:Server:UseScratchOff", function(hasWon)
    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    exports["soe-inventory"]:RemoveItem(src, 1, "scratchoff")
    if hasWon then
        math.randomseed(os.time())
        local moneyWon = math.random(15, 30)
        if exports["soe-inventory"]:AddItem(src, "char", charID, "cash", moneyWon, "{}") then
            exports["soe-logging"]:ServerLog("Scratch-Off Ticket Win", "HAS WON A SCRATCH-OFF TICKET | AMOUNT: " .. moneyWon, src)
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = ("Your scratch-off ticket was a winner! You won $%s!"):format(moneyWon), length = 7500})
        end
    else
        exports["soe-logging"]:ServerLog("Scratch-Off Ticket Lost", "HAS LOST A SCRATCH-OFF TICKET", src)
        if exports["soe-inventory"]:AddItem(src, "char", charID, "scratchoff-lost", 1, "{}") then
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Your scratch-off ticket was a losing ticket", length = 7500})
        end
    end
end)
