## Client APIs

### Exports

##### IsDead
```
Description: Returns if the player has died and is needing respawn/medevac

Arguments:
    None

Returns:
    If the player is dead or not

Examples:
    if exports["soe-emergency"]:IsDead() then
        return true
    end
```

##### GetCurrentCops
```
Description: Returns the amount of police on duty

Arguments:
    None

Returns:
    Returns the amount of police currently on duty

Examples:
    if exports["soe-emergency"]:GetCurrentCops() > 0 then
        print("Cops On Duty!")
    end
```

##### GetCurrentEMS
```
Description: Returns the amount of paramedics on duty

Arguments:
    None

Returns:
    Returns the amount of paramedics currently on duty

Examples:
    if exports["soe-emergency"]:GetCurrentEMS() > 0 then
        print("EMS On Duty!")
    end
```

##### IsImprisoned
```
Description: Returns whether the character is in prison or not

Arguments:
    None

Returns:
    Returns true if the character is in prison or false if not in prison

Examples:
    if exports["soe-emergency"]:IsImprisoned then
        print("Currently in prison!")
    end
```

##### IsInRehab
```
Description: Returns whether the character is in rehab or not

Arguments:
    None

Returns:
    Returns true if the character is in rehab or false if not in rehab

Examples:
    if exports["soe-emergency"]:IsInRehab then
        print("Currently in rehab!")
    end
```

##### ShouldReportInThisArea
```
Description: Returns whether an event could be reported by locals in the area

Arguments:
    None

Returns:
    Returns true if a local has spotted said event. False if not.

Examples:
    local shouldReport = false

    shouldReport = exports["soe-emergency"]:ShouldReportInThisArea()
    if showReport then
        print("Test")
    end
```

##### IsHandcuffed
```
Description: Returns whether the player is handcuffed or not.

Arguments:
    None

Returns:
    Returns true if a player is handcuffed. False if not.

Examples:
    if exports["soe-emergency]:IsRestrained() then
        return false
    end
```
