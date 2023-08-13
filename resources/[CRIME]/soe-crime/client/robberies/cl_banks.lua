local action
local cooldown = 0
local bankRobbery = {}

-- DECORATORS
DecorRegister("isBankTeller", 3)

-- **********************
--    Local Functions
-- **********************
local function SyncBankVault()
    local vault = GetClosestObjectOfType(banks[action.bank].pos, 25.5, banks[action.bank].vault, 0, 0, 0)
    if DoesEntityExist(vault) and not bankRobbery.vaultOpening then
        local openHeading = banks[action.bank].vaultHeadings.open
        local closeHeading = banks[action.bank].vaultHeadings.closed
        if banks[action.bank].vaultOpen then
            if (GetEntityHeading(vault) ~= openHeading) then
                SetEntityHeading(vault, openHeading)
            end
        else
            if (GetEntityHeading(vault) ~= closeHeading) then
                SetEntityHeading(vault, closeHeading)
            end
        end
    end
end

-- OPENS THE VAULT DOOR
local function OpenVault()
    -- OPEN THE VAULT DOOR SLOWLY
    local loopIndex = 0
    local closingHdg = banks[action.bank].vaultHeadings.closed
    local vault = GetClosestObjectOfType(banks[action.bank].pos, 6.5, banks[action.bank].vault, 0, 0, 0)
    if DoesEntityExist(vault) then
        -- THE PALETO/GRAPESEED BANK VAULTS ARE A BIT WEIRD | DO SOMETHING SPECIAL FOR THEM
        if (action.bank == "Paleto Bay" or action.bank == "Grapeseed") then
            SetEntityHeading(vault, banks[action.bank].vaultHeadings.open)
            TriggerServerEvent("Crime:Server:UpdateBankVaultState", {bank = action.bank, state = true})
            return
        end

        -- FREEZE THE PLAYER TO MAKE SURE THEY STAY IN ZONE
        bankRobbery.vaultOpening = true
        FreezeEntityPosition(PlayerPedId(), true)
        while (closingHdg ~= banks[action.bank].vaultHeadings.open) do
            Wait(10)
            SetEntityHeading(vault, closingHdg - 10)
            closingHdg = closingHdg - 0.5

            -- FAILSAFE
            loopIndex = loopIndex + 1
            if (loopIndex >= 1550) then
                FreezeEntityPosition(PlayerPedId(), false)
                exports["soe-ui"]:SendAlert("error", "Something went wrong with the vault!", 5000)
                error("Opening vault loop was cancelled because it kept going and going and going. ERROR REPORT THIS! THIS MEANS THIS BANK VAULT GOT SCREWED :(")
                break
            end
        end
        bankRobbery.vaultOpening = false
        FreezeEntityPosition(PlayerPedId(), false)
        TriggerServerEvent("Crime:Server:UpdateBankVaultState", {bank = action.bank, state = true})
    end
end

-- GET CLOSEST ITEM DROPPED AND IF IN RANGE
local function GetClosestDepositBox()
    local currBox
    local currDist = 10000000
    local pos = GetEntityCoords(PlayerPedId())

    -- ITERATE
    if not action then return end
    for depositBoxID, depositBox in pairs(banks[action.bank].depositBoxes) do
        local dist = #(depositBox.pos - pos)
        if (dist < currDist) then
            currDist = dist
            currBox = depositBoxID
        end
    end

    -- IF CLOSE ENOUGH
    if (currDist <= 0.5) then
        return currBox
    end
    return nil
end

-- LISTENS IF PED HAS A WEAPON INSIDE THE BANK LOBBY
local function ListenForWeaponsInLobby()
    if bankRobbery.alreadyReported and bankRobbery.lastCheck then
        if (GetGameTimer() - bankRobbery.lastCheck >= 70000) then
            bankRobbery.alreadyReported = false
        end
    end

    if not bankRobbery.alreadyReported then
        if (GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("WEAPON_UNARMED")) then return end
        bankRobbery.lastCheck = GetGameTimer()
        bankRobbery.alreadyReported = true

        if not action then return end
        local desc = ("The bank teller at %s Bank is reporting a visible weapon being held by another individual in the lobby."):format(action.bank)
        TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = true, type = "Silent Alarm (Weapon)", desc = desc, code = "10-78", coords = banks[action.bank].pos})
    end
end

-- MAIN FUNCTION FOR POLICE SECURE OF VAULT
local function SecureTheVault()
    exports["soe-emotes"]:StartEmote("cashier")
    exports["soe-utils"]:Progress(
        {
            name = "securingVault",
            duration = math.random(8500, 9500),
            label = "Securing Vault",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = false
            }
        },
        function(cancelled)
            exports["soe-emotes"]:CancelEmote()
            if not cancelled then
                if action then
                    exports["soe-ui"]:HideTooltip()
                    TriggerServerEvent("Crime:Server:SecureBankVault", {bank = action.bank})
                else
                    print("'action' was nil. Error prevented. :P")
                    exports["soe-ui"]:SendAlert("error", "Not close enough! Try again!", 5000)
                end
            end
        end
    )
end

-- MAIN FUNCTION FOR ROBBING DEPOSIT BOXES
local function DoDepositBoxRobbery(depositBox)
    -- IF ALREADY ROBBING, RETURN
    if bankRobbery.isRobbing then return end

    -- RETURN IF PLAYER DOES NOT HAVE A DRILL
    if not exports["soe-inventory"]:HasInventoryItem("drill") then
        exports["soe-ui"]:SendAlert("error", "You need a drill for this!", 5000)
        return
    end

    -- RETURN IF PLAYER DOES NOT HAVE A DRILL BIT EITHER
    if not exports["soe-inventory"]:HasInventoryItem("drillbit") then
        exports["soe-ui"]:SendAlert("error", "You need a drill bit for your drill!", 5000)
        return
    end

    -- CHECK IF THERE'S A NEARBY PLAYER TO STOP DOUBLE-DRILLING
    if exports["soe-utils"]:GetClosestPlayer(1) then
        exports["soe-ui"]:SendAlert("error", "Someone is too close to you!", 5000)
        return
    end

    if (cooldown > GetGameTimer()) then
        exports["soe-ui"]:SendAlert("error", "Wait a bit before doing that again", 5000)
        return
    end

    cooldown = GetGameTimer() + 3000
    local canRobBox = exports["soe-nexus"]:TriggerServerCallback("Crime:Server:BankRequirementCheck", "Deposit Box", action.bank, depositBox)
    if canRobBox then
        exports["soe-ui"]:SendAlert("warning", "Getting drill out of my pockets...", 5000)

        -- SEND THIS TO SERVER-SIDE THAT WE BEGUN DRILLING
        local pos = GetEntityCoords(PlayerPedId())
        local location = exports["soe-utils"]:GetLocation(pos)
        TriggerServerEvent("Crime:Server:InitBankRobbery", {type = "Vault", response = "Panic", bank = action.bank, pos = pos, location = location})

        -- START DRILL MINIGAME
        bankRobbery.isRobbing = true
        if exports["soe-challenge"]:StartDrilling() then
            math.randomseed(GetGameTimer())
            math.random() math.random() math.random()
            if (math.random(1, 100) <= 35) then
                exports["soe-ui"]:SendAlert("error", "You broke the drill bit while pulling out!", 5000)
                TriggerServerEvent("Challenge:Server:BreakDrillBit")
            end

            bankRobbery.isRobbing = false
            TriggerServerEvent("Crime:Server:FinishBankRobbery", {type = "Deposit Box", bank = action.bank, depositBox = depositBox})
        else
            bankRobbery.isRobbing = false
            exports["soe-ui"]:SendAlert("error", "You stopped drilling", 5000)
        end
    end
end

-- VAULT-ATTEMPTS MAIN FUNCTION
local function AttemptToOpenVault()
    -- CHECK IF BANK CAN BE ROBBED
    if bankRobbery.isRobbing then return end
    if bankRobbery.usingPanel then return end

    -- CHECK IF THERE'S A NEARBY PLAYER TO STOP DOUBLE-OPENING
    if exports["soe-utils"]:GetClosestPlayer(2) then
        exports["soe-ui"]:SendAlert("error", "Someone is too close to you!", 5000)
        return
    end

    local canUnlockVault = exports["soe-nexus"]:TriggerServerCallback("Crime:Server:BankRequirementCheck", "Vault", action.bank)
    if canUnlockVault then
        banks = exports["soe-nexus"]:TriggerServerCallback("Crime:Server:SyncBanks")

        if not action then return end
        local myBank = banks[action["bank"]]
        -- GIVE SOME OPTIONS ON HOW WE UNLOCK THIS VAULT
        -- WE COULD GO WITH HACKING, OR IF WE HAVE BANK CARDS (INSTANT ACCESS), OR PERHAPS THERMITE DOWN THE ROAD

        -- IF WE GOT BANK CARDS | LETS DO THAT FIRST
        local card = myBank["bankCardNeeded"]
        if card then
            local hasKey = exports["soe-inventory"]:HasInventoryItem("bankvaultkey")
            local hasCard = exports["soe-inventory"]:HasInventoryItem(card["name"])

            if not hasCard then
                exports["soe-ui"]:SendAlert("error", "You need a " .. card["label"], 5000)
                return
            end

            if not hasKey then
                exports["soe-ui"]:SendAlert("error", "You need a Bank Vault Panel Key!", 5000)
                return
            end

            if hasCard and hasKey then
                bankRobbery.usingPanel = true
                exports["soe-emotes"]:StartEmote("atm")
                exports["soe-ui"]:SendAlert("success", ("You insert a %s and a bank key into the panel..."):format(card["label"]), 9000)

                -- SEND OUT A SILENT ALARM THAT A REPORTED STOLEN BANK CARD WAS USED
                local pedCoords = GetEntityCoords(PlayerPedId())
                local desc = ("Security cameras at %s Bank is reporting a suspicious individual touching the vault controls."):format(action["bank"])
                TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = true, type = "Silent Alarm (Vault Opening)", desc = desc, code = "10-78", coords = pedCoords})

                exports["soe-utils"]:Progress(
                    {
                        name = "openingVault",
                        duration = math.random(12500, 15500),
                        label = "Opening Vault",
                        useWhileDead = false,
                        canCancel = true,
                        controlDisables = {
                            disableMovement = true,
                            disableCarMovement = false,
                            disableMouse = false,
                            disableCombat = false
                        }
                    },
                    function(cancelled)
                        bankRobbery.usingPanel = false
                        exports["soe-emotes"]:CancelEmote()
                        if not cancelled then
                            TriggerServerEvent("Crime:Server:TakeBankCardsAndKey", {card = card["name"]})
                            exports["soe-ui"]:HideTooltip()
                            OpenVault()
                        end
                    end
                )
            end
        end
    end
end

-- **********************
--    Global Functions
-- **********************
-- RETURNS IF PLAYER IS NEAR A BANK TO ROB TELLER
function CanRobBankTeller()
    return bankRobbery.canRobBankTeller
end

-- MAIN TELLER ROBBERY FUNCTION
function DoBankTellerRobbery(teller)
    -- CHECK IF BANK CAN BE ROBBED
    if bankRobbery.isRobbing then return end
    if IsPedDeadOrDying(teller) then return end

    local canRobTeller = exports["soe-nexus"]:TriggerServerCallback("Crime:Server:BankRequirementCheck", "Teller", action.bank)
    if canRobTeller then
        -- INITIATE BANK ROBBERY TO THE SERVER SIDE
        bankRobbery.isRobbing = true
        bankRobbery.teller = teller
        local pos = GetEntityCoords(PlayerPedId())
        local location = exports["soe-utils"]:GetLocation(pos)
        TriggerServerEvent("Crime:Server:InitBankRobbery", {type = "Teller", response = "Panic", bank = action.bank, pos = pos, location = location})

        math.randomseed(GetGameTimer())
        math.random() math.random() math.random()
        local roll = math.random(1, 100)
        exports["soe-utils"]:LoadAnimDict("missheist_agency2ahands_up", 15)
        TaskPlayAnim(bankRobbery.teller, "missheist_agency2ahands_up", "handsup_anxious", 1.5, 1.5, -1, 1, 0, 0, 0, 0)
        Wait(3500)

        if (roll <= 64) then
            -- START MAKING THE TELLER PED DO THINGS
            local msg = "You are robbing the bank teller! Keep aiming at them and wait for them to get the money!"
            exports["soe-ui"]:PersistentAlert("start", "robbingTeller", "inform", msg, 5000)

            local time = math.random(60000, 62000)
            exports["soe-utils"]:LoadAnimDict("oddjobs@shop_robbery@rob_till", 15)
            TaskPlayAnim(bankRobbery.teller, "oddjobs@shop_robbery@rob_till", "loop", 2.0, 2.0, time, 49, 0, 0, 0, 0)

            Wait(time)
            exports["soe-ui"]:PersistentAlert("end", "robbingTeller")
            if bankRobbery.isRobbing then
                bankRobbery.isRobbing = false
                if not DoesEntityExist(bankRobbery.teller) then return end
                exports["soe-utils"]:LoadAnimDict("mp_am_hold_up", 15)

                StopAnimTask(bankRobbery.teller, "oddjobs@shop_robbery@rob_till", "loop", -3.5)
                TaskPlayAnim(bankRobbery.teller, "mp_am_hold_up", "cower_intro", 0.8, 0.8, 2500, 1, 0, 0, 0, 0)
                Wait(2500)
                TaskPlayAnim(bankRobbery.teller, "mp_am_hold_up", "cower_loop", 1.5, 1.5, -1, 1, 0, 0, 0, 0)

                if not action then return end
                TriggerServerEvent("Crime:Server:FinishBankRobbery", {type = "Teller", bank = action.bank})
            else
                exports["soe-ui"]:SendAlert("error", "You went too far from the teller!", 5000)
            end
        else
            -- WHEN THIS IS HIT, MAKE THE TELLER COWER AND REFUSE TO HAND MONEY
            bankRobbery.isRobbing = false
            exports["soe-ui"]:SendAlert("error", "The teller has refused to give you any money!", 5000)

            exports["soe-utils"]:LoadAnimDict("mp_am_hold_up", 15)
            TaskPlayAnim(bankRobbery.teller, "mp_am_hold_up", "cower_intro", 0.8, 0.8, 2500, 1, 0, 0, 0, 0)
            Wait(2500)
            TaskPlayAnim(bankRobbery.teller, "mp_am_hold_up", "cower_loop", 1.5, 1.5, -1, 1, 0, 0, 0, 0)
        end
    end
end

-- **********************
--        Events
-- **********************
-- EVENT TO INSTANTLY GLOBALLY SYNC BANK SETTINGS
RegisterNetEvent("Crime:Client:SyncBankStates")
AddEventHandler("Crime:Client:SyncBankStates", function(_banks)
    banks = _banks
end)

-- EVENT TO GLOBALLY SYNC VAULT CLOSING
RegisterNetEvent("Crime:Client:SecureBankVault")
AddEventHandler("Crime:Client:SecureBankVault", function(bank)
    banks[bank].vaultOpen = false
    local vault = GetClosestObjectOfType(banks[bank].pos, 5.5, banks[bank].vault, 0, 0, 0)
    if DoesEntityExist(vault) then
        SetEntityHeading(vault, banks[bank].vaultHeadings.closed)
    end
end)

-- RESETS BANK VAULT DOORS TO PREVENT SCUFFNESS ON RESOURCE RESTARTS/STOPS
AddEventHandler("onResourceStop", function(resource)
    if (GetCurrentResourceName() ~= resource) then return end

    for bank in pairs(banks) do
        local vault = GetClosestObjectOfType(banks[bank].pos, 5.5, banks[bank].vault, 0, 0, 0)
        if (banks[bank].vaultHeadings ~= nil) then
            SetEntityHeading(vault, banks[bank].vaultHeadings.closed)
        end
    end
end)

-- RESETS PALETO BANK VAULT DOOR
AddEventHandler("onClientResourceStart", function(resource)
    if (GetCurrentResourceName() ~= resource) then return end

    Wait(3500)
    for bank in pairs(banks) do
        if (bank == "Paleto Bay") then
            local vault = GetClosestObjectOfType(banks[bank].pos, 5.5, banks[bank].vault, 0, 0, 0)
            if (banks[bank].vaultHeadings ~= nil) then
                SetEntityHeading(vault, banks[bank].vaultHeadings.closed)
            end
        end
    end
end)

-- INTERACTION KEYPRESS
AddEventHandler("Utils:Client:InteractionKey", function()
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
        return
    end

    if not action then return end
    if action.status then
        if action.inVault then
            local depositBox = GetClosestDepositBox()
            if depositBox and banks[action.bank].vaultOpen then
                DoDepositBoxRobbery(depositBox)
            end
        else
            if action.atPanel and not banks[action.bank].vaultOpen then
                AttemptToOpenVault()
            elseif action.atPanel and banks[action.bank].vaultOpen then
                SecureTheVault()
            end
        end
    end
end)

-- IF WE LEFT A ZONE
AddEventHandler("Utils:Client:ExitedZone", function(name)
    if name:match("bank_teller") or name:match("bank_vault") or name:match("vault_area") then
        action = nil
        bankRobbery.canRobBankTeller, bankRobbery.isRobbing, bankRobbery.listening, bankRobbery.isInVaultArea = false, false, false, false
        exports["soe-ui"]:HideTooltip()

        -- WHEN THE COAST IS CLEAR, TELLER CAN COME BACK UP
        Wait(10000)
        if bankRobbery.teller and not action then
            ClearPedTasks(bankRobbery.teller)
            bankRobbery.teller = nil
        end
    end
end)

-- IF WE ENTERED A ZONE
AddEventHandler("Utils:Client:EnteredZone", function(name, zoneData)
    if name:match("bank_teller") then
        -- IF THE ZONE IS THE BANK TELLER, GIVE SOME OPTIONS
        banks = exports["soe-nexus"]:TriggerServerCallback("Crime:Server:SyncBanks")
        action = {status = true, bank = zoneData.bank}
        bankRobbery.canRobBankTeller = true
        SyncBankVault()

        -- SILENT ALARM FOR GUN IN LOBBY
        if not bankRobbery.listening then
            bankRobbery.listening = true
            -- DON'T TRIGGER ALARM IF ITS A ON DUTY POLICE
            if (exports["soe-jobs"]:GetMyJob() == "POLICE") then return end

            while bankRobbery.listening do
                Wait(3500)
                ListenForWeaponsInLobby()
            end
        end
    elseif (name == "paleto_bank_entrance") then
        -- SPECIAL ZONE NEEDED TO MAKE SURE PALETO BAY BANK IS SYNCED SINCE ITS BIGGER
        action = {status = true, bank = zoneData.bank}
        banks = exports["soe-nexus"]:TriggerServerCallback("Crime:Server:SyncBanks")
        SyncBankVault()
    elseif name:match("bank_vault") then
        -- IF THE ZONE IS THE BANK VAULT
        if (exports["soe-jobs"]:GetMyJob() == "POLICE") then
            action = {status = true, bank = zoneData.bank, atPanel = true, canSecure = true}
            if banks[action.bank].vaultOpen then
                exports["soe-ui"]:ShowTooltip("fas fa-piggy-bank", "[E] Secure Vault", "inform")
            end
        else
            action = {status = true, bank = zoneData.bank, atPanel = true}
            if not banks[action.bank].vaultOpen then
                exports["soe-ui"]:ShowTooltip("fas fa-piggy-bank", "[E] Attempt to Unlock Vault", "inform")
            end
        end
    elseif name:match("vault_area") then
        -- IF THE ZONE IS THE BANK VAULT
        action = {status = true, bank = zoneData.bank, inVault = true}

        if banks[action.bank].vaultOpen then
            if not bankRobbery.isInVaultArea then
                bankRobbery.isInVaultArea = true
                while bankRobbery.isInVaultArea do
                    Wait(5)
                    -- FAILSAFE IF EXITING ZONE DID NOT CORRECTLY STOP THIS LOOP
                    if not action then bankRobbery.isInVaultArea = false break end

                    -- DRAW MARKERS WHERE DEPOSIT BOXES WOULD BE
                    for _, depositBox in pairs(banks[action.bank].depositBoxes) do
                        if depositBox.robbed then
                            DrawMarker(21, depositBox.pos, 0, 0, 0, 0, 0, 0, 0.15, 0.15, 0.15, 51, 143, 44, 175, 0, 1, 2, 0, 0, 0, 0)
                        else
                            DrawMarker(21, depositBox.pos, 0, 0, 0, 0, 0, 0, 0.15, 0.15, 0.15, 255, 0, 0, 175, 0, 1, 2, 0, 0, 0, 0)
                        end
                    end
                end
            end
        --[[else
            -- THIS IDIOT IS A HACKER! GET'EM BOYS!
            for i = 1, 5 do
                if not action then return end
                print("Welcome to the jungle mf.")
                exports["soe-logging"]:ScreenshotMyScreen(("Possibly teleported into the %s Bank vault area with the vault closed"):format(action.bank))
                Wait(5000)
            end]]
        end
    end
end)
