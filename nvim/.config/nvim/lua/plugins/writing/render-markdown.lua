return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {
		completions = { blink = { enabled = true } },
		render_modes = true, -- Show formatted text even while in insert mode
		pipe_table = {
			preset = "round",
		},

		-- Allows word-wrapping plugins like `wrapping.nvim` to work.
		win_options = {
			wrap = { default = true, rendered = true },
		},
	},
}
