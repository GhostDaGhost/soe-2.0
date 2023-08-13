--[[
    @param event - The server event that will be triggered for the callback.
    @param args - Array of arguments to be passed to server callback event.
    @return - Returned value from server callback event.
]]
function TriggerServerCallback(event, ...)
    local ticket = GetGameTimer()
    local p = promise.new()

    RegisterNetEvent(('Nexus:Client:ServerCallbackEvent:%s:%s'):format(event, ticket))

    local e = AddEventHandler(('Nexus:Client:ServerCallbackEvent:%s:%s'):format(event, ticket), function(...)
        p:resolve({...})
    end)

    TriggerServerEvent("Nexus:Server:ProcessServerCallback", event, ticket, ...)

    local result = Citizen.Await(p)

	RemoveEventHandler(e)
	return table.unpack(result)
end