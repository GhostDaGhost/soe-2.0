# SoE UI - A hive of all the UI things.
-----
#### Originally created by: GhostDaGhost
-----

## Client APIs

### Exports

##### HudVisible
```
Description: Returns if the main UI (status circles, vehicle UI) is visible or not.

Arguments: None

Returns:
    True if main UI is visible, false if not.

Examples:
    if exports["soe-ui"]:HudVisible() then
        --
    end
```

##### EnableBigGPS
```
Description: Turns on "big GPS mode", moving street display to top.

Arguments: None

Returns: Nothing

Examples:
    exports["soe-ui]:EnableBigGPS()
```

##### GetMinimap
```
Description: Returns if the minimap is visible or not.

Arguments: None

Returns:
    True if minimap is visible, false if not.

Examples:
    if exports["soe-ui"]:GetMinimap() then
        --
    end
```

##### ToggleMinimap
```
Description: Toggles minimap.

Arguments: None

Returns: Nothing

Examples:
    exports["soe-ui]:ToggleMinimap()
```

##### ShowTooltip
```
Description: Creates a tooltip in the bottom right.

Arguments:
    - Font Awesome icon
    - Message
    - Color Type of Message

Returns:
    None

Examples:
    exports["soe-ui"]:ShowTooltip("fas fa-globe", "[E] Inform Me", "inform")
```

##### SendAlert
```
Description: Creates a "Mythic" Notification on the top right

Arguments:
    - Color Type of Message
    - Message
    - Duration

Returns:
    None

Examples:
    exports["soe-ui"]:SendAlert("inform", "This is an Inform message", 5000)
    exports["soe-ui"]:SendAlert("error", "This is an Error message", 5000)
    exports["soe-notify"]:SendAlert("success", "This is a Success message", 5000)
```

##### SendUniqueAlert
```
Description: Creates a unique "Mythic" Notification on the top right. If an alert already exists with that unique ID it will simply update the existing alert and refresh the timer for the passed time. Allows you to prevent a massive amount of alerts being spammed.

Arguments:
    - Unique ID
    - Color Type of Message
    - Message
    - Duration

Returns:
    None

Examples:
    exports["soe-ui"]:SendUniqueAlert("Test1", "inform", "This is an Inform message", 5000)
```

##### PersistentAlert 
```
Description: Creates a persistent "Mythic" Notification on the top right that will persist on the screen until function is called again with end action.

Arguments:
    - Action
    - Unique ID
    - Color Type of Message
    - Message
    - Duration

Returns:
    None

Examples:
    exports["soe-ui"]:PersistentAlert("start", "Test", "inform", "This is an Inform message", 5000)

    exports["soe-ui"]:PersistentAlert("end", "Test")
```

### Events
##### UI:Client:ResetNUI
```
Description: Broadcasted when `/resetui` was triggered. Meant to reset any NUI instance.

Arguments: None

Examples:
    AddEventHandler("UI:Client:ResetNUI", function()
        --
    end)
```