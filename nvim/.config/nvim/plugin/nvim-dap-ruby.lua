vim.api.nvim_create_autocmd("FileType", {
	pattern = { "ruby", "eruby" },
	callback = function()
		vim.pack.add({
			-- Dependencies
			"https://codeberg.org/mfussenegger/nvim-dap",

			"https://github.com/suketa/nvim-dap-ruby",
		})

		require("dap-ruby").setup()
	end,
})
