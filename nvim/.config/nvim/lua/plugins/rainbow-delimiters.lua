return {
	"HiPhish/rainbow-delimiters.nvim",
	config = function()
		require("rainbow-delimiters.setup").setup({
			-- Remove certain colors because they might confuse me
			highlight = {
				-- 'RainbowDelimiterRed', (usually "warning")
				"RainbowDelimiterYellow",
				"RainbowDelimiterBlue",
				"RainbowDelimiterViolet",
				"RainbowDelimiterCyan",
				"RainbowDelimiterGreen",
				"RainbowDelimiterOrange",
			},

			-- Don't colorize corresponding JSX/HTML tags
			query = {
				javascript = "rainbow-parens",
				tsx = "rainbow-parens",
				typescript = "rainbow-parens",
			},
		})
	end,
}
