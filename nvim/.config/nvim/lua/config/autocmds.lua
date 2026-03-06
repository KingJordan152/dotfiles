local utils = require("core.utils")
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd("LspAttach", {
	desc = "Applies various keymaps and settings for LSPs",
	group = augroup("lsp_configs", { clear = true }),
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)

		-- Neovim creates keymaps for most LSP actions automatically (see https://neovim.io/doc/user/lsp.html#_global-defaults), but these aren't.
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = event.buf, desc = "Go to Definition" })
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = event.buf, desc = "Go to Declaration" })
		vim.keymap.set("n", "<leader>th", function()
			if client and client:supports_method("textDocument/inlayHint", event.buf) then
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			else
				vim.api.nvim_echo({ { "Inlay Hints aren't supported by this LSP", "Removed" } }, true, {})
			end
		end, { buffer = event.buf, desc = "Toggle Inlay Hints" })

		-- Although this keymap is automatically set by Neovim, it must be redefined in order
		-- to consistently overwrite the `keywordprg` keymap on session restoration.
		-- (see https://github.com/rmagatti/auto-session/issues/512#issuecomment-3999927434)
		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover({
				max_width = utils.floating_windows.max_width,
				max_height = utils.floating_windows.max_height,
			})
		end, { buffer = event.buf, desc = "Hover Documentation" })

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

autocmd("FileType", {
	desc = "Add unique keymaps to readonly files",
	group = augroup("readonly_keymaps", { clear = true }),
	pattern = "*",
	callback = function(args)
		if vim.bo[args.buf].readonly or not vim.bo[args.buf].modifiable then
			vim.keymap.set("n", "gq", "<cmd>q<cr>", {
				desc = "Quit the current window",
				buffer = true,
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
