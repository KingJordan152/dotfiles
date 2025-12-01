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

---Determines whether the `tree-sitter-executable` is installed on the user's computer.
---If it isn't, the function will return `false`.
---@param print_message? boolean Controls whether an error message is printed to the command window when the executable doesn't exist.
---@return boolean
function M.tree_sitter_cli_exists(print_message)
	local tree_sitter_cli_exists = M.executable_exists("tree-sitter")
	print_message = print_message or false

	if print_message and not tree_sitter_cli_exists then
		vim.api.nvim_echo({
			{
				"tree-sitter-cli not found! nvim-treesitter will be disabled until it's installed",
			},
		}, true, { err = true })
	end

	return tree_sitter_cli_exists
end

return M
