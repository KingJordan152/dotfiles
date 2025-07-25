return {
	"cbochs/grapple.nvim",
	dependencies = {
		{ "nvim-tree/nvim-web-devicons", lazy = true },
	},
	cmd = "Grapple",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		scope = "git_branch",
		default_scopes = {
			git_branch = {
				cache = {
					-- `CmdlineLeave` fires cache update when switching branches with Fugitive.
					event = { "BufEnter", "FocusGained", "CmdlineLeave" },
					debounce = 1000, -- ms
				},
			},
		},
	},
	keys = {
		-- Recommended keymaps
		{ "<leader>m", "<cmd>Grapple toggle<cr>", desc = "Grapple - Toggle tag" }, -- Think of this like an elevated `mark` command
		{ "<leader>;", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple - Open tags window" },
		{ "<C-S-N>", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple - Cycle next tag" },
		{ "<C-S-P>", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple - Cycle previous tag" },

		-- Index-specific keymaps
		{ "<leader>1", "<cmd>Grapple select index=1<cr>", desc = "Grapple - Select first tag" },
		{ "<leader>2", "<cmd>Grapple select index=2<cr>", desc = "Grapple - Select second tag" },
		{ "<leader>3", "<cmd>Grapple select index=3<cr>", desc = "Grapple - Select third tag" },
		{ "<leader>4", "<cmd>Grapple select index=4<cr>", desc = "Grapple - Select fourth tag" },
		{ "<leader>5", "<cmd>Grapple select index=5<cr>", desc = "Grapple - Select fifth tag" },

		-- [[
		-- I initially wanted to have index-specific keymaps mapped to Ctrl+7-0 so that they would function similarly to <C-6> and
		-- so I could use my right hand to activate them instead of my left. However, I cannot seem to get Tmux running under Ghostty
		-- to recognize <C-#> keymaps. Until Tmux has some magical update or I can dedicate more time to this issue, I believe shortcuts
		-- of this nature are a worthless endeavor.
		-- ]]
	},
}
