local utils = require("core.utils")

---Returns whether various packages are installed on the user's system.
local is_installed = {
	go = function()
		return utils.executable_exists("go")
	end,
	ruby = function()
		-- `ruby_lsp` will consistently fail to install unless Ruby is installed through `mise`
		return utils.executable_exists("mise") and utils.executable_exists("ruby") and utils.executable_exists("gem")
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
		auto_update = false, -- Potential security vulnerability (and it can be annoying)
		ensure_installed = {
			--[[
			-- Tooling for the following languages have been purposely omitted:
			-- - Kotlin (use IntelliJ)
			-- - C# (use Visual Studio)
			--]]

			-- LSPs
			"html",
			-- "emmet_language_server",
			"ts_ls",
			"vtsls",
			"denols",
			"eslint",
			"biome",
			"oxlint",
			"svelte",
			"vue_ls",
			"astro",
			"cssls",
			"css_variables",
			"tailwindcss",
			"cssmodules_ls",
			{ "ruby_lsp", condition = is_installed.ruby },

			"clangd",
			"lua_ls",
			"rust_analyzer",
			"zls",
			"jsonls",
			"yamlls",
			"harper_ls",
			{ "basedpyright", condition = is_installed.python },
			{ "gopls", condition = is_installed.go },
			{ "jdtls", condition = is_installed.java },

			-- Formatters
			"prettierd", -- Web Dev
			"stylua", -- Lua
			"oxfmt",
			{ "goimports", condition = is_installed.go },
			{ "rubocop", condition = is_installed.ruby },
			{ "ruff", condition = is_installed.python },

			-- Linters
			"eslint_d",

			-- Debuggers (DAP)
			"js-debug-adapter",
			"java-debug-adapter",
			"codelldb", -- C/C++/Rust/Zig
			{ "delve", condition = is_installed.go }, -- Go
			{ "debugpy", condition = is_installed.python }, -- Python
			{ "rdbg", condition = is_installed.ruby }, -- Ruby
		},
	},
}
