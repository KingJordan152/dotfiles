local utils = require("utils")

local hybridLineNums = vim.api.nvim_create_augroup("hybridLineNums", { clear = true })

local excludeFiles = utils.Set({
	"snacks_dashboard",
	"snacks_explorer",
	"lazy",
	"mason",
	"snacks_picker_list",
	"snacks_terminal",
	"TelescopePrompt",
})

vim.api.nvim_create_autocmd("InsertEnter", {
	desc = "Disable relative line numbers when entering Insert mode",
	group = hybridLineNums,
	callback = function()
		if not excludeFiles[vim.bo.filetype] then
			vim.o.relativenumber = false
		end
	end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
	desc = "Enable relative line numbers when leaving Insert mode",
	group = hybridLineNums,
	callback = function()
		if not excludeFiles[vim.bo.filetype] then
			vim.o.relativenumber = true
		end
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	desc = "Briefly highlight yanked text",
	callback = function()
		vim.hl.on_yank()
	end,
})
