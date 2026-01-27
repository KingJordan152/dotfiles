-- [[
--    Creates scope-based highlight lines similar to VS code.
-- ]]
return {
	"lukas-reineke/indent-blankline.nvim",
	dependencies = { "HiPhish/rainbow-delimiters.nvim" },
	main = "ibl",
	config = function()
		local hooks = require("ibl.hooks")
		local highlight = {
			-- "RainbowDelimiterRed", (usually indicates error)
			-- "RainbowDelimiterOrange", (too similar to yellow)
			"RainbowDelimiterBlue",
			"RainbowDelimiterViolet",
			"RainbowDelimiterCyan",
			"RainbowDelimiterGreen",
			"RainbowDelimiterYellow",
		}
		local css_nodes = {
			"block",
		}

		-- Ensures Rainbow Delimiters and Indent Blankline highlight groups are synced
		vim.g.rainbow_delimiters = vim.tbl_deep_extend("keep", vim.g.rainbow_delimiters, { highlight = highlight })
		hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

		require("ibl").setup({
			indent = {
				char = "▏",
			},
			scope = {
				show_end = false,
				highlight = highlight,
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
							"object_type",
							"interface_body",
							"enum_body",
							"arguments", -- TS/JS: argument list that's written across multiple lines
							"import_clause", -- TS/JS: multiple exports from a single module listed across multiple lines
						},
						css = css_nodes,
						scss = css_nodes,
						less = css_nodes,
					},
				},
				exclude = {
					language = { "yaml" },
					node_type = {
						["*"] = {
							"jsx_element",
							"element",
						},
					},
				},
			},
		})
	end,
}
