return {
	"bullets-vim/bullets.vim",
	ft = { "markdown", "gitcommit" },
	init = function()
		vim.g.bullets_outline_levels = { "ROM", "ABC", "num", "abc", "rom", "std-" }
	end,
}
