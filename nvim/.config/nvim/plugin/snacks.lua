vim.pack.add({ "https://github.com/folke/snacks.nvim" })

require("snacks").setup({
	bigfile = {
		enabled = true,
	},
	-- Custom `vim.ui.input`
	input = {
		enabled = true,
	},
	image = {
		enabled = true,
		convert = {
			notify = false,
		},
	},
	-- Auto-highlight LSP references
	words = {
		enabled = true,
	},
	-- Floating picker windows (like Telescope)
	picker = {
		enabled = true,
		ui_select = true, -- Custom `vim.ui.select`
		formatters = {
			file = {
				filename_first = true,
			},
		},
		sources = {
			projects = {
				dev = { "~/Documents", "~/Projects" },
				filter = {
					paths = {
						["/opt"] = false,
						["~/.local/share"] = false,
					},
				},
			},
			smart = {
				filter = {
					cwd = true,
				},
				title = "Find File",
			},
			recent = {
				filter = {
					cwd = true,
				},
			},
			lsp_config = {
				configured = true,
				attached = true,
				title = "Attached LSPs",
				layout = "dropdown",
			},
		},
		win = {
			input = {
				keys = {
					["<Esc>"] = { "close", mode = { "n", "i" } }, -- Don't enter Normal mode inside picker
					["<m-/>"] = { "toggle_help_input", mode = "i" },
				},
			},
		},
	},
	terminal = {
		enabled = true,
		auto_close = false,
	},
	-- Cool central-hub page (like Alpha)
	dashboard = {
		enabled = true,
		sections = {
			{ section = "header" },
			{ section = "keys", gap = 1, padding = 1 },
		},
		preset = {
			---@type snacks.dashboard.Item[]
			keys = {
				{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
				{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
				{
					icon = " ",
					key = "r",
					desc = "Recent Files",
					action = ":lua Snacks.dashboard.pick('oldfiles')",
				},
				{
					icon = " ",
					key = "p",
					desc = "Recent Projects",
					action = ":lua Snacks.dashboard.pick('projects')",
				},
				{
					icon = " ",
					key = "c",
					desc = "Config",
					action = ":e ~/.config/nvim/lua/options.lua",
				},
				{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
			},
			header = [[
       ████ ██████           █████      ██                     
      ███████████             █████                             
      █████████ ███████████████████ ███   ███████████   
     █████████  ███    █████████████ █████ ██████████████   
    █████████ ██████████ █████████ █████ █████ ████ █████   
  ███████████ ███    ███ █████████ █████ █████ ████ █████  
 ██████  █████████████████████ ████ █████ █████ ████ ██████]],
		},
	},
	-- Reorganize the statuscolumn and add clickable 'fold' icons
	statuscolumn = {
		enabled = true,
		folds = {
			open = true,
			git_hl = true,
		},
	},
})

-- Primary Pickers
vim.keymap.set("n", "<leader><space>", Snacks.picker.smart, { desc = "Find File" })
vim.keymap.set("n", "<leader>,", Snacks.picker.buffers, { desc = "View Buffers" })
vim.keymap.set("n", "<leader>/", Snacks.picker.grep, { desc = "Grep Files" })
vim.keymap.set("x", "<leader>/", Snacks.picker.grep_word, { desc = "Grep Selection" })
vim.keymap.set("n", "<leader>:", Snacks.picker.command_history, { desc = "View Command History" })
vim.keymap.set("n", "<leader>.", Snacks.picker.resume, { desc = "Resume Previous Picker" })

-- Git Pickers
vim.keymap.set("n", "<leader>gB", Snacks.picker.git_branches, { desc = "Git Branches" })
vim.keymap.set("n", "<leader>gl", Snacks.picker.git_log, { desc = "Git Log" })
vim.keymap.set("n", "<leader>gL", Snacks.picker.git_log_line, { desc = "Git Log Line" })
vim.keymap.set("n", "<leader>gf", Snacks.picker.git_log_file, { desc = "Git Log File" })
vim.keymap.set("n", "<leader>gs", Snacks.picker.git_status, { desc = "Git Status" })
vim.keymap.set("n", "<leader>gS", Snacks.picker.git_stash, { desc = "Git Stash" })

-- Search Pickers
vim.keymap.set("n", '<leader>s"', Snacks.picker.registers, { desc = "Registers" })
vim.keymap.set("n", "<leader>s/", Snacks.picker.search_history, { desc = "History" })
vim.keymap.set("n", "<leader>sa", Snacks.picker.autocmds, { desc = "Autocmds" })
vim.keymap.set("n", "<leader>sC", function()
	Snacks.picker.colorschemes({
		layout = {
			preset = "vscode",
			hidden = {},
		},
	})
end, { desc = "Colorschemes" })
vim.keymap.set("n", "<leader>sd", Snacks.picker.diagnostics_buffer, { desc = "Buffer Diagnostics" })
vim.keymap.set("n", "<leader>sD", Snacks.picker.diagnostics, { desc = "All Diagnostics" })
vim.keymap.set("n", "<leader>sh", Snacks.picker.help, { desc = "Help Pages" })
vim.keymap.set("n", "<leader>sH", Snacks.picker.highlights, { desc = "Highlights" })
vim.keymap.set("n", "<leader>si", Snacks.picker.icons, { desc = "Icons (Nerd Fonts, Emojis, etc.)" })
vim.keymap.set("n", "<leader>sj", Snacks.picker.jumps, { desc = "Jumps" })
vim.keymap.set("n", "<leader>sk", Snacks.picker.keymaps, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>sl", Snacks.picker.loclist, { desc = "Location List" })
vim.keymap.set("n", "<leader>sL", Snacks.picker.lsp_config, { desc = "Attached LSPs" })
vim.keymap.set("n", "<leader>sm", Snacks.picker.marks, { desc = "Marks" })
vim.keymap.set("n", "<leader>sM", Snacks.picker.man, { desc = "Man Pages" })
vim.keymap.set("n", "<leader>sp", Snacks.picker.projects, { desc = "Projects" })
vim.keymap.set("n", "<leader>sq", Snacks.picker.qflist, { desc = "Quickfix List" })
vim.keymap.set("n", "<leader>sr", Snacks.picker.recent, { desc = "Recent" })
vim.keymap.set("n", "<leader>ss", Snacks.picker.lsp_symbols, { desc = "LSP Symbols" })
vim.keymap.set("n", "<leader>sS", Snacks.picker.lsp_workspace_symbols, { desc = "LSP Workspace Symbols" })
vim.keymap.set("n", "<leader>su", Snacks.picker.undo, { desc = "Undo History" })

-- Toggle Terminals
vim.keymap.set("n", "<leader>tt", Snacks.terminal.toggle, { desc = "Toggle terminal" })
vim.keymap.set("n", "<leader>tT", Snacks.terminal.open, { desc = "Toggle new terminal" })

-- (Dashboard) Pull up dashboard from anywhere
vim.keymap.set("n", "<leader><CR>", Snacks.dashboard.open, { desc = "Open Dashboard" })
