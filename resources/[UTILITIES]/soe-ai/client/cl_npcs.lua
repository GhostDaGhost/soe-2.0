npcs = {}

-- SETS NPC SETTINGS
local function SetNPCSettings(entity, settings)
    for _, mode in ipairs(settings) do
        if (mode.setting == "invincible") then
            SetEntityInvincible(entity, mode.state)
        elseif (mode.setting == "freeze") then
            FreezeEntityPosition(entity, mode.state)
        elseif (mode.setting == "ignore") then
            SetBlockingOfNonTemporaryEvents(entity, mode.state)
        elseif (mode.setting == "ragdoll") then
            SetPedCanRagdollFromPlayerImpact(entity, mode.state)
        elseif (mode.setting == "noDrugs") then
            DecorSetBool(entity, "noSellingDrugs", mode.state)
        elseif (mode.setting == "noMugging") then
            DecorSetBool(entity, "noMugging", mode.state)
        elseif (mode.setting == "isBankTeller") then
            DecorSetBool(entity, "isBankTeller", mode.state)
        end
    end
end

-- SPAWNS NPCs AT SOME BASIC LOCATIONS
function InitiateResource()
    for _, npc in pairs(locations) do
        RegisterNPC(npc)
    end
end

-- DELETES A SPECIFIC NPC
function DeleteNPC(npc)
    if not npc.spawned then return end

    npc.spawned = false
    if DoesEntityExist(npc.entity) then
        DeleteEntity(npc.entity)
    end
end

-- REGISTERS NPC TO THE TABLE
function RegisterNPC(data)
    local ped = {}
    ped.id = data.uid
    ped.type = data.type
    ped.model = GetHashKey(data.model)
    ped.pos = data.pos
    ped.networked = data.networked
    ped.scenario = data.scenario
    ped.settings = data.settings
    ped.dist = data.dist

    ped.entity = nil
    ped.spawned = false
    table.insert(npcs, ped)
end

-- SPAWNS A SPECIFIC NPC
function SpawnNPC(npc)
    if npc.spawned then return end

    exports["soe-utils"]:LoadModel(npc.model, 15)
    local ped = CreatePed(npc.type, npc.model, npc.pos.x, npc.pos.y, npc.pos.z, npc.pos.w, false, true)
    --SetPedRandomComponentVariation(ped, true)

    if DoesEntityExist(ped) then
        npc.entity, npc.spawned = ped, true
        if npc.scenario then
            TaskStartScenarioInPlace(npc.entity, npc.scenario, 0, 1)
        end

        if npc.settings then
            SetNPCSettings(npc.entity, npc.settings)
        end
    end
    --SetModelAsNoLongerNeeded(npc.model)
end

-- WHEN RESOURCE IS STOPPED/RESTARTED, DELETE ALL NPCs
AddEventHandler("onResourceStop", function(resource)
    if (GetCurrentResourceName() ~= resource) then return end

    -- DELETE ALL NPCs
    for _, npc in pairs(npcs) do
        if DoesEntityExist(npc.entity) then
            DeleteEntity(npc.entity)
        end
    end
end)
