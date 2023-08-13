RegisterNetEvent("Emergency:Server:DefaultSirenMute")
AddEventHandler("Emergency:Server:DefaultSirenMute", function(toggle)
    local src = source
    TriggerClientEvent("Emergency:Client:DefaultSirenMute", -1, src, toggle)
end)

RegisterNetEvent("Emergency:Server:SetSirenState")
AddEventHandler("Emergency:Server:SetSirenState", function(newstate)
    local src = source
    TriggerClientEvent("Emergency:Client:SetSirenState", -1, src, newstate)
end)

RegisterNetEvent("Emergency:Server:SetPwrcallState")
AddEventHandler("Emergency:Server:SetPwrcallState", function(toggle)
    local src = source
    TriggerClientEvent("Emergency:Client:SetPwrcallState", -1, src, toggle)
end)

RegisterNetEvent("Emergency:Server:SetAirManuState")
AddEventHandler("Emergency:Server:SetAirManuState", function(newstate)
    local src = source
    TriggerClientEvent("Emergency:Client:SetAirManuState", -1, src, newstate)
end)

-- WHEN TRIGGERED, SYNC SIREN STATES WITH EVERYONE
--[[RegisterNetEvent("Emergency:Server:SyncSirenStates")
AddEventHandler("Emergency:Server:SyncSirenStates", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 9291-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 9291-2 | Lua-Injecting Detected.", 0)
        return
    end

    TriggerClientEvent("Emergency:Server:SyncSirenStates", -1, {status = true, src = src, mute = data.mute,
        sirenState = data.sirenState, powercall = data.powercall, manuState = data.manuState
    })
end)]]
