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

				-- Prefer formatting with Conform
				"stylua",
				"oxfmt",

				-- "vtsls",
				-- "emmet_language_server",
			},
		},
	},
}
