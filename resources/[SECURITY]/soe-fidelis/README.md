## Client APIs

### Exports

##### ProcessAnticheat
```
Description: Instantly scans all players via the anticheat to catch any suspicious activity.

Arguments:
    None

Returns:
    Nothing

Examples:
    RegisterCommand(
        "test",
        function()
            exports["soe-fidelis"]:ProcessAnticheat()
        end
    )
```

##### AuthorizeTeleport
```
Description: Authorizes a teleport so the anticheat does not flag it.

Arguments:
    None

Returns:
    Nothing

Examples:
    RegisterCommand(
        "teleport",
        function()
            exports["soe-fidelis"]:AuthorizeTeleport()
            -- TELEPORT CODE HERE
        end
    )
```
