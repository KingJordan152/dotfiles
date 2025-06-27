local function formatter_status()
	local conform = require("conform")
	local formatters_for_current_buffer, lsp_fallback = conform.list_formatters_to_run(0)
	local icon = "%#LualineFormatterIcon# %#lualine_c_normal#"
	local result = icon

	-- TODO: Customize appearance based on whether formatter is active.
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

local function disable_on_filetypes(files)
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
	config = function()
		-- Extend `filename` component to include an icon that corresponds to the filetype.
		local filename_with_icon = require("lualine.components.filename"):extend()
		filename_with_icon.apply_icon = require("lualine.components.filetype").apply_icon
		filename_with_icon.icon_hl_cache = {}

		-- Initialize custom highlight groups.
		local colors = require("tokyonight.colors").setup()
		vim.api.nvim_set_hl(0, "LualineLspIcon", { fg = colors.blue1 })
		vim.api.nvim_set_hl(0, "LualineFormatterIcon", { fg = colors.yellow })

		require("lualine").setup({
			options = {
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				globalstatus = true,
			},
			sections = {
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
					{ filename_with_icon, colored = true },
					{
						filename_with_icon,
						colored = true,
					},
					{
						"grapple",
						color = { fg = colors.blue },
						cond = function()
							return disable_on_filetypes({ "TelescopePrompt" })
						end,
					},
				},
				lualine_x = {

					{
						"lsp_status",
						icon = "%#LualineLspIcon# %#lualine_c_normal#",
						symbols = {
							done = "",
							separator = ", ",
						},
						ignore_lsp = { "cssmodules_ls" },
					},
					{ formatter_status },
					"filetype",
				},
			},
			extensions = {
				"quickfix",
				"lazy",
				"mason",
				"man",
			},
		})
	end,
}
