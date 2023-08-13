local nearbyScenes = {}
local sleep, loopIndex = 550, 0

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, DRAW SCENE TEXT
local function DrawSceneText(scene, text)
    local pos = json.decode(scene["SceneCoords"]) or {}
    local onScreen, x, y = World3dToScreen2d(pos["x"], pos["y"], pos["z"])
    if onScreen then
        local colorData = validSceneColors[scene["SceneColor"]]
        SetTextColour(colorData["r"], colorData["g"], colorData["b"], colorData["a"])

        SetTextScale(0.23, 0.23)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(("[%s] %s"):format(scene["SceneID"], scene["SceneText"]))
        DrawText(x, y)
    end
end

-- **********************
--         Loops
-- **********************
-- MAIN SCENES RUNTIME
CreateThread(function()
    Wait(3500)
    scenes = exports["soe-nexus"]:TriggerServerCallback("Scenes:Server:RequestScenes")

    while true do
        Wait(sleep)
        loopIndex = loopIndex + 1
        if (loopIndex % 10 == 0) then
            nearbyScenes = {}
            local pos = GetEntityCoords(PlayerPedId())
            for _, scene in pairs(scenes) do
                local scenePos = json.decode(scene["SceneCoords"]) or {}
                local _scenePos = vector3(scenePos["x"], scenePos["y"], scenePos["z"])
                if #(pos - _scenePos) <= scene["SceneDist"] then
                    nearbyScenes[#nearbyScenes + 1] = scene
                end
            end
            loopIndex = 0
        end

        if #nearbyScenes >= 1 then
            sleep = 5
            for _, scene in pairs(nearbyScenes) do
                DrawSceneText(scene)
            end
        else
            sleep = 550
        end
    end
end)
