--[[ Creation time 13:56 2023-01-22 UTC+3 ]]
--[[ Written by ProBaturay ]]
--[[ Description

]]

--!strict

local timeOut = 100

local FunctionsModule = require(script:WaitForChild("Functions", timeOut))
local SettingsModule = require(script:WaitForChild("Settings", timeOut))

export type DerivedLuaFunctions = {
	CreateGlobalFunction : (self : DerivedLuaFunctions, functionList : {[number] : string}?) -> (),
	DefaultAllFunctions : (self : DerivedLuaFunctions) -> (),
	DefaultFunction : (self : DerivedLuaFunctions, functionName : string) -> (),
	ResetAllFunctions : (self : DerivedLuaFunctions) -> (),
	ResetFunction : (self : DerivedLuaFunctions, functionName : string) -> (),
	RetrieveFunctions : (self : DerivedLuaFunctions) -> (typeof(FunctionsModule:RetrieveDerivedFunctions())),
	RetrieveSettings : (self : DerivedLuaFunctions) -> (typeof(SettingsModule)),
	Start : (self : DerivedLuaFunctions) -> (),
	UpdateSettings : (self : DerivedLuaFunctions, settingsList : {[string] : any}?) -> (),
}

local unverifiedGlobalFunctions = {}

local derivedFunctions = FunctionsModule:RetrieveDerivedFunctions()
local builtinFunctions = FunctionsModule:RetrieveBuiltinFunctions()

derivedFunctions.AllSettings = SettingsModule

local function unverifyGlobalized(funcName : string)
	if not table.find(unverifiedGlobalFunctions, funcName) then
		table.insert(unverifiedGlobalFunctions, funcName)
	end
	
	if not builtinFunctions[funcName] then
		getfenv(0)[funcName] = function()
			if table.find(unverifiedGlobalFunctions, funcName) then
				derivedFunctions.dwarn("The function '" .. funcName .. "' has not been globalized. Please use CreateGlobalFunction() to register a global function.")
			end
		end
	end
end

local function createGlobalFunction_mutual(funcName)
	if table.find(unverifiedGlobalFunctions, funcName) then
		getfenv(0)[funcName] = derivedFunctions[funcName]

		if table.find(unverifiedGlobalFunctions, funcName) then
			table.remove(unverifiedGlobalFunctions, table.find(unverifiedGlobalFunctions, funcName))
		end
	else
		derivedFunctions.dwarn("Expected non-global function name, got global function name instead.")
	end
end

local derivedLuaFunctions = {
	Settings = SettingsModule,
	started = false,
}

local function onWarningStart() : boolean
	derivedFunctions.dwarn("The module must be set up using Start() function first.")

	return false
end

local metatable = {
	__index = function(tab, index : string)
		local get = derivedLuaFunctions[index]

		if get then
			if derivedLuaFunctions.started or index == "Start" then
				return get
			else
				return onWarningStart()
			end
		else
			return derivedFunctions.dwarn("The function '" .. index .. "' not found in the module.")
		end
	end,
	__metatable = true
}

function derivedLuaFunctions:Start()
	if derivedLuaFunctions.started then
		return derivedFunctions.dwarn("The module has already been set up and in use.")
	end
	
	derivedLuaFunctions.started = true

	for i, func in derivedFunctions do
		unverifyGlobalized(i)
	end
end

function derivedLuaFunctions:RetrieveFunctions()
	return FunctionsModule:RetrieveDerivedFunctions()
end

function derivedLuaFunctions:CreateGlobalFunction(tab : {[number] : string}?)	
	if tab == nil then -- Replace all functions
		for k, v in derivedFunctions do
			createGlobalFunction_mutual(k)
		end
	elseif typeof(tab) == "table" then
		for i, v in tab do
			if typeof(derivedFunctions[v]) == "function" then
				createGlobalFunction_mutual(v)
			else
				derivedFunctions.dwarn("Expected non-global function name, got name '" .. v .. "' instead.")
			end
		end
	end
end

function derivedLuaFunctions:DefaultFunction(funcName : string)	
	if typeof(funcName) ~= "string" then
		return derivedFunctions.dwarn("Expected type 'function', got '" .. typeof(funcName) .. "' instead.")
	end
	
	if funcName ~= "dwarn" then
		getfenv(0)[funcName] = FunctionsModule.defaultDerivedFunctions[funcName]
	end
end

function derivedLuaFunctions:ResetFunction(funcName : string)
	if typeof(funcName) ~= "string" then
		return derivedFunctions.dwarn("Expected type 'function', got '" .. typeof(funcName) .. "' instead.")
	end
	
	local builtin = FunctionsModule:RetrieveBuiltinFunctions()
	
	if builtin[funcName] then
		getfenv(0)[funcName] = builtin[funcName]
	elseif derivedFunctions[funcName] then
		unverifyGlobalized(funcName)
	else
		return derivedFunctions.dwarn("Expected correct function name, got '" .. funcName .. "' instead.")
	end
end

function derivedLuaFunctions:ResetAllFunctions()	
	for i, v in FunctionsModule:RetrieveBuiltinFunctions() do
		derivedFunctions[i] = v
	end
	
	for name, func in derivedFunctions do
		derivedLuaFunctions:ResetFunction(name)
	end
end

function derivedLuaFunctions:DefaultAllFunctions()
	for name, v in FunctionsModule.defaultDerivedFunctions :: {[string] : any} do
		derivedLuaFunctions:DefaultFunction(name)
	end
end

function derivedLuaFunctions:RetrieveSettings()
	return SettingsModule
end

function derivedLuaFunctions:UpdateSettings(tab : {[string] : any}?)
	if tab == nil then
		SettingsModule:DefaultSettings()
	else
		SettingsModule:Update(tab)
	end
end

return setmetatable({}, metatable)
