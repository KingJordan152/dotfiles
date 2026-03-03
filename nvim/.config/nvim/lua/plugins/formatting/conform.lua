local utils = require("core.utils")

---Runs the first available formatter given as an argument.
---You can use this function to run one formatter from a list first *then* another one.
---
---This code can be found on the [GitHub page](https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#run-the-first-available-formatter-followed-by-more-formatters) for `conform.nvim`.
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

---When the given filetype receives linting from a web dev LSP, only assign
---formatters if their config files exists in the current working directory.
---Otherwise, fallback to LSP formatting.
---
---When the given filetype *does not* receive linting, also assign formatters
---when their corresponding config files exist, but fallback to a default config.
---
---Effectively, non-linted files will always be formatted by a dedicated formatter
---while linted files will fallback to LSP formatting if config files don't exist.
---@param bufnr integer Current buffer index
---@return conform.FiletypeFormatter
local function web_dev_config(bufnr)
	local conform = require("conform")
	local linted_filetypes = {}
	local config = {}
	local base_config = {
		"oxfmt", -- Default formatter when no config files are found
		"prettierd",
	}

	linted_filetypes = utils.Set(
		utils.list_extend_dedupe(
			linted_filetypes,
			vim.lsp.config.oxlint.filetypes,
			vim.lsp.config.eslint.filetypes,
			vim.lsp.config.cssls.filetypes
		)
	)

	for _, formatter in pairs(base_config) do
		if conform.get_formatter_info(formatter, bufnr).cwd ~= nil then
			table.insert(config, formatter)
		end
	end

	if vim.tbl_isempty(config) and not linted_filetypes[vim.bo[bufnr].filetype] then
		return vim.tbl_extend("keep", base_config, { stop_after_first = true })
	end

	return config
end

--[[
--  Formatter plugin (with "format on save").
--]]
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	---@module "conform"
	---@type conform.setupOpts
	opts = {
		formatters_by_ft = {
			-- Individual Languages
			lua = { "stylua" },
			rust = { "rustfmt" },
			go = { "goimports", "gofmt", stop_after_first = true },
			python = {
				-- To fix auto-fixable lint errors.
				"ruff_fix",
				-- To run the Ruff formatter.
				"ruff_format",
				-- To organize the imports.
				"ruff_organize_imports",
			},

			-- Web Dev
			html = web_dev_config,
			css = web_dev_config,
			scss = web_dev_config,
			less = web_dev_config,
			javascript = web_dev_config,
			typescript = web_dev_config,
			typescriptreact = web_dev_config,
			javascriptreact = web_dev_config,
			vue = web_dev_config,
			astro = { "prettierd" }, -- No oxfmt support *yet*
			svelte = { "prettierd" }, -- No oxfmt support *yet*

			-- Etc.
			json = web_dev_config,
			jsonc = web_dev_config,
			json5 = web_dev_config,
			yaml = web_dev_config,
			toml = web_dev_config,
			markdown = web_dev_config, -- TODO: Figure out way to add "injected" formatter
			-- mdx = function(bufnr)
			-- 	return { first(bufnr, "oxfmt", "prettierd"), "injected" }
			-- end,
		},

		default_format_opts = {
			lsp_format = "fallback",
		},

		format_on_save = function(bufnr)
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end
			return { lsp_format = "fallback", timeout_ms = 500 }
		end,
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
				-- FormatDisable! will disable formatting just for this buffer
				vim.b.disable_autoformat = true
				vim.api.nvim_echo({ { "Disabled auto-formatting for the current buffer", "Removed" } }, true, {})
			else
				vim.g.disable_autoformat = true
				vim.api.nvim_echo({ { "Disabled auto-formatting", "Removed" } }, true, {})
			end
		end, {
			desc = "Disable auto-formatting on save",
			bang = true,
		})

		vim.api.nvim_create_user_command("FormatEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
			vim.api.nvim_echo({ { "Enabled auto-formatting", "Added" } }, true, {})
		end, {
			desc = "Enable auto-formatting on save",
		})

		vim.api.nvim_create_user_command("FormatToggle", function(args)
			if vim.b.disable_autoformat or vim.g.disable_autoformat then
				vim.cmd("FormatEnable")
			else
				if args.bang then
					vim.cmd("FormatDisable!")
				else
					vim.cmd("FormatDisable")
				end
			end
		end, {
			desc = "Toggle auto-formatting on save",
			bang = true,
		})
	end,
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = false, timeout_ms = 500, lsp_format = "fallback" }, function(err)
					if not err then
						local mode = vim.api.nvim_get_mode().mode
						if vim.startswith(string.lower(mode), "v") then
							vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
						end
					end
				end)
			end,
			mode = { "n", "v" },
			desc = "Format code",
		},
		{
			"<leader>tF",
			function()
				vim.cmd("FormatToggle")
			end,
			desc = "Toggle auto-formatting globally",
		},
		{
			"<leader>tf",
			function()
				vim.cmd("FormatToggle!")
			end,
			desc = "Toggle auto-formatting for the current buffer",
		},
	},
}
