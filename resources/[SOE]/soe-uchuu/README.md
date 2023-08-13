
## Client APIs

### Exports

###### GetPlayer
```
Description: Returns a table with data attributes for the user

Arguments:
  None

Returns:
    Table with the following data attributes that can be called:
      - Identifiers
        - ip
        - license
        - steam (If exists)
        - xbl (if exists)
        - live(if exists)
      - TimeJoined
      - LoggedIn
      - Account (If logged in)
        - UserID
        - Username
        - ForumAccount
      - Character (If character selected)
        - CharID
        - FirstGiven
        - LastGiven
        - DOB
        - CivType
        - CivType
        - Employer
        - JobTitle
        - PrisonTime
      - GameData
        - Hunger
        - Thirst
        - Position
    
Examples: 
  exports["soe-uchuu"]:GetPlayer().Character.CharID
  exports["soe-uchuu"]:GetPlayer().Account.UserID
  exports["soe-uchuu"]:GetPlayer().GameData.Hunger
  exports["soe-uchuu"]:GetPlayer().Identifiers.license
```

<br><br><br>
## Server APIs

### Exports

###### GetOnlinePlayerList
```
Description: Returns a table with data attributes for all players on the server. Organized by player source value.

Arguments:
  None

Returns:
    Table with the following data attributes that can be called by 'source':
      - Identifiers
        - ip
        - license
        - steam (If exists)
        - xbl (if exists)
        - live(if exists)
      - TimeJoined
      - LoggedIn
      - Account (If logged in)
        - UserID
        - Username
        - ForumAccount
      - Character (If character selected)
        - CharID
        - FirstGiven
        - LastGiven
        - DOB
        - CivType
        - CivType
        - Employer
        - JobTitle
        - PrisonTime
    
Examples: 
  exports["soe-uchuu"]:GetOnlinePlayerList()[2].Character.CharID
  exports["soe-uchuu"]:GetOnlinePlayerList()[2].Account.UserID
  exports["soe-uchuu"]:GetOnlinePlayerList()[2].TimeJoined
  exports["soe-uchuu"]:GetOnlinePlayerList()[2].Identifiers.license
```

###### IsDevServer
```
Description: Returns value depending on whether the server is currently a dev server or not.

Arguments:
    None

Returns:
    True if the server is a dev server. False if not.
    
Examples: 
  exports["soe-uchuu"]:IsDevServer()
```

###### IsTrainingServer
```
Description: Returns value depending on whether the server is currently a training server or not.

Arguments:
  None

Returns:
    True if the server is a training server. False if not.
    
Examples: 
    exports["soe-uchuu"]:IsTrainingServer()
```
