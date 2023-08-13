RegisterCommand(
    "pzcreate",
    function(source, args)
        local zoneType = args[1]
        if (zoneType == nil) then
            TriggerEvent("Chat:Client:Message", "[PolyZone]", "Please add zone type to create (poly, circle, box)!", "system")
            return
        end
        if (zoneType ~= "poly" and zoneType ~= "circle" and zoneType ~= "box") then
            TriggerEvent("Chat:Client:Message", "[PolyZone]", "Zone type must be one of: poly, circle, box", "system")
            return
        end
        local name = nil
        if #args >= 2 then
            name = args[2]
        else
            exports["soe-input"]:OpenInputDialogue("name", "Enter Name of Zone:", function(returnData)
                name = returnData
                if (returnData == nil or returnData == "") then
                    TriggerEvent("Chat:Client:Message", "[PolyZone]", "Please add a name!", "system")
                    return
                end
            end)
        end

        TriggerEvent("polyzone:pzcreate", zoneType, name, args)
    end
)
