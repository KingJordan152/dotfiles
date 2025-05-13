---@module 'snacks'

-- [[
--    A collection of small plugins that provide various QoL upgrades to Neovim.
--
--    The most important one here is Picker, which provides a dropdown menu for
--    files and other important lists.
-- ]]
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		-- Allow images to be previewed in Picker (only works in terminals that support it)
		image = {
			enabled = true,
		},
		-- Auto-highlight LSP references
		words = {
			enabled = true,
		},
		-- Scope-based, colored, vertical lines
		indent = {
			indent = {
				priority = 1,
				enabled = true,
			},
			animate = {
				enabled = false,
			},
			scope = {
				enabled = true,
				priority = 200,
			},
		},
		-- File-tree explorer (like VS Code)
		explorer = {
			enabled = true,
			replace_netrw = true, -- Activates when calling `nvim .`
		},
		-- Floating picker windows (like Telescope)
		picker = {
			enabled = true,
			sources = {
				explorer = {
					hidden = true,

					layout = {
						preset = "default",
						---@diagnostic disable-next-line: assign-type-mismatch
						preview = true,
					},
				},
				buffers = {
					focus = "list",
					layout = {
						preset = "vscode",
					},
				},
				projects = {
					dev = { "~/dev", "~/projects", "~/Documents" },
				},
			},
			win = {
				input = {
					keys = {
						["<Esc>"] = { "close", mode = { "n", "i" } }, -- Don't enter Normal mode inside picker
						["<c-n>"] = { "preview_scroll_down", mode = { "i", "n" } },
						["<c-p>"] = { "preview_scroll_up", mode = { "i", "n" } },
					},
				},
			},
		},
		-- Cool central-hub page (like Alpha)
		dashboard = {
			enabled = true,
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
					{
						icon = "󰒲 ",
						key = "L",
						desc = "Lazy",
						action = ":Lazy",
						enabled = package.loaded.lazy ~= nil,
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
		-- Display `lazygit` CLI tool in a floating window
		lazygit = {
			enabled = true,
		},
		-- Reorganize the statuscolumn (and add clickable 'fold' icons)
		statuscolumn = {
			enabled = true,
			folds = {
				open = true,
			},
		},
	},

	keys = {
		-- (Picker) Core Keybindings
		{
			"<C-P>",
			function()
				Snacks.picker.smart()
			end,
			desc = "Smart Find Files",
		},
		{
			"<C-S-P>",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>/",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},
		{
			"<leader>;",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>e",
			function()
				-- Use sidebar picker when manually toggling the explorer.
				-- Otherwise, when invoking `netrw`, it's a floating window.
				---@diagnostic disable-next-line: missing-fields
				Snacks.explorer({
					win = {
						list = {
							keys = {
								-- Close picker upon selection (useful for Explorer `netrw`).
								-- MUST open folder with 'l', not '<CR>', unfortunately.
								---@diagnostic disable-next-line: assign-type-mismatch
								["<CR>"] = { { "confirm", "close" }, mode = { "n", "i" } },
							},
						},
					},
					layout = {
						preset = "sidebar",
						preview = false,
					},
				})
			end,
			desc = "File Explorer",
		},
		{
			"<leader>th",
			function()
				Snacks.picker.colorschemes({
					confirm = function(picker, item)
						-- Apply chosen colorscheme immediately.
						picker:close()
						if item then
							picker.preview.state.colorscheme = nil
							vim.schedule(function()
								vim.cmd("colorscheme " .. item.text)
							end)
						end

						-- Save the chosen colorscheme so that it's loaded next time Neovim is opened.
						local buf = vim.api.nvim_create_buf(false, true) -- Create a new buffer
						vim.api.nvim_buf_set_lines(buf, 0, -1, false, { 'vim.cmd("colorscheme ' .. item.text .. '")' }) -- Set the content

						-- Write the buffer to the specified file
						vim.api.nvim_buf_call(buf, function()
							vim.notify("Colorscheme successfully applied!", "info")
							vim.cmd("write! " .. "~/.config/nvim/lua/current-theme.lua") -- Write to the file
						end)

						-- Delete the buffer after writing
						vim.api.nvim_buf_delete(buf, { force = true })
					end,
				})
			end,
			desc = "Colorschemes",
		},

		-- (Picker) Search Keybindings (prefix 's')
		{
			"<leader>sp",
			function()
				Snacks.picker.projects()
			end,
			desc = "Projects",
		},
		{
			'<leader>s"',
			function()
				Snacks.picker.registers()
			end,
			desc = "Registers",
		},
		{
			"<leader>s/",
			function()
				Snacks.picker.search_history()
			end,
			desc = "Search History",
		},
		{
			"<leader>sa",
			function()
				Snacks.picker.autocmds()
			end,
			desc = "Autocmds",
		},
		{
			"<leader>sb",
			function()
				Snacks.picker.lines()
			end,
			desc = "Buffer Lines",
		},
		{
			"<leader>sc",
			function()
				Snacks.picker.command_history()
			end,
			desc = "Command History",
		},
		{
			"<leader>sC",
			function()
				Snacks.picker.commands()
			end,
			desc = "Commands",
		},
		{
			"<leader>sd",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "Diagnostics",
		},
		{
			"<leader>sD",
			function()
				Snacks.picker.diagnostics_buffer()
			end,
			desc = "Buffer Diagnostics",
		},
		{
			"<leader>sh",
			function()
				Snacks.picker.help()
			end,
			desc = "Help Pages",
		},
		{
			"<leader>sH",
			function()
				Snacks.picker.highlights()
			end,
			desc = "Highlights",
		},
		{
			"<leader>si",
			function()
				Snacks.picker.icons()
			end,
			desc = "Icons",
		},
		{
			"<leader>sj",
			function()
				Snacks.picker.jumps()
			end,
			desc = "Jumps",
		},
		{
			"<leader>sk",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "Keymaps",
		},
		{
			"<leader>sl",
			function()
				Snacks.picker.loclist()
			end,
			desc = "Location List",
		},
		{
			"<leader>sm",
			function()
				Snacks.picker.marks()
			end,
			desc = "Marks",
		},
		{
			"<leader>sM",
			function()
				Snacks.picker.man()
			end,
			desc = "Man Pages",
		},
		{
			"<leader>sp",
			function()
				Snacks.picker.lazy()
			end,
			desc = "Plugin Spec",
		},
		{
			"<leader>sq",
			function()
				Snacks.picker.qflist()
			end,
			desc = "Quickfix List",
		},
		{
			"<leader>sR",
			function()
				Snacks.picker.resume()
			end,
			desc = "Resume",
		},
		{
			"<leader>su",
			function()
				Snacks.picker.undo()
			end,
			desc = "Undo History",
		},
		{
			"<leader>ss",
			function()
				Snacks.picker.lsp_symbols()
			end,
			desc = "LSP Symbols",
		},

		-- (Picker) Git Keybindings (prefix 'g')
		{
			"<leader>gb",
			function()
				Snacks.picker.git_branches()
			end,
			desc = "Git Branches",
		},
		{
			"<leader>gl",
			function()
				Snacks.picker.git_log()
			end,
			desc = "Git Log",
		},
		{
			"<leader>gL",
			function()
				Snacks.picker.git_log_line()
			end,
			desc = "Git Log Line",
		},
		{
			"<leader>gs",
			function()
				Snacks.picker.git_status()
			end,
			desc = "Git Status",
		},
		{
			"<leader>gS",
			function()
				Snacks.picker.git_stash()
			end,
			desc = "Git Stash",
		},
		{
			"<leader>gd",
			function()
				Snacks.picker.git_diff()
			end,
			desc = "Git Diff (Hunks)",
		},
		{
			"<leader>gf",
			function()
				Snacks.picker.git_log_file()
			end,
			desc = "Git Log File",
		},
		-- (Dashboard) Pull up dashboard from anywhere
		{
			"<leader>d",
			function()
				Snacks.dashboard.open()
			end,
			desc = "Open Dashboard",
		},
		-- (Lazygit) Show Lazygit window
		{
			"<leader>lg",
			function()
				Snacks.lazygit.open()
			end,
			desc = "Open Lazygit",
		},
	},
}
