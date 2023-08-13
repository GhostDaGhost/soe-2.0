local spawned = false
local prevPos = vector3(0, 0, 0)
local lastAnticheatScan, thisAnticheatScan, cooldowns = {}, {}, {}

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, GET THE CURRENT WEAPON THE PED HAS BY NAME
local function GetPedWeaponName(ped)
    local hash = GetSelectedPedWeapon(ped)
    local name = exports["soe-utils"]:GetWeaponNameFromHashKey(hash)
    return name or "WEAPON_UNDEFINED"
end

-- WHEN TRIGGERED, LOG THIS ANTICHEAT SCAN
local function LogThisAnticheatScan()
    lastAnticheatScan = {}

    for scanID, scanData in pairs(thisAnticheatScan) do
        lastAnticheatScan[scanID] = scanData
    end
end

-- WHEN TRIGGERED, CHECK IF THE PLAYER IS SPECTATING OTHER PLAYERS (NO COOLDOWN NECESSARY, NEVER FALSE POSITIVES)
local function IsSpectating()
    if NetworkIsInSpectatorMode() then
        exports["soe-logging"]:ScreenshotMyScreen("Spectating Other Players")
        return true
    end
    return false
end

-- WHEN TRIGGERED, CHECK IF THE PLAYER IS USING NIGHT VISION WHILST NOT IN A HELICOPTER
local function IsPlayerUsingNightVision(ped)
    if GetUsingnightvision(true) and not IsPedInAnyHeli(ped) then
        exports["soe-logging"]:ScreenshotMyScreen("Using Night Vision (while not in a helicopter)")
        return true
    end
    return false
end

-- WHEN TRIGGERED, CHECK IF THE PLAYER IS USING THERMAL VISION WHILST NOT IN A HELICOPTER
local function IsPlayerUsingThermalVision(ped)
    if GetUsingseethrough(true) and not IsPedInAnyHeli(ped) then
        exports["soe-logging"]:ScreenshotMyScreen("Using Thermal Vision (while not in a helicopter)")
        return true
    end
    return false
end

-- WHEN TRIGGERED, CHECK IF THE PLAYER IS USING SPEED HACKS ON FOOT
local function IsRunningTooFast(ped)
    if not IsPedInAnyVehicle(ped, true) and GetEntitySpeed(ped) > 15 and not IsPedFalling(ped) and not IsPedInParachuteFreeFall(ped) and not IsPedJumpingOutOfVehicle(ped) and not IsPedRagdoll(ped) and not exports["soe-utils"]:IsModelADog(ped) then
        return true
    end
    return false
end

-- WHEN TRIGGERED, CHECK IF THE PLAYER SOMEHOW HAS A MINIMAP VISIBLE
local function HasMinimap(ped)
    local isPhoneOpen = exports["soe-gphone"]:IsPhoneOpen()
    if not IsRadarHidden() and not IsPedInAnyVehicle(ped, true) and not exports["soe-ui"]:GetMinimap() and not isPhoneOpen then
        exports["soe-logging"]:ScreenshotMyScreen("Has Minimap (Not using a GPS or in vehicle)")
        return true
    end
    return false
end

-- WHEN TRIGGERED, CHECK IF THE PLAYER IS INVISIBLE (TEXTURE LOSS CAN MAKE THIS FALSE POSITIVE)
local function IsPedInvisible(ped)
    -- CHECK IF THE PLAYER HAS EVEN SPAWNED
    if not spawned then
        return false
    end

    local alphaIsLow = (GetEntityAlpha(ped) <= 150)
    if not IsEntityVisible(ped) or not IsEntityVisibleToScript(ped) or alphaIsLow then
        local isOnCooldown = (cooldowns["invisible"] or 0) > GetGameTimer()
        if not isOnCooldown then
            exports["soe-logging"]:ScreenshotMyScreen("Possibly Invisible")
            cooldowns["invisible"] = GetGameTimer() + 8500
        end

        return true
    end
    return false
end

-- WHEN TRIGGERED, CHECK IF A PLAYER IS USING A FORBIDDEN WEAPON
local function IsUsingBadWeapon(myWeapon)
    for _, weapon in pairs(bannableWeapons) do
        if (myWeapon == weapon) then
            -- TAKE A SCREENSHOT OF THE WEAPON
            local isOnCooldown = (cooldowns["badWeapon"] or 0) > GetGameTimer()
            if not isOnCooldown then
                exports["soe-logging"]:ScreenshotMyScreen("Possesses Bannable Weapon")
                cooldowns["badWeapon"] = GetGameTimer() + 8500
            end

            -- REMOVE THE WEAPON
            RemoveWeaponFromPed(PlayerPedId(), GetHashKey(myWeapon))
            return true
        end
    end
    return false
end

-- WHEN TRIGGERED, CHECK IF THE PLAYER IS EXTREMELY FAR FROM THEIR LAST RECORDED COORDINATES
local function DidPedTeleport(ped)
    -- IF THE LAST SEEN COORDINATES DON'T EXIST
    if not lastAnticheatScan["coords"] then
        return false
    end

    -- IF NOT SPAWNED YET
    if not spawned then
        return false
    end

    -- SOME THINGS CAN BE VERY FAST
    if IsPedInAnyHeli(ped) or IsPedInAnyPlane(ped) or (GetEntitySpeed(ped) > 4) then
        return false
    end

    -- RECORD APPROPRIATE COORDINATES
    local myNowPos = GetEntityCoords(ped)
    local myLastPos = lastAnticheatScan["coords"]

    -- COMPARE DISTANCE WITH OUR MAXIMUM ALLOWED
    if #(myNowPos - myLastPos) >= 325.0 then
        return true
    end
    return false
end

-- GET THREAT LEVEL OF PLAYER
local function GetThreatLevel()
    local bannable, suspicious = false, false

    -- START SETTING THREAT LEVELS
    local teleported = thisAnticheatScan["teleported"] and not thisAnticheatScan["teleportAuthorized"]
    local usingSpecialVision = thisAnticheatScan["nightVisionActive"] or thisAnticheatScan["thermalVisionActive"]

    local speeding, hasMinimap = thisAnticheatScan["speed"], thisAnticheatScan["hasMinimap"]
    local invisible, invincible, badWeapon = thisAnticheatScan["invisible"], thisAnticheatScan["invincible"], thisAnticheatScan["badWeapon"]

    -- DETERMINE WHAT TO DO HERE
    local possiblyModding = teleported or invisible or invincible or usingSpecialVision or badWeapon or speeding or hasMinimap
    if possiblyModding or bannable then
        suspicious = true
    end
    return suspicious, bannable
end

-- CONSTRUCT A BAN MESSAGE
local function ConstructBanReason()
    local banReason = ""
    if thisAnticheatScan["badWeapon"] then
        banReason = banReason .. "Bannable Weapon"
    end

    if thisAnticheatScan["invincible"] then
        banReason = banReason .. " | Invincibility"
    end

    if thisAnticheatScan["teleported"] and not thisAnticheatScan["teleportAuthorized"] then
        banReason = banReason .. " | Teleportation"
    end

    banReason = banReason .. " | Hacking/Exploiting/Injecting/Memory Editing"
    return banReason
end

-- **********************
--    Global Functions
-- **********************
-- AUTHORIZE A TELEPORT THIS CYCLE
function AuthorizeTeleport()
    teleportAuthorized = true
end

-- WHEN TRIGGERED, CHECK IF A SENT CHAT MESSAGE HAS A OFFENSIVE WORD
function ValidateChatMessage(message)
    for restrictedWord, anyInstance in pairs(restrictedChatWords) do
        if anyInstance then
            if message:match(restrictedWord) then
                return false, restrictedWord
            end
        else
            if string.find(message, "%f[%a]" .. restrictedWord .. "%f[%A]") then
                return false, restrictedWord
            end
        end
    end
    return true, nil
end

-- WHEN TRIGGERED, GATHER A LIST OF ACTIVE RESOURCES AND CHECK WITH SERVER
function InspectCurrentResources()
    local resources = {}
    for i = 0, GetNumResources() - 1 do
        resources[i + 1] = GetResourceByFindIndex(i)
    end
    TriggerServerEvent("Fidelis:Server:HandleChecks", {status = true, type = "Resource Check", resources = resources})
end

-- WHEN TRIGGERED, RUN A VEHICLE MODEL AND CHECK IF ITS A RESTRICTED VEHICLE
function RestrictedVehicleCheck(ped)
    local restricted = false
    local veh = GetVehiclePedIsIn(ped, false)
    local model = GetEntityModel(veh)

    for i = 0, #restrictedVehicles do
        if (GetHashKey(restrictedVehicles[i]) == model) then
            restricted = true
        end
    end

    if restricted then
        exports["soe-logging"]:ScreenshotMyScreen("Stolen Restricted Vehicle")
    end
end

-- WHEN TRIGGERED, DISABLE FUNCTION KEYS WHEN NOT SPAWNED... NO NEED FOR THEM TO BE USED IN LOGIN
function DisableFunctionKeys()
    DisableControlAction(0, 288, true) -- F1
    DisableControlAction(0, 289, true) -- F2
    DisableControlAction(0, 170, true) -- F3
    DisableControlAction(0, 318, true) -- F5 (1)
    DisableControlAction(0, 327, true) -- F5 (2)
    DisableControlAction(0, 166, true) -- F5 (3)
    DisableControlAction(0, 167, true) -- F6
    DisableControlAction(0, 168, true) -- F7
    DisableControlAction(0, 169, true) -- F8
    DisableControlAction(0, 56, true) -- F9
    DisableControlAction(0, 57, true) -- F10
    DisableControlAction(0, 344, true) -- F11
end

-- WHEN TRIGGERED, CHECK IF PLAYER IS AFK
function AFKKicker()
    -- IF PLAYER IS USING APPEARANCE MENUS, DON'T MARK THEM AFK
    if (GetResourceState("soe-appearance") == "started") and exports["soe-appearance"]:IsUsingAppearanceMenu() then
        idleMinutes = 30
        return
    end

    local pos = GetEntityCoords(PlayerPedId())
    if #(pos - prevPos) > 0.25 then
        prevPos = pos
        idleMinutes = 30
    else
        idleMinutes = idleMinutes - 1
    end

    -- DISPLAY WARNING MESSAGES OR KICK BASED ON MINUTES AFK
    if (idleMinutes > 0 and idleMinutes < 10) then
        if (idleMinutes > 1) then
            TriggerEvent("Chat:Client:SendMessage", "system", ("You will be automatically kicked for being AFK in %s minutes!"):format(idleMinutes))
        else
            TriggerEvent("Chat:Client:SendMessage", "system", ("You will be automatically kicked for being AFK in %s minute!"):format(idleMinutes))
        end
    elseif (idleMinutes <= 0) then
        TriggerServerEvent("Fidelis:Server:AFKKick", {status = true})
    end
end

-- PROCESS ANTICHEAT THIS CYCLE
function ProcessAnticheat()
    local ped, playerID = PlayerPedId(), PlayerId()
    thisAnticheatScan = {}

    -- GATHER GENERAL INFORMATION ABOUT THE PLAYER
    --thisAnticheatScan["teleported"] = DidPedTeleport(ped)
    thisAnticheatScan["teleportAuthorized"] = teleportAuthorized
    thisAnticheatScan["coords"] = GetEntityCoords(ped)
    teleportAuthorized = false

    thisAnticheatScan["spectating"] = IsSpectating()
    --[[thisAnticheatScan["invisible"] = IsPedInvisible(ped)
    thisAnticheatScan["invincible"] = GetPlayerInvincible(playerID)
    thisAnticheatScan["speed"] = IsRunningTooFast(ped)
    thisAnticheatScan["currentSpeed"] = GetEntitySpeed(ped)]]

    thisAnticheatScan["nightVisionActive"] = IsPlayerUsingNightVision(ped)
    thisAnticheatScan["thermalVisionActive"] = IsPlayerUsingThermalVision(ped)
    --thisAnticheatScan["hasMinimap"] = HasMinimap(ped)

    thisAnticheatScan["currentWeapon"] = GetPedWeaponName(ped)
    thisAnticheatScan["badWeapon"] = IsUsingBadWeapon(GetPedWeaponName(ped))

    -- ARE PLAYER ACTIONS SUSPICIOUS AND/OR BANNABLE
    local suspicious, bannable = GetThreatLevel()

    -- PLAYER IS SUSPICIOUS
    if suspicious then
        --print("SUSPICIOUS ACTIVITY ~ Fidelis")

        -- LOG THIS SUSPICIOUS ACTIVITY ALERT
        local isOnCooldown = (cooldowns["scanning"] or 0) > GetGameTimer()
        if not isOnCooldown then
            cooldowns["scanning"] = GetGameTimer() + 10000

            local msg = "HAS TRIPPED A SUSPICIOUS ALERT | SCAN RESULTS: " .. json.encode(thisAnticheatScan)
            exports["soe-logging"]:ServerLog("Suspicious Activity - Possible Modding (Fidelis)", msg)
        end
    end

    -- LOG THIS SCAN
    LogThisAnticheatScan()
end

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, DETECT IF A RESOURCE IS SHUT DOWN BY A PLAYER
AddEventHandler("onClientResourceStop", function(resource)
    exports["soe-logging"]:ServerLog("Resource Stopped - Possible Injection (Fidelis)", "HAS STOPPED A RESOURCE FROM THEIR CLIENT | RESOURCE: " .. resource)
end)

AddEventHandler("onResourceStop", function(resource)
    if (GetCurrentResourceName() ~= resource) then return end
    exports["soe-logging"]:ServerLog("Resource Stopped - Possible Injection (Fidelis)", "HAS STOPPED A RESOURCE FROM THEIR CLIENT | RESOURCE: " .. resource)
end)

-- WHEN TRIGGERED, START DETECTING NEW RESOURCE STARTS
AddEventHandler("SpawnManager:Client:PlayerSpawned", function()
    Wait(3500)
    spawned = true
end)

-- WHEN TRIGGERED, DETECT IF A RESOURCE IS STARTED BY A PLAYER
AddEventHandler("onClientResourceStart", function(resource)
    if not spawned then return end
    exports["soe-logging"]:ServerLog("Resource Started - Possible Injection (Fidelis)", "HAS STARTED A RESOURCE FROM THEIR CLIENT | RESOURCE: " .. resource)
end)

-- WHEN TRIGGERED, PERFORM THUNDER AND LIGHTNING UPON A PLAYER BAN
RegisterNetEvent("Fidelis:Client:LightningStrike")
AddEventHandler("Fidelis:Client:LightningStrike", function(data)
    if not data.status then return end
    ForceLightningFlash()
end)

-- LEAVING VEHICLE LOG
AddEventHandler("BaseEvents:Client:LeftVehicle", function(veh, seat, hash, netID)
    local primary, vin = GetVehicleColours(veh), DecorGetInt(veh, "vin")
    local color = exports["soe-utils"]:GrabVehicleColors()[tostring(primary)]
    local pos, plate, model = GetEntityCoords(veh), GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh)))

    local msg = ("HAS LEFT A VEHICLE | PLATE: %s | MODEL: %s | POS: %s | COLOR: %s | VIN: %s | NET ID: %s | SEAT: %s | HASH: %s"):format(plate, model, pos, color, vin, netID, seat, hash)
    exports["soe-logging"]:ServerLog("Left Vehicle", msg)
end)

-- ENTERING VEHICLE LOG
AddEventHandler("BaseEvents:Client:EnteringVehicle", function(veh, seat, hash, netID)
    local primary, vin = GetVehicleColours(veh), DecorGetInt(veh, "vin")
    local color = exports["soe-utils"]:GrabVehicleColors()[tostring(primary)]
    local pos, plate, model = GetEntityCoords(veh), GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh)))

    local msg = ("IS ENTERING A VEHICLE | PLATE: %s | MODEL: %s | POS: %s | COLOR: %s | VIN: %s | NET ID: %s | SEAT: %s | HASH: %s"):format(plate, model, pos, color, vin, netID, seat, hash)
    exports["soe-logging"]:ServerLog("Entering Vehicle", msg)
end)

-- ENTERED VEHICLE LOG
AddEventHandler("BaseEvents:Client:EnteredVehicle", function(veh, seat, hash, netID)
    local primary, vin = GetVehicleColours(veh), DecorGetInt(veh, "vin")
    local color = exports["soe-utils"]:GrabVehicleColors()[tostring(primary)]
    local pos, plate, model = GetEntityCoords(veh), GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh)))

    local msg = ("HAS ENTERED INTO A VEHICLE | PLATE: %s | MODEL: %s | POS: %s | COLOR: %s | VIN: %s | NET ID: %s | SEAT: %s | HASH: %s"):format(plate, model, pos, color, vin, netID, seat, hash)
    exports["soe-logging"]:ServerLog("Entered Vehicle", msg)

    -- IF VEHICLE IS A DEALERSHIP PREVIEW VEHICLE -- LOG THIS IMMEDIATELY
    if DecorExistOn(veh, "isDealershipVehicle") and (DecorGetBool(veh, "isDealershipVehicle") == true) then
        local msg = ("HAS ENTERED INTO A DEALERSHIP PREVIEW VEHICLE | PLATE: %s | MODEL: %s | POS: %s | COLOR: %s | VIN: %s | NET ID: %s | SEAT: %s | HASH: %s"):format(plate, model, pos, color, vin, netID, seat, hash)
        exports["soe-logging"]:ServerLog("Entered Dealership Preview Vehicle", msg)

        -- TAKE SOME SCREENSHOTS
        for times = 1, 3 do
            exports["soe-logging"]:ScreenshotMyScreen("Possibly Using Dealership Preview Vehicle")
            Wait(2500)
        end
    end
end)
