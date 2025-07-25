return {
	"tpope/vim-fugitive",
	init = function()
		vim.keymap.set("n", "<leader>G", "<Cmd>G<CR>", { desc = "Open Fugitive summary window" })
	end,
}
