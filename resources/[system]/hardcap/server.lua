local playerCount = 0
local list = {}

RegisterNetEvent("hardcap:playerActivated")
AddEventHandler("hardcap:playerActivated", function()
    if not list[source] then
        playerCount = playerCount + 1
        list[source] = true
    end
end)

AddEventHandler("playerDropped", function()
    if list[source] then
        playerCount = playerCount - 1
        list[source] = nil
    end
end)

AddEventHandler("playerConnecting", function(name, setReason)
    local src = source
    local cv = GetConvarInt("sv_maxclients", 64)
    local server = GetConvar("serverTag", "Undefined")
    --print(("Connecting: %s | Identifiers: %s"):format(name, json.encode(GetPlayerIdentifiers(src))))
    exports["soe-logging"]:ServerLog("Player Connecting", {["Server ID"] = tostring(src), ["Server"] = server, ["FiveM Username"] = name, ["Identifiers"] = json.encode(GetPlayerIdentifiers(src))})

    if playerCount >= cv then
        print("Full. :(")
        setReason("This server is full (past " .. tostring(cv) .. " players).")
        CancelEvent()
    end
end)
