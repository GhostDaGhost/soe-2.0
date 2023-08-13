## Client APIs

### Exports

##### GetDisplayName
```
Description: Gets the character name and chooses how to display it

Arguments:
    None

Returns:
    If the player has a dog name set, their name will shows as: "Doggo" instead of "First Name"

    If the player is on duty, their name will show as: "Rank Last Name" instead of "First Name"

    If none of the above are done, their name will simply show as: "First Name"

Examples:
    local name = exports["soe-chat"]:GetDisplayName()
    print(string.format("Hi! My name is %s", name))

    For example, the print message would show like this:
    "Hi! My name is Michael"
```
