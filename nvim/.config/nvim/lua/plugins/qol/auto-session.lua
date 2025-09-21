return {
	"rmagatti/auto-session",
	lazy = false,

	---@module "auto-session"
	---@type AutoSession.Config
	opts = {
		suppressed_dirs = { "~/", "/", "~/Downloads" },
		args_allow_single_directory = false, -- Allows netrw to be opened using `nvim .`
		bypass_save_filetypes = { "netrw" },
	},
	init = function()
		-- Specific option needed by AutoSession to properly save everything.
		vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
	end,
}
