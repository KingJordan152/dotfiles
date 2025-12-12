return {
	"rmagatti/auto-session",
	lazy = false,

	---@module "auto-session"
	---@type AutoSession.Config
	opts = {
		suppressed_dirs = { "~/", "/", "~/Downloads" },
		args_allow_single_directory = false, -- Allows Netrw/Oil to be opened using `nvim .`
		bypass_save_filetypes = { "netrw", "snacks_dashboard" },

		save_extra_data = function()
			local extra_data = {
				autoformatting = {
					global = vim.g.disable_autoformat,
					buffer = vim.b.disable_autoformat,
				},
			}

			return vim.fn.json_encode(extra_data)
		end,

		restore_extra_data = function(_, json_data)
			local extra_data = vim.fn.json_decode(json_data)

			vim.g.disable_autoformat = extra_data.autoformatting.global
			vim.b.disable_autoformat = extra_data.autoformatting.buffer
		end,
	},
	init = function()
		-- Specific option needed by AutoSession to properly save everything.
		vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
	end,
}
