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
		view_options = {
			show_hidden = true,
			is_always_hidden = function(name)
				local files = {
					[".DS_Store"] = true,
					[".git"] = true,
				}
				return files[name]
			end,
		},
		keymaps = {
			["<C-c>"] = false, -- Replace with below keymap
			["q"] = "actions.close",
			["<C-q>"] = "actions.send_to_qflist",
			["yp"] = {
				desc = "Copy relative path",
				"actions.yank_entry",
				opts = {
					modify = ":p:.",
				},
			},
			["yP"] = {
				desc = "Copy full path",
				"actions.yank_entry",
				opts = {
					modify = ":p:~",
				},
			},
			["<CR>"] = {
				--- Open the file under the cursor, but also remove all search highlights.
				--- This is helpful for when you're searching for a file inside a Oil buffer but don't want
				--- that search highlighting to persist once you've made a selection.
				function()
					require("oil").select()
					vim.cmd("nohlsearch")
				end,
			},
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
