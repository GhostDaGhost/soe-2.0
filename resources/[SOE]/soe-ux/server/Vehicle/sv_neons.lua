-- **********************
--       Commands
-- **********************
-- WHEN TRIGGERED, CONTROL NEON LIGHTS THROUGH COMMAND
RegisterCommand("neons", function(source, args)
    local src = source

    local type = "Controller"
    if (args[1] == nil) then
        type = "Controller"
    elseif (args[1] == "on") then
        type = "On"
    elseif (args[1] == "off") then
        type = "Off"
    elseif (args[1] == "flash") then
        type = "Flash"
    elseif (args[1] == "sequence") then
        type = "Sequence"
    elseif (args[1] == "colour" or args[1] == "color") then
        type = "Color"
    end
    TriggerClientEvent("UX:Client:DoNeonUnderglow", src, {status = true, type = type, r = tonumber(args[2]), g = tonumber(args[3]), b = tonumber(args[4])})
end)
