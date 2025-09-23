return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	opts = {
		auto_update = true,
		ensure_installed = {
			-- LSPs
			"ts_ls",
			"clangd",
			"cssls",
			"css_variables",
			"cssmodules_ls",
			"eslint",
			"gopls",
			"lua_ls",
			"rust_analyzer",
			"tailwindcss",

			-- Formatters
			"prettier",
			"prettierd",
			"stylua",

			-- Linters
			"eslint_d",

			-- Debuggers (DAP)
		},
	},
}
