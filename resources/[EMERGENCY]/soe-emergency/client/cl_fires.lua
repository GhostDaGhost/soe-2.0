local fireBlip
local fireFXPos
local fireSmoke
local fireHealth
local fireFX = {}
local hasCaughtFire = false

-- DEBUG HEALTHBAR FOR THE FIRE
local function DebugHealthbar(health)
    local width = (health * 0.00295)
    local red = math.abs(health - 100) * 2.55
    local green = 255 - ((100 - health) * 2.55)
    local offset = 0.382 - ((0.059 - width) / 2)

    DrawRect(0.5, 0.975, 0.3, 0.035, 0, 0, 0, 110)
    DrawRect(offset, 0.975, width, 0.028, math.floor(red), math.floor(green), 0, 100)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.0, 0.40)
    SetTextDropshadow(1, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()

    SetTextEntry("STRING")
    AddTextComponentString("Fire Health")
    DrawText(0.47, 0.96)
end

-- COMPLETELY STOPS CURRENTLY ACTIVE FIRE
RegisterNetEvent("Emergency:Client:ExtinguishFire")
AddEventHandler("Emergency:Client:ExtinguishFire", function()
    for k in pairs(fireFX) do
        RemoveParticleFx(fireFX[k], 1)
    end
    RemoveParticleFx(fireSmoke, 1)

    fireFX = {}
    fireSmoke = nil
    RemoveBlip(fireBlip)
end)

-- MAKES THE PLAYER CATCH FIRE IF NEARBY AND ALLOWS FIRE TO BE EXTINGUISHED
AddEventHandler("Emergency:Client:HandleFireRuntime", function()
    local time = 350
    local ped = PlayerPedId()
    local isEMS = (exports["soe-jobs"]:GetMyJob() == "EMS")
    while #fireFX ~= 0 do
        Wait(time)
        local pos = GetEntityCoords(ped)
        if #(pos - fireFXPos) <= 5.0 then
            if not hasCaughtFire then
                hasCaughtFire = true
                StartEntityFire(ped)
                Wait(10000)
                StopEntityFire(ped)
                hasCaughtFire = false
            end
        elseif #(pos - fireFXPos) <= 55.0 then
            time = 5
            if isEMS then
                DebugHealthbar(fireHealth)
            end

            local veh = GetVehiclePedIsIn(ped, false)
            if (GetEntityModel(veh) == GetHashKey("firetruk")) then
                if IsControlPressed(0, 25) then
                    fireHealth = fireHealth - 0.08
                    DisableControlAction(0, 25)
                end

                if (fireHealth <= 0) then
                    TriggerServerEvent("Emergency:Server:ExtinguishFire")
                    break
                end
            elseif (GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_FIREEXTINGUISHER")) then
                if IsControlPressed(0, 24) then
                    fireHealth = fireHealth - 0.03
                    DisableControlAction(0, 24)
                end
            end
        else
            time = 350
        end
    end
end)

-- CALLED FROM SERVER TO START A FIRE
RegisterNetEvent("Emergency:Client:StartFire")
AddEventHandler("Emergency:Client:StartFire", function(fire, possibleLocations)
    RemoveBlip(fireBlip)
    for _, fx in pairs(fireFX) do
        RemoveParticleFx(fx, 1)
    end
    RemoveParticleFx(fireSmoke, 1)

    local pos = possibleLocations[fire][1].pos
    exports["soe-utils"]:LoadPTFXAsset("core", 15)

    UseParticleFxAssetNextCall("core")
    fireFX[1] = StartParticleFxLoopedAtCoord("fire_wrecked_plane_cockpit", pos, 0.0, -2.0, 0.8, 10.0, 1, 0, 1, 1)
    exports["soe-utils"]:LoadPTFXAsset("scr_agencyheistb", 15)

    UseParticleFxAssetNextCall("scr_agencyheistb")
    fireSmoke = StartParticleFxLoopedAtCoord("scr_agency3b_blding_smoke", pos, 0.0, -2.0, 0.8, 3.0, 1, 0, 1, 1)
    fireHealth = 100
    if #possibleLocations[fire] <= 2 then
        for i = 2, #possibleLocations[fire] do
            UseParticleFxAssetNextCall("core")
            fireFX[i] = StartParticleFxLoopedAtCoord("fire_wrecked_plane_cockpit", possibleLocations[fire][i].pos.x, possibleLocations[fire][i].pos.y, possibleLocations[fire][i].pos.z - 0.98, 0.0, -2.0, 0.8, 2.0 * (100 / fireHealth), 1, 0, 1, 1)
        end
    else
        local amount = {}
        while #amount < 2 do
            Wait(5)
            local val = math.random(2, #possibleLocations[fire])
            local found = false
            if #amount == 0 then
                amount[1] = val
            end

            for _, v in pairs(amount) do
                if (v == val) then
                    found = true
                    break
                end
            end

            if not found then 
                amount[#amount + 1] = val
            end
        end

        for _, v in pairs(amount) do
            UseParticleFxAssetNextCall("core")
            fireFX[v] = StartParticleFxLoopedAtCoord("fire_wrecked_plane_cockpit", possibleLocations[fire][v].pos.x, possibleLocations[fire][v].pos.y, possibleLocations[fire][v].pos.z - 0.98, 0.0, -2.0, 0.8, 2.0, 1, 0, 1, 1)
        end
    end

    fireFXPos = pos
    TriggerEvent("Emergency:Client:HandleFireRuntime")

    -- ALERT FOR FIRE TO EMERGENCY SERVICES
    local myJob = exports["soe-jobs"]:GetMyJob()
    local loc = exports["soe-utils"]:GetLocation(fireFXPos)
    if (myJob == "NEWS") then
        TriggerEvent("Jobs:Client:SendNewsReport", location, fireFXPos, "Fire")
    end

    if (myJob == "POLICE" or myJob == "DISPATCH" or myJob == "EMS") then
        fireBlip = AddBlipForCoord(fireFXPos)
        SetBlipSprite(fireBlip, 436)
        SetBlipColour(fireBlip, 1)

        if (myJob == "EMS") then
            TriggerServerEvent("Emergency:Server:EMSAlerts", {status = true, global = false, type = "Fire Alarm", loc = loc})
            --[[TriggerServerEvent("CADAlerts:Server:SendCAD", false, {
                ["cadType"] = "EMS",
                ["coords"] = fireFXPos,
                ["title"] = "<b>10-70 - Fire Alarm</b><hr>",
                ["description"] = desc,
                ["blip"] = {
                    ["sprite"] = 436,
                    ["color"] = 1,
                    ["scale"] = 0.0
                }
            })]]
        else
            local desc = ("Civilians report a large fire at %s. LEOs are requested to respond for crowd control."):format(loc)
            TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = false, type = "Fire Alarm", desc = desc, code = "10-70", loc = loc, coords = fireFXPos})
        end
    end
end)
