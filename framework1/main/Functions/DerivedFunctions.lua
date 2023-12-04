--[[ Creation time 16:35 2023-01-31 UTC+3 ]]
--[[ Written by ProBaturay ]]
--[[ Description

]]
--[[TODO:
ypcall done

--]]
--!nolint DeprecatedGlobal
--!strict

--TODO: last index not being removed
--Developer console doesn't support U+0009

local RunService = game:GetService("RunService")

export type DerivedFunctions = {
	print: (DerivedFunctions, ...(string | {[any] : any} | boolean)) -> (),
	warn: (DerivedFunctions, ...(string | {[any] : any} | boolean)) -> (),
}

local derivedFunctions = {
	AllSettings = {}
}

local space = " " -- U+0020
local abbreviator = space .. "..."

local escapeCharacters = {
	[1] = "$",
	[2] = "%",
	[3] = "^",
	[4] = "*",
	[5] = "(",
	[6] = ")",
	[7] = "[",
	[8] = "]",
	[9] = ".",
	[10] = "+",
	[11] = "-",
	[12] = "*"
}

local function protectedCall<A>(f : (A) -> (...any), ... : A)	
	if derivedFunctions["AllSettings"]["ProtectedCall"]["Yielding"] then
		local tab = table.pack(pcall(f, ...))
		tab["n"] = nil

		if tab[1] == true then
			if tab[2] ~= nil then
				for i = #tab, 2, -1 do
					tab[i + 1] = tab[i]
				end
			end
			
			tab[2] = nil
		end
				
		return table.unpack(tab)
	else
		local success, err = true, "Not yielded"
		
		coroutine.wrap(function(...)
			success, err = pcall(f, ...)
		end)(...)
		
		return success, err
	end
end

local function firstCalledFrom()
	local traced = debug.traceback()
	local separated = string.split(traced, "\n")
	local firstCalled = separated[#separated - 1]
	
	return firstCalled
end

local function upsideDownString(str : string) : string
	local strings = {} 
	
	for i, v in string.split(str, "\n") do
		strings[i] = v
	end
	
	local newString = ""
	
	for i = #strings, 1, -1 do
		newString ..= if i ~= 1 then strings[i] .. "\n" else strings[i]
	end
	
	return newString
end

local function separateArgumentsBy(isLast : boolean)
	return if not isLast then (derivedFunctions["AllSettings"]["Output"]["SeparateArgumentsBy"] :: string) .. space else ""
end

local function transformToEscapeCharacter(str : string, chars : {string}?, replacement : string, replacements : number?)
	if not chars then
		for i, char in escapeCharacters do
			str = string.gsub(str, "%" .. char, "%%" .. char, replacements)
		end
	else
		error("Specify a use case. Please report it to the developer.")
	end
	
	return str
end

local function removeExtraWhitespace(str)
	str = string.gsub(str, "\n%s*\n", "\n")
	str = string.gsub(str, "{[\n]+%s*}", "{}")
	
	return str
end

local function exceedsMaxLength(output, str : string, lastArgument : unknown) : (boolean, string)
	local length = string.len(str)

	if length >= output.MaxLength then
		if type(lastArgument) == "string" then
			str = string.sub(str, 1, output.MaxLength) .. (if output.StringsQuoted then '"' else "") .. abbreviator		
		elseif type(lastArgument) == "boolean" then
			local reversed = string.reverse(tostring(lastArgument))
			
			local f, l = string.find(string.reverse(str), reversed)
			l, f = (length + 1) - f :: number, (length + 1) - l :: number
			
			str = string.sub(str, 1, l) .. abbreviator
		elseif type(lastArgument) == "table" then
			local lastArgument = lastArgument :: {[number] : any} -- See issue https://github.com/Roblox/luau/issues/830
			local tableLength = #lastArgument
			
			if tableLength > 0 then
				local break_recursiveness = ""
				
				local function removeIndicesRecursively(s)
					local removedWhitespace = removeExtraWhitespace(s)

					local upsideDown = upsideDownString(removedWhitespace)
					
					local maxWhitespaceLength = 0
					local split = string.split(upsideDown, "\n")
					local firstIndex = 0
					
					for i = 2, #split - 1, 1 do
						local matched = string.match(split[i], "%s+") :: string
						
						local whitespace

						if matched then
							whitespace = string.len(matched)
						else
							continue
						end
						
						if maxWhitespaceLength < whitespace then
							maxWhitespaceLength = whitespace
							firstIndex = i
						elseif maxWhitespaceLength > whitespace or (maxWhitespaceLength == whitespace and i == #split - 1) then
							upsideDown = string.gsub(upsideDown, transformToEscapeCharacter(split[firstIndex], nil, ""), "", 1)

							break
						end
					end
					
					upsideDown = upsideDownString(upsideDown)
					
					if string.len(upsideDown) > output.MaxLength and upsideDown ~= break_recursiveness then
						break_recursiveness = upsideDown
						return removeIndicesRecursively(upsideDown)
					else
						return upsideDown
					end
				end
				
				str = removeIndicesRecursively(str)
			end
		end

		return true, str
	end
	
	return false, str
end

local function formatOutputCode(... : any)
	local output = derivedFunctions["AllSettings"]["Output"]
	
	local mergedString = ""

	local packedArguments = {...}
	
	for i, argument in packedArguments do
		if type(argument) == "string" then
			mergedString ..= (if output.StringsQuoted then '"' .. argument .. '"' else argument) .. separateArgumentsBy(i == #packedArguments)
		elseif type(argument) == "boolean" or type(argument) == "number" then
			mergedString ..= tostring(argument) .. separateArgumentsBy(i == #packedArguments)
		elseif type(argument) == "table" then
			local tables = output.Tables
			local tableString = ""
			
			if tables.ShowHexadecimalMemoryAddress then
				tableString ..= tostring(argument) .. space .. "=" .. space
			end
						
			if tables.Expanded then
				tableString ..= "{\n"

				local stackLevel = 1
				
				local function expand(tab, level : number) : string
					local str = ""
					local numberOfElements = 0
					
					local function rep(lvl)
						local str_rep = ""
						
						for i = 1, lvl, 1 do
							str_rep ..= space .. space .. space .. space
						end
						
						return str_rep
					end
					
					for i, v in tab do
						numberOfElements += 1
						str ..= rep(level)
						
						if type(i) == "string" then
							str ..= '["' .. i .. '"] = '
						elseif type(i) == "boolean" or type(i) == "number" then
							str ..= '[' .. tostring(i) .. '] = '
						elseif type(i) == "table" then
							str ..= '[' .. tostring(i) .. '] = '
						end

						if type(v) == "string" then
							str ..= '"' .. v .. '"' .. "," .. "\n"
						elseif type(v) == "boolean" or type(v) == "number" then
							str ..= tostring(v) .. "," .. "\n"
						elseif type(v) == "table" then
							str ..= "{\n" .. expand(v, level + 1)
						end
					end
					
					local indent = "\n" .. rep(level - 1) .. "}" .. (if level == 1 then "" else ",")
					
					if numberOfElements == 0 then
						return indent
					end
					
					return str .. indent
				end
				
				tableString ..= expand(argument, stackLevel) .. separateArgumentsBy(i == #packedArguments)
			else
				tableString ..= "{...}" .. separateArgumentsBy(i == #packedArguments)
			end
			
			mergedString ..= tableString
		end
		
		local isExceeding, modifiedString = exceedsMaxLength(output, mergedString, argument)
		mergedString = modifiedString
		
		if isExceeding then
			break
		end
	end
	
	mergedString = removeExtraWhitespace(mergedString)

	if output["Traceback"] then
		mergedString ..= "\n" .. firstCalledFrom()
	end
	
	if output["ShowClientOrServer"] then
		mergedString ..= space .. ">>"
		if RunService:IsClient() then
			mergedString ..= space .. "Client"
		elseif RunService:IsServer() then
			mergedString ..= space .. "Server"
		elseif RunService:IsStudio() then
			mergedString ..= space .. "Studio"
		end
	end
	
	return mergedString
end

function derivedFunctions.print(... : string | {[any] : any} | boolean)
	print(formatOutputCode(...))
end

function derivedFunctions.warn(... : string | {[any] : any} | boolean)
	warn(formatOutputCode(...))
end

function derivedFunctions.error(... : string | {[any] : any} | boolean)
	error(formatOutputCode(...), 0)
end

function derivedFunctions.pcall<A>(f : (A) -> (...any), ... : A) : (boolean, string)
	return protectedCall(f, ...)
end

function derivedFunctions.xpcall<A>(f : (A) -> (...any), xf : (string) -> (...any), ... : A)
	local args = table.pack(protectedCall(f, ...))
	args["n"] = nil
	
	if not args[1] then
		return xf(args[2] :: string)
	else
		return table.unpack(args)
	end
end

function derivedFunctions.ypcall<A>(ypcall : "'ypcall' won't work. Use 'pcall' instead.")
	return derivedFunctions.dwarn("Global 'ypcall' is deprecated and removed by the module. Please consider using 'pcall' instead.")
end

function derivedFunctions.rpcall<A>(func: (A) -> (...any), timesToTry : number, ... : A)
	local timesTried, errors = 0, {}
	local args
	
	repeat
		timesTried += 1

		args = table.pack(derivedFunctions.pcall(func, ...))
		args["n"] = nil
		
		if not args[1] then
			table.insert(errors, args[2])
		end
		
		task.wait()
	until args[1] or (timesToTry ~= 0 and timesToTry <= timesTried)
	
	return timesTried, errors, table.unpack(args, 3, #args)
end

function derivedFunctions.rxpcall<A>(f : (A) -> (...any), xf : (string) -> (...any), timesToTry : number, ... : A)
	local timesTried, errors = 0, {}
	local args

	repeat
		timesTried += 1

		args = table.pack(derivedFunctions.pcall(f, ...))
		args["n"] = nil

		if not args[1] then
			xf(args[2] :: string)
			table.insert(errors, args[2])
		end
		
		task.wait()
	until (args[2] == nil) or (timesToTry ~= 0 and timesToTry <= timesTried)

	return timesTried, errors, table.unpack(args, 3, #args)
end

function derivedFunctions.unpack<n1..., n2...>(list : {any}, i : number?, j : number?)
	derivedFunctions.dwarn("Global 'unpack' is replaced with 'table.unpack'. Please consider using 'table.unpack' next time.")
	return unpack(list, i, j)
end

function derivedFunctions.dwarn(... : string)
	warn(..., "\n\nThe line of the script that caused the error:\n" .. firstCalledFrom())
end

return derivedFunctions
