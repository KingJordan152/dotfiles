---Formats the blame line to show the committer, relative commit date, and commit message.
---However, if the current line is blank, the blame line isn't shown. This ensures that
---only relevant, important code has an associated blame line.
---@param name string
---@param blame_info Gitsigns.BlameInfo | Gitsigns.CommitInfo
---@return [string,string][]
local function current_line_blame_formatter(name, blame_info)
	if blame_info.author == name then
		blame_info.author = "You"
	end

	local should_display = vim.fn.getline(".") ~= ""
	local date_time = require("gitsigns.util").get_relative_time(blame_info.author_time)
	local formatted_text = string.format("        %s, %s • %s", blame_info.author, date_time, blame_info.summary)

	return { { should_display and formatted_text or "", "GitSignsCurrentLineBlame" } }
end

-- [[
--    Adds git related signs to the gutter, as well as utilities for managing changes
-- ]]
return {
	"lewis6991/gitsigns.nvim",
	opts = {
		signs = {
			add = { text = "┃" },
			change = { text = "┃" },
			delete = { text = "", show_count = true },
			topdelete = { text = "┃", show_count = true },
			changedelete = { text = "~", show_count = true },
			untracked = { text = "┆" },
		},
		signs_staged = {
			add = { text = "┃" },
			change = { text = "┃" },
			delete = { text = "", show_count = true },
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
		current_line_blame_formatter = current_line_blame_formatter,
		current_line_blame_formatter_nc = "",
		attach_to_untracked = true,
		gh = true,

		-- Keymaps
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")

			-- Navigation
			vim.keymap.set("n", "]h", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]h", bang = true })
				else
					---@diagnostic disable-next-line: param-type-mismatch
					gitsigns.nav_hunk("next")
				end
			end, { buffer = bufnr, desc = "Go to Next Hunk" })

			vim.keymap.set("n", "[h", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[h", bang = true })
				else
					---@diagnostic disable-next-line: param-type-mismatch
					gitsigns.nav_hunk("prev")
				end
			end, { buffer = bufnr, desc = "Go to Previous Hunk" })

			-- stylua: ignore start
			-- Staging Keymaps
			vim.keymap.set("n", "<leader>ga%", gitsigns.stage_buffer, { desc = "Buffer" })
			vim.keymap.set("n", "<leader>gah", gitsigns.stage_hunk, { desc = "Hunk" })

			-- Blame Keymaps
			vim.keymap.set("n", "<leader>gB", function() gitsigns.blame_line({ full = true }) end, { desc = "Git Blame Line" })

			-- Hunk Keymaps
			vim.keymap.set("n", "<leader>ghd", gitsigns.diffthis, { buffer = bufnr, desc = "Git Hunk - Open Diff" })
			vim.keymap.set("n", "<leader>ghr", gitsigns.reset_hunk, { desc = "Git Hunk - Reset" })
			vim.keymap.set("n", "<leader>ghp", gitsigns.preview_hunk, { buffer = bufnr, desc = "Git Hunk - Preview" })
			vim.keymap.set( "n", "<leader>ghP", gitsigns.preview_hunk_inline, { buffer = bufnr, desc = "Git Hunk - Preview Inline" })
			-- stylua: ignore end

			-- Text object
			vim.keymap.set({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "inner Git hunk" })
		end,
	},
}
