local isOpen = false

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, OPEN BILLS UI
local function OpenBillsUI(charID)
    local myBills = exports["soe-nexus"]:TriggerServerCallback("Bills:Server:GetData", charID)

    SetNuiFocus(true, true)
    SendNUIMessage({type = "openBillsUI", billData = myBills})
    isOpen = true
end

-- WHEN TRIGGERED, OPEN LOANS UI
local function OpenLoansUI(charID)
    local myLoans = exports["soe-nexus"]:TriggerServerCallback("Loans:Server:GetData", charID)

    SetNuiFocus(true, true)
    SendNUIMessage({type = "openLoansUI", loanData = myLoans})
    isOpen = true
end

-- **********************
--     NUI Callbacks
-- **********************
RegisterNUICallback("closeUI", function()
    SetNuiFocus(false, false)
    isOpen = false
end)

RegisterNUICallback("payBill", function(data)
    SetNuiFocus(false, false)
    isOpen = false

    local charID = exports["soe-uchuu"]:GetPlayer().CharID
    local bills = exports["soe-nexus"]:TriggerServerCallback("Bills:Server:GetData", charID)

    for _, bill in pairs(bills) do
        if (bill.BillID == data.bill) then
            local payment = exports["soe-shops"]:NewTransaction(bill.BillAmt, bill.BillNote)
            if payment then
                local billRepay = exports["soe-nexus"]:TriggerServerCallback("Bills:Server:PayBill", charID, bill.BillID)
                if billRepay.status then
                    exports["soe-ui"]:SendAlert("success", "Bill successfully paid!", 5000)
                else
                    exports["soe-ui"]:SendAlert("success", "An error occured when attempting to pay this bill!", 5000)
                end
            end
        end
    end
end)

RegisterNUICallback("payLoan", function(data)
    SetNuiFocus(false, false)
    isOpen = false

    local charID = exports["soe-uchuu"]:GetPlayer().CharID
    local loans = exports["soe-nexus"]:TriggerServerCallback("Loans:Server:GetData", charID)

    for _, loan in pairs(loans) do
        if (loan.LoanID == data.loan) then
            local payAmt = nil
            exports["soe-input"]:OpenInputDialogue("number", "How much do you want to pay towards this loan?", function(returnData)
                if returnData then
                    payAmt = tonumber(returnData) or 0
                else
                    payAmt = 0
                end
            end)

            while payAmt == nil do
                Wait(10)
            end

            if payAmt > (loan.TotalBalance - loan.AmountPaid) then
                payAmt = (loan.TotalBalance - loan.AmountPaid)
            end

            local confirmText = ("Are you sure you want to pay $%s towards your loan with ID %s? The new loan balance after this payment will be $%s"):format(payAmt, loan.LoanID, (loan.TotalBalance - loan.AmountPaid) - payAmt)
            exports["soe-input"]:OpenConfirmDialogue(confirmText, "Yes", "No", function(returnData)
                if returnData then
                    print("PAYING!")
                end
            end)

            Wait(500)

            local payment = exports["soe-shops"]:NewTransaction(payAmt, "Loan Payment - Loan ID " .. loan.LoanID)
            if payment then
                local loanRepay = exports["soe-nexus"]:TriggerServerCallback("Loans:Server:PayLoan", charID, loan.LoanID, payAmt)
                print(json.encode(loanRepay))
                if loanRepay.status then
                    exports["soe-ui"]:SendAlert("success", "You've put money towards reducing your loan!", 5000)
                else
                    exports["soe-ui"]:SendAlert("success", "An error occured when attempting to pay towards this loan!", 5000)
                end
            end
        end
    end
end)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, OPEN BILLS UI
RegisterNetEvent("Bills:Client:OpenUI", OpenBillsUI)
RegisterNetEvent("Loans:Client:OpenUI", OpenLoansUI)

-- WHEN TRIGGERED, RESET ALL NUI INSTANCES
AddEventHandler("UI:Client:ResetNUI", function()
    SendNUIMessage({type = "closeUI"})
end)

AddEventHandler("Uchuu:Client:CharacterSelected", function(charID)
    local bills = exports["soe-nexus"]:TriggerServerCallback("Bills:Server:GetData", charID)

    if (exports["soe-utils"]:GetTableSize(bills) > 0) then
        local name = exports["soe-uchuu"]:GetPlayer().FirstGiven or "there"
        TriggerEvent("Chat:Client:Message", "[Bank]", "Hi " .. name .. "! We notice you have an outstanding bill. Please be sure to review it and pay it as soon as possible using /bills!", "bank")
    end
end)
