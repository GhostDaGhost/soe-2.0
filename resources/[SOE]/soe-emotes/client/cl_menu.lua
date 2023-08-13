local menuV = assert(MenuV)
local isEmoteMenuOpen = false
local emoteMenu = menuV:CreateMenu("Animations", "Dance party!", "topright", 53, 4, 133, "size-125", "default", "menuv", "emoteMenu", "default")

-- SORTS A TABLE IN ALPHABETICAL ORDER
local function SortByAlphabet(t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    table.sort(a, f)

    local i = 0
    local iter = function()
        i = i + 1
        if (a[i] == nil) then
            return nil
        else
            return a[i], t[a[i]]
        end
    end
    return iter
end

-- OPENS EMOTE MENU
local function OpenEmoteMenu()
    if isEmoteMenuOpen then return end
    -- CLEARS ITEMS IF MENU IS ALREADY OPEN
    emoteMenu:ClearItems()

    -- CREATE SUBMENUS
    exports["soe-ui"]:SendAlert("inform", "Loading emote menu...", 7000)
    local emotes = menuV:InheritMenu(emoteMenu, {["title"] = false, ["subtitle"] = "Choose an emote"})
    emoteMenu:AddButton({icon = "🎭", label = "Animations", value = emotes})
    if not exports["soe-utils"]:IsModelADog(PlayerPedId()) then
        for index, emote in SortByAlphabet(animations) do
            local emoteButtonTxt = ("%s <span style='float:right;'> /e %s</span>"):format(emote.name, index)
            local emoteButton = emotes:AddButton({icon = "", label = emoteButtonTxt, select = function()
                PlayAnimation(emote)
            end})
            Wait(1)
        end
    else
        for index, emote in SortByAlphabet(dogAnimations) do
            local emoteButtonTxt = ("%s <span style='float:right;'> /e %s</span>"):format(emote.name, index)
            local emoteButton = emotes:AddButton({icon = "", label = emoteButtonTxt, select = function()
                PlayAnimation(emote)
            end})
        end
    end

    local walkstyleMenu = menuV:InheritMenu(emoteMenu, {["title"] = false, ["subtitle"] = "Choose a walkstyle"})
    emoteMenu:AddButton({icon = "🚶", label = "Walkstyles", value = walkstyleMenu})
    for index, walk in SortByAlphabet(walkstyles) do
        local walkButtonTxt = ("%s <span style='float:right;'> /walk %s</span>"):format(walk.name, index)
        local walkButton = walkstyleMenu:AddButton({icon = "", label = walkButtonTxt, select = function()
            SetWalkstyle(walk)
        end})
    end

    local expressions = menuV:InheritMenu(emoteMenu, {["title"] = false, ["subtitle"] = "Choose an expression"})
    emoteMenu:AddButton({icon = "😉", label = "Facial Expressions", value = expressions})
    for index, expression in SortByAlphabet(faceExpressions) do
        local moodButtonTxt = ("%s <span style='float:right;'> /mood %s</span>"):format(expression.name, index)
        local moodButton = expressions:AddButton({icon = "", label = moodButtonTxt, select = function()
            PlayFacialExpression(expression)
        end})
    end

    local aimingStylesMenu = menuV:InheritMenu(emoteMenu, {["title"] = false, ["subtitle"] = "Choose an aiming style"})
    emoteMenu:AddButton({icon = "🔫", label = "Aiming Styles", value = aimingStylesMenu})
    for styleID, style in SortByAlphabet(aimingStyles) do
        local aimButtonTxt = ("%s <span style='float:right;'> /aim %s</span>"):format(style.name, styleID)
        local aimButton = aimingStylesMenu:AddButton({icon = "", label = aimButtonTxt, select = function()
            PlayAimingStyle(style)
        end})
    end

    emoteMenu:Open()
    isEmoteMenuOpen = true
end

-- ON MENU CLOSED
emoteMenu:On("close", function(menu)
    isEmoteMenuOpen = false
end)

-- CALLED FROM SERVER AFTER "/emotemenu" IS EXECUTED
RegisterNetEvent("Emotes:Client:OpenEmoteMenu")
AddEventHandler("Emotes:Client:OpenEmoteMenu", OpenEmoteMenu)
