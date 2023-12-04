--[[ Creation time 01:41 2022-12-02 UTC+3 ]]
--[[ Written by ProBaturay ]]
--[[ Description

]]

--!strict

local PredefinedGlobals = require(script:WaitForChild("PredefinedGlobalFunctions", 1000))
local DerivedFunctions = require(script:WaitForChild("DerivedFunctions", 1000))

local functionManagement = {
	defaultDerivedFunctions = DerivedFunctions
}

function functionManagement:RetrieveBuiltinFunctions() : {[string] : any}
	return PredefinedGlobals:RetrieveAllPredefinedGlobals()
end

function functionManagement:RetrieveDerivedFunctions() : {[string] : any}
	return DerivedFunctions
end

function functionManagement:RewriteDerivedFunction(funcName : string, func : ((unknown) -> (unknown))?)
	if typeof(funcName) ~= "string" then
		return DerivedFunctions.dwarn("Expected type 'string', got '" .. typeof(funcName) .. "' instead.")
	elseif typeof(func) ~= "function" or typeof(func) ~= "nil" then
		return DerivedFunctions.dwarn("Expected type 'string', got '" .. typeof(funcName) .. "' instead.")
	end
	
	local funcInTable = table.find(DerivedFunctions, funcName)

	if not funcInTable then
		return DerivedFunctions.dwarn("The function name " .. funcName ..  "could not be found in table.")
	end
	
	DerivedFunctions[funcName] = if func then func else functionManagement.defaultDerivedFunctions[funcName]
end

return functionManagement
