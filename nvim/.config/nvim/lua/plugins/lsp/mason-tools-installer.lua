local utils = require("core.utils")

---Returns whether various packages are installed on the user's system.
local is_installed = {
	go = function()
		return utils.executable_exists("go")
	end,
	ruby = function()
		return utils.executable_exists("ruby") and utils.executable_exists("gem")
	end,
	java = function()
		return utils.executable_exists("java")
	end,
	python = function()
		return utils.executable_exists("python") and utils.executable_exists("pip")
	end,
}

return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	opts = {
		auto_update = true,
		ensure_installed = {
			--[[
			-- Tooling for the following languages have been purposely omitted:
			-- - Kotlin (use IntelliJ)
			-- - C# (use Visual Studio)
			--]]

			-- LSPs
			"html",
			"emmet_language_server",
			"ts_ls",
			"vtsls",
			"denols",
			"eslint",
			"biome",
			"svelte",
			"vue_ls",
			"astro",
			"cssls",
			"css_variables",
			"tailwindcss",
			"cssmodules_ls",
			-- { "ruby_lsp", condition = ruby_exists },

			"clangd",
			{ "gopls", condition = is_installed.go },
			"lua_ls",
			"rust_analyzer",
			"basedpyright",
			"zls",
			{ "jdtls", condition = is_installed.java },
			"jsonls",
			"yamlls",
			"harper_ls",

			-- Formatters
			"prettierd", -- Web Dev
			"stylua", -- Lua
			{ "isort", condition = is_installed.python }, -- Python
			{ "black", condition = is_installed.python }, -- Python
			{ "goimports", condition = is_installed.go },

			-- Linters
			"eslint_d",

			-- Debuggers (DAP)
			"js-debug-adapter",
			"java-debug-adapter",
			"codelldb", -- C/C++/Rust/Zig
			{ "delve", condition = is_installed.go }, -- Go
			{ "debugpy", condition = is_installed.python }, -- Python
		},
	},
}
