-- Options that only become active once an LSP has been attached
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function()
		-- Neovim creates keymaps for most LSP actions automatically (see https://neovim.io/doc/user/lsp.html#_global-defaults)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })

		-- Diagnostic Config
		vim.diagnostic.config({
			severity_sort = true,
			update_in_insert = true,
			float = { border = "rounded", source = "if_many" },
			underline = { severity = vim.diagnostic.severity.ERROR },
			signs = vim.g.have_nerd_font and {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.INFO] = " ",
					[vim.diagnostic.severity.HINT] = " ",
				},
			} or {},
			virtual_text = {
				source = "if_many",
				spacing = 2,
				format = function(diagnostic)
					local diagnostic_message = {
						[vim.diagnostic.severity.ERROR] = diagnostic.message,
						[vim.diagnostic.severity.WARN] = diagnostic.message,
						[vim.diagnostic.severity.INFO] = diagnostic.message,
						[vim.diagnostic.severity.HINT] = diagnostic.message,
					}
					return diagnostic_message[diagnostic.severity]
				end,
			},
		})
	end,
})

-- LSP Configurations
vim.lsp.config["cssmodules_ls"] = {
	init_options = {
		camelCase = false,
	},
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.hover.contentFormat = { "plaintext" }
capabilities.textDocument.hover.dynamicRegistration = true

vim.lsp.config["cssls"] = {
	capabilities = capabilities,
}
