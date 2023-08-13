-- **********************
--       Commands
-- **********************
RegisterCommand("traffic", function(source, args)
    --[[print("-----")
    print("CURRENT")
    print("trafficMult", trafficMult)
    print("defaultTrafficMult", defaultTrafficMult)
    print("trafficOverride", trafficOverride)]]
    -- ONLY ALLOW DEVS TO CHANGE TRAFFIC MULTIPLIER
    local src = source
    local staffRank = GetStaffRank(src)
    --print("staffRank", staffRank)
    if not (staffRank == "developer") then return end

    -- SETS TRAFFIC MULTIPLIER TO SPECIFIED
    if args[1] == "default" or args[1] == "" then
        trafficMult = defaultTrafficMult
        trafficOverride = false
    elseif tonumber(args[1]) then
        newTrafficMult = tonumber(args[1])
        if newTrafficMult > 1.0 then
            trafficMult = 1.0
        else
            trafficMult = newTrafficMult
        end
        trafficOverride = true
    end

    --[[print("-----")
    print("NEW")
    print("trafficMult", trafficMult)
    print("defaultTrafficMult", defaultTrafficMult)
    print("trafficOverride", trafficOverride)]]
    -- FORCE UPDATE TRAFFIC MULTIPLIER VARIABLES FOR ALL CLIENTS
    TriggerClientEvent("Uchuu:Client:SetTrafficMult", -1, newTrafficMult, trafficOverride)
end)

-- **********************
--        Events
-- **********************
-- TRIGGERED BY CLIENT AND RETURNS TRAFFIC DATA
RegisterNetEvent("Uchuu:Server:GetTrafficMult")
AddEventHandler("Uchuu:Server:GetTrafficMult", function()
    print("GET SERVER TRAFFIC DATA FOR CLIENT")
    local src = source
    TriggerClientEvent("Uchuu:Client:SetTrafficMult", src, trafficMult, trafficOverride)
end)
