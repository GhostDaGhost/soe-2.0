-- ALL THIS IS NEEDED FOR... POINTING.
local function _in(args)
    return Citizen.InvokeNative(table.unpack(args))
end

local function map(f, r)
    local a = {}
    for i in pairs(r) do a[i] = f(r[i]) end
    return a
end

local function len(T)
    local n = 0
    for _ in pairs(T) do n = n + 1 end
    return n
end

function table.slice(tbl, first, last, step)
    local sliced = {}
    for i = first or 1, last or #tbl, step or 1 do
        sliced[#sliced + 1] = tbl[i]
    end
    return sliced
end

local PointingTask = {
    _NativesLoop = {},
    _NativesPoint = {},
    _NativesLoadAnim = {},
    _variableReplacements = {},
    _pointingAllowed = true,
    _isPointing = false
}

PointingTask.__index = PointingTask

function PointingTask:_getPitch()
    local pitch = GetGameplayCamRelativePitch()
    if (pitch < -70) then
        pitch = -70
    end
    if (pitch > 42) then
        pitch = 42
    end
    return (pitch + 70) / 112
end

function PointingTask:_getHeading()
    local hdg = GetGameplayCamRelativeHeading()
    if (hdg < -180) then
        hdg = -180
    end
    if (hdg > 180) then
        hdg = 180
    end
    return -(hdg + 180) / 360 + 1
end

PointingTask._variableReplacements = {
    ["__Pitch"] = PointingTask._getPitch,
    ["__Heading"] = PointingTask._getHeading,
    ["__GetPlayerPed"] = function()
        return PlayerPedId()
    end
}

function PointingTask:_registerPointingNatives(args)
    self._NativesLoop = table.slice(args, 1, #args - 3)
    self._NativesPoint = args[#args - 2]
    self._NativesLoadAnim = table.slice(args, #args - 1, #args)
end

function PointingTask:_nativesListener()
    RegisterNetEvent("Emotes:Client:ReceivePointingNatives")
    AddEventHandler("Emotes:Client:ReceivePointingNatives", function(args)
        self:_registerPointingNatives(args)
    end)
end

function PointingTask:_updateClientVariables(nativeArguments)
    t = {}
    for i = 1, len(nativeArguments) do
        t[i] = nativeArguments[i]
        for k in pairs(self._variableReplacements) do
            if nativeArguments[i] == k then
                t[i] = self._variableReplacements[k]()
            end
        end
    end
    return t
end

function PointingTask:_pointingLoop()
    CreateThread(function()
        while self._isPointing do
            Wait(1)
            if len(self._NativesLoop) == 0 then
                goto continue
            end
            map(
                function(t)
                    return _in(self:_updateClientVariables(t))
                end,
                self._NativesLoop
            )
            ::continue::
        end
    end)
end

function PointingTask:_loadAnim()
    _in(self._NativesLoadAnim[1])
    while not _in(self._NativesLoadAnim[2]) do
        Wait(1)
    end
end

function PointingTask:isPointingAllowed()
    if not self._pointingAllowed then return false end
    if IsPedCuffed(PlayerPedId()) then return false end
    return true
end

function PointingTask:disable()
    self._pointingAllowed = false
    self:stop()
end

function PointingTask:enable()
    self._pointingAllowed = true
end

function PointingTask:new(...)
    self = setmetatable({}, PointingTask)
    self:_nativesListener()
    return self
end

-- Start pointing
function PointingTask:start()
    if not self:isPointingAllowed() then return end
    if len(self._NativesPoint) == 0 then return end

    self._isPointing = true
    self:_loadAnim()
    self:_pointingLoop()
    _in(self:_updateClientVariables(self._NativesPoint))
end

-- Stop pointing
function PointingTask:stop()
    if not self:isPointingAllowed() then return end

    self._isPointing = false
    ClearPedSecondaryTask(PlayerPedId())
end

function PointingTask:toggle()
    if self._isPointing == false then
        self:start()
    else
        self:stop()
    end
    self._isPointing = not self._isPointing
end

playerPointing = PointingTask:new()

RegisterCommand("+point", function()
    if not playerPointing._isPointing then playerPointing:start() end
end)

RegisterCommand("-point", function()
    if playerPointing._isPointing then playerPointing:stop() end
end)
