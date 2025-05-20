return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		"andrew-george/telescope-themes",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local builtin = require("telescope.builtin")
		local themes = require("telescope.themes")

		telescope.setup({
			defaults = {
				selection_caret = "❯ ",
				prompt_prefix = "❯ ",
				sorting_strategy = "ascending",
				layout_config = {
					prompt_position = "top",
				},
				mappings = {
					n = {
						["d"] = actions.delete_buffer,
						["q"] = actions.close,
					},
					i = {
						-- Exit Telescope prompt when pressing Escape instead of entering Normal mode.
						["<esc>"] = actions.close,
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
					},
				},
			},
			pickers = {
				find_files = {
					hidden = true,
				},
				buffers = {
					only_cwd = true,
					sort_mru = true,
					initial_mode = "normal",
					previewer = false,
					layout_config = {
						width = 0.4,
						height = 0.5,
					},
				},
			},
			extensions = {
				["ui-select"] = {
					themes.get_dropdown(),
				},
				themes = {
					enable_previewer = true,
					enable_live_preview = true,
					persist = {
						enabled = true,
					},
				},
			},
		})

		-- Load Extensions
		telescope.load_extension("fzf")
		telescope.load_extension("ui-select")
		telescope.load_extension("themes")

		-- Core Keymaps
		if vim.fn.has("mac") == 1 then
			vim.keymap.set("n", "<D-p>", builtin.find_files, { desc = "Find file" })
		else
			vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find file" })
		end
		vim.keymap.set("n", "<leader>;", function()
			builtin.buffers(themes.get_dropdown({ previewer = false }))
		end, { desc = "List buffers" })
		vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Grep files" })
		vim.keymap.set("n", "<leader>cs", "<Cmd>Telescope themes<CR>", { desc = "List colorschemes" })

		-- Search Keymaps (prefix 's')
		vim.keymap.set("n", '<leader>s"', builtin.registers, { desc = "Search registers" })
		vim.keymap.set("n", "<leader>s/", builtin.search_history, { desc = "Search history" })
		vim.keymap.set("n", "<leader>sa", builtin.autocommands, { desc = "Search autocommands" })
		vim.keymap.set("n", "<leader>sc", builtin.command_history, { desc = "Search command history" })
		vim.keymap.set("n", "<leader>sC", builtin.commands, { desc = "Search commands" })
		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Search diagnostics" })
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Search help tags" })
		vim.keymap.set("n", "<leader>sH", builtin.highlights, { desc = "Search highlights" })
		vim.keymap.set("n", "<leader>sj", builtin.jumplist, { desc = "Search jumplist" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Search keymaps" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Search keymaps" })
	end,
}
