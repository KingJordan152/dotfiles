return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },

	-- TODO: Example :)

	opts = {
		keywords = {
			TODO = { icon = " ", color = "hint" },
			NOTE = { icon = " ", color = "info", alt = { "INFO" } },
		},
		highlight = {
			multiline = false,
		},
	},
}
