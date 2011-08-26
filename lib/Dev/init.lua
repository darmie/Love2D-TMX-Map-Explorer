local _print = print
local table  = table
local type   = type

module(...)

function print(...)
	-- if multiple arguments, iterate
	local arg = {...}
	if #arg > 1 then
		for i = 1, #arg do
			print(arg[i])
		end
		return
	end

	local obj = ... 
	local objType = type(obj)
	if objType == 'string' or objType == 'number' then
		_print(obj)
	elseif objType == 'table' then
		_print(table.concat(obj, ', '))
	end
end
