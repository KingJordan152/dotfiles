return {
	"HiPhish/rainbow-delimiters.nvim",
	config = function()
		---Links out to a custom script that will strip all HTML tag-based highlighting
		local remove_tag_delimiters = "rainbow-script"

		require("rainbow-delimiters.setup").setup({
			-- Highlights come from `indent-blankline`

			-- Don't colorize corresponding JSX/HTML tags
			query = {
				javascript = "rainbow-parens",
				tsx = "rainbow-parens",
				typescript = "rainbow-parens",
				html = remove_tag_delimiters,
				astro = remove_tag_delimiters,
				vue = remove_tag_delimiters,
				svelte = remove_tag_delimiters,
			},
		})
	end,
}
