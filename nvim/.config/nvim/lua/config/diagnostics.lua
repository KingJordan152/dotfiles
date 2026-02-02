local utils = require("core.utils")
local prose_filetypes = utils.Set({
	"markdown",
	"text",
	"gitcommit",
})

--- Customize how diagnostics work/appear
vim.diagnostic.config({
	severity_sort = true,
	float = {
		source = "if_many",
		max_width = 100,
	},
	virtual_text = {
		source = "if_many",
		spacing = 2,
	},
	jump = {
		float = true,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = " ",
			[vim.diagnostic.severity.HINT] = " ",
		},
	},
})

vim.api.nvim_create_autocmd("LspAttach", {
	desc = "Adjust diagnostic config for prose-based filetypes",
	group = vim.api.nvim_create_augroup("prose_filetype_diagnostics", { clear = true }),
	callback = function(args)
		local buf_ft = vim.bo[args.buf].filetype

		if prose_filetypes[buf_ft] then
			local ns = vim.lsp.diagnostic.get_namespace(args.data.client_id)

			vim.diagnostic.config({
				virtual_text = false,
				update_in_insert = true,
			}, ns)
		end
	end,
})
