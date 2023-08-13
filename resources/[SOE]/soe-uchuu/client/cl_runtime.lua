local loopIndex = 0
local userLoggedIn, characterSelected, characterSpawned = false, false, false

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, DISABLE LOOT PICKUPS
local function DisableLootPickups()
    local playerID = PlayerId()
    for pickup = 1, #lootPickupList do
        ToggleUsePickupsForPlayer(playerID, lootPickupList[pickup], false)
    end
end

-- WHEN TRIGGERED, ENABLE TRAINS/TRAMS
local function EnableTrains()
    SwitchTrainTrack(0, true)
    SwitchTrainTrack(3, true)

    SetTrainTrackSpawnFrequency(0, 120000)
    SetRandomTrains(1)
end

-- HANDLES DISCORD RICH PRESENCE
local function HandleDiscordPresence()
    -- SET DISCORD RICH PRESENCE
    SetDiscordAppId(672903701601714177)
    SetDiscordRichPresenceAsset("epcg")
    SetDiscordRichPresenceAssetText("Playing on State of Emergency!")

    if (GetConvarInt("usingOneSyncInfinity", 0) == 1) then
        local count, max = exports["soe-utils"]:GetPlayerCount()
        SetRichPresence(("%s/%s players"):format(count, max))
    end

    -- PRESENCE BUTTONS
    SetDiscordRichPresenceAction(0, "Website", "https://evolpcgaming.com/")
    SetDiscordRichPresenceAction(1, "Connect", "fivem://connect/beta.soe.gg")
end

-- HANDLES TICK EVENTS
local function HandlePerTickEvents()
    local ped = PlayerPedId()
    local playerID = PlayerId()

    -- DISABLES HEADSHOTS
    SetPedSuffersCriticalHits(ped, false)

    -- DISABLES AMBIENT SIRENS
    DistantCopCarSirens(false)

    -- DISABLE VEHICLE REWARDS
    DisablePlayerVehicleRewards(playerID)

    -- SET TIME FOR TASER STUN
    SetPedMinGroundTimeForStungun(ped, 10000)

    -- DISABLES THE FLYING CINEMATIC MUSIC / JUMP SPAM PREVENTION
    if (loopIndex % 85 == 0) then
        ResetPlayerStamina(playerID)
        if IsPedInAnyHeli(ped) or IsPedInAnyPlane(ped) then
            SetAudioFlag("DisableFlightMusic", true)
        end

        if IsPedOnFoot(ped) and not IsPedSwimming(ped) and (IsPedRunning(ped) or IsPedSprinting(ped)) and not IsPedClimbing(ped) and IsPedJumping(ped) and not IsPedRagdoll(ped) then
            if (math.random() < 0.8) then
                SetTimeout(550, function()
                    ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 0.02)
                    SetPedToRagdoll(ped, 5000, 1, 2)
                end)
            end
        end
    -- DISABLES ON FOOT/VEHICLE IDLE CAMERA
    elseif (loopIndex % 285 == 0) then
        InvalidateIdleCam()
        InvalidateVehicleIdleCam()
    -- SAVES LAST KNOWN LOCATION FOR CHARACTER
    elseif (loopIndex % 1230 == 0) then
        loopIndex = 0
        SaveLastPosition()

        -- UPDATE DISCORD PRESENCE IF ONESYNC INFINITY IS ON
        if (GetConvarInt("usingOneSyncInfinity", 0) == 1) then
            HandleDiscordPresence()
        end
    end
end

-- **********************
--      Main Loop
-- **********************
CreateThread(function()
    Wait(3500)

    --EnableTrains() DISABLED FOR GLITCHES 8/23/2021
    HandleDiscordPresence()
    DisableLootPickups()
    while true do
        Wait(0)
        -- ITEMS TO EXECUTE AFTER CHARACTER SPAWNED
        if characterSpawned then
            loopIndex = loopIndex + 1
            if (loopIndex % 5 == 0) then
                HandlePerTickEvents()
            end
        end

        -- GET CURRENT TRAFFIC DATA FROM SERVER
        if not getTrafficData then
            TriggerServerEvent("Uchuu:Server:GetTrafficMult")
            getTrafficData = true
        end
        -- SETS TRAFFIC EVERY FRAME
        Traffic()
    end
end)

-- **********************
--        Events
-- **********************
RegisterNetEvent("Uchuu:Client:CharacterSelected")
AddEventHandler("Uchuu:Client:CharacterSelected", function(charID)
    characterSelected = true
end)

RegisterNetEvent("Uchuu:Client:PlayerSpawned")
AddEventHandler("Uchuu:Client:PlayerSpawned", function(spawnID)
    characterSpawned = true
end)

RegisterNetEvent("Uchuu:Client:UserLoggedIn")
AddEventHandler("Uchuu:Client:UserLoggedIn", function(userID)
    userLoggedIn = true
    ShutdownLoadingScreenNui()

    -- DISABLE AI POLICE/FIRE/EMS RESPONSE
    for i = 1, 14 do
        EnableDispatchService(i, false)
    end

    -- DISABLE WANTED LEVELS
    SetMaxWantedLevel(0)

    -- DISABLE AI ENEMY/POLICE BLIPS
    SetPoliceRadarBlips(false)

    -- ALLOW FRIENDLY FIRE - NO DISABLED TARGETS
    NetworkSetFriendlyFireOption(true)
    SetCanAttackFriendly(PlayerPedId(), true, true)
end)
