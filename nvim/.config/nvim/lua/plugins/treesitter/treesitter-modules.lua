local utils = require("core.utils")

return {
	"MeanderingProgrammer/treesitter-modules.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	enabled = utils.tree_sitter_cli_exists,
	---@module 'treesitter-modules'
	---@type ts.mod.UserConfig
	opts = {
		auto_install = true,
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
			"gitcommit",
			"c",
		},
		highlight = {
			enable = true,
		},
		fold = {
			enable = true,
		},
		indent = {
			enable = true,
			disable = { "scss" },
		},
	},
}
