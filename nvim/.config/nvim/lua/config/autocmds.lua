local utils = require("core.utils")
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local hybrid_line_exclude_files = utils.Set({
	"snacks_dashboard",
	"snacks_explorer",
	"lazy",
	"mason",
	"snacks_picker_list",
	"snacks_terminal",
	"TelescopePrompt",
	"help",
})

local hybrid_line_numbers = augroup("hybrid_line_numbers", { clear = true })

autocmd("InsertEnter", {
	desc = "Disable relative line numbers when entering Insert mode",
	group = hybrid_line_numbers,
	callback = function()
		if not hybrid_line_exclude_files[vim.bo.filetype] then
			vim.o.relativenumber = false
		end
	end,
})

autocmd("InsertLeave", {
	desc = "Enable relative line numbers when leaving Insert mode",
	group = hybrid_line_numbers,
	callback = function()
		if not hybrid_line_exclude_files[vim.bo.filetype] then
			vim.o.relativenumber = true
		end
	end,
})

autocmd("TextYankPost", {
	desc = "Briefly highlight yanked text",
	group = augroup("highlight_yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

local virtual_text_disabled_filetypes = utils.Set({
	"markdown",
	"text",
	"gitcommit",
})

autocmd("LspAttach", {
	desc = "Disable diagnostic virtual text for specific filetypes",
	group = augroup("disable_virtual_text", { clear = true }),
	callback = function(args)
		local buf_ft = vim.bo[args.buf].filetype

		if virtual_text_disabled_filetypes[buf_ft] then
			local ns = vim.lsp.diagnostic.get_namespace(args.data.client_id)

			vim.diagnostic.config({
				virtual_text = false,
			}, ns)
		end
	end,
})

autocmd("VimEnter", {
	desc = "Load chosen colorscheme",
	group = augroup("load_colorscheme", { clear = true }),
	callback = function()
		if vim.g.COLORSCHEME then
			vim.cmd.colorscheme(vim.g.COLORSCHEME)
		end
	end,
})
