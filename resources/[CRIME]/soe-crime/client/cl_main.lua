-- COLLECTS NPC HOMIDICES TO PREVENT DUPLICATE ALERTS
homicideReports = {}
menuV = assert(MenuV)

-- WHEN TRIGGERED, LOAD ANIMATION DICTIONARIES UPON INITIATION
function LoadAnimationDictionaries()
    -- PARKING METER
    exports["soe-utils"]:LoadAnimDict("anim@am_hold_up@male", 15)
    exports["soe-utils"]:LoadAnimDict("melee@small_wpn@streamed_core", 15)

    -- PACIFIC STANDARD BANK
    exports["soe-utils"]:LoadAnimDict("anim@heists@ornate_bank@hack", 15)
    exports["soe-utils"]:LoadAnimDict("anim@heists@ornate_bank@grab_cash", 15)
    exports["soe-utils"]:LoadAnimDict("anim@heists@fleeca_bank@scope_out@cashier_loop", 15)
    exports["soe-utils"]:LoadAnimDict("anim@heists@ornate_bank@thermal_charge", 15)
end

-- ITERATE THROUGH PEDS TO LOOK FOR DEAD ONES THAT HAVEN'T BEEN REPORTED YET
function HomicideCheck()
    local myJob = exports["soe-jobs"]:GetMyJob()
    if (myJob == "POLICE") then return end

    -- IF A WITNESS SAW THE HOMICIDE, MAKE A REPORT
    if exports["soe-emergency"]:ShouldReportInThisArea() then
        local pedList = exports["soe-utils"]:IteratePeds()
        for _, ped in pairs(pedList) do
            if IsPedHuman(ped) and not IsPedAPlayer(ped) then
                if IsEntityDead(ped) and homicideReports[ped] == nil then
                    local murderer = PlayerPedId()
                    if (GetPedSourceOfDeath(ped) == murderer) then
                        local pos = GetEntityCoords(murderer)
                        local loc = exports["soe-utils"]:GetLocation(pos)
                        --TriggerServerEvent("Emergency:Server:CADAlerts", "Homicide", location, '', pos)
                        TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = true, type = "Homicide", loc = loc, coords = pos})
                    end
                    homicideReports[ped] = true
                end
            end
        end
    end
end

RegisterNetEvent("Crime:Client:KillMasterAlarm", function(alarmName)
    StopAlarm(alarmName, -1)
end)

RegisterNetEvent("Crime:Client:SendRobberyAlert", function(location, pos, name)
    -- ALARM SOUNDS (ONLY SOME PLACES HAVE THIS)
    if (name == "Vangelico Jewelry Store") then
        while not PrepareAlarm("JEWEL_STORE_HEIST_ALARMS") do
            Wait(15)
        end
        StartAlarm("JEWEL_STORE_HEIST_ALARMS", 1)
    elseif (name == "Paleto Bay Bank") then
        while not PrepareAlarm("PALETO_BAY_SCORE_ALARM") do
            Wait(15)
        end
        StartAlarm("PALETO_BAY_SCORE_ALARM", 1)
    end

    -- GET JOB DATA AND DUTY STATUS
    local isOnDuty = exports["soe-jobs"]:IsOnDuty()
    if isOnDuty then
        local myJob = exports["soe-jobs"]:GetMyJob()
        if (myJob == "POLICE" or myJob == "EMS" or myJob == "DISPATCH") then
            exports["soe-utils"]:PlayProximitySound(3.0, "1090-Alert.ogg", 0.28)
        end

        local desc = ("Security is reporting a commercial hold-up alarm at %s on %s."):format(name, location)
        if (myJob == "EMS") then
            desc = ("Security is reporting a commercial hold-up alarm at %s on %s. SAFR is requested to stage in the area due to the potential for a medical emergency."):format(name, location)
            TriggerServerEvent("Emergency:Server:EMSAlerts", {status = true, global = false, type = "Robbery", desc = desc, loc = loc, coords = pos})
        elseif (myJob == "POLICE" or myJob == "DISPATCH") then
            TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = false, type = "Commercial Alarm", desc = desc, code = "10-90", coords = pos})
        end
    end
end)
