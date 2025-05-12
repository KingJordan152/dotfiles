return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",

	config = function()
		---@diagnostic disable-next-line: missing-fields
		require("nvim-treesitter.configs").setup({
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
			ensure_installed = {
				"lua",
				"tsx",
				"typescript",
				"javascript",
				"jsdoc",
				"markdown",
				"markdown_inline",
				"regex",
			},
		})
	end,
}
