return {
	"nvim-treesitter/nvim-treesitter-context",
	event = "VeryLazy",
	opts = {
		mode = "topline",
		multiwindow = true,
		multiline_threshold = 1, -- Similar behavior to Zed/VS Code
	},
}
