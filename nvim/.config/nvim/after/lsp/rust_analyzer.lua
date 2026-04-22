---@type vim.lsp.Config
return {
	---@type lspconfig.settings.rust_analyzer
	settings = {
		["rust-analyzer"] = {
			lens = {
				-- Not helpful; noisy
				references = {
					adt = {
						enable = false,
					},
					enumVariant = {
						enable = false,
					},
					method = {
						enable = false,
					},
					trait = {
						enable = false,
					},
				},
			},
		},
	},
}
