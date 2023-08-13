
## SOE-SHOPS README
**READ THIS:** The future is now. Remember when I said it would be more simple? Now it is!

### Client Exports
`NewTransaction(totalPrice, statementText, item)`

**Parameters:** 
- `totalPrice` - Price of the payment
- `statementText` - What will go on the bank statement if debit is used
- `item` - Table with item data for an item to give the player if successful
	- `item` - The item name/hash
	- `amt` - The amount of the item
	- `phoneStyle` - The phone style (Only for phones)

**Code Example:**
```lua
RegisterCommand("test", function(args)
	local transaction = exports["soe-shops"]:NewTransaction(1000, "A useless transaction!", {item = "cash", amt = 1000})

	if transaction then
		-- SUCCESS
	else
		-- FAILED
	end
end)
```
Contact Major with any questions!
