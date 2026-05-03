return {
	"justinmk/vim-sneak",
	init = function()
		-- Disable *ugly* highlighting (colorscheme might supply own)
		vim.cmd([[highlight! link Sneak None]])
		vim.cmd([[highlight! link SneakCurrent None]])
	end,
}
