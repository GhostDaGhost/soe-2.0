RegisterNetEvent("BaseEvents:Server:OnPlayerWasted")
RegisterNetEvent("BaseEvents:Server:EnteringVehicle")
RegisterNetEvent("BaseEvents:Server:EnteringAborted")
RegisterNetEvent("BaseEvents:Server:EnteredVehicle")
RegisterNetEvent("BaseEvents:Server:LeftVehicle")

RegisterNetEvent("BaseEvents:Server:OnPlayerMurder")
AddEventHandler("BaseEvents:Server:OnPlayerMurder", function(killedBy, data)
    local victim = source
    --RconLog({msgType = "playerKilled", victim = victim, attacker = killedBy, data = data})
end)

RegisterNetEvent("BaseEvents:Server:OnPlayerDied")
AddEventHandler("BaseEvents:Server:OnPlayerDied", function(killedBy, pos)
    local victim = source
    --RconLog({msgType = "playerDied", victim = victim, attackerType = killedBy, pos = pos})
end)
