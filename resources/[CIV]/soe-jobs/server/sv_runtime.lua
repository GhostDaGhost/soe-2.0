local goPostalDropCooldown = 600 -- 10 MINUTES

CreateThread(function()
    Wait(2500)
    local loopIndex = 0
    while true do
        Wait(5000)

        loopIndex = loopIndex + 1
        if (loopIndex % 2 == 0) then -- EVERY 10 SECONDS
            -- UPDATE LEO/EMS COUNTER
            local emsCount = GetDutyCount("EMS")
            local copCount = GetDutyCount("POLICE")
            TriggerClientEvent("Emergency:Client:UpdateCounter", -1, emsCount, copCount)
        end

        -- GOPOSTAL DROP TIMER
        local ostime = os.time()
        for _, data in pairs(goPostalDestinationStatus) do
            local timeElapsed = ostime - data.lastDrop
            -- IF LAST DROP OFF IS GREATER THAN 10 MINUTES AND DROP IS NOT AVAILABLE THEN ALLOW DROP FOR STOP AGAIN
            if timeElapsed >= goPostalDropCooldown and data.availability == false then
                data.lastDrop = 0
                data.availability = true
            end
        end

        if (loopIndex % 12 == 0)  then
            -- UPDATE LAST PICKED TIME EVERY 60 SECONDS
            for _, treeData in pairs(treePicking.PickableTrees) do
                if treeData.picked then
                    if (os.time() - treeData.lastPicked >= 300) then
                        treeData.picked = false
                        TriggerClientEvent("Jobs:Client:TreePicking:UpdateTreeList", -1, treePicking.PickableTrees)
                    end
                end
            end
        end

        if (loopIndex % 36 == 0) then
            -- UPDATE COOLDOWNS APPROX~ EVERY 180 SECONDS
            for _, spotData in pairs(jobRoles[1].tableName) do
                if spotData.stockTaked and os.time() >= spotData.nextAvailableTime then
                    spotData.stockTaked = false
                end
            end

            for _, spotData in pairs(jobRoles[3].tableName) do
                if spotData.packaged and os.time() >= spotData.nextAvailableTime then
                    spotData.packaged = false
                end
            end
        end

        if (loopIndex % 105 == 0) then -- 10-ISH MINS
            loopIndex = 0
            TriggerEvent("Jobs:Server:NewAITowCall")
        end
    end
end)
