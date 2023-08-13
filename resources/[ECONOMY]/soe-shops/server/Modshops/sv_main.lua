-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, CALLBACK TO CLIENT THE VEHICLE'S CUSTOMIZATIONS
AddEventHandler("Shops:Server:GetVehicleModData", function(cb, src, vin)
    local getVehicleMods = exports["soe-nexus"]:PerformAPIRequest("/api/valet/getmods", ("vin=%s"):format(vin), true)
    if getVehicleMods.status then
        cb({status = true, data = getVehicleMods.data})
    else
        cb({status = false})
    end
end)

-- WHEN TRIGGERED, SAVE THE SENT VEHICLE CUSTOMIZATIONS TO THE VEHICLE
RegisterNetEvent("Shops:Server:UpdateVehicleMods")
AddEventHandler("Shops:Server:UpdateVehicleMods", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 99191-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 99191-2 | Lua-Injecting Detected.", 0)
        return
    end

    if (data.vin ~= 0) then
        exports["soe-nexus"]:PerformAPIRequest("/api/valet/updatemods", ("vin=%s&mods=%s"):format(data.vin, data.mods), true)
    else
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "An error occurred with saving the modifications", time = 5000})
    end
end)
