local action = nil
local isPoleDancing = false

-- ***********************
--     Local Functions
-- ***********************
-- MAIN POLE-DANCING ANIMATION FUNCTION
local function StartPoleDancing()
    isPoleDancing = true
    exports["soe-utils"]:LoadAnimDict("mini@strip_club@pole_dance@pole_dance3")
    exports["soe-ui"]:PersistentAlert("start", "poleDancePrompt", "inform", "[E] Cancel", 100)

    local ped = PlayerPedId()
    local scene = NetworkCreateSynchronisedScene(GetEntityCoords(ped), vector3(0.0, 0.0, 0.0), 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, scene, "mini@strip_club@pole_dance@pole_dance3", "pd_dance_03", 1.5, -4.0, 1, 1, 1148846080, 0)
    NetworkStartSynchronisedScene(scene)
end

-- ***********************
--    Global Functions
-- ***********************
-- CREATES ZONES WHERE POLES ARE TO DANCE
function CreatePoleDanceZones()
    exports["soe-utils"]:AddCircleZone("Pole-1", vector3(108.82, -1289.28, 29.25), 0.5, {name = "Pole-1", useZ = true})
    exports["soe-utils"]:AddCircleZone("Pole-2", vector3(102.21, -1290.16, 29.25), 0.5, {name = "Pole-2", useZ = true})
    exports["soe-utils"]:AddCircleZone("Pole-3", vector3(104.83, -1294.51, 29.25), 0.5, {name = "Pole-3", useZ = true})
end

-- ***********************
--         Events
-- ***********************
-- WHEN NEAR A COMPATIBLE POLE
AddEventHandler("Utils:Client:EnteredZone", function(name)
    if name:match("Pole") then
        action = {status = true}
        exports["soe-ui"]:ShowTooltip("fas fa-music", "[E] Pole Dance", "inform")
    end
end)

-- WHEN LEAVING A COMPATIBLE POLE
AddEventHandler("Utils:Client:ExitedZone", function(name)
    if name:match("Pole") then
        action = nil
        exports["soe-ui"]:HideTooltip()
    end
end)

-- INTERACTION KEY LISTENER
AddEventHandler("Utils:Client:InteractionKey", function()
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
        return
    end

    -- CANCEL POLE DANCING WHEN PRESSING E
    if isPoleDancing then
        isPoleDancing = false
        ClearPedTasksImmediately(PlayerPedId())
        exports["soe-ui"]:PersistentAlert("end", "poleDancePrompt")
        return
    end

    -- PROMPT POLE DANCE OPTION WHEN CLOSE
    if not action then return end
    if action.status then
        if not isPoleDancing then
            StartPoleDancing()
        end
    end
end)
