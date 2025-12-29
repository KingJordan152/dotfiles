return {
	"folke/todo-comments.nvim",
	dependencies = { "folke/snacks.nvim", "nvim-lua/plenary.nvim" },
	event = "VeryLazy",

	-- TODO: Example :)

	config = function()
		require("todo-comments").setup({
			keywords = {
				TODO = { icon = " ", color = "hint" },
				NOTE = { icon = " ", color = "info", alt = { "INFO" } },
			},
			highlight = {
				multiline = false,
			},
		})

		vim.keymap.set("n", "<leader>st", function()
			---@diagnostic disable-next-line: undefined-field
			Snacks.picker.todo_comments()
		end, { desc = "All Todo Comments" })

		vim.keymap.set("n", "<leader>sT", function()
			---@diagnostic disable-next-line: undefined-field
			Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
		end, { desc = "Todo/Fix/Fixme Comments" })
	end,
}
