local utils = require("core.utils")

return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	enabled = function()
		return utils.tree_sitter_cli_exists(true)
	end,
}
