local scenes = {} -- LIST OF ALL SCENES
local secretPassword = "pandaPopcorn" -- SECRET PASSWORD TO USE THE HTTP HANDLER

-- ***********************
--      HTTP Handlers
-- ***********************
-- WHEN TRIGGERED, DO THE FOLLOWING
SetHttpHandler(function(req, res)
    if (req.path == "/reset/" .. secretPassword) then -- MANUALLY CLEAR ALL SCENES (NOT RECOMMENDED)
        scenes = {}
        TriggerClientEvent("Scenes:Client:RequestScenes", -1, scenes)

        res.send("ALL SCENES DELETED BUT NOT FROM THE DATABASE.")
        exports["soe-logging"]:ServerLog("Scenes Resetted", "ALL SCENES DELETED THROUGH HTTP HANDLER")
    elseif (req.path == "/get/" .. secretPassword) then -- MANUALLY GET SCENES FROM DATABASE
        GetScenesFromDB()
        TriggerClientEvent("Scenes:Client:RequestScenes", -1, scenes)

        res.send("ALL SCENES RETRIEVED FROM DATABASE.")
        exports["soe-logging"]:ServerLog("Scenes Retrieved From Database", "ALL SCENES RETRIEVED FROM DATABASE THROUGH HTTP HANDLER")
    end
end)

-- ***********************
--     Global Functions
-- ***********************
-- WHEN TRIGGERED, GET ALL SCENES FROM THE DATABASE
function GetScenesFromDB()
    local getScenes = exports["soe-nexus"]:PerformAPIRequest("/api/scene/get", "", true)
    if getScenes["status"] then
        scenes = getScenes["data"] or {}
        print("SCENES RETRIEVED FROM THE DATABASE SUCCESSFULLY. :)")
    end
end

-- **********************
--        Commands
-- **********************
-- WHEN TRIGGERED, DO SOME SCENE PLACEMENTS
RegisterCommand("scene", function(source)
    local src = source
    TriggerClientEvent("Scenes:Client:MakeScene", src)
end)

-- WHEN TRIGGERED, REMOVE A SCENE BY THE UNIQUE ID
RegisterCommand("removescene", function(source, args)
    local src = source
    if (args[1] == nil) then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Please specify a scene ID", length = 6500})
        return
    end

    local sceneID = tonumber(args[1])
    local removeScene = exports["soe-nexus"]:PerformAPIRequest("/api/scene/manage", ("type=%s&sceneid=%s"):format("remove", sceneID), true)
    if removeScene["status"] then
        exports["soe-logging"]:ServerLog("Scene Removed", "HAS REMOVED A SCENE | ID: " .. sceneID, src) -- LOG SCENE REMOVAL

        -- REMOVE SCENE
        if scenes[sceneID] then
            scenes[sceneID] = nil
        end
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "Scene #" .. sceneID .. " removed!", length = 6500})
        TriggerClientEvent("Scenes:Client:RequestScenes", -1, scenes)
    else
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Scene ID not found", length = 6500})
    end
end)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, GIVE CLIENT THE SERVER LIST OF SCENES
AddEventHandler("Scenes:Server:RequestScenes", function(cb, src)
    cb(scenes)
end)

-- WHEN TRIGGERED, CREATE A SCENE WITH SENT DATA
AddEventHandler("Scenes:Server:MakeScene", function(cb, src, pos, text, color, distance)
    cb(true)

    local pos = {["x"] = pos["x"], ["y"] = pos["y"], ["z"] = pos["z"]}
    local dataString = ("type=%s&color=%s&dist=%s&text=%s&coords=%s"):format("add", color, distance, text, json.encode(pos))

    local addScene = exports["soe-nexus"]:PerformAPIRequest("/api/scene/manage", dataString, true)
    if addScene["status"] then
        local sceneID = addScene["data"]
        scenes[sceneID] = {["SceneID"] = sceneID, ["SceneCoords"] = json.encode(pos), ["SceneText"] = text, ["SceneColor"] = color, ["SceneDist"] = distance}

        TriggerClientEvent("Scenes:Client:RequestScenes", -1, scenes)
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "Scene Created!", length = 5000})

        -- LOG SCENE CREATION
        local msg = ("HAS CREATED A SCENE | ID: %s | TEXT: %s | COLOR: %s | COORDS: %s | DISTANCE: %s"):format(sceneID, text, color, pos, distance)
        exports["soe-logging"]:ServerLog("Scene Created", msg, src)
    end
end)

-- **********************
--        Threads
-- **********************
-- WHEN TRIGGERED, GET ALL SCENES FROM THE DATABASE
CreateThread(function()
    Wait(3500)
    GetScenesFromDB()
end)
