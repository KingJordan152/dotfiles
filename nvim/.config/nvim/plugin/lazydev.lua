vim.pack.add({ "https://github.com/folke/lazydev.nvim" })

require("lazydev").setup({
	library = {
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } }, -- Load luvit types when the `vim.uv` word is found
		{ path = "nvim-lspconfig", words = { "lspconfig" } },
		"nvim-dap-ui",
	},
})
