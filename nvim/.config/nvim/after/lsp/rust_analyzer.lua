---@type vim.lsp.Config
return {
	settings = {
		["rust-analyzer"] = {
			lens = {
				references = false, -- Not helpful; noisy
			},
		},
	},
}
