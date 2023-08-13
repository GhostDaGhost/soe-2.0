## SQL Connector Convars
```
Dev:
set mysql_connection_string "mysql://INSERT_USER:INSERT_PASSWORD@142.44.206.173/soegame2?charset=utf8mb4"

Live:
set mysql_connection_string "socketPath=/var/run/mysqld/mysqld.sock;user=INSERT_USER;password=INSERT_PASSWORD;database=soelog2;charset=utf8mb4"
```

## Server Exports

###### PerformAPIRequest
```
Description: Performs an API request using given arguments, and returns the response from the API in json encoded/ decoded form.

Arguments:
  - [route  STRING REQUIRED] API Route (/bank/someFunction and not api.route.com/bank/someFunction).
  - [data   STRING REQUIRED] API Data. For specific details, refer to API Documentation. Token is NOT required.
  - [decode   BOOL REQUIRED] Boolean argument for if you would like the returned JSON string to be decoded by default.


Returns:
  A JSON array containing the data returned by the API request. Refer to specific API documentation for details.
    
Example: 
  exports["soe-nexus"]:PerformAPIRequest("/api/inventory/get", string.format("invtype=%s&invdata=%s", "char", charid))

Important Notices:
  This function will return FALSE if there are critical errors with your API request (e.g. Connection Failure).
  It will NOT return false if the validation within your API request fails (e.g. missing parameters).
```

## Client Exports

###### RegisterServerCallback
```
Description: Returns data from a server event by triggering it on the client.

Arguments:
  - [event   STRING REQUIRED] Name of the server event (must be a valid event) e.g. Resource:Server:Event.
  - [arg_n      ANY REQUIRED] Arguments for the event. Add with traditional syntax (e.g. arg_1, arg_2, arg_3).


Returns:
  The value returned from the server event.
    
Example:

Client:
  local callback = exports["soe-nexus"]:TriggerServerCallback("Resource:Server:Event", "string_example", 80085)
  print(callback)

Server Event:
  AddEventHandler("Resource:Server:Event", function(cb, src, string_arg, integer_arg)
    -- Do normal function stuff here
    cb("value to be returned")
  end)

Important Notices:
  - Ensure that `cb` and `src` are required parameter definitions, and will be automatically populated.
  - The server event MUST execute `cb()` at the end of execution, or the promise will never resolve.
  - You should treat the export as a traditional `TriggerServerEvent()`, as it operates the same.
```