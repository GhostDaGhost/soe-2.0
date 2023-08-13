## Client APIs

### Exports

##### GetClosestPlayer
```
Description: Returns the closest player or nil if none found in range

Arguments:
    - How far (in meters) to search

Returns:
    Closest player or nil if none in range

Examples:
    exports["soe-utils"]:GetClosestPlayer(3.5)
```

##### GetVehInFrontOfPlayer
```
Description: Returns the closest vehicle or nil if none found in range

Arguments:
    - How far (in meters) to search
    - Should it search behind the player

Returns:
    Closest vehicle or nil if none in range

Examples:
    exports["soe-utils"]:GetVehInFrontOfPlayer(5.0, false)
```

##### GetWeaponNameFromHashKey
```
Description: Returns the weapon name (like 'WEAPON_COMBATPISTOL') of a weapon from hash

Arguments:
    - hash - Hash of weapon

Returns:
    Weapon name from hash

Examples:
    exports["soe-utils"]:GetWeaponNameFromHashKey(GetHashKey("WEAPON_COMBATPISTOL"))
```

##### IsModelADog
```
Description: Returns true if the player is a dog model

Arguments:
    None

Returns:
    True if the player is a dog model or false if not

Examples:
    if exports["soe-utils"]:IsModelADog then
        return true
    end
```

##### DrawTxt
```
Description: Draws text on screen

Arguments:
    - Too many to list. See code for details

Returns:
    Nothing

Examples:
    exports["soe-utils"]:DrawTxt("Test Text!", 0.5, 0.95, 0, {255, 255, 255, 255}, 0.5, true, true, false)
```

##### GetPedInFrontOfPlayer
```
Description: Finds ped in front of player

Arguments:
    - How far (in meters) to search
    - Should the ped be alive

Returns:
    Closest ped or nil if none in range

Examples:
    exports["soe-utils"]:GetPedInFrontOfPlayer(3.0, false)
```

##### ShowNotification
```
Description: Creates a native GTA notification on top of the minimap

Arguments:
    - Text

Returns:
    Nothing

Examples:
    exports["soe-utils"]:ShowNotification("Test Text!")
```

##### DrawText3D
```
Description: Draws text on props/anywhere in the map

Arguments:
    - X
    - Y
    - Z
    - Text
    - Draw Rectangle or not

Returns:
    Nothing

Examples:
    exports["soe-utils"]:DrawText3D(pos.x, pos.y, pos.z, "Test Text!", false)
```

##### Progress
```
Description: Creates a Mythic Progress Bar with animation/prop choices

Arguments:
    - Too many to list.

Returns:
    Nothing

Examples:
    exports["soe-utils"]:Progress(
        {
            name = "testBar",
            duration = 2000,
            label = "Test",
            useWhileDead = false,
            canCancel = false,
            controlDisables = {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = false
            }
        },
        function(cancelled)
            if cancelled == false then
                return true
            else
                return false
            end
        end
    )
```

##### HelpText
```
Description: Creates a native GTA notification on the top left

Arguments:
    - Text
    - Time

Returns:
    Nothing

Examples:
    exports["soe-utils"]:HelpText("Test Text", -1)
```

##### IsAnyDoorOpen
```
Description: Checks if any vehicle door is open

Arguments:
    - None

Returns:
    Returns true if a door is open or false if closed

Examples:
    if exports["soe-utils"]:IsAnyDoorOpen then
        return true
    end
```

##### GetAreaNames
```
Description: Returns a list of area zone names

Arguments:
    - None

Returns:
    Returns zone name

Examples:
    local zone = exports["soe-utils"]:GetAreaNames()[GetNameOfZone(pos.x, pos.y, pos.z)]
```

##### LoadAnimDict
```
Description: Load an animation dictionary if hasn't yet

Arguments:
    - Dictionary Name
    - Wait Time

Returns:
    Nothing

Examples:
    exports["soe-utils]:LoadAnimDict("example", 15)
```

##### LoadModel
```
Description: Load a prop dictionary if hasn't yet

Arguments:
    - Dictionary Name
    - Wait Time

Returns:
    Nothing

Examples:
    exports["soe-utils]:LoadModel("example", 15)
```

##### LoadAnimSet
```
Description: Load a animation set dictionary if hasn't yet

Arguments:
    - Dictionary Name
    - Wait Time

Returns:
    Nothing

Examples:
    exports["soe-utils]:LoadAnimSet("example", 15)
```

##### SpawnVehicle
```
Description: Spawn a vehicle at a specified location

Arguments:
    - Model Name or Hash
    - Location

Returns:
    Nothing

Examples:
    local veh = exports["soe-utils"]:SpawnVehicle("panto", vector4(pos.x, pos.y, pos.z, hdg))
```

##### MetaTool
```
Description: Activates the meta tool to show server IDs and blips of players.

Arguments:
    None

Returns:
    Nothing

Examples:
    RegisterCommand(
        "ameta",
        function()
            exports["soe-utils"]:MetaTool()
        end
    )
```

##### GrabVehicleColors
```
Description: Returns the color of vehicle with a custom name list.

Arguments:
    - None

Returns:
    Returns vehicle color name

Examples:
    TBD
```

##### GetLocation
```
Description: Returns the street, cross and zone of player's location

Arguments:
    - Entity Coordinates

Returns:
    Returns the street, cross and zone of player's location

Examples:
    local pos = GetEntityCoords(PlayerPedId())
    local location = exports["soe-utils"]:GetLocation(pos)
    print(location)

    WOULD LOOK LIKE THIS:
    Alta St in Pillbox Hill
```

##### GetDirection
```
Description: Returns the cardinal direction the player is facing

Arguments:
    - Entity Heading

Returns:
    Returns the cardinal direction the player is facing

Examples:
    local hdg = GetEntityHeading(PlayerPedId())
    local direction = exports["soe-utils"]:GetDirection(hdg)
    print(location)

    WOULD LOOK LIKE THIS:
    South
```

##### SetRentalStatus
```
Description: Sets vehicle as a rental

Arguments:
    - Vehicle

Returns:
    Nothing

Examples:
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    exports["soe-utils"]:SetRentalStatus(veh)
```

## Server API

### Exports

##### GetIdentifiersFromSource
```
Description: Returns a table with all identifiers of a certain player

Arguments:
    - Source

Returns: Nothing

Examples:
    exports["soe-utils"]:GetIdentifiersFromSource()[source]["ip"]
```
