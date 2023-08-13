-- ***********************
--        Commands
-- ***********************
RegisterCommand("hair", function(source)
    local src = source
    if not exports["soe-uchuu"]:IsStaff() then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Experimental command locked behind devs!", length = 5000})
        return
    end
    TriggerClientEvent("Appearance:Client:PieceToggles", src, "hair")
end)

RegisterCommand("bra", function(source)
    local src = source
    TriggerClientEvent("Appearance:Client:PieceToggles", src, "bra")
end)

RegisterCommand("undershirt", function(source)
    local src = source
    TriggerClientEvent("Appearance:Client:PieceToggles", src, "undershirt")
end)

RegisterCommand("bag", function(source)
    local src = source
    TriggerClientEvent("Appearance:Client:PieceToggles", src, "bag")
end)

RegisterCommand("shoes", function(source)
    local src = source
    TriggerClientEvent("Appearance:Client:PieceToggles", src, "shoes")
end)

RegisterCommand("vest", function(source)
    local src = source
    TriggerClientEvent("Appearance:Client:PieceToggles", src, "vest")
end)

RegisterCommand("hat", function(source)
    local src = source
    TriggerClientEvent("Appearance:Client:PieceToggles", src, "hat")
end)

RegisterCommand("glasses", function(source)
    local src = source
    TriggerClientEvent("Appearance:Client:PieceToggles", src, "glasses")
end)

RegisterCommand("ear", function(source)
    local src = source
    TriggerClientEvent("Appearance:Client:PieceToggles", src, "ear")
end)

RegisterCommand("neck", function(source)
    local src = source
    TriggerClientEvent("Appearance:Client:PieceToggles", src, "neck")
end)

RegisterCommand("watch", function(source)
    local src = source
    TriggerClientEvent("Appearance:Client:PieceToggles", src, "watch")
end)

RegisterCommand("bracelet", function(source)
    local src = source
    TriggerClientEvent("Appearance:Client:PieceToggles", src, "bracelet")
end)

RegisterCommand("mask", function(source)
    local src = source
    TriggerClientEvent("Appearance:Client:PieceToggles", src, "mask")
end)

RegisterCommand("pants", function(source)
    local src = source
    TriggerClientEvent("Appearance:Client:PieceToggles", src, "pants")
end)

RegisterCommand("shirt", function(source)
    local src = source
    TriggerClientEvent("Appearance:Client:PieceToggles", src, "shirt")
end)

RegisterCommand("decals", function(source)
    local src = source
    TriggerClientEvent("Appearance:Client:PieceToggles", src, "decals")
end)

RegisterCommand("accessories", function(source)
    local src = source
    TriggerClientEvent("Appearance:Client:PieceToggles", src, "accessories")
end)
