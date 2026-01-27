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
		bigfile = {
			enabled = true,
		},
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
			ui_select = true,
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
				git_hl = true,
			},
		},
	},
	init = function()
		vim.api.nvim_create_autocmd("User", {
			desc = "LSP file renaming integration for Oil",
			pattern = "OilActionsPost",
			callback = function(event)
				if event.data.actions[1].type == "move" then
					Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
				end
			end,
		})
	end,
	keys = {
		-- Primary Pickers
		{
			"<leader><space>",
			function()
				Snacks.picker.smart()
			end,
			desc = "Find File",
		},
		{
			"<leader>,",
			function()
				Snacks.picker.buffers()
			end,
			desc = "View Buffers",
		},
		{
			"<leader>/",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep Files",
		},
		{
			"<leader>/",
			function()
				Snacks.picker.grep_word()
			end,
			desc = "Grep Selection",
			mode = "x",
		},
		{
			"<leader>:",
			function()
				Snacks.picker.command_history()
			end,
			desc = "View Command History",
		},
		{
			"<leader>.",
			function()
				Snacks.picker.resume()
			end,
			desc = "Resume Previous Picker",
		},
		-- Git Pickers
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
			desc = "Git Diff",
		},
		{
			"<leader>gf",
			function()
				Snacks.picker.git_log_file()
			end,
			desc = "Git Log File",
		},
		{
			"<leader>gi",
			function()
				Snacks.picker.gh_issue()
			end,
			desc = "GitHub Issues (open)",
		},
		{
			"<leader>gI",
			function()
				Snacks.picker.gh_issue({ state = "all" })
			end,
			desc = "GitHub Issues (all)",
		},
		{
			"<leader>gp",
			function()
				Snacks.picker.gh_pr()
			end,
			desc = "GitHub Pull Requests (open)",
		},
		{
			"<leader>gP",
			function()
				Snacks.picker.gh_pr({ state = "all" })
			end,
			desc = "GitHub Pull Requests (all)",
		},
		-- Search Pickers
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
			desc = "History",
		},
		{
			"<leader>sa",
			function()
				Snacks.picker.autocmds()
			end,
			desc = "Autocmds",
		},
		{
			"<leader>sC",
			function()
				Snacks.picker.colorschemes({
					layout = {
						preset = "vscode",
						hidden = {},
					},
				})
			end,
			desc = "Colorschemes",
		},
		{
			"<leader>sD",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "All Diagnostics",
		},
		{
			"<leader>sd",
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
			desc = "Icons (Nerd Fonts, Emojis, etc.)",
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
			"<leader>sL",
			function()
				Snacks.picker.lsp_config()
			end,
			desc = "Attached LSPs",
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
				Snacks.picker.projects()
			end,
			desc = "Projects",
		},
		{
			"<leader>sP",
			function()
				Snacks.picker.lazy({
					title = "Lazy Plugin Spec",
				})
			end,
			desc = "Lazy Plugin Spec",
		},
		{
			"<leader>sq",
			function()
				Snacks.picker.qflist()
			end,
			desc = "Quickfix List",
		},
		{
			"<leader>sr",
			function()
				Snacks.picker.recent()
			end,
			desc = "Recent",
		},
		{
			"<leader>ss",
			function()
				Snacks.picker.lsp_symbols()
			end,
			desc = "LSP Symbols",
		},
		{
			"<leader>sS",
			function()
				Snacks.picker.lsp_workspace_symbols()
			end,
			desc = "LSP Workspace Symbols",
		},
		{
			"<leader>su",
			function()
				Snacks.picker.undo()
			end,
			desc = "Undo History",
		},
		-- LSP Actions
		{
			"gai",
			function()
				Snacks.picker.lsp_incoming_calls()
			end,
			desc = "C[a]lls Incoming",
		},
		{
			"gao",
			function()
				Snacks.picker.lsp_outgoing_calls()
			end,
			desc = "C[a]lls Outgoing",
		},
		-- Toggle Terminals
		{
			"<leader>tt",
			function()
				Snacks.terminal.toggle()
			end,
			desc = "Toggle terminal",
		},
		{
			"<leader>tT",
			function()
				Snacks.terminal.open()
			end,
			desc = "Toggle new terminal",
		},
		-- (Dashboard) Pull up dashboard from anywhere
		{
			"<leader><CR>",
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
