-- The following options are only applicable if an LSP has been attached.
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function()
		local floating_window = {
			max_width = 100,
			max_height = 25,
		}

		-- Neovim creates keymaps for most LSP actions automatically (see https://neovim.io/doc/user/lsp.html#_global-defaults), but these aren't.
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })

		-- Customize the LSP hover window
		local default_hover = vim.lsp.buf.hover
		---@diagnostic disable-next-line: duplicate-set-field
		vim.lsp.buf.hover = function()
			return default_hover({
				max_width = floating_window.max_width,
				max_height = floating_window.max_height,
			})
		end

		-- TODO: Add when v0.12 is released
		-- Colorize document symbols if the LSP supports doing that.
		-- local client = vim.lsp.get_client_by_id(args.data.client_id)
		-- if client ~= nil and client:supports_method("textDocument/documentColor") then
		-- 	vim.lsp.document_color.enable(true, args.buf)
		-- end

		-- Customize how diagnostics work
		vim.diagnostic.config({
			severity_sort = true,
			float = { source = "if_many", max_width = floating_window.max_width },
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
			},
		})
	end,
})
