local utils = require("core.utils")

-- General Keymaps
vim.keymap.set("n", "<leader>w", "<Cmd>w<CR>", { desc = "Save File" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("i", "<M-BS>", "<C-w>", { desc = "Delete word backwards" })
vim.keymap.set("n", "<C-CR>", function()
	-- Must specify count because `]<Space>` will ignore it by default.
	return "[<Space>" .. vim.v.count1 .. "]<Space>"
end, { remap = true, expr = true, desc = "Add empty line above and below cursor" })

-- Helix-inspired
vim.keymap.set({ "n", "v", "o" }, "gl", "$", { desc = "Go to end of line" })
vim.keymap.set({ "n", "v", "o" }, "gh", "^", { desc = "Go to start of line" })

-- Stay in visual mode when indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Copy and paste lines down (VS Code-inspired)
vim.keymap.set({ "n", "v" }, "<M-S-J>", function()
	local command = ":co -1<CR>j"
	local mode = vim.api.nvim_get_mode().mode
	local is_visual = mode == "v" or mode == "V" or mode == vim.keycode("<C-v>")

	return is_visual and command .. "gv" or command
end, { expr = true, silent = true })

-- Copy and paste lines up (VS Code-inspired)
vim.keymap.set({ "n", "v" }, "<M-S-K>", function()
	local command = ":co +0<CR>k"
	local mode = vim.api.nvim_get_mode().mode
	local is_visual = mode == "v" or mode == "V" or mode == vim.keycode("<C-v>")

	return is_visual and command .. "gv" or command
end, { expr = true, silent = true })

-- Efficiently move across wrapped lines and add current position to jumplist before relative line movement
vim.keymap.set({ "n", "x" }, "j", function()
	local j = utils.wrapped_lines_movement("j")
	return vim.v.count > 1 and "m'" .. vim.v.count .. j or j
end, { expr = true })

vim.keymap.set({ "n", "x" }, "k", function()
	local k = utils.wrapped_lines_movement("k")
	return vim.v.count > 1 and "m'" .. vim.v.count .. k or k
end, { expr = true })
