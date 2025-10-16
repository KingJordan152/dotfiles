local base_on_attach = vim.lsp.config.eslint.on_attach

---@type vim.lsp.Config
return {
	-- Always run `LspEslintFixAll` on save.
	on_attach = function(client, bufnr)
		if not base_on_attach then
			return
		end

		base_on_attach(client, bufnr)
		vim.api.nvim_create_autocmd("BufWritePre", {
			desc = "Automatically fix all fixable ESLint errors on save",
			buffer = bufnr,
			callback = function()
				local is_formatting_disabled = vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat -- globals come from `conform.nvim`

				if not is_formatting_disabled then
					vim.cmd("LspEslintFixAll")
				end
			end,
		})
	end,
}
