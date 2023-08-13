## Client APIs

### Exports

##### OpenInputDialogue
```
Description: Opens an input box to type numbers or words into it

Arguments:
    - Type of Input (number, text, charid)
    - Title

Returns:
    None

Examples:
    exports["soe-input"]:OpenInputDialogue("text", "What would you like the print message to say?", function(returnData)
        if returnData ~= nil then
            print(returnData)
        end
    end)
```

##### OpenConfirmDialogue
```
Description: Opens a confirm box with yes/no options (Customizable) to confirm a user's selection

Arguments:
    - Message (Are you sure you'd like to...)
    - Yes/Confirm Text (Yes, Confirm, Sure, etc.)
    - No/Decline Text (No, Nah, etc.)

Returns:
    true/false via CB

Examples:
    exports["soe-input"]:OpenConfirmDialogue("Are you sure you want to do this?", "Yes", "No", function(returnData)
        if returnData then
            -- CONFIRMED
        else
            -- DECLINED
        end
    end)
```

##### OpenSelectDialogue
```
Description: Opens a selection dialogue with provided options

Arguments:
    - Message (Please select...)
    - Options (A table with options - {"Option1", "Option2", "Option 3"})

Returns:
    selection option/nil via CB - nil indicates they cancelled/backed out

Examples:
    exports["soe-input"]:OpenSelectDialogue("What kind of key would you like to give this person?", {"Tenant Key", "Guest Key"}, function(returnData)
        if not returnData then
            -- THEY CANCELLED
        else
            print(returnData) -- WHATEVER THEY SELECTED
        end
    end)
```
