## SoE Utilities - Developed by GhostDaGhost (Code) and Major (Code)

This page contains documentation for the SoE Utilities resource. This resource *must* be run alongside the SoE base resource (Current: `uchuu`)

### Client Exports
---
|Export|Parameters|Return|Description
|-|-|-|-
|GetClosestPlayer|`range` (int)|Closest player's server ID.|Gets the closest player's server ID within the `range`.
|GetVehInFrontOfPlayer|`range` (int) <br> `searchBehind` (bool)|The vehicle that the player is facing (or behind if the boolean value of `searchBehind` is true) within the `range`.|Get the vehicle entity that the player is facing or in front of within `range`.
|GetWeaponNameFromHashKey|`hash` (int)|"WEAPON_" name of the weapon's `hash` entered.|Gets the `hash`'s assigned "WEAPON_" name.
|IsModelADog|N/A|Boolean value.|Returns if the player is a dog model.
|DrawTxt|`text` (string) <br> `x` (int) <br> `y` (int) <br> `font` (int) <br> `color` (table) <br> `scale` (int) <br> `center` (bool) <br> `shadow` (bool) <br> `alignRight` (bool)|N/A|Draws text on the screen based on the parameters entered within a loop.
|GetPedInFrontOfPlayer|

### Server Exports
---
|Export|Parameters|Return|Description
|-|-|-|-
