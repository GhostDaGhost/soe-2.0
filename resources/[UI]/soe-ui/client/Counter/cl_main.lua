local isCounterOpen = false

-- KEY MAPPINGS
RegisterKeyMapping("+showcounter", "[UI] Show/Hide Player Counter", "KEYBOARD", "F5")

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, PERFORM ANTI-META CHECKS
local function CanSeePlayer(ped)
    -- IF THEY ARE IN CLEAR VIEW, YES WE CAN SEE THEM
    local canSee = false
    canSee = HasEntityClearLosToEntity(PlayerPedId(), ped, 17)

    -- ADDITIONAL CHECKS IF NOT IN VIEW
    local stealthLevel = GetPedStealthMovement(ped)
    if (stealthLevel == nil) then
        stealthLevel = 0
    end

    -- WE CANNOT SEE THE PLAYER IF THEY ARE DUCKING/COVERING/IN STEALTH
    if IsPedDucking(ped) or IsPedInCover(ped, true) or (stealthLevel == 1) then
        canSee = false
    end
    return canSee
end

-- WHEN TRIGGERED, TOGGLE COUNTER/NEARBY IDS
local function ShowIDsAndCounter()
    if not isCounterOpen then
        isCounterOpen = true

        local totalPlayers, max = #GetActivePlayers(), 100
        if (GetConvarInt("usingOneSyncInfinity", 0) == 1) then
            totalPlayers, max = exports["soe-utils"]:GetPlayerCount()
        end

        SendNUIMessage({type = "Counter.Toggle", show = true, maxPlayers = max, players = totalPlayers})
        while isCounterOpen do
            Wait(5)

            -- GET NEAREST PLAYERS AND PUT IDs OVER THEIR HEAD
            for _, player in pairs(GetActivePlayers()) do
                if CanSeePlayer(GetPlayerPed(player)) then
                    if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(GetPlayerPed(player))) <= 45.0 then
                        local pos = GetPedBoneCoords(GetPlayerPed(player), 0x796e)
                        exports["soe-utils"]:DrawText3D(pos.x, pos.y, pos.z + 0.5, ("[%s]"):format(GetPlayerServerId(player)), true)
                    end
                end
            end
        end
    else
        isCounterOpen = false
        SendNUIMessage({type = "Counter.Toggle", show = false})
    end
end

-- **********************
--        Commands
-- **********************
-- WHEN TRIGGERED, TOGGLE COUNTER/NEARBY IDS
RegisterCommand("+showcounter", ShowIDsAndCounter)
RegisterCommand("-showcounter", ShowIDsAndCounter)
