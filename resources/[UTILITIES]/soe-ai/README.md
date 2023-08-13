## SOE-AI README
**READ THIS:** Don't attempt to use this API unless you know what you're doing.
You have two ways to do this. Follow the formatting inside *sh_npcs.lua* or use the following export. 

### Client Exports
---
`RegisterNPC(data)`
**Parameters:** A table with specific data to configure the NPC.

**Code Example:**
```lua
RegisterCommand("testspawn", function()
    local npcData = {
        type = 4,
        uid = "chopshop1",
        model = "ig_cletus",
        networked = false,
        pos = vector3(2340.66, 3126.09, 48.21),
        dist = 120.0,
        hdg = 356.66,
        scenario = "WORLD_HUMAN_CLIPBOARD",
        settings = {
            {setting = "invincible", state = true},
            {setting = "ignore", state = true},
            {setting = "ragdoll", state = false},
            {setting = "noDrugs", state = true},
            {setting = "noMugging", state = true}
        }
    }

    exports["soe-ai"]:RegisterNPC(npcData)
end)
```
Contact GhostDaGhost with any questions!
