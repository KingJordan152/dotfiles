return {
	"shortcuts/no-neck-pain.nvim",
	version = "*",
	init = function()
		vim.keymap.set("n", "<leader>z", "<Cmd>NoNeckPain<CR>", { desc = "Center window" })
	end,
	opts = {
		width = 110,
	},
}
