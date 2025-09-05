-- Editor Settings
vim.g.have_nerd_font = true -- States that I'm using a nerd font
vim.o.termguicolors = true -- Enable 24-bit RGB color
vim.o.expandtab = true -- Use spaces instead of <Tab>
vim.o.tabstop = 2 -- Number of spaces to use for a <Tab>
vim.o.softtabstop = 2 -- Number of spaces to use for a <Tab> while performing insert actions
vim.o.shiftwidth = 2 -- Number of spaces to use for auto/manual indents
vim.o.showmode = false -- Prevents modes, like INSERT, from being shown (lualine takes care of this).
vim.o.scrolloff = 10 -- Scroll offset
vim.o.mouse = "a" -- Enable mouse usage
vim.o.undofile = true -- Save undo history
vim.o.updatetime = 250 -- Decrease amount of time it takes for swapfile to be auto-saved
vim.o.timeoutlen = 500 -- Decrease allotted time to perform an operation
vim.o.inccommand = "split" -- Live-preview substitutions
vim.o.signcolumn = "yes" -- Reserves extra space in gutter for diagnostic icons
vim.o.confirm = true -- Show dialog instead of erroring when trying to exit an unsaved file
vim.o.wrap = false -- Prevent line wrapping

-- Options for persisting Neovim state across sessions (also used by `auto-session` plugin)
vim.o.sessionoptions = "blank,buffers,curdir,help,tabpages,winsize,winpos,terminal,localoptions"

-- Options for syntax-based folding via Treesitter.
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevelstart = 99 -- Opens all folds created by Treesitter immediately (VS Code behavior)
vim.o.foldnestmax = 5

-- Indentation options
-- vim.o.autoindent = true -- Preserves previous indentation level when entering a newline.
-- vim.o.smartindent = true -- Correctly indents next lines based on programmatic scope (i.e., C-like indentation)
vim.o.breakindent = true -- Preserves indentation across wrapped lines.

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
vim.o.cursorlineopt = "both"

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
		-- Neovim creates keymaps for most LSP actions automatically (see https://neovim.io/doc/user/lsp.html#_global-defaults)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })

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

-- LSP Configurations
vim.lsp.config["cssmodules_ls"] = {
	init_options = {
		camelCase = false,
	},
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.hover.contentFormat = { "plaintext" }
capabilities.textDocument.hover.dynamicRegistration = true

vim.lsp.config["cssls"] = {
	capabilities = capabilities,
}
