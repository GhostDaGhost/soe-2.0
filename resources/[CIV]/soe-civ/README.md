## Client APIs

### Exports

##### IsDragging
```
Description: Returns if the player is currently dragging someone

Arguments:
    None

Returns:
    If the player is dragging another player or not

Examples:
    if exports["soe-civ"]:IsDragging() then
        return true
    end
```

##### IsDragged
```
Description: Returns if the player is currently being dragged

Arguments:
    None

Returns:
    If the player is being dragged by another player

Examples:
    if exports["soe-civ"]:IsDragged() then
        return true
    end
```

##### IsEscorting
```
Description: Returns if the player is currently escorting someone

Arguments:
    None

Returns:
    If the player is escorting another player or not

Examples:
    if exports["soe-civ"]:IsEscorting() then
        return true
    end
```

##### IsEscorted
```
Description: Returns if the player is currently being escorted

Arguments:
    None

Returns:
    If the player is being dragged by another player

Examples:
    if exports["soe-civ"]:IsEscorted() then
        return true
    end
```

##### IsCarrying
```
Description: Returns if the player is currently carrying someone

Arguments:
    None

Returns:
    If the player is carrying another player or not

Examples:
    if exports["soe-civ"]:IsCarrying() then
        return true
    end
```

##### IsCarried
```
Description: Returns if the player is currently being carried

Arguments:
    None

Returns:
    If the player is being carried by another player

Examples:
    if exports["soe-civ"]:IsCarried() then
        return true
    end
```
