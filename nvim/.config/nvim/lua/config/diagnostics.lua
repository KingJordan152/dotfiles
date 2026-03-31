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
