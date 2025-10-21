return {
	"sindrets/diffview.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		enhanced_diff_hl = true,
		view = {
			merge_tool = {
				layout = "diff3_mixed",
			},
		},
		hooks = {
			view_opened = function()
				vim.b.diffview_enabled = true
			end,
			view_closed = function()
				vim.b.diffview_enabled = false
			end,
		},
	},
}
