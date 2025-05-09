-- [[
--    Provides commands for substituting and exchanging text over a given motion.
--    This is a more modern version of ReplaceWithRegister.
-- ]]
return {
	"gbprod/substitute.nvim",
	opts = {},
	init = function()
		-- Delete default LSP keymaps so they don't interfere
		vim.keymap.del("n", "gri")
		vim.keymap.del({ "n", "x" }, "gra")
	end,
	keys = {
		-- Substitute (Replace)
		{
			"gr",
			function()
				require("substitute").operator()
			end,
			desc = "Replace with Register",
		},
		{
			"grr",
			function()
				require("substitute").line()
			end,
			desc = "Replace Line with Register",
		},
		{
			"gR",
			function()
				require("substitute").eol()
			end,
			desc = "Replace with Register (up to EOL)",
		},
		{
			"gr",
			function()
				require("substitute").visual()
			end,
			mode = "x",
			desc = "Replace with Register",
		},
		-- Exchange (swap values); might conflict with another operator...
		{
			"gx",
			function()
				require("substitute.exchange").operator()
			end,
			desc = "Exchange",
		},
		{
			"gxx",
			function()
				require("substitute.exchange").line()
			end,
			desc = "Exchange Line",
		},
		{
			"gx",
			function()
				require("substitute.exchange").visual()
			end,
			mode = "x",
			desc = "Exchange",
		},
	},
}
