local isSitting = false
local chairData, closestChair, lastPosition, currentSitObject

-- CHECKS TO SEE IF PLAYER IS NEAR A SITABLE OBJECT
local function IsNearSitableChair()
    local pos = GetEntityCoords(PlayerPedId())
    for _, chair in pairs(chairs) do
        local hash = chair.prop
        if (type(hash) == "string") then
            hash = GetHashKey(hash)
        end

        local chairObj = GetClosestObjectOfType(pos, 1.0, hash, false)
        if DoesEntityExist(chairObj) then
            chairData, closestChair = chair, chairObj
            return true
        end
    end
    return false
end

-- STANDS THE PLAYER UP FROM THE OBJECT THEY ARE CURRENTLY SITTING ON
local function Stand()
    if isSitting then
        local ped = PlayerPedId()
        ClearPedTasks(ped)

        isSitting = false
        local pos = GetEntityCoords(ped)
        if Vdist2(lastPosition, pos) < 10 then
            SetEntityCoords(ped, lastPosition.x, lastPosition.y, lastPosition.z - 1.0)
        end

        FreezeEntityPosition(ped, false)
        FreezeEntityPosition(currentSitObject, false)
        currentSitObject = nil
        exports["soe-ui"]:PersistentAlert("end", "sittingOnChair")
    end
end

-- SITS THE PLAYER DOWN ON THE NEAREST SITABLE OBJECT
local function Sit(chairObject)
    local ped = PlayerPedId()
    lastPosition = GetEntityCoords(ped)
    currentSitObject = chairObject
    FreezeEntityPosition(chairObject, true)

    local objPos = GetEntityCoords(chairObject)
    SetEntityCoords(ped, objPos.x, objPos.y, objPos.z + chairData.verticalOffset)
    SetEntityHeading(ped, GetEntityHeading(chairObject) + chairData.angularOffset)
    FreezeEntityPosition(ped, true)
    isSitting = true
    TaskStartScenarioAtPosition(ped, chairData.scenario, objPos.x, objPos.y, objPos.z - chairData.verticalOffset, GetEntityHeading(chairObject) + 180.0, -1, true, true)

    exports["soe-ui"]:PersistentAlert("start", "sittingOnChair", "inform", "[E] Stand", 500)
end

-- SITTING COMMAND
RegisterCommand("sit", function()
    if IsNearSitableChair() and not isSitting then
        Sit(closestChair)
    end
end)

-- INTERACTION KEYPRESS TO STAND IF ON A CHAIR
AddEventHandler("Utils:Client:InteractionKey", Stand)
