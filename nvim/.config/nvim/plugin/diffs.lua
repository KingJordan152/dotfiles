-- Configuration MUST be defined before plugin loads
vim.g.diffs = {
	hide_prefix = true,
	integrations = {
		fugitive = true,
		gitsigns = true,
	},
	conflict = {
		show_actions = true,
		keymaps = {
			ours = "<leader>co",
			theirs = "<leader>ct",
			both = "<leader>cb",
			none = "<leader>cx",
			next = "]x",
			prev = "[x",
		},
	},
}

vim.pack.add({
	-- Dependencies
	"https://github.com/tpope/vim-fugitive",
	"https://github.com/lewis6991/gitsigns.nvim",

	"https://git.barrettruth.com/barrettruth/diffs.nvim",
})
