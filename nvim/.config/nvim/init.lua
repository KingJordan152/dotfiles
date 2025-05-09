require("config.lazy")
require("current-theme")
require("options")

local lsp_configs = {}

for _, f in pairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
	local lsp_name = vim.fn.fnamemodify(f, ":t:r")
	table.insert(lsp_configs, lsp_name)
end

vim.lsp.enable(lsp_configs)
