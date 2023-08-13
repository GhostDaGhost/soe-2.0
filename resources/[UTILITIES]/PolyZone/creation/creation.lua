lastCreatedZoneType = nil
lastCreatedZone = nil
createdZoneType = nil
createdZone = nil
drawZone = false

RegisterNetEvent("polyzone:pzcreate")
AddEventHandler(
    "polyzone:pzcreate",
    function(zoneType, name, args)
        if createdZone ~= nil then
            TriggerEvent("Chat:Client:Message", "[PolyZone]", "A shape is already being created!", "system")
            return
        end

        if zoneType == "poly" then
            polyStart(name)
        elseif zoneType == "circle" then
            local radius = nil
            if #args >= 3 then
                radius = tonumber(args[3])
            else
                exports["soe-input"]:OpenInputDialogue("number", "Enter Radius:", function(returnData)
                    radius = tonumber(returnData)
                    if (radius == nil) then
                        TriggerEvent("Chat:Client:Message", "[PolyZone]", "CircleZone requires a radius (must be a number)!", "system")
                        return
                    end
                end)
            end
            circleStart(name, radius)
        elseif zoneType == "box" then
            local length = nil
            if #args >= 3 then
                length = tonumber(args[3])
            else
                exports["soe-input"]:OpenInputDialogue("name", "Enter Length:", function(returnData)
                    length = tonumber(returnData)
                    if (length == nil or length < 0.0) then
                        TriggerEvent("Chat:Client:Message", "[PolyZone]", "BoxZone requires a length (must be a positive number)!", "system")
                        return
                    end
                end)
            end

            local width = nil
            if #args >= 4 then
                width = tonumber(args[4])
            else
                exports["soe-input"]:OpenInputDialogue("name", "Enter Width:", function(returnData)
                    width = tonumber(returnData)
                    if (width == nil or width < 0.0) then
                        TriggerEvent("Chat:Client:Message", "[PolyZone]", "BoxZone requires a width (must be a positive number)!", "system")
                        return
                    end
                end)
            end
            boxStart(name, 0, length, width)
        else
            return
        end
        createdZoneType = zoneType
        drawZone = true
        drawThread()
    end
)

RegisterNetEvent("polyzone:pzfinish")
AddEventHandler(
    "polyzone:pzfinish",
    function()
        if createdZone == nil then
            return
        end

        if createdZoneType == "poly" then
            polyFinish()
        elseif createdZoneType == "circle" then
            circleFinish()
        elseif createdZoneType == "box" then
            boxFinish()
        end

        TriggerEvent("Chat:Client:Message", "[PolyZone]", "Check your server root folder for polyzone_created_zones.txt to get the zone!", "standard")

        lastCreatedZoneType = createdZoneType
        lastCreatedZone = createdZone

        drawZone = false
        createdZone = nil
        createdZoneType = nil
    end
)

RegisterNetEvent("polyzone:pzlast")
AddEventHandler(
    "polyzone:pzlast",
    function()
        if createdZone ~= nil or lastCreatedZone == nil then
            return
        end
        if lastCreatedZoneType == "poly" then
            TriggerEvent("Chat:Client:Message", "[PolyZone]", "The command pzlast only supports BoxZone and CircleZone for now", "system")
        end

        local name
        exports["soe-input"]:OpenInputDialogue("name", "Enter name (or leave empty to reuse last zone's name):", function(returnData)
            name = returnData
            if (name == nil) then
                return
            elseif (name == "") then
                name = lastCreatedZone.name
            end
        end)

        createdZoneType = lastCreatedZoneType
        if createdZoneType == "box" then
            local minHeight, maxHeight
            if lastCreatedZone.minZ then
                minHeight = lastCreatedZone.center.z - lastCreatedZone.minZ
            end
            if lastCreatedZone.maxZ then
                maxHeight = lastCreatedZone.maxZ - lastCreatedZone.center.z
            end
            boxStart(
                name,
                lastCreatedZone.offsetRot,
                lastCreatedZone.length,
                lastCreatedZone.width,
                minHeight,
                maxHeight
            )
        elseif createdZoneType == "circle" then
            circleStart(name, lastCreatedZone.radius, lastCreatedZone.useZ)
        end
        drawZone = true
        drawThread()
    end
)

RegisterNetEvent("polyzone:pzcancel")
AddEventHandler(
    "polyzone:pzcancel",
    function()
        if createdZone == nil then
            return
        end

        TriggerEvent("Chat:Client:Message", "[PolyZone]", "Zone creation canceled!", "system")

        drawZone = false
        createdZone = nil
        createdZoneType = nil
    end
)

-- Drawing
function drawThread()
    Citizen.CreateThread(
        function()
            while drawZone do
                if createdZone then
                    createdZone:draw()
                end
                Wait(0)
            end
        end
    )
end
