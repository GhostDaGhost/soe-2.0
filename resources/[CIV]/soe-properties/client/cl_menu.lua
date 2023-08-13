-- LOCAL VARIABLES
local isBreaching = false
local SOEMenu = assert(MenuV)
local housingMenuMain = SOEMenu:CreateMenu("Properties", 'VIEW AND/OR MANAGE THIS PROPERTY', 'topright', 255, 255, 255, 'size-100', 'default', 'menuv', 'housingMenuMain', 'native')
local financeReturn, loanStatus, accessData = nil, nil, nil
-- GLOBAL VARIABLES
isMenuOpen = false
menuProperty = nil

-- **********************
--    Local Functions
-- **********************
-- PROCESS TRANSACTION FOR HOUSE
local function ProcessHouseTransaction(property, type, downpayment)
    local payment = nil
    if type == "buy" then
        payment = exports["soe-shops"]:NewTransaction(property.price, "Purchased Property - " .. property.address)
    elseif type == "loan" then
        payment = exports["soe-shops"]:NewTransaction(downpayment, "Downpayment for Property - " .. property.address)
    end
    if payment then
        print("SUCCESS ON TRANSACTION SIDE, SETTING PROPERTY OWNERSHIP")
        TriggerServerEvent("Housing:Server:PurchaseProperty", property.id)
        return true
    end
    print("FAILURE ON THE TRANSACTION SIDE, NOT SETTING OWNERSHIP")
    return false
end

-- **********************
--    Global Functions
-- **********************
-- CLOSE ANY INSTANCE OF THE HOUSING MENU
function CloseHousingMenu()
    isMenuOpen = false
    menuProperty = nil
    SOEMenu:CloseAll()
end

housingMenuMain:On('close', function(menu)
    isMenuOpen = false
end)

-- **********************
--       Commands
-- **********************
-- ACCEPT LOAN OFFER
RegisterCommand("acceptoffer", function()
    if financeReturn then
        loanStatus = true
    end
end)

-- DECLINE LOAN OFFER
RegisterCommand("declineoffer", function()
    if financeReturn then
        loanStatus = false
    end
end)

-- **********************
--        Events
-- **********************
-- MAIN EVENT TO OPEN HOUSING MENU
RegisterNetEvent("Housing:Client:OpenHousingMenu")
AddEventHandler("Housing:Client:OpenHousingMenu", function(propertyId, accessType)
    if isMenuOpen then return end

    -- GET CHARACTER AND PROPERTY
    local char = exports["soe-uchuu"]:GetPlayer()
    local property = GetPropertyByID(propertyId)
    -- CLEAR MENU IF ALREADY EXISTS AND SET TITLE TO ADDRESS
    housingMenuMain:ClearItems()
    housingMenuMain:SetTitle(property.address)
    -- SET SUBTITLE BASED ON OWNERSHIP TYPE
    if accessType == "UNOWNED" or accessType == "NONE" then
        housingMenuMain:SetSubtitle("IS THIS YOUR DREAM HOME? IT'S FOR SALE!")
    elseif accessType == "NOACCESS" then
        housingMenuMain:SetSubtitle("I WONDER WHO OWNS THIS...")
    elseif accessType == "UNLOCKED" then
        housingMenuMain:SetSubtitle("LOOKS LIKE THE DOOR IS UNLOCKED!")
    elseif accessType == "GUEST" then
        housingMenuMain:SetSubtitle("GOOD THING I HAV A KEY!")
    elseif accessType == "TENANT" then
        housingMenuMain:SetSubtitle("HOME SWEET HOME!")
    elseif accessType == "OWNER" then
        housingMenuMain:SetSubtitle("HOME SWEET HOME!")
    end
    print(accessType)
    -- IF HOUSE IS UNOWNED
    if accessType == "UNOWNED" then
        -- PREVIEW HOUSE
        local previewButton = housingMenuMain:AddButton({ icon = '🔍', label = "Take a Tour of This Property", select = function()
            TriggerEvent("Housing:Client:EnterShell", propertyId)
            CloseHousingMenu()
        end})
        -- PURCHASE HOUSE
        local housingBuyMenu = SOEMenu:InheritMenu(housingMenuMain, {
            ["title"] = property.address,
            ["subtitle"] = "IT COULD BE YOURS FOR JUST $" .. property.price
        })
        local purchaseButton = housingMenuMain:AddButton({ icon = '💰', label = "Purchase This Property", value = housingBuyMenu})
        -- BUY THE HOUSE IN FULL
        local buyFullButton = housingBuyMenu:AddButton({ icon = '💵', label = "Pay In Full", select = function()
            print("OPENING TRANSACTION UI AND STARTING TRANSACTION")
            if ProcessHouseTransaction(property, "buy") then
                print("TRANSACTION SUCCESSFUL")
                CloseHousingMenu()
            end
            print("TRANSACTION UNSUCCESSFUL")
        end})
        -- BUY THE HOUSE VIA LOAN (SUBMENU)
        local buyLoanButton = housingBuyMenu:AddButton({ icon = '📝', label = "Apply For A Loan", select = function()
            local downpayment, length
            -- DOWNPAYMENT
            exports["soe-input"]:OpenInputDialogue("number", "What is the down payment you'd like to make (How much you'll pay today)?", function(downpaymentResponse)
                if tonumber(downpaymentResponse) then
                    downpayment = tonumber(downpaymentResponse)
                end
            end)
            Wait(500)
            -- LOAN TERM
            exports["soe-input"]:OpenSelectDialogue("What is the desired loan term?", {"6 Weeks", "12 Weeks", "24 Weeks", "36 Weeks", "48 Weeks", "60 Weeks", "72 Weeks"}, function(termResponse)
                if termResponse then
                    termResponse = string.gsub(termResponse, " Weeks", "")
                    length = tonumber(termResponse)
                end
            end)

            -- ISSUES WITH APPLICATION
            if not length or not downpayment then
                TriggerEvent("Chat:Client:Message", "[Bank]", "Sorry, but we can't process your application for a loan at this time. Try again later.", "bank")
                return
            elseif length > 72 then
                TriggerEvent("Chat:Client:Message", "[Bank]", "The length you've selected doesn't really work for us. Re-apply again with a shorter length.", "bank")
                return
            elseif length < 6 then
                TriggerEvent("Chat:Client:Message", "[Bank]", "The length you've selected doesn't really work for us. Re-apply again with a longer length.", "bank")
                return
            elseif downpayment < property.price * .10 then
                TriggerEvent("Chat:Client:Message", "[Bank]", "We'd prefer you pay at least 10% downpayment. Re-apply with at least 10% downpayment and we'll reconsider.", "bank")
                return
            end
            local totalLoanNeeded = property.price - downpayment

            -- GET FINANCE TERMS
            financeReturn = exports["soe-nexus"]:TriggerServerCallback("Housing:Server:GetFinanceTerms", char.CharID, totalLoanNeeded, length)
            local totalLoan = (property.price - downpayment) * (1.0 + tonumber(financeReturn.apr))

            -- SEND CHAT MESSAGE WITH LOAN DETAILS
            TriggerEvent("Chat:Client:SendMessage", "linebreak2")
            TriggerEvent("Chat:Client:SendMessage", "center", "^*^_^2FINANCE TERMS | $" .. totalLoan .. " TOTAL | " .. length .. " MONTHS")
            TriggerEvent("Chat:Client:Message", "^*^2Interest Rate:", "^r" .. tonumber(financeReturn.apr) * 100 .. "%", "blank")
            TriggerEvent("Chat:Client:Message", "^*^2Weekly Payments:", "^r$" .. tonumber(financeReturn.perweek), "blank")
            TriggerEvent("Chat:Client:Message", "", "^*^1Credit Decision Negative Factors:", "blank")
            for _, factor in pairs(financeReturn.factors) do
                if factor.type == "Negative" then
                    TriggerEvent("Chat:Client:Message", "", factor.note, "blank")
                end
            end
            TriggerEvent("Chat:Client:Message", "", "^*^2Credit Decision Positive Factors:", "blank")
            for _, factor in pairs(financeReturn.factors) do
                if factor.type == "Positive" then
                    TriggerEvent("Chat:Client:Message", "", factor.note, "blank")
                end
            end
            TriggerEvent("Chat:Client:Message", "", "Use ^*^2/acceptoffer^r or ^*^1/declineoffer^r to accept/decline this loan offer!", "blank")
            -- WAIT FOR COMMAND
            local loopIndex = 0
            while loanStatus == nil and loopIndex <= 3000 do
                Wait(100)
                loopIndex = loopIndex + 1
            end
            -- ONCE COMMAND IS BACK
            if loanStatus == nil then
                financeReturn, loanStatus = nil
                TriggerEvent("Chat:Client:Message", "[Bank]", "Thank you for your interest, but we will have to revoke this offer. Please re-apply if you'd like to try again.", "bank")
                return
            elseif loanStatus == false then
                financeReturn, loanStatus = nil
                TriggerEvent("Chat:Client:Message", "[Bank]", "We're sorry to see you don't like this offer. Please feel free to re-apply in the future.", "bank")
                return
            end
            
            -- PURCHASE HOUSE USING DOWNPAYMENT
            if ProcessHouseTransaction(property, "loan", downpayment) then
                TriggerServerEvent("Housing:Server:InsertNewLoan", char.CharID, totalLoan, financeReturn.perweek, tonumber(financeReturn.apr), propertyId)
                CloseHousingMenu()
            else
                TriggerEvent("Chat:Client:Message", "[Bank]", "We were unable to process the transaction. Please feel free to re-apply.", "bank")
                return
            end
            financeReturn, loanStatus = nil
        end})
    end
    -- IF PLAYER HAS ACCESS TO HOUSE OR IF IT IS UNLOCKED
    if accessType == "UNLOCKED" or accessType == "GUEST" or accessType == "TENANT" or accessType == "OWNER" then
        -- ENTER HOUSE
        local enterButton = housingMenuMain:AddButton({icon = '🚪', label = "Enter Property", select = function()
            TriggerEvent("Housing:Client:EnterShell", propertyId)
            CloseHousingMenu()
        end})
    end

    if (exports["soe-jobs"]:GetMyJob() == "POLICE" or exports["soe-jobs"]:GetMyJob() == "EMS") then
        -- ENTER HOUSE
        local breachButton = housingMenuMain:AddButton({icon = '🔨', label = "Breach Property", select = function()
            CloseHousingMenu()
            if isBreaching then return end
            isBreaching = true
            exports["soe-utils"]:Progress(
                {
                    name = "breachingPersonalHouse",
                    duration = 500,
                    label = "Breaching",
                    useWhileDead = false,
                    canCancel = false,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true
                    },
                    animation = {
                        animDict = "missprologuemcs_1",
                        anim = "kick_down_player_zero",
                        flags = 1
                    }
                },
                function(cancelled)
                    isBreaching = false
                    ClearPedTasks(PlayerPedId())
                    if not cancelled then
                        TriggerEvent("Housing:Client:EnterShell", propertyId)
                    end
                end
            ) 
        end})

        -- OPEN GARAGE
        local breachGarageButton = housingMenuMain:AddButton({ icon = '🔨', label = "Breach Garage", select = function()
            exports["soe-valet"]:ShowValet("property-" .. propertyId, char.CharID)
            CloseHousingMenu()
        end})
    end

    -- IF PLAYER OWNS OR IS A TENANT OF THE HOUSE
    if accessType == "OWNER" or accessType == "TENANT" then
        -- ACCESS GARAGE - COMING SOON
        local garageButton = housingMenuMain:AddButton({ icon = '🚗', label = "Access Garage", select = function()
            exports["soe-valet"]:ShowValet("property-" .. propertyId, char.CharID)
            CloseHousingMenu()
        end})
        -- LOCK DOOR - COMING SOON
        local lockButton = housingMenuMain:AddButton({ icon = '🔒', label = "Toggle Property Locks", select = function()
            CloseHousingMenu()
        end})
    end

    -- IF PLAYER OWNS THE HOUSE
    if accessType == "OWNER" then
        -- MANAGE ACCESS SUBMENU START
        local accessManageMenu = SOEMenu:InheritMenu(housingMenuMain, {
            ["title"] = property.address,
            ["subtitle"] = "LANDLORD SIMULATOR 2021"
        })
        local manageButton = housingMenuMain:AddButton({ icon = '🔑', label = "Manage Property Access", value = accessManageMenu})
        -- NEW ACCESS BUTTON
        local addNewButton = accessManageMenu:AddButton({ icon = '🔑', label = "Create a New Key", select = function()
            CloseHousingMenu()
            local charID, newAccessType
            exports["soe-input"]:OpenInputDialogue("number", "Enter the SSN of the person you wish to give a key to:", function(returnData)
                if not tonumber(returnData) then
                    exports["soe-ui"]:SendAlert("error", "Invalid SSN enetered!", 5000)
                    return
                end
                charID = returnData
            end)
            Wait(500)
            exports["soe-input"]:OpenInputDialogue("number", "What type of key do you want to give this person? Enter the number!<br>[1] TENANT<br>[2] GUEST", function(returnData)
                if not tonumber(returnData) or tonumber(returnData) < 1 or tonumber(returnData) > 2 then
                    exports["soe-ui"]:SendAlert("error", "Invalid access type entered!", 5000)
                    return
                end
                newAccessType = returnData
                TriggerServerEvent("Housing:Server:UpdatePropertyAccess", charID, propertyId, tonumber(newAccessType))
            end)
        end})

        -- GET ACCESS DATA FOR OTHER PEOPLE WITH ACCESS TO HOUSE
        accessData = exports["soe-nexus"]:TriggerServerCallback("Housing:Server:RequestPropertyAccessInfo", propertyId)

        -- BUTTON FOR EACH ACCESS ENTRY EXCEPT THE OWNER
        for _, data in pairs(accessData) do
            if data.CharID ~= tonumber(char.CharID) then
                local button = accessManageMenu:AddButton({ icon = '🔑', label = "Manage " .. data.Name .. "'s access (SSN: " .. data.CharID .. ")", select = function()
                    CloseHousingMenu()
                    exports["soe-input"]:OpenInputDialogue("number", "Choose what type of access you want " .. data.Name .. " to have? Enter the number!<br>[1] TENANT<br>[2] GUEST<br>[3] NONE/REMOVE", function(newAccessType)
                        if tonumber(newAccessType) and tonumber(newAccessType) >= 1 and tonumber(newAccessType) <= 3 then
                            TriggerServerEvent("Housing:Server:UpdatePropertyAccess", data.CharID, propertyId, tonumber(newAccessType))
                        else
                            exports["soe-ui"]:SendAlert("error", "Invalid access type selected!", 5000)
                        end
                    end)
                end})
                button.Description = data.Name .. "'s current access: " .. data.Access
                Wait(10)
            end
        end
        -- MANAGE ACCESS SUBMENU END

        -- SELL HOUSE TO STATE
        local sellButton = housingMenuMain:AddButton({ icon = '🏷️', label = "Sell Property (To State)", select = function()
            local text = string.format("Are you sure you want to sell this property to the state? You will receive $%s for it.", math.ceil(GetPropertyByID(propertyId).price * 0.2))
            exports["soe-input"]:OpenConfirmDialogue(text, "Sell It", "Keep It", function(returnData)
                if returnData then
                    TriggerServerEvent("Housing:Server:SellProperty", propertyId)
                    CloseHousingMenu()
                end
            end)
        end})

        -- TRANSFER HOUSE TO ANOTHER PLAYER
        local transferButton = housingMenuMain:AddButton({ icon = '🔀', label = "Transfer Property", select = function()
            local newOwner
            exports["soe-input"]:OpenInputDialogue("number", "Who would you like to transfer ownership of the property to? Please enter their SSN!", function(newOwnerResponse)
                if tonumber(newOwnerResponse) then
                    newOwner = tonumber(newOwnerResponse)
                else
                    newOwner = 0
                end
            end)

            while newOwner == nil do
                Wait(10)
            end

            if newOwner > 0 then
                local text = ("Are you sure you want to transfer property ownership of %s to SSN %s? You will not receive any funds and will need to collect any payment separately!"):format(property.address, newOwner)
                exports["soe-input"]:OpenConfirmDialogue(text, "Transfer It", "Keep It", function(returnData)
                    if returnData then
                        local char = exports["soe-uchuu"]:GetPlayer()
                        TriggerServerEvent("Housing:Server:UpdatePropertyAccess", char.CharID, propertyId, 3)
                        TriggerServerEvent("Housing:Server:UpdatePropertyAccess", newOwner, propertyId, 0)
                        exports["soe-ui"]:SendAlert("success", "You,ve successfully transferred this property to SSN " .. newOwner, 2500)
                        CloseHousingMenu()
                    end
                end)
            end
        end})
    end
    -- DOORBELL BUTTON (ANYBODY CAN ACCESS)
    local ringButton = housingMenuMain:AddButton({ icon = '🔔', label = "Ring Property Doorbell", select = function()
        CloseHousingMenu()
        -- RING AT THE FRONT DOOR
        exports["soe-utils"]:PlayProximitySoundFromCoords(vector3(property.entrance.x, property.entrance.y, property.entrance.z), 3.0, "Doorbell.ogg", 0.25)
        Wait(100)
        -- RING INSIDE THE INTERIOR
        local intCoords = GetCoordsFromPropertyOffset(propertyId, shellData[property.shell].doorOffset.x, shellData[property.shell].doorOffset.y, shellData[property.shell].doorOffset.z)
        exports["soe-utils"]:PlayProximitySoundFromCoords(vector3(intCoords.x, intCoords.y, intCoords.z), 25.0, "Doorbell.ogg", 0.25)
    end})
    -- SHOW HOUSE INFO
    local infoButton = housingMenuMain:AddButton({ icon = '🏠', label = "View Property Information", select = function()
        TriggerEvent("Chat:Client:SendMessage", "properties", string.format("The address of this property is %s. It's valued at $%s.", GetPropertyByID(propertyId).address, GetPropertyByID(propertyId).price))
        CloseHousingMenu()
    end})
    -- OPEN MENU
    housingMenuMain:Open()
    isMenuOpen = true
    menuProperty = propertyId
end)
