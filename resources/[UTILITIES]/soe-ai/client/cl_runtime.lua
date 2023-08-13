-- MAIN RUNTIME
-- THIS IS NEEDED BECAUSE FIVEM CANNOT SUPPORT TOO MANY SCRIPTED PEDS SPAWNED IN THE MAP
CreateThread(function()
    Wait(3500)
    InitiateResource()
    while true do
        Wait(750)
        for _, npc in pairs(npcs) do
            local dist = #(GetEntityCoords(PlayerPedId()) - vector3(npc.pos.x, npc.pos.y, npc.pos.z))
            if (dist <= npc.dist) and not npc.spawned then
                SpawnNPC(npc)
            elseif (dist > npc.dist) and npc.spawned then
                DeleteNPC(npc)
            end
        end
    end
end)
