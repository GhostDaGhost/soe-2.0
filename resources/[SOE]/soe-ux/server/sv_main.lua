local spotlights = {}

-- **********************
--       Commands
-- **********************
-- WHEN TRIGGERED, KILL THE BAIT CAR THE PLAYER LAST SET
RegisterCommand("killswitch", function(source)
    local src = source
    TriggerClientEvent("UX:Client:ActivateKillSwitch", src, {status = true})
end)

-- WHEN TRIGGERED, ENABLE/DISABLE SPOTLIGHTS OF A CERTAIN DIRECTION
RegisterCommand("spotlight", function(source, args)
    local src = source
    if (args[1] == "left") then
        TriggerClientEvent("UX:Client:SpotlightOptions", src, "left")
    elseif (args[1] == "right") then
        TriggerClientEvent("UX:Client:SpotlightOptions", src, "right")
    elseif (args[1] == "front") then
        TriggerClientEvent("UX:Client:SpotlightOptions", src, "front")
    else
        TriggerClientEvent("UX:Client:SpotlightOptions", src, nil)
    end
end)

-- **********************
--        Events
-- **********************
-- CALLED FROM CLIENT TO SYNC VEHICLE DOOR OPENING/CLOSING
RegisterNetEvent("UX:Server:ToggleDoor")
AddEventHandler("UX:Server:ToggleDoor", function(veh, door)
    TriggerClientEvent("UX:Client:ToggleDoor", -1, veh, door)
end)

-- CALLED WHEN A SOURCE DROPS -- DELETES ANY SPOTLIGHT THEY HAVE
AddEventHandler("playerDropped", function()
    local src = source
    if spotlights[src] then
        spotlights[src] = nil
        TriggerClientEvent("UX:Client:Spotlights", -1, spotlights)
    end
end)

-- CALLED FROM CLIENT TO SYNC SPOTLIGHTS FROM EMERGENCY VEHICLES
RegisterNetEvent("UX:Server:Spotlights")
AddEventHandler("UX:Server:Spotlights", function(direction, veh)
    local src = source
    if (direction == nil) then
        spotlights[src] = nil
    else
        spotlights[src] = {Direction = direction, Player = src, Vehicle = veh}
    end
    TriggerClientEvent("UX:Client:Spotlights", -1, spotlights)
end)

-- SENT FROM CLIENT TO RELOAD GUN
RegisterNetEvent("UX:Server:UpdateGunAmmo")
AddEventHandler("UX:Server:UpdateGunAmmo", function(gun, ammoToUpdate)
    local src = source
    local getGuns = exports["soe-inventory"]:GetItemData(src, gun.hash, "left")

    -- ITERATE THROUGH GUNS FOUND
    local found = false
    for gunID, gunData in pairs(getGuns) do
        if (tonumber(gunID) == tonumber(gun.uid)) then
            found = gunData
            break
        end
    end

    if found then
        local itemMeta = json.decode(found.ItemMeta)
        itemMeta.ammo = ammoToUpdate
        exports["soe-inventory"]:ModifyItemMeta(gun.uid, json.encode(itemMeta))
    end
end)

RegisterNetEvent("UX:Server:ReloadMyGun")
AddEventHandler("UX:Server:ReloadMyGun", function(gun, ammoType, ammoToAdd, clearing)
    local src = source
    if clearing then
        local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
        exports["soe-inventory"]:AddItem(src, "char", charID, ammoType, 1, "{}")
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "Gun cleared", length = 3500})
    end

    -- ITERATE THROUGH GUNS FOUND
    local found
    local getGuns = exports["soe-inventory"]:GetItemData(src, gun.hash, "left")
    for gunID, gunData in pairs(getGuns) do
        if (tonumber(gunID) == tonumber(gun.uid)) then
            found = gunData
            break
        end
    end

    if found then
        local itemMeta = json.decode(found.ItemMeta)
        itemMeta.ammo = ammoToAdd
        if not clearing then
            exports["soe-inventory"]:RemoveItem(src, 1, ammoType)
        end
        exports["soe-inventory"]:ModifyItemMeta(gun.uid, json.encode(itemMeta))

        -- HAVE CLIENT HIDE WEAPON TO UPDATE IT
        TriggerClientEvent("UX:Client:ReloadMyGun", src, ammoToAdd, clearing)
        if not clearing then
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "Gun reloaded", length = 3500})
        end
    end
end)

-- WHEN TRIGGERED, UPDATE THE KILL SWITCHED VEHICLES
RegisterNetEvent("UX:Server:SyncVehicleKillswitch")
AddEventHandler("UX:Server:SyncVehicleKillswitch", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 88311-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 88311-2 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.plate then return end
    if (data.type == "Update") then
        exports["soe-inventory"]:RemoveItem(src, 1, "enginekiller")
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "Vehicle with plate " .. data.plate .. " has been fitted with a killswitch", length = 5000})
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "Do /killswitch to kill the vehicle whenever!", length = 5000})
    elseif (data.type == "Kill") then
        TriggerClientEvent("UX:Client:SyncVehicleKillswitch", -1, {status = true, veh = data.veh})
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "Vehicle with plate " .. data.plate .. " has been successfully killed", length = 5000})
    end
end)
