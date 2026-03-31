local utils = require("core.utils")

--- Customize how diagnostics work/appear
vim.diagnostic.config({
	severity_sort = true,
	float = {
		source = "if_many",
		max_width = utils.floating_windows.max_width,
	},
	virtual_text = {
		source = "if_many",
		spacing = 2,
	},
	jump = {
		-- Preserve old `jump.float = true` behavior
		on_jump = function(_, bufnr)
			vim.diagnostic.open_float({
				bufnr = bufnr,
				scope = "cursor",
				focus = false,
			})
		end,
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
