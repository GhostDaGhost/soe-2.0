local maxItems = 15
local showMenu = false
currentPolyzone = "None"

-- KEY MAPPINGS
RegisterKeyMapping("radialmenu", "[UI] Open Radial Menu", "KEYBOARD", "F2")

-- ***********************
--     Local Functions
-- ***********************
-- WHEN TRIGGERED, SHUT NUI FOCUS OFF
local function CloseRadialMenu()
    showMenu = false
    SetNuiFocus(false, false)

    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
end

-- WHEN TRIGGERED, GENERATE MENU SLICES BASED OFF CONDITIONS
local function GenerateSlices(entity, entityType)
    local enabledMenus = {}

    for _, menuConfig in pairs(menus) do
        if menuConfig:showIf(entity, entityType) then
            local dataElements = {}
            local hasSubMenus = false
            if (menuConfig.subMenus ~= nil and #menuConfig.subMenus > 0) then
                hasSubMenus = true
                local currentElement = {}
                local previousMenu = dataElements
                for i = 1, #menuConfig.subMenus do
                    currentElement[#currentElement + 1] = subMenus[menuConfig.subMenus[i]]
                    currentElement[#currentElement].id = menuConfig.subMenus[i]
                    currentElement[#currentElement].showIf = nil

                    if (i % maxItems == 0 and i < #menuConfig.subMenus - 1) then
                        previousMenu[maxItems + 1] = {id = "_more", title = "More", icon = "#more", items = currentElement}
                        previousMenu = currentElement
                        currentElement = {}
                    end
                end

                if #currentElement > 0 then
                    previousMenu[maxItems + 1] = {id = "_more", title = "More", icon = "#more", items = currentElement}
                end
                dataElements = dataElements[maxItems + 1].items
            end

            enabledMenus[#enabledMenus + 1] = {id = menuConfig.id, title = menuConfig.name, type = menuConfig.type, func = menuConfig.func,
                parameters = menuConfig.parameters, icon = menuConfig.icon, closeOnClick = menuConfig.closeOnClick
            }

            if hasSubMenus then
                enabledMenus[#enabledMenus].items = dataElements
            end
        end
    end
    return enabledMenus
end

-- WHEN TRIGGERED, OPEN RADIAL MENU
local function OpenRadialMenu()
    local entity, entityType = exports["soe-utils"]:GetEntityPlayerIsLookingAt(3.0, 0.2, 286, PlayerPedId())
    if (entity ~= 0 and entityType ~= 0) then
        CreateThread(function()
            while showMenu do
                Wait(5)
                local sizeX, sizeY, sizeZ = 0.28, 0.28, 0.28
                if IsPedSittingInAnyVehicle(PlayerPedId()) then
                    sizeX, sizeY, sizeZ = 0.36, 0.36, 0.36
                end

                local pos = GetEntityCoords(entity)
                DrawMarker(20, pos.x, pos.y, pos.z + 1.5, 0.0, 0.0, 0.0, 180.0, 0.0, 180.0, sizeX, sizeY, sizeZ, 110, 0, 0, 155, 1, 1, 2, 0, 0, 0, 0)
            end
        end)
    end

    local slices = GenerateSlices(entity, entityType)
    showMenu = true

    SetNuiFocus(true, true)
    SetCursorLocation(0.5, 0.5)

    SendNUIMessage({type = "Radial.Open", items = slices})
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
end

-- ***********************
--    Global Functions
-- ***********************
-- WHEN TRIGGERED, ADD MODEL TO RADIAL MENU MODEL TABLE
function AddModelToRadialData(type, modelsToAdd)
    if not type then return end
    if not modelsToAdd then return end

    type = tostring(type)
    if not models[type] then
        models[type] = {}
    end

    for _, model in pairs(modelsToAdd) do
        models[type][model] = true
    end
end
exports("AddModelToRadialData", AddModelToRadialData)

-- ***********************
--        Commands
-- ***********************
-- WHEN TRIGGERED, OPEN RADIAL MENU
RegisterCommand("radialmenu", OpenRadialMenu)

-- ***********************
--      NUI Callbacks
-- ***********************
-- WHEN TRIGGERED, SHUT NUI FOCUS OFF
RegisterNUICallback("Radial.Close", CloseRadialMenu)

-- WHEN TRIGGERED, DO SLICK CLICK ACTION
RegisterNUICallback("Radial.SliceClick", function(data)
    if (data.type == "command") then
        ExecuteCommand(data.action)
    elseif (data.type == "client") then
        if (data.parameters ~= nil) then
            TriggerEvent(data.action, data.parameters)
        else
            TriggerEvent(data.action)
        end
    elseif (data.type == "server") then
        if (data.parameters ~= nil) then
            TriggerServerEvent(data.action, data.parameters)
        else
            TriggerServerEvent(data.action)
        end
    end
end)

-- ***********************
--         Events
-- ***********************
-- WHEN TRIGGERED, CLEAR CURRENT POLYZONE VARIABLE
AddEventHandler("Utils:Client:ExitedZone", function()
    currentPolyzone = "None"
end)

-- WHEN TRIGGERED, RECORD CURRENT POLYZONE NAME TO VARIABLE
AddEventHandler("Utils:Client:EnteredZone", function(name)
    currentPolyzone = name or "Undefined"
end)

-- WHEN TRIGGERED, RESET ALL NUI INSTANCES
AddEventHandler("UI:Client:ResetNUI", function()
    CloseRadialMenu()
    SendNUIMessage({type = "Radial.Reset", fromLua = true})
end)
