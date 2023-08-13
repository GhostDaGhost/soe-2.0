local area_size = 5000.0
local prospecting = exports["soe-jobs"]
local base_location = vector3(134.377, 2008.930, 152.241)
local PROSPECTING_STATUS, PROSPECTING_TARGETS, PROSPECTING_DIFFICULTIES = {}, {}, {}

Prospecting = {}

-- ***********************
--    Global Functions
-- ***********************
function IsProspecting(src)
    return (PROSPECTING_STATUS[src] ~= nil)
end

function Prospecting.AddTarget(x, y, z, data)
    prospecting:AddProspectingTarget(x, y, z, data)
end

function Prospecting.AddTargets(list)
    prospecting:AddProspectingTargets(list)
end

function Prospecting.StartProspecting(player)
    prospecting:StartProspecting(player)
end

function Prospecting.StopProspecting(player)
    prospecting:StopProspecting(player)
end

function Prospecting.IsProspecting(player)
    return prospecting:IsProspecting(player)
end

function Prospecting.SetDifficulty(modifier)
    return prospecting:SetDifficulty(modifier)
end

function InsertProspectingTarget(resource, x, y, z, data)
    PROSPECTING_TARGETS[#PROSPECTING_TARGETS + 1] = {resource = resource, data = data, x = x, y = y, z = z}
end

function AddProspectingTargets(list)
    local resource = GetInvokingResource()
    InsertProspectingTargets(resource, list)
end

function SetDifficulty(modifier)
    local resource = GetInvokingResource()
    PROSPECTING_DIFFICULTIES[resource] = modifier
end

function AddProspectingTarget(x, y, z, data)
    local resource = GetInvokingResource()
    InsertProspectingTarget(resource, x, y, z, data)
end

function StopProspecting(src)
    if not PROSPECTING_STATUS[src] then return end
    TriggerClientEvent("Jobs:Client:ForceStopProspect", src)
end

-- Choose a random item from the item_pool list
function GetNewRandomItem()
    local randomNum = math.random(1, #prospectingRewards)
    local data = prospectingRewards[randomNum].data
    return data
end

-- Generate a new target location
function GenerateNewTarget(n)
    local newPos = GetNewRandomLocation()
    local newData = GetNewRandomItem()
    Prospecting.AddTarget(newPos.x, newPos.y, newPos.z, newData)
end

-- Make a random location within the area
function GetNewRandomLocation()
    local offsetX = math.random(-area_size, area_size)
    local offsetY = math.random(-area_size, area_size)
    local pos = vector3(offsetX, offsetY, 0.0)
    if #(pos) > area_size then
        return GetNewRandomLocation()
    end
    return base_location + pos
end

function StartProspecting(player)
    if not PROSPECTING_STATUS[player] then
        TriggerClientEvent("Jobs:Client:ForceStartProspect", player)
    end
end

function InsertProspectingTargets(resource, targets)
    for _, target in pairs(targets) do
        InsertProspectingTarget(resource, 0, 0, 0, target.data)
        Wait(5)
    end
    UpdateProspectingTargets(-1)
end

function UpdateProspectingTargets(src)
    local targets = {}
    for _, target in pairs(PROSPECTING_TARGETS) do
        local difficulty = PROSPECTING_DIFFICULTIES[target.resource] or 1.0
        targets[#targets + 1] = {target.x, target.y, target.z, difficulty}
    end
    TriggerClientEvent("Jobs:Client:SetProspectTargetPool", src, targets)
end

function RemoveProspectingTarget(index)
    local new_targets = {}
    for n, target in pairs(PROSPECTING_TARGETS) do
        if (n ~= index) then
            new_targets[#new_targets + 1] = target
        end
    end
    PROSPECTING_TARGETS = new_targets
    UpdateProspectingTargets(-1)
end

function FindMatchingPickup(x, y, z)
    for index, target in pairs(PROSPECTING_TARGETS) do
        local dx, dy, dz = target.x, target.y, target.z
        if (math.floor(dx) == math.floor(x) and math.floor(dy) == math.floor(y) and math.floor(dz) == math.floor(z)) then
            return index
        end
    end
    return nil
end

function HandleProspectingPickup(src, index, x, y, z)
    local target = PROSPECTING_TARGETS[index]
    if target then
        local dx, dy, dz = target.x, target.y, target.z
        local resource, data = target.resource, target.data
        if math.floor(dx) == math.floor(x) and math.floor(dy) == math.floor(y) and math.floor(dz) == math.floor(z) then
            RemoveProspectingTarget(index)
            -- Check if the item is valuable, which is a part of the data we pass when creating it!
            local quantity = 1
    
            -- PERCENTAGE CHANCE CHECK FOR VALUABLE ITEMS
            if (data.valuable ~= nil) then
                math.randomseed(GetGameTimer())
                local randomNum = math.random(1, 100)
    
                -- 65% CHANGE ITEM TO SCRAP METAL
                if (randomNum < 65) then
                    data = {desc = "scrap metal", itemName = "scrapmetal"}
                    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "You found " .. data.desc .. "!", length = 9500})
                else
                    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "You found " .. data.desc .. " worth a lot of money!", length = 9500})
                end
            else
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "You found " .. data.desc .. "!", length = 9500})
            end
    
            -- GIVE THE ITEM
            if (data.quantity ~= nil) then
                quantity = data.quantity
            end
    
            -- GET A NEW TARGET
            GenerateNewTarget()
    
            local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID    
            if exports["soe-inventory"]:AddItem(src, "char", charID, data.itemName, quantity, "{}") then
                exports["soe-logging"]:ServerLog("Prospecting Reward", ("HAS EARNED A REWARD FROM PROSPECTING | AMOUNT: %s | ITEM: %s"):format(quantity, data.itemName), src)
            end
        else
            local newMatch = FindMatchingPickup(x, y, z)
            if newMatch then
                HandleProspectingPickup(src, newMatch, x, y, z)
            end
        end
    end
end

-- ***********************
--         Events
-- ***********************
AddEventHandler("Jobs:Server:GetProspectTargets", function(cb, src)
    cb(true)
    UpdateProspectingTargets(src)
end)

AddEventHandler("Jobs:Server:ActivateProspecting", function(cb, src)
    cb(true)
    Prospecting.StartProspecting(src)
end)

AddEventHandler("Jobs:Server:CollectedProspectNode", function(cb, src, index, x, y, z)
    cb(true)
    if PROSPECTING_STATUS[src] then
        HandleProspectingPickup(src, index, x, y, z)
    end
end)

AddEventHandler("Jobs:Server:UserStartedProspecting", function(cb, src)
    cb(true)
    if not PROSPECTING_STATUS[src] then
        PROSPECTING_STATUS[src] = GetGameTimer()
        exports["soe-logging"]:ServerLog("Prospecting Status", "HAS STARTED PROSPECTING", src)
    end
end)

AddEventHandler("Jobs:Server:UserStoppedProspecting", function(cb, src)
    cb(true)
    if PROSPECTING_STATUS[src] then
        local time = GetGameTimer() - PROSPECTING_STATUS[src]
        PROSPECTING_STATUS[src] = nil
        exports["soe-logging"]:ServerLog("Prospecting Status", "HAS STOPPED PROSPECTING", src)
    end
end)

CreateThread(function()
    -- Default difficulty
    Prospecting.SetDifficulty(1.0)

    -- Add a list of targets
    -- Each target needs an x, y, z and data entry
    Prospecting.AddTargets(prospectingRewards)

    -- Generate 10 random extra targets
    for item = 1, numberOfBuriedItems do
        Wait(1)
        GenerateNewTarget(item)
    end
end)
