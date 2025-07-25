return {
	"mason-org/mason-lspconfig.nvim",
	dependencies = {
		"mason-org/mason.nvim",
		"neovim/nvim-lspconfig",
	},
	opts = {
		automatic_enable = {
			exclude = {
				"ts_ls", -- Handled by `typescript-tools`
				"tailwindcss", -- Handled by `tailwind-tools`
			},
		},
	},
}
