---Runs the first available formatter given as an argument.
---You can use this function to run one formatter first *then* another one.
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

---Returns whether the current buffer will use `eslint_d` for formatting.
---@param bufnr integer The buffer that is going to be formatted.
---@return boolean
local function uses_eslint(bufnr)
	local conform = require("conform")

	for _, formatter in ipairs(conform.list_formatters_to_run(bufnr)) do
		if formatter.name == "eslint_d" then
			return true
		end
	end

	return false
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
			lua = { "stylua" },
			python = { "isort", "black" },
			go = { "goimports", "gofmt", stop_after_first = true },
			css = { "prettierd" },
			scss = { "prettierd" },
			javascript = { "prettierd", "eslint_d" },
			typescript = { "prettierd", "eslint_d" },
			typescriptreact = { "prettierd", "eslint_d" },
			markdown = function(bufnr)
				return { first(bufnr, "prettierd", "prettier"), "injected" }
			end,
		},

		default_format_opts = {
			lsp_format = "fallback",
		},

		--[[ 
     Only enabled when one of the running formatters is **NOT** "eslint_d".
     Since nearly all other formatters are far more performant when run synchronously, this should be
     the default option most of the time.
    ]]
		format_on_save = function(bufnr)
			local is_formatting_disabled = vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat

			if is_formatting_disabled or uses_eslint(bufnr) then
				return
			end
			return { lsp_format = "fallback", timeout_ms = 500 }
		end,

		--[[ 
     Only enabled when one of the running formatters **IS** "eslint_d". 
     This is because "eslint_d" might not be running in the background the moment it's requested, which would cause
     a timeout error if `format_on_save` were the default option.
    ]]
		format_after_save = function(bufnr)
			local is_formatting_disabled = vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat

			if is_formatting_disabled or not uses_eslint(bufnr) then
				return
			end
			return { lsp_format = "fallback" }
		end,

		formatters = {
			eslint_d = {
				env = {
					ESLINT_D_PPID = vim.fn.getpid(),
				},
			},
		},
	},
	init = function()
		-- TODO: Reassess how this should work
		-- local bufnr = vim.api.nvim_get_current_buf()
		-- vim.o.formatexpr = "v:lua.require'conform'.formatexpr("
		-- 	.. (uses_eslint(bufnr) and "{ async = true }" or "")
		-- 	.. ")"

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
			desc = "Disable Format on Save",
			bang = true,
		})

		vim.api.nvim_create_user_command("FormatEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
			vim.api.nvim_echo({ { "Enabled auto-formatting", "Added" } }, true, {})
		end, {
			desc = "Enable Format on Save",
		})
	end,
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" }, function(err)
					if not err then
						local mode = vim.api.nvim_get_mode().mode
						if vim.startswith(string.lower(mode), "v") then
							vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
						end
					end
				end)
			end,
			mode = "",
			desc = "Format code",
		},
		{
			"<leader>tf",
			function()
				if vim.g.disable_autoformat or vim.b.disable_autoformat then
					vim.cmd("FormatEnable")
				else
					vim.cmd("FormatDisable")
				end
			end,
			desc = "Toggle Auto-Formatting",
		},
		{
			"<leader>tF",
			function()
				if vim.g.disable_autoformat or vim.b.disable_autoformat then
					vim.cmd("FormatEnable")
				else
					vim.cmd("FormatDisable!")
				end
			end,
			desc = "Toggle Auto-Formatting for the Current Buffer",
		},
	},
}
