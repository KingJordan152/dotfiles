local cssls_capabilities = vim.lsp.protocol.make_client_capabilities()
cssls_capabilities.textDocument.hover.contentFormat = { "plaintext" }
cssls_capabilities.textDocument.hover.dynamicRegistration = true

---@type vim.lsp.Config
return {
	capabilities = cssls_capabilities, -- Remove hover window formatting because it doesn't render properly by default.
}
