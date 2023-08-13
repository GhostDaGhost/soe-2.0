local eventPrefix = "__PolyZone__:"

function TriggerZoneEvent(eventName, ...)
    TriggerClientEvent(eventPrefix .. eventName, -1, ...)
end

RegisterCommand("pzadd", function(source)
    local src = source
    if not exports["soe-uchuu"]:IsStaff(src) then return end
    TriggerClientEvent("polyzone:pzadd", src)
end)

RegisterCommand("pzundo", function(source)
    local src = source
    if not exports["soe-uchuu"]:IsStaff(src) then return end
    TriggerClientEvent("polyzone:pzundo", src)
end)

RegisterCommand("pzfinish", function(source)
    local src = source
    if not exports["soe-uchuu"]:IsStaff(src) then return end
    TriggerClientEvent("polyzone:pzfinish", src)
end)

RegisterCommand("pzlast", function(source)
    local src = source
    if not exports["soe-uchuu"]:IsStaff(src) then return end
    TriggerClientEvent("polyzone:pzlast", src)
end)

RegisterCommand("pzcancel", function(source)
    local src = source
    if not exports["soe-uchuu"]:IsStaff(src) then return end
    TriggerClientEvent("polyzone:pzcancel", src)
end)

RegisterCommand("pzcomboinfo", function(source)
    local src = source
    if not exports["soe-uchuu"]:IsStaff(src) then return end
    TriggerClientEvent("polyzone:pzcomboinfo", src)
end)

RegisterNetEvent("PolyZone:TriggerZoneEvent")
AddEventHandler("PolyZone:TriggerZoneEvent", TriggerZoneEvent)

exports("TriggerZoneEvent", TriggerZoneEvent)
