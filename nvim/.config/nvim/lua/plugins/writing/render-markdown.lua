return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
	ft = { "markdown", "gitcommit" },
	opts = {
		completions = { lsp = { enabled = true } },
		render_modes = true, -- Show formatted text even while in insert mode
		file_types = { "markdown", "gitcommit" },

		heading = {
			border = true,
			border_virtual = true,
			position = "inline",
			left_pad = 2,
		},
		code = {
			width = "block",
			left_pad = 2,
			right_pad = 2,
			language_pad = 2,
			min_width = 45,
		},
		pipe_table = {
			preset = "round",
			border_virtual = true,
		},
		-- Allows word-wrapping to work in markdown
		overrides = {
			filetype = {
				gitcommit = { heading = { enabled = false } },
			},
		},
		win_options = {
			wrap = { default = true, rendered = true },
			breakindent = { default = true, rendered = true },
			breakindentopt = { default = "list:-1", rendered = "list:-1" },
			linebreak = { default = true, rendered = true },
		},
	},
}
