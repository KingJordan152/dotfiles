-- [[
--    Creates scope-based highlight lines similar to VS code.
-- ]]
return {
	"lukas-reineke/indent-blankline.nvim",
	dependencies = { "HiPhish/rainbow-delimiters.nvim" },
	main = "ibl",
	config = function()
		local hooks = require("ibl.hooks")

		require("ibl").setup({
			indent = {
				char = "▏",
			},
			scope = {
				show_end = false,
				highlight = {
					-- 'RainbowDelimiterRed', (usually "warning")
					"RainbowDelimiterYellow",
					"RainbowDelimiterBlue",
					"RainbowDelimiterViolet",
					"RainbowDelimiterCyan",
					"RainbowDelimiterGreen",
					"RainbowDelimiterOrange",
				},
				include = {
					node_type = {
						["*"] = {
							"return_statement",
							"table_constructor",
							"if_statement",
							"ternary_expression",
							"parenthesized_statement",
							"object",
							"object_pattern",
							"arguments",
						},
					},
				},
				exclude = {
					language = { "yaml" },
					node_type = {
						["*"] = {
							"jsx_element",
						},
					},
				},
			},
		})

		-- Ensures Rainbow Delimiters and Indent Blankline highlight groups are synced
		hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
	end,
}
