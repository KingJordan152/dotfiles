return {
	"folke/lazydev.nvim",
	ft = "lua",
	opts = {
		library = {
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } }, -- Load luvit types when the `vim.uv` word is found
			"nvim-dap-ui",
			"nvim-lspconfig/lua/lspconfig",
		},
	},
}
