local loopIndex = 0
local hookedVeh = 0

-- GENERAL JOBS LOOP
CreateThread(function()
    Wait(3500)
    CreateZones()
    while true do
        Wait(5)
        local myJob = GetMyJob()
        local playerServerId = GetPlayerServerId(PlayerId())
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        -- EMOTE CHECK RUNTIME
        loopIndex = loopIndex + 1
        if (loopIndex % 100 == 0) then
            if myJob == "GOPOSTAL" then
                local hasPackage = GetHasGoPostalPackage()
                if hasPackage and not IsEntityPlayingAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 3) then
                    --print("WHERE'S YOUR BOX!")
                    exports["soe-emotes"]:StartEmote("box")
                else
                    --print("ALREADY CARRYING BOX")
                end
            elseif myJob == "GARBAGE" then
                if hasRubbish and not IsEntityPlayingAnim(PlayerPedId(), sanitationJobRoles[1].animDic, sanitationJobRoles[1].animLib, 3) then
                    --print("WHERE'S YOUR RUBBISH BAG!")
                    exports["soe-emotes"]:StartEmote("rubbish")
                end
            elseif myJob == "CLUCKINBELL" then
                if doingTask then
                    if currentRole == jobRoles[1].roleName and not IsEntityPlayingAnim(PlayerPedId(), jobRoles[1].animDic, jobRoles[1].animLib, 3) then
                        --print("WHERE'S YOUR TABLET!")
                        exports["soe-emotes"]:StartEmote(jobRoles[1].emoteName)
                    elseif currentRole == jobRoles[2].roleName and not IsEntityPlayingAnim(PlayerPedId(), jobRoles[2].animDic, jobRoles[2].animLib, 3) then
                        exports["soe-emotes"]:StartEmote(jobRoles[2].emoteName)
                    elseif currentRole == jobRoles[3].roleName and not IsEntityPlayingAnim(PlayerPedId(), jobRoles[3].animDic, jobRoles[3].animLib, 3) then
                        exports["soe-emotes"]:StartEmote(jobRoles[3].emoteName)
                    end
                elseif currentRole == jobRoles[3].roleName and not IsEntityPlayingAnim(PlayerPedId(), jobRoles[3].animDic2, jobRoles[3].animLib2, 3) and jobRoles[3].hasLogisticsPackage then
                    --print("WHERE'S YOUR BOX!")
                    exports["soe-emotes"]:StartEmote("box")
                end
            end
        end

        -- JOB RUNTIME
        if (loopIndex % 200 == 0) then
            if myJob == "SECURITY" then
                --print("UPDATE GOPOSTAL DESTINATION BLIPS")
                UpdateCheckpointStatus()
            elseif myJob == "CLUCKINBELL" then
                if isOnDuty and not jobStart then
                    JobStart()
                end
            elseif myJob == "GARBAGE" then
                if isOnSanitationDuty and not sanitationJobStart then
                    SanitationJobStart()
                end
            end

            -- MENU CHECK
            if isCluckinBellMenuOpen then
                -- DO DISTANCE CHECK ONLY IS MENU IS OPEN
                local playerCoords = GetEntityCoords(PlayerPedId())
                local distance = #(playerCoords - jobStartCoords)
                if distance > cluckinBellMenuRadius then
                    SOEMenu:CloseAll()
                end
            elseif isSanitationMenuOpen then
                -- DO DISTANCE CHECK ONLY IS MENU IS OPEN
                local playerCoords = GetEntityCoords(PlayerPedId())
                local distance = #(playerCoords - sanitationStartCoords[jobRoles[0].menuIndex].pos)
                if distance > sanitationMenuRadius then
                    SOEMenu:CloseAll()
                end
            elseif isCoCMenuOpen then
                -- DO DISTANCE CHECK ONLY IS MENU IS OPEN
                local playerCoords = GetEntityCoords(PlayerPedId())
                local distance = #(playerCoords - currentBusiness.coords)
                if distance > cocMenuRadius then
                    SOEMenu:CloseAll()
                end
            end
        end

        if (loopIndex % 1000 == 0) then
            if myJob == "GOPOSTAL" then
                --print("UPDATE GOPOSTAL DESTINATION BLIPS")
                UpdateGoPostalDestinationStatus()
            end
        end

        -- DO ABOUT EVERY 20 SECONDS
        if (loopIndex % 2000 == 0) then
            if myJob == "GOPOSTAL" then
                --print("UPDATE LOCAL GOPOSTAL DESTINATION STATUS TABLE")
                TriggerServerEvent("Jobs:Server:GoPostalGetDestinationStatus", playerServerId)
            elseif myJob == "GARBAGE" then
                --print("UPDATE LOCAL GARBAGE PAYTABLE FOR PLAYER")
                TriggerServerEvent("Jobs:Server:GetGarbagePayDataForCharID", playerServerId)
            end
        end

        -- DO ABOUT EVERY 60 SECONDS
        if (loopIndex % 6000 == 0) then
            if myJob == "CLUCKINBELL" then
                if currentRole == jobRoles[1].roleName then
                    --[[print("-----")
                    print("UPDATE STOCK TAKED")]]
                    -- UPDATE LOCAL DATA WITH SERVER DATA
                    jobRoles[roleID].tableName = exports["soe-nexus"]:TriggerServerCallback("Jobs:Server:CluckinBell:GetStockTakingData", roleID)
                elseif currentRole == jobRoles[3].roleName then
                    --[[print("-----")
                    print("UPDATE PACKAGED")]]
                    -- UPDATE LOCAL DATA WITH SERVER DATA
                    jobRoles[roleID].tableName = exports["soe-nexus"]:TriggerServerCallback("Jobs:Server:CluckinBell:GetLogisticsData", roleID)
                end
            end
        end

        if myJob == "CLUCKINBELL" then
            if currentRole == jobRoles[1].roleName or currentRole == jobRoles[3].roleName then
                -- ALLOW ENTERING/EXITING/RUNNING/JUMPING IF PLAYER IS BEING ATTACKED
                if HasPedBeenDamagedByWeapon(PlayerPedId(), 0, 2) or IsPedInMeleeCombat(PlayerPedId()) then
                    Wait(20000)
                end
                -- DISABLE ENTERING/EXITING/RUNNING/JUMPING
                DisableControlAction(0, 21)
                DisableControlAction(0, 22)
                DisableControlAction(0, 23)
                DisableControlAction(0, 75)
            end
        end

        if treePicking.isInZone then
            for index, treeData in pairs(treePicking.PickableTrees) do
                -- CHECKS TO SEE IF PLAYER IS NEAR A PICKABLE TREE
                if #(playerCoords - treeData.pos) <= 2.5 and treePicking.NearestTreeIndex == 0 then
                    treePicking.IsNearby = true
                    treePicking.NearestTreeIndex = index
                    break
                end
            end

            if treePicking.NearestTreeIndex > 0 then
                local treeData = treePicking.PickableTrees[treePicking.NearestTreeIndex]
                if #(playerCoords - treePicking.PickableTrees[treePicking.NearestTreeIndex].pos) <= 2.5 then
                    if not treePicking.InteractionShowing then
                        exports["soe-ui"]:ShowTooltip("fas fa-truck-loading", "[E] Pick " .. treePicking.PickableTrees[treePicking.NearestTreeIndex].name, "inform")
                        treePicking.InteractionShowing = true
                    end
                else
                    -- UPDATE VARIABLES
                    treePicking.IsNearby = false
                    treePicking.NearestTreeIndex = 0

                    -- REMOVE INTERACTION UI IF IT'S SHOWING
                    if treePicking.InteractionShowing then
                        exports["soe-ui"]:HideTooltip()
                        treePicking.InteractionShowing = false
                    end
                end
            end
        end

        -- HOOK TOW TRUCK CHECK
        if (loopIndex % 150 == 0) then
            local towVeh = GetVehiclePedIsIn(PlayerPedId(), false)
            if hookTowTrucks[GetEntityModel(towVeh)] then
                if hookedVeh == 0 and GetEntityAttachedToTowTruck(towVeh) ~= 0 then
                    -- SET HOOKEDVEH TO THE VEHICLE ATTACHED TO TOW TRUCK
                    hookedVeh = GetEntityAttachedToTowTruck(towVeh)
                elseif hookedVeh ~= 0 and GetEntityAttachedToTowTruck(towVeh) == 0 then
                    -- RUN IMPOUND SCRIPT IF TOW TRUCK HAD A VEHICLE BUT NOW DOES NOT
                    TriggerEvent("Jobs:Client:TowAttemptImpound", hookedVeh)
                    hookedVeh = 0
                elseif hookedVeh ~= 0 then
                    -- CHECKED ALL SEATS OF HOOKED VEH TO SEE IF ANY IS OCCUPIED, RELEASE HOOKED VEH IF ANY IS OCCUPIED
                    for seat = -1, 4 do
                        if GetPedInVehicleSeat(hookedVeh, seat) > 0 then
                            exports["soe-ui"]:SendAlert("error", "Vehicle must not be occupied!", 5000)

                            local playerIndex = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(hookedVeh, seat))
                            local playerID = GetPlayerServerId(playerIndex)
                            TriggerServerEvent("Jobs:Server:DetachHookedVeh", {status = true, playerID = playerID})

                            hookedVeh = 0
                            SetVehicleDisableTowing(towVeh, true)
                            DetachVehicleFromAnyTowTruck(hookedVeh)
                            DetachVehicleFromTowTruck(towVeh, hookedVeh)
                            SetVehicleDisableTowing(towVeh, false)
                            SetVehicleTowTruckArmPosition(towVeh, 1.0)
                            Wait(1000)
                            break
                        end
                    end
                end
            end
        end
    end
end)
