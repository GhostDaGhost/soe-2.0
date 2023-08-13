## SoE Challenge - Developed by GhostDaGhost
This page contains documentation for the SoE Challenge resource.

### Client Exports
---
|Export|Parameters|Return|Description
|-|-|-|-
|StartDrilling|-|Result (Bool)|Starts drilling minigame. Returns true if player successfully drilled or false if failed to drill.
|StartLockpicking|`Start`(Bool)|Result (Bool)|Starts lockpicking minigame based on the `Start` parameter. Always set it to true if you want to lockpick. Returns true if player successfully lockpicked or false if failed to lockpick.
|StartSafeCracking|`Combination`(Int)|Result (Bool)|Starts safecracking minigame. Returns true if player successfully cracked or false if failed to crack.
