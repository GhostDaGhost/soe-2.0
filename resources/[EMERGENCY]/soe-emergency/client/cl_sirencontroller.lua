local myVeh
local inVeh = false
local dsrn_mute = true
local srntone_temp = 0
local count_bcast_timer = 0
local delay_bcast_timer = 200
local count_sndclean_timer = 0
local delay_sndclean_timer = 400
local actv_lxsrnmute_temp = false

local snd_lxsiren = {}
local snd_pwrcall = {}
local snd_airmanu = {}
local actv_manu = false
local actv_horn = false
local state_lxsiren = {}
local state_pwrcall = {}
local state_airmanu = {}

-- MODELS LISTED HERE WILL USE THE FIRE TRUCK SIREN/AIRHORN
local modelsWithFireSrn = {"firetruk"}

-- MODELS LISTED HERE WILL USE AMBULANCE SIRENS
local ambulanceSirenModels = {"ambulance", "saframbo1", "saframbo2", "saframbo3"}

-- MODELS LISTED HERE WILL HAVE A FIRE POWERCALL
local modelsWithPowercall = {"ambulance", "saframbo1", "saframbo2", "saframbo3", "firetruk", "lguard"}

-- KEY MAPPINGS
RegisterKeyMapping("+airhorn", "Vehicle Airhorn", "keyboard", "LSHIFT")
RegisterKeyMapping("+chirp", "Vehicle Siren Chirp", "keyboard", "LCONTROL")
RegisterKeyMapping("+airhorn2", "Vehicle Airhorn (ALT)", "keyboard", "NUMPAD8")
RegisterKeyMapping("+chirp2", "Vehicle Siren Chirp (ALT)", "keyboard", "NUMPAD5")

RegisterKeyMapping("sirentoggle", "Siren Toggle", "keyboard", "G")
RegisterKeyMapping("sirenswitch", "Siren Tone Switch", "keyboard", "Y")
RegisterKeyMapping("powercall", "Siren Powercall", "keyboard", "INSERT")
RegisterKeyMapping("emergencylighttoggle", "Emergency Light Toggle", "keyboard", "E")

-- ***********************
--     Local Functions
-- ***********************
-- TOGGLES DEFAULT SIREN MUTING FUNCTION
local function TogMuteDfltSrnForVeh(veh, toggle)
    if DoesEntityExist(veh) and not IsEntityDead(veh) then
        SetVehicleHasMutedSirens(veh, toggle)
    end
end

local function UseFiretruckSiren(veh)
    local model = GetEntityModel(veh)
    for i = 1, #modelsWithFireSrn, 1 do
        if model == GetHashKey(modelsWithFireSrn[i]) then
            return true
        end
    end
    return false
end

local function UseAmbulanceSirens(veh)
    local model = GetEntityModel(veh)
    for i = 1, #ambulanceSirenModels, 1 do
        if model == GetHashKey(ambulanceSirenModels[i]) then
            return true
        end
    end
    return false
end

local function UsePowercallAuxSrn(veh)
    local model = GetEntityModel(veh)
    for i = 1, #modelsWithPowercall, 1 do
        if model == GetHashKey(modelsWithPowercall[i]) then
            return true
        end
    end
    return false
end

local function DoAirhorn(toggle)
    if IsPauseMenuActive() then return end
    if (GetPedInVehicleSeat(myVeh, -1) ~= PlayerPedId()) then
        return
    end

    if (GetVehicleClass(myVeh) == 18) then
        actv_horn = toggle
    end
end

local function CleanupSounds()
    if count_sndclean_timer > delay_sndclean_timer then
        count_sndclean_timer = 0
        for k, v in pairs(state_lxsiren) do
            if v > 0 then
                if not DoesEntityExist(k) or IsEntityDead(k) then
                    if snd_lxsiren[k] ~= nil then
                        StopSound(snd_lxsiren[k])
                        ReleaseSoundId(snd_lxsiren[k])
                        snd_lxsiren[k] = nil
                        state_lxsiren[k] = nil
                    end
                end
            end
        end

        for k, v in pairs(state_pwrcall) do
            if v == true then
                if not DoesEntityExist(k) or IsEntityDead(k) then
                    if snd_pwrcall[k] ~= nil then
                        StopSound(snd_pwrcall[k])
                        ReleaseSoundId(snd_pwrcall[k])
                        snd_pwrcall[k] = nil
                        state_pwrcall[k] = nil
                    end
                end
            end
        end

        for k, v in pairs(state_airmanu) do
            if v == true then
                if not DoesEntityExist(k) or IsEntityDead(k) or IsVehicleSeatFree(k, -1) then
                    if snd_airmanu[k] ~= nil then
                        StopSound(snd_airmanu[k])
                        ReleaseSoundId(snd_airmanu[k])
                        snd_airmanu[k] = nil
                        state_airmanu[k] = nil
                    end
                end
            end
        end
    else
        count_sndclean_timer = count_sndclean_timer + 1
    end
end

local function SetLxSirenStateForVeh(veh, newstate)
    if DoesEntityExist(veh) and not IsEntityDead(veh) then
        if newstate ~= state_lxsiren[veh] then
            if snd_lxsiren[veh] ~= nil then
                StopSound(snd_lxsiren[veh])
                ReleaseSoundId(snd_lxsiren[veh])
                snd_lxsiren[veh] = nil
            end

            if newstate == 1 then
                if UseFiretruckSiren(veh) or UseAmbulanceSirens(veh) then
                    TogMuteDfltSrnForVeh(veh, false)
                else
                    snd_lxsiren[veh] = GetSoundId()
                    PlaySoundFromEntity(snd_lxsiren[veh], "VEHICLES_HORNS_SIREN_1", veh, 0, 0, 0)
                    TogMuteDfltSrnForVeh(veh, true)
                end
            elseif newstate == 2 then
                snd_lxsiren[veh] = GetSoundId()
                PlaySoundFromEntity(snd_lxsiren[veh], "VEHICLES_HORNS_SIREN_2", veh, 0, 0, 0)
                TogMuteDfltSrnForVeh(veh, true)
            elseif newstate == 3 then
                snd_lxsiren[veh] = GetSoundId()
                if UseFiretruckSiren(veh) or UseAmbulanceSirens(veh) then
                    PlaySoundFromEntity(snd_lxsiren[veh], "VEHICLES_HORNS_AMBULANCE_WARNING", veh, 0, 0, 0)
                else
                    PlaySoundFromEntity(snd_lxsiren[veh], "VEHICLES_HORNS_POLICE_WARNING", veh, 0, 0, 0)
                end
                TogMuteDfltSrnForVeh(veh, true)
            else
                TogMuteDfltSrnForVeh(veh, true)
            end

            state_lxsiren[veh] = newstate
        end
    end
end

local function TogPowercallStateForVeh(veh, toggle)
    if DoesEntityExist(veh) and not IsEntityDead(veh) then
        if toggle == true then
            if snd_pwrcall[veh] == nil then
                snd_pwrcall[veh] = GetSoundId()
                if UsePowercallAuxSrn(veh) then
                    PlaySoundFromEntity(snd_pwrcall[veh], "VEHICLES_HORNS_AMBULANCE_WARNING", veh, 0, 0, 0)
                else
                    PlaySoundFromEntity(snd_pwrcall[veh], "VEHICLES_HORNS_SIREN_1", veh, 0, 0, 0)
                end
            end
        else
            if snd_pwrcall[veh] ~= nil then
                StopSound(snd_pwrcall[veh])
                ReleaseSoundId(snd_pwrcall[veh])
                snd_pwrcall[veh] = nil
            end
        end
        state_pwrcall[veh] = toggle
    end
end

local function SetAirManuStateForVeh(veh, newstate)
    if DoesEntityExist(veh) and not IsEntityDead(veh) then
        if newstate ~= state_airmanu[veh] then
            if snd_airmanu[veh] ~= nil then
                StopSound(snd_airmanu[veh])
                ReleaseSoundId(snd_airmanu[veh])
                snd_airmanu[veh] = nil
            end

            if newstate == 1 then
                snd_airmanu[veh] = GetSoundId()
                if UseFiretruckSiren(veh) then
                    PlaySoundFromEntity(snd_airmanu[veh], "VEHICLES_HORNS_FIRETRUCK_WARNING", veh, 0, 0, 0)
                else
                    PlaySoundFromEntity(snd_airmanu[veh], "SIRENS_AIRHORN", veh, 0, 0, 0)
                end
            elseif newstate == 2 then
                snd_airmanu[veh] = GetSoundId()
                PlaySoundFromEntity(snd_airmanu[veh], "VEHICLES_HORNS_SIREN_1", veh, 0, 0, 0)
            elseif newstate == 3 then
                snd_airmanu[veh] = GetSoundId()
                PlaySoundFromEntity(snd_airmanu[veh], "VEHICLES_HORNS_SIREN_2", veh, 0, 0, 0)
            end

            state_airmanu[veh] = newstate
        end
    end
end

local function DoSirenChirp(toggle)
    if IsPauseMenuActive() then return end
    if (GetPedInVehicleSeat(myVeh, -1) ~= PlayerPedId()) then
        return
    end

    if (GetVehicleClass(myVeh) == 18) then
        actv_manu = toggle
        if not toggle then
            SetLxSirenStateForVeh(myVeh, 0)
        end
    end
end

-- ***********************
--        Commands
-- ***********************
RegisterCommand("+airhorn", function()
    DoAirhorn(true)
end)

RegisterCommand("-airhorn", function()
    DoAirhorn(false)
end)

RegisterCommand("+airhorn2", function()
    DoAirhorn(true)
end)

RegisterCommand("-airhorn2", function()
    DoAirhorn(false)
end)

RegisterCommand("+chirp", function()
    DoSirenChirp(true)
end)

RegisterCommand("-chirp", function()
    DoSirenChirp(false)
end)

RegisterCommand("+chirp2", function()
    DoSirenChirp(true)
end)

RegisterCommand("-chirp2", function()
    DoSirenChirp(false)
end)

RegisterCommand("emergencylighttoggle", function()
    if IsPauseMenuActive() then return end
    if (GetPedInVehicleSeat(myVeh, -1) ~= PlayerPedId()) then
        return
    end

    if (GetVehicleClass(myVeh) == 18) then
        local volume = exports["soe-utils"]:GetSoundLevel()
        if IsVehicleSirenOn(myVeh) then
            SetVehicleSiren(myVeh, false)
            exports["soe-utils"]:PlaySound("sirens_off.ogg", volume, true)
        else
            SetVehicleSiren(myVeh, true)
            count_bcast_timer = delay_bcast_timer
            exports["soe-utils"]:PlaySound("sirens_on.ogg", volume, true)
        end
    end
end)

RegisterCommand("powercall", function()
    if IsPauseMenuActive() then return end
    if (GetPedInVehicleSeat(myVeh, -1) ~= PlayerPedId()) then
        return
    end

    if (GetVehicleClass(myVeh) == 18) then
        local volume = exports["soe-utils"]:GetSoundLevel()
        if state_pwrcall[myVeh] then
            exports["soe-utils"]:PlaySound("sirens_downgrade.ogg", volume, true)
            TogPowercallStateForVeh(myVeh, false)
            count_bcast_timer = delay_bcast_timer
        else
            if IsVehicleSirenOn(myVeh) then
                exports["soe-utils"]:PlaySound("sirens_upgrade.ogg", volume, true)
                TogPowercallStateForVeh(myVeh, true)
                count_bcast_timer = delay_bcast_timer
            end
        end
    end
end)

RegisterCommand("sirentoggle", function()
    if IsPauseMenuActive() then return end
    if (GetPedInVehicleSeat(myVeh, -1) ~= PlayerPedId()) then
        return
    end

    if (GetVehicleClass(myVeh) == 18) then
        local volume = exports["soe-utils"]:GetSoundLevel()
        local cstate = state_lxsiren[myVeh]
        if (cstate == 0) then
            if IsVehicleSirenOn(myVeh) then
                exports["soe-utils"]:PlaySound("sirens_upgrade.ogg", volume, true)
                SetLxSirenStateForVeh(myVeh, 1)
                count_bcast_timer = delay_bcast_timer
            end
        else
            exports["soe-utils"]:PlaySound("sirens_downgrade.ogg", volume, true)
            SetLxSirenStateForVeh(myVeh, 0)
            count_bcast_timer = delay_bcast_timer
        end
    end
end)

RegisterCommand("sirenswitch", function()
    if IsPauseMenuActive() then return end
    if (GetPedInVehicleSeat(myVeh, -1) ~= PlayerPedId()) then
        return
    end

    if (GetVehicleClass(myVeh) == 18) then
        if IsVehicleSirenOn(myVeh) then
            local volume = exports["soe-utils"]:GetSoundLevel()
            exports["soe-utils"]:PlaySound("sirens_upgrade.ogg", volume, true)
            local cstate = state_lxsiren[myVeh]
            local nstate = 1
            if (cstate == 1) then
                nstate = 2
            elseif (cstate == 2) then
                nstate = 3
            else
                nstate = 1
            end
            SetLxSirenStateForVeh(myVeh, nstate)
            count_bcast_timer = delay_bcast_timer
        end
    end
end)

-- ***********************
--         Events
-- ***********************
-- WHEN TRIGGERED, END SIREN SYNC LOOP
AddEventHandler("BaseEvents:Client:LeftVehicle", function()
    myVeh = nil
    inVeh = false
end)

RegisterNetEvent("Emergency:Client:DefaultSirenMute")
AddEventHandler("Emergency:Client:DefaultSirenMute", function(src, toggle)
    local ped = GetPlayerPed(GetPlayerFromServerId(src))
    if DoesEntityExist(ped) and not IsEntityDead(ped) then
        if ped ~= PlayerPedId() then
            if IsPedInAnyVehicle(ped, false) then
                local veh = GetVehiclePedIsUsing(ped)
                TogMuteDfltSrnForVeh(veh, toggle)
            end
        end
    end
end)

RegisterNetEvent("Emergency:Client:SetSirenState")
AddEventHandler("Emergency:Client:SetSirenState", function(src, newstate)
    local ped = GetPlayerPed(GetPlayerFromServerId(src))
    if DoesEntityExist(ped) and not IsEntityDead(ped) then
        if ped ~= PlayerPedId() then
            if IsPedInAnyVehicle(ped, false) then
                local veh = GetVehiclePedIsUsing(ped)
                SetLxSirenStateForVeh(veh, newstate)
            end
        end
    end
end)

RegisterNetEvent("Emergency:Client:SetPwrcallState")
AddEventHandler("Emergency:Client:SetPwrcallState", function(src, toggle)
    local ped = GetPlayerPed(GetPlayerFromServerId(src))
    if DoesEntityExist(ped) and not IsEntityDead(ped) then
        if ped ~= PlayerPedId() then
            if IsPedInAnyVehicle(ped, false) then
                local veh = GetVehiclePedIsUsing(ped)
                TogPowercallStateForVeh(veh, toggle)
            end
        end
    end
end)

RegisterNetEvent("Emergency:Client:SetAirManuState")
AddEventHandler("Emergency:Client:SetAirManuState", function(src, newstate)
    local ped = GetPlayerPed(GetPlayerFromServerId(src))
    if DoesEntityExist(ped) and not IsEntityDead(ped) then
        if ped ~= PlayerPedId() then
            if IsPedInAnyVehicle(ped, false) then
                local veh = GetVehiclePedIsUsing(ped)
                SetAirManuStateForVeh(veh, newstate)
            end
        end
    end
end)

-- WHEN TRIGGERED, SYNC ALL SIREN STATES
--[[RegisterNetEvent("Emergency:Client:SyncSirenStates")
AddEventHandler("Emergency:Client:SyncSirenStates", function(data)
    if not data.status then return end

    local ped = GetPlayerPed(GetPlayerFromServerId(data.src))
    if DoesEntityExist(ped) and not IsEntityDead(ped) then
        if (ped ~= PlayerPedId()) then
            if not IsPedInAnyVehicle(ped, false) then
                return
            end

            local veh = GetVehiclePedIsUsing(ped)
            TogMuteDfltSrnForVeh(veh, data.mute)
            SetLxSirenStateForVeh(veh, data.sirenState)
            TogPowercallStateForVeh(veh, data.powercall)
            SetAirManuStateForVeh(veh, data.manuState)
        end
    end
end)]]

-- WHEN TRIGGERED, START A LOOP TO SYNC SIREN STATES
AddEventHandler("BaseEvents:Client:EnteredVehicle", function(veh)
    myVeh = veh
    inVeh = true
    while inVeh do
        Wait(5)
        CleanupSounds()

        if (GetPedInVehicleSeat(myVeh, -1) == PlayerPedId()) then
            local class = GetVehicleClass(myVeh)
            if (class == 18) then
                DisableControlAction(0, 86, true) -- INPUT_VEH_HORN
                if state_lxsiren[myVeh] ~= 1 and state_lxsiren[myVeh] ~= 2 and state_lxsiren[myVeh] ~= 3 then
                    state_lxsiren[myVeh] = 0
                end

                if state_pwrcall[myVeh] ~= true then
                    state_pwrcall[myVeh] = false
                end

                if state_airmanu[myVeh] ~= 1 and state_airmanu[myVeh] ~= 2 and state_airmanu[myVeh] ~= 3 then
                    state_airmanu[myVeh] = 0
                end

                if (UseFiretruckSiren(myVeh) or UseAmbulanceSirens(veh)) and state_lxsiren[myVeh] == 1 then
                    TogMuteDfltSrnForVeh(myVeh, false)
                    dsrn_mute = false
                else
                    TogMuteDfltSrnForVeh(myVeh, true)
                    dsrn_mute = true
                end

                if not IsVehicleSirenOn(myVeh) and state_lxsiren[myVeh] > 0 then
                    SetLxSirenStateForVeh(veh, 0)
                    count_bcast_timer = delay_bcast_timer
                end

                if not IsVehicleSirenOn(myVeh) and state_pwrcall[myVeh] == true then
                    TogPowercallStateForVeh(myVeh, false)
                    count_bcast_timer = delay_bcast_timer
                end

                -- ADJUST HORN / MANU STATE
                local hmanu_state_new = 0
                if actv_horn == true and actv_manu == false then
                    hmanu_state_new = 1
                elseif actv_horn == false and actv_manu == true then
                    hmanu_state_new = 2
                elseif actv_horn == true and actv_manu == true then
                    hmanu_state_new = 3
                end

                if hmanu_state_new == 1 then
                    if not UseFiretruckSiren(myVeh) then
                        if state_lxsiren[veh] > 0 and actv_lxsrnmute_temp == false then
                            srntone_temp = state_lxsiren[myVeh]
                            SetLxSirenStateForVeh(myVeh, 0)
                            actv_lxsrnmute_temp = true
                        end
                    end
                else
                    if not UseFiretruckSiren(myVeh) then
                        if actv_lxsrnmute_temp == true then
                            SetLxSirenStateForVeh(myVeh, srntone_temp)
                            actv_lxsrnmute_temp = false
                        end
                    end
                end

                if state_airmanu[myVeh] ~= hmanu_state_new then
                    SetAirManuStateForVeh(myVeh, hmanu_state_new)
                    count_bcast_timer = delay_bcast_timer
                end
            end

            if (class ~= 14 and class ~= 15 and class ~= 16 and class ~= 21) then
                if (count_bcast_timer > delay_bcast_timer) then
                    count_bcast_timer = 0
                    if (class == 18) then
                        TriggerServerEvent("Emergency:Server:DefaultSirenMute", dsrn_mute)
                        TriggerServerEvent("Emergency:Server:SetSirenState", state_lxsiren[veh])
                        TriggerServerEvent("Emergency:Server:SetPwrcallState", state_pwrcall[veh])
                        TriggerServerEvent("Emergency:Server:SetAirManuState", state_airmanu[veh])
                    end
                else
                    count_bcast_timer = count_bcast_timer + 1
                end
            end
        end
    end
end)
