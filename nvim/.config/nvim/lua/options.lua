-- Editor Settings
vim.g.have_nerd_font = true -- States that I'm using a nerd font
vim.opt.termguicolors = true -- Enable 24-bit RGB color
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.showmode = false -- Prevents modes, like INSERT, from being shown (lualine takes care of this).
vim.opt.wrap = false -- Prevent line wrapping
vim.opt.scrolloff = 8 -- Scroll offset
vim.opt.mouse = "a" -- Enable mouse usage
vim.opt.undofile = true -- Save undo history
vim.opt.updatetime = 250 -- Decrease amount of time it takes for swapfile to be auto-saved
vim.opt.timeoutlen = 500 -- Decrease allotted time to perform an operation
vim.opt.inccommand = "split" -- Live-preview substitutions
vim.opt.signcolumn = "yes" -- Reserves extra space in gutter for diagnostic icons

-- Preserve indentation from previous line
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Screen splitting direction preference
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Perform case-insensitive searching UNLESS you write a capital letter
-- or prepend search with `\C`
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Enable Hybrid Line Numbers (relative except for current line)
vim.opt.relativenumber = true
vim.opt.number = true

-- Dynamically turn on/off relative line numbers when entering Insert Mode
local hybridLineNums = vim.api.nvim_create_augroup("hybridLineNums", { clear = true })
local excludeFiles = { "snacks_dashboard", "snacks_explorer", "lazy", "snacks_picker_list" }

local function isValidFile()
	for _, file in ipairs(excludeFiles) do
		if vim.bo.filetype == file then
			return false
		end
	end
	return true
end

vim.api.nvim_create_autocmd("InsertEnter", {
	desc = "Turn off Relative Line numbers when entering Insert Mode",
	group = hybridLineNums,
	callback = function()
		if isValidFile() then
			vim.opt.relativenumber = false
		end
	end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
	desc = "Turn on Relative Line numbers when leaving Insert Mode",
	group = hybridLineNums,
	callback = function()
		if isValidFile() then
			vim.opt.relativenumber = true
		end
	end,
})

-- Sync clipboard between OS and Neovim
-- Using `schedule` can increase startup time
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

-- Only highlight the current line number (specific color depends on colorscheme)
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

-- Briefly highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank()
	end,
	desc = "Briefly highlight yanked text",
})

-- Options that only become active once an LSP has been attached
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function()
		-- LSP-Related Keymaps
		vim.keymap.set("n", "gh", function()
			vim.lsp.buf.hover({
				border = "rounded",
				max_height = 25,
			})
		end, { desc = "View Hover Information" })
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
		vim.keymap.set({ "n", "v", "i" }, "<M-.>", vim.lsp.buf.code_action, { desc = "See Code Actions" })
		vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename Symbol" })

		-- Diagnostic Config
		vim.diagnostic.config({
			severity_sort = true,
			update_in_insert = true,
			float = { border = "rounded", source = "if_many" },
			underline = { severity = vim.diagnostic.severity.ERROR },
			signs = vim.g.have_nerd_font and {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰅚 ",
					[vim.diagnostic.severity.WARN] = "󰀪 ",
					[vim.diagnostic.severity.INFO] = "󰋽 ",
					[vim.diagnostic.severity.HINT] = "󰌶 ",
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

-- Global Keymaps
vim.keymap.set("n", "<leader>w", "<Cmd>w<CR>", { desc = "Save File" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<C-S-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-S-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-S-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-S-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
