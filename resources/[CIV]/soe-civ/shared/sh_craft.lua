craft = {}

craft.campFire = {
    name = "Camp Fire",
    recipes = {
        {
            name = "Cooked Boar Meat", itemIcon = "🥩", itemName = "cookedboarmeat", itemDisplayName = "Cooked Boar Meat", amount = 1, craftTime = 5000,
            ingredients = {
                {itemName = "boarmeat", itemDisplayName = "Boar Meat", requiredAmount = 1},
            },
        },
        {
            name = "Cooked Game Meat", itemIcon = "🥩", itemName = "cookedgame", itemDisplayName = "Cooked Game Meat", amount = 1, craftTime = 5000,
            ingredients = {
                {itemName = "smallgamemeat", itemDisplayName = "Small Game Meat", requiredAmount = 1},
            },
        },
        {
            name = "Cooked Venison", itemIcon = "🥩", itemName = "cookedvenison", itemDisplayName = "Cooked Venison", amount = 1, craftTime = 5000,
            ingredients = {
                {itemName = "deermeat", itemDisplayName = "Deer Meat", requiredAmount = 1},
            },
        },
    },
}