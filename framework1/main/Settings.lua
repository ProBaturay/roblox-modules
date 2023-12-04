--[[ Creation time 14:44 2023-01-22 UTC+3 ]]
--[[ Written by ProBaturay ]]
--[[ Description

]]

--!strict

local Functions = require(script.Parent:WaitForChild("Functions", 1000))
local Callbacks = require(script:WaitForChild("Callbacks", 1000))

local derivedFunctions = Functions:RetrieveDerivedFunctions()

local tablesExpanded = false
local seperateArgumentsBy = ","
local maxLength = 5000
local showHexadecimalMemoryAddress = false
local showClientOrServer = false
local traceback = true
local stringsQuoted = true

type OutputSettings = {
	[number] : boolean | number | {[number] : any},
}

local outputSettings : OutputSettings = {
	["MaxLength"] = maxLength,
	["ShowClientOrServer"] = showClientOrServer,
	["Traceback"] = traceback,
	["StringsQuoted"] = stringsQuoted,
	["Tables"] = {
		["Expanded"] = tablesExpanded,
		["ShowHexadecimalMemoryAddress"] = showHexadecimalMemoryAddress,
	} :: {[number] : any},
	["SeparateArgumentsBy"] = seperateArgumentsBy
}

local protectedCallSettings = {
	["Yielding"] = true
}

local default_allSettings = {
	["Output"] = outputSettings,
	["ProtectedCall"] = protectedCallSettings
}

local function table_clone(tab, deepSearch : boolean?)
	if deepSearch then
		local clone = {}

		for i, v in tab do
			if type(v) == "table" then
				v = table_clone(v, true)
			end

			clone[i] = v
		end

		return clone
	else	
		return table.clone(tab)
	end
end

local function tablesHaveCommonKey(tab1, tab2, k)
	local found, indexed = false, {}

	for i, v in tab1 do
		table.insert(indexed, i)
	end

	for i, v in tab2 do
		if table.find(indexed, i) and i == k then
			found = true
			break
		end
	end

	return found
end

local function switchType(a : any) : (any)?
	if type(a) == "string" then
		a = tonumber(a) :: number
	end
	
	return a
end

local settingsCallbackFunctions = {}

local function pasteAllKeysInOneTable(tab : {[string] : any})	
	for i, v in tab do
		if type(v) == "table" then
			pasteAllKeysInOneTable(v)
		else
			settingsCallbackFunctions[i] = v
		end
	end
end

pasteAllKeysInOneTable(default_allSettings)
Callbacks:NonExistentCallbacks(settingsCallbackFunctions)

--print(settingsCallbackFunctions) --TODO: IMPORTANT!

local function call(t, firstLocation, lastLocation, value)
	if type(lastLocation) ~= "string" then 
		derivedFunctions.dwarn("Table key not matched; expected type 'string'. Key passed: " .. lastLocation)
	else
		if type(value) == "table" then
			if tablesHaveCommonKey(t, firstLocation, lastLocation) then
				for k2, v2 in t[lastLocation] do
					call(t[lastLocation] :: {[string] : any}, firstLocation[lastLocation] :: {[string] : any}, k2, v2)
				end
			else
				derivedFunctions.dwarn("Table key not matched; expected correct table key. Key passed: " .. lastLocation)
			end
		else
			local callback = Callbacks.Callbacks[lastLocation]
			
			if not callback then
				return derivedFunctions.dwarn("Could not update settings for '" .. lastLocation .. "':\nThe property doesn't exist.")
			end
			
			local intended, warning, func : any = callback(value)
			
			if warning and intended then
				derivedFunctions.dwarn(warning)
			end
			
			if (type(value) == type(firstLocation[lastLocation])) and intended then
				firstLocation[lastLocation] = value
			elseif intended then
				if func then
					firstLocation[lastLocation] = func()
				end
			else
				derivedFunctions.dwarn("Could not update settings for '" .. lastLocation .. "':\n" .. (warning :: string))
			end
		end
	end
end

local settings = table_clone(default_allSettings, true)

local settingsMetatable

settingsMetatable = {
	__newindex = function(tab, index, value)
		local lastValue = value
		
		local f 
			
		f = function(t : {any}, val : any, lastVal : any, i : number?)
			if typeof(val) ~= type(lastVal) then
				derivedFunctions.dwarn("Argument type assigning failed. Defaulting value.")

				if i then
					rawset(t, i, lastVal)
				else
					rawset(t, table.find(t, val) :: number, lastVal)
				end
			elseif type(val) == "table" then
				f(rawget(t, i :: number), val, lastVal, nil)
			end
		end
		
		f(tab, value, lastValue, index)
	end,
	
	__index = function(selfTab, index)		
		if index == "DefaultSettings" then
			local tab = setmetatable(table_clone(default_allSettings), settingsMetatable)
			
			return function(self)
				for k, v in tab do						
					call(tab, selfTab, k, v)
				end
			end
		elseif index == "Update" then
			return function(self, tab : {[string] : any})
				if type(tab) == "table" then
					local minimum = 0

					for k, v in tab do
						if minimum == 0 then
							minimum += 1
						else
							break
						end
					end

					if minimum == 0 then
						derivedFunctions.dwarn("Proper usage to default values: 'nil'")
					else			
						for k, v in tab do						
							call(tab, selfTab, k, v)
						end
					end
				elseif type(selfTab) ~= "table" then
					derivedFunctions.dwarn("Expected type 'table', got '" .. type(selfTab) .. "' instead.")
				end		
			end :: never
		else
			return rawget(selfTab, index)
		end
	end,
}

return setmetatable(settings, settingsMetatable)
