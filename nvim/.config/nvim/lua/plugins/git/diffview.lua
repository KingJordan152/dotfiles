---Hides the custom `lualine` winbar so that the custom `Diffview` winbars can appear.
---@param should_hide? boolean Can be used to optionally *show* the `lualine` winbar.
local function hide_winbar(should_hide)
	should_hide = should_hide == nil and true or should_hide
	require("lualine").hide({ place = { "winbar" }, unhide = not should_hide })
end

return {
	"sindrets/diffview.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = { "DiffviewOpen", "DiffviewFileHistory" },
	config = function()
		local autocmd_id

		require("diffview").setup({
			enhanced_diff_hl = true,
			view = {
				merge_tool = {
					layout = "diff3_mixed",
				},
			},
			hooks = {
				diff_buf_win_enter = function(_, winid)
					-- Turn off cursor line for diffview windows because of bg conflict.
					-- See https://github.com/neovim/neovim/issues/9800
					vim.wo[winid].culopt = "number"
				end,
				view_enter = function()
					local hide_winbar_timeout = 200

					---This `autocmd` prevents `Diffview`'s default winbars from being overwritten
					---by `lualine`'s custom one after switching back and forth between different Tmux
					---sessions.
					---
					---The `hide` function must be deferred, otherwise it either won't work or a race condition
					---between this `autocmd` and `lualine` will occur, breaking the winbar feature altogether.
					---
					---This will cause the winbar to briefly flicker. You can adjust the `hide_winbar_timeout`
					---value to change when the flicker occurs, however setting too low of a value (e.g., `100`)
					---can cause a race condition that will break the winbar.
					autocmd_id = vim.api.nvim_create_autocmd("FocusGained", {
						desc = "Ensure Diffview's winbars are shown after switching Tmux sessions",
						group = vim.api.nvim_create_augroup("diffview_tmux", { clear = true }),
						callback = function()
							vim.defer_fn(hide_winbar, hide_winbar_timeout)
						end,
					})

					hide_winbar()
				end,
				view_leave = function()
					hide_winbar(false)

					if autocmd_id ~= nil then
						vim.api.nvim_del_autocmd(autocmd_id)
						autocmd_id = nil
					end
				end,
			},
		})
	end,
}
