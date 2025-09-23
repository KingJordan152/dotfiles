---Collection of global methods that I might use throughout my config.
local M = {}

---Creates a collection of unique strings.
---@param list string[] All the strings you wish to place in the Set. Any duplicated string will be ignored.
---@return {string: boolean} set A table indexed by all the strings from the given `list`.
function M.Set(list)
	local set = {}
	for _, element in ipairs(list) do
		set[element] = true
	end

	return set
end

---Determines whether the given executable is installed on the user's system.
---@param executable string The name of the executable you want to check.
---@return boolean
function M.executable_exists(executable)
	return vim.fn.executable(executable) == 1
end

return M
