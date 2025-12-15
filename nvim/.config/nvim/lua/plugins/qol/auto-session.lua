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
				autoformat = {
					global = vim.g.disable_autoformat,
					buffer = {},
				},
			}

			-- Save all buffer-scoped auto-formatting states based on buffer ID
			for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
				extra_data.autoformat.buffer[bufnr] = vim.b[bufnr].disable_autoformat
			end

			-- Save all breakpoints (code from https://github.com/rmagatti/auto-session?tab=readme-ov-file#%EF%B8%8F-saving-custom-data)
			local ok, breakpoints = pcall(require, "dap.breakpoints")
			if ok and breakpoints then
				local bps = {}
				local breakpoints_by_buf = breakpoints.get()
				for buf, buf_bps in pairs(breakpoints_by_buf) do
					bps[vim.api.nvim_buf_get_name(buf)] = buf_bps
				end
				if not vim.tbl_isempty(bps) then
					extra_data.breakpoints = bps
				end
			end

			return vim.fn.json_encode(extra_data)
		end,

		restore_extra_data = function(_, json_data)
			local extra_data = vim.fn.json_decode(json_data)

			vim.g.disable_autoformat = extra_data.autoformat.global

			-- Restore all buffer-scoped auto-formatting states based on buffer ID
			for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
				vim.b[bufnr].disable_autoformat = extra_data.autoformat.buffer[bufnr]
			end

			-- Restore all breakpoints (code from https://github.com/rmagatti/auto-session?tab=readme-ov-file#%EF%B8%8F-saving-custom-data)
			if extra_data.breakpoints then
				local ok, breakpoints = pcall(require, "dap.breakpoints")

				if ok and breakpoints then
					for buf_name, buf_bps in pairs(extra_data.breakpoints) do
						for _, bp in pairs(buf_bps) do
							local line = bp.line
							local opts = {
								condition = bp.condition,
								log_message = bp.logMessage,
								hit_condition = bp.hitCondition,
							}
							breakpoints.set(opts, vim.fn.bufnr(buf_name), line)
						end
					end
				end
			end
		end,
	},
	init = function()
		-- Specific option needed by AutoSession to properly save everything.
		vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
	end,
}
