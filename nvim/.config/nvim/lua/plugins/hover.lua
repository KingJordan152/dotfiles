-- [[
--    Modifies the native hover window by allowing multiple sources to appear in the same window via tabs.
--    This makes Neovim hover windows similar to VS Code hover windows.
-- ]]
return {
	"lewis6991/hover.nvim",
	opts = {
		init = function()
			require("hover.providers.lsp")
			require("hover.providers.diagnostic")
			require("hover.providers.dap")
			require("hover.providers.fold_preview")
		end,
		preview_opts = {
			border = "rounded",
			max_height = 25,
			max_width = 100,
		},
	},

	keys = {
		{
			"gh",
			function(opts)
				local api = vim.api
				local hover_win = vim.b.hover_preview

				-- If the hover window is already open, jump into that.
				if hover_win and api.nvim_win_is_valid(hover_win) then
					api.nvim_set_current_win(hover_win)
				else
					require("hover").hover(opts)
				end
			end,
			desc = "Show Hover Information",
		},
		{
			"gH",
			function(opts)
				require("hover").hover_select(opts)
			end,
			desc = "Select Hover Source",
		},
		{
			"<C-n>",
			function(opts)
				require("hover").hover_switch("next", opts)
			end,
			desc = "Select Next Hover Source",
		},
		{
			"<C-p>",
			function(opts)
				require("hover").hover_switch("previous", opts)
			end,
			desc = "Select Previous Hover Source",
		},
	},
}
