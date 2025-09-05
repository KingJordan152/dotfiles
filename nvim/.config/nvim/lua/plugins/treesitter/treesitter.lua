return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		---@diagnostic disable-next-line: missing-fields
		require("nvim-treesitter.configs").setup({
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
			ensure_installed = {
				"lua",
				"luadoc",
				"tsx",
				"typescript",
				"javascript",
				"jsdoc",
				"html",
				"css",
				"styled", -- For styled-components
				"markdown",
				"markdown_inline",
				"yaml",
				"regex", -- For certain pickers
				"latex",
				"query",
				"c",
			},
		})
	end,
}
