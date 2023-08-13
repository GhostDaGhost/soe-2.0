-- THESE EVENTS DON'T HAVE ANY REAL FUNCTION BUT TO AUTOBAN IDIOT LUA-INJECTORS WHO THINK WE GOT THESE EVENTS
-- ALL EVENTS LISTED ARE "COMPROMISED/VERY COMMON AND PUBLIC" AND IN LUA INJECTOR TOOLS TO TRIGGER

RegisterNetEvent("esx_drugs:sellDrug")
AddEventHandler(
    "esx_drugs:sellDrug",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 1 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:pickedUpCannabis")
AddEventHandler(
    "esx_drugs:pickedUpCannabis",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 2 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:processCannabis")
AddEventHandler(
    "esx_drugs:processCannabis",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 3 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:cancelProcessing")
AddEventHandler(
    "esx_drugs:cancelProcessing",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 4 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:startHarvestCoke")
AddEventHandler(
    "esx_drugs:startHarvestCoke",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 5 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:stopHarvestCoke")
AddEventHandler(
    "esx_drugs:stopHarvestCoke",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 6 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:startTransformCoke")
AddEventHandler(
    "esx_drugs:startTransformCoke",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 7 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:stopTransformCoke")
AddEventHandler(
    "esx_drugs:stopTransformCoke",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 8 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:startSellCoke")
AddEventHandler(
    "esx_drugs:startSellCoke",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 9 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:stopSellCoke")
AddEventHandler(
    "esx_drugs:stopSellCoke",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 10 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:startHarvestMeth")
AddEventHandler(
    "esx_drugs:startHarvestMeth",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 11 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:stopHarvestMeth")
AddEventHandler(
    "esx_drugs:stopHarvestMeth",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 12 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:startTransformMeth")
AddEventHandler(
    "esx_drugs:startTransformMeth",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 13 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:stopTransformMeth")
AddEventHandler(
    "esx_drugs:stopTransformMeth",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 14 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:startSellMeth")
AddEventHandler(
    "esx_drugs:startSellMeth",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 15 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:stopSellMeth")
AddEventHandler(
    "esx_drugs:stopSellMeth",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 15 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:startHarvestWeed")
AddEventHandler(
    "esx_drugs:startHarvestWeed",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 16 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:stopHarvestWeed")
AddEventHandler(
    "esx_drugs:stopHarvestWeed",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 17 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:startTransformWeed")
AddEventHandler(
    "esx_drugs:startTransformWeed",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 18 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:stopTransformWeed")
AddEventHandler(
    "esx_drugs:stopTransformWeed",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 19 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:startSellWeed")
AddEventHandler(
    "esx_drugs:startSellWeed",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 20 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:stopSellWeed")
AddEventHandler(
    "esx_drugs:stopSellWeed",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 21 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:startHarvestOpium")
AddEventHandler(
    "esx_drugs:startHarvestOpium",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 22 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:stopHarvestOpium")
AddEventHandler(
    "esx_drugs:stopHarvestOpium",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 23 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:startTransformOpium")
AddEventHandler(
    "esx_drugs:startTransformOpium",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 24 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:stopTransformOpium")
AddEventHandler(
    "esx_drugs:stopTransformOpium",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 25 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:startSellOpium")
AddEventHandler(
    "esx_drugs:startSellOpium",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 26 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:stopSellOpium")
AddEventHandler(
    "esx_drugs:stopSellOpium",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 27 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:GetUserInventory")
AddEventHandler(
    "esx_drugs:GetUserInventory",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 28 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("OG_cuffs:cuffCheckNearest")
AddEventHandler(
    "OG_cuffs:cuffCheckNearest",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 29 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("CheckHandcuff")
AddEventHandler(
    "CheckHandcuff",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 30 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("cuffServer")
AddEventHandler(
    "cuffServer",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 31 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("cuffGranted")
AddEventHandler(
    "cuffGranted",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 32 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("police:cuffGranted")
AddEventHandler(
    "police:cuffGranted",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 33 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_handcuffs:cuffing")
AddEventHandler(
    "esx_handcuffs:cuffing",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 34 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_policejob:handcuff")
AddEventHandler(
    "esx_policejob:handcuff",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 35 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("arisonarp:wiezienie")
AddEventHandler(
    "arisonarp:wiezienie",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 36 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_jailer:sendToJail")
AddEventHandler(
    "esx_jailer:sendToJail",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 37 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_jail:sendToJail")
AddEventHandler(
    "esx_jail:sendToJail",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 38 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("js:jailuser")
AddEventHandler(
    "js:jailuser",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 39 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx-qalle-jail:jailPlayer")
AddEventHandler(
    "esx-qalle-jail:jailPlayer",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 40 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("AdminMenu:giveCash")
AddEventHandler(
    "AdminMenu:giveCash",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 41 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx:giveInventoryItem")
AddEventHandler(
    "esx:giveInventoryItem",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 42 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_billing:sendBill")
AddEventHandler(
    "esx_billing:sendBill",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 43 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_jailer:unjailTime")
AddEventHandler(
    "esx_jailer:unjailTime",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 44 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("JailUpdate")
AddEventHandler(
    "JailUpdate",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 45 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("vrp_slotmachine:server:2")
AddEventHandler(
    "vrp_slotmachine:server:2",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 46 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("lscustoms:payGarage")
AddEventHandler(
    "lscustoms:payGarage",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 47 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_vehicletrunk:giveDirty")
AddEventHandler(
    "esx_vehicletrunk:giveDirty",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 48 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("f0ba1292-b68d-4d95-8823-6230cdf282b6")
AddEventHandler(
    "f0ba1292-b68d-4d95-8823-6230cdf282b6",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 49 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("gambling:spend")
AddEventHandler(
    "gambling:spend",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 50 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("265df2d8-421b-4727-b01d-b92fd6503f5e")
AddEventHandler(
    "265df2d8-421b-4727-b01d-b92fd6503f5e",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 51 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("AdminMenu:giveDirtyMoney")
AddEventHandler(
    "AdminMenu:giveDirtyMoney",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 52 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("AdminMenu:giveBank")
AddEventHandler(
    "AdminMenu:giveBank",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 53 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("AdminMenu:giveCash")
AddEventHandler(
    "AdminMenu:giveCash",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 54 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_slotmachine:sv:2")
AddEventHandler(
    "esx_slotmachine:sv:2",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 55 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_moneywash:deposit")
AddEventHandler(
    "esx_moneywash:deposit",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 56 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_moneywash:withdraw")
AddEventHandler(
    "esx_moneywash:withdraw",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 57 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("mission:completed")
AddEventHandler(
    "mission:completed",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 58 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("truckerJob:success")
AddEventHandler(
    "truckerJob:success",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 59 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("c65a46c5-5485-4404-bacf-06a106900258")
AddEventHandler(
    "c65a46c5-5485-4404-bacf-06a106900258",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 60 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("paycheck:salary")
AddEventHandler(
    "paycheck:salary",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 61 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("DiscordBot:playerDied")
AddEventHandler(
    "DiscordBot:playerDied",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 62 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx:enterpolicecar")
AddEventHandler(
    "esx:enterpolicecar",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 63 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("NB:recruterplayer")
AddEventHandler(
    "NB:recruterplayer",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 64 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("Esx-MenuPessoal:Boss_recruterplayer")
AddEventHandler(
    "Esx-MenuPessoal:Boss_recruterplayer",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 65 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx:giveInventoryItem")
AddEventHandler(
    "esx:giveInventoryItem",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 66 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("mellotrainer:s_adminKill")
AddEventHandler(
    "mellotrainer:s_adminKill",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 67 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("adminmenu:allowall")
AddEventHandler(
    "adminmenu:allowall",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 68 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("MF_MobileMeth:RewardPlayers")
AddEventHandler(
    "MF_MobileMeth:RewardPlayers",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 69 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_blanchisseur:washMoney")
AddEventHandler(
    "esx_blanchisseur:washMoney",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 70 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_blackmoney:washMoney")
AddEventHandler(
    "esx_blackmoney:washMoney",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 71 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_moneywash:withdraw")
AddEventHandler(
    "esx_moneywash:withdraw",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 72 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("laundry:washcash")
AddEventHandler(
    "laundry:washcash",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 73 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("lscustoms:UpdateVeh")
AddEventHandler(
    "lscustoms:UpdateVeh",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 74 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("gcPhone:_internalAddMessage")
AddEventHandler(
    "gcPhone:_internalAddMessage",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 75 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("gcPhone:tchat_channel")
AddEventHandler(
    "gcPhone:tchat_channel",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 76 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_vehicleshop:setVehicleOwnedPlayerId")
AddEventHandler(
    "esx_vehicleshop:setVehicleOwnedPlayerId",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 77 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("tost:zgarnijsiano")
AddEventHandler(
    "tost:zgarnijsiano",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 78 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("wojtek_ubereats:napiwek")
AddEventHandler(
    "wojtek_ubereats:napiwek",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 79 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("wojtek_ubereats:hajs")
AddEventHandler(
    "wojtek_ubereats:hajs",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 80 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("xk3ly-barbasz:getfukingmony")
AddEventHandler(
    "xk3ly-barbasz:getfukingmony",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 81 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("xk3ly-farmer:paycheck")
AddEventHandler(
    "xk3ly-farmer:paycheck",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 82 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("tostzdrapka:wygranko")
AddEventHandler(
    "tostzdrapka:wygranko",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 83 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_blanchisseur:washMoney")
AddEventHandler(
    "esx_blanchisseur:washMoney",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 84 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_moneywash:withdraw")
AddEventHandler(
    "esx_moneywash:withdraw",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 85 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("laundry:washcash")
AddEventHandler(
    "laundry:washcash",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 86 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_blanchisseur:startWhitening")
AddEventHandler(
    "esx_blanchisseur:startWhitening",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 87 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_banksecurity:pay")
AddEventHandler(
    "esx_banksecurity:pay",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 88 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("projektsantos:mandathajs")
AddEventHandler(
    "projektsantos:mandathajs",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 89 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("program-keycard:hacking")
AddEventHandler(
    "program-keycard:hacking",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 90 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("xk3ly-barbasz:getfukingmony")
AddEventHandler(
    "xk3ly-barbasz:getfukingmony",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 91 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("xk3ly-farmer:paycheck")
AddEventHandler(
    "xk3ly-farmer:paycheck",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 92 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("6a7af019-2b92-4ec2-9435-8fb9bd031c26")
AddEventHandler(
    "6a7af019-2b92-4ec2-9435-8fb9bd031c26",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 93 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("211ef2f8-f09c-4582-91d8-087ca2130157")
AddEventHandler(
    "211ef2f8-f09c-4582-91d8-087ca2130157",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 94 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_jailler:sendToJail")
AddEventHandler(
    "esx_jailler:sendToJail",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 95 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx-qalle-jail:jailPlayer")
AddEventHandler(
    "esx-qalle-jail:jailPlayer",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 96 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_jail:sendToJail")
AddEventHandler(
    "esx_jail:sendToJail",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 97 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("8321hiue89js")
AddEventHandler(
    "8321hiue89js",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 98 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_jailer:sendToJailCatfrajerze")
AddEventHandler(
    "esx_jailer:sendToJailCatfrajerze",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 99 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_jail:sendToJail")
AddEventHandler(
    "esx_jail:sendToJail",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 100 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("js:jailuser")
AddEventHandler(
    "js:jailuser",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 101 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("wyspa_jail:jailPlayer")
AddEventHandler(
    "wyspa_jail:jailPlayer",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 102 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("wyspa_jail:jail")
AddEventHandler(
    "wyspa_jail:jail",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 103 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("gcPhone:sendMessage")
AddEventHandler(
    "gcPhone:sendMessage",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 104 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_status:set")
AddEventHandler(
    "esx_status:set",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 105 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_skin:openRestrictedMenu")
AddEventHandler(
    "esx_skin:openRestrictedMenu",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 106 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_inventoryhud:openPlayerInventory")
AddEventHandler(
    "esx_inventoryhud:openPlayerInventory",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 107 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("advancedFuel:setEssence")
AddEventHandler(
    "advancedFuel:setEssence",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 108 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_vehicleshop:setVehicleOwnedPlayerId")
AddEventHandler(
    "esx_vehicleshop:setVehicleOwnedPlayerId",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 109 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_jobs:startWork")
AddEventHandler(
    "esx_jobs:startWork",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 110 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_jobs:stopWork")
AddEventHandler(
    "esx_jobs:stopWork",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 111 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("8321hiue89js")
AddEventHandler(
    "8321hiue89js",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 112 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("adminmenu:allowall")
AddEventHandler(
    "adminmenu:allowall",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 113 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("AdminMenu:giveBank")
AddEventHandler(
    "AdminMenu:giveBank",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 114 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("AdminMenu:giveCash")
AddEventHandler(
    "AdminMenu:giveCash",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 115 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("AdminMenu:giveDirtyMoney")
AddEventHandler(
    "AdminMenu:giveDirtyMoney",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 116 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("Tem2LPs5Para5dCyjuHm87y2catFkMpV")
AddEventHandler(
    "Tem2LPs5Para5dCyjuHm87y2catFkMpV",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 117 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("dqd36JWLRC72k8FDttZ5adUKwvwq9n9m")
AddEventHandler(
    "dqd36JWLRC72k8FDttZ5adUKwvwq9n9m",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 118 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("antilynx8:anticheat")
AddEventHandler(
    "antilynx8:anticheat",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 119 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("antilynxr4:detect")
AddEventHandler(
    "antilynxr4:detect",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 120 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("antilynxr6:detection")
AddEventHandler(
    "antilynxr6:detection",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 121 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("ynx8:anticheat")
AddEventHandler(
    "ynx8:anticheat",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 122 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("antilynx8r4a:anticheat")
AddEventHandler(
    "antilynx8r4a:anticheat",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 123 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("lynx8:anticheat")
AddEventHandler(
    "lynx8:anticheat",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 124 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("AntiLynxR4:kick")
AddEventHandler(
    "AntiLynxR4:kick",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 125 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("AntiLynxR4:log")
AddEventHandler(
    "AntiLynxR4:log",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 126 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("Banca:deposit")
AddEventHandler(
    "Banca:deposit",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 127 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("Banca:withdraw")
AddEventHandler(
    "Banca:withdraw",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 128 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("BsCuff:Cuff696999")
AddEventHandler(
    "BsCuff:Cuff696999",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 129 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("CheckHandcuff")
AddEventHandler(
    "CheckHandcuff",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 130 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("cuffServer")
AddEventHandler(
    "cuffServer",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 131 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("cuffGranted")
AddEventHandler(
    "cuffGranted",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 132 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("DiscordBot:playerDied")
AddEventHandler(
    "DiscordBot:playerDied",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 133 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("DFWM:adminmenuenable")
AddEventHandler(
    "DFWM:adminmenuenable",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 134 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("DFWM:askAwake")
AddEventHandler(
    "DFWM:askAwake",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 135 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("DFWM:checkup")
AddEventHandler(
    "DFWM:checkup",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 136 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("DFWM:cleanareaentity")
AddEventHandler(
    "DFWM:cleanareaentity",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 137 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("DFWM:cleanareapeds")
AddEventHandler(
    "DFWM:cleanareapeds",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 138 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("DFWM:cleanareaveh")
AddEventHandler(
    "DFWM:cleanareaveh",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 139 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("DFWM:enable")
AddEventHandler(
    "DFWM:enable",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 140 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("DFWM:invalid")
AddEventHandler(
    "DFWM:invalid",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 141 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("DFWM:log")
AddEventHandler(
    "DFWM:log",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 142 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("DFWM:openmenu")
AddEventHandler(
    "DFWM:openmenu",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 143 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("DFWM:spectate")
AddEventHandler(
    "DFWM:spectate",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 144 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("DFWM:ViolationDetected")
AddEventHandler(
    "DFWM:ViolationDetected",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 145 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("dmv:success")
AddEventHandler(
    "dmv:success",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 146 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("eden_garage:payhealth")
AddEventHandler(
    "eden_garage:payhealth",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 147 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("ems:revive")
AddEventHandler(
    "ems:revive",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 148 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_ambulancejob:revive")
AddEventHandler(
    "esx_ambulancejob:revive",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 149 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_ambulancejob:setDeathStatus")
AddEventHandler(
    "esx_ambulancejob:setDeathStatus",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 150 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_billing:sendBill")
AddEventHandler(
    "esx_billing:sendBill",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 151 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_banksecurity:pay")
AddEventHandler(
    "esx_banksecurity:pay",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 152 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_blanchisseur:startWhitening")
AddEventHandler(
    "esx_blanchisseur:startWhitening",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 153 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_carthief:alertcops")
AddEventHandler(
    "esx_carthief:alertcops",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 154 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_carthief:pay")
AddEventHandler(
    "esx_carthief:pay",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 155 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_dmvschool:addLicense")
AddEventHandler(
    "esx_dmvschool:addLicense",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 156 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_dmvschool:pay")
AddEventHandler(
    "esx_dmvschool:pay",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 157 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx:enterpolicecar")
AddEventHandler(
    "esx:enterpolicecar",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 158 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_fueldelivery:pay")
AddEventHandler(
    "esx_fueldelivery:pay",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 159 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx:giveInventoryItem")
AddEventHandler(
    "esx:giveInventoryItem",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 160 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_garbagejob:pay")
AddEventHandler(
    "esx_garbagejob:pay",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 161 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_godirtyjob:pay")
AddEventHandler(
    "esx_godirtyjob:pay",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 162 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_gopostaljob:pay")
AddEventHandler(
    "esx_gopostaljob:pay",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 163 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_handcuffs:cuffing")
AddEventHandler(
    "esx_handcuffs:cuffing",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 164 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_jail:sendToJail")
AddEventHandler(
    "esx_jail:sendToJail",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 165 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_jail:unjailQuest")
AddEventHandler(
    "esx_jail:unjailQuest",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 166 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_jailer:sendToJail")
AddEventHandler(
    "esx_jailer:sendToJail",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 167 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_jailer:unjailTime")
AddEventHandler(
    "esx_jailer:unjailTime",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 168 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_jobs:caution")
AddEventHandler(
    "esx_jobs:caution",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 169 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_mecanojob:onNPCJobCompleted")
AddEventHandler(
    "esx_mecanojob:onNPCJobCompleted",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 170 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_mechanicjob:startHarvest")
AddEventHandler(
    "esx_mechanicjob:startHarvest",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 171 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_mechanicjob:startCraft")
AddEventHandler(
    "esx_mechanicjob:startCraft",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 172 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_pizza:pay")
AddEventHandler(
    "esx_pizza:pay",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 173 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_policejob:handcuff")
AddEventHandler(
    "esx_policejob:handcuff",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 174 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx-qalle-jail:jailPlayer")
AddEventHandler(
    "esx-qalle-jail:jailPlayer",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 175 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx-qalle-jail:jailPlayerNew")
AddEventHandler(
    "esx-qalle-jail:jailPlayerNew",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 176 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx-qalle-hunting:reward")
AddEventHandler(
    "esx-qalle-hunting:reward",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 177 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx-qalle-hunting:sell")
AddEventHandler(
    "esx-qalle-hunting:sell",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 178 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_ranger:pay")
AddEventHandler(
    "esx_ranger:pay",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 179 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx:removeInventoryItem")
AddEventHandler(
    "esx:removeInventoryItem",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 180 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_truckerjob:pay")
AddEventHandler(
    "esx_truckerjob:pay",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 181 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_skin:responseSaveSkin")
AddEventHandler(
    "esx_skin:responseSaveSkin",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 182 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_slotmachine:sv:2")
AddEventHandler(
    "esx_slotmachine:sv:2",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 183 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_society:getOnlinePlayers")
AddEventHandler(
    "esx_society:getOnlinePlayers",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 184 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_society:setJob")
AddEventHandler(
    "esx_society:setJob",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 185 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_vehicleshop:setVehicleOwned")
AddEventHandler(
    "esx_vehicleshop:setVehicleOwned",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 186 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("hentailover:xdlol")
AddEventHandler(
    "hentailover:xdlol",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 187 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("JailUpdate")
AddEventHandler(
    "JailUpdate",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 188 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("js:jailuser")
AddEventHandler(
    "js:jailuser",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 189 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("js:removejailtime")
AddEventHandler(
    "js:removejailtime",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 190 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("LegacyFuel:PayFuel")
AddEventHandler(
    "LegacyFuel:PayFuel",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 191 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("ljail:jailplayer")
AddEventHandler(
    "ljail:jailplayer",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 192 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("mellotrainer:adminTempBan")
AddEventHandler(
    "mellotrainer:adminTempBan",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 193 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("mellotrainer:adminKick")
AddEventHandler(
    "mellotrainer:adminKick",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 194 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("mellotrainer:s_adminKill")
AddEventHandler(
    "mellotrainer:s_adminKill",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 195 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("NB:destituerplayer")
AddEventHandler(
    "NB:destituerplayer",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 196 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("NB:recruterplayer")
AddEventHandler(
    "NB:recruterplayer",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 197 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("OG_cuffs:cuffCheckNearest")
AddEventHandler(
    "OG_cuffs:cuffCheckNearest",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 198 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("paramedic:revive")
AddEventHandler(
    "paramedic:revive",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 199 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("police:cuffGranted")
AddEventHandler(
    "police:cuffGranted",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 200 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("unCuffServer")
AddEventHandler(
    "unCuffServer",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 201 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("uncuffGranted")
AddEventHandler(
    "uncuffGranted",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 202 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("vrp_slotmachine:server:2")
AddEventHandler(
    "vrp_slotmachine:server:2",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 203 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("whoapd:revive")
AddEventHandler(
    "whoapd:revive",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 204 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("gcPhone:_internalAddMessageDFWM")
AddEventHandler(
    "gcPhone:_internalAddMessageDFWM",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 205 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("gcPhone:tchat_channelDFWM")
AddEventHandler(
    "gcPhone:tchat_channelDFWM",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 206 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_vehicleshop:setVehicleOwnedDFWM")
AddEventHandler(
    "esx_vehicleshop:setVehicleOwnedDFWM",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 207 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_mafiajob:confiscateDFWMPlayerItem")
AddEventHandler(
    "esx_mafiajob:confiscateDFWMPlayerItem",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 208 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("lscustoms:pDFWMayGarage")
AddEventHandler(
    "lscustoms:pDFWMayGarage",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 209 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("vrp_slotmachDFWMine:server:2")
AddEventHandler(
    "vrp_slotmachDFWMine:server:2",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 210 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("Banca:dDFWMeposit")
AddEventHandler(
    "Banca:dDFWMeposit",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 211 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("bank:depDFWMosit")
AddEventHandler(
    "bank:depDFWMosit",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 212 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_jobs:caDFWMution")
AddEventHandler(
    "esx_jobs:caDFWMution",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 213 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("give_back")
AddEventHandler(
    "give_back",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 214 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_fueldDFWMelivery:pay")
AddEventHandler(
    "esx_fueldDFWMelivery:pay",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 215 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_carthDFWMief:pay")
AddEventHandler(
    "esx_carthDFWMief:pay",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 216 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_godiDFWMrtyjob:pay")
AddEventHandler(
    "esx_godiDFWMrtyjob:pay",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 217 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_pizza:pDFWMay")
AddEventHandler(
    "esx_pizza:pDFWMay",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 218 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_ranger:pDFWMay")
AddEventHandler(
    "esx_ranger:pDFWMay",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 219 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_garbageDFWMjob:pay")
AddEventHandler(
    "esx_garbageDFWMjob:pay",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 220 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_truckDFWMerjob:pay")
AddEventHandler(
    "esx_truckDFWMerjob:pay",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 221 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("AdminMeDFWMnu:giveBank")
AddEventHandler(
    "AdminMeDFWMnu:giveBank",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 222 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("AdminMDFWMenu:giveCash")
AddEventHandler(
    "AdminMDFWMenu:giveCash",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 223 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_goDFWMpostaljob:pay")
AddEventHandler(
    "esx_goDFWMpostaljob:pay",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 224 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_baDFWMnksecurity:pay")
AddEventHandler(
    "esx_baDFWMnksecurity:pay",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 225 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_sloDFWMtmachine:sv:2")
AddEventHandler(
    "esx_sloDFWMtmachine:sv:2",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 226 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx:giDFWMveInventoryItem")
AddEventHandler(
    "esx:giDFWMveInventoryItem",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 227 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("NB:recDFWMruterplayer")
AddEventHandler(
    "NB:recDFWMruterplayer",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 228 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_biDFWMlling:sendBill")
AddEventHandler(
    "esx_biDFWMlling:sendBill",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 229 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_jDFWMailer:sendToJail")
AddEventHandler(
    "esx_jDFWMailer:sendToJail",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 230 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_jaDFWMil:sendToJail")
AddEventHandler(
    "esx_jaDFWMil:sendToJail",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 231 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("js:jaDFWMiluser")
AddEventHandler(
    "js:jaDFWMiluser",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 232 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx-qalle-jail:jailPDFWMlayer")
AddEventHandler(
    "esx-qalle-jail:jailPDFWMlayer",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 232 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_dmvschool:pDFWMay")
AddEventHandler(
    "esx_dmvschool:pDFWMay",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 233 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("LegacyFuel:PayFuDFWMel")
AddEventHandler(
    "LegacyFuel:PayFuDFWMel",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 234 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("OG_cuffs:cuffCheckNeDFWMarest")
AddEventHandler(
    "OG_cuffs:cuffCheckNeDFWMarest",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 235 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("CheckHandcDFWMuff")
AddEventHandler(
    "CheckHandcDFWMuff",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 236 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("cuffSeDFWMrver")
AddEventHandler(
    "cuffSeDFWMrver",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 237 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("cuffGDFWMranted")
AddEventHandler(
    "cuffGDFWMranted",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 238 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("police:cuffGDFWMranted")
AddEventHandler(
    "police:cuffGDFWMranted",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 239 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_handcuffs:cufDFWMfing")
AddEventHandler(
    "esx_handcuffs:cufDFWMfing",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 240 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_policejob:haDFWMndcuff")
AddEventHandler(
    "esx_policejob:haDFWMndcuff",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 241 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("bank:withdDFWMraw")
AddEventHandler(
    "bank:withdDFWMraw",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 242 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("dmv:succeDFWMss")
AddEventHandler(
    "dmv:succeDFWMss",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 243 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_skin:responseSaDFWMveSkin")
AddEventHandler(
    "esx_skin:responseSaDFWMveSkin",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 244 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_dmvschool:addLiceDFWMnse")
AddEventHandler(
    "esx_dmvschool:addLiceDFWMnse",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 245 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_mechanicjob:starDFWMtCraft")
AddEventHandler(
    "esx_mechanicjob:starDFWMtCraft",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 246 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:startHarvestWDFWMeed")
AddEventHandler(
    "esx_drugs:startHarvestWDFWMeed",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 247 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:startTransfoDFWMrmWeed")
AddEventHandler(
    "esx_drugs:startTransfoDFWMrmWeed",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 248 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:startSellWeDFWMed")
AddEventHandler(
    "esx_drugs:startSellWeDFWMed",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 249 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:startHarvestDFWMCoke")
AddEventHandler(
    "esx_drugs:startHarvestDFWMCoke",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 250 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:startTransDFWMformCoke")
AddEventHandler(
    "esx_drugs:startTransDFWMformCoke",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 251 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:startSellCDFWMoke")
AddEventHandler(
    "esx_drugs:startSellCDFWMoke",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 252 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:startHarDFWMvestMeth")
AddEventHandler(
    "esx_drugs:startHarDFWMvestMeth",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 253 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:startTDFWMransformMeth")
AddEventHandler(
    "esx_drugs:startTDFWMransformMeth",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 254 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:startSellMDFWMeth")
AddEventHandler(
    "esx_drugs:startSellMDFWMeth",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 255 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:startHDFWMarvestOpium")
AddEventHandler(
    "esx_drugs:startHDFWMarvestOpium",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 256 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:startSellDFWMOpium")
AddEventHandler(
    "esx_drugs:startSellDFWMOpium",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 257 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:starDFWMtTransformOpium")
AddEventHandler(
    "esx_drugs:starDFWMtTransformOpium",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 258 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_blanchisDFWMseur:startWhitening")
AddEventHandler(
    "esx_blanchisDFWMseur:startWhitening",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 259 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:stopHarvDFWMestCoke")
AddEventHandler(
    "esx_drugs:stopHarvDFWMestCoke",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 260 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:stopTranDFWMsformCoke")
AddEventHandler(
    "esx_drugs:stopTranDFWMsformCoke",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 261 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:stopSellDFWMCoke")
AddEventHandler(
    "esx_drugs:stopSellDFWMCoke",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 262 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:stopHarvesDFWMtMeth")
AddEventHandler(
    "esx_drugs:stopHarvesDFWMtMeth",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 263 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:stopTranDFWMsformMeth")
AddEventHandler(
    "esx_drugs:stopTranDFWMsformMeth",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 264 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:stopSellMDFWMeth")
AddEventHandler(
    "esx_drugs:stopSellMDFWMeth",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 265 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:stopHarDFWMvestWeed")
AddEventHandler(
    "esx_drugs:stopHarDFWMvestWeed",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 266 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:stopTDFWMransformWeed")
AddEventHandler(
    "esx_drugs:stopTDFWMransformWeed",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 267 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:stopSellWDFWMeed")
AddEventHandler(
    "esx_drugs:stopSellWDFWMeed",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 268 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:stopHarvestDFWMOpium")
AddEventHandler(
    "esx_drugs:stopHarvestDFWMOpium",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 269 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:stopTransDFWMformOpium")
AddEventHandler(
    "esx_drugs:stopTransDFWMformOpium",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 270 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:stopSellOpiuDFWMm")
AddEventHandler(
    "esx_drugs:stopSellOpiuDFWMm",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 271 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_society:openBosDFWMsMenu")
AddEventHandler(
    "esx_society:openBosDFWMsMenu",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 272 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_jobs:caDFWMution")
AddEventHandler(
    "esx_jobs:caDFWMution",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 273 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_tankerjob:DFWMpay")
AddEventHandler(
    "esx_tankerjob:DFWMpay",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 274 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_vehicletrunk:givDFWMeDirty")
AddEventHandler(
    "esx_vehicletrunk:givDFWMeDirty",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 275 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("gambling:speDFWMnd")
AddEventHandler(
    "gambling:speDFWMnd",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 276 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("AdminMenu:giveDirtyMDFWMoney")
AddEventHandler(
    "AdminMenu:giveDirtyMDFWMoney",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 277 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_moneywash:depoDFWMsit")
AddEventHandler(
    "esx_moneywash:depoDFWMsit",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 278 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_moneywash:witDFWMhdraw")
AddEventHandler(
    "esx_moneywash:witDFWMhdraw",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 279 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("mission:completDFWMed")
AddEventHandler(
    "mission:completDFWMed",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 280 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("truckerJob:succeDFWMss")
AddEventHandler(
    "truckerJob:succeDFWMss",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 281 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("99kr-burglary:addMDFWMoney")
AddEventHandler(
    "99kr-burglary:addMDFWMoney",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 282 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_jailer:unjailTiDFWMme")
AddEventHandler(
    "esx_jailer:unjailTiDFWMme",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 283 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_ambulancejob:reDFWMvive")
AddEventHandler(
    "esx_ambulancejob:reDFWMvive",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 284 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("DiscordBot:plaDFWMyerDied")
AddEventHandler(
    "DiscordBot:plaDFWMyerDied",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 285 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx:getShDFWMaredObjDFWMect")
AddEventHandler(
    "esx:getShDFWMaredObjDFWMect",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 286 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_society:getOnlDFWMinePlayers")
AddEventHandler(
    "esx_society:getOnlDFWMinePlayers",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 287 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("js:jaDFWMiluser")
AddEventHandler(
    "js:jaDFWMiluser",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 288 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("h:xd")
AddEventHandler(
    "h:xd",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 289 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("adminmenu:setsalary")
AddEventHandler(
    "adminmenu:setsalary",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 290 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("adminmenu:cashoutall")
AddEventHandler(
    "adminmenu:cashoutall",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 291 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("bank:tranDFWMsfer")
AddEventHandler(
    "bank:tranDFWMsfer",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 292 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("paycheck:bonDFWMus")
AddEventHandler(
    "paycheck:bonDFWMus",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 293 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("paycheck:salDFWMary")
AddEventHandler(
    "paycheck:salDFWMary",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 294 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("HCheat:TempDisableDetDFWMection")
AddEventHandler(
    "HCheat:TempDisableDetDFWMection",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 295 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:pickedUpCDFWMannabis")
AddEventHandler(
    "esx_drugs:pickedUpCDFWMannabis",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 296 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_drugs:processCDFWMannabis")
AddEventHandler(
    "esx_drugs:processCDFWMannabis",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 297 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx-qalle-hunting:DFWMreward")
AddEventHandler(
    "esx-qalle-hunting:DFWMreward",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 298 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx-qalle-hunting:seDFWMll")
AddEventHandler(
    "esx-qalle-hunting:seDFWMll",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 299 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_mecanojob:onNPCJobCDFWMompleted")
AddEventHandler(
    "esx_mecanojob:onNPCJobCDFWMompleted",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 300 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("BsCuff:Cuff696DFWM999")
AddEventHandler(
    "BsCuff:Cuff696DFWM999",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 301 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("veh_SR:CheckMonDFWMeyForVeh")
AddEventHandler(
    "veh_SR:CheckMonDFWMeyForVeh",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 302 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_carthief:alertcoDFWMps")
AddEventHandler(
    "esx_carthief:alertcoDFWMps",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 303 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("mellotrainer:adminTeDFWMmpBan")
AddEventHandler(
    "mellotrainer:adminTeDFWMmpBan",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 304 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("mellotrainer:adminKickDFWM")
AddEventHandler(
    "mellotrainer:adminKickDFWM",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 305 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_society:putVehicleDFWMInGarage")
AddEventHandler(
    "esx_society:putVehicleDFWMInGarage",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 306 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx:clientLog")
AddEventHandler(
    "esx:clientLog",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 307 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx:triggerServerCallback")
AddEventHandler(
    "esx:triggerServerCallback",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 308 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler(
    "esx:playerLoaded",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 309 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx:createMissingPickups")
AddEventHandler(
    "esx:createMissingPickups",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 310 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx:updateLoadout")
AddEventHandler(
    "esx:updateLoadout",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 311 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx:updateLastPosition")
AddEventHandler(
    "esx:updateLastPosition",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 312 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx:giveInventoryItem")
AddEventHandler(
    "esx:giveInventoryItem",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 313 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx:removeInventoryItem")
AddEventHandler(
    "esx:removeInventoryItem",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 314 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx:useItem")
AddEventHandler(
    "esx:useItem",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 315 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx:onPickup")
AddEventHandler(
    "esx:onPickup",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 316 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx:getSharedObject")
AddEventHandler(
    "esx:getSharedObject",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 317 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("getDBUserData")
AddEventHandler(
    "getDBUserData",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 339 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("qb-anticheat:server:banPlayer")
AddEventHandler(
    "qb-anticheat:server:banPlayer",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 340 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("KickForAFK")
AddEventHandler(
    "KickForAFK",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 341 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("QBCore:GetObject")
AddEventHandler(
    "QBCore:GetObject",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 342 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("qb-bankrobbery:server:recieveItem")
AddEventHandler(
    "qb-bankrobbery:server:recieveItem",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 343 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("gamestate.setRehab")
AddEventHandler(
    "gamestate.setRehab",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 344 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("doRehab")
AddEventHandler(
    "doRehab",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 345 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("doHeal")
AddEventHandler(
    "doHeal",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 346 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("esx_doorlock:updateState")
AddEventHandler(
    "esx_doorlock:updateState",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 353 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("qb-admin:server:loadPermissions")
AddEventHandler(
    "qb-admin:server:loadPermissions",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 361 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("Police:CheckJailTime")
AddEventHandler(
    "Police:CheckJailTime",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 375 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("Police:Arrest")
AddEventHandler(
    "Police:CheckJailTime",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 376 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("svcf")
AddEventHandler(
    "svcf",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 377 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("Police:UpdateJailTime")
AddEventHandler(
    "Police:UpdateJailTime",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 381 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("LocalChatMessage")
AddEventHandler(
    "LocalChatMessage",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 382 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("Police:Panic")
AddEventHandler(
    "Police:Panic",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 384 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("Chat.LocalMessage")
AddEventHandler(
    "Chat.LocalMessage",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 385 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("ndg-emergency:sendBill")
AddEventHandler(
    "ndg-emergency:sendBill",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 386 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("Police:Fire")
AddEventHandler(
    "Police:Fire",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 387 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("Police:Alert")
AddEventHandler(
    "Police:Alert",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 388 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("Police:SeizeCash")
AddEventHandler(
    "Police:SeizeCash",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 389 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("Police:SeizeItem")
AddEventHandler(
    "Police:SeizeItem",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 390 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("911toggle")
AddEventHandler(
    "911toggle",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 391 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("Police:Cuff")
AddEventHandler(
    "Police:Cuff",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 392 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("Debt:Increment")
AddEventHandler(
    "Debt:Increment",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 393 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("Banking:DefaultTransaction")
AddEventHandler(
    "Banking:DefaultTransaction",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 394 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("Bank:GiveCash")
AddEventHandler(
    "Bank:GiveCash",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 395 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("Banking:Welfare")
AddEventHandler(
    "Banking:Welfare",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 396 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("Banking:WelfareRequest")
AddEventHandler(
    "Banking:WelfareRequest",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 397 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("Banking:CollectWelfare")
AddEventHandler(
    "Banking:CollectWelfare",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 398 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("Banking:TransferMoney")
AddEventHandler(
    "Banking:TransferMoney",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 399 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("Banking:WithdrawMoney")
AddEventHandler(
    "Banking:WithdrawMoney",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 400 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("DebitBankAccount")
AddEventHandler(
    "DebitBankAccount",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 401 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("grp:getSharedObject")
AddEventHandler(
    "grp:getSharedObject",
    function()
        local src = source
        TriggerEvent(
            "Fidelis:Server:HandleBan",
            src,
            "Fidelis",
            "[Autoban] Trigger ID: 402 | Lua-Injecting Detected.",
            0
        )
    end
)

RegisterNetEvent("es:addCommand")
AddEventHandler("es:addCommand", function()
    local src = source
    TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 404 | Lua-Injecting Detected.", 0)
end)

RegisterNetEvent("es:getPlayerFromId")
AddEventHandler("es:getPlayerFromId", function()
    local src = source
    TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 405 | Lua-Injecting Detected.", 0)
end)

RegisterNetEvent("bank:deposit")
AddEventHandler("bank:deposit", function()
    local src = source
    TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 406 | Lua-Injecting Detected.", 0)
end)

RegisterNetEvent("bank:withdraw")
AddEventHandler("bank:withdraw", function()
    local src = source
    TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 407 | Lua-Injecting Detected.", 0)
end)

RegisterNetEvent("bank:transfer")
AddEventHandler("bank:transfer", function()
    local src = source
    TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 408 | Lua-Injecting Detected.", 0)
end)

RegisterNetEvent("bank:givecash")
AddEventHandler("bank:givecash", function()
    local src = source
    TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 409 | Lua-Injecting Detected.", 0)
end)

RegisterNetEvent("es:playerLoaded")
AddEventHandler("es:playerLoaded", function()
    local src = source
    TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 410 | Lua-Injecting Detected.", 0)
end)
