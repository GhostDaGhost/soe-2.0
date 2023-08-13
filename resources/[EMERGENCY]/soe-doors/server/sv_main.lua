-- ***********************
--         Events
-- ***********************
-- TRIGGERED WHEN SOURCE JOINS THE SERVER TO SYNC ALL DOORS
AddEventHandler("Doors:Server:InitiateResource", function(cb, src)
    cb(doors)
end)

-- SYNCS DOOR STATE AFTER A SOURCE LOCKS/UNLOCKS
RegisterNetEvent("Doors:Server:SyncStateChange")
AddEventHandler("Doors:Server:SyncStateChange", function(data)
    local src = source
    if not data then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 45245-1 | Lua-Injecting Detected.", 0)
        return
    end

    if not data.status then
        TriggerEvent("Fidelis:Server:HandleBan", src, "Fidelis", "[Autoban] Trigger ID: 45245-2 | Lua-Injecting Detected.", 0)
        return
    end

    doors[data.doorID].locked = data.state
    if not data.usingThermite then
        local msg
        if doors[data.doorID].locked then
            msg = "You lock the door"
        else
            msg = "You unlock the door"
        end

        if not data.isGate and not data.isBuzzer then
            local sound = "door_unlock.ogg"
            if (doors[data.doorID].hash == 430324891 or doors[data.doorID].hash == 871712474) then
                sound = "cell_unlock.ogg"
            end

            -- ONLY PLAY SOUND FOR ONE DOOR
            if not data.secondaryDoor then
                exports["soe-utils"]:PlayProximitySoundFromCoords(doors[data.doorID].pos, 4.5, sound, 0.5)
            end
        elseif data.isGate then
            if doors[data.doorID].locked then
                msg = "You lock the gate"
            else
                msg = "You unlock the gate"
            end
        end
        if data.isLinked then
            msg = msg .. "s"
        end

        -- ONLY SHOW MESSAGE FOR ONCE
        if not data.secondaryDoor then
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "inform", text = msg, length = 1500})
        end
    end
    TriggerClientEvent("Doors:Client:SyncStateChange", -1, {status = true, doorID = data.doorID, state = data.state})
end)
