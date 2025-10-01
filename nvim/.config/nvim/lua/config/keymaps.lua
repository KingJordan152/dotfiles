-- General Keymaps
vim.keymap.set("n", "<leader>w", "<Cmd>w<CR>", { desc = "Save File" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("i", "<M-BS>", "<C-w>", { desc = "Delete word backwards" })

-- Copy and paste lines up and down.
vim.keymap.set({ "n", "x" }, "<M-S-J>", ":co -1<CR>j", { desc = "Copy line down" })
vim.keymap.set({ "n", "x" }, "<M-S-K>", ":co +0<CR>k", { desc = "Copy line up" })

-- Move up and down across wrapped lines while allowing for count-based vertical movement (useful for Markdown files)
vim.keymap.set({ "n", "x" }, "j", function()
	return vim.v.count > 0 and "j" or "gj"
end, { expr = true, silent = true })

vim.keymap.set({ "n", "x" }, "k", function()
	return vim.v.count > 0 and "k" or "gk"
end, { expr = true, silent = true })
