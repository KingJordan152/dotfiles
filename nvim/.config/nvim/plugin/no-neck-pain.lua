return {
	"shortcuts/no-neck-pain.nvim",
	version = "*",
	cmd = "NoNeckPain",
	keys = {
		{
			"<leader>zz",
			"<cmd>NoNeckPain<cr>",
			desc = "Center current window",
		},
	},
	opts = {
		width = 110,
		disableOnLastBuffer = true,
		fallbackOnBufferDelete = false,
	},
}
