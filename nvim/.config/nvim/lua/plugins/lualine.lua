-- Displays the formatters that will run against the current buffer.
--
-- If there aren't any configured formatters for the current buffer but it has an LSP,
-- `"LSP"` will be displayed instead.
--
-- If there aren't any formatters or LSPs configured for the current buffer, the component isn't displayed.
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

---Controls whether certain components are disabled for certain filetypes.
---@param files string[] List of filetypes that the component will be disabled for.
---@return boolean
local function disabled_filetypes(files)
	for _, file in ipairs(files) do
		if vim.bo.filetype == file then
			return false
		end
	end
	return true
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
		-- Extend `filename` component to include an icon that corresponds to the filetype.
		local filename_with_icon = require("lualine.components.filename"):extend()
		filename_with_icon.apply_icon = require("lualine.components.filetype").apply_icon
		filename_with_icon.icon_hl_cache = {}

		-- Allows usage of custom colors in different components.
		local colors = require("tokyonight.colors").setup()

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
						filename_with_icon,
						colored = true,
					},
					{
						"grapple",
						color = { fg = colors.blue },
						cond = function()
							return disabled_filetypes({ "TelescopePrompt" })
						end,
					},
				},
				lualine_x = {
					{
						"lsp_status",
						icon = { " ", color = { fg = colors.blue1 } },
						symbols = {
							done = "",
							separator = ", ",
						},
						ignore_lsp = { "cssmodules_ls", "css_variables", "eslint" },
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
					},
					{
						"diagnostics",
						sections = { "error", "warn", "hint" },
						symbols = { error = " ", warn = " ", hint = " ", info = " " },
						always_visible = true,
						cond = function()
							return disabled_filetypes({ "help", "TelescopePrompt", "gitcommit" })
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
