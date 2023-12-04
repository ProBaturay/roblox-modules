--[[ Creation time 14:01 2023-01-31 UTC+3 ]]
--[[ Written by ProBaturay ]]
--[[ Description

]]

--!nolint DeprecatedGlobal
--!strict

-- Roblox Built-in Globals

local builtin_print = print
local builtin_delay = delay
local builtin_Delay = Delay
local builtin_elapsedTime = elapsedTime
local builtin_ElapsedTime = ElapsedTime
local builtin_gcinfo = gcinfo
local builtin_printidentity = printidentity
local builtin_require = require
local builtin_settings = settings
local builtin_spawn = spawn
local builtin_Spawn = Spawn
local builtin_stats = stats
local builtin_Stats = Stats
local builtin_tick = tick
local builtin_time = time
local builtin_typeof = typeof
local builtin_UserSettings = UserSettings
local builtin_version = version
local builtin_Version = Version
local builtin_wait = wait
local builtin_Wait = Wait
local builtin_warn = warn
local builtin_ypcall = ypcall

-- Lua Built-in Globals

local builtin_assert = assert
local builtin_collectgarbage = collectgarbage
local builtin_error = error
local builtin_getfenv = getfenv
local builtin_getmetatable = getmetatable
local builtin_ipairs = ipairs
local builtin_loadstring = loadstring
local builtin_newproxy = newproxy
local builtin_next = next
local builtin_pairs = pairs
local builtin_pcall = pcall
local builtin_print = print
local builtin_rawequal = rawequal
local builtin_rawget = rawget
local builtin_rawset = rawset
local builtin_select = select
local builtin_setfenv = setfenv
local builtin_setmetatable = setmetatable
local builtin_tonumber = tonumber
local builtin_tostring = tostring
local builtin_type = type
local builtin_unpack = unpack
local builtin_xpcall = xpcall

local robloxGlobalFunctions : {[string] : any} = {
	["delay"] = builtin_delay,
	["Delay"] = builtin_Delay,
	["elapsedTime"] = builtin_elapsedTime,
	["ElapsedTime"] = builtin_ElapsedTime,
	["gcinfo"] = builtin_gcinfo,
	["printidentity"] = builtin_printidentity,
	["require"] = builtin_require,
	["settings"] = builtin_settings,
	["spawn"] = builtin_spawn,
	["Spawn"] = builtin_Spawn,
	["stats"] = builtin_stats,
	["Stats"] = builtin_Stats,
	["tick"] = builtin_tick,
	["time"] = builtin_time,
	["typeof"] = builtin_typeof,
	["UserSettings"] = builtin_UserSettings,
	["version"] = builtin_version,
	["Version"] = builtin_Version,
	["wait"] = builtin_wait,
	["Wait"] = builtin_Wait,
	["warn"] = builtin_warn,
	["ypcall"] = builtin_ypcall
}

local luaGlobalFunctions : {[string] : any} = {
	["assert"] = builtin_assert,
	["collectgarbage"] = builtin_collectgarbage,
	["error"] = builtin_error,
	["getfenv"] = builtin_getfenv,
	["getmetatable"] = builtin_getmetatable,
	["ipairs"] = builtin_ipairs,
	["loadstring"] = builtin_loadstring,
	["newproxy"] = builtin_newproxy,
	["next"] = builtin_next,
	["pairs"] = builtin_pairs,
	["pcall"] = builtin_pcall,
	["print"] = builtin_print,
	["rawequal"] = builtin_rawequal,
	["rawget"] = builtin_rawget,
	["rawset"] = builtin_rawset,
	["select"] = builtin_select,
	["setfenv"] = builtin_setfenv,
	["setmetatable"] = builtin_setmetatable,
	["tonumber"] = builtin_tonumber,
	["tostring"] = builtin_tostring,
	["type"] = builtin_type,
	["unpack"] = builtin_unpack,
	["xpcall"] = builtin_xpcall,
}

local globals = {}

function globals:RetrieveLuaGlobals()
	return luaGlobalFunctions
end

function globals:RetrieveRobloxGlobals()
	return robloxGlobalFunctions
end

function globals:RetrieveAllPredefinedGlobals() : {[string] : () -> ()}
	local allGlobals = globals:RetrieveLuaGlobals()
	
	for i, v in globals:RetrieveRobloxGlobals() do
		allGlobals[i] = v
	end
	
	return allGlobals
end

export type PredefinedGlobals = typeof(globals:RetrieveAllPredefinedGlobals())

return globals
