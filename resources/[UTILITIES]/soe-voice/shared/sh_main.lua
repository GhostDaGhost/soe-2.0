logger = {
	['log'] = function(message, ...)
		print((message):format(...))
	end,
	['info'] = function(message, ...)
		print(('[info] ' .. message):format(...))
	end,
	['warn'] = function(message, ...)
		print(('[^1WARNING^7] ' .. message):format(...))
	end,
	['error'] = function(message, ...)
		print(('[^1ERROR^7] ' .. message):format(...))
	end,
	['verbose'] = function(message, ...)
		print(('[verbose] ' .. message):format(...))
	end,
}

function tPrint(tbl, indent)
	indent = indent or 0
	for k, v in pairs(tbl) do
		local tblType = type(v)
		formatting = string.rep("  ", indent) .. k .. ": "
		if tblType == "table" then
			print(formatting)
			tPrint(v, indent + 1)
		elseif tblType == 'boolean' then
			print(formatting .. tostring(v))
		elseif tblType == "function" then
			print(formatting .. tostring(v))
		else
			print(formatting .. v)
		end
	end
end
