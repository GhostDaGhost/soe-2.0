RegisterNetEvent("Nexus:Server:SendMDTData")
AddEventHandler("Nexus:Server:SendMDTData", function(playerData, loc, veh)
    local sendData = {}
    local src = source
    local playerPos = GetEntityCoords(GetPlayerPed(src))

    sendData = {
        ["name"] = {
            ["first"] = playerData.FirstGiven,
            ["last"] = playerData.LastGiven
        },
        ["job"] = {
            ["type"] = playerData.CivType,
            ["department"] = playerData.Employer,
            ["rank"] = playerData.JobTitle,
            ["callsign"] = exports["soe-emergency"]:GetCallsign(playerData.CharID),
            ["onduty"] = exports["soe-jobs"]:IsOnDuty(src),
            ["currentjob"] = exports["soe-jobs"]:GetJob(src)
        },
        ["pos"] = {
            ["coords"] = {x = playerPos.x, y = playerPos.y, z = playerPos.z},
            ["location"] = loc
        }
    }

    if veh ~= nil then
        sendData["vehicle"] = veh
    end

    local dataString = string.format("charid=%s&data=%s", playerData.CharID, json.encode(sendData))
    if not exports["soe-uchuu"]:IsDevServer() then
        local updateMDT = exports["soe-nexus"]:PerformAPIRequest("/api/cad/update", dataString, true)
    end

    return
end)

RegisterNetEvent("Nexus:Server:DeleteOldMDTData")
AddEventHandler("Nexus:Server:DeleteOldMDTData", function()
    if not exports["soe-uchuu"]:IsDevServer() then
        local deleteOldMDT = exports["soe-nexus"]:PerformAPIRequest("/api/cad/removeold", "", true)
    end

    return
end)