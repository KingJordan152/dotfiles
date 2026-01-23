local utils = require("core.utils")

---Determines whether Go exists on the user's system.
---@return boolean
local function go_exists()
	return utils.executable_exists("go")
end

return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	event = "VeryLazy",
	opts = {
		auto_update = true,
		ensure_installed = {
			-- LSPs
			"html",
			-- "emmet_language_server",
			"ts_ls",
			"denols",
			"eslint",
			"biome",
			"svelte",
			"vue_ls",
			"astro",
			"angularls",
			"cssls",
			"css_variables",
			"tailwindcss",
			"cssmodules_ls",

			"clangd",
			{ "gopls", condition = go_exists },
			"lua_ls",
			"rust_analyzer",
			"jsonls",
			"yamlls",
			"harper_ls",

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
