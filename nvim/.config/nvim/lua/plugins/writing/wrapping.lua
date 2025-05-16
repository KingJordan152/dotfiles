return {
	"andrewferrier/wrapping.nvim",
	config = function()
		require("wrapping").setup({
			create_keymaps = false,
		})
	end,
}
