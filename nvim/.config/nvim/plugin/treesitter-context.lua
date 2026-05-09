vim.pack.add({
	-- Dependencies
	"https://github.com/nvim-treesitter/nvim-treesitter",

	"https://github.com/nvim-treesitter/nvim-treesitter-context",
})

require("treesitter-context").setup({
	mode = "topline",
	multiwindow = true,
	multiline_threshold = 1, -- Similar behavior to Zed/VS Code
})
