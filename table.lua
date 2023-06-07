-- Reminder: This script only works in Luau environment!
-- Renewed table library
-- Functions that were replaced:
--     pack:
--       Old: Packs all the arguments packed, including a "n" field with the number of arguments passed
--       New: Packs all the arguments packed, without the "n" field. Nil values are not permitted
--     find:
--       Old: Finds the argument passed, looping through the numeric keys
--       New: Finds the argument passed, looping through all the keys
-- Functions added:
--     GetDeprecated: Returns a list of functions deprecated for Luau

--!strict

local deprecatedFunctions = {"foreach", "foreachi", "getn"}

local renewedTableLibrary = {}

function renewedTableLibrary:GetDeprecated()
	return deprecatedFunctions
end

function renewedTableLibrary.pack(...: any)
	return {...}
end

function renewedTableLibrary.find<a>(tab: {any}, arg: a): a?
	for i, v in tab do
		if v == arg then
			return v
		end
	end
	
	return nil
end

for i, v in table :: {any} do
	if not renewedTableLibrary[i] then
		renewedTableLibrary[i] = v
	end
end

return renewedTableLibrary
