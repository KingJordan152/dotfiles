vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.o.termguicolors = true -- Enable 24-bit RGB color
vim.o.expandtab = true -- Use spaces instead of <Tab>
vim.o.tabstop = 2 -- Number of spaces to use for a <Tab>
vim.o.softtabstop = 2 -- Number of spaces to use for a <Tab> while performing insert actions
vim.o.shiftwidth = 2 -- Number of spaces to use for auto/manual indents
vim.o.shiftround = true -- Round indent to multiple of `shiftwidth`
vim.o.showmode = false -- Prevents modes, like INSERT, from being shown (lualine takes care of this).
vim.o.scrolloff = 10 -- Scroll offset
vim.o.sidescrolloff = 10 -- Horizontal scroll offset
vim.o.mouse = "a" -- Enable mouse usage
vim.o.undofile = true -- Save undo history
vim.o.updatetime = 250 -- Decrease amount of time it takes for swapfile to be auto-saved
vim.o.timeoutlen = 500 -- Decrease allotted time to perform an operation
vim.o.inccommand = "split" -- Live-preview substitutions
vim.o.signcolumn = "yes:2" -- Prevents layout shift by reserving extra space for diagnostic icons and line numbers up to 999
vim.o.confirm = true -- Show dialog instead of erroring when trying to exit an unsaved file
vim.o.wrap = false -- Prevent line wrapping
vim.o.linebreak = true -- When `wrap` is true, causes full words to wrap rather than individual characters
vim.o.winborder = "rounded" -- Make all floating windows have a "rounded" border
vim.o.pumborder = vim.o.winborder -- Make native popup menus (e.g., right-click menus) follow the `winborder` option
vim.o.foldlevelstart = 99 -- Opens all folds created by Treesitter immediately (VS Code behavior)
vim.o.swapfile = false -- Disable swapfile creation
vim.o.spelllang = "en_us" -- Set the language `spell` uses to U.S. English
vim.o.spelloptions = "camel" -- Spellcheck the individual parts of a camelCased word
vim.o.autoindent = true -- Preserves previous indentation level when entering a newline
vim.o.smartindent = true -- Correctly indents next lines based on programmatic scope (i.e., C-like indentation) *only* when `indentexpr` isn't set
vim.o.breakindent = true -- Preserves indentation across wrapped lines
vim.o.splitright = true -- Ensure vertical splits are split to the **right**
vim.o.splitbelow = true -- Ensure horizontal splits are split to the **bottom**
vim.o.ignorecase = true -- Ignore case when performing a search (`/`)
vim.o.smartcase = true -- Disregard `ignorecase` setting if a search pattern contains a capital letter or search is prepended with `\C`
vim.g.markdown_recommended_style = 0 -- Disable all preset Markdown styles (they overwrite the ones set here)

-- Enable "hybrid" line numbers (i.e., relative numbers except for current line)
vim.o.number = true
vim.o.relativenumber = true

-- Highlight current line AND line number
vim.o.cursorline = true
vim.o.cursorlineopt = "both"

-- Special icons used for various UI elements
vim.opt.fillchars:append({
  diff = "╱",
  lastline = ".",
  eob = " ",
})

-- Special icons used for various whitespace (non-visible) characters
vim.opt.listchars:append({
  tab = "» ",
  trail = "·",
  space = "·",
  nbsp = "␣",
  eol = "󰌑",
})

-- Sync clipboard between OS and Neovim.
-- Using `schedule` can increase startup time.
vim.schedule(function() vim.o.clipboard = "unnamedplus" end)

-- Experimental; replaces builtin message and cmdline presentation layer
require("vim._core.ui2").enable({
  enable = true,
  msg = {
    targets = {
      progress = "msg",
    },
  },
})

-- Customize which filetypes are assigned to different extensions/filenames
vim.filetype.add({
  extension = {
    ["code-snippets"] = "json",
  },
  pattern = {
    ["[jt]sconfig.*%.json"] = "jsonc", -- TS/JS config files
    [".*/%.vscode/.*%.json"] = "jsonc", -- All special VS Code files
    [".*/%.zed/.*%.json"] = "jsonc", -- All special Zed files
  },
})
