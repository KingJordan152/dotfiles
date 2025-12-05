return {
	"folke/which-key.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	event = "VeryLazy",
	---@class wk.Opts
	opts = {
		preset = "modern",
		delay = 1500,
		---@type wk.Spec
		spec = {
			{ "<leader>g", group = "Git" },
			{ "<leader>gh", group = "Git Hunk" },
			{ "<leader>s", group = "Search" },
			{ "<leader>S", group = "Swap (Textobject)" },
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
}
