---@type vim.lsp.Config
return {
	settings = {
		gopls = {
			semanticTokens = true,
			codelenses = {
				test = true,
			},
		},
	},
}
