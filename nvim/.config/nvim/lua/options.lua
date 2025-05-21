-- Editor Settings
vim.g.have_nerd_font = true -- States that I'm using a nerd font
vim.o.termguicolors = true -- Enable 24-bit RGB color
vim.o.expandtab = true -- Use spaces instead of <Tab>
vim.o.tabstop = 2 -- Number of spaces to use for a <Tab>
vim.o.softtabstop = 2 -- Number of spaces to use for a <Tab> while performing insert actions
vim.o.shiftwidth = 2 -- Number of spaces to use for auto/manual indents
vim.o.showmode = false -- Prevents modes, like INSERT, from being shown (lualine takes care of this).
vim.o.wrap = false -- Prevent line wrapping
vim.o.scrolloff = 10 -- Scroll offset
vim.o.mouse = "a" -- Enable mouse usage
vim.o.undofile = true -- Save undo history
vim.o.updatetime = 250 -- Decrease amount of time it takes for swapfile to be auto-saved
vim.o.timeoutlen = 500 -- Decrease allotted time to perform an operation
vim.o.inccommand = "split" -- Live-preview substitutions
vim.o.signcolumn = "yes" -- Reserves extra space in gutter for diagnostic icons
vim.o.confirm = true -- Show dialog instead of erroring when trying to exit an unsaved file
vim.o.linebreak = true -- When line-wrapping is enabled, this causes full words to wrap instead of individual characters.

-- Options for persisting Neovim state across sessions (also used by `auto-session` plugin)
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Indentation options
vim.o.autoindent = true -- Preserves previous indentation level when entering a newline.
vim.o.smartindent = true -- Correctly indents next lines based on programmatic scope (i.e., C-like indentation)
vim.o.breakindent = true -- Wrapped lines are indented based on the initial line's indentation level
vim.o.breakindentopt = "list:-1" -- Properly indents markdown bullet points

-- Screen splitting direction preference
vim.o.splitright = true
vim.o.splitbelow = true

-- Perform case-insensitive searching UNLESS you write a capital letter
-- or prepend search with `\C`
vim.o.ignorecase = true
vim.o.smartcase = true

------ Hybrid Line Numbers (relative except for current line) ------
local hybridLineNums = vim.api.nvim_create_augroup("hybridLineNums", { clear = true })
local excludeFiles = {
	"snacks_dashboard",
	"snacks_explorer",
	"lazy",
	"mason",
	"snacks_picker_list",
	"snacks_terminal",
	"TelescopePrompt",
}

-- Determines whether the current buffer should show hybrid line numbers
local function isValidFile()
	return not vim.tbl_contains(excludeFiles, vim.bo.filetype)
end

vim.o.relativenumber = true
vim.o.number = true

vim.api.nvim_create_autocmd("InsertEnter", {
	desc = "Disengage Relative Line numbers when entering Insert Mode",
	group = hybridLineNums,
	callback = function()
		if isValidFile() then
			vim.o.relativenumber = false
		end
	end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
	desc = "Engage Relative Line numbers when leaving Insert Mode",
	group = hybridLineNums,
	callback = function()
		if isValidFile() then
			vim.o.relativenumber = true
		end
	end,
})

-- Only highlight the current line number (specific color depends on colorscheme)
vim.o.cursorline = true
vim.o.cursorlineopt = "number"

-- Sync clipboard between OS and Neovim
-- Using `schedule` can increase startup time
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- Briefly highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	desc = "Briefly highlight yanked text",
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Options that only become active once an LSP has been attached
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function()
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
		if vim.fn.has("mac") then
			vim.keymap.set({ "n", "x", "i" }, "<D-.>", vim.lsp.buf.code_action, { desc = "See Code Actions" })
		else
			vim.keymap.set({ "n", "x", "i" }, "<A-.>", vim.lsp.buf.code_action, { desc = "See Code Actions" })
		end
		vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename Symbol" })

		-- Diagnostic Config
		vim.diagnostic.config({
			severity_sort = true,
			update_in_insert = true,
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

-- Global Keymaps
vim.keymap.set("n", "<leader>w", "<Cmd>w<CR>", { desc = "Save File" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<C-S-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-S-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-S-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-S-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Move up and down across wrapped lines while allowing for count-based vertical movement (useful for Markdown files)
vim.api.nvim_set_keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })
