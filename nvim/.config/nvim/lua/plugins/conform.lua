--- Runs the first available formatter given as an argument.
--- You can use this function to run one formatter first *then* another one.
---
--- This code can be found on the [GitHub page](https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#run-the-first-available-formatter-followed-by-more-formatters) for `conform.nvim`.
---@param bufnr integer The buffer this formatting will be applied to.
---@param ... string The formatters you want to attempt to run.
---@return string
local function first(bufnr, ...)
	local conform = require("conform")
	for i = 1, select("#", ...) do
		local formatter = select(i, ...)
		if conform.get_formatter_info(formatter, bufnr).available then
			return formatter
		end
	end
	return select(1, ...)
end

--- Attempts to format the given buffer with `prettier` *first*, then formats with `eslint_d`.
---
--- This is useful for projects where code styles are enforced through `eslint` rules rather than in a `.prettierrc` file, but you still want to apply `prettier`'s clean formatting wherever possible.
---@param bufnr integer The buffer this formatting will be applied to.
local function format_with_prettier_then_eslint(bufnr)
	return { first(bufnr, "prettierd", "prettier"), "eslint_d" }
end

-- Formatter plugin (with "format on save")
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			javascript = format_with_prettier_then_eslint,
			typescript = format_with_prettier_then_eslint,
			typescriptreact = format_with_prettier_then_eslint,
			markdown = function(bufnr)
				return { first(bufnr, "prettierd", "prettier"), "injected" }
			end,
		},

		default_format_opts = {
			lsp_format = "fallback",
		},

		format_on_save = {
			lsp_format = "fallback",
			timeout_ms = 500,
		},
	},
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true })
			end,
			desc = "Format buffer",
		},
	},
}
