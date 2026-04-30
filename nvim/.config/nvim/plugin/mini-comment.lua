vim.pack.add({
	-- Dependencies
	"https://github.com/JoosepAlviste/nvim-ts-context-commentstring",

	"https://github.com/nvim-mini/mini.comment",
})

-- NECESSARY; ensures JSX/TSX files apply correct commentstring based Treesitter node.
-- e.g., JSX attributes -> '// %s'; JSX Elements -> '{/* %s */}'
require("ts_context_commentstring").setup({
	enable_autocmd = false,
})

require("mini.comment").setup({
	options = {
		custom_commentstring = function()
			return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
		end,
	},
})
