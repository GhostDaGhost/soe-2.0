local action
local jailTime = 0
local isDoingCookingTask, isDoingCleaningTask = false, false
local electricBlips, cleanedSpots, repairedBoxes, cookingStage = {}, {}, {}, 0
local onJob, isDoingElectricianJob, isDoingCookingJob, isDoingCleaningJob = false, false, false, false

-- **********************
--    Local Functions
-- **********************
-- RANDOM HIGH CHANCE OF SENTENCE REDUCTION
local function ReduceMySentence(chance)
    math.randomseed(GetGameTimer())
    if (math.random(1, 100) <= chance) then
        exports["soe-ui"]:SendAlert("success", "Your sentence was reduced by 1 month for good behavior!", 9000)
        TriggerServerEvent("Emergency:Server:ReduceSentence", 1, true)
        jailTime = jailTime - 1
    end
end

-- IF A PLAYER GETS RELEASED DURING A JOB
local function PrisonerWasReleased()
    -- REMOVE ELECTRICIAN JOB BLIPS
    if isDoingElectricianJob then
        for _, blip in pairs(electricBlips) do
            RemoveBlip(blip)
        end
        Wait(150)
        isDoingElectricianJob, electricBlips, repairedBoxes = false, {}, {}
        exports["soe-ui"]:PersistentAlert("end", "electricianJob")
        exports["soe-ui"]:ToggleMinimap(false)
    end

    -- REMOVE ANYTHING RELATED TO COOKING
    if isDoingCookingJob then
        -- RESET ALL COOKING SPOTS STATUS
        for _, spot in pairs(cookingSpots) do
            spot.completed = false
        end
        Wait(150)
        cookingStage, isDoingCookingJob = 0, false
        exports["soe-ui"]:PersistentAlert("end", "cookingJob")
    end

    -- REMOVE ANYTHING RELATED TO CLEANING
    if isDoingCleaningJob then
        -- RESET ALL CLEANING SPOTS STATUS
        for _, spot in pairs(cleaningSpots) do
            spot.cleaned = false
        end
        Wait(150)
        isDoingCleaningJob, cleanedSpots = false, {}
        exports["soe-ui"]:PersistentAlert("end", "cleaningJob")
    end

    if onJob then
        onJob = false
        exports["soe-ui"]:SendAlert("warning", "I heard you got released... you're off the job. Go have fun out there.", 5000)
    end
end

-- DECREASES JAIL TIME BY 1 MIN EVERY 60 SECONDS
local function StartJailTick()
    SetTimeout(60000, function()
        jailTime = jailTime - 1
        TriggerServerEvent("Emergency:Server:ReduceSentence", jailTime, false)
        if (jailTime == 0 or jailTime < 0) then
            PrisonerWasReleased()

            TriggerEvent("Chat:Client:Message", "[Jail]", "Your sentence time is up! Find a purple mark to be released from the prison!", "standard")
            -- TODO: IF DOC IS AVAILABLE, DO NOT AUTO-TELEPORT. FOR NOW LET US TELEPORT THEM TO GET PAST THE LOCKED DOORS - Ghost 4/2/2021
            --[[TriggerEvent("Chat:Client:Message", "[Jail]", "Your sentence time is up! You've been escorted off the prison by local officers from the Department of Corrections.", "standard")
            DoScreenFadeOut(500)
            Wait(500)
            exports["soe-fidelis"]:AuthorizeTeleport()
            SetEntityCoords(PlayerPedId(), vector3(1846.85, 2587.07, 45.67))
            Wait(500)
            DoScreenFadeIn(500)]]
            return
        else
            if (jailTime > 1) then
                TriggerEvent("Chat:Client:Message", "[Jail]", ("You have %s months remaining in your sentence."):format(jailTime), "standard")
            else
                TriggerEvent("Chat:Client:Message", "[Jail]", ("You have %s month remaining in your sentence."):format(jailTime), "standard")
            end
            StartJailTick()
        end
    end)
end

-- ACTIVATES/DEACTIVATES JAIL ALARM
local function JailBreakAlarm(state)
    -- HAVE STROBES AND SIREN GO OFF AT THE PRISON
    local alarmIPL = GetInteriorAtCoordsWithType(1787.004, 2593.1984, 45.7978, "int_prison_main")
    RefreshInterior(alarmIPL)
    EnableInteriorProp(alarmIPL, "prison_alarm")

    -- START/STOP ALARM SOUNDS
    if state then
        while not PrepareAlarm("PRISON_ALARMS") do
            Wait(100)
        end
        StartAlarm("PRISON_ALARMS", true)
    else
        StopAlarm("PRISON_ALARMS", -1)
    end
end

-- FIXES ELECTRICAL BOX
local function FixElectricalBox()
    local ped = PlayerPedId()
    local found, pos = false, GetEntityCoords(ped)
    -- FIND OUR NEAREST ELECTRIC BOX IN THE TABLE
    for index, box in pairs(electricBoxSpots) do
        if #(pos - box.pos) <= 3.5 then
            found = index
            break
        end
    end

    if repairedBoxes[found] then return end
    -- DO THE FOLLOWING IF WE ARE NEAR A BOX
    if found then
        -- ANIMATION
        exports["soe-utils"]:LoadAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@", 15)
        TaskPlayAnim(ped, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0, 1.0, -1, 49, 0, 0, 0, 0)

        -- SKILLBAR MINIGAME
        math.randomseed(GetGameTimer())
        if exports["soe-challenge"]:Skillbar(7000, math.random(5, 12)) then
            Wait(200)
            if exports["soe-challenge"]:Skillbar(6500, math.random(5, 12)) then
                Wait(200)
                if exports["soe-challenge"]:Skillbar(6500, math.random(5, 12)) then
                    Wait(200)
                    if exports["soe-challenge"]:Skillbar(5000, math.random(5, 12)) then
                        repairedBoxes[found] = true
                        exports["soe-ui"]:SendAlert("success", ("You repaired electrical box #%s!"):format(found), 5500)
                        SetBlipScale(electricBlips[found], 1.2)
                        SetBlipColour(electricBlips[found], 69)
                        ReduceMySentence(70)

                        -- IF WE COMPLETED ALL
                        if #repairedBoxes == 14 then
                            for _, blip in pairs(electricBlips) do
                                RemoveBlip(blip)
                            end
                            Wait(150)
                            onJob, isDoingElectricianJob, electricBlips, repairedBoxes = false, false, {}, {}
                            exports["soe-ui"]:ToggleMinimap(false)
                            exports["soe-ui"]:PersistentAlert("end", "electricianJob")
                            exports["soe-ui"]:SendAlert("success", "You completed the electrical chores!", 7500)
                        end
                    end
                end
            end
        end
        ClearPedTasksImmediately(ped)
        StopAnimTask(ped, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 3.0)
    end
end

-- TOGGLES CLEANING JOB
local function ToggleCleaningJob()
    if not isDoingCleaningJob then
        onJob, isDoingCleaningJob = true, true
        -- CREATE MARKERS WHERE PLACES CAN BE CLEANED
        CreateThread(function()
            while isDoingCleaningJob do
                Wait(5)
                for _, spot in pairs(cleaningSpots) do
                    if spot.cleaned then
                        DrawMarker(21, spot.pos.x, spot.pos.y, spot.pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 47, 194, 31, 130, 0, 1, 2, 0, 0, 0, 0)
                    else
                        DrawMarker(21, spot.pos.x, spot.pos.y, spot.pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 153, 43, 43, 130, 0, 1, 2, 0, 0, 0, 0)
                    end
                end
            end
        end)

        -- MAKE NOTIFICATION
        exports["soe-ui"]:PersistentAlert("start", "cleaningJob", "inform", "You've been tasked with cleaning the tables and payphones up. Get to it dammit!", 300)
    else
        for _, spot in pairs(cleaningSpots) do
            spot.cleaned = false
        end
        onJob, isDoingCleaningJob, cleanedSpots = false, false, {}
        exports["soe-ui"]:PersistentAlert("end", "cleaningJob")
        exports["soe-ui"]:SendAlert("error", "You quit the cleaning job", 5000)
    end
end

-- TOGGLES ELECTRICIAN JOB
local function ToggleCookingJob()
    if not isDoingCookingJob then
        onJob, isDoingCookingJob = true, true
        -- CREATE MARKERS OF THE "COOKING STAGES" AND START GENERAL RUNTIME
        CreateThread(function()
            local loopIndex = 0
            while isDoingCookingJob do
                Wait(5)
                for _, spot in pairs(cookingSpots) do
                    if spot.completed then
                        DrawMarker(21, spot.pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 47, 194, 31, 130, 0, 1, 2, 0, 0, 0, 0)
                    else
                        DrawMarker(21, spot.pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 153, 43, 43, 130, 0, 1, 2, 0, 0, 0, 0)
                    end
                end

                loopIndex = loopIndex + 1
                if (loopIndex % 55 == 0) then
                    if (cookingStage == 4) then
                        if not IsEntityPlayingAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 3) then
                            exports["soe-emotes"]:StartEmote("foodtray")
                        end
                    end
                    loopIndex = 0
                end
            end
        end)

        -- MAKE NOTIFICATION
        exports["soe-ui"]:PersistentAlert("start", "cookingJob", "inform", "You've been tasked with cooking meals for the prisoners. Don't burn anything.", 300)
    else
        -- RESET ALL COOKING SPOTS STATUS
        for _, spot in pairs(cookingSpots) do
            spot.completed = false
        end
        Wait(150)
        onJob, cookingStage, isDoingCookingJob = false, 0, false
        exports["soe-ui"]:PersistentAlert("end", "cookingJob")
        exports["soe-ui"]:SendAlert("error", "You quit the cooking job", 5000)
    end
end

-- TOGGLES ELECTRICIAN JOB
local function ToggleElectricianJob()
    if not isDoingElectricianJob then
        -- CREATE BLIPS FOR THE ELECTRIC BOXES
        electricBlips = {}
        for index, box in pairs(electricBoxSpots) do
            local blip = AddBlipForCoord(box.pos)
            SetBlipSprite(blip, 402)
            SetBlipColour(blip, 5)
            SetBlipScale(blip, 1.4)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Electric Box #" .. index)
            EndTextCommandSetBlipName(blip)
            table.insert(electricBlips, blip)
        end

        -- MAKE NOTIFICATION AND SHOW MINIMAP
        onJob, isDoingElectricianJob = true, true
        exports["soe-ui"]:ToggleMinimap(true)
        exports["soe-ui"]:PersistentAlert("start", "electricianJob", "inform", "You've been tasked with repairing electrical boxes. You've been given a map with all of them.", 300)
    else
        for _, blip in pairs(electricBlips) do
            RemoveBlip(blip)
        end
        Wait(150)
        onJob, isDoingElectricianJob, electricBlips = false, false, {}
        exports["soe-ui"]:PersistentAlert("end", "electricianJob")
        exports["soe-ui"]:SendAlert("error", "You quit the electrician job", 5000)
        exports["soe-ui"]:ToggleMinimap(false)
    end
end

-- DOES CLEANING TASK
local function DoCleaningTask()
    local mySpot
    -- FIND CLOSEST CLEANING TASK SPOT
    for _, spotData in pairs(cleaningSpots) do
        if #(GetEntityCoords(PlayerPedId()) - vector3(spotData.pos.x, spotData.pos.y, spotData.pos.z)) <= 1.0 then
            mySpot = spotData
            break
        end
    end

    -- IF WE ARE NEARBY A SPOT
    if mySpot then
        -- CHECK IF THIS CLEANING TASK HAS ALREADY BEEN DONE
        if mySpot.cleaned then
            exports["soe-ui"]:SendAlert("error", "You already cleaned this")
            return
        end

        isDoingCleaningTask = true
        SetEntityHeading(PlayerPedId(), mySpot.pos.w)
        exports["soe-emotes"]:StartEmote("clean")
        exports["soe-utils"]:Progress(
            {
                name = "cleaningTask",
                duration = math.random(8500, 9500),
                label = "Cleaning",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = false
                }
            },
            function(cancelled)
                isDoingCleaningTask = false
                exports["soe-emotes"]:CancelEmote()
                if not cancelled then
                    mySpot.cleaned = true
                    cleanedSpots[#cleanedSpots + 1] = true
                    exports["soe-ui"]:SendAlert("success", "This looks clean enough for now!", 6500)

                    -- IF WE COMPLETED ALL
                    if #cleanedSpots == 13 then
                        for _, spot in pairs(cleaningSpots) do
                            spot.cleaned = false
                        end
                        onJob, isDoingCleaningJob, cleanedSpots = false, false, {}
                        exports["soe-ui"]:PersistentAlert("end", "cleaningJob")
                        exports["soe-ui"]:SendAlert("success", "You completed the cleaning chores!", 7500)
                        ReduceMySentence(70)
                    end
                end
            end
        )
    end
end

-- DOES COOKING TASK
local function DoCookingTask()
    local mySpot
    -- FIND CLOSEST COOKING TASK SPOT
    for _, spotData in pairs(cookingSpots) do
        if #(GetEntityCoords(PlayerPedId()) - spotData.pos) <= 1.0 then
            mySpot = spotData
            break
        end
    end

    -- IF WE ARE NEARBY A SPOT
    if mySpot then
        -- CHECK IF THIS COOKING TASK HAS ALREADY BEEN DONE
        if mySpot.completed then
            exports["soe-ui"]:SendAlert("error", "You already did this task")
            return
        end

        -- CHECK WHICH TASK THIS IS.. GOD I WISH SWITCH STATEMENTS EXISTED - Ghost 4/2/2021
        if (mySpot.name == "Washing") then
            if (cookingStage ~= 0) then
                exports["soe-ui"]:SendAlert("error", "You already washed your hands", 5000)
                return
            end

            isDoingCookingTask = true
            exports["soe-ui"]:SendAlert("warning", "Its always important to wash my hands...", 8500)
            exports["soe-utils"]:Progress(
                {
                    name = "washingHands",
                    duration = 9500,
                    label = "Washing Hands",
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                        disableMovement = false,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = false
                    },
                    animation = {
                        animDict = "amb@prop_human_bum_bin@base",
                        anim = "base",
                        flags = 1
                    }
                },
                function(cancelled)
                    isDoingCookingTask = false
                    ClearPedTasks(PlayerPedId())
                    if not cancelled then
                        cookingStage = 1
                        mySpot.completed = true
                        exports["soe-ui"]:SendAlert("success", "You washed your hands. Now you can move onto gathering the ingredients.", 8500)
                    end
                end
            )
        elseif (mySpot.name == "Gathering Ingredients") then
            -- MAKE SURE WE WASHED OUR HANDS FIRST
            if (cookingStage ~= 1) then
                exports["soe-ui"]:SendAlert("error", "Make sure to wash your hands first!", 5000)
                return
            end

            isDoingCookingTask = true
            exports["soe-ui"]:SendAlert("warning", "Gotta get the ingredients first...", 8500)
            exports["soe-utils"]:Progress(
                {
                    name = "gettingIngredients",
                    duration = 7500,
                    label = "Getting Ingredients",
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                        disableMovement = false,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = false
                    },
                    animation = {
                        animDict = "anim@heists@ornate_bank@grab_cash",
                        anim = "grab",
                        flags = 1
                    }
                },
                function(cancelled)
                    isDoingCookingTask = false
                    ClearPedTasks(PlayerPedId())
                    if not cancelled then
                        cookingStage = 2
                        mySpot.completed = true
                        exports["soe-ui"]:SendAlert("success", "You got the ingredients. Now you can move onto cooking.", 8500)
                    end
                end
            )
        elseif (mySpot.name == "Cooking") then
            -- MAKE SURE WE GOT INGREDIENTS FIRST
            if (cookingStage ~= 2) then
                exports["soe-ui"]:SendAlert("error", "Make sure to get the ingredients!", 5000)
                return
            end

            -- START COOKING OUR MEAL ON THE STOVE
            isDoingCookingTask = true
            exports["soe-ui"]:SendAlert("success", "Time to start cooking this meal!", 8500)
            exports["soe-emotes"]:StartEmote("bbq")
            Wait(math.random(10000, 12000))

            exports["soe-ui"]:SendAlert("warning", "I need to flip this!", 5000)
            if exports["soe-challenge"]:Skillbar(9500, math.random(5, 10)) then
                Wait(math.random(10000, 12000))
                exports["soe-ui"]:SendAlert("warning", "I need to flip this!", 5000)
                if exports["soe-challenge"]:Skillbar(9500, math.random(5, 10)) then
                    cookingStage = 3
                    mySpot.completed = true
                    exports["soe-ui"]:SendAlert("success", "You cooked the meal. Now you can move onto finalizing.", 8500)
                else
                    exports["soe-ui"]:SendAlert("error", "Damn! I burned it!", 5000)
                end
            else
                exports["soe-ui"]:SendAlert("error", "Damn! I burned it!", 5000)
            end

            isDoingCookingTask = false
            exports["soe-emotes"]:CancelEmote()
        elseif (mySpot.name == "Finalizing") then
            -- MAKE SURE WE COOKED THE MEAL FIRST
            if (cookingStage ~= 3) then
                exports["soe-ui"]:SendAlert("error", "Make sure to cook the meal first!", 5000)
                return
            end

            isDoingCookingTask = true
            exports["soe-ui"]:SendAlert("warning", "Now to fully prepare this meal by adding sides and condiments.", 8500)
            exports["soe-utils"]:Progress(
                {
                    name = "preparingMeal",
                    duration = 8500,
                    label = "Preparing Meal",
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                        disableMovement = false,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = false
                    },
                    animation = {
                        animDict = "mp_weapons_deal_sting",
                        anim = "crackhead_bag_loop",
                        flags = 49
                    }
                },
                function(cancelled)
                    isDoingCookingTask = false
                    ClearPedTasks(PlayerPedId())
                    if not cancelled then
                        cookingStage = 4
                        mySpot.completed = true
                        exports["soe-ui"]:SendAlert("success", "You prepared the meal. Now go to the window and deliver the meal there.", 8500)
                        exports["soe-emotes"]:StartEmote("foodtray")
                    end
                end
            )
        elseif (mySpot.name == "Delivering") then
            -- MAKE SURE WE FINALIZED THE MEAL
            if (cookingStage ~= 4) then
                exports["soe-ui"]:SendAlert("error", "Make sure to finalize the meal first!", 5000)
                return
            end

            mySpot.completed = true
            for _, spot in pairs(cookingSpots) do
                spot.completed = false
            end
            cookingStage = 0
            exports["soe-emotes"]:CancelEmote()
            exports["soe-ui"]:SendAlert("success", "Good job! You prepared that meal. You can make another or come back to me to stop and take a break.", 8500)
            ReduceMySentence(68)
        end
    end
end

-- **********************
--    Global Functions
-- **********************
-- RETURNS WHETHER PLAYER IS DOING ELECTRICIAN JOB
function IsDoingElectricianJob()
    return isDoingElectricianJob
end

-- RETURNS IF PLAYER IS IN JAIL
function IsImprisoned()
    if (jailTime <= 0) then
        return false
    end
    return true
end

-- SENDS PLAYER TO PRISON TO A RANDOM CELL
function SendToPrison()
    math.randomseed(GetGameTimer())
    local cell = cells[math.random(1, #cells)]

    local ped = PlayerPedId()
    exports["soe-fidelis"]:AuthorizeTeleport()
    SetEntityCoords(ped, cell.pos)
    SetEntityHeading(ped, cell.pos.w)
end

-- RETURNS WHETHER PLAYER IS NEAR ELECTRICAL BOX
function IsNearElectricalBox()
    for _, box in pairs(electricBoxSpots) do
        if #(GetEntityCoords(PlayerPedId()) - box.pos) <= 3.5 then
            return true
        end
    end
    return false
end

-- RETURNS WHETHER PLAYER IS NEAR ELECTRICIAN JOB
function IsNearElectricJob()
    for _, spot in pairs(jobSpots) do
        if (spot.type == "Electrician") then
            if #(GetEntityCoords(PlayerPedId()) - spot.pos) <= 3.5 then
                return true
            end
        end
    end
    return false
end

-- **********************
--        Events
-- **********************
-- REQUESTED FROM SERVER TO INITIATE PRISON ALARM
RegisterNetEvent("Prison:Client:JailBreakAlarm")
AddEventHandler("Prison:Client:JailBreakAlarm", JailBreakAlarm)

-- REQUESTED FROM RADIAL MENU TO FIX ELECTRICAL BOX
AddEventHandler("Prison:Client:FixElectricalBox", FixElectricalBox)

-- REQUESTED FROM RADIAL MENU TO START ELECTRICIAN JOB
AddEventHandler("Prison:Client:StartElectricianJob", ToggleElectricianJob)

-- CALLED FROM SERVER TO SYNC JAILTIME
RegisterNetEvent("Prison:Client:SyncJailTime")
AddEventHandler("Prison:Client:SyncJailTime", function(_jailTime)
    jailTime = _jailTime
end)

-- UPON RESOURCE START, MAKE OUR PRISONER PEDS
AddEventHandler("onClientResourceStart", function(resource)
    if (GetCurrentResourceName() ~= resource) then return end
    Wait(3500)

    CreateZones()
end)

AddEventHandler("Utils:Client:ExitedZone", function(name)
    if name:match("prison") then
        action = nil
        exports["soe-ui"]:HideTooltip()
    end
end)

AddEventHandler("Utils:Client:EnteredZone", function(name, zoneData)
    if (name == "prison_cookingjob") then
        action = {status = true, jobType = "Cooking"}
        if not isDoingCookingJob then
            exports["soe-ui"]:ShowTooltip("fas fa-utensils", "[E] Start Cooking Job", "inform")
        else
            exports["soe-ui"]:ShowTooltip("fas fa-utensils", "[E] Stop Cooking Job", "inform")
        end
    elseif (name == "prison_cleaningjob") then
        action = {status = true, jobType = "Cleaning"}
        if not isDoingCleaningJob then
            exports["soe-ui"]:ShowTooltip("fas fa-broom", "[E] Start Cleaning Job", "inform")
        else
            exports["soe-ui"]:ShowTooltip("fas fa-broom", "[E] Stop Cleaning Job", "inform")
        end
    end
end)

AddEventHandler("Utils:Client:InteractionKey", function()
    -- MAKE SURE WE ARE NOT DEAD OR HANDCUFFED
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
        return
    end

    -- IF E IS PRESSED WHILE DOING COOKING JOB, DO THE TASK
    if isDoingCookingJob then
        if isDoingCookingTask then return end
        DoCookingTask()
    end

    -- IF E IS PRESSED WHILE DOING CLEANING JOB, DO THE CLEANING
    if isDoingCleaningJob then
        if isDoingCleaningTask then return end
        DoCleaningTask()
    end

    -- ZONE TRACKING ACTIONS
    if not action then return end
    if action.status then
        if (action.jobType == "Cooking") then
            ToggleCookingJob()
        elseif (action.jobType == "Cleaning") then
            ToggleCleaningJob()
        end
    end
end)

-- CALLED FROM THE SERVER FROM "/arrest" TO SEND PLAYER TO JAIL
RegisterNetEvent("Prison:Client:ArrestPlayer")
AddEventHandler("Prison:Client:ArrestPlayer", function(time)
    local ped = PlayerPedId()

    -- SEND THE PLAYER TO A MUGSHOT ROOM
    DoScreenFadeOut(500)
    Wait(500)
    FreezeEntityPosition(ped, true)

    math.random() math.random() math.random()
    TriggerServerEvent("Instance:Server:SetPlayerInstance", "MugshotRoom-" .. math.random(50000))
    exports["soe-fidelis"]:AuthorizeTeleport()
    SetEntityCoords(ped, vector3(402.91, -996.75, (-99.0 - 1)))
    SetEntityHeading(ped, 186.2)
    exports["soe-emotes"]:StartEmote("mugshot")

    -- DO SOME PICTURE TAKING
    Wait(1500)
    DoScreenFadeIn(500)
    for i = 1, 2 do
        PlaySoundFrontend(-1, "Camera_Shoot", "Phone_Soundset_Franklin", 1)
        Wait(3000)
    end

    SetEntityHeading(ped, 88.07)
    for i = 1, 2 do
        PlaySoundFrontend(-1, "Camera_Shoot", "Phone_Soundset_Franklin", 1)
        Wait(3000)
    end

    SetEntityHeading(ped, 270.0)
    for i = 1, 2 do
        PlaySoundFrontend(-1, "Camera_Shoot", "Phone_Soundset_Franklin", 1)
        Wait(3000)
    end

    -- DELETE OUR BOARD AND UNFREEZE INMATE
    Wait(2000)
    FreezeEntityPosition(ped, false)
    DoScreenFadeOut(500)
    exports["soe-utils"]:PlaySound("cell_closing.ogg", exports["soe-utils"]:GetSoundLevel(), true)

    Wait(500)
    TriggerServerEvent("Instance:Server:SetPlayerInstance", -1)
    SendToPrison(ped)
    Wait(500)
    DoScreenFadeIn(500)

    jailTime = time
    StartJailTick()
    exports["soe-emotes"]:CancelEmote()

    -- START LOOP TO ENSURE PLAYER STAYS IN PRISON BOUNDARIES
    while (jailTime > 0) do
        Wait(1500)
        if #(GetEntityCoords(PlayerPedId()) - vector3(1690.2, 2599.81, 45.56)) > 119 then
            if (jailTime == 0) then return end
            DoScreenFadeOut(500)
            Wait(500)
            SendToPrison(PlayerPedId())
            Wait(500)
            DoScreenFadeIn(500)
            exports["soe-ui"]:SendAlert("error", "The DOC puts you back to the cells because you went too far", 5000)
        end
    end
end)
