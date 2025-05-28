return {
	"obsidian-nvim/obsidian.nvim",
	version = "*",
	lazy = true,
	ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	-- event = {
	--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
	--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
	--   -- refer to `:h file-pattern` for more examples
	--   "BufReadPre path/to/my-vault/*.md",
	--   "BufNewFile path/to/my-vault/*.md",
	-- },
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		ui = { enable = false }, -- `render-markdown` already takes care of this
		workspaces = {
			{
				name = "General",
				path = "~/Documents/Obsidian Vault", -- Might change based on the computer I'm using
			},
		},
		completion = {
			nvim_cmp = false,
			blink = true,
		},
		attachments = {
			img_folder = "Misc./Attachments",
		},
	},
}
