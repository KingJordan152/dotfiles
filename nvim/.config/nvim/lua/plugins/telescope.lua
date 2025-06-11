return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		"andrew-george/telescope-themes",
		"nvim-telescope/telescope-file-browser.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local builtin = require("telescope.builtin")
		local themes = require("telescope.themes")
		local fb_actions = require("telescope").extensions.file_browser.actions

		telescope.setup({
			defaults = {
				prompt_prefix = " ❯ ",
				selection_caret = " ❯ ",
				entry_prefix = "   ",
				sorting_strategy = "ascending",
				layout_config = {
					prompt_position = "top",
				},
				mappings = {
					n = {
						["dd"] = actions.delete_buffer,
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
				oldfiles = {
					only_cwd = true,
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
					path_display = function(_, path)
						local tail = require("telescope.utils").path_tail(path)
						return string.format("%s  %s", tail, path)
					end,
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
				file_browser = {
					initial_mode = "normal",
					grouped = true,
					select_buffer = true,
					path = "%:p:h",
					hijack_netrw = true,

					mappings = {
						["n"] = {
							["<bs>"] = fb_actions.backspace, -- Go up a directory in Normal mode
						},
					},
				},
			},
		})

		-- Load Extensions
		telescope.load_extension("fzf")
		telescope.load_extension("ui-select")
		telescope.load_extension("themes")
		telescope.load_extension("file_browser")

		-- Core Keymaps
		-- if vim.fn.has("mac") == 1 then
		-- 	vim.keymap.set("n", "<D-p>", builtin.find_files, { desc = "Find file" })
		-- else
		-- 	vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find file" })
		-- end
		vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find file" })
		vim.keymap.set("n", "<leader>;", function()
			builtin.buffers(themes.get_dropdown({ previewer = false }))
		end, { desc = "List buffers" })
		vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Grep files" })
		vim.keymap.set("n", "<leader>e", " <Cmd>Telescope file_browser<CR> ", { desc = "Open File Explorer" })
		vim.keymap.set("n", "<leader>cs", "<Cmd>Telescope themes<CR>", { desc = "List colorschemes" })

		-- Search Keymaps (prefix 's')
		vim.keymap.set("n", '<leader>s"', builtin.registers, { desc = "Search registers" })
		vim.keymap.set("n", "<leader>s/", builtin.search_history, { desc = "Search history" })
		vim.keymap.set("n", "<leader>so", builtin.oldfiles, { desc = "Search oldfiles" })
		vim.keymap.set("n", "<leader>sa", builtin.autocommands, { desc = "Search autocommands" })
		vim.keymap.set("n", "<leader>sc", builtin.command_history, { desc = "Search command history" })
		vim.keymap.set("n", "<leader>sC", builtin.commands, { desc = "Search commands" })
		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Search diagnostics" })
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Search help tags" })
		vim.keymap.set("n", "<leader>sH", builtin.highlights, { desc = "Search highlights" })
		vim.keymap.set("n", "<leader>sj", builtin.jumplist, { desc = "Search jumplist" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Search keymaps" })
		vim.keymap.set("n", "<leader>sL", builtin.loclist, { desc = "Search location list" })
		vim.keymap.set("n", "<leader>sm", builtin.marks, { desc = "Search marks" })
		vim.keymap.set("n", "<leader>sM", builtin.man_pages, { desc = "Search man pages" })
		vim.keymap.set("n", "<leader>sq", builtin.quickfix, { desc = "Search quickfix list" })
		vim.keymap.set("n", "<leader>sQ", builtin.quickfixhistory, { desc = "Search quickfix history" })
		vim.keymap.set("n", "<leader>sR", builtin.resume, { desc = "Search resume" })
		vim.keymap.set("n", "<leader>st", builtin.tags, { desc = "Search tags" })

		-- LSP-related Keymaps (still 'search')
		vim.keymap.set("n", "<leader>sr", builtin.lsp_references, { desc = "Search LSP references" })
		vim.keymap.set("n", "<leader>sD", builtin.lsp_document_symbols, { desc = "Search LSP document symbols" })
		-- vim.keymap.set("n", "<leader>ssw", builtin.lsp_workspace_symbols, { desc = "Search LSP workspace symbols" })
		-- vim.keymap.set("n", "<leader>si", builtin.lsp_implementations, { desc = "Search LSP implementations" })
		-- vim.keymap.set("n", "<leader>sD", builtin.lsp_definitions, { desc = "Search LSP definitions" })
		-- vim.keymap.set("n", "<leader>sT", builtin.lsp_type_definitions, { desc = "Search LSP type definitions" })

		-- Git Keymaps (prefix 'g')
		vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Git commits" })
		vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Git branches" })
		vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Git status" })
		vim.keymap.set("n", "<leader>gS", builtin.git_stash, { desc = "Git stash" })
	end,
}
