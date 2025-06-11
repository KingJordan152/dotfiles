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
		input = {
			enabled = true,
		},
		-- Auto-highlight LSP references
		words = {
			enabled = true,
		},
		-- Floating picker windows (like Telescope)
		picker = {
			enabled = false,
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
		-- terminal = {
		-- 	enabled = true,
		-- 	auto_close = false,
		-- },
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
		-- {
		-- 	"<leader>e",
		-- 	-- If the explorer is already open, focus it.
		-- 	-- Otherwise, open a new explorer picker.
		-- 	function()
		-- 		local explorer = Snacks.picker.get({ source = "explorer" })[1]
		-- 		local opts = {
		-- 			layout = {
		-- 				preset = "sidebar",
		-- 				preview = false,
		-- 			},
		-- 		}
		--
		-- 		if explorer == nil then
		-- 			Snacks.picker.explorer(opts)
		-- 		elseif explorer:is_focused() then
		-- 			Snacks.picker.explorer(opts)
		-- 		elseif not explorer:is_focused() then
		-- 			explorer:focus()
		-- 		end
		-- 	end,
		-- 	desc = "File Explorer",
		-- },
		-- {
		-- 	"<leader>T",
		-- 	function()
		-- 		Snacks.terminal.open()
		-- 	end,
		-- 	desc = "Create new Terminal",
		-- },
		-- {
		-- 	"<leader>t",
		-- 	function()
		-- 		Snacks.terminal.toggle()
		-- 	end,
		-- 	desc = "Toggle Terminal",
		-- },
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
