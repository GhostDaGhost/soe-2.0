-- **********************
--       Commands
-- **********************
-- WHEN TRIGGERED, OPEN BILLS UI
RegisterCommand("bills", function(source)
    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    TriggerClientEvent("Bills:Client:OpenUI", src, charID)
end)

RegisterCommand("loans", function(source)
    local src = source
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
    TriggerClientEvent("Loans:Client:OpenUI", src, charID)
end)

-- **********************
--        Events
-- **********************
AddEventHandler("Bills:Server:GetData", function(cb, src, charID)
    local bills = exports["soe-nexus"]:PerformAPIRequest("/api/bills/get", "charid=" .. charID, true)

    if bills and bills.status then
        cb(bills.data)
    else
        cb({})
    end
end)

AddEventHandler("Loans:Server:GetData", function(cb, src, charID)
    local loans = exports["soe-nexus"]:PerformAPIRequest("/api/loans/get", "charid=" .. charID, true)

    if loans and loans.status then
        cb(loans.data)
    else
        cb({})
    end
end)

AddEventHandler("Bills:Server:PayBill", function(cb, src, charID, billID)
    local payBill = exports["soe-nexus"]:PerformAPIRequest("/api/bills/pay", ("charid=%s&billid=%s"):format(charID, billID), true)

    if payBill then
        cb(payBill)
    else
        cb({["status"] = false})
    end
end)

AddEventHandler("Loans:Server:PayLoan", function(cb, src, charID, loanID, amt)
    local payLoan = exports["soe-nexus"]:PerformAPIRequest("/api/loans/pay", ("charid=%s&loanid=%s&amt=%s"):format(charID, loanID, amt), true)

    if payLoan then
        cb(payLoan)
    else
        cb({["status"] = false})
    end
end)
