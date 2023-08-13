## SoE Inventory - Developed by Major (Code) and GBJoel (UI) - 2.0 Re-write by Boba
This page contained documentation for the SoE Inventory resource. This resource *must* be run alongside the SoE base resource (Current: `uchuu`)

### Client Exports
---
|Export|Parameters|Return|Description
|-|-|-|-
|RequestInventory|-|Inventory(s) (Table)|Returns a table value for all open inventories for the current character.
|GetItemAmt|`itemtype`(string) <br> `invSide`(string)|Total amount of items matching `itemtype` as an `int` value|Get amount of items in the current character's inventory<br>`itemtype` Name of the item you want to search for.<br>`invSide` The inventory to search. (left, right, both)
|GetItemData|`itemtype`(string) <br> `invSide`(string)|Row value for items matching `itemtype` as a table value.|Get all of the rows matching `itemtype` in the current character's inventory.<br>`itemtype` Name of the item you want to search for.<br>`invSide` The inventory to search. (left, right, both)

### Server Exports
---
|Export|Parameters|Return|Description
|-|-|-|-
|RequestInventory|`src`(int)<br>`type`(string)<br>`server`(bool)|Inventory(s) (Table)|Returns a table value for all current open inventories directly from the API request.<br> `src` ServerID of player requested.<br> `type` Unused for now, set to 'all' or leave `nil`.<br> `server` Must **always** be set to true to ensure response is returned.<br>
|AddItem|`src`(int)<br> `invtype`(string)<br> `invdata`(int)<br> `itemtype`(string)<br> `itemamt`(int)<br> `itemmeta`(json)<br>|API response (Table)|Add Item export. TODO: parameters
|ModifyItem|`src`(int)<br> `type`(string)<br> `data`(int)<br> `amt`(int)<br> `name`(string)<br> `id`(int)|API response (Table)|Modify existing item export. TODO: parameters
|UseItem|`src`(int)<br> `itemid`(int)<br> `amt`(int)<br> `invtype`(string)<br> `itemname`(string)<br> `invdata`(int)|API response (Table)|Use item export. TODO: parameters
|ModifyItemMeta|`itemid`(int)<br> `itemmeta`(json)|API response (Table)|Modify existing item export.<br>`itemid` ID of the item being modified.<br>`itemmeta` The JSON table containing updated metadata.
|GetItemAmt|`src`(int)<br> `itemtype`(string) <br> `invSide`(string)|Total amount of items matching `itemtype` as an `int` value|Get amount of items in player's inventory<br>`src` Player ServerID to get inventory from.<br>`itemtype` Name of the item you want to search for.<br>`invSide` The inventory to search. (left, right, both)
|GetItemData|`src`(int)<br> `itemtype`(string) <br> `invSide`(string)|Row value for items matching `itemtype` as a table value.|Get all of the rows matching `itemtype` in a player's inventory.<br>`src` Player ServerID to get inventory from.<br>`itemtype` Name of the item you want to search for.<br>`invSide` The inventory to search. (left, right, both)