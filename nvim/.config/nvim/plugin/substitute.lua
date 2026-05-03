-- [[
--    Provides commands for substituting and exchanging text over a given motion.
--    This is a more modern version of ReplaceWithRegister.
-- ]]
return {
	"gbprod/substitute.nvim",
	opts = {
		highlight_substituted_text = {
			enabled = true,
			timer = 150, -- Match highlight on yank timeout
		},
	},
	keys = {
		-- Substitute (replace)
		{
			"gs",
			function()
				require("substitute").operator({
					modifiers = { "reindent" },
				})
			end,
			desc = "Substitute",
		},
		{
			"gss",
			function()
				require("substitute").line({
					modifiers = { "reindent" },
				})
			end,
			desc = "Substitute line",
		},
		{
			"gS",
			function()
				require("substitute").eol()
			end,
			desc = "Substitute (up to EOL)",
		},
		{
			"gs",
			function()
				require("substitute").visual()
			end,
			mode = "x",
			desc = "Substitute",
		},
		-- Exchange (swap values)
		{
			"<leader>x",
			function()
				require("substitute.exchange").operator()
			end,
			desc = "Exchange",
		},
		{
			"<leader>xx",
			function()
				require("substitute.exchange").line()
			end,
			desc = "Exchange line",
		},
		{
			"<leader>x",
			function()
				require("substitute.exchange").visual()
			end,
			mode = "x",
			desc = "Exchange",
		},
	},
}
