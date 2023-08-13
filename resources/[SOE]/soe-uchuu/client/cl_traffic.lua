-- **********************
--    Global Functions
-- **********************
function Traffic()
    local players = #GetActivePlayers()

    --[[print("-----")
	print("#players", players)
	print("trafficMult", trafficMult)
	print("defaultTrafficMult", defaultTrafficMult)
	print("trafficOverride", trafficOverride)]]
    -- LOWERS LOCAL TRAFFIC DEPENDING ON ACTIVE PLAYERS
    if trafficOverride == false then
        if players >= 32 then
            trafficMult = 0.6
        elseif players >= 64 then
            trafficMult = 0.5
        end
    end

    -- SET TRAFFIC
    SetVehicleDensityMultiplierThisFrame(trafficMult)
    SetRandomVehicleDensityMultiplierThisFrame(trafficMult)
    SetPedDensityMultiplierThisFrame(0.8)

    SetParkedVehicleDensityMultiplierThisFrame(0.8)
    SetScenarioPedDensityMultiplierThisFrame(trafficMult, trafficMult)
end

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, UPDATE TRAFFIC MULTIPLIERS FROM SERVER
RegisterNetEvent("Uchuu:Client:SetTrafficMult")
AddEventHandler("Uchuu:Client:SetTrafficMult", function(newTrafficMult, newTrafficOverride)
    --[[print("SET")
    print("newTrafficMult", newTrafficMult)
    print("newTrafficOverride", newTrafficOverride)]]
    trafficMult, trafficOverride = newTrafficMult, newTrafficOverride
end)
