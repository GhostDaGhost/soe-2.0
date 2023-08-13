## Client APIs

### Exports

##### GetPlayerInstance
```
Description: Returns the specified player's instance

Arguments:
    - The server ID of the player to return the instance name of

Returns:
    Instance ID of player, default is "global"

Examples:
    exports["soe-instance"]:GetPlayerInstance(-1)
    exports["soe-instance"]:GetPlayerInstance(GetPlayerServerId(PlayerId())) -- Redudant, but for example
```

##### GetEntityInstance
```
Description: Returns the specified entity's instance if registered with script

Arguments:
    - The network ID of the entity to return the instance name of

Returns:
    Instance ID of entity, default is "global" or nil if entity undefined

Examples:
    exports["soe-instance"]:GetEntityInstance(NetworkGetNetworkIdFromEntity(vehicle))
```

## Server API

### Exports

##### SetPlayerInstance
```
Description: Set a player's instance

Arguments:
    - Instance name, -1 will change to "global"
    - Server Id to set instance of

Returns: Nothing

Examples:
    exports["soe-instance"]:SetPlayerInstance("1234 Imagination Ct", source)
```

##### SetEntityInstance
```
Description: Set a entity's instance

Arguments:
    - Instance name, -1 will change to "global"
    - Network Id to set instance of

Returns: Nothing

Examples:
    exports["soe-instance"]:SetEntityInstance("1234 Imagination Ct", netID)
```
##### GetPlayerInstance
```
Description: Returns the specified player's instance

Arguments:
    - The server ID of the player to return the instance name of

Returns:
    Instance ID of player, default is "global" or nil if undefined

Examples:
    exports["soe-instance"]:GetPlayerInstance(source)
```

##### GetEntityInstance
```
Description: Returns the specified entity's instance if registered with script

Arguments:
    - The network ID of the entity to return the instance name of

Returns:
    Instance ID of entity, default is "global" or nil if entity undefined

Examples:
    exports["soe-instance"]:GetEntityInstance(netID)
```

### Events

##### Instance:Server:SetPlayerInstance
```
Description: Set a player's instance

Arguments:
    - Instance name, -1 will change to "global"
    - (Optional if from client) Server Id to set instance of

Returns: Nothing

Examples:
    From Client:
        TriggerServerEvent("Instance:Server:SetPlayerInstance", "1234 Imagination Ct")
    From Server:
        TriggerEvent("Instance:Server:SetPlayerInstance", "1234 Imagination Ct", source)
```

##### Instance:Server:SetEntityInstance
```
Description: Set a entity's instance

Arguments:
    - Instance name, -1 will change to "global"
    - Network Id to set instance of

Returns: Nothing

Examples:
    From Client:
        TriggerServerEvent("Instance:Server:SetEntityInstance", "1234 Imagination Ct", NetworkGetNetworkIdFromEntity(vehicle))
    From Server:
        TriggerEvent("Instance:Server:SetEntityInstance", "1234 Imagination Ct", netID)
```
