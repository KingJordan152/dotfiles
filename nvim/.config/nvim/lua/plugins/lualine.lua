-- [[
--    Renders an aesthetic statusbar towards the bottom of the screen containing
--    information such as my current mode, filename, LSP, etc.
-- ]]
return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			theme = "auto",
			component_separators = { left = "/", right = "/" },
			section_separators = { left = "", right = "" },
		},
		sections = {
			lualine_a = {
				{
					"mode",
					color = { gui = "bold" },
				},
			},
		},
	},
}
