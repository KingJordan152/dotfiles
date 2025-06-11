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
}
