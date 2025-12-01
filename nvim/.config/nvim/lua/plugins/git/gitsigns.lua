-- [[
--    Adds git related signs to the gutter, as well as utilities for managing changes
-- ]]
return {
	"lewis6991/gitsigns.nvim",
	opts = {
		signs = {
			add = { text = "┃" },
			change = { text = "┃" },
			delete = { text = "-", show_count = true },
			topdelete = { text = "┃", show_count = true },
			changedelete = { text = "~", show_count = true },
			untracked = { text = "┆" },
		},
		signs_staged = {
			add = { text = "┃" },
			change = { text = "┃" },
			delete = { text = "-", show_count = true },
			topdelete = { text = "┃", show_count = true },
			changedelete = { text = "~", show_count = true },
			untracked = { text = "┆" },
		},
		count_chars = {
			[1] = "¹",
			[2] = "²",
			[3] = "³",
			[4] = "⁴",
			[5] = "⁵",
			[6] = "⁶",
			[7] = "⁷",
			[8] = "⁸",
			[9] = "⁹",
			["+"] = "⁺",
		},
		current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol",
			virt_text_priority = 5000, -- MUST be higher than 4096 to appear after diagnostics (https://github.com/lewis6991/gitsigns.nvim/issues/605)
			delay = 500,
			use_focus = true,
		},
		current_line_blame_formatter = "        <author>, <author_time:%R> • <summary>",
		attach_to_untracked = true,
		gh = true,

		-- Keymaps
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")

			-- Navigation
			vim.keymap.set("n", "]c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					---@diagnostic disable-next-line: param-type-mismatch
					gitsigns.nav_hunk("next")
				end
			end, { buffer = bufnr, desc = "Go to Next Hunk" })

			vim.keymap.set("n", "[c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					---@diagnostic disable-next-line: param-type-mismatch
					gitsigns.nav_hunk("prev")
				end
			end, { buffer = bufnr, desc = "Go to Previous Hunk" })

			-- Actions
			vim.keymap.set("n", "<leader>ghd", gitsigns.diffthis, { buffer = bufnr, desc = "Git Hunk - Open Diff" })
			vim.keymap.set("n", "<leader>ghs", gitsigns.stage_hunk, { desc = "Git Hunk - Stage" })
			vim.keymap.set("n", "<leader>ghr", gitsigns.reset_hunk, { desc = "Git Hunk - Reset" })
			vim.keymap.set("n", "<leader>ghp", gitsigns.preview_hunk, { buffer = bufnr, desc = "Git Hunk - Preview" })
			vim.keymap.set(
				"n",
				"<leader>ghP",
				gitsigns.preview_hunk_inline,
				{ buffer = bufnr, desc = "Git Hunk - Preview Inline" }
			)
		end,
	},
}
