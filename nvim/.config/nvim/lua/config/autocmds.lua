local utils = require("core.utils")

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
-- FIX: Cursor remains blinking on "VimSuspend" and doesn't change
vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
	group = vim.api.nvim_create_augroup("restore_cursor_on_exit", { clear = true }),
	desc = "Restore cursor style upon exiting Neovim",
	callback = function()
		vim.o.guicursor = ""
		vim.fn.chansend(vim.v.stderr, "\x1b[ q")
	end,
})
