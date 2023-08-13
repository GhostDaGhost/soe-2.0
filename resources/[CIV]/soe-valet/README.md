## Client APIs

### Exports

##### HasKey
```
Description: Returns whether the player has a key to the vehicle specified 

Arguments:
    - Vehicle

Returns:
    True if the player has a key to the vehicle specified. False if not.

Examples:
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    local hasKey = exports["soe-valet"]:HasKey(veh)
    if not hasKey then
        print("DOES NOT HAVE KEY)
        return
    end
```

##### UpdateKeys
```
Description: Gives the player keys to the vehicle specified 

Arguments:
    - Vehicle

Returns:
    Nothing

Examples:
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    exports["soe-valet"]:UpdateKeys(veh)
```
