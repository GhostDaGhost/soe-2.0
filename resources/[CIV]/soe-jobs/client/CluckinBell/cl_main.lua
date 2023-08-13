-- LOCAL VARIABLES
SOEMenu = assert(MenuV)
local jobMenuMain = SOEMenu:CreateMenu(false, "Cluck cluck", 'topright', 255, 255, 255, 'size-100', 'default', 'menuv', 'jobMenuMain', 'native')
cluckinBellMenuRadius = 1.5
isCluckinBellMenuOpen = false

local jobTitle = "[Cluckin' Bell]"
jobStartCoords = vector3(-68.37363, 6253.662, 31.08276)
jobStart = false

roleID = 0
doingTask = false
isOnDuty = false
currentRole = jobRoles[0].roleName

-- **********************
--       Functions
-- **********************

-- THIS WILL SET THE PLAYER ON/OFF CLUCKIN BELL JOB
function ClockinCluckinBell(bool)
    isOnDuty = bool
    TriggerServerEvent("Jobs:Server:ToggleDuty", {status = true, dutyStatus = isOnDuty, job = "CLUCKINBELL"})
    print("CLUCKINBELL CLOCKIN", isOnDuty)
end

-- JOB START
function JobStart()
    jobStart = true

    -- CREATE MARKERS FOR JOB ROLE
    CreateThread(function()
        while isOnDuty and jobStart do
            Wait(5)
            if not doingTask and jobRoles[roleID].tableName ~= nil then
                for index, spot in pairs(jobRoles[roleID].tableName) do
                    if spot.stockTaked ~= nil and not spot.stockTaked then
                        DrawMarker(21, spot.pos.x, spot.pos.y, spot.pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 153, 43, 43, 130, 0, 1, 2, 0, 0, 0, 0) -- RED
                    elseif spot.dropOff ~= nil and spot.dropOff and jobRoles[roleID].hasLogisticsPackage then
                        DrawMarker(21, spot.pos.x, spot.pos.y, spot.pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 47, 31, 194, 130, 0, 1, 2, 0, 0, 0, 0) -- BLUE
                    elseif not spot.dropOff and not jobRoles[roleID].hasLogisticsPackage and not spot.packaged then
                        DrawMarker(21, spot.pos.x, spot.pos.y, spot.pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 47, 194, 31, 130, 0, 1, 2, 0, 0, 0, 0) -- GREEN
                    end
                end
            end
        end
    end)

    -- MAKE NOTIFICATION
    exports["soe-ui"]:PersistentAlert("start", jobRoles[roleID].roleName, "inform", jobRoles[roleID].roleNotification, 300)
end

-- **********************
--    Local Functions
-- **********************

local function closeMenus()
    jobMenuMain:ClearItems()
    SOEMenu:CloseAll()
    isCluckinBellMenuOpen = false
end

local function JobCompleted()
    -- UPDATE JOBS COMPLETED AND SHOW SUCCESS MESSAGE
    jobRoles[roleID].jobsCompleted = jobRoles[roleID].jobsCompleted + 1
    exports["soe-ui"]:SendAlert("success", jobRoles[roleID].roleSuccessMessage, 5000)         
    exports["soe-ui"]:SendAlert("success", string.format("You have completed %s task(s)", jobRoles[roleID].jobsCompleted), 5000)
    --print("jobsCompleted/rewardThreshold", jobRoles[roleID].jobsCompleted, jobRoles[roleID].rewardThreshold)
    
    -- IF WE REACH REWARD THRESHOLD
    if jobRoles[roleID].jobsCompleted == jobRoles[roleID].rewardThreshold then
        jobRoles[roleID].jobsCompleted = 0
        TriggerServerEvent("Jobs:Server:CluckinBell:WorkBonus", {status = true, roleID = roleID, currentRole = currentRole})
        --print("GIVE REWARDS")
    end
end

-- DOES STOCKTAKING TASK
local function DoStockTakingTask()
    --[[print("-----")
    print("roleID", roleID)
    print("DoStockTakingTask")]]

    local spot
    -- FIND CLOSEST STOCKTAKER TASK SPOT
    for _, spotData in pairs(jobRoles[roleID].tableName) do
        if #(GetEntityCoords(PlayerPedId()) - vector3(spotData.pos.x, spotData.pos.y, spotData.pos.z)) <= 1.0 then
            spot = spotData
            break
        end
    end

    -- IF WE ARE NEARBY A SPOT
    if spot then
        -- UPDATE LOCAL DATA WITH SERVER DATA
        jobRoles[roleID].tableName = exports["soe-nexus"]:TriggerServerCallback("Jobs:Server:CluckinBell:GetStockTakingData")

        if spot.occupied then
            exports["soe-ui"]:SendAlert("error", "Someone is already performing a task here!")
            return
        end
        --[[print("stockTaked", spot.stockTaked)
        print("nextAvailableTime", spot.nextAvailableTime)]]
        if spot.stockTaked then
            exports["soe-ui"]:SendAlert("error", "This area has been stock taked recently, come back later.")
            return
        end

        -- ONLY ONE PERSON CAN USE THE SPOT
        TriggerServerEvent("Jobs:Server:CluckinBell:SetVariable", roleID, spot, "occupied", true)

        doingTask = true
        SetEntityHeading(PlayerPedId(), spot.pos.w)
        exports["soe-emotes"]:StartEmote(jobRoles[roleID].emoteName)
        exports["soe-utils"]:Progress(
            {
                name = jobRoles[roleID].roleName,
                duration = math.random(jobRoles[roleID].workMinDuration, jobRoles[roleID].workMaxDuration),
                label = jobRoles[roleID].roleAction,
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = false
                },
            },
            function(cancelled)
                doingTask = false
                exports["soe-emotes"]:CancelEmote()
                if not cancelled then
                    -- UPDATE SPOT STOCK TAKED
                    TriggerServerEvent("Jobs:Server:CluckinBell:SetVariable", roleID, spot, "stockTaked", true)
                    
                    -- UPDATE JOBS COMPLETED AND SHOW SUCCESS MESSAGE
                    JobCompleted()
                end
                -- FREE THE SPOT ON END
                TriggerServerEvent("Jobs:Server:CluckinBell:SetVariable", roleID, spot, "occupied", false)

                -- UPDATE LOCAL DATA WITH SERVER DATA
                jobRoles[roleID].tableName = exports["soe-nexus"]:TriggerServerCallback("Jobs:Server:CluckinBell:GetStockTakingData")                
            end

        )
    end
end

-- DOES PROCESSING TASK
local function DoProcessingTask()
    local spot

    -- FIND CLOSEST PROCESSING TASK SPOT
    for index, spotData in pairs(jobRoles[roleID].tableName) do
        if #(GetEntityCoords(PlayerPedId()) - vector3(spotData.pos.x, spotData.pos.y, spotData.pos.z)) <= 1.0 then
            spot = spotData
            break
        end
    end

    -- IF WE ARE NEARBY A SPOT
    if spot then
        -- UPDATE LOCAL DATA WITH SERVER DATA
        jobRoles[roleID].tableName = exports["soe-nexus"]:TriggerServerCallback("Jobs:Server:CluckinBell:GetProcessingData")

        if spot.occupied then
            exports["soe-ui"]:SendAlert("error", "This staion is being used by someone else!")
            return
        end

        -- ONLY ONE PERSON CAN USE THE SPOT
        TriggerServerEvent("Jobs:Server:CluckinBell:SetVariable", roleID, spot, "occupied", true)

        doingTask = true
        SetEntityHeading(PlayerPedId(), spot.pos.w)
        exports["soe-emotes"]:StartEmote(jobRoles[roleID].emoteName)
        exports["soe-utils"]:Progress(
            {
                name = jobRoles[roleID].roleName,
                duration = math.random(jobRoles[roleID].workMinDuration, jobRoles[roleID].workMaxDuration),
                label = jobRoles[roleID].roleAction,
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = false
                },
            },
            function(cancelled)
                doingTask = false
                exports["soe-emotes"]:CancelEmote()
                if not cancelled then
                    -- UPDATE JOBS COMPLETED AND SHOW SUCCESS MESSAGE
                    JobCompleted()
                end
                -- FREE THE SPOT ON END
                TriggerServerEvent("Jobs:Server:CluckinBell:SetVariable", roleID, spot, "occupied", false)

                -- UPDATE LOCAL DATA WITH SERVER DATA
                jobRoles[roleID].tableName = exports["soe-nexus"]:TriggerServerCallback("Jobs:Server:CluckinBell:GetProcessingData")                
            end
        )
    end
end

-- DOES PROCESSING TASK
local function DoPackingTask()
    local spot

    -- FIND CLOSEST PROCESSING TASK SPOT
    for index, spotData in pairs(jobRoles[roleID].tableName) do
        if #(GetEntityCoords(PlayerPedId()) - vector3(spotData.pos.x, spotData.pos.y, spotData.pos.z)) <= 1.0 then
            spot = spotData
            break
        end
    end

    -- IF WE ARE NEARBY A SPOT
    if spot then
        -- UPDATE LOCAL DATA WITH SERVER DATA
        jobRoles[roleID].tableName = exports["soe-nexus"]:TriggerServerCallback("Jobs:Server:CluckinBell:GetLogisticsData")

        if spot.occupied then
            exports["soe-ui"]:SendAlert("error", "This staion is being used by someone else!")
            return
        end

        if (jobRoles[roleID].hasLogisticsPackage and not spot.dropOff) or (not jobRoles[roleID].hasLogisticsPackage and spot.dropOff) or spot.packaged then
            return
        end

        -- ONLY ONE PERSON CAN USE THE SPOT
        TriggerServerEvent("Jobs:Server:CluckinBell:SetVariable", roleID, spot, "occupied", true)

        doingTask = true
        SetEntityHeading(PlayerPedId(), spot.pos.w)
        exports["soe-emotes"]:StartEmote(jobRoles[roleID].emoteName)
        exports["soe-utils"]:Progress(
            {
                name = jobRoles[roleID].roleName,
                duration = math.random(jobRoles[roleID].workMinDuration, jobRoles[roleID].workMaxDuration),
                label = jobRoles[roleID].roleAction,
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = false
                },
            },
            function(cancelled)
                doingTask = false
                exports["soe-emotes"]:CancelEmote()
                if not cancelled then
                    if not jobRoles[roleID].hasLogisticsPackage and not jobRoles[roleID].dropOff then
                        jobRoles[roleID].hasLogisticsPackage = true
                        exports["soe-emotes"]:StartEmote("box")
                        
                        -- UPDATE SPOT PACKAGED
                        TriggerServerEvent("Jobs:Server:CluckinBell:SetVariable", roleID, spot, "packaged", true)                        
                    else
                        -- RESET HAS LOGISTICS PACKAGE FLAG
                        jobRoles[roleID].hasLogisticsPackage = false

                        -- UPDATE JOBS COMPLETED AND SHOW SUCCESS MESSAGE
                        JobCompleted()
                    end
                    -- FREE THE SPOT ON END
                    TriggerServerEvent("Jobs:Server:CluckinBell:SetVariable", roleID, spot, "occupied", false)

                    -- UPDATE LOCAL DATA WITH SERVER DATA
                    jobRoles[roleID].tableName = exports["soe-nexus"]:TriggerServerCallback("Jobs:Server:CluckinBell:GetLogisticsData")                
                end
            end
        )
    end
end

-- JOB INTERACTION MENU
local function JobInteractionMenu()
    jobMenuMain:ClearItems()
    jobMenuMain:SetTitle(jobTitle)
    local inspectButton = jobMenuMain:AddButton({ icon = '🔍', label = 'Job Info', select = function()
        --print("JOB INFO")
        TriggerEvent("Chat:Client:SendMessage", "center", jobTitle)
        TriggerEvent("Chat:Client:SendMessage", "linebreak")
        for index = 1, #jobRoles do
            TriggerEvent("Chat:Client:Message", jobRoles[index].roleIcon .." ".. jobRoles[index].roleName, jobRoles[index].roleDescription)
        end
        TriggerEvent("Chat:Client:SendMessage", "linebreak")
    end})

    local currentRoleButton = jobMenuMain:AddButton({ icon = '💼', label = 'Current Job', select = function()
        local jobString = string.format("You don't work here!", currentRole)
        if currentRole ~= jobRoles[0].roleName then
            jobString = string.format("Your current job is a %s.", string.lower(currentRole))
        end
        TriggerEvent("Chat:Client:Message", jobTitle, jobString, "taxi")
    end})

    local stockTakerButton = jobMenuMain:AddButton({ icon = '🖥️', label = 'Stock Taker', select = function()
        jobStart = false
        exports["soe-ui"]:PersistentAlert("end", jobRoles[roleID].roleName)
        roleID = 1
        currentRole = jobRoles[1].roleName
        TriggerEvent("Chat:Client:Message", jobTitle, jobRoles[roleID].roleStartText, "taxi")
        ClockinCluckinBell(true)
        closeMenus()
    end})

    local processorButton = jobMenuMain:AddButton({ icon = '🍗', label = 'Processor', select = function()
        jobStart = false
        exports["soe-ui"]:PersistentAlert("end", jobRoles[roleID].roleName)
        roleID = 2
        currentRole = jobRoles[2].roleName
        TriggerEvent("Chat:Client:Message", jobTitle, jobRoles[roleID].roleStartText, "taxi")
        ClockinCluckinBell(true)
        closeMenus()

    end})

    local logisticsWorkerButton = jobMenuMain:AddButton({ icon = '📦', label = 'Logistics Worker', select = function()
        jobStart = false
        exports["soe-ui"]:PersistentAlert("end", jobRoles[roleID].roleName)
        roleID = 3
        currentRole = jobRoles[3].roleName
        TriggerEvent("Chat:Client:Message", jobTitle, jobRoles[roleID].roleStartText, "taxi")
        ClockinCluckinBell(true)
        closeMenus()

    end})

    if currentRole ~= jobRoles[0].roleName then
        local quitButton = jobMenuMain:AddButton({ icon = '❌', label = 'Quit', select = function()
            -- END ROLE NOTIFICATION MESSAGES
            TriggerEvent("Chat:Client:Message", jobTitle, "One less worker to pay!", "taxi")
            exports["soe-ui"]:PersistentAlert("end", jobRoles[roleID].roleName)

            -- RESET VARIABLES
            roleID = 0
            jobStart = false
            currentRole = jobRoles[0].roleName
            jobRoles[3].hasLogisticsPackage = false
                        
            -- END JOB
            ClockinCluckinBell(false)
            closeMenus()
        end})
    end

    -- OPEN MENU AND FREEZE PLAYER/CONTROLS
    jobMenuMain:Open()
    isCluckinBellMenuOpen = true
    while isCluckinBellMenuOpen do
        Wait(5)
        DisableControlAction(0, 23)
        DisableControlAction(0, 75)
    end
end

-- ON MENU CLOSED, UNFREEZE AND RESET VEHICLE MODS TO WHAT THEY WERE BEFORE
jobMenuMain:On('close', function(menu)
    closeMenus()
end)

-- INTERACTION KEYPRESS
AddEventHandler("Utils:Client:InteractionKey", function()
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() or isCluckinBellMenuOpen then
        return
    end
    local playerCoords = GetEntityCoords(PlayerPedId())
    local distance = #(playerCoords - jobStartCoords)
    --print("DIST CHECK", distance)
    if distance <= 1.5 then
        --print("OPEN MENU")
        JobInteractionMenu()
    end

    if jobStart and not doingTask then
        if currentRole == jobRoles[1].roleName then
            --print("DO STOCK TAKING")
            DoStockTakingTask()
        elseif currentRole == jobRoles[2].roleName then
            --print("DO PROCESSING")
            DoProcessingTask()
        elseif currentRole == jobRoles[3].roleName then
            --print("DO PACKING")
            DoPackingTask()
        end
    end
end)

-- DEBUG
--[[RegisterCommand("cluck", function() 
    JobInteractionMenu()
    isCluckinBellMenuOpen = false
end)

RegisterCommand("log", function()
    jobRoles[roleID].hasLogisticsPackage = true
end)]]
