RegisterNetEvent("Nexus:Server:ProcessServerCallback")
AddEventHandler("Nexus:Server:ProcessServerCallback", function(event, ticket, ...)
    local src = source
	local p = promise.new()

    TriggerEvent(event, function(...)
		p:resolve({...})
	end, src, ...)

	local result = Citizen.Await(p)

	TriggerClientEvent(('Nexus:Client:ServerCallbackEvent:%s:%s'):format(event, ticket), src, table.unpack(result))
end)