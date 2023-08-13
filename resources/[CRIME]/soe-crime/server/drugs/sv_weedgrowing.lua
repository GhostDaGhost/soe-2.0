local maxPlants = 20
local weedplants = {}
local SyncWeedPlants = {}
local hashes = {
    ["seed"] = "bkr_prop_weed_plantpot_stack_01b",
    ["tiny"] = "bkr_prop_weed_01_small_01b",
    ["medium"] = "bkr_prop_weed_med_01b",
    ["large"] = "bkr_prop_weed_lrg_01b",
    ["harvest"] = "bkr_prop_weed_lrg_01b"
}

-- **********************
--    Local Functions
-- **********************
-- WHEN TRIGGERED, GROW ALL WEED PLANTS AFTER 30 MINUTES
local function GrowWeedPlants()
    local growAllPlants = exports["soe-nexus"]:PerformAPIRequest("/api/weed/modifyplant", "type=grow", true)
    if not growAllPlants.status then
        exports["soe-logging"]:ServerLog("All Weed Plants Failed To Grow", "THE GROWING API'S STATUS RETURNED FALSE")
        return
    end
    exports["soe-logging"]:ServerLog("All Weed Plants Grown", "ALL WEED PLANTS GROWN AFTER 30 MINUTES")

    local getWeedplants = exports["soe-nexus"]:PerformAPIRequest("/api/weed/getplants", "", true)
    if not getWeedplants.status then return end
    weedplants = getWeedplants.data
end

-- WHEN TRIGGERED, CHECK ITEM REQUIREMENTS PRIOR TO PLACING PLANT
local function CheckPlantPlacing(src)
    -- PERFORM ITEM CHECKS
    if (exports["soe-inventory"]:GetItemAmt(src, "weed_seed", "left") < 1) then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You need a seed to plant!", length = 7500})
        return
    end
    
    if (exports["soe-inventory"]:GetItemAmt(src, "empty_pot", "left") < 1) then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You need a empty pot to plant the seed!", length = 7500})
        return
    end

    if (exports["soe-inventory"]:GetItemAmt(src, "soil_bag", "left") < 1) then
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You need a soil bag to plant the seed in the pot!", length = 7500})
        return
    end

    -- GO TO CLIENT AND GRAB SOME DATA
    TriggerClientEvent("Crime:Client:PlantWeedPlant", src, {status = true})
end

-- RETURN FIRST VALUE WHERE X IS WITHIN RANGE OF PLAYER FOR WEED PLANTS TO GROW
local function GetFirstKey(SearchWeedPlants, x)
    x = x + 5000 -- add 5000 to make sure all x values are posative
    jump = math.floor((#SearchWeedPlants / 2) + 0.5) -- jump will half each time to narow the search
    position = #SearchWeedPlants - jump -- starting position will be in the middle of the array
    failsafe = #SearchWeedPlants -- this is a just incase the array fails the while true will break
    while true do
        distance = x - (json.decode(SearchWeedPlants[position].PlantPosition).x + 5000) -- get distance between weed plant and player
        if (distance <= 65 and distance >= -65) then                                     
            temp_pos = position - 1
            while true do
                if temp_pos == 0 then -- if position befor is 0 then return first item in array
                    return 1
                end

                newDistance = x - (json.decode(SearchWeedPlants[temp_pos].PlantPosition).x + 5000)      
                if ((x - (json.decode(SearchWeedPlants[temp_pos].PlantPosition).x + 5000)) > 65) then -- if position befor this in array is further than min distance then we are at the start
                    return temp_pos + 1
                else
                    temp_pos = temp_pos - 1
                end 
            end
            break
        elseif (distance <= -65) then -- if x is not within min range then the plant cannot be nere the player so we will have to 
            if (position == 1) then -- move the search to narrow down the starting position
                return -1
            end

            jump = math.floor((jump / 2) + 0.5)
            position = position - jump
            if(position <= 0) then
                position = 1
            end
        elseif(distance >= 65) then 
            if (position == #SearchWeedPlants)then
                return -1
            end

            jump = math.floor((jump / 2) + 0.5)
            position = position + jump
            if (position > #SearchWeedPlants) then
                position = #SearchWeedPlants
            end
        end

        if (failsafe <= 0 ) then -- this is where the loop will end if there any error which will make the array continue forever
            break
        end
        failsafe = failsafe - 1
    end
    return -1   
end

-- WHEN TRIGGERED, THIS WILL ENSURE THE SPAWNING OF PLANTS FOR NEARBY PLAYERS. USING SORTING AND SEARCH TO REDUCE ON CALLS AND CHECKS
-- New function will sort the weedPlants by x so that we can find all x nere the player and in a row and then break when past the range
local function EnsurePlantsSpawn()
    SyncWeedPlants = {} -- new array to sort synced plants if they are normal and have no property then they will be in 0
    -- else they will be in a subarray with the key of the property id so any player in that property
 
    for _, plants in pairs(weedplants) do -- will only load from that array cutting down on loops even more
        if plants.PropertyID == nil then
            if SyncWeedPlants[-1] == nil then
                SyncWeedPlants[-1] = {}
            end
            table.insert(SyncWeedPlants[-1], plants)   
        else
            if SyncWeedPlants[plants.PropertyID] == nil then
                SyncWeedPlants[plants.PropertyID] = {}
            end
            table.insert(SyncWeedPlants[plants.PropertyID], plants)   
        end
    end

    table.sort(SyncWeedPlants[-1], function(a, b)
        return json.decode(a.PlantPosition).x < json.decode(b.PlantPosition).x
    end) -- sort so all x values

    for src in pairs(exports["soe-uchuu"]:GetOnlinePlayerList()) do
        if not DoesEntityExist(GetPlayerPed(src)) then return end

        local Property = exports["soe-properties"]:GetPropertySourceIsIn(src)
        if (Property ~= nil) then -- the player is in a property
            if (SyncWeedPlants[Property] ~= nil) then
                for _, plant in pairs(SyncWeedPlants[Property]) do
                    local plantPos = json.decode(plant.PlantPosition)
                    if (plant.PlantStage == "seed") then
                        TriggerClientEvent("Crime:Client:SyncWeedPlants", src, {status = true, type = "grow", hash = "bkr_prop_weed_plantpot_stack_01b",
                            x = tonumber(plantPos.x), y = tonumber(plantPos.y), z = tonumber(plantPos.z), plantID = plant.PlantID, property = true
                        })
                    end

                    if (plant.PlantStage == "tiny") then
                        TriggerClientEvent("Crime:Client:SyncWeedPlants", src, {status = true, type = "remove", hash = "bkr_prop_weed_plantpot_stack_01b",
                            x = tonumber(plantPos.x), y = tonumber(plantPos.y), z = tonumber(plantPos.z), property = true
                        })
                        Wait(1500)
                        TriggerClientEvent("Crime:Client:SyncWeedPlants", src, {status = true, type = "grow", hash = "bkr_prop_weed_01_small_01b",
                            x = tonumber(plantPos.x), y = tonumber(plantPos.y), z = tonumber(plantPos.z), plantID = plant.PlantID, property = true
                        })
                    end

                    if (plant.PlantStage == "medium") then
                        TriggerClientEvent("Crime:Client:SyncWeedPlants", src, {status = true, type = "remove", hash = "bkr_prop_weed_01_small_01b",
                            x = tonumber(plantPos.x), y = tonumber(plantPos.y), z = tonumber(plantPos.z), property = true
                        })
                        Wait(1500)
                        TriggerClientEvent("Crime:Client:SyncWeedPlants", src, {status = true, type = "grow", hash = "bkr_prop_weed_med_01b",
                            x = tonumber(plantPos.x), y = tonumber(plantPos.y), z = tonumber(plantPos.z), plantID = plant.PlantID, property = true
                        })
                    end

                    if (plant.PlantStage == "large") then
                        TriggerClientEvent("Crime:Client:SyncWeedPlants", src, {status = true, type = "remove", hash = "bkr_prop_weed_med_01b",
                            x = tonumber(plantPos.x), y = tonumber(plantPos.y), z = tonumber(plantPos.z), property = true
                        })
                        Wait(1500)
                        TriggerClientEvent("Crime:Client:SyncWeedPlants", src, {status = true, type = "grow", hash = "bkr_prop_weed_lrg_01b",
                            x = tonumber(plantPos.x), y = tonumber(plantPos.y), z = tonumber(plantPos.z), plantID = plant.PlantID, property = true
                        })
                    end

                    if (plant.PlantStage == "harvest") then
                        TriggerClientEvent("Crime:Client:SyncWeedPlants", src, {status = true, type = "grow", hash = "bkr_prop_weed_lrg_01b",
                            x = tonumber(plantPos.x), y = tonumber(plantPos.y), z = tonumber(plantPos.z), plantID = plant.PlantID, property = true
                        })
                    end
                end
            end
        else -- the player is not in a property
            pos = GetFirstKey(SyncWeedPlants[-1], GetEntityCoords(GetPlayerPed(src)).x)
            while true do 
                -- if (pos == -1) then --check plant is within range
                --     break
                -- end
                if (pos <= 0 or pos > #SyncWeedPlants[-1]) then --check plant is within range
                    break
                elseif (SyncWeedPlants[-1][pos] == nil) then   --even if plant is within range. make sure it exists
                    break
                end
                plant = SyncWeedPlants[-1][pos]
                local plantPos = json.decode(plant.PlantPosition)

                if #(GetEntityCoords(GetPlayerPed(src)) - vector3(plantPos.x, plantPos.y, plantPos.z)) <= 65.0 then   
                    if (plant.PlantStage == "seed") then
                        TriggerClientEvent("Crime:Client:SyncWeedPlants", src, {status = true, type = "grow", hash = "bkr_prop_weed_plantpot_stack_01b",
                            x = tonumber(plantPos.x), y = tonumber(plantPos.y), z = tonumber(plantPos.z), plantID = plant.PlantID
                        })
                    end

                    if (plant.PlantStage == "tiny") then
                        TriggerClientEvent("Crime:Client:SyncWeedPlants", src, {status = true, type = "remove", hash = "bkr_prop_weed_plantpot_stack_01b",
                            x = tonumber(plantPos.x), y = tonumber(plantPos.y), z = tonumber(plantPos.z)
                        })
                        Wait(1500)
                        TriggerClientEvent("Crime:Client:SyncWeedPlants", src, {status = true, type = "grow", hash = "bkr_prop_weed_01_small_01b",
                            x = tonumber(plantPos.x), y = tonumber(plantPos.y), z = tonumber(plantPos.z), plantID = plant.PlantID
                        })
                    end

                    if (plant.PlantStage == "medium") then
                        TriggerClientEvent("Crime:Client:SyncWeedPlants", src, {status = true, type = "remove", hash = "bkr_prop_weed_01_small_01b",
                            x = tonumber(plantPos.x), y = tonumber(plantPos.y), z = tonumber(plantPos.z)
                        })
                        Wait(1500)
                        TriggerClientEvent("Crime:Client:SyncWeedPlants", src, {status = true, type = "grow", hash = "bkr_prop_weed_med_01b",
                            x = tonumber(plantPos.x), y = tonumber(plantPos.y), z = tonumber(plantPos.z), plantID = plant.PlantID
                        })
                    end

                    if (plant.PlantStage == "large") then
                        TriggerClientEvent("Crime:Client:SyncWeedPlants", src, {status = true, type = "remove", hash = "bkr_prop_weed_med_01b",
                            x = tonumber(plantPos.x), y = tonumber(plantPos.y), z = tonumber(plantPos.z)
                        })
                        Wait(1500)
                        TriggerClientEvent("Crime:Client:SyncWeedPlants", src, {status = true, type = "grow", hash = "bkr_prop_weed_lrg_01b",
                            x = tonumber(plantPos.x), y = tonumber(plantPos.y), z = tonumber(plantPos.z), plantID = plant.PlantID
                        })
                    end

                    if (plant.PlantStage == "harvest") then
                        TriggerClientEvent("Crime:Client:SyncWeedPlants", src, {status = true, type = "grow", hash = "bkr_prop_weed_lrg_01b",
                            x = tonumber(plantPos.x), y = tonumber(plantPos.y), z = tonumber(plantPos.z), plantID = plant.PlantID
                        })
                    end
                elseif ((((GetEntityCoords(GetPlayerPed(src)).x + 5000) - json.decode(SyncWeedPlants[-1][pos].PlantPosition).x + 5000)) < -65) or (((GetEntityCoords(GetPlayerPed(src)).x + 5000) - (json.decode(SyncWeedPlants[-1][pos].PlantPosition).x + 5000)) > 65) then
                    break                                              
                end

                pos = pos + 1
                if pos > #SyncWeedPlants[-1] then
                    break
                end
            end  
        end
    end
end

-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, INITIATE WEEDPLANTS RESOURCE
function InitWeedplants()
    local getWeedplants = exports["soe-nexus"]:PerformAPIRequest("/api/weed/getplants", "", true)
    if getWeedplants.status then
        weedplants = getWeedplants.data
        print("GRABBED WEEDPLANTS FROM DATABASE. :)")
    end
end

-- **********************
--       Commands
-- **********************
-- WHEN TRIGGERED, CHECK PLANT PLACING REQUIREMENTS
RegisterCommand("plant", function(source)
    local src = source
    CheckPlantPlacing(src)
end)

-- WHEN TRIGGERED, HARVEST THE NEAREST WEED PLANT
RegisterCommand("harvest", function(source)
    local src = source
    TriggerClientEvent("Crime:Client:HarvestNearestPlant", src, {status = true})
end)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, GROW ALL WEED PLANTS AFTER 30 MINUTES | THIS EVENT WAS MADE TO PREVENT ERRORS WHEN SYNCHRONOUS
AddEventHandler("Crime:Server:GrowWeedPlants", GrowWeedPlants)

-- WHEN TRIGGERED, PERFORM A WEED PLANT SPAWNING INSURANCE EVENT | THIS EVENT WAS MADE TO PREVENT ERRORS WHEN SYNCHRONOUS
AddEventHandler("Crime:Server:EnsurePlantsSpawn", EnsurePlantsSpawn)

-- WHEN TRIGGERED, DESPAWN ALL WEED PLANTS FROM PROPERTY
RegisterNetEvent("Crime:Server:ExitShellDespawn", function(houseID)
    local src = source
    if (houseID == nil) then return end

    if (SyncWeedPlants[houseID] ~= nil) then
        for _, plant in pairs(SyncWeedPlants[houseID]) do
            local plantPos = json.decode(plant.PlantPosition)
            TriggerClientEvent("Crime:Client:SyncWeedPlants", src, {status = true, type = "remove", hash = hashes[plant.PlantStage],
                x = tonumber(plantPos.x), y = tonumber(plantPos.y), z = tonumber(plantPos.z)
            })
        end
    end
end)

-- WHEN TRIGGERED, CALLBACK A STATUS TO CLIENT IF THE PLANT IS REMOVED FROM DB
AddEventHandler("Crime:Server:RemoveWeedPlant", function(cb, src, plantID, plantHash)
    local pos = GetEntityCoords(GetPlayerPed(src))
    TriggerClientEvent("Crime:Client:SyncWeedPlants", -1, {status = true, type = "remove", hash = plantHash,
        x = tonumber(pos.x), y = tonumber(pos.y), z = tonumber(pos.z)
    })

    -- REMOVE PLANT FROM THE DB
    local removeWeedPlant = exports["soe-nexus"]:PerformAPIRequest("/api/weed/modifyplant", ("type=%s&plantid=%s"):format("remove", plantID), true)
    if removeWeedPlant.status then
        cb(true)
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "You removed a plant", length = 9500})

        -- IF THIS IS A FULLY GROWN PLANT, GIVE WEED BAGGIES
        if (plantHash == "bkr_prop_weed_lrg_01b") then
            local amt = math.random(1, 4)
            local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID
            if exports["soe-inventory"]:AddItem(src, "char", charID, "weed_smallbag", amt, "{}") then
                TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = ("You got %sx baggies of weed from this plant!"):format(amt), length = 7500})
                exports["soe-logging"]:ServerLog("Weed Plant Harvest Loot", ("HAS EARNED %s %s FROM HARVESTING A PLANT"):format(amt, "weed_smallbag"), src)
            end

            if exports["soe-utils"]:GetRandomChance(35) then
                if exports["soe-inventory"]:AddItem(src, "char", charID, "weed_seed", 1, "{}") then
                    TriggerClientEvent("Notify:Client:SendAlert", src, {type = "warning", text = "You got a weed seed from this plant!", length = 7500})
                    exports["soe-logging"]:ServerLog("Weed Plant Harvest Loot", ("HAS EARNED %s %s FROM HARVESTING A PLANT"):format(1, "weed_seed"), src)
                end
            end
        end
        exports["soe-logging"]:ServerLog("Weed Plant Harvested", ("HAS HARVESTED A %s WITH PLANT ID %s"):format(plantHash, plantID), src)

        -- UPDATE GLOBAL WEEDPLANTS TABLE
        local getWeedplants = exports["soe-nexus"]:PerformAPIRequest("/api/weed/getplants", "", true)
        if getWeedplants.status then
            weedplants = getWeedplants.data
        end
    else
        cb(false)
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Something went wrong with removing this plant!", length = 7500})
    end
end)

-- WHEN TRIGGERED, CALLBACK A STATUS TO CLIENT IF THE PLANT IS REGISTERED TO DB
AddEventHandler("Crime:Server:RegisterNewPlant", function(cb, src, pos)
    local charID = exports["soe-uchuu"]:GetOnlinePlayerList()[src].CharID

    -- CHECK HOW MANY EXISTING PLANTS THE CHARACTER HAS TO LIMIT
    local getAmountOfPlants = exports["soe-nexus"]:PerformAPIRequest("/api/weed/modifyplant", ("type=%s&charid=%s"):format("getcount", charID), true)
    if getAmountOfPlants.status then
        if tonumber(getAmountOfPlants.data) >= maxPlants then
            cb({status = false})
            TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "You realize you already have too many plants growing", length = 7500})
            return
        end
    else
        cb({status = false})
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Something went wrong with placing this plant!", length = 7500})
        return
    end

    -- REGISTER NEW PLANT INTO THE DB
    local propertyID = exports["soe-properties"]:GetPropertySourceIsIn(src)
    local dataString = ("charid=%s&plantpos=%s&plantstage=%s"):format(charID, json.encode(pos), "seed")
    if (propertyID ~= nil) then
        dataString = ("charid=%s&plantpos=%s&plantstage=%s&propertyid=%s"):format(charID, json.encode(pos), "seed", propertyID)
    end

    local registerWeedPlant = exports["soe-nexus"]:PerformAPIRequest("/api/weed/addplant", dataString, true)
    if registerWeedPlant.status then
        -- REMOVE WEED SUPPLIES WHEN USED
        exports["soe-inventory"]:RemoveItem(src, 1, "weed_seed")
        exports["soe-inventory"]:RemoveItem(src, 1, "empty_pot")
        exports["soe-inventory"]:RemoveItem(src, 1, "soil_bag")

        cb({status = true, plantID = tonumber(registerWeedPlant.data.PlantID)})
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "success", text = "You placed a pot down and planted the seed!", length = 9500})
        exports["soe-logging"]:ServerLog("Weed Plant Planted", ("HAS PLANTED A WEEDPLANT AT %s, WITH PLANT ID %s"):format(pos, registerWeedPlant.data.PlantID), src)

        -- UPDATE GLOBAL WEEDPLANTS TABLE
        local getWeedplants = exports["soe-nexus"]:PerformAPIRequest("/api/weed/getplants", "", true)
        if getWeedplants.status then
            weedplants = getWeedplants.data
        end
    else
        cb({status = false})
        TriggerClientEvent("Notify:Client:SendAlert", src, {type = "error", text = "Something went wrong with placing this plant!", length = 7500})
    end
end)
