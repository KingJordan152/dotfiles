return {
	"sindrets/diffview.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = "DiffviewOpen",
	config = function()
		local diffview_winbars = vim.api.nvim_create_augroup("diffview_hide_winbars", { clear = true })

		vim.api.nvim_create_autocmd("User", {
			desc = "Disable winbars when Diffview is opened",
			pattern = "DiffviewViewEnter",
			group = diffview_winbars,
			callback = function()
				vim.g.diffview_open = true
				require("lualine").hide({ place = { "winbar" }, unhide = false })
			end,
		})

		vim.api.nvim_create_autocmd("User", {
			desc = "Enable winbars when Diffview is closed",
			pattern = "DiffviewViewLeave",
			group = diffview_winbars,
			callback = function()
				vim.g.diffview_open = false
				require("lualine").hide({ place = { "winbar" }, unhide = true })
			end,
		})

		require("diffview").setup({
			enhanced_diff_hl = true,
			view = {
				merge_tool = {
					layout = "diff3_mixed",
				},
			},
			hooks = {
				diff_buf_win_enter = function(_, winid)
					-- Turn off cursor line for diffview windows because of bg conflict.
					-- See https://github.com/neovim/neovim/issues/9800
					vim.wo[winid].culopt = "number"
				end,
			},
		})
	end,
}
