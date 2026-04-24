---Collection of global methods and variables that I might use throughout my config.
local M = {}

M.floating_windows = {
	max_width = 100,
	max_height = 25,
}

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

---Combines any number of arrays into a single one.
---@param ... any[]
---@return any[]
function M.merge_arrays(...)
	local result = {}

	for _, list in ipairs({ ... }) do
		vim.list_extend(result, list)
	end

	return result
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

---Move up and down across wrapped lines while allowing for count-based vertical movement
---This is particularly useful for Markdown files, where line wrapping is common.
---@param char string
---@return string
function M.wrapped_lines_movement(char)
	if not vim.o.wrap then
		return char
	end

	return vim.v.count > 0 and char or "g" .. char
end

---Determines whether the Treesitter node at the cursor's current position
---is equal to one of the nodes from the provided list.
---@param node_list string[] List of Treesitter nodes to check against the current one.
---@return boolean
function M.treesitter_node_equals(node_list)
	local row, column = unpack(vim.api.nvim_win_get_cursor(0))
	local success, node = pcall(vim.treesitter.get_node, {
		pos = { row - 1, math.max(0, column - 1) }, -- Properly captures node at the cursor (0-indexed)
	})

	if not success or not node then
		return false
	end

	return vim.tbl_contains(node_list, node:type())
end

return M
