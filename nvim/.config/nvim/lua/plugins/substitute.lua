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
		-- Substitute (Replace)
		{
			"gs",
			function()
				require("substitute").operator()
			end,
			desc = "Replace with Register",
		},
		{
			"gss",
			function()
				require("substitute").line()
			end,
			desc = "Replace Line with Register",
		},
		{
			"gS",
			function()
				require("substitute").eol()
			end,
			desc = "Replace with Register (up to EOL)",
		},
		{
			"gs",
			function()
				require("substitute").visual()
			end,
			mode = "x",
			desc = "Replace with Register",
		},
		-- Exchange (swap values); might conflict with another operator...
		-- {
		-- 	"gx",
		-- 	function()
		-- 		require("substitute.exchange").operator()
		-- 	end,
		-- 	desc = "Exchange",
		-- },
		-- {
		-- 	"gxx",
		-- 	function()
		-- 		require("substitute.exchange").line()
		-- 	end,
		-- 	desc = "Exchange Line",
		-- },
		-- {
		-- 	"gx",
		-- 	function()
		-- 		require("substitute.exchange").visual()
		-- 	end,
		-- 	mode = "x",
		-- 	desc = "Exchange",
		-- },
	},
}
