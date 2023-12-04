--[[ Creation time 22:25 2023-02-03 UTC+3 ]]
--[[ Written by ProBaturay ]]
--[[ Description

]]

--!strict

local allowedMaxLength = 5000

local callbacks = {
	Callbacks  = {
		["MaxLength"] = function(maxLength : (string | number))
			if type(maxLength) == "number" then
				local floor_maxLength = math.floor(maxLength :: number)

				if maxLength ~= floor_maxLength then
					return false, "Expected number type 'integer', got 'non-integer' instead."
				else
					if maxLength > allowedMaxLength then
						return true, allowedMaxLength .. " characters can be output at most each time. Setting the maximum length to " .. allowedMaxLength .. ".", function()
							return allowedMaxLength
						end
					else
						return true, nil, function()
							return maxLength
						end
					end
				end
			elseif typeof(maxLength) == "string" then
				local tonumber_maxLength = tonumber(maxLength)

				if type(tonumber_maxLength) == "number" then
					local floor_maxLength = math.floor(tonumber_maxLength)

					if tonumber_maxLength ~= floor_maxLength then
						return false, "Expected number type 'integer (string)', got 'non-integer (string)' instead."
					else
						if tonumber_maxLength > allowedMaxLength then
							return true, allowedMaxLength .. " characters can be output at most each time. Setting the maximum length to " .. allowedMaxLength .. ".", function()
								return allowedMaxLength
							end
						else
							return true, nil, function()
								return tonumber_maxLength
							end
						end
					end
				else
					return false, "Expected number type 'integer (string)', got '" .. type(maxLength) .. "' instead."
				end
			else
				return false, "Expected type 'number', got '" .. type(maxLength) .. "' instead."
			end			
		end,
		
		["ShowHexadecimalMemoryAddress"] = function(a : boolean)
			if type(a) ~= "boolean" then
				return false, "Expected type 'boolean', got '" .. type(a) .. "' instead."
			end

			return true
		end,
		
		["ShowClientOrServer"] = function(a : boolean)
			if type(a) ~= "boolean" then
				return false, "Expected type 'boolean', got '" .. type(a) .. "' instead."
			end

			return true
		end,
		
		["Traceback"] = function(a : boolean)
			if type(a) ~= "boolean" then
				return false, "Expected type 'boolean', got '" .. type(a) .. "' instead."
			end

			return true
		end,
		
		["Expanded"] = function(a : boolean)
			if type(a) ~= "boolean" then
				return false, "Expected type 'boolean', got '" .. type(a) .. "' instead."
			end

			return true
		end,
		
		["SeparateArgumentsBy"] = function(a : string)
			if type(a) ~= "string" then
				return false, "Expected type 'string', got '" .. type(a) .. "' instead."
			end

			return true
		end,
		
		["StringsQuoted"] = function(a : boolean)
			if type(a) ~= "boolean" then
				return false, "Expected type 'string', got '" .. type(a) .. "' instead."
			end

			return true
		end,
		
		["Yielding"] = function(a : boolean)
			if type(a) ~= "boolean" then
				return false, "Expected type 'boolean', got '" .. type(a) .. "' instead."
			end

			return true
		end,
		
	} :: {[string] : (any) -> (boolean, string?, ((any) -> (any))?)}
}

function callbacks:NonExistentCallbacks(names)
	for name, _ in names do
		if not self.Callbacks[name] then
			error("The callback name '" .. name .. "' was not found. Please report it to the developer to fix the error.")
		end
	end
end

return callbacks
