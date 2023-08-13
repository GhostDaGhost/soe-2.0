local maxVehicles = 5
myList = {}

-- REMOVES A VEHICLE FROM THE ANTI-TOW LIST
local function RemoveVehicleFromList(index)
    --print("REMOVING ONE OFF THE LIST!")
    -- ALLOW THE GAME ENGINE TO REMOVE THE VEHICLE AS NECESSARY
    local vehID = myList[index].vehID
    SetEntityAsNoLongerNeeded(vehID)
    SetVehicleAsNoLongerNeeded(vehID)

    -- REMOVE THE ENTRY FROM THE LIST
    table.remove(myList, index)
end

-- ADDS A VEHICLE TO THE ANTI-TOW LIST
local function AddVehicleToList(veh)
    --print("Debug 1.")
    local plate = GetVehicleNumberPlateText(veh)

    -- CHECK IF VEHICLE IS ALREADY IN LIST
    local found
    for _, vehicle in pairs(myList) do
        if (vehicle.plate == plate) then
            found = true
            break
        end
    end

    -- ADD VEHICLE TO LIST IF NOT ALREADY
    if not found then
        --print("Debug 2.")
        table.insert(myList, {vehID = veh, plate = plate})
    end
end

-- FIRES WHEN SOMEONE ENTERS A VEHICLE
AddEventHandler("BaseEvents:Client:EnteredVehicle", function(veh, seat)
    -- IF NOT A DRIVER, RETURN
    if (seat ~= -1) then return end

    -- IF THE LIST IS ALREADY EXCEEDING MAX VEHICLES, DELETE ONE OFF THE LIST
    if #myList == maxVehicles then
        -- CHECK IF THIS NEW VEHICLE IS IN THE LIST ALREADY
		local found 
        local plate = GetVehicleNumberPlateText(veh)
        for _, vehicle in pairs(myList) do
            if (vehicle.plate == plate) then
                found = true
            end
        end

        -- REMOVE A VEHICLE FROM THE LIST IF THE VEHICLE PLAYER IS IN IS NOT ALREADY IN LIST
        if not found then
            RemoveVehicleFromList(1)
        end
    end

    -- CHECK IF VEHICLE IS ALREADY IN THE LIST
    AddVehicleToList(veh)
end)
