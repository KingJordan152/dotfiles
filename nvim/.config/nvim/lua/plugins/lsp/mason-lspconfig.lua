return {
	"mason-org/mason-lspconfig.nvim",
	dependencies = {
		"mason-org/mason.nvim",
		"neovim/nvim-lspconfig",
	},
	opts = {
		automatic_enable = {
			exclude = {
				"tsgo",
				"ts_ls",
				-- "vtsls",
				-- "emmet_language_server",
			},
		},
	},
}
