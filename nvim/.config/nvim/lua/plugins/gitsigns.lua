-- [[
--    Adds git related signs to the gutter, as well as utilities for managing changes
-- ]]
return {
	"lewis6991/gitsigns.nvim",
	opts = {
		signs = {
			add = { text = "┃" },
			change = { text = "┃" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		signs_staged = {
			add = { text = "┃" },
			change = { text = "┃" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
		current_line_blame_opts = {
			virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
			delay = 500,
		},
		current_line_blame_formatter = "        <author>, <author_time:%R> • <summary>",

		-- Keymaps
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")

			-- Navigation
			vim.keymap.set("n", "]c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gitsigns.nav_hunk("next")
				end
			end, { buffer = bufnr, desc = "Go to Next Hunk" })

			vim.keymap.set("n", "[c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gitsigns.nav_hunk("prev")
				end
			end, { buffer = bufnr, desc = "Go to Previous Hunk" })

			-- Actions
			vim.keymap.set("n", "<leader>hd", gitsigns.diffthis, { buffer = bufnr, desc = "Hunk - Diff (Gitsigns)" })
			vim.keymap.set(
				"n",
				"<leader>hp",
				gitsigns.preview_hunk,
				{ buffer = bufnr, desc = "Hunk - Preview (Gitsigns)" }
			)
			vim.keymap.set(
				"n",
				"<leader>hP",
				gitsigns.preview_hunk_inline,
				{ buffer = bufnr, desc = "Hunk - Preview Inline (Gitsigns)" }
			)
		end,
	},
}
