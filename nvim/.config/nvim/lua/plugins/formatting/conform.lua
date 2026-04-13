local utils = require("core.utils")
local web_dev_formatters = {
	"oxfmt",
	"prettierd",
	"biome",
	"biome-organize-imports",
}

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

---Takes a list of formatters and filters out the ones that don't have a current
---working directory (i.e., a dedicated configuration file).
---
---This function makes it so that the `require_cwd` formatter option doesn't have to
---be applied globally.
---@param bufnr integer Current buffer index.
---@param formatters string[] List of formatters to filter.
---@return string[]
local function require_cwd(bufnr, formatters)
	local conform = require("conform")
	local config = {}

	for _, formatter in ipairs(formatters) do
		if conform.get_formatter_info(formatter, bufnr).cwd ~= nil then
			table.insert(config, formatter)
		end
	end

	return config
end

---Determines the formatters that will be used for all web development filetypes.
---
---A formatter must have a dedicated configuration file in order to be activated.
---Otherwise, fallback to LSP formatters.
---
---Examples of formatter configuration files include `.prettierrc`, `.oxfmtrc.json`, etc.
---@param bufnr integer Current buffer index.
---@return string[]
local function web_dev_config(bufnr)
	return require_cwd(bufnr, web_dev_formatters)
end

---Determines the formatters that will be used for all web development-adjacent filetypes
---(i.e., files that can reasonably be found both inside and outside web development projects).
---
---For these files, the `web_dev_config` is applied, but rather than falling back to the LSP when
---formatter configuration files aren't found, we default to the first available formatter provided.
---
---This makes it so that filetypes like `Markdown` can still receive dedicated formatting even when
---they're outside a web development project and don't have an associated configuration file.
---@param bufnr integer Current buffer index.
---@return string[]
local function web_dev_adjacent_config(bufnr)
	local config = web_dev_config(bufnr)

	if vim.tbl_isempty(config) then
		config = { first(bufnr, unpack(web_dev_formatters)) }
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
			astro = web_dev_config,
			svelte = web_dev_config,

			-- Etc.
			json = web_dev_adjacent_config,
			jsonc = web_dev_adjacent_config,
			json5 = web_dev_adjacent_config,
			yaml = web_dev_adjacent_config,
			toml = web_dev_adjacent_config,
			markdown = function(bufnr)
				return utils.merge_arrays(web_dev_adjacent_config(bufnr), { "injected" })
			end,
			mdx = function(bufnr)
				return utils.merge_arrays(web_dev_adjacent_config(bufnr), { "injected" })
			end,
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
