require("config.lazy")
require("current-theme")
require("options")

-- LSP Setup
vim.lsp.enable({
	"lua_ls", -- Lua
	"ts_ls", -- TypeScript/JavaScript
	"clangd", -- C/C++
	"jdtls", -- Java
	"rust_analyzer", -- Rust
	"gopls", -- Go
})
