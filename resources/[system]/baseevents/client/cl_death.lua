local diedAt
local isDead, hasBeenDead = false, false

CreateThread(function()
    Wait(3500)
    while true do
        Wait(5)

        local ped, player = PlayerPedId(), PlayerId()
        if IsPedFatallyInjured(ped) and not isDead then
            isDead = true
            if not diedAt then
                diedAt = GetGameTimer()
            end

            local killer, killerweapon = NetworkGetEntityKillerOfPlayer(player)
            local killerentitytype = GetEntityType(killer)
            local killerinvehicle, killervehiclename, killervehicleseat = false, "", 0

            if (killerentitytype == 1) then
                if IsPedInAnyVehicle(killer, false) then
                    killerinvehicle = true
                    killervehiclename = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(killer))))
                    killervehicleseat = GetPedVehicleSeat(killer)
                else
                    killerinvehicle = false
                end
            end

            local killerid = NetworkGetPlayerIndexFromPed(killer)
            if killer ~= ped and killerid ~= nil and NetworkIsPlayerActive(killerid) then
                killerid = GetPlayerServerId(killerid)
            else
                killerid = -1
            end

            if killer == ped or killer == -1 then
                TriggerEvent("BaseEvents:Client:OnPlayerDied", GetEntityCoords(ped))
                TriggerServerEvent("BaseEvents:Server:OnPlayerDied", {status = true})
                hasBeenDead = true
            else
                TriggerEvent("BaseEvents:Client:OnPlayerMurder", {
                    status = true,
                    killerID = killerid,
                    murderWeapon = killerweapon,
                    killerInVeh = killerinvehicle,
                    killerVehSeat = killervehicleseat,
                    killerVehModel = killervehiclename
                })

                TriggerServerEvent("BaseEvents:Server:OnPlayerMurder", {
                    status = true,
                    killerID = killerid,
                    murderWeapon = killerweapon,
                    killerInVeh = killerinvehicle,
                    killerVehSeat = killervehicleseat,
                    killerVehModel = killervehiclename
                })
                hasBeenDead = true
            end
        elseif not IsPedFatallyInjured(ped) then
            isDead, diedAt = false, nil
        end

        -- CHECK IF THE PLAYER HAS TO RESPAWN IN ORDER TO TRIGGER AN EVENT
        if not hasBeenDead and diedAt ~= nil and diedAt > 0 then
            TriggerEvent("BaseEvents:Client:OnPlayerWasted", GetEntityCoords(ped))
            TriggerServerEvent("BaseEvents:Server:OnPlayerWasted", {status = true})
            hasBeenDead = true
        elseif hasBeenDead and diedAt ~= nil and diedAt <= 0 then
            hasBeenDead = false
        end
    end
end)
