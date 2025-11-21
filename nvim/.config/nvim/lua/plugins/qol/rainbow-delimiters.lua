return {
	"HiPhish/rainbow-delimiters.nvim",
	config = function()
		require("rainbow-delimiters.setup").setup({
			-- Highlights come from `indent-blankline`

			-- Don't colorize corresponding JSX/HTML tags
			query = {
				javascript = "rainbow-parens",
				tsx = "rainbow-parens",
				typescript = "rainbow-parens",
			},
		})
	end,
}
