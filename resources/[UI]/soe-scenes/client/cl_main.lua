local spawnGhostBall = false
local ghostBall, ghostBallCoords
local ballReference = `w_ex_snowball`

scenes = {}

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, REMOVE GHOST BALL AS PLACEMENT REFERENCE
local function RemoveGhostBall(_ghost)
    local ghost = _ghost
    SetEntityAsMissionEntity(ghost, true, true)
    DeleteObject(ghost)
    DeleteEntity(ghost)
    ghostBall = nil
end

-- WHEN TRIGGERED, CREATE GHOST BALL AS PLACEMENT REFERENCE
local function CreateGhostBall(pos)
    exports["soe-utils"]:LoadModel(ballReference, 15)
    local ballProp = CreateObject(ballReference, pos, false, false, false)
    SetModelAsNoLongerNeeded(ballReference)

    SetEntityCollision(ballProp, false, false)
    SetEntityAsMissionEntity(ballProp, true, true)
    SetEntityAlpha(ballProp, 55, 1)
    return ballProp
end

-- **********************
--     NUI Callbacks
-- **********************
-- WHEN TRIGGERED, SHUT NUI FOCUS OFF
RegisterNUICallback("Scenes.CloseUI", function()
    SetNuiFocus(false, false)
end)

-- WHEN TRIGGERED, DO SANITY CHECKS AND THEN MAKE SERVER CREATE SCENE
RegisterNUICallback("Scenes.CreateScene", function(data)
    local chosenColor = data["color"] -- VALID COLOR CHECKS
    if not validSceneColors[chosenColor] then
        exports["soe-ui"]:SendAlert("error", "Invalid color inputted!", 5000)
        return
    end

    local chosenDistance = tonumber(data["distance"]) -- DISTANCE CHECKS
    if (chosenDistance ~= nil) then
        if (chosenDistance <= 0 or chosenDistance > 10) then
            exports["soe-ui"]:SendAlert("error", "Invalid distance inputted!", 5000)
            return
        end
    end

    -- PREPARES SCENE FOR TRAVEL TO SERVER :)
    exports["soe-nexus"]:TriggerServerCallback("Scenes:Server:MakeScene", ghostBallCoords, data["text"], chosenColor or "White", chosenDistance or 5)
    ghostBallCoords = nil
end)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, RESET ALL NUI INSTANCES
AddEventHandler("UI:Client:ResetNUI", function()
    SendNUIMessage({type = "Scenes.ResetUI"})
end)

-- WHEN TRIGGERED, UPDATE LOCAL SCENES TABLE
RegisterNetEvent("Scenes:Client:RequestScenes", function(_scenes)
    scenes = _scenes
end)

-- WHEN TRIGGERED, DO SOME SCENE PLACEMENTS
RegisterNetEvent("Scenes:Client:MakeScene", function()
    if (ghostBall ~= nil) then
        DeleteEntity(ghostBall)
    end
    Wait(100)

    local ray = exports["soe-utils"]:GhostRaycast(20)
    ghostBall = CreateGhostBall(ray)
    spawnGhostBall = true

    exports["soe-ui"]:SendAlert("warning", "Choose a place to put your scene!", 1500)
    while spawnGhostBall do
        Wait(5)
        ray = exports["soe-utils"]:GhostRaycast(20)
        DisableControlAction(0, 44)
        DisableControlAction(0, 51)
        DisableControlAction(0, 24)
        DisableControlAction(0, 200)
        DisableControlAction(0, 201)

        if (ghostBall ~= nil) then
            SetEntityCoords(ghostBall, ray)
            SetEntityHeading(ghostBall, vehHeading)

            -- CANCEL SELECTION KEY - ESC
            if IsDisabledControlPressed(0, 200) then
                RemoveGhostBall(ghostBall)
                spawnGhostBall = false
                if (ghostBall ~= nil) then
                    DeleteEntity(ghostBall)
                end
                break
            end

            -- SET LOCATION KEY - ENTER
            if IsDisabledControlPressed(0, 201) then
                RemoveGhostBall(ghostBall)
                spawnGhostBall = false

                -- SETTING SCENE LOCATION
                local ray = exports["soe-utils"]:GhostRaycast(20)
                ghostBallCoords = ray

                SetNuiFocus(true, true)
                SetCursorLocation(0.5, 0.5)
                SendNUIMessage({type = "Scenes.ShowUI"})
                if (ghostBall ~= nil) then
                    DeleteEntity(ghostBall)
                end
                break
            end
        else
            spawnGhostBall = false
        end
    end
end)
