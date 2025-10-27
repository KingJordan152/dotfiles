local utils = require("core.utils")

---Determines whether Go exists on the user's system.
---@return boolean
local function go_exists()
	return utils.executable_exists("go")
end

return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	opts = {
		auto_update = true,
		ensure_installed = {
			-- LSPs
			"ts_ls",
			"svelte",
			"vue_ls",
			"clangd",
			"cssls",
			"css_variables",
			"cssmodules_ls",
			"eslint",
			{ "gopls", condition = go_exists },
			"lua_ls",
			"rust_analyzer",
			"tailwindcss",
			"jsonls",
			"yamlls",
			"emmet_language_server",

			-- Formatters
			"prettier",
			"prettierd",
			"stylua",
			{ "goimports", condition = go_exists },

			-- Linters
			"eslint_d",

			-- Debuggers (DAP)
			"js-debug-adapter",
		},
	},
}
