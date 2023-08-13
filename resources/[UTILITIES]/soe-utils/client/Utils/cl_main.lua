local lastHit = 0
local xyz, debug, isInVehicle = false, false, false

-- INTERACTION KEY
RegisterKeyMapping("interact", "[Interact] Interaction Key", "keyboard", "E")

-- **********************
--    Local Functions
-- **********************
local function DrawDebugText(text, x, y)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(x, y)
end

-- **********************
--    Global Functions
-- **********************
-- USUALLY USED FOR RAYCASTING PURPOSES
function CameraForwardVec()
    local rot = (math.pi / 180.0) * GetGameplayCamRot(2)
    return vector3(-math.sin(rot.z) * math.abs(math.cos(rot.x)), math.cos(rot.z) * math.abs(math.cos(rot.x)), math.sin(rot.x))
end
exports("CameraForwardVec", CameraForwardVec)

-- SHOWS A NOTIFICATION OVER THE MINIMAP
function ShowNotification(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(0, 1)
end
exports("ShowNotification", ShowNotification)

-- SHOWS HELP TEXT ON THE TOP LEFT OF THE SCREEN
function HelpText(text, time)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, (-1 or time))
end
exports("HelpText", HelpText)

-- SHOWS FLOATING HELP TEXT AT A POSITION
function FloatingHelpText(message, pos)
    AddTextEntry(message, message)
    SetFloatingHelpTextWorldPosition(1, pos)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)

    BeginTextCommandDisplayHelp(message)
    EndTextCommandDisplayHelp((2 or 0), false, true, -1)
end
exports("FloatingHelpText", FloatingHelpText)

-- ROTATES ANGLES TO VECTOR FORM (USES VECTOR3 NATIVE)
function RotAnglesToVec(rot)
    local x, z = math.rad(rot.x), math.rad(rot.z)
    local num = math.abs(math.cos(x))
    return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end
exports("RotAnglesToVec", RotAnglesToVec)

-- RETURNS IF ANY DOOR OF A VEHICLE IS OPEN
function IsAnyDoorOpen(veh)
    for i = 0, 5 do
        if DoesVehicleHaveDoor(veh, i) then
            local angle = GetVehicleDoorAngleRatio(veh, i)
            if (angle > 0) then
                return true
            end
        end
    end
    return false
end
exports("IsAnyDoorOpen", IsAnyDoorOpen)

-- RAYCASTING SPECIFICALLY MODIFIED FOR GHOST OBJECT/VEHICLE PLACEMENT
function GhostRaycast(dist)
    local start = GetGameplayCamCoord()
    local target = start + (CameraForwardVec() * dist)
    local ray = StartShapeTestRay(start, target, -1, PlayerPedId(), 1)
    local _, _, c = GetShapeTestResult(ray)
    return c
end
exports("GhostRaycast", GhostRaycast)

-- DRAWS 3D TEXT AT SPECIFIC COORDINATES
function DrawText3D(x, y, z, text, rect)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(_x, _y)
        if rect then
            local factor = (string.len(text)) / 370
            DrawRect(_x, (_y + 0.0125), (0.017 + factor), 0.03, 0, 0, 0, 75)
        end
    end
end
exports("DrawText3D", DrawText3D)

-- DRAWS TEXT ON THE PLAYER'S SCREEN
function DrawTxt(text, x, y, font, color, scale, center, shadow, alignRight, num1, num2)
    SetTextColour(color[1], color[2], color[3], color[4])
    SetTextFont(font)
    SetTextScale(scale, scale)
    if shadow then
        SetTextOutline()
    end

    if center then
        SetTextCentre(center)
    elseif alignRight then
        SetTextRightJustify(true)
        SetTextWrap(num1, num2)
    end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end
exports("DrawTxt", DrawTxt)

-- LOADS ANIMATION DICTIONARY (ERRORS OUT WHEN INVALID SO NO STUCK LOOPS)
function LoadAnimDict(dict, time)
    local gameTime = GetGameTimer()
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait((time or 15))
            local n = GetGameTimer()
            if (n > gameTime + 2000) then
                if (n > gameTime + 10000) then
                    print(string.format("ERROR: %s is not a valid animation dictionary or took too long to load", dict))
                    return 0
                end
            end
        end
    end
end
exports("LoadAnimDict", LoadAnimDict)

-- LOADS MODEL (ERRORS OUT WHEN INVALID SO NO STUCK LOOPS)
function LoadModel(model, time)
    if not HasModelLoaded(model) and IsModelInCdimage(model) then
        --print("LoadModel: Debugging! We are loading " .. model)
        local gameTime = GetGameTimer()

        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(time or 15)

            local n = GetGameTimer()
            if (n > gameTime + 2000) then
                if (n > gameTime + 10000) then
                    print(("ERROR: %s is not a valid model or took too long to load"):format(model))
                    return 0
                end
            end
        end
    end
end
exports("LoadModel", LoadModel)

-- LOADS ANIMATION SET (ERRORS OUT WHEN INVALID SO NO STUCK LOOPS)
function LoadAnimSet(dict, time)
    local gameTime = GetGameTimer()
    if not HasAnimSetLoaded(dict) then
        RequestAnimSet(dict)
        while not HasAnimSetLoaded(dict) do
            Wait((time or 15))
            local n = GetGameTimer()
            if (n > gameTime + 2000) then
                if (n > gameTime + 10000) then
                    print(string.format("ERROR: %s is not a valid animation set or took too long to load", dict))
                    return 0
                end
            end
        end
    end
end
exports("LoadAnimSet", LoadAnimSet)

-- LOADS PTFX ASSET (ERRORS OUT WHEN INVALID SO NO STUCK LOOPS)
function LoadPTFXAsset(asset, time)
    local gameTime = GetGameTimer()
    if not HasNamedPtfxAssetLoaded(asset) then
        RequestNamedPtfxAsset(asset)
        while not HasNamedPtfxAssetLoaded(asset) do
            Wait((time or 15))
            local n = GetGameTimer()
            if (n > gameTime + 2000) then
                if (n > gameTime + 10000) then
                    print(string.format("ERROR: %s is not a valid PTFX asset or took too long to load", asset))
                    return 0
                end
            end
        end
    end
end
exports("LoadPTFXAsset", LoadPTFXAsset)

-- WHEN TRIGGERED, CHECK IF AN OBJECT IS NEAR A PLAYER
function IsNearObject(objectName, range)
    -- SET DEFAULT RANGE IF NOT DEFINED
    if (range == nil) then
        range = 1.5
    end

    -- CHECK IF PLAYER IS NEAR OBJECT
    local obj = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), range, GetHashKey(objectName), false)
    if DoesEntityExist(obj) then
        return true
    end
    return false
end
exports("IsNearObject", IsNearObject)

-- SPAWNS OBJECT AT PLAYER'S POSITION AT AN OFFSET
function SpawnObject(model)
    if (type(model) == "string") then
        model = GetHashKey(model)
    end

    LoadModel(model, 15)
    local obj = CreateObject(model, GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 5.0, 0.0), true, false, true)
    while not NetworkGetEntityIsNetworked(obj) do
        Wait(50)
        NetworkRegisterEntityAsNetworked(obj)
    end

    local netID = GetNetID(obj)
    SetModelAsNoLongerNeeded(model)
    return obj
end
exports("SpawnObject", SpawnObject)

-- RESTORES WEAPONS AND ARMOR WHEN CHANING MODEL
function RestoreMyItems(health, armor)
    local ped = PlayerPedId()
    -- RESTORE WEAPONS
    local myInv = exports["soe-inventory"]:RequestInventory()
    if (myInv.leftInventory ~= nil) then
        for _, item in pairs(myInv.leftInventory) do
            local itemMeta = json.decode(item.ItemMeta)
            if itemMeta.equipped then
                GiveWeaponToPed(ped, GetHashKey(item.ItemType), tonumber(itemMeta.ammo), false, false)
                SetPedAmmo(ped, GetHashKey(item.ItemType), tonumber(itemMeta.ammo))
            end
        end
    end

    -- RESTORE HEALTH/ARMOR
    SetPedArmour(ped, armor)
    SetEntityHealth(ped, health)
end
exports("RestoreMyItems", RestoreMyItems)

-- ENTITY DEBUGGER TO SHOW ITS POS AND YAW
function EntityDebugger()
    debug = not debug
    while debug do
        Wait(5)
        local ray = Raycast(100)
        local ent = ray.HitEntity
        if (GetEntityType(ent) == 0) then
            ent = lastHit
        else
            lastHit = ent
        end

        local pos = GetEntityCoords(ent)
        local found, x, y = GetScreenCoordFromWorldCoord(pos.x, pos.y, pos.z)
        if found then
            DrawDebugText("Model: " .. GetEntityModel(ent), x, y)
            DrawDebugText("Coords: " .. GetEntityCoords(ent), x, y + 0.03)
            DrawDebugText("Yaw: " .. GetEntityRotation(ent), x, y + 0.06)
            DrawDebugText("Relationship Group: " .. GetPedRelationshipGroupHash(ent) or 0, x, y + 0.09)
        end
    end
end
exports("EntityDebugger", EntityDebugger)

-- RETURNS STREET NAME WITH CROSS (IF ABLE) AND AREA NAME
function GetLocation(pos)
    local cross
    local street
    street, cross = GetStreetNameAtCoord(pos.x, pos.y, pos.z, street, cross)
    local zone = GetAreaNames()[GetNameOfZone(pos.x, pos.y, pos.z)]
    local primaryStreetName = GetStreetNameFromHashKey(street)
    local crossStreetname = GetStreetNameFromHashKey(cross)

    -- PREVENTS AN ERROR WHEN CONCATENATING A NIL VALUE. HAPPENS IN AREAS SUCH AS TUNNELS
    if (zone == nil or zone == "") then
        zone = "Unincorporated Zone"
    end

    -- PREVENTS AN ERROR WHEN CONCATENATING A NIL VALUE
    local currentStreetName = primaryStreetName
    if (currentStreetName == nil or currentStreetName == "") then
        currentStreetName = " "
    end

    -- FINALLY RETURN THE STREET NAME AND CROSS
    if (crossStreetname ~= nil and crossStreetname ~= "") then
        currentStreetName = ("%s / %s in %s"):format(currentStreetName, crossStreetname, zone)
    else
        currentStreetName = ("%s in %s"):format(currentStreetName, zone)
    end
    return currentStreetName
end
exports("GetLocation", GetLocation)

function GetClosestPed(maxDist, localsOnly)
    localsOnly = localsOnly or false
    local pedList = {}
    local handle, ped = FindFirstPed()
    local done = false
    repeat
        done, ped = FindNextPed(handle)
        if not localsOnly or (localsOnly and not IsPedAPlayer(ped)) then
            pedList[#pedList + 1] = ped
        end
    until not done
    EndFindPed(handle)

    local closest
    local dist = 1000
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    for _, v in pairs(pedList) do
        if (v ~= ped) then
            local vPos = GetEntityCoords(v)
            if (Vdist2(pos, vPos) < dist) then
                closest = v
                dist = Vdist2(pos, vPos)
            end
        end
    end

    if (dist <= (maxDist or 5.0)) then
        return closest
    end
    return 0
end
exports("GetClosestPed", GetClosestPed)

-- GETS CLOSEST PLAYER BASED OFF RADIUS OF ANOTHER PED/PLAYER
function GetClosestPlayer(radius)
    local closestPlayer = -1
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local closestDistance = 99999999
    local players = GetActivePlayers()

    -- ITERATE THROUGH ACTIVE PLAYERS TO FIND CLOSEST ONE
    for _, v in pairs(players) do
        local target = GetPlayerPed(v)
        if (target ~= ped) then
            local targetPos = GetEntityCoords(target)
            local distance = Vdist2(targetPos, pos)
            if (distance < closestDistance and distance <= radius) then
                closestPlayer = v
                closestDistance = distance
            end
        end
    end

    -- RETURN OUR CLOSEST PLAYER
    if (closestDistance ~= 99999999) then
        return closestPlayer
    end
    return nil
end
exports("GetClosestPlayer", GetClosestPlayer)

-- RETURNS PED/PLAYER IN FRONT OF PLAYER
function GetPedInFrontOfPlayer(distance, isAlive)
    -- CHANGES FLAG IF WANTED ALIVE OR DEAD
    local flag
    if isAlive then
        flag = 4
    else
        flag = 8
    end

    -- START LOOKING FOR OUR PED
    local target = nil
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    for i = -2.0, 1.0, 0.1 do
        -- USE RAYCAST TO FIND THE PED IN FRONT OF THE PLAYER
        local offset = GetOffsetFromEntityInWorldCoords(ped, 0.0, distance, 0.0)
        local result = StartShapeTestCapsule(pos.x, pos.y, pos.z + i, offset.x, offset.y, offset.z, 1.0, flag, ped, 0)

        -- IF WE FOUND OUR TARGET, RETURN IT
        local _, _, _, _, target = GetShapeTestResult(result)
        if (target ~= nil and target ~= 0) then
            return target
        end
    end
    -- IF WE FAILED, RETURN NIL
    return target
end
exports("GetPedInFrontOfPlayer", GetPedInFrontOfPlayer)

-- RAYCASTING FUNCTION
function Raycast(dist)
    local camRot = GetGameplayCamRot()
    local camCoords = GetGameplayCamCoord()
    local forwardVector = {
        x = (-math.sin((math.pi / 180) * camRot.z) * math.abs(math.cos((math.pi / 180) * camRot.x))),
        y = (math.cos((math.pi / 180) * camRot.z) * math.abs(math.cos((math.pi / 180) * camRot.x))),
        z = (math.sin((math.pi / 180) * camRot.x))
    }
    local cx, cy, cz = table.unpack(camCoords)

    local distance = dist or 2.0
    if GetFollowPedCamViewMode() ~= 4 then
        distance = distance + #(GetPedBoneCoords(PlayerPedId(), 0x796E, 0.0, 0.0, 0.0) - camCoords)
    end
    local dx, dy, dz = cx + forwardVector.x * distance, cy + forwardVector.y * distance, cz + forwardVector.z * distance

    local ray = StartShapeTestRay(cx, cy, cz, dx, dy, dz, -1, PlayerPedId(), 1)
    local a, b, c, d, ent = GetShapeTestResult(ray)
    return {a = a, b = b, HitPosition = c, HitCoords = d, HitEntity = ent}
end
exports("Raycast", Raycast)

-- WHEN TRIGGERED, RETURN ENTITY PLAYER IS LOOKING AT
function GetEntityPlayerIsLookingAt(dist, radius, flag, ignore)
    local distance = dist or 3.0
    local pos = GetPedBoneCoords(PlayerPedId(), 31086)
    local forwardVectors = CameraForwardVec()

    local forwardCoords = pos + (forwardVectors * (isInVehicle and distance + 1.5 or distance))
    if not forwardVectors then return end

    local handle = StartShapeTestSweptSphere(pos.x, pos.y, pos.z, forwardCoords.x, forwardCoords.y, forwardCoords.z, radius or 0.2, flag or 286, ignore, 0)
    local _, hit, targetCoords, _, targetEntity = GetShapeTestResult(handle)
    if not hit and targetEntity == 0 then return end

    local entityType = GetEntityType(targetEntity)
    return targetEntity, entityType, targetCoords
end
exports("GetEntityPlayerIsLookingAt", GetEntityPlayerIsLookingAt)

-- WHEN TRIGGERED, BEGIN A FAILSAFE FOR LOADING INTO SOMETHING TO PREVENT SCUFF/DEATH
function FloatUntilSafe(obj)
    FreezeEntityPosition(PlayerPedId(), true)

    local count = 200
    while (count > 0) do
        Wait(150)
        if HasCollisionLoadedAroundEntity(PlayerPedId()) == 1 and HasCollisionForModelLoaded(GetEntityModel(obj)) == 1 and HasModelLoaded(GetEntityModel(obj)) == 1 then
            count = -9
            break
        end
        count = count - 1
        print("[FloatUntilSafe]: Making sure you do not get scuffed or killed... our count is:", count)
    end

    FreezeEntityPosition(PlayerPedId(), false)
    if (count <= -9) then
        return true
    else
        return false
    end
end
exports("FloatUntilSafe", FloatUntilSafe)

-- **********************
--       Commands
-- **********************
RegisterCommand("interact", function()
    TriggerEvent("Utils:Client:InteractionKey")
    TriggerServerEvent("Utils:Server:InteractionKey")
end)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, RECORD IF PLAYER LEFT A VEHICLE
AddEventHandler("BaseEvents:Client:LeftVehicle", function()
    isInVehicle = false
end)

-- WHEN TRIGGERED, RECORD IF PLAYER ENTERED A VEHICLE
AddEventHandler("BaseEvents:Client:EnteredVehicle", function()
    isInVehicle = true
end)

-- SENT FROM SERVER TO COPY POS AND HDG TO CLIPBOARD
RegisterNetEvent("Utils:Client:SaveXYZToClipboard")
AddEventHandler("Utils:Client:SaveXYZToClipboard", function(pos, hdg)
    if not hdg then
        SendNUIMessage({action = "copyToClipboard", data = "" .. vec(pos.x, pos.y, pos.z)})
    else
        SendNUIMessage({action = "copyToClipboard", data = "" .. vec(pos.x, pos.y, pos.z, hdg)})
    end
end)

-- CALLED FROM SERVER AFTER "/xyz" IS EXECUTED
RegisterNetEvent("Utils:Client:ToggleXYZ")
AddEventHandler("Utils:Client:ToggleXYZ", function()
    xyz = not xyz
    local ped = PlayerPedId()
    while xyz do
        Wait(65)
        local pos = GetEntityCoords(ped)
        local hdg = GetEntityHeading(ped)

        local roundx = tonumber(("%.2f"):format(pos.x))
        local roundy = tonumber(("%.2f"):format(pos.y))
        local roundz = tonumber(("%.2f"):format(pos.z))
        local roundhdg = tonumber(("%.2f"):format(hdg))
        local info = {x = roundx, y = roundy, z = roundz, hdg = roundhdg}
        SendNUIMessage({action = "toggleXYZ", bool = xyz, info = info})
    end
    SendNUIMessage({action = "toggleXYZ", bool = false})
end)
