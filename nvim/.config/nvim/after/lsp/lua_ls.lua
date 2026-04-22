---@type vim.lsp.Config
return {
	---@type lspconfig.settings.lua_ls
	settings = {
		Lua = {
			codeLens = { enable = false }, -- Only shows references; not helpful
		},
	},
}
