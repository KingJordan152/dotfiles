vim.pack.add({ "https://github.com/stevearc/quicker.nvim" })

require("quicker").setup({
	opts = {
		relativenumber = true,
		number = true,
		signcolumn = vim.o.signcolumn,
	},
	highlight = {
		-- Use treesitter highlighting
		treesitter = true,
		-- Use LSP semantic token highlighting
		lsp = true,
		-- Load the referenced buffers to apply more accurate highlights (may be slow)
		load_buffers = true,
	},
	keys = {
		{
			">",
			function()
				require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
			end,
			desc = "Expand quickfix context",
		},
		{
			"<",
			function()
				require("quicker").collapse()
			end,
			desc = "Collapse quickfix context",
		},
	},
})
