vim.pack.add({ "https://github.com/shortcuts/no-neck-pain.nvim" })

require("no-neck-pain").setup({
	width = 110,
	disableOnLastBuffer = true,
	fallbackOnBufferDelete = false,
})

vim.keymap.set("n", "<leader>zz", "<Cmd>NoNeckPain<CR>", { desc = "Center current window (NoNeckPain)" })
