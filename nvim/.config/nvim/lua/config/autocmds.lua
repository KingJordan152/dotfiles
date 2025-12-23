local utils = require("core.utils")
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd("LspAttach", {
	desc = "Applies various keymaps and settings for LSPs",
	group = augroup("lsp_configs", { clear = true }),
	callback = function()
		local default_hover = vim.lsp.buf.hover
		local floating_window = {
			max_width = 100,
			max_height = 25,
		}

		-- Customize the LSP hover window
		---@diagnostic disable-next-line: duplicate-set-field
		vim.lsp.buf.hover = function()
			return default_hover({
				max_width = floating_window.max_width,
				max_height = floating_window.max_height,
			})
		end

		-- Neovim creates keymaps for most LSP actions automatically (see https://neovim.io/doc/user/lsp.html#_global-defaults), but these aren't.
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })

		-- TODO: Add when v0.12 is released
		-- Colorize document symbols if the LSP supports doing that.
		-- local client = vim.lsp.get_client_by_id(args.data.client_id)
		-- if client ~= nil and client:supports_method("textDocument/documentColor") then
		-- 	vim.lsp.document_color.enable(true, args.buf)
		-- end
	end,
})

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
