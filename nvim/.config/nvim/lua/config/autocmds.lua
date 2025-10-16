local utils = require("core.utils")

-- The following options are only applicable if an LSP has been attached.
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function()
		-- Neovim creates keymaps for most LSP actions automatically (see https://neovim.io/doc/user/lsp.html#_global-defaults), but these aren't.
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })

		-- Customize the LSP hover window
		local default_hover = vim.lsp.buf.hover
		---@diagnostic disable-next-line: duplicate-set-field
		vim.lsp.buf.hover = function()
			return default_hover({
				border = "rounded",
				max_height = 25,
				max_width = 100,
			})
		end

		-- Customize how diagnostics work
		vim.diagnostic.config({
			severity_sort = true,
			float = { border = "rounded", source = "if_many" },
			underline = { severity = vim.diagnostic.severity.ERROR },
			signs = vim.g.have_nerd_font and {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.INFO] = " ",
					[vim.diagnostic.severity.HINT] = " ",
				},
			} or {},
			virtual_text = {
				source = "if_many",
				spacing = 2,
				format = function(diagnostic)
					local diagnostic_message = {
						[vim.diagnostic.severity.ERROR] = diagnostic.message,
						[vim.diagnostic.severity.WARN] = diagnostic.message,
						[vim.diagnostic.severity.INFO] = diagnostic.message,
						[vim.diagnostic.severity.HINT] = diagnostic.message,
					}
					return diagnostic_message[diagnostic.severity]
				end,
			},
		})
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
})

local hybrid_line_numbers = vim.api.nvim_create_augroup("hybrid_line_numbers", { clear = true })

vim.api.nvim_create_autocmd("InsertEnter", {
	desc = "Disable relative line numbers when entering Insert mode",
	group = hybrid_line_numbers,
	callback = function()
		if not hybrid_line_exclude_files[vim.bo.filetype] then
			vim.o.relativenumber = false
		end
	end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
	desc = "Enable relative line numbers when leaving Insert mode",
	group = hybrid_line_numbers,
	callback = function()
		if not hybrid_line_exclude_files[vim.bo.filetype] then
			vim.o.relativenumber = true
		end
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	desc = "Briefly highlight yanked text",
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Credit: https://old.reddit.com/r/neovim/comments/1nlypjk/neovim_keeps_my_cursor_shape_hostage_in_tmux/nfc1fhl/
vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
	group = vim.api.nvim_create_augroup("restore_cursor_on_exit", { clear = true }),
	desc = "Restore cursor style upon exiting Neovim",
	callback = function()
		vim.opt.guicursor = ""
		vim.fn.chansend(vim.v.stderr, "\x1b[ q")
	end,
})
