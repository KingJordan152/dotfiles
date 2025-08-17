-- Variable used for "gd" keymap in config.
local detail = false

return {
	"stevearc/oil.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",

		-- Third-party extensions
		-- "benomahony/oil-git.nvim", -- No longer using until author addresses performance issues
		{ "JezerM/oil-lsp-diagnostics.nvim", opts = {} },
	},
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		default_file_explorer = true,
		watch_for_changes = true,
		skip_confirm_for_simple_edits = true,
		keymaps = {
			["<C-c>"] = false, -- Replace with below keymap
			["q"] = "actions.close",
			["<C-q>"] = "actions.send_to_qflist",
			["gd"] = {
				desc = "Toggle file detail view",
				callback = function()
					detail = not detail
					if detail then
						require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
					else
						require("oil").set_columns({ "icon" })
					end
				end,
			},
		},
	},
	keys = {
		{
			"<leader>e",
			"<cmd>Oil<CR>",
			desc = "Open file browser (Oil)",
		},
	},
}
