-- USED IN ENUMERATING ITEMS
local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}

-- ENUMERATES ENTITIES
local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or (id == 0) then
            disposeFunc(iter)
            return
        end

        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)

        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next

        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

-- ENUMERATES OBJECTS
function EnumerateObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end
exports("EnumerateObjects", EnumerateObjects)

-- ENUMERATES PEDS
function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end
exports("EnumeratePeds", EnumeratePeds)

-- ENUMERATES VEHICLES
function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end
exports("EnumerateVehicles", EnumerateVehicles)

-- ENUMERATES PICKUPS
function EnumeratePickups()
    return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end
exports("EnumeratePickups", EnumeratePickups)

-- ITERATES THROUGH CLOSEST PEDS TO PLAYER
function IteratePeds()
    local pedList = {}
    local done = false
    local handle, ped = FindFirstPed()
    repeat
        done, ped = FindNextPed(handle)
        pedList[#pedList + 1] = ped
    until not done
    EndFindPed(handle)
    return pedList
end
exports("IteratePeds", IteratePeds)

-- ITERATES THROUGH CLOSEST VEHICLES TO PLAYER
function IterateVehicles()
    local vehList = {}
    local done = false
    local handle, veh = FindFirstVehicle()
    repeat
        done, veh = FindNextVehicle(handle)
        vehList[#vehList + 1] = veh
    until not done
    EndFindVehicle(handle)
    return vehList
end
exports("IterateVehicles", IterateVehicles)
