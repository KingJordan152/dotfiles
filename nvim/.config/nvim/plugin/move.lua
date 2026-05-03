vim.pack.add({ "https://github.com/fedepujol/move.nvim" })

require("move").setup({
	char = {
		enable = true,
	},
})

-- Normal Mode Keymaps
vim.keymap.set("n", "<M-j>", "<cmd>MoveLine(1)<CR>", { desc = "Move line up", silent = true })
vim.keymap.set("n", "<M-k>", "<cmd>MoveLine(-1)<CR>", { desc = "Move line down", silent = true })
vim.keymap.set("n", "<M-h>", "<cmd>MoveHChar(-1)<CR>", { desc = "Move character left", silent = true })
vim.keymap.set("n", "<M-l>", "<cmd>MoveHChar(1)<CR>", { desc = "Move character right", silent = true })

-- Visual Mode Keymaps (need to use `:` instead of `<cmd>` otherwise it won't work)
vim.keymap.set("x", "<M-j>", ":MoveBlock(1)<CR>", { desc = "Move block up", silent = true })
vim.keymap.set("x", "<M-k>", ":MoveBlock(-1)<CR>", { desc = "Move block down", silent = true })
vim.keymap.set("x", "<M-h>", ":MoveHBlock(-1)<CR>", { desc = "Move block left", silent = true })
vim.keymap.set("x", "<M-l>", ":MoveHBlock(1)<CR>", { desc = "Move block right", silent = true })
