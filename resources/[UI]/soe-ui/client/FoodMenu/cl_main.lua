-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, SHOW A FOOD MENU
function ShowFoodMenu(imageName)
    SetNuiFocus(true, true)
    SendNUIMessage({type = "FoodMenu.OpenUI", imageName = imageName})
end
exports("ShowFoodMenu", ShowFoodMenu)

-- **********************
--     NUI Callbacks
-- **********************
-- WHEN TRIGGERED, SHUT NUI FOCUS OFF
RegisterNUICallback("FoodMenu.CloseUI", function()
    SetNuiFocus(false, false)
end)
