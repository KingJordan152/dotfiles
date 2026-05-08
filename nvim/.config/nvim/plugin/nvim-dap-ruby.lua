vim.api.nvim_create_autocmd("FileType", {
	pattern = { "ruby", "eruby" },
	group = vim.api.nvim_create_augroup("nvim-dap-ruby", {}),
	callback = function()
		vim.pack.add({
			-- Dependencies
			"https://codeberg.org/mfussenegger/nvim-dap",

			"https://github.com/suketa/nvim-dap-ruby",
		})

		require("dap-ruby").setup()
	end,
})
