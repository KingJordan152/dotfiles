-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

---@diagnostic disable-next-line: undefined-field
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.autocmds")
require("config.keymaps")
require("config.diagnostics")

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{ import = "plugins" },
		{ import = "plugins.colorschemes" },
		{ import = "plugins.completions" },
		{ import = "plugins.debugging" },
		{ import = "plugins.git" },
		{ import = "plugins.lsp" },
		{ import = "plugins.treesitter" },
		{ import = "plugins.writing" },
		{ import = "plugins.formatting" },
		{ import = "plugins.linting" },
		{ import = "plugins.qol" }, -- "Quality of Life" plugins
	},
	ui = {
		border = "rounded",
		title = "Lazy.nvim",
	},
	install = {
		missing = true,
		colorscheme = { "tokyonight-night" },
	},
	checker = {
		enabled = true,
		notify = false, -- Don't automatically notify plugin updates because the message can prevent Neovim from loading properly.
	},
	change_detection = {
		enabled = true,
		notify = false, -- Notifications are very annoying and often mess up UI when many updates are made.
	},
})
