-- PINS VARIABLES
local pinOne = false
local pinTwo = false
local pinThree = false
local pinFour = false
local pinSound = GetSoundId()

-- GENERAL DRILLING VARIABLES
local drillFX
local drillObj
local scaleformDrilling
local newDrilling = false

local drillSpeed = 0.0
local drillDepth = 0.0
local drillPushed = 0.0
local drillResetTime = 0
local drillPosition = 0.0
local drillTemperature = 0.0

-- IF FAILED TO DRILL, DO THE FOLLOWING
local function FailedToDrill()
    drillSpeed = 0.0
    drillPushed = 0.0
    drillPosition = 0.0
    drillTemperature = 0.0
    RemoveParticleFx(drillFX, 0)

    local ped = PlayerPedId()
    TaskPlayAnim(ped, "anim@heists@fleeca_bank@drilling", "drill_straight_fail", 8.0, 8.0, 2000, 2, 0, 0, 0, 0)
end

-- REMOVES DRILL AND UNFREEZES PLAYER
local function RemoveDrill()
    EnableControlAction(2, 27)
    EnableControlAction(2, 37)
    SetPedCanSwitchWeapon(PlayerPedId(), true)
    FreezeEntityPosition(PlayerPedId(), false)
    ClearPedTasksImmediately(PlayerPedId())
    if (drillObj ~= nil) then
        DeleteEntity(drillObj)
    end

    if not HasSoundFinished(pinSound) then
        StopSound(pinSound)
    end

    RemoveParticleFx(drillFX, 0)

    drillDepth = 0.0
    drillPosition = 0.0
    drillTemperature = 0.0
    drillSpeed = 0.0
    drillPushed = 0.0
    pinOne = false
    pinTwo = false
    pinThree = false
    pinFour = false

    FreezeEntityPosition(PlayerPedId(), false)
    SetScaleformMovieAsNoLongerNeeded(scaleformDrilling)
end

-- RUNTIME FOR DRILLING
local function DrillTick()
    DisableControlAction(2, 37, true)
    DisableControlAction(2, 27, true)
    DrawScaleformMovieFullscreen(scaleformDrilling, 255, 255, 255, 255)

    if IsControlJustPressed(2, 241) then
        if (drillPushed < 1.0) then
            drillPushed = drillPushed + 0.125
        else
            drillPushed = 1.0
        end
    end

    if IsControlJustPressed(2, 242) then
        if (drillPushed > 0.0) then
            drillPushed = drillPushed - 0.125
        else
            drillPushed = 0.0
        end
    end

    if IsDisabledControlPressed(0, 24) or IsControlPressed(0, 24) then
        if (drillSpeed < 1.0) then
            drillSpeed = drillSpeed + 0.002
        else
            drillSpeed = 1.0
        end
    else
        if (drillSpeed > 0.0) then
            drillSpeed = drillSpeed - 0.008
        else
            drillSpeed = 0.0
        end
    end

    local ped = PlayerPedId()
    if (drillResetTime < GetGameTimer()) then
        if (drillPosition == 0.0 and not IsEntityPlayingAnim(ped, "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 3)) then
            TaskPlayAnim(ped, "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
        end

        if (drillPosition > 0.0 and not IsEntityPlayingAnim(ped, "anim@heists@fleeca_bank@drilling", "drill_right_end", 3)) then
            TaskPlayAnim(ped, "anim@heists@fleeca_bank@drilling", "drill_right_end", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
        end

        if (drillTemperature < 1.0 and drillPosition > drillDepth - 0.2) then
            if (drillSpeed > 0.2 and drillSpeed < 0.8) then
                drillDepth = drillDepth + 0.0003
            end
            if (drillSpeed > 0.3 and drillSpeed < 0.7) then
                drillDepth = drillDepth + 0.0003
            end
            if (drillDepth > 0.776 and (drillSpeed > 0.2 and drillSpeed < 0.7)) then
                drillDepth = drillDepth + 0.005
            end
        end

        if
            (((drillPushed > 0.75 and drillSpeed > 0) or (drillPushed > 0 and drillSpeed > 0.75)) and
                drillPosition > drillDepth - 0.2 and
                drillTemperature < 1)
         then
            drillTemperature = drillTemperature + 0.015
        end

        if ((drillSpeed == 0.0 or drillPosition == 0.0) and drillTemperature > 0.0) then
            drillTemperature = drillTemperature - 0.005
        end

        if (drillSpeed < 0.01) then
            RemoveParticleFx(drillFX, 0)
        end

        if (drillPushed > 0.0) then
            if (drillPosition < drillDepth - 0.2) then
                drillPosition = drillPosition + 0.05
            end
            if (drillPosition < drillDepth) then
                drillPosition = drillPosition + 0.01
                if (drillSpeed > 0.0) then
                    RemoveParticleFx(drillFX, 0)
                    UseParticleFxAsset("fm_mission_controler")
                    drillFX =
                        StartNetworkedParticleFxLoopedOnEntity(
                        "scr_drill_debris",
                        drillObj,
                        0.0,
                        -0.55,
                        0.01,
                        90.0,
                        90.0,
                        90.0,
                        0.8,
                        0,
                        0,
                        0
                    )
                    SetParticleFxLoopedEvolution(drillFX, "power", 0.7, 0)
                else
                    RemoveParticleFx(drillFX, 0)
                end
            end
        else
            drillPosition = 0.0
            RemoveParticleFx(drillFX, 0)
        end

        if (drillDepth > 0.326 and not pinOne) then
            PlaySoundFrontend(pinSound, "Drill_Pin_Break", "DLC_HEIST_FLEECA_SOUNDSET", 1)
            pinOne = true
        end

        if (drillDepth > 0.476 and not pinTwo) then
            PlaySoundFrontend(pinSound, "Drill_Pin_Break", "DLC_HEIST_FLEECA_SOUNDSET", 1)
            pinTwo = true
        end

        if (drillDepth > 0.625 and not pinThree) then
            PlaySoundFrontend(pinSound, "Drill_Pin_Break", "DLC_HEIST_FLEECA_SOUNDSET", 1)
            pinThree = true
        end

        if (drillDepth > 0.776 and not pinFour) then
            PlaySoundFrontend(pinSound, "Drill_Pin_Break", "DLC_HEIST_FLEECA_SOUNDSET", 1)
            pinFour = true
        end

        if (drillTemperature > 0.99 or drillPosition > drillDepth + 0.3) then
            if not HasSoundFinished(pinSound) then
                StopSound(pinSound)
            end
            FailedToDrill()
        end
    end

    CallScaleformMovieMethodWithNumber(
        scaleformDrilling,
        "SET_SPEED",
        drillSpeed,
        -1082130432,
        -1082130432,
        -1082130432,
        -1082130432
    )
    CallScaleformMovieMethodWithNumber(
        scaleformDrilling,
        "SET_DRILL_POSITION",
        drillPosition,
        -1082130432,
        -1082130432,
        -1082130432,
        -1082130432
    )
    CallScaleformMovieMethodWithNumber(
        scaleformDrilling,
        "SET_TEMPERATURE",
        drillTemperature,
        -1082130432,
        -1082130432,
        -1082130432,
        -1082130432
    )

    if (drillPosition > 0.8) then
        RemoveParticleFx(drillFX, 0)
        drillTemperature = 0.0
        drillSpeed = 0.0
        TaskPlayAnim(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "outro", 1.0, 1.0, 10000, 1, 0, 0, 0, 0)
        Wait(5000)
        RemoveDrill()
        newDrilling = false
        return false
    end
    return true
end

function StartDrilling()
    local ped = PlayerPedId()
    GiveWeaponToPed(ped, -1569615261, 0, true, true)
    SetPedCanSwitchWeapon(ped, false)
    FreezeEntityPosition(ped, true)

    local num = RequestScaleformMovieInstance("DRILLING")
    while not HasScaleformMovieLoaded(num) do
        Wait(100)
    end

    scaleformDrilling = num
    CallScaleformMovieMethodWithNumber(num, "SET_SPEED", 0.0, -1082130432, -1082130432, -1082130432, -1082130432)
    CallScaleformMovieMethodWithNumber(num, "SET_HOLE_DEPTH", 0.1, -1082130432, -1082130432, -1082130432, -1082130432)
    CallScaleformMovieMethodWithNumber(
        num,
        "SET_DRILL_POSITION",
        0.0,
        -1082130432,
        -1082130432,
        -1082130432,
        -1082130432
    )
    CallScaleformMovieMethodWithNumber(num, "SET_TEMPERATURE", 0.0, -1082130432, -1082130432, -1082130432, -1082130432)

    exports["soe-utils"]:LoadPTFXAsset("fm_mission_controler", 100)
    exports["soe-utils"]:LoadAnimDict("anim@heists@fleeca_bank@drilling", 15)

    local model = GetHashKey("hei_prop_heist_drill")
    exports["soe-utils"]:LoadModel(model, 15)
    Wait(1000)

    local pos = GetEntityCoords(ped)
    drillObj = CreateObject(model, pos, true, true, false)

    SetEntityInvincible(drillObj, true)
    FreezeEntityPosition(drillObj, true)
    AttachEntityToEntity(drillObj, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 2, 1)
    SetModelAsNoLongerNeeded(model)
    TaskPlayAnim(ped, "anim@heists@fleeca_bank@drilling", "drill_right_end", 1.0, 0.1, 2000, 1, 0, 0, 0, 0)

    newDrilling = true
    Wait(100)
    while true do
        if (newDrilling == false) then
            return true
        end
        if IsControlJustPressed(0, 177) then
            RemoveDrill()
            return false
        end
        DrillTick()
        Wait(1)
    end
end
