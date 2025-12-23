-- Choose default colorscheme
if not vim.g.COLORSCHEME then
	vim.g.COLORSCHEME = "tokyonight-night"
end

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
vim.o.signcolumn = "yes:2" -- Prevents layout shift by reserving extra space for diagnostic icons and line numbers up to 999
vim.o.confirm = true -- Show dialog instead of erroring when trying to exit an unsaved file
vim.o.wrap = false -- Prevent line wrapping
vim.o.linebreak = true -- When `wrap` is true, causes full words to wrap rather than individual characters
vim.o.winborder = "rounded" -- Make all floating windows have the "rounded" border.
vim.o.foldlevelstart = 99 -- Opens all folds created by Treesitter immediately (VS Code behavior)
vim.opt.fillchars:append({ diff = "╱", lastline = ".", eob = " " }) -- Defines the characters to use for different special lines throughout Neovim

-- Indentation options
vim.o.autoindent = true -- Preserves previous indentation level when entering a newline
vim.o.smartindent = true -- Correctly indents next lines based on programmatic scope (i.e., C-like indentation) *only* when `indentexpr` isn't set
vim.o.breakindent = true -- Preserves indentation across wrapped lines

-- Screen splitting direction preference
vim.o.splitright = true
vim.o.splitbelow = true

-- Perform case-insensitive searching UNLESS you write a capital letter or prepend search with `\C`
vim.o.ignorecase = true
vim.o.smartcase = true

-- Enable "hybrid" line numbers (i.e., relative numbers except for current line)
vim.o.relativenumber = true
vim.o.number = true

-- Only highlight the current line number (specific color depends on colorscheme)
vim.o.cursorline = true
vim.o.cursorlineopt = "both"

-- Sync clipboard between OS and Neovim.
-- Using `schedule` can increase startup time.
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)
