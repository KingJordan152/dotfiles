return {
	"mrjones2014/smart-splits.nvim",
	lazy = false, -- Needs to work immediately with Tmux
	config = function()
		local smart_splits = require("smart-splits")

		---@diagnostic disable-next-line: missing-fields
		smart_splits.setup({
			default_amount = 2,
			cursor_follows_swapped_bufs = true,
			float_win_behavior = "mux", -- Ensures floating windows are properly focused when leaving/entering a split
			at_edge = "stop",
		})

		-- stylua: ignore start

		-- Moving between splits
		vim.keymap.set("n", "<C-h>", smart_splits.move_cursor_left, { desc = "Go to the left window" })
		vim.keymap.set("n", "<C-j>", smart_splits.move_cursor_down, { desc = "Go to the lower window" })
		vim.keymap.set("n", "<C-k>", smart_splits.move_cursor_up, { desc = "Go to the upper window" })
		vim.keymap.set("n", "<C-l>", smart_splits.move_cursor_right, { desc = "Go to the right window" })
		vim.keymap.set("n", "<C-\\>", smart_splits.move_cursor_previous, { desc = "Go to the previous window" })

		-- Resizing splits
		vim.keymap.set("n", "<C-M-h>", smart_splits.resize_left, { desc = "Resize split left" })
		vim.keymap.set("n", "<C-M-j>", smart_splits.resize_down, { desc = "Resize split down" })
		vim.keymap.set("n", "<C-M-k>", smart_splits.resize_up, { desc = "Resize split up" })
		vim.keymap.set("n", "<C-M-l>", smart_splits.resize_right, { desc = "Resize split right" })

		-- Swapping buffers between windows
		vim.keymap.set( "n", "<C-S-H>", smart_splits.swap_buf_left, { desc = "Swap current window with the left window" })
		vim.keymap.set( "n", "<C-S-J>", smart_splits.swap_buf_down, { desc = "Swap current window with the lower window" })
		vim.keymap.set("n", "<C-S-K>", smart_splits.swap_buf_up, { desc = "Swap current window with the upper window" })
		vim.keymap.set( "n", "<C-S-L>", smart_splits.swap_buf_right, { desc = "Swap current window with the right window" })

		-- stylua: ignore start
	end,
}
