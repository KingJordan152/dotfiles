local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local hybrid_line_numbers = augroup("hybrid_line_numbers", { clear = true })

autocmd("InsertEnter", {
	desc = "Disable relative line numbers when entering Insert mode",
	group = hybrid_line_numbers,
	callback = function(args)
		if vim.bo[args.buf].modifiable then
			vim.o.relativenumber = false
		end
	end,
})

autocmd("InsertLeave", {
	desc = "Enable relative line numbers when leaving Insert mode",
	group = hybrid_line_numbers,
	callback = function(args)
		if vim.bo[args.buf].modifiable then
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

autocmd("FileType", {
	desc = "Add unique keymaps to readonly files",
	group = augroup("readonly_keymaps", { clear = true }),
	pattern = "*",
	callback = function(args)
		local bufnr = args.buf

		if vim.bo[bufnr].readonly or not vim.bo[bufnr].modifiable then
			vim.keymap.set("n", "gq", "<cmd>q<cr>", {
				desc = "Quit the current window",
				buf = bufnr,
			})
		end
	end,
})

autocmd("VimResized", {
	desc = "Automatically resize splits when the terminal's window is resized",
	group = augroup("equalize_splits", { clear = true }),
	callback = function()
		local current_tab = vim.api.nvim_get_current_tabpage()

		vim.cmd("tabdo wincmd =")
		vim.api.nvim_set_current_tabpage(current_tab)
	end,
})
