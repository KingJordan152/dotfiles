return {
	"folke/which-key.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	event = "VeryLazy",
	---@class wk.Opts
	opts = {
		preset = "helix",

		---@type number | fun(ctx: { keys: string, mode: string, plugin?: string }):number
		delay = function(ctx)
			return (ctx.plugin and ctx.plugin ~= "marks") and 0 or 1000
		end,

		---@type wk.Spec
		spec = {
			{ "<leader>g", group = "Git" },
			{ "<leader>gh", group = "Git Hunk" },
			{ "<leader>ga", group = "Git Add (Stage)" },
			{ "<leader>s", group = "Search" },
			{ "<leader>X", group = "Exchange Treesitter node" },
			{ "<leader>d", group = "Debugger" },
			{ "<leader>l", group = "LSP Method" },
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
