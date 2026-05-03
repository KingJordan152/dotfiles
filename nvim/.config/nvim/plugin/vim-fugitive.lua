return {
	"tpope/vim-fugitive",
	init = function()
		vim.keymap.set("n", "<leader>gg", "<Cmd>G<CR>", { desc = "Fugitive Summary Window" })
		vim.keymap.set("n", "<leader>ga.", "<cmd>G add .<cr>", { desc = "All changes" })
	end,
}
