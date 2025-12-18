local utils = require("core.utils")
local colors = require("tokyonight.colors").setup()

local winbar_disabled_filetypes = utils.Set({
	"oil",
	"fugitive",
})

---Determines the formatters that will run against the current buffer.
---
---If there aren't any configured formatters for the current buffer *but* it has an LSP,
---`"LSP"` will be returned.
---
---If there are neither formatters nor LSPs configured for the current buffer, the empty string will be returned.
---@return string
local function formatter_status()
	local conform = require("conform")
	local formatters_for_current_buffer, lsp_fallback = conform.list_formatters_to_run(0)
	local result = ""

	if next(formatters_for_current_buffer) == nil then
		if lsp_fallback then
			result = result .. "LSP"
		else
			result = ""
		end
	else
		for i, formatter in ipairs(formatters_for_current_buffer) do
			local separator = i == 1 and "" or ", "

			result = result .. separator .. formatter.name
		end
	end

	return result
end

---Determines whether the current window contains any splits.
---@return boolean
local function has_splits()
	local wins = vim.api.nvim_tabpage_list_wins(0)
	local split_count = 0

	for _, win in ipairs(wins) do
		local win_config = vim.api.nvim_win_get_config(win)

		-- Filter out all floating windows to get the true split count.
		if win_config.relative == "" then
			split_count = split_count + 1
		end
	end

	return split_count > 1
end

---Determines whether the winbar (`:h winbar`) should be displayed.
---
---The winbar is only shown under the following circumstances:
---  - the current window contains splits
---  - the current buffer has a name (i.e., not "No Name")
---  - the current buffer's filetype isn't explicitly disallowed (e.g., `Oil` buffers)
---@return boolean
local function should_display_winbar()
	local not_disabled_filetype = not winbar_disabled_filetypes[vim.bo.filetype]
	local not_no_name = vim.api.nvim_buf_get_name(0) ~= ""
	return not_no_name and not_disabled_filetype and has_splits()
end

-- [[
--    Renders an aesthetic statusbar towards the bottom of the screen containing
--    information such as my current mode, filename, LSP, etc.
-- ]]
return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
	config = function()
		-- A `filename` component that includes a filetype icon and becomes bold when the buffer has been modified.
		local custom_filename = require("lualine.components.filename"):extend()
		custom_filename.apply_icon = require("lualine.components.filetype").apply_icon
		custom_filename.icon_hl_cache = {} -- Ensures the filename component renders properly with the right colors.
		local highlight = require("lualine.highlight")

		---Initialize the filename component to have different colors when modified/saved.
		function custom_filename:init(options)
			custom_filename.super.init(self, options)
			self.status_colors = {
				saved = highlight.create_component_highlight_group({ gui = "" }, "filename_status_saved", self.options),
				modified = highlight.create_component_highlight_group(
					{ gui = "bold" },
					"filename_status_modified",
					self.options
				),
			}
			if self.options.color == nil then
				self.options.color = ""
			end
		end

		---Ensure the filename's color updates whenever the buffer is either modified or saved.
		function custom_filename:update_status()
			local data = custom_filename.super.update_status(self)
			data = highlight.component_format_highlight(
				vim.bo.modified and self.status_colors.modified or self.status_colors.saved
			) .. data
			return data
		end

		require("lualine").setup({
			options = {
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				globalstatus = true,
			},
			sections = {
				lualine_a = {
					{
						"mode",
						separator = { left = "", right = "" },
					},
				},
				lualine_b = {
					{
						"branch",
						draw_empty = true,
					},
					{
						"diff",
						symbols = { added = " ", modified = " ", removed = " " },
					},
				},
				lualine_c = {
					{
						custom_filename,
						colored = true,
						symbols = {
							modified = "●",
							readonly = "",
						},
						cond = function()
							return not should_display_winbar()
						end,
					},
					{
						"grapple",
						color = { fg = colors.blue },
						cond = function()
							return not utils.Set({ "TelescopePrompt" })[vim.bo.filetype]
						end,
					},
				},
				lualine_x = {
					{
						"lsp_status",
						icon = { "", color = { fg = colors.blue1 } },
						symbols = {
							done = "",
							separator = ", ",
						},
						ignore_lsp = {
							"cssmodules_ls",
							"css_variables",
							"eslint",
							"stylua",
							"tailwindcss",
							"emmet_language_server",
							"render-markdown",
						},
						on_click = function()
							Snacks.picker.lsp_config()
						end,
					},
					{
						formatter_status,
						icon = { "", color = { fg = colors.yellow } },
						-- If formatting is disabled, make the component red with a strikethrough.
						color = function()
							if vim.b.disable_autoformat or vim.g.disable_autoformat then
								return { fg = colors.red, gui = "strikethrough" }
							end
							return "lualine_c_normal"
						end,
						on_click = function(_, _, modifier)
							-- See `:h stl` for info on using `stridx`
							-- Can't use "shift" because Ghostty uses it as a global click modifier.
							local pressed_alt = vim.fn.stridx(modifier, "a") ~= -1
							vim.cmd("FormatToggle" .. (not pressed_alt and "!" or ""))
						end,
					},
					{
						"diagnostics",
						sections = { "error", "warn" },
						symbols = { error = " ", warn = " ", hint = " ", info = " " },
						always_visible = true,
						cond = function()
							return not utils.Set({ "help", "TelescopePrompt", "gitcommit" })[vim.bo.filetype]
						end,
					},
				},
				lualine_y = { "progress" },
				lualine_z = {
					{
						"location",
						separator = { left = "", right = "" },
					},
				},
			},
			winbar = {
				lualine_c = {
					{
						custom_filename,
						colored = true,
						symbols = {
							modified = "●",
							readonly = "",
						},
						cond = should_display_winbar,
						separator = { left = "", right = "" },
						color = "lualine_b_normal",
					},
				},
			},
			inactive_winbar = {
				lualine_c = {
					{
						custom_filename,
						colored = true,
						symbols = {
							modified = "●",
							readonly = "",
						},
						cond = should_display_winbar,
						separator = { left = "", right = "" },
						padding = 2,
					},
				},
			},
			extensions = {
				"quickfix",
				"lazy",
				"mason",
				"man",
				"oil",
			},
		})
	end,
}
