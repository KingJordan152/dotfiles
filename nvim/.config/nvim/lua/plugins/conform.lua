-- Formatter plugin (with "format on save")
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },

	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true })
			end,
			desc = "Format buffer",
		},
	},

	config = function()
		-- Initializes ESLint as the formatter if an ESLint config file is present in the cwd.
		-- Otherwise, Prettier is used.
		local eslintWithPrettierFallback = function(bufnr)
			if require("conform").get_formatter_info("eslint_d", bufnr).available then
				return { "eslint_d" }
			else
				return { "prettierd", "prettier", stop_after_first = true }
			end
		end

		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				javascript = eslintWithPrettierFallback,
				typescript = eslintWithPrettierFallback,
				typescriptreact = { "eslint_d", "prettierd", "prettier", stop_after_first = true },
				markdown = { "prettierd", "prettier", stop_after_first = true },
			},

			default_format_opts = {
				lsp_format = "fallback",
			},

			format_on_save = {
				lsp_format = "fallback",
				timeout_ms = 500,
			},
		})
	end,
}
