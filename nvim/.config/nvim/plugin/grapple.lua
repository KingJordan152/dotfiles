vim.pack.add({
	-- Dependencies
	"https://github.com/nvim-tree/nvim-web-devicons",

	"https://github.com/cbochs/grapple.nvim",
})

require("grapple").setup({
	scope = "git_branch", -- Assign default
	default_scopes = {
		git_branch = {
			cache = {
				-- `CmdlineLeave` fires cache update when switching branches with Fugitive.
				event = { "BufEnter", "FocusGained", "CmdlineLeave" },
				debounce = 1000, -- ms
			},
		},
	},
	---@type grapple.vim.win_opts
	win_opts = {
		border = "rounded",
	},
})

-- General keymaps
vim.keymap.set("n", "<leader>a", "<cmd>Grapple toggle<CR>", { desc = "Grapple - Toggle tag" }) -- Think of this like "Add" or "Append" (inspired by Harpoon keymap)
vim.keymap.set("n", "<leader>;", "<cmd>Grapple toggle_tags<CR>", { desc = "Grapple - Open tags window" })
vim.keymap.set("n", "]g", "<cmd>Grapple cycle_tags next<CR>", { desc = "Grapple - Cycle next tag" })
vim.keymap.set("n", "[g", "<cmd>Grapple cycle_tags prev<CR>", { desc = "Grapple - Cycle previous tag" })

-- Tag-jump keymaps
vim.keymap.set("n", "<leader>1", "<cmd>Grapple select index=1<CR>", { desc = "Grapple - Select tag 1" })
vim.keymap.set("n", "<leader>2", "<cmd>Grapple select index=2<CR>", { desc = "Grapple - Select tag 2" })
vim.keymap.set("n", "<leader>3", "<cmd>Grapple select index=3<CR>", { desc = "Grapple - Select tag 3" })
vim.keymap.set("n", "<leader>4", "<cmd>Grapple select index=4<CR>", { desc = "Grapple - Select tag 4" })
vim.keymap.set("n", "<leader>5", "<cmd>Grapple select index=5<CR>", { desc = "Grapple - Select tag 5" })
vim.keymap.set("n", "<leader>6", "<cmd>Grapple select index=6<CR>", { desc = "Grapple - Select tag 6" })
vim.keymap.set("n", "<leader>7", "<cmd>Grapple select index=7<CR>", { desc = "Grapple - Select tag 7" })
vim.keymap.set("n", "<leader>8", "<cmd>Grapple select index=8<CR>", { desc = "Grapple - Select tag 8" })
vim.keymap.set("n", "<leader>9", "<cmd>Grapple select index=9<CR>", { desc = "Grapple - Select tag 9" })
