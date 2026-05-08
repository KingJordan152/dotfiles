---@alias VariableData { [string]: { global: any, buffer: any[] } }

---Creates a table of all the global and buffer-local variables that the user wishes to save.
---This can then be used by `AutoSession` to preserve those variables after Neovim exits.
---@param variables string[]
---@return VariableData
local function save_variables(variables)
	---@type VariableData
	local variable_data = {}

	for _, variable in ipairs(variables) do
		variable_data[variable] = {
			global = vim.g[variable],
			buffer = {},
		}

		for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
			local bufname = vim.fn.bufname(bufnr) -- Since bufnr can change between sessions, bufname must be used
			variable_data[variable].buffer[bufname] = vim.b[bufnr][variable]
		end
	end

	return variable_data
end

---Takes a table created by `save_variables` and re-initializes its respective global and buffer-local variables.
---This can be used by `AutoSession` to restore those variables after opening Neovim and restoring a session.
---@param variables string[]
---@param data VariableData
local function restore_variables(variables, data)
	for _, variable in ipairs(variables) do
		-- Initialize default values if they don't exist
		data[variable] = data[variable] or {}
		data[variable].global = data[variable].global or nil
		data[variable].buffer = data[variable].buffer or {}

		vim.g[variable] = data[variable].global

		for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
			local bufname = vim.fn.bufname(bufnr) -- Since bufnr can change between sessions, bufname must be used
			vim.b[bufnr][variable] = data[variable].buffer[bufname]
		end
	end
end

return {
	"rmagatti/auto-session",
	lazy = false,

	---@module "auto-session"
	---@type AutoSession.Config
	opts = {
		suppressed_dirs = { "~/", "/", "~/Downloads" },
		args_allow_single_directory = false, -- Allows Netrw/Oil to be opened using `nvim .`
		bypass_save_filetypes = { "netrw", "snacks_dashboard", "dapui_console" },
		git_use_branch_name = true,
		git_auto_restore_on_branch_change = true,

		save_extra_data = function()
			local extra_data = save_variables({ "disable_autoformat" })

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

			restore_variables({ "disable_autoformat" }, extra_data)

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

							-- Create or load buffer to prevent breakpoints from resolving to line 1
							local bufnr = vim.fn.bufnr(buf_name, true)
							if vim.fn.bufloaded(bufnr) == 0 then
								vim.api.nvim_buf_call(bufnr, vim.cmd.edit)
							end

							breakpoints.set(opts, bufnr, line)
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
