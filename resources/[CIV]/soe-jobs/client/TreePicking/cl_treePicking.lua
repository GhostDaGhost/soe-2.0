-- **********************
--    Local Functions
-- **********************
-- PICK TREE
local function PickTree()
    if treePicking.IsNearby then     
        -- CHECK IF PLAYER IS ALRADY PICKING
        if treePicking.IsPicking then
            exports["soe-ui"]:SendUniqueAlert("alreadyPicking", "error", "You are already picking this tree!", 5000)     
            return
        end

        -- CHECK IF TREE IS ALREADY PICKED
        if treePicking.PickableTrees[treePicking.NearestTreeIndex].picked then
            exports["soe-ui"]:SendUniqueAlert("barrenTree", "error", "There is nothing here to pick, try again later!", 5000)
            return
        end

        -- PICK TREE ONLY IF NOT ALREADY PICKING AND TREE NOT ALREADY PICKED
        treePicking.IsPicking = true
        
        -- UPDATE SERVER VARIABLES
        TriggerServerEvent("Jobs:Server:TreePicking:UpdateTree", treePicking.NearestTreeIndex, true)

        -- PROGRESS BAR FOR PICKING TREE
        exports["soe-utils"]:Progress(
            {
                name = "pickingTree",
                duration = 10000,
                label = ("Picking %s"):format(treePicking.PickableTrees[treePicking.NearestTreeIndex].name),
                useWhileDead = false,
                canCancel = false,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true
                },
                animation = {
                    animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                    anim = "machinic_loop_mechandplayer",
                    flags = 49
                }
            },
            function(cancelled)
                if not cancelled then
                    -- TRIGGER EVENT TO GIVE PLAYER ITEMS
                    TriggerServerEvent("Jobs:Server:TreePicking:PickTree", {status = true, treeIndex = treePicking.NearestTreeIndex})
                    -- ALLOW PICKING AGAIN
                    treePicking.IsPicking = false
                end
            end
        )    
    end
end

-- **********************
--        Events
-- **********************
-- UPDATE CLIENT TREE DATA WITH SERVER DATA
RegisterNetEvent("Jobs:Client:TreePicking:UpdateTreeList")
AddEventHandler("Jobs:Client:TreePicking:UpdateTreeList", function(NewPickableTrees)
    treePicking.PickableTrees = NewPickableTrees
end)

-- ON ZONE EXIT
AddEventHandler("Utils:Client:ExitedZone", function(name)
    if (name == "paleto_farm") then
        treePicking.isInZone = false
    end
end)

-- ON ZONE ENTRANCE
AddEventHandler("Utils:Client:EnteredZone", function(name)
    if (name == "paleto_farm") then
        treePicking.isInZone = true
    end
end)

-- INTERACTION KEYPRESS
AddEventHandler("Utils:Client:InteractionKey", function()
    if exports["soe-emergency"]:IsDead() or exports["soe-emergency"]:IsRestrained() then
        return
    end
    PickTree()
end)
