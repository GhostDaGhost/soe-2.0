local UX = {}
local needsToResetSoon = false

-- VEHICLE RELATED
local cruise, entering = 0, false

-- SPOTLIGHTS
local thread, spotlightNum = false, 0

engine = false
sentAlert = false
myVeh, inVeh, seatbelt = nil, false, false

-- DECORATORS
DecorRegister("hasKillswitchFitted", 2)
DecorRegister("hasKillswitchTriggered", 2)

-- KEY MAPPINGS
RegisterKeyMapping("cruise", "[Veh] Cruise Control", "keyboard", "Y")
--[[RegisterKeyMapping("inccruise", "[Veh] Increase Cruise Speed", "keyboard", "PLUS")
RegisterKeyMapping("deccruise", "[Veh] Decrease Cruise Speed", "keyboard", "MINUS")]]

RegisterKeyMapping("tackle", "Tackle Player", "keyboard", "E")
RegisterKeyMapping("belt", "Toggle Seatbelt", "keyboard", "F1")
RegisterKeyMapping("engine", "Toggle Engine", "keyboard", "F6")
RegisterKeyMapping("readplate", "Read License Plate", "keyboard", "M")

-- RESET SHOTS FIRED SENT ALERT VARIABLE
local function ResetSentShotsFiredAlert()
    SetTimeout(8000, function() sentAlert = false end)
end

-- MAINTAINS A SET SPEED WHILE CRUISE CONTROL IS ON
local function CruiseImpulse(veh, cruisingSpeed)
    local speed = GetEntitySpeed(veh)
    if (speed < cruisingSpeed) then
        ApplyForceToEntityCenterOfMass(veh, 0, 0.0, 15.0, 0.0, true, true, true, true)
    end
end

-- WHEN TRIGGERED, CHECK GIVEN MODEL IF IT IS A SEAPLANE
local function IsThisModelASeaplane(hash)
    for seaplane in pairs(seaplanes) do
        if (GetHashKey(seaplane) == hash) then
            return true
        end
    end
    return false
end

-- WHEN TRIGGERED, DO DOG WARPOUT
local function DoDogWarpout(ped)
    SetVehicleDoorShut(myVeh, 2, true)
    SetEntityCollision(ped, false, true)
    ClearPedTasks(ped)
    ClearPedTasksImmediately(ped)
    TaskLeaveVehicle(ped, myVeh, 16)

    local offset = GetOffsetFromEntityInWorldCoords(myVeh, -1.75, 0.0, -0.5)
    SetEntityCoords(ped, offset.x, offset.y, offset.z, true, true, true, true)
    SetEntityCollision(ped, true, true)
end

-- WHEN TRIGGERED, CHANGE CRUISING SPEED BY INCREMENT OR DECREMENT
--[[local function ChangeCruisingSpeed(type)
    if (cruise <= 0) then
        print("already zero.")
        return
    end

    print(cruise)
    if (type == "Increment") then
        if (cruise > 44) then
            exports["soe-ui"]:SendAlert("error", "Cannot go that high!", 5000)
        end
        cruise = cruise + 1
    elseif (type == "Decrement") then
        if (cruise <= 0) then
            cruise = 0
            exports["soe-ui"]:SendAlert("error", "Cannot go that low!", 5000)
        end
        cruise = cruise - 1
    end

    print(cruise)
    local mph = math.floor(cruise * 2.23694 + 0.5)
    exports["soe-ui"]:SendAlert("inform", ("Cruise Control %sed To: %s MPH"):format(type, mph), 2500)
end]]

-- WHEN TRIGGERED, ACTIVATE LAST VEHICLE FITTED WITH A KILLSWITCH
local function ActivateKillSwitch(data)
    if not data.status then return end
    if not UX.currentBaitCar then
        exports["soe-ui"]:SendAlert("error", "Set up a killswitch first!", 5000)
        return
    end

    -- SPECIAL EFFECTS FOR THE MURSION
    local plate = GetVehicleNumberPlateText(UX.currentBaitCar)
    exports["soe-emotes"]:StartEmote("phoneplay")
    exports["soe-ui"]:SendAlert("warning", "Activating killswitch of vehicle with plate " .. plate, 5000)
    for i = 1, 5 do
        Wait(850)
        PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
    end

    exports["soe-emotes"]:CancelEmote()
    PlaySound(-1, "Click_Fail", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
    TriggerServerEvent("UX:Server:SyncVehicleKillswitch", {status = true, type = "Kill", veh = VehToNet(UX.currentBaitCar), plate = plate})
    UX.currentBaitCar = nil
end

-- WHEN TRIGGERED, DO ANCHOR TASKS
local function DoAnchor()
    if not myVeh then
        exports["soe-ui"]:SendAlert("error", "No vehicle found to anchor", 5000)
        return
    end

    local isDriver = (GetPedInVehicleSeat(myVeh, -1) == PlayerPedId())
    if not isDriver then
        exports["soe-ui"]:SendAlert("error", "You need to be the driver", 5000)
        return
    end

    local model = GetEntityModel(myVeh)
    if IsThisModelABoat(model) or IsThisModelAJetski(model) or IsThisModelASeaplane(model) or IsThisModelAnAmphibiousCar(model) or IsThisModelAnAmphibiousQuadbike(model) then
        if (GetEntitySpeed(myVeh) > 3.0) then
            exports["soe-ui"]:SendAlert("error", "Slow down to 5 knots!", 5000)
            return
        end

        exports["soe-utils"]:GetEntityControl(myVeh)
        if IsBoatAnchoredAndFrozen(myVeh) then
            TriggerServerEvent("Utils:Server:SyncBoatAnchor", {status = true, entity = VehToNet(myVeh), anchor = false})
        elseif not IsBoatAnchoredAndFrozen(myVeh) and GetEntitySpeed(myVeh) < 20 then
            TriggerServerEvent("Utils:Server:SyncBoatAnchor", {status = true, entity = VehToNet(myVeh), anchor = true})
        else
            exports["soe-ui"]:SendAlert("error", "You could not anchor the boat", 5000)
        end
    end
end

-- WHEN TRIGGERED, DO ENGINE KILLER EQUIPPING TASKS
local function UseEngineKiller()
    if UX.installingEngineKiller then return end

    -- VEHICLE SAFETY CHECKS
    if not myVeh then
        exports["soe-ui"]:SendAlert("error", "No vehicle found to sabotage", 5000)
        return
    end

    local ped = PlayerPedId()
    local isDriver = (GetPedInVehicleSeat(myVeh, -1) == ped)
    if not isDriver then
        exports["soe-ui"]:SendAlert("error", "You need to be the driver", 5000)
        return
    end

    -- DUPLICATE KILLSWITCH CHECK
    if DecorGetBool(myVeh, "hasKillswitchFitted") then
        exports["soe-ui"]:SendAlert("error", "You notice something is already installed", 5000)
        return
    end

    UX.installingEngineKiller = true
    exports["soe-utils"]:LoadAnimDict("veh@handler@base", 15)
    TaskPlayAnim(ped, "veh@handler@base", "hotwire", 2.0, 2.0, -1, 49, 0, 0, 0, 0)
    exports["soe-utils"]:Progress(
        {
            name = "installingEngineKiller",
            duration = 6500,
            label = "Installing Killswitch",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
            },
        },
        function(cancelled)
            ClearPedTasks(ped)
            UX.installingEngineKiller = false
            if not cancelled then
                UX.currentBaitCar = myVeh
                DecorSetBool(myVeh, "hasKillswitchFitted", true)

                local plate = GetVehicleNumberPlateText(myVeh)
                TriggerServerEvent("UX:Server:SyncVehicleKillswitch", {status = true, type = "Update", plate = plate})
            end
        end
    )
end

-- VEHICLE DOOR TOGGLE WITH INDEX PROVIDED
local function SelectDoorIndex(doorIndex)
    if (doorIndex ~= nil) then
        if (doorIndex == "frontleft" or doorIndex == "fl") then
            door = 0
        elseif (doorIndex == "frontright" or doorIndex == "fr") then
            door = 1
        elseif (doorIndex == "backleft" or doorIndex == "bl") then
            door = 2
        elseif (doorIndex == "backright" or doorIndex == "br") then
            door = 3
        elseif (doorIndex == "trunk2") then
            door = 6
        elseif (doorIndex == "hood" or doorIndex == "h") then
            door = 4
        elseif (doorIndex == "trunk" or doorIndex == "t") then
            door = 5
        else
            door = nil
        end

        local ped = PlayerPedId()
        if IsPedSittingInAnyVehicle(ped) then
            local isDriver = (GetPedInVehicleSeat(myVeh, -1) == ped)
            if isDriver then
                ToggleVehicleDoor(myVeh, door)
            end
        else
            local veh = exports["soe-utils"]:GetVehInFrontOfPlayer(5.0)
            if DoesEntityExist(veh) then
                if not IsVehiclePreviouslyOwnedByPlayer(veh) then
                    exports["soe-ui"]:SendAlert("error", "This vehicle is locked!", 5000)
                    return
                end
                ToggleVehicleDoor(veh, door)
            end
        end
    end
end

-- TOGGLES CRUISE CONTROL
local function CruiseControl()
    local class = GetVehicleClass(myVeh)

    -- IF IT IS AN EMERGENCY VEHICLE AND HAS LIGHTS ON
    if (class == 18) and IsVehicleSirenOn(myVeh) then
        return
    end

    -- IF IT IS A CYCLE/AIRCRAFT
    if class == 13 or class == 14 or class == 15 then
        return
    end

    -- IF NOT A DRIVER
    local ped = PlayerPedId()
    if not GetPedInVehicleSeat(myVeh, -1) == ped then
        return
    end

    if (cruise == 0) and IsPedInAnyVehicle(ped, true) then
        if (GetEntitySpeedVector(myVeh, true)["y"] > 0) then
            cruise = GetEntitySpeed(myVeh)
            local cruiseMph = math.floor(cruise * 2.23694 + 0.5)
            exports["soe-ui"]:SendAlert("inform", ("Cruise Control Set To: %s MPH"):format(cruiseMph), 2500)

            while (cruise > 0) do
                -- IF ENGINE SHUTS OFF, DISABLE CC SINCE IT IS AN EXPLOIT
                if not GetIsVehicleEngineRunning(myVeh) then
                    cruise = 0
                    break
                end

                -- IF NO COMPLICATIONS ARISE DURING OR AT THE START OF CRUISE CONTROL
                if
                    IsVehicleOnAllWheels(myVeh) and GetEntitySpeed(myVeh) > (cruise - 2.0) and
                        (GetEntityPitch(myVeh) <= 10.0 or
                            (GetEntityPitch(myVeh) <= 30.0 and cruiseMph <= 20 and
                                (GetVehicleCurrentGear(myVeh) or GetVehicleCurrentGear(myVeh)) and
                                class == 20))
                 then
                    CruiseImpulse(myVeh, cruise)
                else
                    cruise = 0
                    exports["soe-ui"]:SendAlert("inform", "Cruise Control Disabled", 2500)
                    break
                end

                -- 'SPACEBAR' AND 'S' KEYS CANCEL CRUISE CONTROL OUT
                if IsControlPressed(1, 76) or IsControlPressed(1, 72) then
                    cruise = 0
                    exports["soe-ui"]:SendAlert("inform", "Cruise Control Disabled", 2500)
                end

                -- IF AT OR OVER 100 MPH
                if (cruise > 44) then
                    cruise = 0
                    exports["soe-ui"]:SendAlert("error", "Cruising Speed Too High!", 5000)
                    break
                end
                Wait(1)
            end
            cruise = 0
        else
            cruise = 0
            exports["soe-ui"]:SendAlert("inform", "Cruise Control Disabled", 2500)
        end
    else
        if (cruise > 0) then
            exports["soe-ui"]:SendAlert("inform", "Cruise Control Disabled", 2500)
        end
        cruise = 0
    end
end

-- DOOR TOGGLER
function ToggleVehicleDoor(veh, door)
    -- IF THE PLAYER IS KIDNAPPED OR CUFFED, THEY CAN'T DO THIS
    if IsPedCuffed(PlayerPedId()) then
        return
    end

    -- CHECK ANGLE OF DOOR
    local angle = GetVehicleDoorAngleRatio(veh, door)
    if (angle == 0) then
        -- IF VEHICLE IS UNLOCKED
        if (GetVehicleDoorLockStatus(veh) ~= 2) then
            -- SEND TO SERVER TO SYNC DOOR OPENING/CLOSING
            TriggerServerEvent("UX:Server:ToggleDoor", VehToNet(veh), door)
        else
            exports["soe-ui"]:SendAlert("error", "Vehicle is locked", 5000)
        end
    else
        -- SEND TO SERVER TO SYNC DOOR OPENING/CLOSING
        TriggerServerEvent("UX:Server:ToggleDoor", VehToNet(veh), door)
    end
end

-- RETURNS WHETHER SEATBELT IS ON/OFF
function IsWearingSeatbelt()
    return seatbelt
end

-- TOGGLES SEATBELT
function ToggleSeatbelt()
    if (myVeh ~= nil) then
        -- IF VEHICLE IS A BICYCLE OR MOTORCYLE THEN NO SEATBELT
        if IsThisModelABicycle(GetEntityModel(myVeh)) or IsThisModelABike(GetEntityModel(myVeh)) then
            exports["soe-ui"]:SendUniqueAlert("noSeatbelt", "error", "This vehicle does not have a seatbelt", 5000)
            return
        end

        -- SEATBELT CONTROL WITH NOTIFICATIONS AND SOUNDS
        seatbelt = not seatbelt
        exports["soe-ui"]:UpdateSeatbeltIcon(seatbelt)
        local volume = exports["soe-utils"]:GetSoundLevel()
        if seatbelt then
            exports["soe-utils"]:PlaySound("seatbelt_on.ogg", volume, true)
            exports["soe-ui"]:SendAlert("inform", "Seatbelt On", 1000)
        else
            exports["soe-utils"]:PlaySound("seatbelt_off.ogg", volume, true)
            exports["soe-ui"]:SendAlert("inform", "Seatbelt Off", 1000)
        end
    end
end

-- TOGGLES ENGINE
function ToggleEngine()
    -- IF ALREADY HOTWIRING, RETURN
    if IsHotwiring() then return end

    local isDriver = (GetPedInVehicleSeat(myVeh, -1) == PlayerPedId())
    if myVeh and isDriver then
        if GetIsVehicleEngineRunning(myVeh) then
            -- IF ALREADY RUNNING, TURN ENGINE OFF
            SetVehicleEngineOn(myVeh, false, true, true)
            engine = false
        else
            -- CHECK IF THE PLAYER HAS A KEY TO THE VEHICLE
            local hasKey = exports["soe-valet"]:HasKey(myVeh)
            if not hasKey then
                exports["soe-ui"]:SendAlert("error", "You do not have keys to this vehicle", 2500)
                return
            end

            -- CHECK IF THE KILLSWITCH WAS TRIGGERED
            if DecorGetBool(myVeh, "hasKillswitchTriggered") then
                exports["soe-ui"]:SendAlert("error", "You realize the engine is having trouble working", 5000)
                return
            end

            -- TURN ENGINE ON
            engine = true
            SetVehicleEngineOn(myVeh, true, false, true)
            Wait(500)

            -- IF VEHICLE ENGINE HP IS LOW, SHUT IT OFF AGAIN
            if GetVehicleEngineHealth(myVeh) < 150 then
                SetVehicleEngineOn(myVeh, false, true, true)
            end
        end

        -- AIRCRAFT ENGINE CONTROL
        local class = GetVehicleClass(myVeh)
        if (class == 15 or class == 16) then
            print("is aircraft")
            TriggerEvent("Aviation:Client:UpdateEngineStatus", engine)
        else
            print("is not aircraft")
        end
    end
end

function SendShotsFiredAlert()
    local ped = PlayerPedId()
    local shouldReport = exports["soe-emergency"]:ShouldReportInThisArea()
    if (exports["soe-jobs"]:GetMyJob() == "POLICE") or IsPedCurrentWeaponSilenced(ped) then
        shouldReport = false
    end

    if shouldReport then
        -- MAKE SURE WE ARE NOT IN A SHOTS FIRED EXCLUDED ZONE (SHOOTING RANGES ETC)
        local pos = GetEntityCoords(ped)
        for _, zone in ipairs(excludedShotsFiredZones) do
            if #(zone.pos - pos) <= zone.range then
                return
            end
        end

        local loc = exports["soe-utils"]:GetLocation(pos)
        if not IsPedInAnyVehicle(ped) then
            TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = true, type = "Shots Fired", loc = loc, coords = pos})
        else
            local veh = GetVehiclePedIsIn(ped, false)
            local primary = GetVehicleColours(veh)
            local plate = GetVehicleNumberPlateText(veh)

            -- LETS ASSUME IT'S A DRIVE-BY SHOOTING
            TriggerServerEvent("Emergency:Server:CADAlerts", {status = true, global = true, type = "Drive-By Shooting",
                loc = loc, model = GetEntityModel(veh), color = primary, plate = plate, coords = pos
            })
        end
        sentAlert = true
        ResetSentShotsFiredAlert()
    end
end

-- **********************
--       Commands
-- **********************
RegisterCommand("anchor", DoAnchor)
RegisterCommand("belt", ToggleSeatbelt)
RegisterCommand("engine", ToggleEngine)
RegisterCommand("cruise", CruiseControl)
RegisterCommand("neutral", SetNeutralGear)

-- SELECTS DOOR INDEX BASED OFF ARGUMENT TO TOGGLE
RegisterCommand("door", function(source, args)
    SelectDoorIndex(args[1])
end)

-- TOGGLES VEHICLE HOOD
RegisterCommand("hood", function()
    SelectDoorIndex("hood")
end)

-- TOGGLES VEHICLE TRUNK
RegisterCommand("trunk", function()
    SelectDoorIndex("trunk")
end)

-- TOGGLES VEHICLE'S ALTERNATE TRUNK
RegisterCommand("trunk2", function()
    SelectDoorIndex("trunk2")
end)

--[[RegisterCommand("inccruise", function()
    ChangeCruisingSpeed("Increment")
end)

RegisterCommand("deccruise", function()
    ChangeCruisingSpeed("Decrement")
end)]]

-- SHUFFLES TO THE NEXT AVAILABLE VEHICLE SEAT
RegisterCommand("shuffle", function()
    if (myVeh ~= 0) then
        -- IF PLAYER HAS A SEATBELT ON, DON'T DO THIS
        if seatbelt then
            exports["soe-ui"]:SendAlert("error", "You can't shuffle seats with a seatbelt on!", 5000)
            return
        end
        -- SHUFFLE SEATS
        TaskShuffleToNextVehicleSeat(PlayerPedId(), myVeh)
    end
end)

-- TRIGGERED UPON 'M' KEYPRESS (DEFAULT KEY)
RegisterCommand("readplate", function()
    local veh = exports["soe-utils"]:GetVehInFrontOfPlayer(20.0)
    if veh then
        -- GRAB PLATE AND MODEL INFO
        local plate = GetVehicleNumberPlateText(veh)
        local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh)))

        -- SEND TO CHAT OUR INFO GATHERED ABOVE
        TriggerEvent("Chat:Client:Message", "[Plate]", plate, "standard")
        TriggerEvent("Chat:Client:Message", "[Model]", model, "standard")

        if (exports["soe-jobs"]:GetMyJob() == "POLICE") then
            local myHeading, vehHeading = GetEntityHeading(PlayerPedId()), GetEntityHeading(veh)
            local diffHeading = math.abs((myHeading - vehHeading + 540) % 360 - 180)
            
            -- ALT M WILL WORK
            if diffHeading >= 150 or diffHeading <= 30 then
                -- "ALPR HIT", IF ALT IS ALSO PRESSED
                if IsControlPressed(1, 19) then
                    ExecuteCommand("runplate " .. plate)
                end
            else
                exports["soe-ui"]:SendAlert("error", "Not in a good angle for the ALPRs", 1500)
            end
        end
    end
end)

-- TOGGLES VEHICLE'S TRAILER DOOR
RegisterCommand("trailer", function(source, args)
    -- SELECT TRAILER DOOR INDEX BASED OFF ARGUMENT
    if args[1] == "2" or args[1] == "bl" or args[1] == "backleft" then
        door = 2
    elseif args[1] == "3" or args[1] == "br" or args[1] == "backright" then
        door = 3
    elseif args[1] == "lower" or args[1] == "4" then
        door = 4
    elseif args[1] == "trunk" or args[1] == "5" or args[1] == "boot" then
        door = 5
    else
        door = nil
    end

    -- IF WE GOT A DOOR MATCH, TOGGLE IT
    if (door ~= nil) then
        local isDriver = (GetPedInVehicleSeat(myVeh, -1) == PlayerPedId())
        local hasTrailer, trailerID = GetVehicleTrailerVehicle(myVeh, trailerID)
        if hasTrailer and (trailerID ~= nil) and isDriver then
            if DoesVehicleHaveDoor(trailerID, door) then
                -- CHECK ANGLE OF DOOR
                local angle = GetVehicleDoorAngleRatio(trailerID, door)
                if (angle == 0) then
                    -- IF VEHICLE IS UNLOCKED
                    if (GetVehicleDoorLockStatus(myVeh) ~= 2) then
                        -- SEND TO SERVER TO SYNC DOOR OPENING/CLOSING
                        TriggerServerEvent("UX:Server:ToggleDoor", VehToNet(trailerID), door)
                    else
                        exports["soe-ui"]:SendAlert("error", "Vehicle and trailer are locked", 5000)
                    end
                else
                    -- SEND TO SERVER TO SYNC DOOR OPENING/CLOSING
                    TriggerServerEvent("UX:Server:ToggleDoor", VehToNet(trailerID), door)
                end
            end
        end
    end
end)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, EQUIP THE VEHICLE WITH A KILLSWITCH
AddEventHandler("Inventory:Client:UseEngineKiller", UseEngineKiller)

-- WHEN TRIGGERED, ACTIVATE KILLSWITCH OF LAST VEHICLE FITTED WITH A KILLSWITCH
RegisterNetEvent("UX:Client:ActivateKillSwitch")
AddEventHandler("UX:Client:ActivateKillSwitch", ActivateKillSwitch)

-- WHEN TRIGGERED, SYNC KILL SWITCH WITH VEHICLE
RegisterNetEvent("UX:Client:SyncVehicleKillswitch")
AddEventHandler("UX:Client:SyncVehicleKillswitch", function(data)
    if not data.status then return end

    local veh = NetToVeh(data.veh)
    if DecorGetBool(veh, "hasKillswitchFitted") then
        DecorSetBool(veh, "hasKillswitchTriggered", true)
        SetVehicleEngineOn(veh, false, false, false)
    end
end)

-- LEAVING VEHICLE EVENTS
AddEventHandler("BaseEvents:Client:LeftVehicle", function(veh)
    -- FLAG THAT WE ARE NO LONGER IN A VEHICLE AND SAVE ENGINE STATUS
    if engine then
        Wait(100)
        SetVehicleEngineOn(veh, true, true, true)
    end

    -- RESET SEVERAL VARIABLES
    inVeh, myVeh, neutral, seatbelt = false, nil, false, false
end)

-- SENT FROM SERVER TO SYNC DOOR OPENING/CLOSING
RegisterNetEvent("UX:Client:ToggleDoor")
AddEventHandler("UX:Client:ToggleDoor", function(veh, door)
    -- IF THE VEHICLE IS "INSTANCED", RETURN
    if not NetworkDoesNetworkIdExist(veh) then return end

    -- IF WE HAVE CONTROL OF THE VEHICLE, TOGGLE DOORS
    veh = NetToVeh(veh)
    if NetworkHasControlOfEntity(veh) then
        local angle = GetVehicleDoorAngleRatio(veh, door)
        if (angle == 0) then
            SetVehicleDoorOpen(veh, door, false, false)
        else
            SetVehicleDoorShut(veh, door, false, false)
        end
    end
end)

-- CALLED FROM SERVER AFTER "/spotlight" IS EXECUTED
RegisterNetEvent("UX:Client:SpotlightOptions")
AddEventHandler("UX:Client:SpotlightOptions", function(type)
    -- IF THIS IS NOT AN EMERGENCY VEHICLE, DON'T TRY
    if (GetVehicleClass(myVeh) ~= 18) then return end

    local id = VehToNet(myVeh)
    if (type == "left") then
        TriggerServerEvent("UX:Server:Spotlights", "left", id)
    elseif (type == "right") then
        TriggerServerEvent("UX:Server:Spotlights", "right", id)
    elseif (type == "front") then
        TriggerServerEvent("UX:Server:Spotlights", "front", id)
    else
        TriggerServerEvent("UX:Server:Spotlights", nil)
    end
end)

-- ENTERING VEHICLE EVENTS
AddEventHandler("BaseEvents:Client:EnteringVehicle", function(veh)
    local closest, dist = -3, 500.0

    -- CERTAIN MODELS ARE STUPID. DON'T USE "CLOSEST DOOR" FUNCTIONALITY - PRAISE CFX FOR THIS
    local blacklist = {"bus", "pbus", "airbus"}
    for i = 1, #blacklist do
        if (GetHashKey(blacklist[i]) == GetEntityModel(veh)) then
            --print("THIS IS IN THE ENTERING VEHICLE BLACKLIST.")
            return
        end
    end

    -- CHOOSE THE CLOSEST DOOR TO ENTER
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    for i = 0, 4 do
        if DoesVehicleHaveDoor(veh, i) then
            -- OLD METHOD TO GRAB NEAREST VEHICLE SEAT
            -- THIS GIVES YOU A HARD TIME TO CARJACK LOCALS THOUGH
            --[[if IsVehicleSeatFree(veh, i - 1) then
                if (Vdist2(pos, door) < dist) then
                    closest = i - 1
                    dist = Vdist2(pos, door)
                end
            end]]

            -- JUST GRAB THE CLOSEST SEAT AND DISTANCE AND MAKE SURE
            -- OCCUPANT IS NOT A PLAYER IN CASE OF CARJACKING
            local door, occupant = GetEntryPositionOfDoor(veh, i), GetPedInVehicleSeat(veh, i - 1)
            if not IsPedAPlayer(occupant) then
                if #(pos - door) <= dist then
                    closest = i - 1
                    dist = #(pos - door)
                end
            end
        end
    end

    -- IF CLOSEST SEAT IS FOR SOME REASON DEFAULT, NO GO
    if (closest == -3) then return end

    -- IF PLAYER IS CUFFED, CANCEL ENTERING A DOOR
    if exports["soe-emergency"]:IsRestrained() then
        if GetVehicleDoorAngleRatio(veh, closest + 1) <= 0 then
            ClearPedTasks(ped)
            entering = false
            local time = GetGameTimer()
            while exports["soe-utils"]:TimeSince(time) < 1000 do
                Wait(5)
                DisableControlAction(0, 23, true)
            end
            return
        end
    end

    -- DOGS ARE... QUITE SPECIAL. HAVE THEM WARP IN INSTEAD
    if exports["soe-utils"]:IsModelADog(ped) then
        ClearPedTasks(ped)
        ClearPedTasksImmediately(ped)
        SetPedIntoVehicle(ped, veh, closest)
        return
    end

    -- MAKE THE PED ENTER THE VEHICLE
    TaskEnterVehicle(ped, veh, 10000, closest, 1.0, 1, 0)
    entering = true
    local start = GetGameTimer()
    while entering do
        Wait(5)
        -- GIVE PLAYER AN OPPORTUNITY TO CANCEL
        for i = 32, 35 do
            if IsControlJustPressed(0, i) then
                if entering then
                    ClearPedTasks(ped)
                    entering = false
                end
            end
        end

        -- IF WE ARE TAKING TOO LONG TO GET INSIDE, LIKELY TOO FAR
        if exports["soe-utils"]:TimeSince(start) > 8000 then
            if entering then
                ClearPedTasks(ped)
                entering = false
            end
        end
    end
end)

RegisterNetEvent("UX:Client:Spotlights")
AddEventHandler("UX:Client:Spotlights", function(list)
    spotlights, spotlightNum = list, 0
    for k, v in pairs(spotlights) do
        if not NetworkDoesNetworkIdExist(v.Vehicle) then
            spotlights[k].Vehicle = 0
        else
            spotlights[k].Vehicle = NetToVeh(v.Vehicle)
        end
        spotlightNum = spotlightNum + 1
    end

    if not thread then
        thread = true
        local n = 60
        local closeList = {}
        local pos = GetEntityCoords(PlayerPedId())
        while (spotlightNum > 0) do
            Wait(1)
            for k, v in pairs(closeList) do
                if (v.Direction == "left") then
                    DrawSpotLight(GetOffsetFromEntityInWorldCoords(v.Vehicle, -0.5, 0.0, 1.5), exports["soe-utils"]:RotAnglesToVec(GetEntityRotation(v.Vehicle) - vector3(15.0, 0.0, -90.0)), 255, 255, 255, 100.0, 10.0, 1.0, 30.0, 1.0)
                elseif (v.Direction == "right") then
                    DrawSpotLight(GetOffsetFromEntityInWorldCoords(v.Vehicle, 0.5, 0.0, 1.5), exports["soe-utils"]:RotAnglesToVec(GetEntityRotation(v.Vehicle) - vector3(15.0, 0.0, 90.0)), 255, 255, 255, 100.0, 10.0, 1.0, 30.0, 1.0)
                else
                    DrawSpotLight(GetOffsetFromEntityInWorldCoords(v.Vehicle, 0.0, -1.0, 2.0), exports["soe-utils"]:RotAnglesToVec(GetEntityRotation(v.Vehicle) - vector3(15.0, 0.0, 0.0)), 255, 255, 255, 100.0, 10.0, 0.5, 30.0, 1.0)
                end
            end

            n = n + 1
            if (n >= 60) then
                pos = GetEntityCoords(PlayerPedId())
                closeList = {}
                for k, v in pairs(spotlights) do
                    if DoesEntityExist(v.Vehicle) then
                        if Vdist2(pos, GetEntityCoords(v.Vehicle)) <= 10000.0 then
                            closeList[k] = v
                        end
                    end
                end
                n = 0
            end
        end
        thread = false
    end
end)

-- ENTERED INTO VEHICLE EVENT
AddEventHandler("BaseEvents:Client:EnteredVehicle", function(veh, seat)
    -- SET SOME VARIABLES AND SAVE ENGINE STATUS
    myVeh, inVeh, entering = veh, true, false
    engine = GetIsVehicleEngineRunning(myVeh)
    if not engine then
        SetVehicleEngineOn(myVeh, false, true, true)
    end

    -- SET SOME FLAGS
    local ped = PlayerPedId()
    SetPedIntoVehicle(ped, myVeh, seat) -- SET PLAYER INTO VEHICLE
    SetPedConfigFlag(ped, 184, true) -- DISABLE AUTO-SEAT SHUFFLE
    SetPedConfigFlag(ped, 429, true) -- DISABLE AUTO-ENGINE TOGGLE

    -- DISABLE AUTO-MOTORCYCLE HELMET IF ON A MOTORCYCLE/BMX
    local model = GetEntityModel(veh)
    if IsThisModelABicycle(model) or IsThisModelABike(model) then
        SetPedConfigFlag(ped, 35, false)
    end

    print(("Is Vehicle Networked? [Veh ID: %s] [Is Networked: %s]"):format(veh, NetworkGetEntityIsNetworked(veh)))
    -- POSSIBLE PERSISTENCE FIXES
    local netID = exports["soe-utils"]:GetNetID(veh)
    SetVehicleHasBeenOwnedByPlayer(veh, true)
    exports["soe-utils"]:RegisterEntityAsNetworked(veh)

    print(("Obtained NetID for [Veh ID: %s] as [Net ID: %s] [Plate: %s] [VIN: %s]"):format(veh, netID, GetVehicleNumberPlateText(veh), DecorGetInt(veh, "vin")))
    print(("Is Vehicle Networked? [Veh ID: %s] [Is Networked: %s]"):format(veh, NetworkGetEntityIsNetworked(veh)))

    local loopIndex, civType = 0, exports["soe-uchuu"]:GetPlayer().CivType
    while inVeh do
        Wait(5)
        if not engine then
            SetVehicleEngineOn(myVeh, false, true, true)
        end

        -- KILLSWITCH FIX FOR PERSISTENT ENGINE
        if engine and DecorGetBool(myVeh, "hasKillswitchTriggered") then
            engine = false
            SetVehicleEngineOn(myVeh, false, false, false)
        end

        -- FORCED FIRST PERSON WHEN AIMING/SHOOTING
        if IsPlayerFreeAiming(PlayerId()) then
            if not needsToResetSoon then
                needsToResetSoon = true
            end
            SetFollowVehicleCamViewMode(4)
        else
            if needsToResetSoon then
                needsToResetSoon = false
                SetFollowVehicleCamViewMode(1)
            end
        end

        -- DISABLE BIKE JUMP SPAM
        if GetVehicleClass(myVeh) == 13 then
            if IsControlJustPressed(0, 102) then
                local time = GetGameTimer() + 1500
                while GetGameTimer() < time do
                    Wait(5)
                    DisableControlAction(0, 102, true)
                end
            end
        end

        -- CHILD LOCK FOR EMERGENCY VEHICLES
        if (GetVehicleClass(myVeh) == 18) and (civType ~= "POLICE") then
            if (seat == 1 or seat == 2) then
                if (GetVehicleDoorAngleRatio(myVeh, seat + 1) == 0) then
                    DisableControlAction(0, 75)
                end
            end
        end

        -- DISABLE VEHICLE ROLL BACK OVER / AIR CONTROL
        local roll = GetEntityRoll(myVeh)
        if DoesEntityExist(myVeh) and not IsEntityDead(myVeh) then
            if not IsThisModelABike(model) and not IsThisModelABoat(model) and not IsThisModelAHeli(model) and not IsThisModelAPlane(model) and IsEntityInAir(myVeh) then
                DisableControlAction(0, 59) -- D
                DisableControlAction(0, 60) -- LEFT CTRL
            end

            if (roll > 75.0 or roll < -75.0) and GetEntitySpeed(myVeh) < 2 then
                DisableControlAction(2, 59, true) -- D
                DisableControlAction(2, 60, true) -- LEFT CTRL
            end
        end

        -- STEERING ANGLE WHEN GETTING OUT
        if IsControlPressed(0, 75) then
            ped = PlayerPedId()
            if exports["soe-utils"]:IsModelADog(ped) then
                DoDogWarpout(ped)
            end

            local angle = GetVehicleSteeringAngle(myVeh)
            for i = 1, 5 do
                Wait(50)
                SetVehicleSteeringAngle(myVeh, angle)
            end
        end

        -- SEATBELT CHECK WHEN PRESSING F
        if seatbelt then
            DisableControlAction(0, 75, true) -- F
            if IsDisabledControlJustPressed(0, 75) then
                exports["soe-ui"]:SendUniqueAlert("deniedSeatbelt", "error", "You cannot exit the vehicle while your seatbelt is on.", 2000)
            end
        end

        -- CONTROLS NEUTRAL GEAR
        MaintainNeutralGear()

        loopIndex = loopIndex + 1
        if (loopIndex % 60 == 0) then
            local health = GetVehicleEngineHealth(myVeh)
            if health < 100 then
                engine = false
                SetVehicleEngineOn(myVeh, false, true, true)
            end
        elseif (loopIndex % 65 == 0) then
            loopIndex = 0

            -- CONTROLS TURN SIGNALS
            ControlTurnSignals()
        end
    end
end)
