## Server APIs

### Exports

##### GetDutyCount
```
Description: Gets duty count of certain job types

Arguments:
    Job Type

Returns:
    Count of people on duty for it

Examples:
    RegisterCommand(
        "copdutycheck",
        function(source)
            local src = source
            local count = exports["soe-jobs"]:GetDutyCount("POLICE")
            print("WE HAVE " .. count .. " COPS ON DUTY!")
        end
    )
```
