local _onSpot = false
local crackingSafe = false
local _SafeCrackingStates = "Setup"

local function IsSafeUnlocked()
    return _safeLockStatus[_currentLockNum] == nil
end

local function SetSafeDialStartNumber()
    local dialStartNumber = math.random(0, 100)
    SafeDialRotation = (3.6 * dialStartNumber)
end

local function InitSafeLocks()
    if not _safeCombination then
        return
    end

    local locks = {}
    for i = 1, #_safeCombination do
        table.insert(locks, true)
    end

    return locks
end

local function EndMiniGame(safeUnlocked)
    if safeUnlocked then
        PlaySoundFrontend(0, "SAFE_DOOR_OPEN", "SAFE_CRACK_SOUNDSET", true)
    else
        PlaySoundFrontend(0, "SAFE_DOOR_CLOSE", "SAFE_CRACK_SOUNDSET", true)
    end
    crackingSafe = false
    SafeCrackingStates = "Setup"
    ClearPedTasksImmediately(PlayerPedId())
end

local function RelockSafe()
    if not _safeCombination then
        return
    end

    _safeLockStatus = InitSafeLocks()
    _currentLockNum = 1
    _requiredDialRotationDirection = _initDialRotationDirection
    _onSpot = false

    for i = 1, #_safeCombination do
        _safeLockStatus[i] = true
    end
end

local function InitializeSafe(safeCombination)
    _initDialRotationDirection = "Clockwise"
    _safeCombination = safeCombination

    RelockSafe()
    SetSafeDialStartNumber()
end

local function GetCurrentSafeDialNumber(currentDialAngle)
    local number = math.floor((100 * (currentDialAngle / 360)))
    if number > 0 then
        number = (100 - number)
    end
    return math.abs(number)
end

local function RotateSafeDial(rotationDirection)
    if (rotationDirection == "Anticlockwise" or rotationDirection == "Clockwise") then
        local multiplier
        local rotationPerNumber = 3.6
        if rotationDirection == "Anticlockwise" then
            multiplier = 1
        elseif rotationDirection == "Clockwise" then
            multiplier = -1
        end

        local rotationChange = (multiplier * rotationPerNumber)
        SafeDialRotation = (SafeDialRotation + rotationChange)
        PlaySoundFrontend(0, "TUMBLER_TURN", "SAFE_CRACK_SOUNDSET", true)
    end

    _currentDialRotationDirection = rotationDirection
    _lastDialRotationDirection = rotationDirection
end

local function ReleaseCurrentPin()
    _safeLockStatus[_currentLockNum] = false
    _currentLockNum = (_currentLockNum + 1)

    if (_requiredDialRotationDirection == "Anticlockwise") then
        _requiredDialRotationDirection = "Clockwise"
    else
        _requiredDialRotationDirection = "Anticlockwise"
    end

    PlaySoundFrontend(0, "TUMBLER_PIN_FALL_FINAL", "SAFE_CRACK_SOUNDSET", true)
end

local function HandleSafeDialMovement()
    if IsControlJustPressed(0, 34) then
        RotateSafeDial("Anticlockwise")
    elseif IsControlJustPressed(0, 35) then
        RotateSafeDial("Clockwise")
    else
        RotateSafeDial("Idle")
    end
end

local function DrawSprites(drawLocks)
    local dict = "MPSafeCracking"
    local aspectRatio = GetAspectRatio(true)

    DrawSprite(dict, "Dial_BG", 0.48, 0.3, 0.3, (aspectRatio * 0.3), 0, 255, 255, 255, 255)
    DrawSprite(dict, "Dial", 0.48, 0.3, (0.3 * 0.5), ((aspectRatio * 0.3) * 0.5), SafeDialRotation, 255, 255, 255, 255)

    if not drawLocks then
        return
    end

    local xPos = 0.6
    local yPos = ((0.3 * 0.5) + 0.035)
    for _, lockActive in pairs(_safeLockStatus) do
        local lockString
        if lockActive then
            lockString = "lock_closed"
        else
            lockString = "lock_open"
        end

        DrawSprite(dict, lockString, xPos, yPos, 0.025, (aspectRatio * 0.015), 0, 231, 194, 81, 255)
        yPos = yPos + 0.05
    end
end

function StartSafeCracking(combination)
    local result
    crackingSafe = not crackingSafe
    RequestStreamedTextureDict("MPSafeCracking", false)
    RequestAmbientAudioBank("SAFE_CRACK", false)

    if crackingSafe then
        Wait(1000)

        -- INITIALIZE SAFE AND ANIMATION DICTIONARY
        InitializeSafe(combination)
        exports["soe-utils"]:LoadAnimDict("mini@safe_cracking", 15)

        -- TUTORIAL
        exports["soe-ui"]:SendAlert("inform", "Press 'W' to try to crack/leave the safe", 6500)
        exports["soe-ui"]:SendAlert("inform", "Press 'A' to rotate counter-clockwise", 6500)
        exports["soe-ui"]:SendAlert("inform", "Press 'D' to rotate clockwise", 6500)

        while crackingSafe do
            TaskPlayAnim(PlayerPedId(), "mini@safe_cracking", "idle_base", 3.0, 3.0, -1, 1, 0, 0, 0, 0)

            DrawSprites(true)
            result = RunMiniGame()

            if (result == true) then
                return result
            elseif (result == false) then
                return result
            end

            Wait(1)
        end
    end
end

function RunMiniGame()
    if _SafeCrackingStates == "Setup" then
        _SafeCrackingStates = "Cracking"
    elseif _SafeCrackingStates == "Cracking" then
        local isDead = (GetEntityHealth(PlayerPedId()) <= 101)
        if isDead then
            EndMiniGame(false)
            return false
        end

        if IsControlJustPressed(0, 33) then
            EndMiniGame(false)
            return false
        end

        if IsControlJustPressed(0, 32) then
            if _onSpot then
                ReleaseCurrentPin()
                _onSpot = false
                if IsSafeUnlocked() then
                    EndMiniGame(true, false)
                    return true
                end
            else
                EndMiniGame(false)
                return false
            end
        end

        HandleSafeDialMovement()

        local incorrectMovement =
            _currentLockNum ~= 0 and _requiredDialRotationDirection ~= "Idle" and
            _currentDialRotationDirection ~= "Idle" and
            _currentDialRotationDirection ~= _requiredDialRotationDirection

        if not incorrectMovement then
            local currentDialNumber = GetCurrentSafeDialNumber(SafeDialRotation)
            local correctMovement =
                _requiredDialRotationDirection ~= "Idle" and
                (_currentDialRotationDirection == _requiredDialRotationDirection or
                    _lastDialRotationDirection == _requiredDialRotationDirection)
            if correctMovement then
                local pinUnlocked =
                    _safeLockStatus[_currentLockNum] and currentDialNumber == _safeCombination[_currentLockNum]
                if pinUnlocked then
                    PlaySoundFrontend(0, "TUMBLER_PIN_FALL", "SAFE_CRACK_SOUNDSET", true)
                    _onSpot = true
                end
            end
        elseif incorrectMovement then
            _onSpot = false
        end
    end
end
