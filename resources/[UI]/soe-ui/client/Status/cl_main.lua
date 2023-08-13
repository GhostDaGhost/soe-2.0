isTalking = false

-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, UPDATE VOICE RANGE INDICATOR
function SetVoiceRangeState(range)
    SendNUIMessage({type = "Status.UpdateVOIPRange", range = range})
end
exports("SetVoiceRangeState", SetVoiceRangeState)

-- WHEN TRIGGERED, UPDATES RADIO TRANSMITTING INDICATOR
function SetTransmittingState(isTransmitting, type)
    SendNUIMessage({type = "Status.SetTransmittingState", isTransmitting = isTransmitting, channelType = type})
end
exports("SetTransmittingState", SetTransmittingState)

-- WHEN TRIGGERED, HIDES VANILLA HUD COMPONENTS
function HideHUDComponents()
    -- HIDE RETICLE
    if not IsAimCamActive() or not IsFirstPersonAimCamActive() then
        HideHudComponentThisFrame(14)
    end

    -- HIDE OTHER HUD COMPONENTS LIKE AMMO, CASH, STREET NAME, ETC
    DisplayAmmoThisFrame(false)
    HideHudComponentThisFrame(3)
    HideHudComponentThisFrame(4)
    HideHudComponentThisFrame(7)
    HideHudComponentThisFrame(9)
    HideHudComponentThisFrame(20)
end

-- WHEN TRIGGERED, UPDATES THE STATUS CIRCLES
function UpdateCoreStatus()
    local ped = PlayerPedId()
    local myStatus = {type = "Status.PopulateUI", status = {}}

    myStatus["status"][1] = {name = "health", value = ((GetEntityHealth(ped) - 100) / GetPedMaxHealth(ped) * 200)}
    myStatus["status"][2] = {name = "armor", value = GetPedArmour(ped)}
    myStatus["status"][3] = {name = "hunger", value = (exports["soe-nutrition"]:GetHunger() / 2.5)}
    myStatus["status"][4] = {name = "thirst", value = (exports["soe-nutrition"]:GetThirst() / 2.5)}
    myStatus["status"][5] = {name = "oxygen", value = (GetPlayerUnderwaterTimeRemaining(PlayerId())) * 5}

    SendNUIMessage(myStatus)
    SendNUIMessage({type = "Status.Display", show = hud})
end
