local currentBed = nil
local isLogsOpen = false
local isOnBed, isGettingOutOfBed = false, false

-- ***********************
--     Local Functions
-- ***********************
-- DISPLAYS BLEEDING WOUNDS
local function DisplayTriageInfo(bloodyBone)
    if (IsBleeding() and bloodyBone ~= nil) then
        TriggerEvent("Chat:Client:Message", "[Triage]", ("^1Bleeding ^0coming from the ^3%s^0."):format(bloodyBone), "system")
    end
end

-- FINDS THE NEAREST PLAYER TO TAKE FROM BED
local function TakeFromBedOptions()
    local player = exports["soe-utils"]:GetClosestPlayer(5)
    if (player ~= nil) then
        TriggerServerEvent("Healthcare:Server:TakeFromBed", GetPlayerServerId(player))
    else
        exports["soe-ui"]:SendAlert("error", "Nobody close enough", 5000)
    end
end

-- GETS THE DRAGGED/CARRIED/ESCORTED PLAYER IN BED
local function PutInBedOptions(noCharge)
    -- RESET ESCORTING/DRAGGING/CARRYING STATUS
    local holding = exports["soe-civ"]:IsHolding()
    local dragging = exports["soe-civ"]:IsDragging()
    local carrying = exports["soe-civ"]:IsCarrying()
    local escorting = exports["soe-civ"]:IsEscorting()
    if (escorting ~= nil) then
        TriggerServerEvent("Civ:Server:EscortPlayer", escorting, false)
        TriggerServerEvent("Healthcare:Server:PutInBed", escorting, noCharge)
        exports["soe-civ"]:SetEscortingState(nil)
    elseif (carrying ~= nil) then
        TriggerServerEvent("Civ:Server:CarryPlayer", carrying, false)
        TriggerServerEvent("Healthcare:Server:PutInBed", carrying, noCharge)
        exports["soe-civ"]:SetCarryingState(nil)
    elseif (dragging ~= nil) then
        TriggerServerEvent("Civ:Server:DragPlayer", dragging, false)
        TriggerServerEvent("Healthcare:Server:PutInBed", dragging, noCharge)
        exports["soe-civ"]:SetDraggingState(nil)
    elseif (holding ~= nil) then
        TriggerServerEvent("Civ:Server:HoldPlayer", holding, false)
        TriggerServerEvent("Healthcare:Server:PutInBed", holding, noCharge)
        exports["soe-civ"]:SetHoldingState(nil)
    end
end

-- TRIGGERED AFTER FORCED TO LEAVE A BED
local function TakeFromBed()
    if isOnBed then
        local ped = PlayerPedId()
        if checkedIn then
            TriggerServerEvent("Healthcare:Server:CheckOutOfBed", checkedInBed)
            checkedInBed = nil
            checkedIn = false
        end

        ClearPedTasks(ped)
        local hdg = GetEntityHeading(currentBed)
        SetEntityHeading(ped, hdg - 90)

        isOnBed = false
        exports["soe-utils"]:LoadAnimDict("switch@franklin@bed", 15)
        exports["soe-ui"]:SendAlert("inform", "You've been helped off the bed")
        TaskPlayAnim(ped, "switch@franklin@bed", "sleep_getup_rubeyes", 8.0, 8.0, -1, 8, 0, 0, 0, 0)
    end
end

-- DECIDES WHETHER TO TRIAGE THE NEAREST NPC OR PLAYER
local function TriageOptions()
    local ped = exports["soe-utils"]:GetPedInFrontOfPlayer(5)
    if (ped ~= nil and ped ~= 0) and not IsPedAPlayer(ped) then
        local death = GetPedCauseOfDeath(ped)
        local weaponName = exports["soe-utils"]:GetWeaponNameFromHashKey(death)
        print(weaponName)
        if (causesOfDeath[weaponName] ~= nil) then
            TriggerEvent("Chat:Client:Message", "[Triage]", ("You examine the individual and determine that their injuries are ^3%s^0."):format(causesOfDeath[weaponName]), "standard")
        else
            TriggerEvent("Chat:Client:Message", "[Triage]", "You examine the individual and could not determine what their injuries are.", "system")
        end
    else
        local player = exports["soe-utils"]:GetClosestPlayer(5)
        if (player ~= nil) then
            TriggerServerEvent("Healthcare:Server:TriagePlayer", GetPlayerServerId(player))
        else
            exports["soe-ui"]:SendAlert("error", "Nobody close enough", 5000)
        end
    end
end

-- STARTS BED HEALING
local function StartHealingInBed(dict, anim, noCharge)
    -- NO CHARGE FOR EMERGENCY SERVICES | GOVERNOR OZZY REQUEST 8/18/2021
    local myJob = exports["soe-jobs"]:GetMyJob()
    if (myJob == "POLICE" or myJob == "EMS") then
        noCharge = true
    end

    local ped = PlayerPedId()
    if not noCharge then
        if (GetEntityHealth(ped) < 185) and not exports["soe-emergency"]:IsDead() then
            local debt = 200
            if checkedIn then
                if exports["soe-config"]:GetConfigValue("economy", "hospital_checkin") then
                    debt = exports["soe-config"]:GetConfigValue("economy", "hospital_checkin")
                end
            else
                if exports["soe-config"]:GetConfigValue("economy", "hospital") then
                    debt = exports["soe-config"]:GetConfigValue("economy", "hospital")
                end
            end
            TriggerServerEvent("Bank:Server:IncreaseStateDebt", debt, "San Andreas Health Authority", "Medical Treatment", false)
        end
    end

    -- START BED LOOP
    exports["soe-ui"]:SendAlert("inform", "You are being treated while in bed", 5000)
    HealInjuriesAndBleeding()
    while isOnBed do
        Wait(1150)
        -- MAKE SURE HEALING IS ONGOING
        if GetEntityHealth(ped < 200) then
            local health = GetEntityHealth(ped)
            SetEntityHealth(ped, health + 1)
        end

        -- MAKE SURE PLAYER IS LYING ON THE BED
        if not isGettingOutOfBed then
            if not IsEntityPlayingAnim(ped, dict, anim, 3) then
                TaskPlayAnim(ped, dict, anim, 1.0, 1.0, -1, 1, 0, 0, 0, 0, 0)
            end
        end

        -- MAKE SURE PLAYER STAYS ON BED
        local myPos = GetEntityCoords(ped)
        local bPos, bHdg = GetEntityCoords(currentBed), GetEntityHeading(currentBed)
        if #(myPos - bPos) > 1.4 then
            SetEntityCoords(ped, bPos)
            SetEntityHeading(ped, (bPos + 180))
            TaskPlayAnim(ped, dict, anim, 1.0, 1.0, -1, 1, 0, 0, 0, 0, 0)
            exports["soe-ui"]:SendAlert("error", "You must stay on the bed while being treated", 3500)
        end
    end
    TriggerServerEvent("Healthcare:Server:ResetPedDamage")
end

-- GETS ONTO THE NEAREST BED
local function GetInBed(noCharge)
    local ped = PlayerPedId()

    -- IF ALREADY IN BED
    if isOnBed then
        isOnBed = false
        if checkedIn then
            TriggerServerEvent("Healthcare:Server:CheckOutOfBed", checkedInBed)
            checkedInBed = nil
            checkedIn = false
        end

        ClearPedTasks(ped)
        local hdg = GetEntityHeading(currentBed)
        SetEntityHeading(ped, hdg - 90)

        isGettingOutOfBed = true
        exports["soe-utils"]:LoadAnimDict("switch@franklin@bed", 15)
        TaskPlayAnim(ped, "switch@franklin@bed", "sleep_getup_rubeyes", 8.0, 8.0, -1, 8, 0, 0, 0, 0)
        Wait(9000)
        exports["soe-emotes"]:RestoreSavedWalkstyle()
        return
    end

    -- GET OUR CLOSEST BED
    local myPos = GetEntityCoords(ped)
    for _, v in pairs(beds) do
        local nearestBed = GetClosestObjectOfType(myPos, 1.5, GetHashKey(v), 0, 1, 1)
        if DoesEntityExist(nearestBed) then
            currentBed = nearestBed
            break
        else
            currentBed = nil
        end
    end

    if (currentBed == nil) then
        exports["soe-ui"]:SendAlert("error", "No beds nearby", 5000)
        return
    end

    -- REVIVE PLAYER IF DEAD
    if exports["soe-emergency"]:IsDead() then
        exports["soe-nutrition"]:SetLevels(175, 175)
        exports["soe-ui"]:SendAlert("warning", "You've been nourished and helped out by the medical staff", 5000)
        TriggerServerEvent("Emergency:Server:RevivePlayer", GetPlayerServerId(PlayerId()), nil)
    end

    local pos, hdg = GetEntityCoords(currentBed), GetEntityHeading(currentBed)
    SetEntityCoords(ped, pos)
    SetEntityHeading(ped, (hdg + 180))

    -- RANDOMLY GENERATES LYING ANIMATION
    local dict
    local anim
    math.randomseed(GetGameTimer())
    local math = math.random(0, 5)
    if (math == 5) then
        dict = "dead"
        anim = "dead_e"
    elseif (math == 4) then
        dict = "timetable@denice@ig_1"
        anim = "base"
    elseif (math == 3) then
        dict = "missfbi1"
        anim = "cpr_pumpchest_idle"
    else
        dict = "dead"
        anim = "dead_a"
    end

    isOnBed = true
    isGettingOutOfBed = false
    exports["soe-utils"]:LoadAnimDict(dict, 15)
    TaskPlayAnim(ped, dict, anim, 1.0, 1.0, -1, 1, 0, 0, 0, 0, 0)
    StartHealingInBed(dict, anim, noCharge)
end

-- ***********************
--    Global Functions
-- ***********************
-- OPENS LOGS UI
function OpenLogUI()
    if isLogsOpen then return end
    isLogsOpen = true

    local hospitalLogs = exports["soe-nexus"]:TriggerServerCallback("Healthcare:Server:GetLogs")
    SetNuiFocus(true, true)
    SendNUIMessage({type = "openLogs", logData = hospitalLogs})
end

-- INVENTORY ITEM USAGE OF A FIRST AID KIT
function UseFirstAidKit()
    exports["soe-utils"]:Progress(
        {
            name = "usingFAK",
            duration = 30000,
            label = "Using First Aid Kit",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = false,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = false
            },
            animation = {
                animDict = "amb@world_human_clipboard@male@idle_b",
                anim = "idle_d",
                flags = 49
            },
            prop = {
                model = "prop_ld_health_pack",
                bone = 60309
            }
        },
        function(cancelled)
            if not cancelled then
                local ped = PlayerPedId()
                local health = GetEntityHealth(ped)
                if (health < 150) then
                    health = health + 5
                    SetEntityHealth(ped, health)
                end

                StopBleeding()
                exports["soe-ui"]:SendAlert("inform", "You wrap your wounds up to stop the bleeding", 5000)
            end
        end
    )
end

-- ***********************
--        Commands
-- ***********************
-- THIS NEEDS TO BE IN CLIENT SIDE UNFORTUNATELY, CHECKS YOUR OWN TRIAGE RESULTS
RegisterCommand("triageself", function()
    TriggerServerEvent("Healthcare:Server:TriagePlayer", GetPlayerServerId(PlayerId()))
end)

-- ***********************
--     NUI Callbacks
-- ***********************
-- WHEN TRIGGERED, STOP NUI FOCUS FOR THE LOG UI
RegisterNUICallback("Logs.CloseUI", function()
    isLogsOpen = false
    SetNuiFocus(false, false)
end)

-- ***********************
--         Events
-- ***********************
-- CALLED FROM SERVER AFTER "/bed" IS EXECUTED
RegisterNetEvent("Healthcare:Client:GetInBed")
AddEventHandler("Healthcare:Client:GetInBed", GetInBed)

-- CALLED FROM SERVER AFTER "/putinbed" IS EXECUTED
RegisterNetEvent("Healthcare:Client:PutInBedOptions")
AddEventHandler("Healthcare:Client:PutInBedOptions", PutInBedOptions)

-- CALLED FROM SERVER AFTER "/takefrombed" IS EXECUTED
RegisterNetEvent("Healthcare:Client:TakeFromBedOptions")
AddEventHandler("Healthcare:Client:TakeFromBedOptions", TakeFromBedOptions)

-- CALLED FROM SERVER AFTER "/triage" IS EXECUTED
RegisterNetEvent("Healthcare:Client:TriageOptions")
AddEventHandler("Healthcare:Client:TriageOptions", TriageOptions)

-- CALLED FROM SERVER TO SHOW INJURED AND BLEEDING WOUNDS
RegisterNetEvent("Healthcare:Client:TriagePlayer")
AddEventHandler("Healthcare:Client:TriagePlayer", DisplayTriageInfo)

-- CALLED FROM SERVER TO MAKE THE PLAYER LEAVE THE BED
RegisterNetEvent("Healthcare:Client:TakeFromBed")
AddEventHandler("Healthcare:Client:TakeFromBed", TakeFromBed)
